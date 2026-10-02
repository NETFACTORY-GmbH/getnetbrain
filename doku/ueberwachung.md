# Überwachung

NETbrain meldet seinen Zustand über HTTP-Endpunkte. Jeder antwortet mit **200**, wenn alles in Ordnung ist, und mit **503**, wenn nicht. Damit genügt in Uptime Kuma der gewöhnliche HTTP-Monitor.

Dieselben Prüfungen sehen Administratoren auch in NETbrain selbst, unter **Administration → Übersicht → Betriebszustand**.

## Die Endpunkte

| Endpunkt | Prüft | 503, wenn | Token |
|---|---|---|---|
| `/api/live` | Der Prozess antwortet | — | nein |
| `/api/ready` | Ablage beschreibbar, keine Migration im Gange | Ablage gestört, Migration läuft oder ist gescheitert | nein |
| `/api/health` | wie `/api/ready`, zusätzlich die Lizenz | zusätzlich ohne gültige Lizenz | nein |
| `/api/monitor/speicher` | Belegung von Daten- und Sicherungsablage in Prozent | über 90 % belegt | ja |
| `/api/monitor/sicherung` | letzter Sicherungslauf | gescheitert oder älter als 26 Stunden | ja |
| `/api/monitor/lizenz` | Restlaufzeit, Bestätigung durch den Lizenzdienst | weniger als 14 Tage übrig, gesperrt, oder seit 48 Stunden nicht bestätigt | ja |
| `/api/monitor/portal` | letzter Abgleich mit dem Kundenportal | gescheitert oder älter als 30 Minuten; ohne Portal immer 200 | ja |

`/api/live` und `/api/ready` sind die Probes für Kubernetes und antworten unabhängig vom Host-Header. `/api/health` beantwortet die Frage „ist alles gut, Lizenz eingeschlossen?“.

## Token einrichten

Die Endpunkte unter `/api/monitor/` geben Betriebsinterna preis und antworten nur mit Token. Ohne Token gibt es sie nicht (404).

Am einfachsten: **Administration → Übersicht → Überwachung von außen → Token erzeugen**. Der Token steht danach dort zum Kopieren, samt Beispielaufruf. **Neuen Token erzeugen** macht den bisherigen ungültig.

Alternativ geben Sie ihn vor, etwa auf einer App-Plattform: `NETBRAIN_MONITOR_TOKEN` mit mindestens 16 Zeichen (`openssl rand -hex 24`) in der `netbrain-compose.yml` bzw. als Umgebungsvariable des Pods. Dann ist das Feld in der Verwaltung fest.

Der Monitor schickt den Token als Header:

```
curl -s -H "Authorization: Bearer <token>" https://netbrain.ihre-firma.de/api/monitor/speicher
```

Die Grenze für den Speicher ändern Sie mit `NETBRAIN_MONITOR_SPEICHER_PROZENT` (1 bis 99, Vorgabe 90).

## Antwort

Jeder Endpunkt unter `/api/monitor/` antwortet im selben Aufbau:

```
{
  "ok": true,
  "meldung": "Höchste Belegung 61.4 %.",
  "daten": {
    "grenze": 90,
    "prozent": 61.4,
    "data":    { "pfad": "/data",    "prozent": 61.4, "frei": 41234567168, "gesamt": 106825756672 },
    "backups": { "pfad": "/backups", "prozent": 61.4, "frei": 41234567168, "gesamt": 106825756672 }
  }
}
```

Die `meldung` steht so in der Benachrichtigung, dass man ohne Nachschlagen weiß, was los ist. Größen sind in Byte.

## In Uptime Kuma

Je Endpunkt ein Monitor:

1. **Monitor-Typ** „HTTP(s)“, **URL** etwa `https://netbrain.ihre-firma.de/api/monitor/sicherung`.
2. Unter **Headers**: `{"Authorization": "Bearer <token>"}`.
3. **Intervall**: 60 Sekunden für `live` und `ready`, 5 bis 15 Minuten für die übrigen genügt.

Für einen Verlauf der Belegung nehmen Sie den Typ „HTTP(s) – Json Query“ mit dem Ausdruck `daten.prozent` und der Bedingung „kleiner als 90“.

Für das Kundenportal selbst ein eigener Monitor auf `https://<portal-adresse>/health`.

## Was bewusst fehlt

Die Erreichbarkeit der KI-Anbieter: Eine echte Prüfung kostet bei jedem Aufruf Tokens. Prüfen Sie sie bei Bedarf unter **Administration → KI & Zugriffsrechte → Modelle jetzt prüfen**.
