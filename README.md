# Scheduled Run List

This cookbook allows for adding a secondary run list and a time window where the run list may be run once. The window is controlled by an attributes for the date and start and end times. If the Chef Infra client does not run during the time window, the run list will not be executed.

Run list dependencies are provided by the wrapper cookbook.

included_run_list is an attribute

## Output

When the cookbook is added to the run list, if it has a scheduled run list the output is logged:

       Recipe: scheduled_run_list::default
         * log[Scheduled Run List 'chef-client-update' scheduled for 2021-04-15 between 1500 and 1530.] action write

If a matching window is not found there is no logging message.***
Attribute set if the window was executed***

## Attributes

The format for adding InSpec profiles managed by `scheduled_run_list` is the same for adding standard compliance profiles, but the attribute namespace is `scheduled_run_list` instead of `audit` and there are 2 additional attributes of arrays. The `start` and `end` arrays map 1-1 where the first time in the `start` completes with the first time in the `end`. Following this example:

    default['scheduled_run_list']['run_list'] = 'chef-client-update'
    default['scheduled_run_list']['year'] = 2021
    default['scheduled_run_list']['month'] = 04
    default['scheduled_run_list']['day'] = 15
    default['scheduled_run_list']['time-start'] = 1500
    default['scheduled_run_list']['time-end'] = 1530

# Limitations

    If the Chef Infra client does not run during the prescribed time window the scheduled run list will not be re-scheduled.
    No support for scheduling besides date, hour, and minutes, no cron semantics.
