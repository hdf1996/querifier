[![CircleCI](https://dl.circleci.com/status-badge/img/gh/hdf1986/querifier/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/hdf1986/querifier/tree/main)

# Querifier

Querifier is a gem intended to easily generate queries for API's, it isn't an ORM, instead, it's a layer on top of ActiveRecord.

The most common case of use is to create simple and generic, yet powerful filtering and ordering in your API's results.

## Demo

You can check https://querifier-demo.herokuapp.com/v1/books?page=1&filter[where][title]=Season&filter[order][id]=desc for a demo of how it works

The source code of the demo is available at https://github.com/hdf1986/querifier-demo

Also, a frontend demo built in Next.js can be found at https://github.com/hdf1986/querifier-demo-frontend / https://querifier-demo-frontend.vercel.app/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'querifier'
```

And then execute:

```shell
bundle
```

If you are using rails, you can do:

```shell
rails generate querifier:install
```

## Usage
If you are using rails, you can do:

```shell
rails generate querifier:query your_model
```

it will create a query for your model, in this case it will be

```ruby
class BookQuery
  include Querifier::Queries::Default

  # If no order param is provided, then this order will be used
  # default_sort { id: :asc }
  # Configure these constants to add attributes to the ordering a filtering
  where_attributes :id # Configure your attributes here
  order_attributes :id # Configure your attributes here
end

```

After that, your query will be able to receive params like this
```ruby
# Will return an array or query with the filtered and ordered results
BookQuery.new(filter: { order: { id: desc }, where: { id: 1 } }).collection
```

This work great with Rails controllers, you can start filtering and ordering with something like this:

```ruby
class BookController < ApiController
  def index
    render json: BookQuery.new(params).collection
  end
end
```

## Indexing

Querifier does not generate any kind of database indexes automatically, It's up to you to identify which columns may need indexes on the database and to add them.

Here are some quick tips: 
- Columns you normally use for ordering or filtering, should have an index. 
- By default Rails already includes foreign keys columns for you, but not in most other columns
- Having too many indexes can be harmful depending on the scenario, try to keep it balanced


## Custom model class

Querifier will try to assume the class for your model removing the `Query` from your query classname, some examples are:
  - BookQuery => Book
  - BooksQuery => Books
  - SomeModule::BookQuery => Book

If your model isn't called like your query, you can configure it with the default_collection method, something like:

```ruby
class BookQuery
  include Querifier::Queries::Default

  # If no order param is provided, then this order will be used
  # default_sort { id: :asc }
  # Configure these constants to add attributes to the ordering a filtering
  where_attributes :id, :author_name # Configure your attributes here
  order_attributes :id # Configure your attributes here


  # This will replace the assumption with the class you send via parameter
  # The :: are optional, but I recommend you to be explicit about the modules of your class
  def self.default_collection
    ::SomeOtherClassName.all
  end

  def filter_by_author_name(value)
    @collection = @collection.joins(:author).where(authors: { name: value })
  end
end

```


## Custom filters/methods

If you reach to a case where you need a filter that's not covered by default than the default ones, you can do something like this:

```ruby
class BookQuery
  include Querifier::Queries::Default

  # If no order param is provided, then this order will be used
  # default_sort { id: :asc }
  # Configure these constants to add attributes to the ordering a filtering
  where_attributes :id, :author_name # Configure your attributes here
  order_attributes :id # Configure your attributes here

  def filter_by_author_name(value)
    @collection = @collection.joins(:author).where(authors: { name: value })
  end
end

```

You can do the same with the ordering

```ruby
class BookQuery
  include Querifier::Queries::Default

  # If no order param is provided, then this order will be used
  # default_sort { id: :asc }
  # Configure these constants to add attributes to the ordering a filtering
  where_attributes :id, :author_name # Configure your attributes here
  order_attributes :id # Configure your attributes here

  def order_by_author_name(direction)
    @collection = @collection.joins(:author).order("authors.name #{direction}")
    # Don't pannic! I know we are concatenating a "raw" value to the query, but in this case direction is being sanitized and validated in the invocation of this method
    # In case you have any doubt about it, check https://github.com/hdf1986/querifier/blob/master/lib/querifier/queries/order.rb valid_sort? method
    # Im totally open to better ways of doing this, since i didn't find a nice way to implement joined and dinamic ordering queries
  end
end

```

## Good to know
- You can create a filter_by_* or order_by_* method for any name you want to, just take care that if the field doesn't exist in the database, it will need a custom method as seen before
- The filters are executed in the order they are received from the `.new` method, this is a coincidence, so i can't ensure it will keep happening in the future
- Most of this structure is inspired by Loopback REST API for querying data (see https://loopback.io/doc/en/lb3/Querying-data.html). I don't like loopback at all, but i think this standard is a good place to start with
- There's some minor performance differences between custom methods and default ones (the custom ones being the faster ones), because we use `method_missing` magic to implement the default ones is slower
- If you don't want to use `where`, or `order`, you can include just `Querifier::Queries::Order` or `Querifier::Queries::Where` instead of `Querifier::Queries::Default`, according to your needs

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hdf1986/querifier. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Querifier project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/Querifier/blob/master/CODE_OF_CONDUCT.md).
