# toddherrbach.com

Personal portfolio site. Three static HTML pages; all CSS is inline in each file
(the only external dependency is the Google Fonts link). No build step.

## Server / Deploy
- Site: toddherrbach.com
- Host: iad1-shared-b7-08.dreamhost.com   (SSH user: dotbacher)
- Web root: /home/dotbacher/toddherrbach.com/
- Deploy: `./scripts/deploy.sh --dry-run` (preview, uploads nothing), then
  `./scripts/deploy.sh` (refuses a dirty git tree, asks for a `y`, one rsync pass).
  - rsync over key-based SSH. Flags: `-a -z -i --no-perms`. NO `--delete`.
  - `--no-perms` is REQUIRED: without it `-a` copies the Mac's private dir/file perms
    (700/600) onto the server and Apache 403s the WHOLE site. (Learned the hard way;
    fixed once with chmod 755/644 on the server + adding --no-perms.)
  - Excludes: .git, .DS_Store, CLAUDE.md, SESSION_LOG.md, scripts/, .dh-diag/
    (so these docs are repo-only and never deployed).
  - The human runs deploy and confirms; the SSH key is never in the script.
- macOS rsync is openrsync (2.6.9-compatible): no `--chmod=D/F` support — use `--no-perms`.

## Files
- index.html                 Homepage: identity + two cards (case study, resume)
- hidden-palms-ranch.html    HPR case study (long scroll, hero video, Rosie payoff)
- todd-herrbach-resume.html  Resume
- scripts/deploy.sh          Deploy tool
- images/                    All media (screenshots, video, wave/hero textures, Rosie photos)

## images/ folder (current)
- Case study screenshots: guest-page-*.png, guide-app-*.png, guide-step-1..6.png,
  guest-scroll-1..7.png, media-dashboard.png, todays-uploads.png, shot-6.png
- Hero / wave: hero-waveform.jpg (desktop, 1810x869), hero-waveform-mobile.jpg
  (mobile, 1100x528, ~2.08:1), hero-texture.jpg
- Video: guide-app-upload.mp4 (900x1950, ~2.6MB, 29.8s re-encode from the high-res
  original), guide-app-upload-poster.jpg. Referenced with `?v=2` for cache-busting.
- Rosie payoff (the only real photography): rosie-horizontal.jpg (credit: Carlos
  Amoedo), rosie-face.jpeg (credit: Briana Perroux)

## Brand
- Case study tokens (:root): --dark #0B1620, --dark-2 #111E2D, --mid #F3F6FA,
  --accent/--primary #1355C7, --accent-hover #0D44A8, --accent-green #1A7A50,
  --accent-warm #C47D20, --body #37465A, --border #DDE4EE, --muted #637080
- Homepage label colors: CASE STUDY blue #5B9BFF, RESUME gold #C9A23F
- Font: Montserrat (weights 200..800)

## Homepage design notes (index.html)
- Two cards, EXACTLY equal height via `align-items: stretch` (a hard rule from Todd).
- Visual hierarchy: card title 100% white  >  CTA 85% white (16px = 80% of the 20px
  title, hover -> full white)  >  subhead muted  >  italic accent/curiosity line BELOW
  the CTA, colored as its label color at 85% (case study blue, resume gold).
- Resume tagline: "Three decades making complex systems work for everyone, not just
  the builder." Case study tagline: "From AirDrop to a complete guest experience."
- MOBILE (<=620px) is a LOCKED, no-scroll layout (the fixed wave must not drift):
  - body uses 100svh; on phones/tablets (<=1024px) html `overflow:hidden` + body is a
    viewport-tall touch region (100dvh, overflow-y auto), so a drag only rubber-band
    bounces — no real scroll, no iOS toolbar-dismiss shift.
  - Hero wave (.hero-bg) is position:fixed with a FIXED 380px height (NOT vh) so its
    bright line lands consistently across devices; `background-position: center 33%`
    sits the bright line on the bottom of "Herrbach" (calibrated on a 430px iPhone 14
    Pro Max — tuning is width-sensitive, so trust real-device feedback over the preview).
  - Wave dimmed on mobile: opacity 0.9 + the base ::after scrim at 0.5 opacity (about
    half the desktop shading — a deliberate midpoint between bright and fully dimmed).
  - Eyebrow and footer are MATCHED right-aligned vertical stacks: no bullets,
    line-height 1.2, text at 0.62 white. SYSTEMS THINKER (last eyebrow line) clears the
    wave's top edge by ~5px.
  - Desktop keeps the originals: horizontal eyebrow with bullet separators, horizontal
    footer with a dot. Mobile-only rules live in the <=620px and <=1024px media queries.

## Email
All `mailto:` links (homepage, case study, resume) pre-fill the subject:
`mailto:todd.herrbach@gmail.com?subject=Hi%20Todd`

## Copy rules
No em dashes. Sentence case headings. No filler language.
