import SwiftUI

struct RideListView: View {
    @StateObject private var viewModel = RidesViewModel()
    @State private var showingCreateRide = false
    
    var body: some View {
        NavigationView {
            List(viewModel.filteredRides) { ride in
                NavigationLink(destination: RideDetailView(ride: ride)) {
                    RideRowView(ride: ride)
                }
            }
            .navigationTitle("Cornell Rides")
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { _ in
                viewModel.filterRides()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateRide = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingCreateRide) {
                CreateRideView(viewModel: viewModel)
            }
        }
    }
}

struct RideRowView: View {
    let ride: Ride
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(ride.destination)
                    .font(.headline)
                Spacer()
                Text("$\(String(format: "%.2f", ride.price))")
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
            
            HStack {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                Text(ride.departureLocation)
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.blue)
                Text(ride.departureTime, style: .date)
                    .font(.subheadline)
            }
            
            HStack {
                Image(systemName: "person.2.fill")
                    .foregroundColor(.purple)
                Text("\(ride.availableSeats) seats available")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}
