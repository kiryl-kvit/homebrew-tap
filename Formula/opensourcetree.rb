class Opensourcetree < Formula
  desc "Cross-platform Git GUI application"
  homepage "https://github.com/kiryl-kvit/opensourcetree"
  version "0.1.0"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.1.0/opensourcetree-0.1.0-linux-x64.tar.gz"
      sha256 "dbee73fad1b70abda5edeb793ca90f4311049b708b34364effcdbd1844ce3a0a"
    end
  end

  on_macos do
    on_arm do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.1.0/opensourcetree-0.1.0-osx-arm64.tar.gz"
      sha256 "7ee318fc88937b1f16ab9704d904f4cc645908d9c22b77020c2a2798164cbbbb"
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
      (share/"applications").install "opensourcetree.desktop"
      (share/"icons/hicolor/scalable/apps").install "opensourcetree.svg"
    end
  end

  def caveats
    if OS.mac?
      <<~EOS
        To add OpenSourceTree to your Applications folder:
          ln -sf #{prefix}/OpenSourceTree.app /Applications/OpenSourceTree.app

        Then it will appear in Spotlight search.
      EOS
    end
  end

  test do
    assert_predicate bin/"opensourcetree", :exist?
  end
end
