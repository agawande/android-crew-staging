require 'fileutils'
require_relative 'spec_consts.rb'


FileUtils.rm_rf 'tmp'
FileUtils.rm_rf Crew_test::NDK_COPY_DIR
FileUtils.rm_rf File.join(Crew_test::NDK_DIR, 'prebuilt')
FileUtils.rm_rf File.join(Crew_test::DOCROOT_DIR, 'utilities')

FileUtils.cd(Crew_test::DATA_DIR) { FileUtils.rm Dir['curl-*.rb', 'libarchive-*.rb', 'ruby-*.rb', 'xz-*.rb'] }
FileUtils.rm_f Crew_test::DATA_READY_FILE
