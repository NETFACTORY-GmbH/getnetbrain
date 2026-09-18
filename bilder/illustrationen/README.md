# Illustrationen für die Salesseite

Die Salesseite verwendet drei schematische SVG-Grafiken in der visuellen Sprache der NETFACTORY-Hauptseite: dunkle Interface-Karten, feine Verbindungen und wenige Akzente in Türkis (#1bccc4) und Mint (#92e188). Die Inhalte erklären konkrete NETbrain-Abläufe und bleiben auf jedem Bildschirm scharf.

In index.html eingebunden: Wissensfluss im Einstieg, Freigabeprozess im Abschnitt „Im Alltag“ und Systemgrenze bei „Datenhoheit“. Die drei zuvor erzeugten 3D-Motive ergänzen den Lösungsabschnitt als atmosphärische Bildstrecke.

| Datei | Einsatz | Alternativtext |
|---|---|---|
| [netbrain-wissensfluss.svg](netbrain-wissensfluss.svg) | Einstieg | Vom Beitrag zum geprüften Firmenwissen und zur Nutzung über Suche und KI-Chat. |
| [netbrain-freigabeprozess.svg](netbrain-freigabeprozess.svg) | Abschnitt „Im Alltag“ | Einreichen, aufbereiten, prüfen und gemeinsam nutzen. |
| [netbrain-datenhoheit.svg](netbrain-datenhoheit.svg) | Abschnitt „Datenhoheit“ | Eigene Installation, lokale Notizen und frei wählbare KI-Anbindung. |
| [firmenwissen-hero-transparent-v2.png](firmenwissen-hero-transparent-v2.png) | Bildstrecke im Lösungsabschnitt | Vernetzte Dokumente bilden einen gemeinsamen Wissensbestand. |
| [wissen-freigabe.png](wissen-freigabe.png) | Bildstrecke im Lösungsabschnitt | Ein Beitrag wird geprüft und in den gemeinsamen Bestand übernommen. |
| [datenhoheit-server.png](datenhoheit-server.png) | Bildstrecke im Lösungsabschnitt | Server und Firmenwissen innerhalb der eigenen Infrastruktur. |

Die SVGs haben transparente Flächen, feste Seitenverhältnisse und benötigen keinen CSS-Mischmodus. Das Einstiegsbild wird priorisiert, alle weiteren Grafiken werden verzögert geladen. Für die 3D-Motive verwendet die Seite responsive WebP-Fassungen mit 600 und 1200 Pixel Breite; die PNG-Originale bleiben als Quelldateien erhalten.

## Verwendete Prompts

### firmenwissen-hero-transparent-v2

Use case: background-extraction. Asset type: transparent landing-page hero illustration. Remove the entire pure black background and make it genuinely transparent. Preserve the central glass document library, all five connected document stations, every turquoise connecting line, mint check badge, reflections that belong to the objects, exact composition, proportions, colors, materials, lighting, and resolution. Keep the objects sharp with clean anti-aliased edges. Change only the background. Output must contain a real alpha channel with fully transparent pixels extending to every canvas edge. Avoid black rectangle, dark matte, halo, fringe, new objects, moved objects, changed lighting, crop, text, logo, and watermark.

### firmenwissen-hero

Use case: stylized-concept. Asset type: premium B2B knowledge management website hero illustration, landscape 1536x1024. Create a refined editorial 3D still life representing shared company knowledge: a central translucent smoked-glass cubic library containing neatly layered document sheets, connected by a few precise thin turquoise paths to five smaller floating document tiles. Documents have minimal embossed abstract lines only. Cohesive architectural composition, orthographic three-quarter view, centered subject with generous black negative space all around, entire object visible, pure black background fading to black at edges for seamless placement on black website. Materials: dark graphite anodized metal, optical smoked glass, restrained luminous turquoise #1bccc4 edges and subtle mint #92e188 verification accents, realistic soft studio reflections. Strong hierarchy, elegant and tactile, high-end software campaign visual. No text, no letters, no numbers, no logos, no watermark, no brain shapes, no robots, no people, no UI screenshots, no purple or blue glow, no busy particles. This is a conceptual illustration, not a product interface.

### wissen-freigabe

Use case: stylized-concept. Asset type: landscape 1536x1024 section illustration for premium B2B knowledge software on a black website. Refined editorial 3D still life showing a simple left-to-right journey from raw contributions to reviewed shared knowledge. Left: three loose graphite document cards, one with abstract text strokes, one with an embossed link icon, one with a small embossed image icon. Middle: a single upright smoked-glass review pane holding a document with a crisp mint-green check mark. Right: three neatly aligned completed document cards on a low dark plinth. A very restrained thin turquoise line connects the three groups left to right. Composition clean and immediately legible with three separated stations, consistent orthographic three-quarter view, generous empty black margins, objects entirely in frame. Graphite anodized metal, smoked glass, soft realistic studio reflections, turquoise #1bccc4 edge lighting and mint #92e188 check accent. Pure black background and edges, no frame. Elegant premium architectural product render, restrained illumination. No words, no letters, no numbers, no logos, no watermark, no people, no robots, no brains, no purple, no UI screenshot.

### datenhoheit-server

Use case: stylized-concept. Asset type: premium B2B knowledge management sales website data sovereignty illustration, landscape 1536x1024. Create a refined editorial 3D still life of a compact single graphite server tower with three elegant horizontal modules, accompanied by a neat stack of document cards, all sitting together inside an architectural open-topped smoked-glass square enclosure on a dark metal plinth. An elegant small solid mint-colored shield inset on the front of the plinth communicates control. The enclosure is a conceptual boundary of the company's own infrastructure, not a prison. No external cloud and no external cables. Subject centered, restrained orthographic three-quarter view, generous empty black margins, entire object visible. Graphite anodized aluminum, smoked optical glass, turquoise #1bccc4 glass edges and small mint #92e188 status lights, soft studio reflections, tactile realistic premium materials, minimal architectural design. Pure black background fades to pure black edges, no frame. Match a sophisticated black/turquoise software website. No text, letters, numbers, logos, watermark, padlock, people, robots, brains, purple glow, excessive particles or UI screenshots.
