//
//  PensionSummary.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/06/2024.
//

import SwiftUI

struct PensionSummary: View {
    @State var pensionPot: Int = 0
    @State var taxFreeLumpSumPercent: Int = 0
    @State var currentAge: Int = 0
    
    @State var taxFreeLumpSumPounds: Int = 0
    @State var remainingPot: Int = 0
    @State var annualIncome: Int = 0
    
    var firstSectionHeader: some View {
        HStack {
            Spacer()
            Text("Assumptions based on retirement @60")
                .fontDesign(.monospaced)
            Spacer()
        }
    }
    
    var body: some View {
        Form {
            Section(header: firstSectionHeader) {
                VStack {
                    Text("Very beautiful graph")
                        .padding()
                    NameAndSum(name: "Pension total", sum: $pensionPot)
                }
            }
            
            Section() {
                TextFieldStack(textFieldName: "Tax free lump sum", value: $taxFreeLumpSumPercent, endSymbol: "%")
                TextFieldStack(textFieldName: "Your current age", value: $currentAge, endSymbol: "years", bold: false)
            }
            
            Section("What's you get") {
                NameAndSum(name: "Tax free lump sum", sum: $taxFreeLumpSumPounds)
                NameAndSum(name: "Remaining pot", sum: $remainingPot)
                NameAndSum(name: "Annual income after retirement", sum: $annualIncome)
            }
        }
        .navigationTitle("💰 Pension summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView{
        PensionSummary()
    }
}
