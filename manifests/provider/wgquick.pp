# @summary Manage the wg quick components of a wireguard setup
# @api private
#
define wireguard::provider::wgquick (
  String[1] $interface = $title,
  Enum['present', 'absent'] $ensure = 'present',
  Wireguard::Peers $peers = [],
  Integer[1024, 65000] $dport = Integer(regsubst($title, '^\D+(\d+)$', '\1')),
  Array[Hash[String,Variant[Stdlib::IP::Address::V4::CIDR,Stdlib::IP::Address::V6::CIDR]]] $addresses = [],
) {
  assert_private()
  $params = {
    'interface' => $interface,
    'dport'     => $dport,
    'peers'     => $peers,
    'addresses' => $addresses,
  }

  file { "/etc/wireguard/${interface}.conf":
    ensure  => $ensure,
    content => epp("${module_name}/wireguard_conf.epp", $params),
    owner   => 'root',
    mode    => '0600',
  }
}