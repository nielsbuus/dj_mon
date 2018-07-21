# Warning
This fork of `dj_mon` gem was created to add a **Reset all** button which resets (deletes existing job and creates same job with same name and parameters) all present jobs.

# DJ Mon [![Build Status](https://secure.travis-ci.org/akshayrawat/dj_mon.png?branch=master)](http://travis-ci.org/akshayrawat/dj_mon)

A Rails engine based frontend for Delayed Job. It also has an [iPhone app](http://itunes.apple.com/app/dj-mon/id552732872).

## Demo
* [A quick video tour](http://www.akshay.cc/dj_mon/)
* [Sandbox Demo URL](http://dj-mon-demo.herokuapp.com/)
* Username: `dj_mon`
* Password: `password`
* [Demo Source](https://github.com/akshayrawat/dj_mon_demo)

## Installation

Add this line to your application's Gemfile:

    gem 'dj_mon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dj_mon

## Note

* Supports `activerecord` and `mongoid`.
* Supports `ruby 1.8.7` or higher for `activerecord`. `delayed_job_mongoid` depends
  on `mongoid 3.0` which needs ruby 1.9, so there is no support for `ruby
  1.8.7` for that.


## Usage

If you are using Rails =< 3.1, or if `config.assets.initialize_on_precompile` is set to false, then add this to `config/environments/production.rb`.

    config.assets.precompile += %w( dj_mon/dj_mon.js dj_mon/dj_mon.css)

Mount it in `routes.rb`

    mount DjMon::Engine => 'dj_mon'

DJ Mon has NO authentication by default, so unless you are running a trusted environment or wants the world to see your delayed jobs, you better add some.

This is done by defining a monkey patch proc in a Rails initializer, which is then executed inside any controller class definitions that DJ Mon contains.

E.g. in `config/initializers/dj_mon.rb`

    YourApp::Application.config.dj_mon.auth_monkey_patch = -> {
       before_action :totally_simple_authentication

       def totally_simple_authentication
          if params[:totally_secret_token] == env['DJ_MON_TOKEN']
            cookies[:dj_mon_authenticated] = true
          end
          cookies[:dj_mon_authenticated].present?
       end
    }

Now visit `http://localhost:3000/dj_mon` and profit!

## iPhone App
* The iPhone app is written in RubyMotion. [Source](https://github.com/akshayrawat/dj_mon_iphone).
* [On App Store](http://itunes.apple.com/app/dj-mon/id552732872)

## Contributing

### Things to do
* Mostly in the iPhone app. Mentioned in the [README](https://github.com/akshayrawat/dj_mon_iphone).


### Running the test suite

To run the test suite, execute the following commands from the project
root:

    gem install bundler
    bundle install
    rake test:prepare
    rake

![Screenshot](https://github.com/akshayrawat/dj_mon_demo/raw/master/docs/screenshot.jpg)
