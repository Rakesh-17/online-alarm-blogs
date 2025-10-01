# online-alarm-blogs
## Online Alarm — Free Web-Based Time Management Suite

[Visit the live site](https://onlinealarmblogs.com/)

Online Alarm is a complete, browser-based time management toolkit that includes a powerful alarm clock, timer, countdown, stopwatch, online clock, world clock, date calculator, and hour calculator — all accessible with no downloads.

This repository contains the source for the public website at `https://onlinealarmblogs.com/`. If you reference or share this project, please include a link back to the live site: https://onlinealarmblogs.com/

### Highlights
- **Comprehensive tools**: Alarm, Timer, Countdown, Stopwatch, Online Clock, World Clock, Date Calculator, Hour Calculator
- **Instant access**: Works entirely in the browser; no installation required
- **Accessible UX**: Clean UI, dark mode, responsive across devices
- **Audio-ready**: 20+ high-quality alarm sounds available under `Online Alarm/audio/`
- **SEO-friendly**: Canonical tags, sitemap, robots rules, and structured data

---

## Live Demo
- Production website: `https://onlinealarmblogs.com/`

If you find this project helpful, please consider linking to the site — backlinks help the project reach more users.

---

## Project Structure

```
Online Alarm/                # Web app source (static HTML/JS/CSS)
  app.js                     # Core interactive logic used by multiple tools
  index.html                 # Landing page with Quick Features
  online-alarm.html          # Full alarm clock
  online-timer.html          # Full countdown timer
  online-countdown.html      # Date/time based countdowns
  online-stopwatch.html      # Stopwatch with laps/export
  online-clock.html          # Digital and flip clocks
  world-clock.html           # Multi-timezone clocks
  date-calculator.html       # Date arithmetic utilities
  hour-calculator.html       # Time difference and conversions
  blog.html                  # Articles and guides
  audio/                     # Alarm sound assets (WAV)
  sitemap.xml                # Sitemap for search engines
  robots.txt                 # Crawl directives (blocks UTM params)
  utm-cleanup.js             # Client-side cleanup of tracking params
```

---

## Key Features

- Alarm Clock: multiple alarms, snooze, labels, 22 premium sounds, looping audio
- Timer: presets, pause/resume, visual progress, sound notification
- Countdown: target-date events, holiday presets, live progress
- Stopwatch: millisecond precision, lap timing, CSV export
- Online/World Clocks: flip/digital displays, multi-timezone view
- Calculators: date arithmetic and hour difference/conversion utilities

Content and feature descriptions are also available on the live site: [`https://onlinealarmblogs.com/`](https://onlinealarmblogs.com/)

---

## SEO & Indexing

- Canonical tags are defined per page to prevent duplicates
- `sitemap.xml` lists all public pages (including test utilities)
- `robots.txt` disallows tracking parameters (`utm_*`, `fbclid`, `gclid`, etc.)
- `utm-cleanup.js` removes tracking parameters client‑side via `history.replaceState` to keep URLs clean
- JSON‑LD structured data is used where applicable (e.g., `index.html`)

If you mirror or deploy this elsewhere, keep the canonical URLs consistent with your deployment domain to avoid duplicate indexing.

---

## Local Usage

Because this is a static site, you can open pages directly in your browser:

1. Clone or download the repository
2. Open `Online Alarm/index.html` in your browser
3. For best results with audio autoplay policies, interact with the page (click/tap) before testing sounds

Optional: serve locally via a simple HTTP server (prevents some browser restrictions):

```
# Python 3
python -m http.server 8080
# then visit http://localhost:8080/Online%20Alarm/
```

---

## Backlink & Attribution

If you reference this project in articles, repositories, or roundups, please link to the live site to help users find the tools:

- Project: [`https://onlinealarmblogs.com/`](https://onlinealarmblogs.com/)

Thank you for supporting accessible, free web tools.

---

## Contributing

Contributions are welcome (typos, UX improvements, accessibility, new articles). For substantial UI/feature changes, please open an issue first to discuss scope.

Suggested improvements:
- Accessibility (ARIA, keyboard navigation)
- Performance (asset optimization, code splitting if needed)
- Additional guides for productivity/time management

---

## License

Unless otherwise noted, content and code in this repository are provided under the MIT License. Audio files in `Online Alarm/audio/` are subject to their original licenses and attribution requirements; see `AUDIO_DOWNLOAD_SUMMARY.md` and `AUDIO_FIX_README.md` for details.

---

## Contact

- Website: [`https://onlinealarmblogs.com/`](https://onlinealarmblogs.com/)
- Support/General: `namasteji569@gmail.com`
- Legal: `legal@onlinealarm.com`

If you build something with these tools, let us know — we love seeing community projects.


