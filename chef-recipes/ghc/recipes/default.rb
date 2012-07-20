
ver = '7.4.2'
hp_ver = '2012.2.0.0'

bin_tarball = "ghc-#{ver}-x86_64-unknown-linux.tar.bz2" 
bin_url = "http://www.haskell.org/ghc/dist/#{ver}/#{bin_tarball}" 
hp_tarball = "haskell-platform-#{hp_ver}.tar.gz"
hp_url = "http://lambda.haskell.org/platform/download/#{hp_ver}/#{hp_tarball}"

# basic build reqs
package 'libgmp3c2'
package 'libgmp3-dev'
package 'make'

# haskell platform deps
#package 'libgl1-mesa-swx11'
#package 'libgl1-mesa-swx11-dev'
#package 'libglu1-mesa-dev'
package 'freeglut3-dev'

unless File.file? '/usr/local/bin/ghc'
  # download / unpack phase
  bash "download ghc #{ver}" do
    cwd "/tmp"

    code <<-EOH
      set -e
      #wget #{bin_url}
      cp /vagrant/#{bin_tarball} .
    EOH
  end

  bash "unpack ghc #{ver}" do
    cwd "/tmp"

    code <<-EOH
      set -e
      tar -xvjf #{bin_tarball}
    EOH
  end

  bash "download haskell platform #{hp_ver}" do
    cwd "/tmp"

    code <<-EOH
      set -e
      #wget #{hp_url}
      cp /vagrant/#{hp_tarball} .
    EOH
  end

  bash "unpack haskell platform #{hp_ver}" do
    cwd "/tmp"

    code <<-EOH
      set -e
      tar -xvzf #{hp_tarball}
    EOH
  end


  # build / install phase
  bash "configure ghc #{ver}" do
    cwd "/tmp/ghc-#{ver}"

    code <<-EOH
      set -e
      ./configure
    EOH
  end

  bash "install ghc #{ver}" do
    cwd "/tmp/ghc-#{ver}"
    user "root"

    code <<-EOH
      set -e
      make install
    EOH
  end

  bash "configure haskell platform #{hp_ver}" do
    cwd "/tmp/haskell-platform-#{hp_ver}"

    code <<-EOH
      set -e
      ./configure --enable-unsupported-ghc-version
    EOH
  end

  bash "make haskell platform #{hp_ver}" do
    cwd "/tmp/haskell-platform-#{hp_ver}"

    code <<-EOH
      set -e
      make
    EOH
  end

  bash "install haskell platform #{hp_ver}" do
    cwd "/tmp/haskell-platform-#{hp_ver}"
    user "root"

    code <<-EOH
      set -e
      make install
    EOH
  end
end

