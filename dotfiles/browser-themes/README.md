# Browser themes

Catppuccin Mocha, mauve accent — same palette as the alacritty, zellij, bat,
helix and nvim themes in this repo.

`init-user.sh` copies these to `~/.config/browser-themes/` along with the rest
of `dotfiles/`. Neither browser reads them from there automatically; both need
a one-time manual load.

## Chrome

```
chrome://extensions  →  Developer mode ON  →  Load unpacked
~/.config/browser-themes/chrome
```

Persists across restarts. To remove it, `chrome://settings/appearance` → Reset
to default.

## Firefox

Release Firefox refuses to permanently install unsigned add-ons, and a theme is
an add-on. Three options:

**Temporary** — good for checking it looks right, lost on restart:

```
about:debugging#/runtime/this-firefox  →  Load Temporary Add-on
~/.config/browser-themes/firefox/manifest.json
```

**Permanent, self-signed** — free, and doesn't list the theme publicly:

```sh
cd ~/.config/browser-themes/firefox
zip -r ../catppuccin-mocha.zip .
```

Upload the zip to [addons.mozilla.org](https://addons.mozilla.org/developers/)
as **"On your own"** distribution. You get a signed `.xpi` back, which installs
permanently. Requires a Mozilla account.

**Permanent, no signing** — only on Developer Edition, Nightly, or ESR:

```
about:config  →  xpinstall.signatures.required = false
```

Then install the zip directly. This does nothing on release Firefox.

## Or skip all of that

Catppuccin publishes both officially, one click each:

- [Chrome Web Store](https://chromewebstore.google.com/search/catppuccin)
- [Firefox Add-ons](https://addons.mozilla.org/firefox/addon/catppuccin-mocha-mauve/)

These local copies exist so the theme is pinned and reproducible alongside
everything else in this repo. The rendered result is near-identical.
