actionback
==========
[![Build Status](https://travis-ci.org/sweatshirtio/actionback.svg?branch=master)](https://travis-ci.org/sweatshirtio/actionback) [![Gem Version](https://badge.fury.io/rb/actionback.svg)](http://badge.fury.io/rb/actionback)

`Action Pack` can now go **BACK!**

Deserialize URLs to resources or resource IDs.  Action Back uses your defined routes and controllers to determine the correct resource to return.  This is great for `Hypermedia APIs` and following [HATEOAS](http://en.wikipedia.org/wiki/HATEOAS) principles in your REST APIs.

Put more simply, actionback will turn
`http://api.yourapp.com/users/3` into `#<User id:3, first_name: "Bob">`.

## Installation
Add `actionback` to your Gemfile:
```ruby
gem 'actionback'
```

## Supported Ruby/Rails versions
- ruby >= 1.9.3
- rails >= 3.0

## Deserializing URLs to Resources

### Serializers
Include `ActionBack::RouteBack` in your serializer (or wherever you may want to deserialize URLs to resources).  This will give the serializer the ability to `find` a resource given a `URL`.  Behind the scenes, `ActionBack::RouteBack` is calling on the inferred controller to return the correct resource.


Here is an example of using actionback with [Roar-Rails](https://github.com/apotonick/roar-rails)
```ruby
# Represent user
class UserRepresenter < Representable::Decorator
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia
  include ActionBack::RouteBack

  property :name
end


# Represent awesomeness
class AwesomeRepresenter < Representable::Decorator
  include Roar::Representer::JSON
  include Roar::Representer::Feature::Hypermedia

  # Deserialize the passed in user URL to a user instance
  property :user,
    decorator: UserRepresenter,
    instance: lambda { |fragment, *args| fragment },
    deserialize: lambda { |object, fragment, *args| object.resource_from_url(fragment) }
end
```

The above example expects a URL, such as `http://api.awesomeapp.com/users/3`,
to be passed in as the value for the user property.  `AwesomeRepresenter` will then call on `ActionBack` with this URL for the correct User resource.

`#<User id:3 >` will now officially be related to **Awesome**! You're happy because that couldn't have been easier.  `#<User id:3 >` is happy because he/she is now awesome :satisfied:.  Hooray... Everyones happy :+1:

#### ActionBack::RouteBack Methods
- `#resource_from_url(url):` returns ActiveRecord model instantce

- `#id_from_url(url):`       returns ActiveRecord model ID

### Controllers
`ActionBack::ControllerAdditions` adds class methods to your controller to give it the ability to return a resource/resource ID given route params.

Controllers are inferred in actionback via rails routes.  They are called on to return the classified resource or resource ID.  You will need to include `ActionBack::ControllerAdditions` in the relevant controllers.

```ruby
class AwesomeController < ApplicationController
  include ActionBack::ControllerAdditions
end
```

## Custom Behavior
### Controllers
It is more likely that you will want to override `ActionBack::Controller` methods.

By overriding the controller methods, you can create your own complex queries to fetch resources.  You will want to do this for queries that involve more than one ID, such as for nested routes.

For example:
```ruby
class GroupUsersController < ApplicationController
  include ActionBack::ControllerAdditions

  def self.fetch_resource(route_params)
    User.where id: route_params[:id], group_id: route_params[:group_id]
  end

  def self.fetch_resource_id(route_params)
    { id: route_params[:id], group_id: route_params[:group_id] }
  end
end
```
