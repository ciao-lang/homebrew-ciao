# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

# TODO: See https://github.com/Homebrew/homebrew/blob/master/Library/Formula/rust.rb

class Ciao < Formula
  desc "Ciao programming language"
  homepage "http://ciao-lang.org"

#  stable do
#    url "https://github.com/ciao-lang/ciao.git"
#    sha256 ""
#  end

  # (32-bit mode)
  head do
    url "https://github.com/ciao-lang/ciao.git"
  end

  # GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def install
    ENV.m32 # (otherwise universal binary is being build, despite ciao
            # configure options, due to homebrew's superenv)
    system "./builder/sh_src/config-sysdep/ciao_sysconf", "--osarch"
    system "./ciao-boot.sh",
           "configure",
           "--instype=global",
           "--with-docs=no",
           "--lpdoc:htmldir=#{prefix}/var/www/ciao",
           "--ciao:install_prefix=#{prefix}"
    system "cat", "build-boot/eng/ciaoengine/cfg/DARWINx86_64m32/config_sh"
    system "./ciao-boot.sh", "build"
    system "./ciao-boot.sh", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test ciao`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "${bin}/ciaoc"
  end
end
