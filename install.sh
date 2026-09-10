#!/usr/bin/env bash
#
# NETbrain installieren — ein Link, kein Parameter.
#
#   curl -fsSL https://getnetbrain.netfactory.de/install.sh | sudo bash
#   curl -fsSL https://getnetbrain.netfactory.de/install.sh@0.4.1 | sudo bash
#
# Die Version steckt im Namen des Links; `install.sh` ohne Zusatz ist die
# neueste. Beide Dateien haben denselben Inhalt und entstehen beim Paketbau
# (`paket-bauen.sh --link-ziel`), der die Version und — für einen
# kundeneigenen Link — Konto und Pull-Token einsetzt. Ist nichts eingesetzt,
# gilt `latest` und die Anmeldedaten werden erfragt.
#
# Nachgeladen wird nichts: `install.sh` und `update-agent.sh` kommen mit
# `docker cp` aus dem bezogenen Image, damit Anwendung und Installer je Version
# aus demselben Artefakt stammen und dieser Link nie veraltet.
#
# Selten gebraucht: erstes Argument setzt die Version, `--verzeichnis PFAD`
# (Vorgabe /opt/netbrain), `--image REF`, `--ja` für keine Rückfragen.
# Für Automatisierung: NETBRAIN_KONTO, NETBRAIN_TOKEN.
#
# Danach führt `install.sh` im Zielverzeichnis (status, token, logs, update).
set -euo pipefail

# Vom Paketbau ersetzt. Unersetzt bleiben die Marken stehen und gelten als leer.
VERSION=""
KONTO="NetBrain-Regestry"
TOKEN=""
IMAGE_BASIS="ghcr.io/netfactory-gmbh/netbrain"
[[ "$VERSION" == __*__ ]] && VERSION=""
[[ "$KONTO"   == __*__ ]] && KONTO=""
[[ "$TOKEN"   == __*__ ]] && TOKEN=""
KONTO="${NETBRAIN_KONTO:-$KONTO}"
TOKEN="${NETBRAIN_TOKEN:-$TOKEN}"

IMAGE=""
VERZEICHNIS="/opt/netbrain"
NACHFRAGEN=1

rot()   { printf '\033[31m%s\033[0m\n' "$*" >&2; }
gelb()  { printf '\033[33m%s\033[0m\n' "$*" >&2; }
gruen() { printf '\033[32m%s\033[0m\n' "$*"; }
info()  { printf '%s\n' "$*"; }
abbruch() { rot "FEHLER: $*"; exit 1; }

# Heißt die heruntergeladene Datei `install.sh@0.4.1`, ist das die Version:
# Der Link trägt sie, also muss sie niemand abtippen.
if [[ "${0##*@}" != "$0" && "${0##*@}" =~ ^[0-9] ]]; then VERSION="${0##*@}"; fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --verzeichnis) VERZEICHNIS="${2:-}"; shift 2 ;;
    --image)       IMAGE="${2:-}"; shift 2 ;;
    --ja)          NACHFRAGEN=0; shift ;;
    --*) abbruch "Unbekannte Option »$1«. Bekannt: --verzeichnis, --image, --ja" ;;
    *)   VERSION="$1"; shift ;;
  esac
done

