# Was den Server verlässt

NETbrain läuft auf Ihrem Server. Diese Seite listet vollständig, welche Verbindungen nach außen es aufbaut, damit Ihre Datenschutzprüfung nicht raten muss.

## An Ihren KI-Anbieter

Wenn jemand den KI-Chat nutzt oder Wissen aufbereiten lässt, geht an den gewählten Anbieter:

- die Frage oder der eingeworfene Text samt beigefügter Dateien und Bilder,
- die Ausschnitte aus dem Firmenwissen, die für die Antwort herangezogen werden — sofern Firmenwissen für diesen Anbieter freigegeben ist,
- bei verbundenem privaten Vault die passenden lokalen Auszüge — sofern freigegeben.

Welcher Anbieter das ist, bestimmen Sie. Bei einem Modell in Ihrem eigenen Netz bleibt die Verarbeitung intern. Ob Firmenwissen oder private Auszüge an **Cloud**-Anbieter gehen dürfen, regeln zwei Schalter unter **Administration → KI & Zugriffsrechte → Wissen und Cloud**. Wechselt jemand mitten im Gespräch zu einem Cloud-Anbieter, fragt NETbrain vorher nach; die Zustimmung wird protokolliert. Siehe [KI-Zugänge und Freigaben](ki-zugaenge.html).

## Websuche und abgerufene Links

- Fügt jemand beim Erfassen einen **Link** ein, ruft NETbrain diese Seite ab und speichert eine Kopie als Nachweis.
- Nutzt jemand im Chat die **Websuche**, gehen daraus geformte Suchanfragen an die Suche des KI-Anbieters oder an eine eigene Suchmaschine, falls Sie eine eingerichtet haben; die besten Treffer werden abgerufen.

## An den Lizenzdienst

`lizenz-netbrain.netfactory.de`, betrieben von NETFACTORY:

- **Aktivierung und regelmäßige Bestätigung**: die Lizenzdatei und der technische Installationsschlüssel. Keine Inhalte, keine Konten.
- **Testlizenz**, wenn Sie eine anfordern: Firma, Name und Mailadresse, zur Ausstellung und Zustellung der Lizenz.
- **Feedback**, wenn jemand über „Feedback geben“ etwas schickt: der Text, die freiwillige Kontaktangabe, die NETbrain-Version und die Installationskennung — ohne Benutzername oder Konto. Die Meldung wird in NETbrain nicht gespeichert, sondern per Mail an uns zugestellt.

## An die Container-Registry

`ghcr.io`: bei Installation und Update der Bezug des Images, beim Update-Helfer alle sechs Stunden die Frage nach einer neuen Version. Das belegt, welche Version Sie beziehen — mehr nicht.

## An das Kundenportal

Nur wenn Sie es einrichten: die freigegebenen Seiten als fertiges HTML samt ihren Abbildungen, an den Portal-Container unter der von Ihnen eingetragenen Adresse.

## Sonst nichts

Keine Nutzungsstatistik, kein Tracking, keine automatische Fehlerübermittlung. Sicherungen bleiben auf Ihrem Server, verschlüsselt mit Ihrer Passphrase. Der Chatverlauf liegt Ende-zu-Ende-verschlüsselt auf dem Server; der Schlüssel entsteht im Browser aus dem Passwort des Nutzers.

Persönliche Notizen im privaten Vault liegen in einem Ordner auf dem Rechner des Mitarbeiters und werden nicht auf dem Server gespeichert.
