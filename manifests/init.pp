# Class: limits
#
# Class responsible for setting the global limits file to be updated
#
# Parameters:
#  - final file to be written to
#  - directory to manage on RedHat
#
# Actions:
#
class limits(
  $limits_file = '/etc/security/limits.conf',
  $limits_dir = '/etc/security/limits.d/'
) {
  if $::osfamily == 'RedHat' {
    file { $limits_dir:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      recurse => true,
      purge   => true,
      force   => true
    }
  }
}
