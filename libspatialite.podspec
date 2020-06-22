Pod::Spec.new do |s|
  s.name     = 'libspatialite'
  s.version  = '4.3.0'
  s.license  = 'MPL-1.1'
  s.summary  = '...'
  s.homepage = 'https://www.gaia-gis.it/fossil/libspatialite/home'
  s.authors  = { 'Alessandro Furieri': 'a.furieri@lqt.it' }

  # v = s.version.to_s.split('.')
  # archive_name = "sqlite-amalgamation-"+v[0]+v[1].rjust(2, '0')+v[2].rjust(2, '0')+"00"
  archive_name = "libspatialite-4.3.0"
  # s.source   = { :http => "https://www.sqlite.org/#{Time.now.year}/#{archive_name}.zip" }
  s.source   = { :http => "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/#{archive_name}.zip" }
  s.requires_arc = false

  s.default_subspecs = 'core'

  s.prepare_command = "curl -OL #{s.source.html} ; ls . ; #{archive_name}/configure --enable-geos=no --enable-proj=no --enable-freexl=no"

  s.subspec 'core' do |ss|
    # ss.source_files = "#{archive_name}/sqlite*.{h,c}"
    ss.source_files =
      "#{archive_name}/*.h",
      "#{archive_name}/src/{gaiaaux,gaiageo}/gg_*.c",
      "#{archive_name}/src/{dxf,gaiaexif,geopackage,md5,shapefiles,spatialite,srsinit,versioninfo,virtualtext,wfs}/*.c"
    # ss.public_header_files = "#{archive_name}/sqlite3.h"
    ss.osx.pod_target_xcconfig = { 'OTHER_CFLAGS' => '$(inherited) -DHAVE_USLEEP=1' }
    # Disable OS X / AFP locking code on mobile platforms (iOS, tvOS, watchOS)
    sqlite_xcconfig_ios = { 'OTHER_CFLAGS' => '$(inherited) -DHAVE_USLEEP=1 -DSQLITE_ENABLE_LOCKING_STYLE=0' }
    ss.ios.pod_target_xcconfig = sqlite_xcconfig_ios
    ss.tvos.pod_target_xcconfig = sqlite_xcconfig_ios
    ss.watchos.pod_target_xcconfig = sqlite_xcconfig_ios
  end
end
