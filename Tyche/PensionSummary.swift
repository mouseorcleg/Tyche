//
//  PensionSummary.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/06/2024.
//

import SwiftUI

struct PensionSummary: View {
    
    @ObservedObject var vm: PensionContributionViewModel
    
    var firstSectionFooter: some View {
        HStack {
            Spacer()
            Text("Assumptions based on retirement @60")
                .fontDesign(.monospaced)
            Spacer()
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text(""), footer: firstSectionFooter) {
                VStack {
                    Text("Very beautiful graph")
                        .padding()
                    NameAndSum(name: "Pension total", sum: $vm.pensionPot)
                }
                TextFieldStack(textFieldName: "Tax free lump sum", value: $vm.taxFreeLumpSumPercent, endSymbol: "%")
                TextFieldStack(textFieldName: "Your current age", value: $vm.currentAge, endSymbol: "years", bold: false)
            }
            
            Section("What's you get") {
                NameAndSum(name: "Tax free lump sum", sum: $vm.taxFreeLumpSumPounds)
                NameAndSum(name: "Remaining pot", sum: $vm.remainingPot)
                NameAndSum(name: "Annual income after retirement", sum: $vm.annualIncome)
            }
        }
        .onAppear(perform: {
            vm.calculatePension()
            vm.updatePensionSummary()
        })
        .onChange(of: vm.taxFreeLumpSumPercent, {
            vm.updatePensionSummary()
        })
        .onChange(of: vm.currentAge, {
            vm.calculatePension()
            vm.updatePensionSummary()
        })
        .navigationTitle("💰 Pension summary")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView{
        PensionSummary(vm: PensionContributionViewModel())
    }
}
