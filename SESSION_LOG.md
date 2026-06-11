# toddherrbach.com — Session Log

## Session 1
Repo initialized from live site download. Images folder contains current HPR
case study screenshots. Ready for case study image refresh.

## Session 2 (2026-06-10) — case study polish, homepage design, full mobile pass
Long build/polish session. Everything deployed and device-tested unless noted.

Deploy / infra:
- SSH key auth set up for the `dotbacher` DreamHost account; first real deploy done.
- Fixed a whole-site 403: rsync `-a` had copied the Mac's private perms onto the
  server; added `--no-perms` to deploy.sh (and chmod 755/644 on the server once).

Case study (hidden-palms-ranch.html):
- Hero upload-flow video: custom takeover overlay (not native fullscreen) with
  Watch-again / Resume-case-study end buttons; the phone is reparented to <body> on
  open to escape a stacking-context trap that left it blurry. Re-encoded the clip from
  the high-res original to 900x1950 (2.6MB, 29.8s) for crisp desktop playback, and
  cache-busted the URL with `?v=2` (the identical filename had been serving the old
  cached long clip).
- "Meet Rosie" payoff section added right after the video block (the only real
  photography in the project): horizontal photo + bordered text box (warm accent
  stripe) + square face photo wrapped by the text; photo credits Carlos Amoedo
  (horizontal) and Briana Perroux (face).
- Whole-page spacing/typography audit; logic-table header vertical-align fix.

Homepage (index.html):
- Two cards redesigned: case study card widened so its title + subhead fit one line;
  EXACT equal height enforced with `align-items: stretch` (hard rule). CTAs set to 80%
  of the title size (16px) at 85% white (hover -> full white). Italic curiosity/tagline
  lines added BELOW each CTA, colored as the label color at 85% (case study blue,
  resume gold). Resume tagline finalized: "Three decades making complex systems work
  for everyone, not just the builder."
- Full MOBILE pass (desktop left as-is throughout):
  - Locked, no-scroll layout: 100svh + html/body scroll lock so a drag only rubber-band
    bounces (keeps the fixed wave from drifting; fixes the iOS toolbar-dismiss shift).
  - Hero wave given a FIXED 380px height so its bright line is device-stable; tuned to
    sit on the bottom of "Herrbach" at `background-position: center 33%` (calibrated
    from Pro Max feedback after 31% read high and 40%/37% overshot).
  - Eyebrow turned into a right-aligned vertical stack (no bullets) that clears the
    wave's top edge; top padding pulled up so adding the third line didn't move Herrbach.
  - Footer (email + LinkedIn) made a MATCHED right-aligned stack: dropped the divider
    line, tightened to the eyebrow's rhythm, raised text to 0.62 white. +15% gap between
    the bottom card and the footer.
  - Wave dimming dialed to a midpoint: opacity 0.9 + base scrim at 0.5 (between the
    original punch and full desktop shading).

Site-wide:
- All `mailto:` links pre-fill the subject with "Hi Todd".

## Session 3 (2026-06-10) — case study copy fixes + Background "Hands-On" skills
Case study only (hidden-palms-ranch.html). Each change previewed and deployed.

Copy corrections:
- Guest Experience, "Save your photos" (step 3): "100%" -> "the majority" of guests.
- Background / Experience, Orlando Magic line: "200+" -> "150+" annual events. (The resume
  states no event count, so there was nothing to match there.)
- Community / "PA of the Day": dropped the inaccurate "Founder"; rewrote to the true story
  pulled from the resume — "Developed a professional live audio social media brand from
  80,000 to 350,000+ followers across Facebook and Instagram, building the Instagram
  presence from scratch. Ran an affiliated print-on-demand Shopify store for 10 years,
  generating the direct customer insight that now drives Custom Crew Gear."

Background "Hands-On" skills (replaced the old "Stack" pill row that just duplicated the
build stack above it):
- Relabeled Stack -> Hands-On (a competency level between "working knowledge" and "proficient").
- New pill style `.skill-pill`: outline pills (transparent fill, thin border) with a bold
  term + optional muted helper line — deliberately distinct from the filled build `.stack-chip`s.
- Curated to real-history skills, grouped/ordered AI / commerce / audio:
  ChatGPT (daily user, 2+ years) · Claude (experienced) · Claude Code (rapidly progressive
  understanding) | Shopify · Print-on-demand (CustomCat) · Email marketing · Meta Ads
  (Facebook & Instagram) [lead-gen & retargeting] | Audio over IP (Dante) · Post-production
  audio mixing · Pro Tools (audio mixing software) · Waves (plug-ins) · iZotope (audio
  repair & denoise).
- Desktop wrapping fix: the block was confined to a 480px grid column, so the 4 commerce
  pills (Meta Ads alone is ~234px) couldn't share a line. Moved Hands-On to a FULL-WIDTH
  band above the Background grid, with the three groups as their own rows
  (`.handson-groups` / `.handson-group`) — each group is one line on desktop. On mobile
  (<=768px) the groups stack one-per-line to preserve the mobile list (and the wide Meta
  Ads pill no longer clips as it did in the old 145px column).

## Session 4 (2026-06-11) — resume consistency fixes (DEPLOYED)
todd-herrbach-resume.html only. Commit 2963ebb; deployed via deploy.sh (dry-run confirmed a
resume-only transfer; case study and all other files untouched). Print machinery untouched;
no em dashes in new copy.
- Project status: "In late-stage testing, approaching launch" -> "Version 1 live and in use
  at Hidden Palms Ranch".
- SigV4 bullet: reframed as the architecture decision (sign AWS SigV4 directly in PHP, no
  SDK and no AWS account, directed through Claude Code); rest of the bullet unchanged.
- Final project bullet: dropped "served as the primary ... across 15+ build sessions"; now
  "as the development partner ... The build is ongoing; guides report anything that blocks
  their workflow or any guest reaction worth acting on, and that feedback sets the next release."
- Custom Crew Gear bullet 2: conditional trim applied to hold the two-page print
  ("Paused at the print-file automation stage ... launches when it does."). Net rendered
  length after the trim: 0 lines (edits +2, trim -2), measured print-accurate at the 4.81in
  right column / 9pt.
- PENDING: a separate case study consistency pass for hidden-palms-ranch.html is planned and
  not started. Nothing uncommitted there at deploy time.
