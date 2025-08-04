# TaskBlock

A task manager and calendar designed to implement Time Blocking techniques. This project served as an exercise in learning UIKit while building a practical productivity application.

## Overview

TaskBlock is an iOS productivity app that helps users organize their tasks using the time blocking methodology. The app allows users to create tasks, organize them into categories, and automatically schedule them into predefined time blocks based on priority, difficulty, and category preferences.

## Core Features

- **Task Management**: Create, edit, and organize tasks in an inbox system
- **Time Blocking**: Schedule tasks into predefined time blocks throughout the day
- **Auto-Scheduling**: Automatically assign tasks to appropriate blocks based on:
  - Task category matching block preferences
  - Difficulty level alignment
  - Priority-based ordering
- **Task Categorization**: Organize tasks with custom categories
- **Flexible Task Properties**: Set priority, difficulty, size, and time estimates for each task
- **Settings Management**: Customize app appearance, calendar integration, and block configurations

## Architecture

### Design Pattern
The application follows the **Model-View-Controller (MVC)** architectural pattern, which is the standard approach for UIKit applications.

### Core Components

#### Models
- **`ToDoItem`**: Core Data entity representing individual tasks
  - Properties: title, notes, category, priority, difficulty, size, start/end dates, completion status
  - Managed through Core Data for persistence

- **`BlockItem`**: Core Data entity representing time blocks
  - Properties: title, preferred category, preferred difficulty, start/end times
  - Contains logic for auto-scheduling tasks based on preferences

#### View Controllers
- **`InboxViewController`**: Manages the task inbox where new and unscheduled tasks are stored
- **`ScheduleViewController`**: Displays tasks organized by time blocks in a sectioned table view
- **`DetailViewController`**: Handles task creation and editing with form-based interface
- **`SettingsViewController`**: Manages app configuration and preferences
- **`CategoriesTableViewController`**: Allows users to create and manage task categories

#### Views
- **Storyboard-based UI**: Interface defined using Interface Builder with programmatic customizations
- **Custom Table View Cells**: `ToDoCell` for displaying tasks with completion toggles and metadata
- **Segmented Controls**: For priority, difficulty, and size selection

### Data Layer

#### Core Data Stack
- **Persistent Container**: Configured in `AppDelegate` for Core Data management
- **Context Management**: Single managed object context for CRUD operations
- **Data Model**: `ToDoModel.xcdatamodeld` defines the entity relationships and attributes

#### Data Flow
1. User interactions in View Controllers
2. Model updates through Core Data context
3. Context saves trigger UI updates
4. Table view reloads reflect current data state

## Technologies Used

### Core Technologies
- **UIKit**: Primary framework for user interface development
- **Core Data**: Object graph and persistence framework for data management
- **Foundation**: Basic functionality and data types

### UI Components
- **UITableViewController**: Primary interface for displaying lists of tasks and settings
- **UINavigationController**: Navigation hierarchy management
- **UITabBarController**: Tab-based interface for main app sections
- **UISegmentedControl**: Priority, difficulty, and size selection
- **UIDatePicker**: Date and time selection for task scheduling
- **UITextView/UITextField**: Text input for task details

### Development Tools
- **Xcode**: Primary development environment
- **Interface Builder**: Visual interface design through storyboards
- **Instruments**: Performance analysis and debugging

## Project Structure

```
TaskBlock/
├── Models/
│   └── SettingModel/           # Settings configuration models
├── ViewControllers/            # All view controller implementations
├── ToDoItem/                   # Core Data ToDoItem entity files
├── BlockItem/                  # Core Data BlockItem entity files
├── Assets.xcassets/           # App icons and images
├── Base.lproj/                # Storyboard files
├── ToDoModel.xcdatamodeld/    # Core Data model definition
└── Supporting Files/          # App delegate, scene delegate, etc.
```

## Key Algorithms

### Auto-Scheduling Logic
The app implements intelligent task scheduling through the `BlockItem` class:

1. **Category Matching**: Tasks are first filtered by matching categories with block preferences
2. **Difficulty Sorting**: Tasks are prioritized based on how well their difficulty matches the block's preferred difficulty
3. **Priority Ordering**: Within difficulty groups, tasks are sorted by priority level
4. **Time Fitting**: Tasks are fit into available time slots within each block

### Task Management
- **Core Data Integration**: All CRUD operations go through managed object context
- **Real-time Updates**: UI responds immediately to data changes
- **Completion Tracking**: Tasks can be marked complete with timestamp recording

## Learning Objectives Achieved

This project demonstrates proficiency in:
- **UIKit Framework**: Complex view hierarchies and navigation patterns
- **Core Data**: Entity modeling, relationships, and persistence management
- **MVC Architecture**: Proper separation of concerns and data flow
- **Table View Management**: Dynamic content, editing, and custom cells
- **User Interface Design**: Storyboard usage and programmatic UI updates
- **Settings Management**: UserDefaults integration and preference handling

## Future Enhancements

Potential areas for expansion include:
- **Calendar Integration**: Sync with Apple Calendar for external event awareness
- **Cloud Sync**: iCloud integration for cross-device synchronization
- **Advanced Scheduling**: Machine learning for improved auto-scheduling
- **Analytics**: Task completion tracking and productivity insights
- **Notifications**: Reminders and time block alerts

## Development Notes

This application was built as a learning exercise to explore UIKit development patterns and Core Data integration. The focus was on implementing clean architecture, proper data management, and intuitive user experience design principles.
