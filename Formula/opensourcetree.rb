class Opensourcetree < Formula
  desc "Cross-platform Git GUI application"
  homepage "https://github.com/kiryl-kvit/opensourcetree"
  version "0.2.0"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.2.0/opensourcetree-0.2.0-linux-x64.tar.gz"
      sha256 "71014c77c90c74ee13d1e3e3654f96d9de37e76e139c59fa5fd0efd47a8b7600"
    end
  end

  on_macos do
    on_arm do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.2.0/opensourcetree-0.2.0-osx-arm64.tar.gz"
      sha256 "9c8c6a5810b0fcca2201b68b3536e46700c717290ed1feb4cd471a04c4ef1b7d"
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
