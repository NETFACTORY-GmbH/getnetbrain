# Benutzer und Rollen

Konten verwalten Administratoren unter **Administration → Übersicht & Konten**. Die Zahl der Konten ist durch die Lizenz nicht begrenzt.

## Die drei Rollen

| Rolle | Darf |
|---|---|
| **Benutzer** | Firmenwissen lesen, einreichen und Fehler melden; privater Vault; KI-Chat. Jedes Konto hat diese Rolle. |
| **Wissenspflege** | zusätzlich Einreichungen veröffentlichen oder ablehnen, Seiten bearbeiten, verschieben und löschen, Seiten im Kundenportal veröffentlichen. |
| **Admin** | zusätzlich Konten und Rollen verwalten, KI-Zugänge und Freigaben, Einstellungen, Sicherung, Updates, Kundenportal und Lizenz. |

Eine Firmenseite entsteht immer über die Wissensprüfung: Benutzer reichen ein, die Wissenspflege gibt frei.

## Konto anlegen

Unter **Konto anlegen** Benutzername, Anzeigename und ein vorläufiges Passwort eintragen. Das Konto ist sofort freigegeben. Bei der ersten Anmeldung setzt die Person ein eigenes Passwort und richtet die Zwei-Faktor-Anmeldung ein.

## Zugangsanfragen

Wer sich unter `/registrieren` selbst anmeldet, erscheint unter **Wartet auf Freigabe**. **Freigeben** schaltet das Konto frei, **Ablehnen** verwirft die Anfrage.

## Konten verwalten

Je Konto in der Liste **Konten**:

- **Rollen** — Häkchen für Wissenspflege und Admin, dann **Rollen speichern**.
- **Vorläufiges Passwort setzen** — beendet alle Sitzungen des Kontos; die Person muss beim nächsten Anmelden ein eigenes Passwort wählen.
- **2FA zurücksetzen** — etwa bei verlorenem Handy; die Person richtet die Zwei-Faktor-Anmeldung beim nächsten Anmelden neu ein.
- **Sperren** und **Entsperren**.
- **Löschen**.

Unter **Letzte Kontenänderungen** steht, wer wann was geändert hat.

> [!HINWEIS] Ein vorläufiges Passwort öffnet den Chatverlauf nicht
> Der Chatverlauf ist mit dem Passwort der Person verschlüsselt. Nach einem vom Administrator gesetzten Passwort entsperrt sie ihn mit ihrem Wiederherstellungscode.

## Wenn sich der letzte Administrator aussperrt

Auf dem Server, im Verzeichnis `/opt/netbrain`:

```
sudo docker compose -f netbrain-compose.yml exec netbrain node scripts/user.mjs --2fa-reset <benutzername>
```

Die Zwei-Faktor-Anmeldung lässt sich insgesamt freiwillig machen, mit `NETBRAIN_2FA_OPTIONAL: "true"` in der Compose-Datei. Wir raten davon ab.
