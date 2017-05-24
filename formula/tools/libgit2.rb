class Libgit2 < BuildDependency

  desc "A portable, pure C implementation of the Git core methods provided as a re-entrant linkable library with a solid API"
  homepage 'https://libgit2.github.com/'
  url 'https://github.com/libgit2/libgit2/archive/v${version}.tar.gz'

  release version: '0.24.6', crystax_version: 1, sha256: { linux_x86_64:   '3fcc31b5c42763403cc2de9606f76d90c1365235ba74a4610604e2c331264e95',
                                                           darwin_x86_64:  '3aab051274820be9817948e258478a03e13ee068244430dbb38a49c1573a595c',
                                                           windows_x86_64: '8a4158c66918acedb835868f007a1b83d73941da4e5b0c197c1dc0b2259edc02',
                                                           windows:        '12c7539b9f4a046704e8e6a31d2e2114ee402429384e2c77a146658429593ba3'
                                                         }

  depends_on 'zlib'
  depends_on 'openssl'
  depends_on 'libssh2'

  def build_for_platform(platform, release, options, host_dep_dirs, _target_dep_dirs)
    install_dir = install_dir_for_platform(platform.name, release)
    zlib_dir    = host_dep_dirs[platform.name]['zlib']
    openssl_dir = host_dep_dirs[platform.name]['openssl']
    libssh2_dir = host_dep_dirs[platform.name]['libssh2']

    FileUtils.cp_r File.join(src_dir, '.'), '.'

    build_env['EXTRA_CFLAGS']   = "#{platform.cflags}"
    build_env['EXTRA_DEFINES']  = "-DGIT_OPENSSL -DOPENSSL_SHA1 -DGIT_SSH -DGIT_THREADS"
    build_env['EXTRA_INCLUDES'] = "-I#{zlib_dir}/include -I#{openssl_dir}/include -I#{libssh2_dir}/include"

    build_env['EXTRA_DEFINES'] += " -DGIT_ARCH_64"  unless platform.name == 'windows'
    build_env['EXTRA_DEFINES'] += " -DGIT_USE_NSEC" if platform.target_os == 'windows'

    make_args = ['-f', 'Makefile.crystax']

    if platform.target_os == 'windows'
      build_env['EXTRA_DEFINES'] += " -DGIT_WIN32"
      make_args << 'MINGW=1'
    end

    system 'make', *make_args

    FileUtils.mkdir_p ["#{install_dir}/lib", "#{install_dir}/include"]
    #
    FileUtils.cp   './libgit2.a',      "#{install_dir}/lib/"
    FileUtils.cp   './include/git2.h', "#{install_dir}/include/"
    FileUtils.cp_r './include/git2',   "#{install_dir}/include/"
  end
end
