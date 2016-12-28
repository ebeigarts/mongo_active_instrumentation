# Mongo Active Instrumentation

Pretty logging with colors for mongo/mongoid with rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongo_active_instrumentation'
```

And then execute:

```bash
$ bundle
```

## Example

```
Started GET "/" for ::1
Processing by PagesController#show as HTML
  Parameters: {"path"=>"/"}
  Mongo (2.1ms)  {"find"=>"users", "filter"=>{"deleted_at"=>nil, "_id"=>BSON::ObjectId('4f796a9e83fa26bacf000360')}, "limit"=>1, "singleBatch"=>true}
Completed 200 OK in 54ms (Views: 9.7ms | Mongo: 2.1ms)
```

vs

```
Started GET "/" for ::1
Processing by PagesController#show as HTML
  Parameters: {"path"=>"/"}
MONGODB | localhost:27017 | app_development.find | STARTED | {"find"=>"users", "filter"=>{"deleted_at"=>nil, "_id"=>BSON::ObjectId('4f796a9e83fa26bacf000360')}, "limit"=>1, "singleBatch"=>true}
MONGODB | localhost:27017 | app_development.find | SUCCEEDED | 0.0021879999999999998s
Completed 200 OK in 54ms (Views: 9.7ms)
```
