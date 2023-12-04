import Foundation
import EventKit

// Check and request access to Calendar and Reminders
public func requestCalendarAndReminderAccess() {
    let eventStore = EKEventStore()

    eventStore.requestFullAccessToEvents { granted, error in
        if granted {
            // Access to Calendar granted, proceed with using EventKit
            print("Calendar access granted")
        } else {
            // Handle denied access or error
            print("Calendar access denied")
        }
    }

    // Request access to reminders
    eventStore.requestFullAccessToReminders { granted, error in
        if granted {
            // Access to Reminders granted, proceed with using EventKit
            print("Reminder access granted")
        } else {
            // Handle denied access or error
            print("Reminder access denied")
        }
    }
}



