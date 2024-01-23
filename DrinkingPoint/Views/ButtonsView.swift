import SwiftUI

struct ButtonsView: View {
    var body: some View {
        HStack {
            Spacer() // Spacer before the first button

            Button(action: {
                // Action for Button 1
            }) {
                Image(systemName: "house.fill")
            }
            .padding(.vertical, 8) // Reduced vertical padding
            .padding(.horizontal, 10) // Horizontal padding for touch area
            .foregroundColor(.white)

            Spacer() // Spacer between buttons

            Button(action: {
                // Action for Button 2
            }) {
                Image(systemName: "location.fill")
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundColor(.white)

            Spacer() // Spacer between buttons

            Button(action: {
                // Action for Button 3
            }) {
                Image(systemName: "person.fill")
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundColor(.white)

            Spacer() // Spacer after the last button
        }
        .padding(.top, 15) // Additional padding at the bottom to push the buttons down
        .background(Color.gray) // Gray background for the entire HStack
//        .padding(.horizontal) // Padding on the sides of the HStack
    }
}
