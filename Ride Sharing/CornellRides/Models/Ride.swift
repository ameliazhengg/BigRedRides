import Foundation

struct Ride: Identifiable {
    let id: UUID
    let driver: User
    let destination: String
    let departureLocation: String
    let departureTime: Date
    let price: Double
    let availableSeats: Int
    let description: String
    var riders: [User]
    
    init(id: UUID = UUID(), driver: User, destination: String, departureLocation: String, departureTime: Date, price: Double, availableSeats: Int, description: String, riders: [User] = []) {
        self.id = id
        self.driver = driver
        self.destination = destination
        self.departureLocation = departureLocation
        self.departureTime = departureTime
        self.price = price
        self.availableSeats = availableSeats
        self.description = description
        self.riders = riders
    }
}
