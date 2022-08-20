# AuxiliaryRailsResourceable

[![Gem](https://img.shields.io/gem/v/auxiliary_rails_resourceable.svg)](https://rubygems.org/gems/auxiliary_rails_resourceable)

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'auxiliary_rails_resourceable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install auxiliary_rails_resourceable

## Usage

```ruby
# app/controllers/resources_controller.rb
# @abstract
class ResourcesController < ApplicationController
  include AuxiliaryRails::Concerns::Resourceable
end

# app/views/resources/
# - index.html.erb
# - new.html.erb
# - show.html.erb
# - edit.html.erb
# - _form.html.erb
# - _list.html.erb
# - _search_form.html.erb

# /config/locales/resources.en.yml
en:
  resources:
    create:
      notice: "%{resource_name} was successfully created."
    update:
      notice: "%{resource_name} was successfully updated."
    destroy:
      notice: "%{resource_name} was successfully destroyed."
```

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
