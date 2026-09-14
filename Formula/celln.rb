# Homebrew formula for the sympozium-ai/celln tap.
class Celln < Formula
  desc "Run agents in hardware-isolated cells with attested, revocable tools"
  homepage "https://github.com/sympozium-ai/celln"
  url "https://github.com/sympozium-ai/celln/releases/download/v0.5.14/celln-x86_64-unknown-linux-musl.tar.gz"
  sha256 "b2db7f495146b49695ff72dd19c6b8f393908c6aa0f90d262df3299a81259b23"
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
