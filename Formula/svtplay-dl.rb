class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from https://www.svtplay.se/"
  homepage "https://svtplay-dl.se/"
  url "https://files.pythonhosted.org/packages/55/fa/e7eb0da0f6c78188d98ab44d3fa37b3652e34ebe577d0bc0e35145b42c25/svtplay-dl-4.2.tar.gz"
  sha256 "e0cfcef6f7d94c768a7bc97fcdaf3e3481f369c7a06db0112170a711db793eaa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9000a51b187ed7afc1567285abd163cfef88a506056cfaa07460cab3cbdd5289"
    sha256 cellar: :any,                 big_sur:       "51b04f0e6ed98256973ef0049c0212694fd48c05b1d80169d2162d953bb417b1"
    sha256 cellar: :any,                 catalina:      "5add3f760ef55a426b4de05d12ef47c43c1827fd5f03be5852221525c96f685c"
    sha256 cellar: :any,                 mojave:        "df77d808a32f4d18ee81a483d494e497f6dbb9db812031d7b3a7bc070b35d05e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00f0c1047d4836a9e0180150dcc7cdd41228972bf16931f8b65df8f74e41f46a"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804/cffi-1.14.6.tar.gz"
    sha256 "c9a875ce9d7fe32887784274dd533c57909b7b1dcadcc128a2ac21331a9765dd"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/37/fd/05a04d7e14548474d30d90ad0db5d90ee2ba55cd967511a354cf88b534f1/charset-normalizer-2.0.3.tar.gz"
    sha256 "c46c3ace2d744cfbdebceaa3c19ae691f53ae621b39fd7570f59d14fb7f2fd12"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To use post-processing options:
        `brew install ffmpeg` or `brew install libav`.
    EOS
  end

  test do
    url = "https://tv.aftonbladet.se/abtv/articles/244248"
    match = <<~EOS
      https://absvpvod-vh.akamaihd.net/i/2018/02/cdaefe0533c2561f00a41c52a2d790bd
      /,1280_720_2800,960_540_1500,640_360_800,480_270_300,.mp4.csmil
      /index_0_av.m3u8
    EOS
    assert_match match.delete!("\n"), shell_output("#{bin}/svtplay-dl -g #{url}")
  end
end
