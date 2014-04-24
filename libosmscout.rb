require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Libosmscout < Formula
  homepage ""
  url "https://github.com/nkostelnik/libosmscout/tarball/master"
  sha1 "e48a50f57dd7291747b7fb619ea51ad444673a2a"
  version "0.1"

  depends_on 'autoconf'
  depends_on 'automake'
  depends_on 'libtool'
  depends_on 'marisa'
  depends_on 'pkg-config'
  depends_on 'protobuf'

  # depends_on "cmake" => :build
  # depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    #system "./configure", "--disable-debug",
    #                      "--disable-dependency-tracking",
    #                      "--disable-silent-rules",
    #                      "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    #system "cd libosmscout && make"#, "install" # if this fails, try separate make/make install steps

    # system "cd libosmscout && ./autogen.sh && ./configure --disable-see2-support && make"

    build_command = <<-eos
      # compile libosmscout
      cd libosmscout
      ./autogen.sh && ./configure --disable-see2-support && make
      export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$(pwd)
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/src/.libs
      cd ..

      # compile libosmscoutimport
      cd libosmscout-import
      ./autogen.sh && ZLIB_CFLAGS="-I/usr/include" ZLIB_LIBS="-L/usr/lib -lz" ./configure && make
      export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$(pwd)
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/src/.libs
      cd ..

      # compile the Import tool
      cd Import/
      ./autogen.sh && ./configure && make
      cp src/Import src/osmscout-import
      cd ..
    eos

    system(build_command)

    # prefix.install Dir['*']

    # include.install Dir['libosmscout/include/osmscout']
    lib.install Dir['libosmscout/src/.libs/*']

    # system("cp -rf libosmscout-import/include/osmscout/* #{include}/osmscout")
    lib.install Dir['libosmscout-import/src/.libs/*']

    # system("cp -rf libosmscout-map/include/osmscout/* #{include}/osmscout")
    # lib.install Dir['libosmscout-map/src/.libs/*']

    bin.install Dir['Import/src/osmscout-import']
    bin.install Dir['Import/src/.libs']
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test libosmscout`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
