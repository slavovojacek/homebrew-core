class Ttfautohint < Formula
  desc "Auto-hinter for TrueType fonts"
  homepage "https://www.freetype.org/ttfautohint/"
  url "https://downloads.sourceforge.net/project/freetype/ttfautohint/1.8.3/ttfautohint-1.8.3.tar.gz"
  sha256 "87bb4932571ad57536a7cc20b31fd15bc68cb5429977eb43d903fa61617cf87e"
  license any_of: ["FTL", "GPL-2.0-or-later"]

  livecheck do
    url "https://sourceforge.net/projects/freetype/rss?path=/ttfautohint"
    regex(%r{url=.*?/ttfautohint[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "eff19e3d880697bc17c8094b8d0b5d3f8371817d1fb62ca752065d8e2e102c4e"
    sha256 cellar: :any,                 big_sur:       "6901a298ff9d9316c844dd856a6ee587b5d9fee3f8b60a3d0ac569c2cea1bed9"
    sha256 cellar: :any,                 catalina:      "542ada8a8e7deaa7fc3f14f2fec704b2570bec6baa07396a37ac7b6d280cfab6"
    sha256 cellar: :any,                 mojave:        "04ca530843887602e80fde17d24f4ed8e19d1248bd71c81c925c161770dbdf56"
    sha256 cellar: :any,                 high_sierra:   "a6573ae816a7555d62308759c2d64f9fb955ba056d856d904a522996ba0a0c83"
    sha256 cellar: :any,                 sierra:        "d45d8d85d3ffa162326ea8e2f63778f4fe583c41bc316c15c5a63b3625beb0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce873df8769c2106cc3c2232bfc4049c23feb3da8ad417a71df7db048455acb6"
  end

  head do
    url "https://repo.or.cz/ttfautohint.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "libpng"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-doc",
                          "--without-qt"
    system "make", "install"
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    font_dir = "/Library/Fonts"
    on_linux do
      font_name = "DejaVuSans.ttf"
      font_dir = "/usr/share/fonts/truetype/dejavu"
    end
    cp "#{font_dir}/#{font_name}", testpath
    system bin/"ttfautohint", font_name, "output.ttf"
    assert_predicate testpath/"output.ttf", :exist?
  end
end
