// NETbrain-Dokumentation: Kopierknöpfe, Suche, markierter Abschnitt.
// Ohne JavaScript bleibt jede Seite vollständig lesbar; nur diese Hilfen fehlen.
(() => {
  document.querySelectorAll('.codeblock .kopieren').forEach((knopf) => {
    knopf.addEventListener('click', async () => {
      const text = knopf.parentElement.querySelector('code').innerText.replace(/\n$/, '');
      try {
        await navigator.clipboard.writeText(text);
        knopf.classList.add('kopiert');
        knopf.setAttribute('aria-label', 'Kopiert');
        setTimeout(() => { knopf.classList.remove('kopiert'); knopf.setAttribute('aria-label', 'Befehl kopieren'); }, 1800);
      } catch { /* Ohne Zwischenablage bleibt der Text markierbar. */ }
    });
  });

  // Auf dem Handy startet die Navigation zugeklappt, sonst steht der Inhalt erst
  // nach zwanzig Einträgen. Ohne JavaScript bleibt sie offen.
  const navigation = document.querySelector('.seitennav details');
  if (navigation && matchMedia('(max-width: 860px)').matches) navigation.open = false;

  // Suche über alle Seiten. Der Index entsteht beim Bauen (suche.json) und wird
  // erst beim ersten Fokus geladen.
  const feld = document.querySelector('.suche input');
  const liste = document.querySelector('.suche .treffer');
  if (feld && liste) {
    let index = null;
    let auswahl = -1;
    const laden = async () => {
      if (index) return index;
      try { index = await (await fetch(feld.dataset.index)).json(); } catch { index = []; }
      return index;
    };
    const normal = (text) => text.toLocaleLowerCase('de-DE');
    const zeigen = async () => {
      const woerter = normal(feld.value).split(/\s+/).filter((w) => w.length >= 2);
      auswahl = -1;
      if (!woerter.length) { liste.hidden = true; return; }
      const eintraege = await laden();
      const treffer = eintraege
        .map((e) => {
          const titel = normal(e.titel); const text = normal(e.text);
          let punkte = 0;
          for (const w of woerter) {
            if (titel.includes(w)) punkte += 5;
            else if (text.includes(w)) punkte += 1;
            else return null;
          }
          return { e, punkte };
        })
        .filter(Boolean)
        .sort((a, b) => b.punkte - a.punkte)
        .slice(0, 8);
      liste.replaceChildren();
      if (!treffer.length) {
        const leer = document.createElement('li');
        leer.className = 'leer';
        leer.textContent = 'Nichts gefunden.';
        liste.append(leer);
      }
      for (const { e } of treffer) {
        const li = document.createElement('li');
        const a = document.createElement('a');
        a.href = feld.dataset.basis + e.url;
        const b = document.createElement('b'); b.textContent = e.titel;
        const s = document.createElement('span'); s.textContent = e.seite;
        a.append(b, s); li.append(a); liste.append(li);
      }
      liste.hidden = false;
    };
    feld.addEventListener('focus', laden, { once: true });
    feld.addEventListener('input', zeigen);
    feld.addEventListener('keydown', (ereignis) => {
      const links = [...liste.querySelectorAll('a')];
      if (ereignis.key === 'Escape') { liste.hidden = true; feld.blur(); return; }
      if (!links.length) return;
      if (ereignis.key === 'ArrowDown' || ereignis.key === 'ArrowUp') {
        ereignis.preventDefault();
        auswahl = (auswahl + (ereignis.key === 'ArrowDown' ? 1 : -1) + links.length) % links.length;
        links.forEach((l, i) => l.classList.toggle('aktiv', i === auswahl));
      }
      if (ereignis.key === 'Enter') {
        ereignis.preventDefault();
        location.href = links[Math.max(auswahl, 0)].href;
      }
    });
    document.addEventListener('click', (ereignis) => {
      if (!ereignis.target.closest('.suche')) liste.hidden = true;
    });
    document.addEventListener('keydown', (ereignis) => {
      if (ereignis.key === '/' && document.activeElement !== feld && !/input|textarea/i.test(document.activeElement.tagName)) {
        ereignis.preventDefault();
        feld.focus();
      }
    });
  }

  // „Auf dieser Seite": den Abschnitt markieren, der gerade oben steht.
  const verweise = [...document.querySelectorAll('.auf-dieser-seite a')];
  if (verweise.length && 'IntersectionObserver' in window) {
    const nachId = new Map(verweise.map((a) => [a.hash.slice(1), a]));
    const beobachter = new IntersectionObserver((eintraege) => {
      for (const eintrag of eintraege) {
        if (!eintrag.isIntersecting) continue;
        verweise.forEach((a) => a.classList.remove('aktiv'));
        nachId.get(eintrag.target.id)?.classList.add('aktiv');
      }
    }, { rootMargin: '-80px 0px -70% 0px' });
    document.querySelectorAll('.artikel h2[id]').forEach((h) => beobachter.observe(h));
  }
})();
