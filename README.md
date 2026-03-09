# Advanced_SQL_MajorProject1

## How To run System

## System Arcitecture 
This is where the system arcitecture is laid out for anyone working on the project. things like what each program will read and right. tables within the database and logcial flows for each program itself
___
### Workstation Simulation:
Simulates the behavior of a real workstation using worker attributes and production rules.
#### Logical Flow
- Worker Logs in
- Reads worker info form DB
- Reads Config / Station Info / maybe assigned order info
- determines expected build tioming from worker experience or skill level
- runs the production logic
- Andon display only reads and shows the state
#### Reads/Writes
Reads
- Worker login / Worker id
- Worker Experience level or efficiency rating
- Workstation info
- Assigned Order / lamp type
- configuration values
- bin / material avilability
  
Writes
- Lamp started
- lamp Completed
- Lamp Failed
- Part/Bin consumption
- Current station status
___
### Visual Representation (Andon Display)
Displays the current state of a selected workstation. Shows whether the workstation is currently working, finished, halted, or waiting. Also displays worker information, workstation information, current order/lamp type, material/bin status, and a short recent activity log.
#### Logical Flow
- Input worker to attach to
- Reads Worker Info From DB
- Reads Config / Station Info / maybe assigned order info
- formates data to wpf
- updates display every x time
#### Reads/Writes
Reads
- Worker login / Worker id
- Workstation info
- Assigned Order / lamp type
- bin / material avilability
- workstation log maybe?

Writes
- None
___
### Runner
Simulates the physical refill confirmation button used by a runner. It monitors low-bin alerts, allows the runner to confirm a refill, and records missed or completed refill actions.
#### Logical Flow
- Reads low-bin alerts and bin status from the database
- Checks whether any bins are flagged as low/pending refill
- Enables the refill button for bins that need attention
- Calculates remaining response time using the alert timestamp
- Waits for runner button press
- If button is pressed, writes refill confirmation to the DB
- If timer reaches zero without button press, updates alert status to missed/overdue
- If button is pressed after deadline, still records the refill and updates status/logs accordingly
#### Reads/Writes
Reads
- bin levels
- low-bin flag / alert status
- alert timestamp
- workstation/bin identity

Writes
- Refill confirmation / button press outcome
- Alert status updates
- log of button press
- log of failure to press button
___
Note: When a bin is flagged as missed, this does not mean the bin will not be refilled. It only indicates that the refill action did not occur within the required time window. The runner may still refill the bin afterward. The missed flag is recorded for logging and future operational analysis.
### Assembly Line
Main assembly line dashboard that displays the current overall state of production. It shows workers, workstation statuses, order progress, bin levels, active flags, recent logs, and production metrics in a kanban-style layout.
#### Logical Flow
- Reads live system data from the DB
- Reads worker, workstation, order, bin, alert, and log information
- Formats bin levels to show current level and max capacity
- Displays current bin flags / alert states
- Displays order status and workers currently assigned
- Displays worker status in a kanban-style layout
- Displays recent running logs
- Displays production metrics such as total produced, total failed, and average build time
- Refreshes every X seconds
#### Reads/Writes
Reads
- bin levels
- low-bin flags / alert status
- Alert timestamps
- order info
- worker info
- current work station information
- Last x amount of logs
- Production totals and metrics

Writes
- None
___
Note: This would also include number of total fog lights produced, failed, average time for fog light creation and other data deemed nescary to the company
### Config Table
Administrative tool used to manage system configuration values and editable production data. It allows authorized users to update settings that affect workstation behavior, bin limits, order values, timing rules, and other adjustable parts of the system.
#### Logical Flow
- Admin opens configuration tool
- admin login
- Reads current configuration and editable system values from the DB
- Displays data in a table/grid style interface
- Admin edits values such as bin capacities, thresholds, workstation settings, order values, timing multipliers, and other configurable fields
- Validates edited input
- Writes approved changes back to the DB
- Other programs pick up updated values during their next refresh/read cycle
#### Reads/Writes
Read 
- Configuration values
- Bin settings and capacities
- Low-bin threshold values
- Workstation settings
- Order defaults or editable order values
- Timing / simulation modifiers
- Possibly worker role or admin permission info

Writes
- Updated configuration values
- Updated bin settings and capacities
- Updated threshold values
- Updated workstation settings
- Updated order/configurable production values
- Log of configuration changes
___
Note: This tool acts as an admin interface for maintaining system behavior without requiring direct database edits. It should only be accessible by authorized users.
### Database
This is our once source of truth within the system. each program communicates with the database and updates the information with its own updated knowledge. 
___
