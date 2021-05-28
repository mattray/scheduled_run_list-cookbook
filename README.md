# Scheduled Run List

This cookbook allows for adding a secondary run list and a time window where the run list may be run once. The window is controlled by an attributes for the date and start and end times. If the Chef Infra client does not run during the time window, the run list will not be executed.

## Recipes

### default

The ``scheduled_run_list::default`` recipe must be included in the run list and any dependencies also included. A wrapper cookbook around the ``scheduled_run_list`` and the recipes to run is a convenient way to ensure dependencies are all met. See the [included test-cookbook](test/integration/test-cookbook) as an example.

### download

The ``scheduled_run_list::download`` recipe takes the
```
    node['scheduled_run_list']['download']
```
attribute and loads a JSON file similar to
```JSON
{
    "run_list": ["test_cookbook::run_list", "test_cookbook::run_list2"],
    "year": 2021,
    "month": 5,
    "day": 28,
    "time-start": 200,
    "time-end": 2100
}
```
to load a scheduled run list via a remote file. The recipe must be before the ``scheduled_run_list::default`` recipe to ensure that the attributes are loaded properly before attempting execution.

## Attributes

The format for adding InSpec profiles managed by `scheduled_run_list` is the same for adding standard compliance profiles, but the attribute namespace is `scheduled_run_list` instead of `audit` and there are 2 additional attributes of arrays. The `start` and `end` arrays map 1-1 where the first time in the `start` completes with the first time in the `end`. Following this example:

    default['scheduled_run_list']['run_list'] = ['test_cookbook::run_list']
    default['scheduled_run_list']['year'] = 2021
    default['scheduled_run_list']['month'] = 04
    default['scheduled_run_list']['day'] = 15
    default['scheduled_run_list']['time-start'] = 1500
    default['scheduled_run_list']['time-end'] = 1530

## Output

When the cookbook is added to the run list, if it has a scheduled run list the output is logged:

```
       Recipe: scheduled_run_list::default
         * log[Scheduled Run List:["test_cookbook::run_list"]] action write
         * log[Scheduled Run List:20210528 between 400 and 1500:currently 20210528-752 ] action write
```

If it is currently in the time window:
```
         * log[Scheduled Run List:EXECUTING] action write
```

If the run list is not in the time window yet:
```
         * log[Scheduled Run List:PENDING] action write
```

If the time window for the run list has passed:
```
         * log[Scheduled Run List:ENDED] action write
```

If there is not a scheduled run list but the cookbook is included:
```
         * log[NO SCHEDULED RUN LIST] action write
```

If the scheduled run list has already run, the logging reads:
```
         * log[Scheduled Run List:ALREADY EXECUTED] action write
```

### Output Attributes

Once the scheduled run list has been executed, it is recorded to the filesystem and as an attribute. The hash
```
    node['scheduled_run_list']['processed']
```
provides a set of key-value pairs of timestamps and the associated run lists that are populated from the filesystem to keep track of previous run lists.

# Limitations

    If the Chef Infra client does not run during the prescribed time window the scheduled run list will not be re-scheduled.
    No support for scheduling besides date, hour, and minutes, no cron semantics.

## TESTING

The included [kitchen.yml](kitchen.yml) and [Policfyile.rb](Policyfile.rb) provide the following tests:

### default

Update the Policfyfile.rb with the current date and the [integration test](test/integration/default/default_test.rb) with the right date and times to test running a single recipe added to the run list. The output will show
```
...
         * log[Scheduled Run List:["test_cookbook::run_list"]] action write
         * log[Scheduled Run List:20210528 between 400 and 1500:currently 20210528-534 ] action write
         * log[Scheduled Run List:EXECUTING] action write
       Recipe: test_cookbook::run_list
         * log[THIS IS THE RUN LIST RECIPE. THIS IS INSIDE THE WINDOW.] action write
       Recipe: scheduled_run_list::default
         * file[/tmp/kitchen/cache/scheduled_run_list/20210528-400-1500] action create
         * ruby_block[Scheduled Run List:COMPLETED] action run
```
indicating that the run list has been found in the window and executed. `kitchen verify` will verify the scheduled run list was executed and attributes were set by the scheduled run list. Subsequent `kitchen converge`s with the node will _not_ execute the run list again and the `kitchen verify` will show that the run list has been processed
```
     ✔  ["default", "scheduled_run_list", "processed"] is expected to include "20210528-400-1500"
     ✔  ["default", "scheduled_run_list", "year"] is expected to eq 2021
     ×  ["default", "test_cookbook"] is expected to include "run_list"
     expected nil to include "run_list", but it does not respond to `include?`
     ×  ["default", "test_cookbook"] is expected not to include "run_list2"
     expected nil not to include "run_list2", but it does not respond to `include?`
     ×  ["default", "test_cookbook", "run_list"] is expected to equal true
     expected true
          got nil
  File /tmp/kitchen/cache/scheduled_run_list/20210528-400-1500
     ✔  content is expected to match /test_cookbook::run_list/
```
but the attributes are not set, showing that it has not run again (failure is expected the second run).,

### dependency

This is identical to the ``default`` test, but it includes multiple recipes in the scheduled run list with cookbook dependencies.

### noop

This tests when no scheduled run list is provided.

### pending

This tests when the scheduled run list time window is in the future and has not executed yet.

### passed

This tests when the scheduled run list time window has already passed and was not executed.

### download
