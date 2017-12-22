Pod::Spec.new do |s|
	# info
	s.name = 'LocalizableCheck'
	s.version = '0.1.0'
	s.summary = 'A command line tool to check your strings files.'
	s.description = <<-DESC
	This tool will help you check if your Localizable.stirngs files are in sync, and update your strings from interface builder files.
	DESC
	s.homepage = 'https://github.com/djbe/LocalizableCheck'
	s.authors = {
		'David Jennes' => 'david.jennes@gmail.com'
	}
	s.license = {
		:type => 'MIT',
		:file => 'LICENSE'
	}
	
	# files
	s.source = {
		http: "https://github.com/djbe/LocalizableCheck/releases/download/#{s.version}/LocalizableCheck-#{s.version}.zip"
	}
	s.preserve_paths = '*'
	s.exclude_files  = '**/file.zip'
end