[[ "$(id -u)" == "0" ]] || abbruch "Bitte mit sudo aufrufen."
[[ -n "$IMAGE" ]] || IMAGE="$IMAGE_BASIS:${VERSION:-latest}"
REGISTRY="${IMAGE%%/*}"
[[ "$IMAGE" == */*:* && ( "$REGISTRY" == *.* || "$REGISTRY" == *:* ) ]] \
  || abbruch "»$IMAGE« nennt keine Registry mit Hostnamen und Versions-Tag."

# Rückfragen lesen vom Terminal, nicht von stdin: Bei `curl … | sudo bash`
# steht auf stdin dieses Skript.
frage() {
  local text="$1" antwort
  (( NACHFRAGEN )) || return 0
  [[ -r /dev/tty ]] || abbruch "$text — kein Terminal für die Rückfrage. Mit --ja zustimmen."
  read -r -p "$text [ja/NEIN] " antwort < /dev/tty
  [[ "$antwort" == "ja" ]]
}

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------
installiere_docker() {
  rot "Docker ist nicht installiert."
  info "Das offizielle Skript von Docker (https://get.docker.com) richtet Paketquelle,"
  info "Engine und Compose ein und ändert dabei die Paketquellen dieses Servers. Wer das"
  info "selbst tun will, bricht ab und folgt https://docs.docker.com/engine/install/."
  frage "Docker jetzt über get.docker.com installieren?" \
    || abbruch "Ohne Docker läuft NETbrain nicht. Abgebrochen, nichts verändert."
  command -v curl >/dev/null 2>&1 || abbruch "curl fehlt: apt-get install -y curl"
  local skript; skript="$(mktemp)"
  curl -fsSL https://get.docker.com -o "$skript" || abbruch "get.docker.com nicht erreichbar."
  sh "$skript" || abbruch "Die Docker-Installation ist fehlgeschlagen."
  rm -f "$skript"
  systemctl enable --now docker >/dev/null 2>&1 || true
}

command -v docker >/dev/null 2>&1 || installiere_docker
docker info >/dev/null 2>&1 || abbruch "Docker läuft nicht: systemctl start docker"
docker compose version >/dev/null 2>&1 || abbruch \
  "Docker Compose (v2) fehlt: apt-get install -y docker-compose-plugin"

# ---------------------------------------------------------------------------
# Image beziehen. Erst versuchen, dann fragen: Eine bestehende Anmeldung und
# ein eingesetztes Token sollen keine Eingabe kosten.
# ---------------------------------------------------------------------------
anmelden() {
  local konto="$1" token="$2"
  printf '%s' "$token" | docker login "$REGISTRY" -u "$konto" --password-stdin >/dev/null \
    || return 1
  gruen "An $REGISTRY angemeldet."
}

beziehe() { docker pull "$IMAGE" >/dev/null 2>&1; }

info "Beziehe $IMAGE …"
if [[ -n "$TOKEN" && -n "$KONTO" ]]; then
  anmelden "$KONTO" "${TOKEN//[$'\r\n']/}" || abbruch \
    "Anmeldung an $REGISTRY fehlgeschlagen. Der Link enthält ein ungültiges oder
  abgelaufenes Zugangstoken — beim Herausgeber einen neuen anfordern."
  unset TOKEN
fi
if ! beziehe; then
  [[ -r /dev/tty ]] || abbruch \
    "Das Image konnte nicht bezogen werden und es gibt kein Terminal für die Anmeldung.
  Konto und Token über NETBRAIN_KONTO und NETBRAIN_TOKEN übergeben."
  gelb "Für $IMAGE ist eine Anmeldung nötig. Konto und Pull-Token kommen vom Herausgeber."
  read -r -p "Konto: " KONTO < /dev/tty
  read -r -s -p "Pull-Token (bleibt unsichtbar): " TOKEN < /dev/tty; printf '\n'
  [[ -n "$KONTO" && -n "$TOKEN" ]] || abbruch "Konto oder Token leer."
  anmelden "$KONTO" "${TOKEN//[$'\r\n']/}" || abbruch "Anmeldung fehlgeschlagen."
  unset TOKEN
  beziehe || abbruch \
    "Das Image konnte nicht bezogen werden. Version »${VERSION:-latest}« prüfen und ob das
  Token Leserechte auf die Pakete hat."
fi

# ---------------------------------------------------------------------------
# Installer aus dem Image holen
# ---------------------------------------------------------------------------
mkdir -p "$VERZEICHNIS"
BEHAELTER="netbrain-auspacken-$$"
docker create --name "$BEHAELTER" "$IMAGE" >/dev/null
aufraeumen() { docker rm -f "$BEHAELTER" >/dev/null 2>&1 || true; }
trap aufraeumen EXIT
entpacke() { docker cp "$BEHAELTER:/app/auslieferung/$1" "$VERZEICHNIS/$1" 2>/dev/null; }
entpacke install.sh || abbruch \
  "Dieses Image bringt keinen Installer mit (Fassungen vor 0.4.1). Für diese Version das
  Auslieferungspaket verwenden — darin liegt install.sh."
entpacke update-agent.sh || gelb "Hinweis: update-agent.sh fehlt im Image; Updates über /admin bleiben aus."
aufraeumen; trap - EXIT
chmod +x "$VERZEICHNIS"/*.sh

# ---------------------------------------------------------------------------
# Installieren. Ab hier führt install.sh und bezieht dasselbe Image.
# ---------------------------------------------------------------------------
cd "$VERZEICHNIS"
NETBRAIN_IMAGE="$IMAGE" bash ./install.sh installieren

cat <<ENDE

Weiter im Browser: Einrichtungs-Token von oben eintragen, ersten Administrator
anlegen, Lizenzdatei einfügen.

Spätere Befehle in $VERZEICHNIS:
  sudo ./install.sh status | token | logs | stop | start
ENDE
