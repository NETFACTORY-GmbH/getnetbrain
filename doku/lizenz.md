# Lizenz

NETbrain wird je Installation und Jahr lizenziert. Die Zahl der Benutzerkonten ist nicht begrenzt. Aktualisierungen und eine monatliche Betreuungszeit sind enthalten.

## Sieben Tage ohne Lizenz

Eine neue Installation ist ab dem ersten Start **sieben Tage vollständig nutzbar**, ganz ohne Lizenzdatei. In dieser Zeit können Sie in Ruhe ausprobieren.

## Testlizenz anfordern

Unter **Lizenz** (`/lizenz`) oder im Einrichtungsassistenten fordern Administratoren eine Testlizenz über sieben Tage an: Firma, Name und Mailadresse eintragen, die Lizenz kommt per Mail. Den Block aus der Mail fügen Sie wie jede andere Lizenz ein. Je Mailadresse gibt es eine Testlizenz. Sie enthält auch das [Kundenportal](kundenportal.html).

## Lizenz hinterlegen

Ein Administrator öffnet unter **Administration** den Verweis **Lizenz aktivieren oder verlängern** oder direkt `/lizenz`, fügt den Inhalt der Lizenzdatei ein und klickt **Lizenz prüfen und aktivieren**. NETbrain bindet die Lizenz dabei beim Lizenzdienst an diese Installation; dieselbe Datei lässt sich nicht auf einem zweiten Server aktivieren. Nach erfolgreicher Aktivierung bestätigt die Seite die Lizenz und leitet zur Anwendung weiter.

Übertragen werden nur die Lizenzdatei und der technische Installationsschlüssel. Notizen, Chats und Konten bleiben in Ihrer Installation.

## Verbindung zum Lizenzdienst

NETbrain bestätigt die Aktivierung regelmäßig beim Lizenzdienst. Ist er nicht erreichbar, arbeitet eine aktivierte Installation bis zu **sieben Tage** weiter und weist darauf hin. Der Server braucht dafür ausgehend Port 443 zu `lizenz-netbrain.netfactory.de`.

## Ablauf und Verlängerung

Nach dem Ablauftag bleiben **sieben Tage Übergangsfrist**. Für die Verlängerung erhalten Sie von uns eine neue Lizenzdatei, die Sie an derselben Stelle einfügen. Die Testlizenz hat keine Übergangsfrist.

Ist weder Testphase noch Lizenz gültig, bleiben erreichbar:

- die Lizenzseite, um eine Lizenz einzufügen,
- der **Export des Firmenwissens** als JSON für Administratoren,
- der private Vault.

Es geht nichts verloren. Sobald eine gültige Lizenz hinterlegt ist, steht sofort wieder alles offen.

## Für den Support

Unter `/lizenz` steht im aufklappbaren Bereich **Installationskennung für den Support** die Kennung Ihrer Installation. Nennen Sie sie bei Fragen zur Lizenz. Lizenz kaufen oder verlängern: [info@netfactory.de](mailto:info@netfactory.de).
