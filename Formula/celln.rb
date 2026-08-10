# Homebrew formula for the sympozium-ai/celln tap.
class Celln < Formula
  desc "Run agents in hardware-isolated cells with attested, revocable tools"
  homepage "https://github.com/sympozium-ai/celln"
  url "https://github.com/sympozium-ai/celln/releases/download/v0.5.1/celln-x86_64-unknown-linux-musl.tar.gz"
  sha256 "c473236e852fed3a6da885f0540e5be3a5084d83fcc4cb4be3cdb5f8fc387898"
  license "Apache-2.0"

  depends_on "cpio"
  depends_on "e2fsprogs"

  on_macos do
    disable! date: "2026-08-06", because: "the release archive requires Linux"
  end

  on_arm do
    disable! date: "2026-08-06", because: "the release archive requires x86_64"
  end
  def install
    bin.install "bin/celln"
    pkgshare.install Dir["share/celln/*"]
  end

  test do
    assert_match "celln", shell_output("#{bin}/celln --version")
    (testpath/"agent.toml").write shell_output("#{bin}/celln spec init")
    assert_match "my-agent", shell_output("#{bin}/celln spec check agent.toml --no-json")
  end
end
