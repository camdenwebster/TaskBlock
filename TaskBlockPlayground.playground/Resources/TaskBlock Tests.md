### Test tasks are filtered by category for given block
#### Test ID: 1
* Given a block has a preferred category of "Work"
* And at least one task has a category of "Work"
* And at least one task has a category of "School"
* When the day is planned
* Then only tasks with a category of "Work" should be added to the block
### Test tasks are sorted by difficulty for given block
#### Test ID: 2
* Given a block has a preferred difficulty of "High"
* And at least one task has a difficulty of "High"
* And at least one task has a difficulty of "Medium"
* And all the tasks have the same priority
* When the day is planned
* Then  tasks with a difficulty of "High" should be added to the block first
* And any tasks with a difficulty of "Medium" or "Low" should be added to the block second
### Test tasks are sorted by priority, highest to lowest
#### Test ID: 3
* Given at least one task has a priority of "High"
* And at least one task has a priority of "Medium"
* And at least one task has a priority of "Low"
* When the day is planned
* Then any tasks with a priority of "High" should be added to the block first
* And any tasks with a priority of "Medium" should be added to the block second
* And any tasks with a priority of "Low" should be added to the block third
### Test tasks are limited to block time limit by total task duration
#### Test ID: 4
* Given there are two blocks, each with a specified duration of 90 minutes
* And the cumulative duration of a list of tasks is greater than 90 minutes
* When the day is planned
* Then only as many tasks as will fit into the first 90 minute block should be added to the block
* And the remaining tasks should be added to the second block
