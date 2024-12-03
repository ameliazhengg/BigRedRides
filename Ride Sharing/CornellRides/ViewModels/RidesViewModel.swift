import Foundation

class RidesViewModel: ObservableObject {
    @Published var rides: [Ride] = []
    @Published var filteredRides: [Ride] = []
    @Published var searchText: String = ""
    
    private let dataService = MockDataService.shared
    
    init() {
        fetchRides()
    }
    
    func fetchRides() {
        rides = dataService.rides
        filterRides()
    }
    
    func filterRides() {
        if searchText.isEmpty {
            filteredRides = rides
        } else {
            filteredRides = rides.filter { ride in
                ride.destination.lowercased().contains(searchText.lowercased()) ||
                ride.departureLocation.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func createRide(destination: String, departureLocation: String, departureTime: Date, price: Double, availableSeats: Int, description: String) {
        let newRide = Ride(
            driver: dataService.currentUser,
            destination: destination,
            departureLocation: departureLocation,
            departureTime: departureTime,
            price: price,
            availableSeats: availableSeats,
            description: description
        )
        rides.append(newRide)
        filterRides()
    }
}
