actions :add, :delete, :set_permissions, :clear_permissions

attribute :user,         :kind_of => String,  :name_attribute => true
attribute :password,     :kind_of => String
attribute :vhosts,       :kind_of => Array,   :default => ["/"]
attribute :permissions,  :kind_of => String,  :default => '".*" ".*" ".*"'
attribute :tags,         :kind_of => String
