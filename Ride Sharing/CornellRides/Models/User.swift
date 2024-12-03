import Foundation

struct User: Identifiable {
    let id: UUID
    let name: String
    let email: String
    let phoneNumber: String
    let profileImage: String // URL or system image name
    
    init(id: UUID = UUID(), name: String, email: String, phoneNumber: String, profileImage: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.profileImage = profileImage
    }
}
