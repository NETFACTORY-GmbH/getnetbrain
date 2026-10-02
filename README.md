# NETbrain — Installationsskript

Auslieferungsort für das Installationsskript von NETbrain. Kein Quellcode der
Anwendung, keine Zugangsdaten.

```bash
curl -fsSL https://getnetbrain.netfactory.de/install.sh | sudo bash          # neueste Fassung
curl -fsSL https://getnetbrain.netfactory.de/install.sh@0.4.1 | sudo bash    # feste Fassung
```

Das Skript richtet Docker auf Rückfrage ein, bezieht das NETbrain-Image aus der
Registry und übernimmt danach der mitgelieferte Installer. Konto und Pull-Token
für die Registry kommen von NETFACTORY.

© NETFACTORY GmbH

## Seite und Auffindbarkeit

- `index.html` – Produktseite mit JSON-LD (`@graph`: Organisation, Website, Software, Produktfilm, FAQ).
- `doku/`, `llms.txt`, `llms-full.txt`, `sitemap.xml` – erzeugt von `netbrain-dev/auslieferung/doku/bauen.py`, nicht von Hand ändern.
- `robots.txt`, `site.webmanifest`, `404.html`, `bilder/og-image-1200.png` – von Hand gepflegt.
- `.nojekyll` – GitHub Pages liefert alles unverändert aus; sonst würde Jekyll die `.md`-Fassungen der Doku zu HTML umbauen.
