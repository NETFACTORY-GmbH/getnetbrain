# Kubernetes und App-Plattformen

Diese Seite richtet sich an Betreiber von Kubernetes- oder App-Plattformen. Gemeint ist der Fall, dass ein Kunde NETbrain selbst startet und niemand dabei etwas von Hand einrichtet. Installer und Update-Helfer werden hier nicht gebraucht.

## Kachel im Katalog

| | |
|---|---|
| Name | NETbrain |
| Beschreibung | Wissensplattform mit Firmenwissen, privatem Vault und KI-Chat |
| Symbol, einfarbig | [netbrain-icon-mono.svg](https://getnetbrain.netfactory.de/bilder/netbrain-icon-mono.svg) — `fill="currentColor"`, färbt sich nach der Schriftfarbe der Kachel |
| Symbol, farbig | [netbrain-icon.svg](https://getnetbrain.netfactory.de/bilder/netbrain-icon.svg) |
| Schriftzug | [netbrain-logo.svg](https://getnetbrain.netfactory.de/bilder/netbrain-logo.svg) |

Bitte das Signet verwenden, kein allgemeines Gehirn- oder KI-Symbol.

## NETbrain

| | |
|---|---|
| Image | `ghcr.io/netfactory-gmbh/netbrain:<version>` (öffentlich) |
| Port | HTTP auf **4321**, TLS am Ingress |
| Liveness | `/api/live` — antwortet, solange der Prozess lebt |
| Readiness | `/api/ready` — Ablage beschreibbar, keine Migration im Gange |
| Benutzer | `10001`, beide Volumes müssen ihm gehören |
| Repliken | genau **1**, kein Autoscaling |

### Umgebungsvariablen

| Variable | Wert | Ohne sie |
|---|---|---|
| `NETBRAIN_ALLOWED_HOSTS` | der vergebene Hostname (empfohlen) | Jeder Hostname wird angenommen, bis der Assistent den Namen speichert |
| `NETBRAIN_SETUP_TOKEN` | Zufallswert, mindestens 24 Zeichen | Das Token steht nur im Pod-Log; der Kunde kommt nicht an seine Einrichtung |
| `NETBRAIN_SECRET_KEY` | Zufallswert, `openssl rand -base64 32` | Der Kunde kann keine KI-Zugänge hinterlegen |
| `NETBRAIN_TRUSTED_PROXY_HOPS` | Zahl der Proxys davor, meist `1` | Anmeldedrossel und Protokoll sehen die Proxy-Adresse |

`NETBRAIN_SETUP_TOKEN` und `NETBRAIN_SECRET_KEY` gehören in den Geheimnisspeicher der Plattform und müssen **über Neustarts gleich bleiben**. Ein neuer `NETBRAIN_SECRET_KEY` macht hinterlegte KI-Schlüssel unlesbar.

Zeigen Sie das Einrichtungs-Token auf der Kachel an, so wie das Startpasswort anderer Anwendungen. Der Kunde braucht es genau einmal.

### Probes

`/api/live` und `/api/ready` antworten unabhängig vom Host-Header, von Einrichtung und Lizenz. Das ist Absicht: Eine noch nicht eingerichtete oder gesperrte Installation muss weiterlaufen und ihre Einrichtungs- bzw. Lizenzseite ausliefern.

> [!WICHTIG] `/api/health` nicht als Probe verwenden
> `/api/health` meldet **503**, solange die Lizenz fehlt oder abgelaufen ist. Als Liveness-Probe führt das zu einer Neustart-Schleife, als Readiness-Probe nimmt es die Installation aus dem Verkehr — der Kunde erreicht dann nicht einmal die Seite, auf der er die Lizenz einträgt. `/api/health` eignet sich für die Überwachung, nicht für Probes.

```
livenessProbe:
  httpGet: { path: /api/live, port: 4321 }
  periodSeconds: 30
readinessProbe:
  httpGet: { path: /api/ready, port: 4321 }
  periodSeconds: 10
startupProbe:
  httpGet: { path: /api/live, port: 4321 }
  failureThreshold: 30
  periodSeconds: 5
```

Für die Überwachung (Speicher, Sicherung, Lizenz, Portal) gibt es zusätzlich `/api/monitor/*` mit Token; siehe [Überwachung](ueberwachung.html).

### Volumes

- `/data` — Wissensbestand, Konten, Chats, Lizenz. Der einzige unersetzliche Zustand.
- `/backups` — die von NETbrain erzeugten verschlüsselten Sicherungen.

Sichert die Plattform das Volume ohnehin, genügt das. Planen Sie dann nicht zusätzlich NETbrains eigene Sicherung mit Aufbewahrung im selben Verzeichnis — zwei Zeitpläne räumen sich die Dateien gegenseitig weg.

### Ingress

Der Ingress beendet TLS und reicht per HTTP weiter; den `Host`-Header lässt er unverändert. Ein umgeschriebener `Host` (Service-Name, `localhost`) führt zu **421**, sobald ein Hostname gesetzt ist. Request-Bodys bis 12 MB müssen durchgehen.

### Warum genau eine Replik

NETbrain ist für einen Knoten gebaut: Der Bestand liegt als Dateien vor, Schreibzugriffe werden im Prozess serialisiert, die Anmeldedrosseln zählen im Arbeitsspeicher. Eine zweite Replik hebt das auf. Also `replicas: 1` und eine Update-Strategie, die den alten Pod vor dem neuen beendet (`Recreate`).

## Kundenportal

Optional, nur für Kunden, deren Lizenz das Portal enthält.

| | |
|---|---|
| Image | `ghcr.io/netfactory-gmbh/netbrain-portal:<version>` (öffentlich) |
| Port | HTTP auf **8080**, eigener Hostname, TLS am Ingress |
| Prüfpfad | `/health` |
| Benutzer | `10001`, Volume `/data` muss ihm gehören; das übrige Dateisystem darf schreibgeschützt sein |
| Repliken | **1** |
| Variable | `PORTAL_SYNC_KEY` — Kopplungsschlüssel, mindestens 32 Zeichen |

Die Plattform erzeugt `PORTAL_SYNC_KEY` (`openssl rand -base64 32`), legt ihn im Geheimnisspeicher ab — er muss über Neustarts gleich bleiben — und zeigt ihn **zusammen mit der Portal-Adresse auf der Kachel**. Der Kunde trägt beides in NETbrain unter **Administration → Kundenportal** ein; am Portal selbst richtet niemand etwas ein.

NETbrain muss das Portal erreichen können, umgekehrt nicht. Das Portal verbindet sich nie mit NETbrain und braucht keinen Zugang dorthin.

## Zwei-Faktor-Anmeldung

Pflicht für jedes Konto. Sperrt sich der letzte Administrator aus:

```
kubectl exec <pod> -- node scripts/user.mjs --2fa-reset <benutzername>
```

`NETBRAIN_2FA_OPTIONAL=true` macht die Zwei-Faktor-Anmeldung freiwillig.

## Lizenz

Eine frische Installation läuft sieben Tage ohne Lizenz. Danach fordert der Kunde im Assistenten selbst eine Testlizenz an oder fügt seine Lizenz ein. Der Pod braucht dafür ausgehend HTTPS zu `lizenz-netbrain.netfactory.de`. Niemand auf der Plattform muss etwas freischalten.

## Updates

Ziehen Sie den Image-Tag hoch wie bei jeder anderen Anwendung; die [Versionshinweise](versionen.html) nennen, ob vorher etwas zu tun ist. Den mitgelieferten Update-Helfer und `install.sh` bitte nicht im Pod aufrufen — beide richten einen Docker-Host ein und haben im Pod nichts verloren.
