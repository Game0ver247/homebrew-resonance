class Resonance < Formula
  desc "Album-focused Spotify listening interface powered by Spicetify"
  homepage "https://github.com/Game0ver247/resonance"
  url "https://github.com/Game0ver247/resonance/archive/542e1387237d9535b17cb4070896da01a28aa79c.tar.gz"
  version "4.11.0"
  sha256 "c5121970c9df5e7e9fe080191f2b17b2159147a028d493eff8365702396d1a52"

  depends_on "python@3.14"
  depends_on "spicetify-cli"

  def install
    libexec.install "maintenance.py", "build.py", "display-ui.js", "lyrics-engine.js", "homebrew-launcher.py"
    (bin/"resonance").write <<~SH
      #!/bin/sh
      export PATH="#{Formula["spicetify-cli"].opt_bin}:$PATH"
      exec "#{Formula["python@3.14"].opt_bin}/python3.14" "#{libexec}/homebrew-launcher.py" "$@"
    SH
  end

  def caveats
    <<~EOS
      Install Spotify desktop, sign in, and complete Spicetify's initial setup:
        https://spicetify.app/docs/getting-started
      Apply Resonance with:
        resonance update
      After brew upgrade, run resonance update again to apply the new source.
      Check: resonance check
      Remove Spotify customization before uninstalling the formula:
        resonance uninstall
        brew uninstall resonance
      Installing or removing this formula does not automatically modify Spotify.
    EOS
  end

  test do
    assert_match "Maintain the local Resonance", shell_output("#{bin}/resonance --help")
    # Test installation planning with an isolated Spotify/config fixture.
    resources = testpath/"Spotify.app/Contents/Resources"
    resources.mkpath
    (resources.parent/"Info.plist").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <plist version="1.0"><dict><key>CFBundleShortVersionString</key><string>1.3.4.123</string></dict></plist>
    XML
    config = testpath/"config-xpui.ini"
    config.write <<~INI
      [Setting]
      spotify_path = #{resources}
      [Backup]
      version = 1.3.4.123
      [AdditionalOptions]
      extensions =
    INI
    fakebin = testpath/"fakebin"
    fakebin.mkpath
    (fakebin/"spicetify").write <<~SH
      #!/bin/sh
      if [ "$1" = "-c" ]; then
        printf '%s\n' "#{config}"
      else
        exit 99
      fi
    SH
    (fakebin/"spicetify").chmod 0755
    # Invoke the packaged launcher directly to let the fixture CLI take priority.
    ENV.prepend_path "PATH", fakebin
    python = Formula["python@3.14"].opt_bin/"python3.14"
    output = shell_output("#{python} #{libexec}/homebrew-launcher.py update --dry-run")
    assert_match "Would run: spicetify apply", output
    refute_path_exists resources/"Apps"
  end
end
