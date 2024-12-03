import SwiftUI

struct RideDetailView: View {
    let ride: Ride
    @Environment(\.presentationMode) var presentationMode
    @State private var showingContactSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading) {
                        Text(ride.driver.name)
                            .font(.title2)
                            .bold()
                        Text(ride.driver.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Ride Details
                VStack(alignment: .leading, spacing: 15) {
                    DetailRow(icon: "mappin.circle.fill",
                             title: "Destination",
                             detail: ride.destination)
                    
                    DetailRow(icon: "location.circle.fill",
                             title: "Departure",
                             detail: ride.departureLocation)
                    
                    DetailRow(icon: "clock.fill",
                             title: "Time",
                             detail: ride.departureTime.formatted())
                    
                    DetailRow(icon: "dollarsign.circle.fill",
                             title: "Price",
                             detail: "$\(String(format: "%.2f", ride.price))")
                    
                    DetailRow(icon: "person.2.fill",
                             title: "Available Seats",
                             detail: "\(ride.availableSeats)")
                }
                .padding()
                
                // Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.headline)
                    Text(ride.description)
                        .foregroundColor(.gray)
                }
                .padding()
                
                // Contact Button
                Button(action: {
                    showingContactSheet = true
                }) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Contact Driver")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingContactSheet) {
            ContactSheet(driver: ride.driver)
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let detail: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(detail)
                    .font(.body)
            }
        }
    }
}

struct ContactSheet: View {
    let driver: User
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading) {
                            Text(driver.name)
                                .font(.headline)
                            Text(driver.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        // Handle phone call
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text(driver.phoneNumber)
                        }
                    }
                    
                    Button(action: {
                        // Handle email
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text(driver.email)
                        }
                    }
                }
            }
            .navigationTitle("Contact Driver")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
