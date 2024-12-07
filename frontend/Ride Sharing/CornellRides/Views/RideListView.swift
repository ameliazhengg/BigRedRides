import SwiftUI

struct RideListView: View {
    @StateObject private var viewModel = RidesViewModel()
    @State private var showingCreateRide = false
    @State private var selectedFilter = "All"
    
    let filters = ["All", "Today", "Tomorrow", "This Week"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Filter pills
                    FilterPillsView(
                        selectedFilter: $selectedFilter,
                        filters: filters,
                        onFilterSelect: { filter in
                            viewModel.applyFilter(filter)
                        }
                    )
                    
                    if viewModel.filteredRides.isEmpty {
                        EmptyStateView()
                    } else {
                        // Rides list
                        RidesList(rides: viewModel.filteredRides)
                    }
                }
            }
            .navigationTitle("Cornell Rides")
            .searchable(text: $viewModel.searchText, prompt: "Search by destination or location")
            .onChange(of: viewModel.searchText) { _ in
                viewModel.applyFilter(selectedFilter)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CreateRideButton(showingCreateRide: $showingCreateRide)
                }
            }
            .sheet(isPresented: $showingCreateRide) {
                CreateRideView(viewModel: viewModel)
            }
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "car.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No rides available")
                .font(.title2)
                .fontWeight(.medium)
            Text("Create a ride or adjust your filters")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

struct FilterPillsView: View {
    @Binding var selectedFilter: String
    let filters: [String]
    let onFilterSelect: (String) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(filters, id: \.self) { filter in
                    FilterPillButton(
                        filter: filter,
                        isSelected: selectedFilter == filter,
                        action: {
                            selectedFilter = filter
                            onFilterSelect(filter)
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }
}

struct FilterPillButton: View {
    let filter: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(filter)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct RidesList: View {
    let rides: [Ride]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(rides) { ride in
                    NavigationLink(destination: RideDetailView(ride: ride)) {
                        RideRowView(ride: ride)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

struct RideRowView: View {
    let ride: Ride
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Destination and Price
            DestinationPriceRow(ride: ride)
            
            // Time and Seats
            TimeSeatsRow(ride: ride)
        }
        .padding()
    }
}

struct DestinationPriceRow: View {
    let ride: Ride
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(ride.destination)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(ride.departureLocation)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            PriceTag(price: ride.price)
        }
    }
}

struct TimeSeatsRow: View {
    let ride: Ride
    
    var body: some View {
        HStack {
            // Time
            Label(
                formatDate(ride.departureTime),
                systemImage: "clock"
            )
            .font(.subheadline)
            .foregroundColor(.gray)
            
            Spacer()
            
            // Seats
            Label(
                "\(ride.availableSeats) seats",
                systemImage: "person.2"
            )
            .font(.subheadline)
            .foregroundColor(.gray)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today, " + date.formatted(date: .omitted, time: .shortened)
        } else if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow, " + date.formatted(date: .omitted, time: .shortened)
        } else {
            return date.formatted(date: .abbreviated, time: .shortened)
        }
    }
}

struct PriceTag: View {
    let price: Double
    
    var body: some View {
        Text("$\(String(format: "%.2f", price))")
            .font(.headline)
            .foregroundColor(.blue)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue.opacity(0.1))
            )
    }
}

struct CreateRideButton: View {
    @Binding var showingCreateRide: Bool
    
    var body: some View {
        Button(action: { showingCreateRide = true }) {
            Label("Create Ride", systemImage: "plus.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.blue)
        }
    }
}
