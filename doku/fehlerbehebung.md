# Fehlerbehebung

Die meisten Probleme haben eine von wenigen Ursachen. Diese Seite ordnet sie nach dem, was Sie sehen.

## Bei der Installation

| Meldung | Ursache und Abhilfe |
|---|---|
| `Bitte mit sudo aufrufen.` | Das Skript braucht Root-Rechte: `… \| sudo bash`. |
| `Docker läuft nicht` | `sudo systemctl start docker`, dann erneut. |
| `Docker Compose (v2) fehlt` | `sudo apt-get install -y docker-compose-plugin` |
| `Das Image … konnte nicht bezogen werden` | Kommt der Server ausgehend auf 443 zu `ghcr.io`? Löst der Name auf? Gibt es die Version? Eine Anmeldung braucht es nicht. |
| `Port … ist belegt` | Anderen Port wählen: `… \| sudo NETBRAIN_PORT=4330 bash`, der Proxy leitet dann dorthin. |
| `hat nach 180 Sekunden nicht »bereit« gemeldet` | Der Installer zeigt die letzten Protokollzeilen. Meist ist `/data` nicht beschreibbar oder eine Einstellung ungültig. |

## Im Browser

| Sie sehen | Ursache und Abhilfe |
|---|---|
| Fehler **421** | Der aufgerufene Name steht nicht in `NETBRAIN_ALLOWED_HOSTS`, oder der Proxy schreibt den `Host`-Header um. Siehe [Installation](installation.html#dns-name-und-proxy-kette-eintragen). |
| Anmeldung erscheint nach richtigem Passwort wieder | NETbrain wird über HTTP statt HTTPS aufgerufen, oder das Zertifikat ist abgelaufen. Siehe [Reverse-Proxy](reverse-proxy.html). |
| „Zu viele Anmeldeversuche“, obwohl niemand sich vertippt hat | `NETBRAIN_TRUSTED_PROXY_HOPS` fehlt oder steht auf `0`: Alle Nutzer erscheinen als eine Adresse. |
| Einrichtungs-Token wird abgewiesen | Es ist ein altes. `sudo ./install.sh token` zeigt das aktuelle. |
| Kein Token in der Ausgabe | Die Installation ist schon eingerichtet. |
| Eine Datei lässt sich nicht einreichen, es erscheint eine fremde Fehlerseite | Das Body-Limit des Proxys ist kleiner als 12 MB. |
| Lizenzseite statt Anwendung | Testphase oder Lizenz abgelaufen, oder die Aktivierung wurde länger als sieben Tage nicht bestätigt. Siehe [Lizenz](lizenz.html). |
| „Aktivierung fehlgeschlagen“ | Der Server erreicht den Lizenzdienst nicht (ausgehend 443 zu `lizenz-netbrain.netfactory.de`), oder die Lizenz ist schon an eine andere Installation gebunden. |
| Privater Vault „In diesem Browser nicht verfügbar“ | Der Vault braucht Chrome oder Edge. |
| KI-Chat antwortet mit Fehler | **Administration → KI & Zugriffsrechte → Modelle jetzt prüfen** zeigt, welcher Anbieter nicht antwortet. |

## Zustand prüfen

```
cd /opt/netbrain
sudo ./install.sh status
```

Am Ende steht die Antwort der Selbstprüfung:

- **bereit** — alles in Ordnung.
- **migriert** — der Bestand wird nach einem Update angepasst. Abwarten.
- **nicht bereit** — die Einzelprüfungen daneben nennen die Ursache, meist ein nicht beschreibbares `/data`.

## Bevor Sie uns schreiben

Schicken Sie bitte diese beiden Ausgaben mit; sie beantworten die meisten Rückfragen vorweg:

```
sudo ./install.sh status
sudo ./install.sh logs
```

Die letzten Zeilen des Protokolls genügen, `Strg` + `C` beendet die Ausgabe. Unsere Adresse: [info@netfactory.de](mailto:info@netfactory.de). Aus der Anwendung heraus geht es auch über **Feedback geben** im Hinweisbalken.
