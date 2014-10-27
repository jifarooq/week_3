class AttrAccessorObject
  def self.my_attr_accessor(*names)

    names.each do |name|
    	ivar_name = "@#{name}".to_sym

    	define_method name do
    		instance_variable_get(ivar_name)
    	end 

    	define_method "#{name}=" do |val|
    		instance_variable_set(ivar_name, val)
    	end
    end

  end #my_attr end

end
