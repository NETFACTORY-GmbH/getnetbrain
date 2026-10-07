# Aktualisieren

Neue Versionen erscheinen regelmäßig. Administratoren sehen sie am Zahnrad oben rechts und ausführlich unter **Administration → Übersicht → Systemaktualisierung**. Was sich geändert hat und ob vorher etwas zu tun ist, steht in den [Versionshinweisen](versionen.html).

## Im Browser

**Jetzt aktualisieren** führt vier Schritte in dieser Reihenfolge aus:

1. eine verschlüsselte Sicherung anlegen — schlägt sie fehl, beginnt das Update nicht;
2. das neue NETbrain-Image beziehen;
3. den Container neu starten und die Selbstprüfung abwarten;
4. bei fehlgeschlagener Prüfung automatisch zur bisherigen Version zurückkehren.

NETbrain selbst hat dabei keinen Zugriff auf Docker. Ein lokaler Helfer auf dem Server, den der Installer eingerichtet hat, übernimmt genau diesen Ablauf und sonst nichts. Er prüft alle sechs Stunden, ob es eine neue Version gibt.

## Von Hand auf dem Server

Für Wartung und den Notfall:

```
cd /opt/netbrain
sudo docker compose -f netbrain-compose.yml exec netbrain node scripts/backup.mjs
sudo ./install.sh
```

Der Installer erkennt die vorhandene Installation, lässt die Daten stehen und wartet, bis die Anpassungen am Bestand durch sind. Ihre `netbrain-compose.yml` bleibt unverändert. Während der Bestand angepasst wird, meldet `sudo ./install.sh status` den Zustand `migriert` — das ist normal.

Eine bestimmte Version installieren Sie mit dem versionierten Link:

```
curl -fsSL https://getnetbrain.netfactory.de/install.sh@0.4.16 | sudo bash
```

## Zurück auf die Vorversion

Geht über denselben Weg mit der alten Versionsnummer. Ein bereits angepasster Bestand ist von der Vorversion aber nicht immer vollständig lesbar. Der verlässliche Rückweg ist die Sicherung vor dem Update — deshalb steht sie dort.

## Auf einer App-Plattform

Der Update-Helfer braucht einen Docker-Host und greift auf Kubernetes nicht. Dort ziehen Sie den Image-Tag hoch wie bei jeder anderen Anwendung; siehe [Kubernetes und App-Plattformen](plattform.html).
