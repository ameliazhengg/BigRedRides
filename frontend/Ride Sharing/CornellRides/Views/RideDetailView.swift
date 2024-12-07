import SwiftUI

struct RideDetailView: View {
    let ride: Ride
    @Environment(\.presentationMode) var presentationMode
    @State private var showingContactSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Top Card: Route & Price
                VStack(spacing: 12) {
                    // Route
                    HStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            Text("To")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ride.destination)
                                .font(.title3)
                                .bold()
                            Text(ride.departureLocation)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    
                    Divider()
                    
                    // Price
                    HStack {
                        Text("$\(String(format: "%.2f", ride.price))")
                            .font(.title.bold())
                            .foregroundColor(.blue)
                        Text("per person")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Ride Info
                VStack(spacing: 20) {
                    // Time & Seats
                    HStack(spacing: 30) {
                        // Date
                        VStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundColor(.orange)
                            Text(ride.departureTime.formatted(date: .abbreviated, time: .omitted))
                                .font(.subheadline.bold())
                        }
                        
                        // Time
                        VStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                            Text(ride.departureTime.formatted(date: .omitted, time: .shortened))
                                .font(.subheadline.bold())
                        }
                        
                        // Seats
                        VStack(spacing: 6) {
                            Image(systemName: "person.2.fill")
                                .font(.title2)
                                .foregroundColor(.purple)
                            Text("\(ride.availableSeats) seats")
                                .font(.subheadline.bold())
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                
                // Driver Info
                VStack(alignment: .leading, spacing: 16) {
                    Text("Driver")
                        .font(.headline)
                    
                    HStack(spacing: 16) {
                        // Profile Image
                        if ride.driver.profileImage.hasPrefix("http") {
                            AsyncImage(url: URL(string: ride.driver.profileImage)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 44))
                            }
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 44))
                                .frame(width: 60, height: 60)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ride.driver.name)
                                .font(.headline)
                            Text(ride.driver.email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Button(action: { showingContactSheet = true }) {
                            Image(systemName: "message.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Trip Details
                if !ride.description.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Trip Details")
                            .font(.headline)
                        Text(ride.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingContactSheet) {
            ContactSheet(driver: ride.driver)
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
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(driver.name)
                                .font(.headline)
                            Text("Driver")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Button(action: {
                        if let url = URL(string: "tel://\(driver.phoneNumber)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label {
                            Text(driver.phoneNumber)
                        } icon: {
                            Image(systemName: "phone.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                    
                    Button(action: {
                        if let url = URL(string: "mailto:\(driver.email)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Label {
                            Text(driver.email)
                        } icon: {
                            Image(systemName: "envelope.circle.fill")
                                .foregroundColor(.blue)
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
