#
# SSL certificates staged for Apache
#
class profile::apachecert (
  # all injected from hiera
  $id,  # identify which private key / certificate pair we should use. This usually comes from hieradata/clients/*.yaml
        # see dist/profile/files/apache-cert/$id{,-bundle}.crt and profile::apache-cert::secret-key-$id
) {
  include apache
  include apache::mod::ssl

  # certificates and apache config to let Apache recognize this file
  file { '/etc/apache2/certificate.crt':
    source  => "puppet:///modules/${module_name}/apachecert/${id}.crt",
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
  file { '/etc/apache2/bundle.crt':
    source  => "puppet:///modules/${module_name}/apachecert/${id}-bundle.crt",
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
  file { '/etc/apache2/conf.d/ssl.conf':
    source  => "puppet:///modules/${module_name}/apachecert/ssl.conf",
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

  file { '/etc/apache2/server.key':
    content => lookup("profile::apachecert::secret-key-${id}"),
    mode    => '0600',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
}
