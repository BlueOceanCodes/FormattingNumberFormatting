//
//  ContentView.swift
//  FormattingAway
//
//  Created by Alex Hudson on 6/27/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var count = 987_123_659_150_101
    @State private var numberString = ""
    @State private var depth = 0.0
    @State private var separateWords = [String]()
    //  let timer: Timer?

    var body: some View {
        VStack {

            VStack(spacing: 0) {

                TextField("Enter Large Number", text: $numberString)
                    .padding()
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .onChange(of: numberString) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.numberString = filtered
                        }
                    }

                Text(separateWords.first ?? "")
                    .frame(depth: depth)
                    .padding(32)
                    .font(.largeTitle)

                Button("Start animation") {

                    guard let count = Int(numberString) else { return }

                    separateWords = formatSeparateWords(count: count)

                    Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in

                        depth += 2

                        if depth > 400 {
                            depth = 0
                            separateWords.remove(at: 0)
                            if separateWords.isEmpty {
                                timer.invalidate()
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {

        }
    }

    private func createWordFrom(_ count: Int) -> String {

        let value = NSNumber(value: count)

        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut

        return formatter.string(from: value)!.capitalized
    }

    private func formatSeparateWords(count: Int) -> [String] {

        var words = [String]()

        let trillions = count / 1_000_000_000_000

        let billions = count % 1_000_000_000_000 / 1_000_000_000

        let millions = count % 1_000_000_000 / 1_000_000

        let thousands = count % 1_000_000 / 1_000

        let hundreds = count % 1_000 / 100

        let tens = count % 100

        if trillions > 0 {
            words.append(createWordFrom(trillions) + " Trillion")
        }

        if billions > 0 {
            words.append(createWordFrom(billions) + " Billion")
        }

        if millions > 0 {
            words.append(createWordFrom(millions) + " Million")
        }

        if thousands > 0 {
            words.append(createWordFrom(thousands) + " Thousand")
        }

        if hundreds > 0 {
            var hundredsWord = createWordFrom(hundreds) + " Hundred"
            print(tens)

            if tens > 0 {
                hundredsWord.append(" " + createWordFrom(tens))
            }
            words.append(hundredsWord)
        }

        return words
    }
}

#Preview {
    ContentView()
        .glassBackgroundEffect()
}
