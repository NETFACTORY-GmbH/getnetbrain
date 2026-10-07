# Einrichtung im Browser

Nach der Installation landet jeder Aufruf auf `/einrichtung`. Der Assistent führt in neun Schritten durch alles, was eine Installation braucht. Was Sie hier eintragen, wird gespeichert; eine Konfigurationsdatei müssen Sie nicht pflegen.

> [!WICHTIG] Halten Sie Ihren Passwortmanager bereit
> In Schritt 2 erzeugt NETbrain eine **Sicherungs-Passphrase** und zeigt sie genau einmal. Ohne sie lässt sich keine Ihrer Sicherungen mehr öffnen — auch nicht durch uns, denn wir haben sie nie. Legen Sie sie ab, sobald sie erscheint, sodass mindestens zwei Personen herankommen.

## 1. Token

Fügen Sie das Einrichtungs-Token aus der Ausgabe des Installers ein. Es belegt, dass Sie Zugriff auf den Server haben; ohne diesen Nachweis wäre die Einrichtungsseite ein offenes Tor. Ein abgewiesenes Token ist fast immer ein altes: `sudo ./install.sh token` zeigt das aktuelle.

## 2. Geheimnisse

NETbrain erzeugt die nötigen Schlüssel und die Sicherungs-Passphrase selbst. Die Passphrase erscheint einmal und muss zur Bestätigung noch einmal eingegeben werden. Was hier weggeklickt wird, ist weg.

## 3. Erreichbarkeit und Name

- **Hostname** — der DNS-Name, unter dem Ihr Team NETbrain aufruft.
- **Zahl der Reverse-Proxys** vor NETbrain, meist `1`. Nicht auf `0` lassen, wenn ein Proxy davorsteht.
- **Name Ihrer Organisation** — erscheint im Seitentitel und in den Datenschutzhinweisen.

Steht ein Wert schon in der `netbrain-compose.yml`, zeigt die Seite ihn als fest an: Die Datei hat Vorrang.

## 4. KI-Anbieter

Adresse und Schlüssel Ihres Anbieters. Der Zugang wird sofort getestet, bevor es weitergeht — ein Tippfehler fällt hier auf und nicht beim ersten Nutzer. Welche Anbieter und Modelle wer nutzen darf, legen Sie später unter [KI-Zugänge und Freigaben](ki-zugaenge.html) fest.

## 5. Sicherung

Uhrzeit des täglichen Laufs (Vorgabe 02:00) und wie viele Stände aufgehoben werden (Vorgabe 14). Lösen Sie den **Probelauf** aus: Er schreibt sofort eine Sicherung und beweist, dass Zeitplan und Passphrase zusammenpassen. Der Zeitplan läuft im Container; auf Ihrem Server entsteht kein Cronjob.

## 6. Lizenz

Fügen Sie den Inhalt Ihrer Lizenzdatei ein. NETbrain bindet sie dabei beim Lizenzdienst an diese Installation. Haben Sie noch keine Lizenz, gibt es zwei Wege:

- **Ohne Lizenz weitermachen** — eine neue Installation ist ab dem ersten Start sieben Tage vollständig nutzbar.
- **Testlizenz anfordern** — Firma, Name und Mailadresse eintragen; die Lizenz kommt per Mail, gilt 30 Tage und wird hier eingefügt. Je Mailadresse gibt es eine.

Mehr dazu unter [Lizenz](lizenz.html).

## 7. Kundenportal

Optional und überspringbar. Ist ein Portal-Container schon vorhanden, tragen Sie hier seine Adresse ein und erzeugen den Kopplungsschlüssel. Das geht genauso später unter **Verwaltung → Kundenportal** — siehe [Kundenportal](kundenportal.html). Der Schritt erscheint nur, wenn Ihre Lizenz das Portal enthält.

## 8. Prüfung

NETbrain sieht sich selbst durch und meldet, was fehlt oder unsicher eingestellt ist. Arbeiten Sie jeden Befund ab, statt ihn zu übergehen; die Liste meldet sich nur zu echten Lücken.

## 9. Administrator

Das erste Konto: Benutzername und Passwort, dazu gleich die **Zwei-Faktor-Anmeldung**. Scannen Sie den QR-Code mit einer Authenticator-App (zum Beispiel Microsoft Authenticator, Google Authenticator oder 1Password) und geben Sie den sechsstelligen Code ein. Ohne gültigen Code entsteht kein Konto.

Nach der ersten Anmeldung zeigt NETbrain einmalig zehn **Wiederherstellungscodes**. Notieren Sie sie — sie sind der Weg zurück, wenn das Handy verloren geht.

Damit endet der Einrichtungsmodus: `/einrichtung` ist danach nicht mehr erreichbar. Weitere Konten legen Sie unter [Benutzer und Rollen](benutzer.html) an.

## Danach

- Den Proxy und die Sicherung einmal nachweisen statt annehmen: Zertifikat gültig, Port 4321 von außen gesperrt, eine 12-MB-Datei geht durch, eine Sicherung lässt sich öffnen. Siehe [Reverse-Proxy](reverse-proxy.html#nachweisen) und [Sicherung](sicherung.html).
- Eine Kopie der Sicherungen auf ein Ziel außerhalb des Servers einrichten.
