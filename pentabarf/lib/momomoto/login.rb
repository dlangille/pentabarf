require 'digest/md5'

module Momomoto

  class Login < Base

    def initialize
    super
    @table = 'person'
    @domain = 'person'
    @fields = { :person_id    => Datatype::Integer.new( {:primary_key => true, :not_null => true, :serial => true} ),
                :login_name   => Datatype::Varchar.new( {} ),
                :password     => Datatype::Password.new( {:length => 48} ),
                :last_login   => Datatype::Timestamp.new( {:auto_update => true} )
    }
    end

    def authorize( login_name, password )
      if login_name.to_s != '' && password.to_s != '' && select( { :login_name => login_name } ) == 1
        salt = self[0].password[0..15]
        salt_bin = sprintf( "%c%c%c%c%c%c%c%c", salt[0..1].hex, salt[2..3].hex,
                            salt[4..5].hex, salt[6..7].hex, salt[8..9].hex,
                            salt[10..11].hex, salt[12..13].hex, salt[14..15].hex )
        if Digest::MD5.hexdigest( salt_bin + password ) == self[0].password[16..47]
          @current_record = 0;
          @@permissions = execute("SELECT get_permissions from get_permissions(#{self[:person_id]});").to_a.flatten
          return true
        end
      end
      return false
    end

    def dirty?()
      true
    end

  end
end
