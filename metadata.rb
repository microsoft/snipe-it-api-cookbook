name 'snipeit_api'
maintainer 'Microsoft'
maintainer_email 'chef@microsoft.com'
license 'MIT'
description 'Installs/Configures snipeit_api'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.2.2'
chef_version '>= 14.0'
source_url 'https://github.com/Microsoft/snipe-it-api-cookbook'
issues_url 'https://github.com/Microsoft/snipe-it-api-cookbook/issues'

supports 'mac_os_x'

depends 'chef-sugar'
depends 'chef-vault'
