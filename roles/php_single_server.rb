name "php_single_server"
description "Everything required to run the PHP version of the Panomira API, on one server."

lib_dir = 'lib'
# defaults for debian
php_defaults = {
  'conf_dir' => '/etc/php5/cli',
  'ext_conf_dir' => '/etc/php5/conf.d',
  'fpm_user' => 'www-data',
  'fpm_group' => 'www-data',
  'prefix_dir' => '/usr/local'
}

override_attributes(
  "php" => {
    "install_method" => "package",

    # NOTE: INSTALLATION FROM SOURCE DIDN'T WORK OUT (some packages conflict with manual PHP installation)

    # "install_method" => "source",
    # "version" => "5.5.11",
    # "checksum" => "9156fcd4b254cbfa9a7535f931da29d5",
    #
    # 'conf_dir' => php_defaults['conf_dir'],
    # 'ext_conf_dir' => php_defaults['ext_conf_dir'],
    # 'fpm_user' => php_defaults['fpm_user'],
    # 'fpm_group' => php_defaults['fpm_group'],
    # 'prefix_dir' => php_defaults['prefix_dir'],
    #
    # # note: adding "--enable-bcmath=shared" didn't prevent amqp component to complain on missing bcmath
    # # note: excluded "--with-libevent-dir" option (wasn't recognized)
    # 'configure_options' => %W{--prefix=#{php_defaults['prefix_dir']}
    #                            --with-libdir=#{lib_dir}
    #                            --with-config-file-path=#{php_defaults['conf_dir']}
    #                            --with-config-file-scan-dir=#{php_defaults['ext_conf_dir']}
    #                            --with-pear
    #                            --enable-fpm
    #                            --with-fpm-user=#{php_defaults['fpm_user']}
    #                            --with-fpm-group=#{php_defaults['fpm_group']}
    #                            --with-zlib
    #                            --with-openssl
    #                            --with-kerberos
    #                            --with-bz2
    #                            --with-curl
    #                            --enable-ftp
    #                            --enable-zip
    #                            --enable-exif
    #                            --with-gd
    #                            --enable-gd-native-ttf
    #                            --with-gettext
    #                            --with-gmp
    #                            --with-mhash
    #                            --with-iconv
    #                            --with-imap
    #                            --with-imap-ssl
    #                            --enable-sockets
    #                            --enable-soap
    #                            --with-xmlrpc
    #                            --with-mcrypt
    #                            --enable-mbstring
    #                            --with-t1lib
    #                            --with-mysql
    #                            --with-mysqli=/usr/bin/mysql_config
    #                            --with-mysql-sock
    #                            --with-sqlite3
    #                            --with-pdo-mysql
    #                            --with-pdo-sqlite
    #                            --enable-bcmath=shared}
  }
)

run_list(
  # note: this recipe is also defined in "php_webserver" role - do not remove either one
  "recipe[panomira_php_api::apache2_php_upgrade]",

  "role[memcached]",
  "role[php_mysql_master]",
  "role[php_neo4j_main]",
  "role[php_neo4j_contacts]",
  "role[php_webserver]",
)
