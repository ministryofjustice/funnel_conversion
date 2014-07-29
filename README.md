funnel_conversion
=================

Deploying to Heroku
-------------------

Commands to get started:

    git clone git@github.com:ministryofjustice/funnel_conversion.git

    cd funnel_conversion

    bundle

    brew install heroku-toolbelt
    
    heroku create --region eu

    heroku apps:rename [your-app-name]

    heroku config:set email=[google analytics account email]
    heroku config:set password=[google application password]

    heroku config

    heroku keys:add

    git push heroku master

API Usage
---------

There are two URL endpoints.

* Today's completion rate, for use with Geckoboard's 'Text' Custom Widget:


    http://[your-app-name].herokuapp.com/todays_completion_rate/[profile_id]/[goal_id]

* Last x days completion rate, for use with Geckoboard's 'Number and Secondary Stat' Custom Widget:


    http://[your-app-name].herokuapp.com/last_x_days_completion_rate/[days]/[profile_id]/[goal_id]
