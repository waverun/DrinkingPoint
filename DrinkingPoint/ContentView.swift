//
//  ContentView.swift
//  DrinkingPoint
//
//  Created by shay moreno on 21/01/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var imagePickerViewModel = ImagePickerViewModel()

    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all) // Set the background color for the entire view

            VStack(spacing: 0) { // Remove spacing to eliminate gaps
                MapView()
                    .onAppear {
                        MapViewManager.shared.onLocationSelected = { location, radius in
                            MapViewManager.shared.updateRegion(userLocation: location, radius: radius)
                        }
                    }
                ButtonsView(imagePickerViewModel: imagePickerViewModel)
            }
        }
        .sheet(isPresented: $imagePickerViewModel.isImagePickerPresented) {
            ImagePickerView(image: self.$imagePickerViewModel.image)
        }
    }
}
