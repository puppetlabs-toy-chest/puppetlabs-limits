# Class: limits
#
# This module manages limits
#
# Parameters:
#    $title - should be of the form domain/(hard|soft-)/item if $domain, $type
#             and $item are not present
#    $value - value of limit, use undef to remove the value
#    $domain - limit domain
#    $type - limit type (hard|soft|-)
#    $item - limit item
#
# Actions:
#    updates the limit file with the value provided
define limits::fragment (
  $value  = undef,
  $domain = undef,
  $type   = undef,
  $item   = undef,
  $file   = undef,
) {
  include limits
  $key = split($title, '/')
  $limit_domain = $domain ? {
    undef   => $key[0],
    default => $domain,
  }
  $limit_type = $type ? {
    undef   => $key[1],
    default => $type,
  }
  $limit_item = $item ? {
    undef   => $key[2],
    default => $item,
  }
  $limits_file = $file ? {
    undef   => $limits::limits_file,
    default => $file,
  }

  # These regex are taken from the augeas Limits lens
  # https://github.com/hercules-team/augeas/blob/master/lenses/limits.aug
  if ( $limit_type   !~ /^(hard|soft|-)$/ or
        $limit_domain !~ /^([%@]?[A-Za-z0-9_.-]+|\*)$/ or
        $limit_item   !~ /^[A-Za-z]+$/ ) {
    fail("invalid limits format: ${limit_domain}/${limit_type}/${limit_item}")
  }

  if ( $value and $value !~ /^([A-Za-z0-9_.\/-]+)$/ ) {
    fail("invalid value for limits: ${value}. See man 5 limits.conf")
  }

  $context = "/files${limits_file}"

  $path_list  = "domain[.=\"${limit_domain}\"][./type=\"${limit_type}\" and ./item=\"${limit_item}\"]"
  $path_exact = "domain[.=\"${limit_domain}\"][./type=\"${limit_type}\" and ./item=\"${limit_item}\" and ./value=\"${value}\"]"

  if $value {
    augeas { "limits_conf/${title}":
      context => $context,
      incl    => $limits_file,
      lens    => 'Limits.lns',
      onlyif  => "match ${path_exact} size == 0",
      changes => [
                  # remove all matching to the $domain, $type, $item, for any $value
                  "rm ${path_list}",
                  # insert new node at the end of tree
                  "set domain[last()+1] ${limit_domain}",
                  # assign values to the new node
                  "set domain[last()]/type ${limit_type}",
                  "set domain[last()]/item ${limit_item}",
                  "set domain[last()]/value ${value}",
                  ],
    }
  } else {
    augeas { "limits_conf/${title}":
      context => $context,
      incl    => $limits_file,
      lens    => 'Limits.lns',
      onlyif  => "match ${path_list} size != 0",
      changes => [
                  # remove all matching to the $domain, $type, $item, for any $value
                  "rm ${path_list}",
                  ],
    }
  }
}
