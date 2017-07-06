# must be first file included
require_relative 'spec_helper.rb'

require_relative '../library/platform.rb'


describe "crew install" do
  before(:all) do
    ndk_init
  end

  before(:each) do
    clean_hold
    clean_cache
    repository_init
    repository_clone
  end

  context "without argument" do
    it "says that all archives are not found" do
      names = (Crew::Test::TOOLS_NAMES + Crew::Test::UTILS_NAMES).sort.map { |e| "host/#{e}" }
      lines = names.map { |e| Platform::NAMES.map { |p| "#{e} .* #{p}:.*#{Global::PKG_CACHE_DIR}/tools/#{e}.*" } }.flatten
      File.open('/tmp/crew.log', 'a') do |f|
        f.puts "DEBUG: names: #{names}"
        f.puts "DEBUG: lines: #{names}"
      end
      crew 'shasum'
      got = out.split("\n")
      expect(:ok).to eq(result)
      expect(lines.size).to eq(got.size)
      got.each_with_index { |g, i| expect(g).to match(lines[i]) }
    end
  end

  # context "non existing name" do
  #   it "outputs error message" do
  #     crew 'install', 'foo'
  #     expect(exitstatus).to_not be_zero
  #     expect(err.split("\n")[0]).to eq('error: no available formula for foo')
  #     expect(pkg_cache_empty?).to eq(true)
  #   end
  # end

  # context "existing formula with one release and bad sha256 sum of the downloaded file" do
  #   it "outputs error message" do
  #     copy_formulas 'libbad.rb'
  #     file = File.join(Global::PKG_CACHE_DIR, Global::NS_DIR[:target], "libbad-1.0.0_1.#{Global::ARCH_EXT}")
  #     crew 'install', 'libbad'
  #     expect(exitstatus).to_not be_zero
  #     expect(err.split("\n")[0]).to eq("error: bad SHA256 sum of the file #{file}")
  #     expect(in_pkg_cache?(:target, 'libbad', '1.0.0', 1)).to eq(true)
  #   end
  # end

  # context "existing formula with one release, no dependencies, specifing only name" do
  #   it "outputs info about installing existing release" do
  #     copy_formulas 'libone.rb'
  #     file = "libone-1.0.0_1.#{Global::ARCH_EXT}"
  #     url = "#{Global::DOWNLOAD_BASE}/packages/libone/#{file}"
  #     crew 'install', 'libone'
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("calculating dependencies for libone: \n"          \
  #                       "  dependencies to install: \n"                    \
  #                       "downloading #{url}\n"                             \
  #                       "checking integrity of the archive file #{file}\n" \
  #                       "unpacking archive\n")
  #     expect(in_pkg_cache?(:target, 'libone', '1.0.0', 1)).to eq(true)
  #   end
  # end

  # context "existing formula with one release, no dependencies, specifing name and version" do
  #   it "outputs info about installing existing release" do
  #     copy_formulas 'libone.rb'
  #     file = "libone-1.0.0_1.#{Global::ARCH_EXT}"
  #     url = "#{Global::DOWNLOAD_BASE}/packages/libone/#{file}"
  #     crew 'install', 'libone:1.0.0'
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("calculating dependencies for libone: \n"          \
  #                       "  dependencies to install: \n"                    \
  #                       "downloading #{url}\n"                             \
  #                       "checking integrity of the archive file #{file}\n" \
  #                       "unpacking archive\n")
  #     expect(in_pkg_cache?(:target, 'libone', '1.0.0', 1)).to eq(true)
  #   end
  # end

  # context "existing formula with one release, no dependencies, specifing full release info" do
  #   it "outputs info about installing existing release" do
  #     copy_formulas 'libone.rb'
  #     file = "libone-1.0.0_1.#{Global::ARCH_EXT}"
  #     url = "#{Global::DOWNLOAD_BASE}/packages/libone/#{file}"
  #     crew 'install', 'libone:1.0.0:1'
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("calculating dependencies for libone: \n"          \
  #                       "  dependencies to install: \n"                    \
  #                       "downloading #{url}\n"                             \
  #                       "checking integrity of the archive file #{file}\n" \
  #                       "unpacking archive\n")
  #     expect(in_pkg_cache?(:target, 'libone', '1.0.0', 1)).to eq(true)
  #   end
  # end

  # context "existing formula with one release, no dependencies, specifing non existing version" do
  #   it "outputs info about installing existing release" do
  #     copy_formulas 'libone.rb'
  #     crew 'install', 'libone:2.0.0'
  #     expect(exitstatus).to_not be_zero
  #     expect(err.split("\n")[0]).to eq('error: libone has no release with version 2.0.0')
  #   end
  # end

  # context "existing formula with two versions and one dependency" do
  #   it "outputs info about installing dependency and the latest version" do
  #     copy_formulas 'libone.rb', 'libtwo.rb'
  #     depfile = "libone-1.0.0_1.#{Global::ARCH_EXT}"
  #     depurl = "#{Global::DOWNLOAD_BASE}/packages/libone/#{depfile}"
  #     resfile = "libtwo-2.2.0_1.#{Global::ARCH_EXT}"
  #     resurl = "#{Global::DOWNLOAD_BASE}/packages/libtwo/#{resfile}"
  #     crew 'install', 'libtwo'
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("calculating dependencies for libtwo: \n"             \
  #                       "  dependencies to install: libone\n"                 \
  #                       "installing dependencies for libtwo:\n"               \
  #                       "downloading #{depurl}\n"                             \
  #                       "checking integrity of the archive file #{depfile}\n" \
  #                       "unpacking archive\n"                                 \
  #                       "\n"                                                  \
  #                       "downloading #{resurl}\n"                             \
  #                       "checking integrity of the archive file #{resfile}\n" \
  #                       "unpacking archive\n")
  #     expect(in_pkg_cache?(:target, 'libone', '1.0.0', 1)).to eq(true)
  #     expect(in_pkg_cache?(:target, 'libtwo', '2.2.0', 1)).to eq(true)
  #   end
  # end

  # context "specific release of the existing formula with three releases and two dependencies" do
  #   it "outputs info about installing dependencies and the specified release" do
  #     copy_formulas 'libone.rb', 'libtwo.rb', 'libthree.rb'
  #     depfile1 = "libone-1.0.0_1.#{Global::ARCH_EXT}"
  #     depurl1 = "#{Global::DOWNLOAD_BASE}/packages/libone/#{depfile1}"
  #     depfile2 = "libtwo-2.2.0_1.#{Global::ARCH_EXT}"
  #     depurl2 = "#{Global::DOWNLOAD_BASE}/packages/libtwo/#{depfile2}"
  #     resfile = "libthree-2.2.2_1.#{Global::ARCH_EXT}"
  #     resurl = "#{Global::DOWNLOAD_BASE}/packages/libthree/#{resfile}"
  #     crew 'install', 'libthree:2.2.2:1'
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("calculating dependencies for libthree: \n"            \
  #                       "  dependencies to install: libone, libtwo\n"          \
  #                       "installing dependencies for libthree:\n"              \
  #                       "downloading #{depurl1}\n"                             \
  #                       "checking integrity of the archive file #{depfile1}\n" \
  #                       "unpacking archive\n"                                  \
  #                       "downloading #{depurl2}\n"                             \
  #                       "checking integrity of the archive file #{depfile2}\n" \
  #                       "unpacking archive\n"                                  \
  #                       "\n"                                                   \
  #                       "downloading #{resurl}\n"                              \
  #                       "checking integrity of the archive file #{resfile}\n"  \
  #                       "unpacking archive\n")
  #     expect(in_pkg_cache?(:target, 'libone', '1.0.0', 1)).to eq(true)
  #     expect(in_pkg_cache?(:target, 'libtwo', '2.2.0', 1)).to eq(true)
  #     expect(in_pkg_cache?(:target, 'libthree', '2.2.2', 1)).to eq(true)
  #   end
  # end

  # context "existing formula with one release from the cache" do
  #   it "outputs info about using cached file" do
  #     copy_formulas 'libone.rb'
  #     file = "libone-1.0.0_1.#{Global::ARCH_EXT}"
  #     crew_checked 'install', 'libone'
  #     crew_checked '-b', 'remove', 'libone'
  #     crew 'install', 'libone'
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("calculating dependencies for libone: \n"          \
  #                       "  dependencies to install: \n"                    \
  #                       "using cached file #{file}\n"                      \
  #                       "checking integrity of the archive file #{file}\n" \
  #                       "unpacking archive\n")
  #     expect(in_pkg_cache?(:target, 'libone', '1.0.0', 1)).to eq(true)
  #   end
  # end

  # context "existing formula with four versions, 11 releases, specifying only name" do
  #   it "outputs info about installing latest release" do
  #     copy_formulas 'libfour.rb'
  #     file = "libfour-4.4.4_4.#{Global::ARCH_EXT}"
  #     url = "#{Global::DOWNLOAD_BASE}/packages/libfour/#{file}"
  #     crew 'install', 'libfour'
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("calculating dependencies for libfour: \n"         \
  #                       "  dependencies to install: \n"                    \
  #                       "downloading #{url}\n"                             \
  #                       "checking integrity of the archive file #{file}\n" \
  #                       "unpacking archive\n")
  #     expect(in_pkg_cache?(:target, 'libfour', '4.4.4', 4)).to eq(true)
  #   end
  # end

  # context "existing formula with four versions, specifying name and version" do
  #   it "outputs info about installing latest crystax_version of the specified version" do
  #     copy_formulas 'libfour.rb'
  #     file = "libfour-3.3.3_3.#{Global::ARCH_EXT}"
  #     url = "#{Global::DOWNLOAD_BASE}/packages/libfour/#{file}"
  #     crew 'install', 'libfour:3.3.3'
  #     expect(result).to eq(:ok)
  #     expect(out).to eq("calculating dependencies for libfour: \n"         \
  #                       "  dependencies to install: \n"                    \
  #                       "downloading #{url}\n"                             \
  #                       "checking integrity of the archive file #{file}\n" \
  #                       "unpacking archive\n")
  #     expect(in_pkg_cache?(:target, 'libfour', '3.3.3', 3)).to eq(true)
  #   end
  # end
end
