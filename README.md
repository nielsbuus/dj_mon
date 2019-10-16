A Rails engine based frontend for Delayed Job. 

## Installation

Add this line to your application's Gemfile:

    gem 'dj_mon', github: "nielsbuus/dj_mon"

And then execute:

    $ bundle

## Usage

Mount it in `routes.rb`

    mount DjMon::Engine => 'dj_mon'

DJ Mon has NO authentication by default, so unless you are running a trusted environment or wants the world to see your delayed jobs, you better add some.

In previous versions, this was done by defining a proc that was essentially monkey patching `DjMon::DjReportsController`. For unknown reasons it doesn't work anymore. I don't know if it's new rubies or new rails that are breaking it. Instead I have introduced a cleaner/simpler approach.

By default, DjMons controller will inherit from `ApplicationController`, but you can change this in an initializer and use a controller that is properly secured.

In `config/application.rb`, add the following inside the module, you add the following line

    config.dj_mon.parent_controller = "Admin::AdminController"

Now visit `http://localhost:3000/dj_mon` and profit!
