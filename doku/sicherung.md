# Sicherung und Wiederherstellung

NETbrain sichert sich selbst: täglich, verschlüsselt und mit anschließender Prüfung. Ihre Aufgabe ist zweierlei — die Sicherungen vom Server herunterholen und das Zurückspielen gelegentlich üben.

## Was gesichert wird

Eine Sicherung ist eine einzelne, mit AES-256-GCM verschlüsselte Datei (`.nbk`). Sie enthält:

- den Wissensbestand samt Anhängen,
- die Benutzerkonten,
- die Chat-Daten samt Anhängen (sie sind zusätzlich Ende-zu-Ende-verschlüsselt),
- die KI-Freigaben,
- die Freigaben für das Kundenportal.

Alles liegt in einem Bündel, weil die Teile zusammengehören: Die Chat-Schlüssel eines Kontos sind mit dessen Passwort verpackt. Ein Bündel aus verschiedenen Zeitpunkten wäre teilweise unlesbar.

> [!WICHTIG] Ohne Passphrase keine Wiederherstellung
> Die Sicherungen öffnen sich nur mit der Sicherungs-Passphrase aus der Einrichtung. Wir haben sie nicht und können sie nicht wiederherstellen.

## Zeitplan und letzter Lauf

Unter **Administration → Einstellungen → Sicherungen** stehen Uhrzeit (Vorgabe 02:00, leer heißt aus), die Zahl der aufbewahrten Stände (Vorgabe 14) und der Knopf **Jetzt sichern**. Unter **Administration → Übersicht** sehen Sie den letzten Lauf und sein Ergebnis. Ein ausbleibender Lauf meldet sich sonst nirgends — werfen Sie gelegentlich einen Blick darauf.

Von Hand auf dem Server, etwa vor einem Eingriff:

```
cd /opt/netbrain
sudo docker compose -f netbrain-compose.yml exec netbrain node scripts/backup.mjs
```

## Sicherungen vom Server holen

Die Sicherungen liegen zunächst auf demselben Rechner wie die Daten. Gegen einen gelöschten Beitrag hilft das, gegen einen Ausfall des Servers nicht. Zwei Wege:

**Aus dem Volume kopieren**, per Auftrag Ihres Sicherungssystems:

```
sudo docker compose -f /opt/netbrain/netbrain-compose.yml cp netbrain:/backups/ /pfad/zu/ihrem/sicherungsziel/
```

**Ein Verzeichnis des Servers einhängen.** In der `netbrain-compose.yml` die Zeile `- netbrain-backups:/backups` durch Ihr Verzeichnis ersetzen, etwa `- /srv/sicherung/netbrain:/backups`, dann `sudo ./install.sh`. NETbrain schreibt danach direkt dorthin.

Die Bündel sind verschlüsselt und dürfen auf ein Ziel, das andere lesen können — solange die Passphrase nicht danebenliegt.

## Eine Sicherung prüfen

```
cd /opt/netbrain
sudo docker compose -f netbrain-compose.yml exec netbrain sh -c 'ls -lh /backups | tail -5'
sudo docker compose -f netbrain-compose.yml exec netbrain node scripts/backup.mjs --verify /backups/<datei>.nbk
```

## Wiederherstellen

Die Wiederherstellung schreibt **ausschließlich auf ein leeres Ziel**; ein bestehender Bestand wird nie überschrieben. Spielen Sie deshalb erst in ein Prüfverzeichnis zurück, sehen Sie es an, und entscheiden Sie dann.

```
sudo docker compose -f netbrain-compose.yml exec netbrain \
  node scripts/backup.mjs --restore /backups/<datei>.nbk \
    --vault /tmp/probe/vault --users /tmp/probe/users.json \
    --chat /tmp/probe/ai-chat --policy /tmp/probe/ai-policy.json \
    --portal /tmp/probe/portal.json
```

Enthält das Bündel einen Teil, für den Sie kein Ziel angeben, bricht die Wiederherstellung ab, statt ihn stillschweigend wegzulassen. Ältere Bündel ohne Portal-Freigaben brauchen `--portal` nicht.

Die Passphrase nimmt der Lauf aus der Installation. Auf einem fremden Rechner — dem Ernstfall — geben Sie sie mit: `NETBRAIN_BACKUP_PASSPHRASE='…'`.

### Auf einen neuen Server

NETbrain nach [Installation](installation.html) aufsetzen, **nicht** einrichten, und stattdessen die Sicherung nach `/data` zurückspielen. Wenden Sie sich dafür gern an uns; wir gehen den Weg mit Ihnen durch.

## Einmal im Quartal: die Probe

Spielen Sie vierteljährlich eine Sicherung testweise in ein Prüfverzeichnis zurück und sehen Sie hinein. Mit Termin im Kalender, sonst findet es nicht statt. Eine Sicherung, aus der nie jemand zurückgespielt hat, ist kein Nachweis, sondern eine Vermutung.

## Volumes

| Volume | Inhalt |
|---|---|
| `netbrain-data` (`/data`) | Wissensbestand, Anhänge, Konten, Einstellungen, Lizenz — der einzige unersetzliche Zustand |
| `netbrain-backups` (`/backups`) | die verschlüsselten Sicherungen |

Zwei Installationen dürfen niemals dasselbe Datenvolume benutzen. Es gibt keine Sperre dagegen, und der Schaden zeigt sich erst später als widersprüchlicher Bestand.
