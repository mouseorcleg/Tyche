//
//  PensionSummary.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/06/2024.
//

import SwiftUI
import Charts

struct GraphSection: Identifiable {
    var id = UUID()
    var name: String
    var contributionInPounds: Int
}

struct PensionSummary: View {
    
    @ObservedObject var vm: PensionContributionViewModel
    
    @State var sections: [GraphSection] = []
    
    var firstSectionFooter: some View {
        HStack {
            Spacer()
            Text("Assumptions based on retirement @60")
                .fontDesign(.monospaced)
            Spacer()
        }
    }
    
    var pensionChart: some View {
        Chart(sections) { section in
            SectorMark(
                angle: .value("\(section.name)", section.contributionInPounds),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .cornerRadius(5)

            .foregroundStyle(by: .value("Name", section.name))
        }
        .scaledToFit()
        .chartLegend(alignment: .center, spacing: 16)
        .chartBackground { chartProxy in
          GeometryReader { geometry in
            if let anchor = chartProxy.plotFrame {
              let frame = geometry[anchor]
              Text("Contributions")
                .position(x: frame.midX, y: frame.midY)
            }
          }
        }
    }
    
    var body: some View {
        Form {
            Section(header: Text(""), footer: firstSectionFooter) {
                VStack {
                    pensionChart
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
            updateSections()
        })
        .onChange(of: vm.taxFreeLumpSumPercent, {
            vm.updatePensionSummary()
        })
        .onChange(of: vm.currentAge, {
            vm.calculatePension()
            updateSections()
            vm.updatePensionSummary()
        })
        .navigationTitle("💰 Pension summary")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func updateSections() {
        let personalContribution = GraphSection(name: "Personal", contributionInPounds: vm.personalContributionTotal)
        let companyContribution = GraphSection(name: "Company", contributionInPounds: vm.companyContributionTotal)
        let privateContribution = GraphSection(name: "Private", contributionInPounds: vm.privatePensionTotal)
        self.sections = [personalContribution, companyContribution, privateContribution]
    }
}

#Preview {
    NavigationView{
        PensionSummary(vm: PensionContributionViewModel())
    }
}
