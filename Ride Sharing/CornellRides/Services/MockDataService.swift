import Foundation

class MockDataService {
    static let shared = MockDataService()
    
    var currentUser: User = User(
        name: "John Smith",
        email: "js123@cornell.edu",
        phoneNumber: "(607) 555-0123",
        profileImage: "person.circle.fill"
    )
    
    var users: [User] = [
        User(name: "Emma Wilson", email: "ew234@cornell.edu", phoneNumber: "(607) 555-0124", profileImage: "person.circle.fill"),
        User(name: "Michael Brown", email: "mb345@cornell.edu", phoneNumber: "(607) 555-0125", profileImage: "person.circle.fill"),
        User(name: "Sarah Davis", email: "sd456@cornell.edu", phoneNumber: "(607) 555-0126", profileImage: "person.circle.fill")
    ]
    
    var rides: [Ride] = []
    
    private init() {
        setupMockData()
    }
    
    private func setupMockData() {
        let calendar = Calendar.current
        let now = Date()
        
        // Create some sample rides
        rides = [
            Ride(
                driver: users[0],
                destination: "JFK Airport",
                departureLocation: "Cornell North Campus",
                departureTime: calendar.date(byAdding: .day, value: 1, to: now)!,
                price: 45.0,
                availableSeats: 3,
                description: "Heading to JFK Airport. Can pick up from North Campus."
            ),
            Ride(
                driver: users[1],
                destination: "New York City",
                departureLocation: "Cornell Central Campus",
                departureTime: calendar.date(byAdding: .day, value: 2, to: now)!,
                price: 50.0,
                availableSeats: 4,
                description: "Weekend trip to NYC. Comfortable SUV with space for luggage."
            ),
            Ride(
                driver: users[2],
                destination: "Syracuse",
                departureLocation: "Cornell West Campus",
                departureTime: calendar.date(byAdding: .hour, value: 5, to: now)!,
                price: 25.0,
                availableSeats: 2,
                description: "Quick trip to Syracuse. Split gas and tolls."
            )
        ]
    }
}
