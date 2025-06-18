---
title = "New Pages"
url = "new-pages"
published = 2025-06-18T05:00:04+00:00
---

Welcome to the new pages! Not much should have changed from the angular ones with a few exceptions.

Changes from a external perspective

- fix: Reloading on a page with a non-empty path is no longer causes the github default 404
- tweak: Color theme changed to Catppuccin!
- tweak: Altered Page formatting and styles
- tweak: Clients no longer render directly from markdown
- removed: MotD no longer displayed at the bottom of the page; caused issues with page width on mobile when rending math text
- removed: Light/Dark toggle temporally disabled (returns soon)

Internally major changes have been made. The primary issue that drove these changes is the reloading problem. Simply, Github's static serving is not effective for Angular routed single page applications. Further, my previous approach involved fetching and rendering markdown content with KaTeX which caused large scripts to be loaded and executed in addition to the angular binaries. Resolving both of these issues is static content. For my tastes it is a bit too impractical to directly wright an article with HTML, so I avoided that path.

I was aware of tested solutions such as mdBook and Jekyll but was interested in working with a language I enjoy, [Gleam](https://github.com/gleam-lang/gleam). Gleam's [lustre_ssg](https://github.com/lustre-labs/ssg) has been a excellent tool. Offering an excessive amount of customizability while not being cumbersome. It of course has flaws. These are mostly related to the [djot-markdown parser](https://github.com/lpil/jot) being work in progress. However, if you need a feature added, contributions there are welcomed, and from my experience reviewed promptly.

Overall I would say the changeover has been a success and I look forward to tweaking the site.
