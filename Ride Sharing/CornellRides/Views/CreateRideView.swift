import SwiftUI

struct CreateRideView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: RidesViewModel
    
    @State private var destination = ""
    @State private var departureLocation = ""
    @State private var departureTime = Date()
    @State private var price = ""
    @State private var availableSeats = ""
    @State private var description = ""
    
    let commonDestinations = ["JFK Airport", "Syracuse", "NYC", "Boston"]
    let commonLocations = ["North Campus", "Central Campus", "West Campus", "Collegetown"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Visual route indicator
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 20) {
                            LocationField(
                                icon: "location.fill",
                                title: "From",
                                location: $departureLocation,
                                options: commonLocations
                            )
                            
                            LocationField(
                                icon: "mappin.circle.fill",
                                title: "To",
                                location: $destination,
                                options: commonDestinations
                            )
                        }
                    }
                    .padding(.vertical, 10)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                )
                
                Section {
                    DatePicker("Departure Time", selection: $departureTime, in: Date()...)
                        .datePickerStyle(.graphical)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                )
                
                Section {
                    HStack {
                        PriceField(price: $price)
                        Divider()
                            .frame(height: 30)
                        SeatsField(seats: $availableSeats)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                )
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Additional Information")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        TextEditor(text: $description)
                            .frame(height: 100)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                        .padding(.vertical, 5)
                )
            }
            .navigationTitle("Create Ride")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Post") {
                    createRide()
                }
                .disabled(!isFormValid)
                .font(.headline)
            )
        }
    }
    
    private var isFormValid: Bool {
        !destination.isEmpty &&
        !departureLocation.isEmpty &&
        !price.isEmpty &&
        !availableSeats.isEmpty &&
        Double(price) != nil &&
        Int(availableSeats) != nil
    }
    
    private func createRide() {
        guard let priceValue = Double(price),
              let seatsValue = Int(availableSeats) else { return }
        
        viewModel.createRide(
            destination: destination,
            departureLocation: departureLocation,
            departureTime: departureTime,
            price: priceValue,
            availableSeats: seatsValue,
            description: description
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct LocationField: View {
    let icon: String
    let title: String
    @Binding var location: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Picker(title, selection: $location) {
                Text("Select location").tag("")
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            
            if !options.contains(location) && !location.isEmpty {
                TextField("Custom location", text: $location)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}

struct PriceField: View {
    @Binding var price: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Price", systemImage: "dollarsign.circle.fill")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text("$")
                    .foregroundColor(.gray)
                TextField("0.00", text: $price)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

struct SeatsField: View {
    @Binding var seats: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Seats", systemImage: "person.2.fill")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("0", text: $seats)
                .keyboardType(.numberPad)
        }
    }
}
