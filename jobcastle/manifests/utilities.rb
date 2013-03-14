define :with_parents do
    mkdir_p File.dirname(@name)
    file @name, :ensure => 'present'
end

define :mkdir_p do
    name = @name
    until name == '/'
        file name, :ensure => 'directory' unless scope.catalog.resource 'file', name
        name = File.dirname(name)
    end
end