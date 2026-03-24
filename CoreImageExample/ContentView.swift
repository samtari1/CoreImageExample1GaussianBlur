//
//  ContentView.swift
//  CoreImageExample
//
//  Created by Quanpeng Yang on 3/23/26.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var picture = UIImage(named: "llama") ?? UIImage(systemName: "photo")!

    var body: some View {
        VStack(spacing: 20) {
            Button("Apply Filter") {
                Task {
                    await applyFilter()
                }
            }
            .buttonStyle(.borderedProminent)

            Image(uiImage: picture)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding()
    }

    func applyFilter() async {
        let context = CIContext()
        let blurFilter = CIFilter.gaussianBlur()
        
        // Convert UIImage to CIImage
        guard let inputCIImage = CIImage(image: picture) else { return }
        blurFilter.inputImage = inputCIImage
        blurFilter.radius = 5
        
        // Get the output and convert back to UIImage
        if let output = blurFilter.outputImage {
            // We use the original extent or a cropped extent to avoid blurred edges expanding the image
            if let image = context.createCGImage(output, from: inputCIImage.extent) {
                let finishedImage = UIImage(cgImage: image)
                
                // Update UI on the main actor
                await MainActor.run {
                    picture = finishedImage
                }
            }
        }
    }
}
