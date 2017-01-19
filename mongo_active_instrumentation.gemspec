Gem::Specification.new do |s|
  s.name        = 'mongo_active_instrumentation'
  s.version     = '0.1.1'
  s.authors     = ['Edgars Beigarts']
  s.summary     = 'ActiveSupport/Rails instrumentation for Mongo'
  s.email       = ['edgars.beigarts@gmail.com']
  s.description = s.summary
  s.homepage    = 'https://github.com/ebeigarts/mongo_active_instrumentation'
  s.license     = 'MIT'

  s.files       = Dir['{lib}/**/*'] + %w( README.md LICENSE.txt )

  s.add_dependency 'mongo', '>= 2.1'
  s.add_dependency 'activesupport', '>= 4.2'
end
