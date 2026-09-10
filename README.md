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
