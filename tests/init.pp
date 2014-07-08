class { 'limits':
  limits_file => '/tmp/limits.conf'
}
limits::fragment { 'joe/soft/nproc':
  value => '10'
}
limits::fragment { 'my-limit':
  value  => '10',
  domain => 'foo',
  type   => 'hard',
  item   => 'locks',
}
limits::fragment { 'dan/soft/nproc':
  value => '10'
}
#delete this value
limits::fragment { 'dan/hard/nproc':
}
limits::fragment { '*/-/locks':
  value => '10',
  file  => '/tmp/locks.conf',
}

# From man 5 limits.conf
# *               soft    core            0
# *               hard    nofile          512
# @student        hard    nproc           20
# @faculty        soft    nproc           20
# @faculty        hard    nproc           50
# ftp             hard    nproc           0
# @student        -       maxlogins       4
# :123            hard    cpu             5000
# @500:           soft    cpu             10000
# 600:700         hard    locks           10
limits::fragment { '*/soft/core':
  value => '0'
}
limits::fragment { '*/hard/nofile':
  value => '512'
}
limits::fragment { '@student/hard/nproc':
  value => '20'
}
limits::fragment { '@faculty/soft/nproc':
  value => '20'
}
limits::fragment { '@faculty/hard/nproc':
  value => '50'
}
limits::fragment { 'ftp/hard/nproc':
  value => '0'
}
limits::fragment { '@student/-/maxlogins':
  value => '4'
}
# the following 3 fragments from the man limits.conf cause agueas to fail
# limits::fragment { ':123/hard/cpu':
#   value => '5000'
# }
# limits::fragment { '@500:/soft/cpu':
#   value => '100000'
# }
# limits::fragment { '600:700/hard/locks':
#   value => '10'
# }


# testing errors
# limits::fragment { 'joe':
#   value => '10'
# }
# limits::fragment { 'joe/locks':
#   value => '10'
# }
# limits::fragment { 'joe /-/locks':
#   value => '10'
# }
# limits::fragment { 'joe/foo/locks':
#   value => '10'
# }
# limits::fragment { 'joe/ /locks':
#   value => '10'
# }
