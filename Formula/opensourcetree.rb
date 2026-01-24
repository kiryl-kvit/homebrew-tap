class Opensourcetree < Formula
  desc "Cross-platform Git GUI application"
  homepage "https://github.com/kiryl-kvit/opensourcetree"
  version "0.3.0"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.3.0/opensourcetree-0.3.0-linux-x64.tar.gz"
      sha256 "c729c848230c7854ad738c10b5d2ebd1d8cf948cf13883dfb2b5892b8d7f0854"
    end
  end

  on_macos do
    on_arm do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.3.0/opensourcetree-0.3.0-osx-arm64.tar.gz"
      sha256 "df6db4842fc7969f3489a0cf71aefa799d3748082ed80fe0b9888604b835339d"
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

      # Install .desktop file to the Homebrew share directory for desktop integration
      desktop_dir = share/"applications"
      desktop_dir.mkpath
      desktop_file = desktop_dir/"opensourcetree.desktop"
      desktop_file.write <<~DESKTOP
        [Desktop Entry]
        Name=OpenSourceTree
        GenericName=Git Client
        Comment=Cross-platform Git GUI application
        Exec=#{opt_bin}/opensourcetree %F
        Icon=opensourcetree
        Terminal=false
        Type=Application
        Categories=Development;RevisionControl;
        Keywords=git;version control;vcs;repository;
        StartupWMClass=OpenSourceTree
        MimeType=application/x-git;
      DESKTOP

      # Install icon to the Homebrew share directory for desktop integration
      icon_dir = share/"icons/hicolor/scalable/apps"
      icon_dir.mkpath
      (icon_dir/"opensourcetree.svg").write(File.read("opensourcetree.svg"))
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
          #{share}/applications/opensourcetree.desktop
          #{share}/icons/hicolor/scalable/apps/opensourcetree.svg

        If your launcher does not pick it up - ln -s $(brew --prefix)/share/applications/opensourcetree.desktop ~/.local/share/applications.
      EOS
    end
  end

  test do
    assert_predicate bin/"opensourcetree", :exist?
  end
end
