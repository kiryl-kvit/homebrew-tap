class Opensourcetree < Formula
  desc "Cross-platform Git GUI application"
  homepage "https://github.com/kiryl-kvit/opensourcetree"
  version "0.1.0"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.1.0/opensourcetree-0.1.0-linux-x64.tar.gz"
      sha256 "3ead7b2136477d88b181ec9cb840f43a84e5303264b7db633f4b7d1b835ddfd3"
    end
  end

  on_macos do
    on_arm do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.1.0/opensourcetree-0.1.0-osx-arm64.tar.gz"
      sha256 "9c04c3a343c0982025789e3523ccbe4b62c22615c186d060c42e7299098887e8"
    end
  end

  def install
    if OS.mac?
      prefix.install "OpenSourceTree.app"
      (bin/"opensourcetree").write <<~SH
        #!/bin/bash
        open "#{prefix}/OpenSourceTree.app" "$@"
      SH
    else
      bin.install "opensourcetree"

      # Install .desktop file to ~/.local/share/applications for desktop integration
      local_apps = Pathname.new(Dir.home)/".local/share/applications"
      local_apps.mkpath
      desktop_file = local_apps/"opensourcetree.desktop"
      desktop_file.write <<~DESKTOP
        [Desktop Entry]
        Name=OpenSourceTree
        GenericName=Git Client
        Comment=Cross-platform Git GUI application
        Exec=#{bin}/opensourcetree %F
        Icon=opensourcetree
        Terminal=false
        Type=Application
        Categories=Development;RevisionControl;
        Keywords=git;version control;vcs;repository;
        StartupWMClass=OpenSourceTree
        MimeType=application/x-git;
      DESKTOP

      # Install icon to ~/.local/share/icons for desktop integration
      local_icons = Pathname.new(Dir.home)/".local/share/icons/hicolor/scalable/apps"
      local_icons.mkpath
      (local_icons/"opensourcetree.svg").write(File.read("opensourcetree.svg"))
    end
  end

  def caveats
    if OS.mac?
      <<~EOS
        To add OpenSourceTree to your Applications folder:
          ln -sf #{prefix}/OpenSourceTree.app /Applications/OpenSourceTree.app

        Then it will appear in Spotlight search.
      EOS
    else
      <<~EOS
        Desktop integration files have been installed to:
          ~/.local/share/applications/opensourcetree.desktop
          ~/.local/share/icons/hicolor/scalable/apps/opensourcetree.svg

        You may need to log out and back in for the app to appear in your launcher.
      EOS
    end
  end

  def post_uninstall
    if OS.linux?
      # Clean up desktop integration files
      desktop_file = Pathname.new(Dir.home)/".local/share/applications/opensourcetree.desktop"
      icon_file = Pathname.new(Dir.home)/".local/share/icons/hicolor/scalable/apps/opensourcetree.svg"
      desktop_file.unlink if desktop_file.exist?
      icon_file.unlink if icon_file.exist?
    end
  end

  test do
    assert_predicate bin/"opensourcetree", :exist?
  end
end
