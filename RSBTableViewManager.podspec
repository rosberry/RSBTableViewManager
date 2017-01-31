Pod::Spec.new do |s|

s.name                = "RSBTableViewManager"
s.version             = "1.0.0"
s.summary             = "iOS library for UITableView managing"
s.homepage            = "https://bitbucket.org/rosberryteam/rsbtableviewmanager"
s.license             = 'MIT'
s.author              = { "Rosberry" => "info@rosberry.com" }
s.source              = { :git => "https://github.com/rosberry/RSBTableViewManager", :tag => s.version }
s.platform            = :ios, '7.0'
s.requires_arc        = true
s.source_files        = 'RSBTableViewManager/*.{h,m}'

s.subspec 'Protocols' do |ss|
ss.source_files       = 'RSBTableViewManager/Protocols/*.{h,m}'
end

s.subspec 'Items' do |ss|
ss.dependency 'RSBTableViewManager/Protocols'
ss.source_files       = 'RSBTableViewManager/Items/*.{h,m}'
end

end
