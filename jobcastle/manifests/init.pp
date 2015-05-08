class jobcastle(
  $db_user      = $jobcastle::params::db_user,
  $db_password  = $jobcastle::params::db_password,
  $db_name      = $jobcastle::params::db_name,
  $init_db      = true
) inherits jobcastle::params {

  class { 'jobcastle::base': }

  class { 'jobcastle::php': }

  if $init_db {
    class { 'jobcastle::db':
      username    => $db_user,
      password    => $db_password,
      schema      => $db_name
    }
  }

}