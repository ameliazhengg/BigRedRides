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
        applyFilter("All")
    }
    
    func applyFilter(_ filter: String) {
        var filtered = rides
        
        // Apply date filter
        filtered = filtered.filter { ride in
            switch filter {
            case "Today":
                return Calendar.current.isDateInToday(ride.departureTime)
            case "Tomorrow":
                return Calendar.current.isDateInTomorrow(ride.departureTime)
            case "This Week":
                let currentWeek = Calendar.current.component(.weekOfYear, from: Date())
                let rideWeek = Calendar.current.component(.weekOfYear, from: ride.departureTime)
                return currentWeek == rideWeek
            default:
                return true
            }
        }
        
        // Apply search filter if search text exists
        if !searchText.isEmpty {
            filtered = filtered.filter { ride in
                ride.destination.lowercased().contains(searchText.lowercased()) ||
                ride.departureLocation.lowercased().contains(searchText.lowercased())
            }
        }
        
        filteredRides = filtered
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
        applyFilter("All")
    }
}
