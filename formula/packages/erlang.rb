class Erlang < Package

  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  url "https://github.com/erlang/otp/archive/OTP-${version}.tar.gz"

  release version: '19.2.3', crystax_version: 1, sha256: '0'

  depends_on 'ncurses'
  depends_on 'openssl'
  # todo:
  #build_depends_on 'libcrystax'

  # ldflags_in_c_wrapper: true,
  # debug_compiler_args:  true,
  build_options setup_env:           false,
                copy_installed_dirs: [],
                gen_android_mk:      false

  build_copy 'LICENSE.txt'

  def build_for_abi(abi, toolchain,  _release, _host_dep_dirs, target_dep_dirs)
    install_dir = install_dir_for_abi(abi)
    ncurses_dir = target_dep_dirs['ncurses']
    openssl_dir = target_dep_dirs['openssl']

    xcomp_file = gen_xcomp_file(abi, toolchain, ncurses_dir, openssl_dir)

    build_env.clear

    build_env['ERL_TOP'] = Dir.pwd
    build_env['LANG'] = 'C'
    build_env['MAKEFLAGS'] = "-j#{num_jobs}"

    system './otp_build', 'autoconf'
    system './otp_build', 'configure', "--xcomp-conf=#{xcomp_file}"
    system './otp_build', 'boot', '-a'
    system './otp_build', 'release', '-a', "#{install_dir}/#{abi}"
    system './otp_build', 'tests'

    erl = "#{Dir.pwd}//bootstrap/bin/erl"
    FileUtils.cd('release/tests/test_server') do
      args = ['-eval', "'ts:install([{xcomp,\"#{xcomp_file}\"}])'",
              '-s', 'ts', 'compile_testcases',
              '-s', 'init', 'stop'
             ]
      system erl, *args
    end

    tests_dir = "#{package_dir}/tests/native/#{abi}"
    FileUtils.mkdir_p tests_dir
    FileUtils.cp_r "#{install_dir}/#{abi}", package_dir
    FileUtils.cp_r "release/tests", tests_dir

    replace_shell_in "#{package_dir}/#{abi}"
    replace_shell_in tests_dir
  end

  def gen_xcomp_file(abi, toolchain, ncurses_dir, openssl_dir)
    arch = Build.arch_for_abi(abi)
    sysroot = "--sysroot=#{Build.sysroot(abi)}"
    crystax_libs_dir = "#{Global::NDK_DIR}/sources/crystax/libs/#{abi}"

    cc     = toolchain.c_compiler(arch, abi) + ' ' + sysroot
    cxx    = toolchain.cxx_compiler(arch, abi) + ' ' + sysroot
    cpp    = cc + ' ' + '-E'
    ar     = toolchain.tool(arch, 'ar')
    ranlib = toolchain.tool(arch, 'ranlib')
    ld     = toolchain.tool(arch, 'ld')

    cflags   = toolchain.cflags(abi)
    cflags  += ' -mthumb' if abi =~ /^armeabi/
    cppflags = "-I#{ncurses_dir}/include -I#{openssl_dir}/include"
    ldflags  = toolchain.ldflags(abi) + " -fPIE -pie -L#{ncurses_dir}/libs/#{abi} -L#{openssl_dir}/libs/#{abi}"
    ded_ldflags = toolchain.ldflags(abi) + " -shared -Wl,-Bsymbolic -L#{openssl_dir}/libs/#{abi} -L#{crystax_libs_dir}"

    conf_args = ["--disable-hipe",
                 "--without-javac",
                 "--disable-dynamic-ssl-lib",
                 "--disable-silent-rules",
                 "--with-ssl=#{openssl_dir}"
                ]

    file = "#{Dir.pwd}/xcomp-crystax-#{abi}.conf"
    File.open(file, 'w') do |f|
      f.puts "## -*-shell-script-*-"
      f.puts "erl_xcomp_build=guess"
      f.puts "erl_xcomp_host=\"#{host_for_abi(abi)}\""
      f.puts "erl_xcomp_configure_flags=\"#{conf_args.join(' ')}\""
      f.puts "erl_xcomp_sysroot=\"#{Build.sysroot(abi)}\""
      f.puts "CC=\"#{cc}\""
      f.puts "CXX=\"#{cxx}\""
      f.puts "CPP=\"#{cpp}\""
      f.puts "AR=\"#{ar}\""
      f.puts "LD=\"#{ld}\""
      f.puts "RANLIB=\"#{ranlib}\""
      f.puts "CFLAGS=\"#{cflags}\""
      f.puts "CPPFLAGS=\"#{cppflags}\""
      f.puts "LDFLAGS=\"#{ldflags}\""
      f.puts "DED_LD=\"#{cc}\""
      f.puts "DED_LDFLAGS=\"#{ded_ldflags}\""
      f.puts "DED_LD_FLAG_RUNTIME_LIBRARY_PATH="
    end
    file
  end

  def replace_shell_in(dir)
    grep_args = ['-r', '-I', '-e', '/bin/sh', dir]
    Utils.run_command('grep', *grep_args).split("\n").map { |s| s.split(':')[0] }.each do |file|
      # debug output
      #puts "  fixing file: #{file}"
      content = File.read(file).gsub('/bin/sh', '/system/bin/sh')
      File.open(file, 'w') { |f| f.write content }
    end
  end
end