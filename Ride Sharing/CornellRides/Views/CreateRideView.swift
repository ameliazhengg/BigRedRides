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
                Section(header: Text("Ride Details")) {
                    // Destination picker
                    Picker("Destination", selection: $destination) {
                        Text("Select destination").tag("")
                        ForEach(commonDestinations, id: \.self) { dest in
                            Text(dest).tag(dest)
                        }
                    }
                    
                    // Custom destination if not in common list
                    if !commonDestinations.contains(destination) {
                        TextField("Custom destination", text: $destination)
                    }
                    
                    // Departure location picker
                    Picker("Departure Location", selection: $departureLocation) {
                        Text("Select pickup location").tag("")
                        ForEach(commonLocations, id: \.self) { loc in
                            Text(loc).tag(loc)
                        }
                    }
                    
                    // Custom location if not in common list
                    if !commonLocations.contains(departureLocation) {
                        TextField("Custom pickup location", text: $departureLocation)
                    }
                    
                    DatePicker("Departure Time", selection: $departureTime, in: Date()...)
                }
                
                Section(header: Text("Price and Seats")) {
                    TextField("Price ($)", text: $price)
                        .keyboardType(.decimalPad)
                    
                    TextField("Available Seats", text: $availableSeats)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Additional Information")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
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
