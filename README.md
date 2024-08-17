# AuxiliaryRails::Resourceable

[![Gem](https://img.shields.io/gem/v/auxiliary_rails_resourceable.svg)](https://rubygems.org/gems/auxiliary_rails_resourceable)

`Resourceable` module speeds up development by loading your controllers with RESTful (CRUD) actions.

It is powered with search ([ransack](https://github.com/activerecord-hackery/ransack)), pagination ([pagy](https://github.com/ddnexus/pagy)) and policies ([pundit](https://github.com/varvet/pundit)).
All these make your controllers and views much cleaner, so you can just focus on what is important.

`Resourceable` aims to be as simple and flexible as possible and suggests customization using regular method overwriting instead of tricky configs or DSLs.
Of course, it may not cover all possible cases, but if you need something really custom - just write custom code.


## Installation

Add one of these lines to your application's `Gemfile`:

```ruby
# version released to RubyGems (recommended)
gem 'auxiliary_rails_resourceable'

# or latest development version from a specific branch of the GitHub repository
gem 'auxiliary_rails_resourceable',
  git: 'https://github.com/ergoserv/auxiliary_rails_resourceable',
  branch: 'develop'
# or from a local path (for development and testing purposes)
gem 'auxiliary_rails_resourceable',
  path: '../auxiliary_rails_resourceable'
```

Copy `resources.en.yml` to `config/locales/resources.en.yml`.

Create shared views in `app/views/resources/` (or `app/views/resourceable/` if your need to share views for modules).
Recommended structure for views:
```
index.html.erb
new.html.erb
show.html.erb
edit.html.erb
_form.html.erb
_list.html.erb
_search_form.html.erb
```

## Usage

Just define `ResourcesController` and inherit controllers from it for fulfilling them with the all the basic CRUD actions.

```ruby
# app/controllers/resources_controller.rb
# @abstract
class ResourcesController < ApplicationController
  include AuxiliaryRails::Concerns::Resourceable
end

# app/controllers/products_controller.rb
class ProductsController < ResourcesController
end
```

### Customization

`Resourceable` is a very simple and clear module, just read its code and overwrite
what you need in `ResourcesController` or any of its subclasses, e.g.:

```ruby
# app/controllers/products_controller.rb
class ProductsController < ResourcesController
  # Load additional data for views
  def index
    super
    self.collection = collection.includes([:category])
  end

  protected

  # Add any additional scopes to the collection scope
  def collection_scope
    policy_scope(Product).active.in_stock
  end

  # Overwrite Pagy configs using Pagy's methods
  # https://github.com/ddnexus/pagy/blob/master/lib/pagy/backend.rb#L19
  def pagy_get_vars(collection, vars)
    vars[:items] = 250
    super
  end
end
```

## References

This gem is heavily inspired by [inherited_resources](https://github.com/activeadmin/inherited_resources) and [activeadmin](https://github.com/activeadmin/activeadmin).
It even follows the naming for helpers of `inherited_resources`, but much lighter (~250 lines of code only), with an approach of "just overwrite what you need" instead of complex configuration options. And, in simple cases, can be used as a drop-in replacement with no or just a few code changes.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ergoserv/auxiliary_rails_resourceable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ergoserv/auxiliary_rails_resourceable/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AuxiliaryRailsResourceable project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ergoserv/auxiliary_rails_resourceable/blob/master/CODE_OF_CONDUCT.md).

-------------------------------------------------------------------------------

[![alt text](https://raw.githubusercontent.com/ergoserv/auxiliary_rails/master/assets/ErgoServ_horizontalColor@sign+text+bg.png "ErgoServ - Web and Mobile Development Company")](https://www.ergoserv.com)

This gem was created and is maintained by [ErgoServ](https://www.ergoserv.com).

If you like what you see and would like to hire us or join us, [get in touch](https://www.ergoserv.com)!
