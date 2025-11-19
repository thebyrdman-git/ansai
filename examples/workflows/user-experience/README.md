# Progress Tracker - Beautiful CLI Progress Visualization

## Purpose

A reusable bash library for displaying beautiful progress bars and task status in terminal applications. Makes automation transparent and engaging for users.

## What It Demonstrates

- **User Experience Patterns:** Beautiful CLI interfaces with emojis and progress bars
- **Reusable Functions:** Exportable bash functions that can be sourced by other scripts
- **Visual Feedback:** Real-time progress updates and status indicators
- **Error Handling:** Clear error states with visual indicators

## Prerequisites

- Bash 4.0+
- Terminal with UTF-8 and emoji support
- No external dependencies required

## Configuration

No configuration needed! This is a pure bash library with no external dependencies.

## Usage Examples

### Example 1: Simple Progress Bar

```bash
#!/bin/bash
source ansai-progress-tracker

# Process 10 items
for i in {1..10}; do
    show_progress $i 10 "Processing Items"
    # Your work here
    sleep 0.5
done
```

**Output:**
```
🎯 Processing Items: [████████████████████████████████░░░░░░░░░░░░░░░░] 64% (7/10)
```

### Example 2: Task Status Tracking

```bash
#!/bin/bash
source ansai-progress-tracker

show_task_status "Backup Database" "starting" "5 minutes"
# Do backup work
show_task_status "Backup Database" "complete"
```

**Output:**
```
🚀 STARTING: Backup Database
   ⏱️  ETA: 5 minutes
✅ COMPLETE: Backup Database
```

### Example 3: Multi-Step Task with Progress

```bash
#!/bin/bash
source ansai-progress-tracker

run_with_progress 3 "Deploy Application" \
    "echo 'Building...'" \
    "echo 'Testing...'" \
    "echo 'Deploying...'"
```

**Output:**
```
🚀 STARTING: Deploy Application
🎯 Deploy Application: [█████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 33% (1/3)
🎯 Deploy Application: [██████████████████████████████████░░░░░░░░░░░░░░] 66% (2/3)
🎯 Deploy Application: [██████████████████████████████████████████████████] 100% (3/3) ✅ COMPLETE!
✅ COMPLETE: Deploy Application
```

### Example 4: Custom Task with Error Handling

```bash
#!/bin/bash
source ansai-progress-tracker

total_files=100
current=0

for file in /path/to/files/*; do
    ((current++))
    show_progress $current $total_files "Syncing Files"
    
    if ! process_file "$file"; then
        echo ""
        show_task_status "File Processing" "error"
        exit 1
    fi
done
```

### Example 5: Integration with Your Workflow

```bash
#!/bin/bash
# my-automation-script
source ansai-progress-tracker

# Step 1: Preparation
show_task_status "Environment Setup" "starting"
setup_environment
show_task_status "Environment Setup" "complete"

# Step 2: Main work with progress
total=50
for i in $(seq 1 $total); do
    show_progress $i $total "Processing Data"
    process_item $i
done

# Step 3: Cleanup
show_task_status "Cleanup" "starting"
cleanup_files
show_task_status "Cleanup" "complete"
```

## Available Functions

### `show_progress <current> <total> [task_name]`

Display a progress bar with percentage.

**Parameters:**
- `current`: Current step number (integer)
- `total`: Total number of steps (integer)
- `task_name`: Optional task description (default: "Task")

**Example:**
```bash
show_progress 7 10 "Downloading Files"
# Output: 🎯 Downloading Files: [███████████████████████░░░░░░░░] 70% (7/10)
```

### `show_task_status <task_name> <status> [eta]`

Display task status with appropriate emoji and color.

**Parameters:**
- `task_name`: Name of the task
- `status`: One of: `starting`, `progress`, `working`, `complete`, `error`, `paused`, `warning`
- `eta`: Optional estimated time remaining

**Example:**
```bash
show_task_status "Database Backup" "starting" "2 minutes"
# Output: 🚀 STARTING: Database Backup
#            ⏱️  ETA: 2 minutes
```

### `run_with_progress <total_steps> <task_name> <command1> [command2] ...`

Execute multiple commands with automatic progress tracking.

**Parameters:**
- `total_steps`: Number of commands to execute
- `task_name`: Overall task name
- `commands`: One or more commands to execute

**Example:**
```bash
run_with_progress 3 "System Update" \
    "apt update" \
    "apt upgrade -y" \
    "apt autoremove -y"
```

## Status Icons Reference

| Status | Icon | Use Case |
|--------|------|----------|
| `starting` | 🚀 | Task is beginning |
| `progress`/`working` | ⚙️ | Task is in progress |
| `complete` | ✅ | Task finished successfully |
| `error` | ❌ | Task encountered an error |
| `paused` | ⏸️ | Task is temporarily paused |
| `warning` | ⚠️ | Task completed with warnings |

## Real-World Use Cases

1. **File Processing**: Show progress when processing large batches of files
2. **Data Migration**: Track database migration steps
3. **Backup Operations**: Display backup progress and ETA
4. **Deployment Scripts**: Show deployment stages
5. **Data Synchronization**: Track sync progress across multiple sources
6. **Build Processes**: Display compilation steps
7. **Testing Suites**: Show test execution progress
8. **System Maintenance**: Track cleanup and optimization tasks

## Integration with Other ANSAI Components

This progress tracker is used by many other ANSAI workflows:

- **ansai-budget-analyzer**: Shows analysis progress
- **ansai-plex-library-organizer**: Tracks file organization
- **ansai-youtube-subscription-sync**: Shows download progress
- **ansai-dr-test**: Displays backup validation steps
- **ansai-compliance-check**: Tracks audit progress

## Customization

### Changing Progress Bar Style

Edit the `show_progress` function to use different characters:

```bash
# Default: filled="█" empty="░"
# Alternative 1: filled="=" empty=" "
# Alternative 2: filled="#" empty="-"
# Alternative 3: filled="●" empty="○"
```

### Adding Custom Status Types

Add new cases to `show_task_status`:

```bash
"archived")
    echo "📦 ARCHIVED: $task_name"
    ;;
"scheduled")
    echo "📅 SCHEDULED: $task_name"
    ;;
```

### Adjusting Speed

Change the `sleep` value in `run_with_progress`:

```bash
sleep 0.1  # Faster feedback
sleep 0.5  # Slower, more visible
sleep 0    # No delay (fastest)
```

## Building Blocks Demonstrated

- ✅ **User Experience:** Beautiful, informative CLI output
- ✅ **Reusability:** Library pattern for bash scripts
- ✅ **Error Handling:** Clear success/failure states
- ✅ **Feedback:** Real-time progress indication
- ✅ **Transparency:** Users always know what's happening

## Contributing

Want to add features? Ideas:
- Color customization
- Multiple progress bars (parallel tasks)
- Logging integration
- Time estimation based on historical data
- Progress persistence (resume from checkpoint)

## License

MIT License - Free to use and modify

---

**Part of the ANSAI Framework**  
Learn more: https://ansai.dev


