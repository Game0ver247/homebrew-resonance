# Resonance Homebrew tap

Install the Resonance command, Python and Spicetify CLI:

```sh
brew install Game0ver247/resonance/resonance
```

Install Spotify desktop, sign in, then complete [Spicetify's initial setup](https://spicetify.app/docs/getting-started). Apply the interface:

```sh
resonance update
```

Update:

```sh
brew update
brew upgrade Game0ver247/resonance/resonance
resonance update
```

Check: `resonance check`. Remove the Spotify customization with `resonance uninstall`, then remove the command with `brew uninstall resonance`.

Formula installation never modifies Spotify automatically. The launcher stages source in a temporary directory; recovery backups remain under your Spicetify configuration. Spotify must be configured separately; the formula installs CLI dependencies only.

See the [main project](https://github.com/Game0ver247/resonance#install) for features and macOS, Windows and Fedora/Linux terminal instructions.
