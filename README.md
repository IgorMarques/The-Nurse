# The Nurse

Alert whoever you want when your apps are in a bad shape. It uses [Sickbay](https://github.com/IgorMarques/sickbay) for app monitoring.

[![Code Climate](https://codeclimate.com/github/IgorMarques/The-Nurse/badges/gpa.svg)](https://codeclimate.com/github/IgorMarques/The-Nurse)
[![Build Status](https://travis-ci.org/IgorMarques/The-Nurse.svg?branch=master)](https://travis-ci.org/IgorMarques/The-Nurse)
[![Coverage Status](https://coveralls.io/repos/github/IgorMarques/The-Nurse/badge.svg?branch=master)](https://coveralls.io/github/IgorMarques/The-Nurse?branch=master)

## How does it work?

1. Register the many apps you want to be monitored (with Name, URL to be checked and the HTTP statuses that indicate your app is fine).
- Every X minutes (completely up to you) The Nurse checks your apps
- If N of last M requests (again, completely up to you) returns a status code different from the one you expect, The Nurse will warn the Doctor about it.
  - This warn is a POST request containing the name of the service, its URL and the last M HTTP codes received. This POST will be sent to whoever URL you want.

Notice: The app also registers an entry you your DB for each health check. This way you can easily go back in time and check how was your app at any given time.

## Why?

The Nurse can be used to trigger a Kill Switch mechanism in your app: When your app receives the The Nurse's request into some endpoint, it stops some critical and automatic procedure to keep going.

This can be extremely useful when dealing with a microservice architecture or when you app depends on external services.

The Nurse can be also be used as a way to monitoring your apps and warn the right people when something is bad.

## Setting up

This setup assumes you have a proper Ruby workspace setted up with:

- Ruby 2.3.1
- Rails 5.0.0.1
- PostgreSQL
- Redis

Just run:

```
$ git clone http://github.com/IgorMarques/sickbay
$ cd sickbay
$ bundle install
$ rake db:create db:migrate
```

## Configuring the app

The app runs just fine for demo right out of the box (you just need to register some apps). But before putting your instance of The Nurse into production, remember to set it properly for your own needs.

### Registering apps

Using rails console (don't worry, we have plans to add a proper web interface in the near future), create the apps/services you want to monitor. To run the console, run:

```shell
$ bundle exec rails console
```

And to create the apps, run this inside the console:

```
Service.create(name: 'ExampleService', url: 'www.example-service.com/health', allowed_codes: [200])
```

**NOTICE: The `allowed_codes` field is an array**

Now your app will be properly monitored once you run the app.

### Your Sickbay instance

By default, The Nurse uses my instance of [Sickbay](https://github.com/IgorMarques/sickbay) on Heroku (on a free tier plan) to run the checks. If you plan on using this app for real, please set your own Sickbay instance. The deploy on Heroku is pretty straightforward (you literally just need to push the code there).

After the setup, remember to set the `ENV` variable `SICKBAY_URL` to the proper URL.

### Monitoring frequency

By default, The Nurse will check the Sickbay instance every minute. You can change this by setting up the `ENV` variable `HEALTH_CHECK_RATE` to the time in minutes you desire.

### Outage criteria

By default, if 2 in the last 3 checks to the endpoint of the service return a value that is not present in the `allowed_codes` list, The Nurse will notify your Doctor endpoint. You can custom set both values by setting up the ENV variables `ENTRIES_FETCHED` and `ENTRIES_OK`.

### Unregistering apps

You can disable the monitoring for a specific app setting its `active` attribute to `false`. Only apps with the value `true` are checked.

### Warning whoever you want

Just set the variable `DOCTOR_URL` to whoever app should be notified when an outage happens. This URL should be able to receive a proper `POST` HTTP request with the params like:

```json
{
  "service_name": "TheFailingService",
  "service_url": "www.this_service_failed.com/health",
  "codes": ["200", "500", "500"]
}
```

## Running

Once everything is setted up, this will run your healthchecks :)

```shell
$ foreman start
```

This will start all the components of the app:
- A Rails server
- [Clockwork](https://github.com/Rykian/clockwork) for recurring jobs
- [Sidekiq](https://github.com/mperham/sidekiq) for background jobs

You can also start each component alone. Check the Procfile for more info.

## Other use cases

As mentioned earlier, you can use The Nurse to check the health at your app at any given time The Nurse was paying attention to it.

All health checks are stored into [Statuses](https://github.com/IgorMarques/The-Nurse/blob/master/app/models/status.rb) entries. Feel free to run the SQL or active record queries you like to fetch whatever data you want.

Example:

```ruby
2.3.1 :001 > Service.first.statuses

  Service Load (28.0ms)  SELECT  "services".* FROM "services" ORDER BY "services"."id" ASC LIMIT $1  [["LIMIT", 1]]
  Status Load (55.4ms)  SELECT "statuses".* FROM "statuses" WHERE "statuses"."service_id" = $1  [["service_id", 1]]
 => #<ActiveRecord::Associations::CollectionProxy [#<Status id: 1, code: 200, service_id: 1, created_at: "2016-11-29 19:25:31", updated_at: "2016-11-29 19:25:31">, #<Status id: 3, code: 200, service_id: 1, created_at: "2016-11-30 17:04:08", updated_at: "2016-11-30 17:04:08">, #<Status id: 6, code: 200, service_id: 1, created_at: "2016-11-30 17:04:59", updated_at: "2016-11-30 17:04:59">, #<Status id: 9, code: 200, service_id: 1, created_at: "2016-11-30 17:05:58", updated_at: "2016-11-30 17:05:58">, #<Status id: 12, code: 200, service_id: 1, created_at: "2016-11-30 17:06:59", updated_at: "2016-11-30 17:06:59">]>
```

## Testing

This app uses Rspec for testing. To run the test suit:

```shell
$ rspec
```

## Deploying

This project is compatible with heroku. Following [their tutorial](https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction) should be enough

## Plans for the future and contributing

There's still a lot to be done. Here are some features planed:

- [ ] Web interface with the live status of each registered service
- [ ] Web interface for managing (creating, editing, deleting, etc) services
- [ ] Support for reading data from multiple Sickbay instances at once

Feel free to contribute with a PR :)
