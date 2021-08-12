class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    url "https://networkupstools.org/source/2.7/nut-2.7.4.tar.gz"
    sha256 "980e82918c52d364605c0703a5dcf01f74ad2ef06e3d365949e43b7d406d25a7"

    # Upstream fix for OpenSSL 1.1 compatibility
    # https://github.com/networkupstools/nut/pull/504
    patch do
      url "https://github.com/networkupstools/nut/commit/612c05ef.patch?full_index=1"
      sha256 "0f87adda658bc2ce6ae0266dfa7ced8c6e7e0db627baaef8cdbd547416ba989b"
    end
  end

  bottle do
    sha256 arm64_big_sur: "4a5c519bf1474df85186b1bbab6221549a3f668a9eae785bd0398aaf1b850f68"
    sha256 big_sur:       "9df4cddf68b3d3aeb84b5762514a070f8685da5f0c02e0bf097c1cf0a33dcf47"
    sha256 catalina:      "1586ba300fc949859b2bebb55af99bc634362db7633e91a0db30aad28bef9c09"
    sha256 mojave:        "dde3a1e3dc4e86f77d01071c0d669ea600569b41f8e9f11bb16a6b19e39286ca"
    sha256 high_sierra:   "6fda08463f3e551d255b80e6e467b1f2938c973ab016f81b1585dd73373da562"
    sha256 x86_64_linux:  "de5e555a1d1715840b4b526a93c8d8cc509c86325d3295019e3399fc200a93f0"
  end

  head do
    url "https://github.com/networkupstools/nut.git"
    depends_on "asciidoc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "openssl@1.1"

  conflicts_with "rhino", because: "both install `rhino` binaries"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "./autogen.sh"
    else
      # Regenerate configure, due to patch applied
      system "autoreconf", "-i"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/nut
      --with-statepath=#{var}/state/ups
      --with-pidpath=#{var}/run
      --with-openssl
      --with-serial
      --with-usb
      --without-avahi
      --without-cgi
      --without-dev
      --without-doc
      --without-ipmi
      --without-libltdl
      --without-neon
      --without-nss
      --without-powerman
      --without-snmp
      --without-wrap
    ]
    on_macos do
      args << "--with-macosx_ups"
    end
    on_linux do
      args << "--with-udev-dir=#{lib}/udev"
    end

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"state/ups").mkpath
    (var/"run").mkpath
  end

  plist_options manual: "upsmon -D"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_sbin}/upsmon</string>
            <string>-D</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/dummy-ups", "-L"
  end
end
