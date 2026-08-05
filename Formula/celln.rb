# Homebrew formula for the sympozium-ai/celln tap.
class Celln < Formula
  desc "Run agents in hardware-isolated cells with attested, revocable tools"
  homepage "https://github.com/sympozium-ai/celln"
  url "https://github.com/sympozium-ai/celln/archive/refs/tags/v0.4.10.tar.gz"
  sha256 "15d18674c5d0316767e2d9210d40a82250add6d583fab35782e5cab7f0dee34c"
  license "Apache-2.0"

  depends_on "cpio"
  depends_on "e2fsprogs"
  depends_on "rustup"

  def install
    ENV["RUSTUP_HOME"] = buildpath/"rustup"
    ENV["CARGO_HOME"] = buildpath/"cargo"
    system "rustup", "toolchain", "install", "stable", "--profile", "minimal",
           "--target", "x86_64-unknown-linux-musl"
    system "cargo", "+stable", "install", "--path", "crates/celln-cli", "--root", prefix,
           "--locked"
    system "cargo", "+stable", "build", "--release", "--package", "celln-pilot",
           "--target", "x86_64-unknown-linux-musl", "--bin", "celln-pilot", "--bin", "pilot-fetch",
           "--locked"

    pkgshare.install "scripts", "guest"
    guest_bin = buildpath/"target/x86_64-unknown-linux-musl/release"
    (pkgshare/"pilot").install guest_bin/"celln-pilot"
    (pkgshare/"pilot").install guest_bin/"pilot-fetch"
  end

  test do
    assert_match "celln", shell_output("#{bin}/celln --version")
    (testpath/"agent.toml").write shell_output("#{bin}/celln spec init")
    assert_match "my-agent", shell_output("#{bin}/celln spec check agent.toml --no-json")
  end
end
