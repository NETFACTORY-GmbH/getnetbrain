# Installation

Die Installation besteht aus einem Befehl auf dem Server und einer kleinen Anpassung danach. Rechnen Sie mit rund zehn Minuten auf der Kommandozeile; die Einrichtung im Browser folgt im nächsten Kapitel.

## Installieren

Melden Sie sich auf dem Server an und führen Sie aus:

```
curl -fsSL https://getnetbrain.netfactory.de/install.sh | sudo bash
```

Das Skript prüft Docker, bezieht das NETbrain-Image (öffentlich, ohne Anmeldung), legt die Installation unter `/opt/netbrain` an und startet sie. Es wartet, bis NETbrain antwortet — beim ersten Mal bis zu zwei Minuten. Auf einem systemd-Server richtet es zusätzlich den lokalen Update-Helfer ein, über den Administratoren später Updates im Browser auslösen.

Am Ende stehen das **Einrichtungs-Token** und die Adresse, unter der es weitergeht.

### Eine bestimmte Version installieren

Die Version steckt im Link:

```
curl -fsSL https://getnetbrain.netfactory.de/install.sh@0.4.16 | sudo bash
```

### Proxy auf einem anderen Rechner

Steht Ihr Reverse-Proxy nicht auf demselben Server, muss NETbrain auf allen Netzwerkschnittstellen lauschen. Dann gehört zwingend eine Firewallregel dazu, die Port 4321 auf die Adresse des Proxys beschränkt (siehe [Reverse-Proxy, Punkt 6](reverse-proxy.html#firewall)):

```
curl -fsSL https://getnetbrain.netfactory.de/install.sh | sudo NETBRAIN_BIND=0.0.0.0 bash
```

Ist Port 4321 belegt, wählen Sie einen anderen; der Proxy leitet dann dorthin weiter:

```
curl -fsSL https://getnetbrain.netfactory.de/install.sh | sudo NETBRAIN_PORT=4330 bash
```

Die Variablen stehen dabei **hinter** `sudo`: Davor gesetzt, verwirft `sudo` sie.

## DNS-Name und Proxy-Kette eintragen

Dieser Schritt gehört zu jeder Installation. Der Installer erlaubt zunächst nur `localhost` und `127.0.0.1`. Ruft Ihr Proxy NETbrain unter dem DNS-Namen auf, antwortet NETbrain mit **421** — das sieht wie ein Defekt aus und ist eine Zeile.

```
sudo nano /opt/netbrain/netbrain-compose.yml
```

In der Zeile `NETBRAIN_ALLOWED_HOSTS` den Namen ergänzen und im selben `environment:`-Block die Zahl der Proxys vor NETbrain eintragen:

```
      NETBRAIN_ALLOWED_HOSTS: "localhost,127.0.0.1,netbrain.ihre-firma.de"
      NETBRAIN_TRUSTED_PROXY_HOPS: "1"
```

Steht ein Proxy davor, gehört dort `1` hin, nicht `0`. Sonst sieht die Anmeldedrossel alle Besucher als die Adresse des Proxys, und ein einziger Fehlversuch sperrt alle gemeinsam aus. Die Zahl können Sie alternativ im Einrichtungsassistenten eintragen — aber nur an einer der beiden Stellen; was in der Datei steht, hat Vorrang.

Danach die Änderung übernehmen und das neue Token abrufen:

```
cd /opt/netbrain
sudo ./install.sh
sudo ./install.sh token
```

Die Compose-Datei gehört Ihnen: Kein Update überschreibt sie.

## Weiter im Browser

Rufen Sie `https://netbrain.ihre-firma.de` auf. Jeder Aufruf landet auf der Einrichtung — weiter mit [Einrichtung im Browser](einrichtung.html).

## Befehle für später

Alle im Verzeichnis `/opt/netbrain`:

| Befehl | Wirkung |
|---|---|
| `sudo ./install.sh status` | Läuft NETbrain, ist es bereit, welche Version |
| `sudo ./install.sh token` | Einrichtungs-Token anzeigen, solange nicht eingerichtet |
| `sudo ./install.sh logs` | Protokoll mitlesen, `Strg+C` beendet |
| `sudo ./install.sh stop` / `start` | Anhalten und wieder starten |
| `sudo ./install.sh` | Änderungen an der Compose-Datei übernehmen, Version aktualisieren |

Einen Löschbefehl hat der Installer bewusst nicht.

> [!HINWEIS] Das Token gilt nur bis zum nächsten Neustart
> Nach jedem Neustart des Containers steht ein neues Token im Protokoll. Ein „falsches“ Token ist fast immer ein altes — `sudo ./install.sh token` zeigt das aktuelle.
