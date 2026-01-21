class Opensourcetree < Formula
  desc "Cross-platform Git GUI application"
  homepage "https://github.com/kiryl-kvit/opensourcetree"
  version "0.1.0"
  license "MIT"

  on_linux do
    on_intel do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.1.0/opensourcetree-0.1.0-linux-x64.tar.gz"
      sha256 "249a684c7b4243dfb0fd02d7bce7c4a857caa69525eadb1f58c9da224d7e943e"
    end
  end

  on_macos do
    on_arm do
      url "https://github.com/kiryl-kvit/opensourcetree/releases/download/v0.1.0/opensourcetree-0.1.0-osx-arm64.tar.gz"
      sha256 "8117e37671e6c550c503b235d2ff38084e9a376194ca13bb670ec1fdbc5b2cf3"
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
