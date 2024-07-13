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
    var color: Color
}

struct PensionSummary: View {
    
    @ObservedObject var vm: PensionContributionViewModel
    
    @State var sections: [GraphSection] = []
    
    var firstSectionHeader: some View {
            Text("Assumptions based on retirement @60")
    }
    
    var pensionChart: some View {
        Chart(sections) { section in
            SectorMark(
                angle: .value("\(section.name)", section.contributionInPounds),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .cornerRadius(5)
            .opacity(0.2)
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
                .foregroundColor(.purple.opacity(0.8))
                .fontWeight(.semibold)
            }
          }
        }
    }
    
    var body: some View {
        Form {
            Section(header: firstSectionHeader, footer: Text("")) {
                VStack {
                    pensionChart
                        .padding()
                    TitleAndSum(title: "Pension total", sum: $vm.pensionPot)
                }
                CalculatorTextField(textFieldName: "Tax free lump sum", value: $vm.taxFreeLumpSumPercent, endSymbol: "%")
                CalculatorTextField(textFieldName: "Your current age", value: $vm.currentAge, endSymbol: "years", bold: false)
            }
            
            Section("What's you get") {
                TitleAndSum(title: "Tax free lump sum", sum: $vm.taxFreeLumpSumPounds)
                TitleAndSum(title: "Remaining pot", sum: $vm.remainingPot)
                TitleAndSum(title: "Annual income after retirement", sum: $vm.annualIncome)
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
        let personalContribution = GraphSection(name: "Personal", contributionInPounds: vm.personalContributionTotal, color: .pink)
        let companyContribution = GraphSection(name: "Company", contributionInPounds: vm.companyContributionTotal, color: .purple)
        let privateContribution = GraphSection(name: "Private", contributionInPounds: vm.privatePensionTotal, color: .blue)
        self.sections = [personalContribution, companyContribution, privateContribution]
    }
}

#Preview {
    NavigationView{
        PensionSummary(vm: PensionContributionViewModel())
    }
}
