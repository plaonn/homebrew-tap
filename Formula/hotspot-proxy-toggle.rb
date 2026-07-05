class HotspotProxyToggle < Formula
  desc "Toggle macOS proxy settings when connected to matching phone hotspots"
  homepage "https://github.com/plaonn/mac-hotspot-proxy-toggle"
  url "https://github.com/plaonn/mac-hotspot-proxy-toggle/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "7511abe046c9862020ab68c5ba320a7ee8e27f311ff7bb283869c87136018185"
  license "MIT"

  depends_on :macos

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  service do
    run [opt_libexec/"hotspot-proxy-toggle-helper", "--command", opt_bin/"hotspot-proxy-toggle"]
    keep_alive true
    log_path var/"log/hotspot-proxy-toggle-helper.log"
    error_log_path var/"log/hotspot-proxy-toggle-helper.log"
  end

  def caveats
    <<~EOS
      Create and edit the user config before starting the service:
        mkdir -p ~/.config
        cp #{etc}/hotspot-proxy-toggle.conf.example ~/.config/hotspot-proxy-toggle.conf
        ${EDITOR:-vi} ~/.config/hotspot-proxy-toggle.conf

      Start the event helper LaunchAgent:
        brew services start hotspot-proxy-toggle

      Run one reconciliation manually:
        hotspot-proxy-toggle run
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/hotspot-proxy-toggle help")
    assert_match "Usage:", shell_output("#{libexec}/hotspot-proxy-toggle-helper --help")
  end
end
