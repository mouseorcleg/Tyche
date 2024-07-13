//
//  CalculatorView.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/06/2024.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject var vm = PensionContributionViewModel()
    
    var submitButton: some View {
        HStack{
            Spacer()
            NavigationLink(destination: PensionSummary(vm: vm), label: {
                Text("See Pension Summary")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(width: 280, height: 44)
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.top, 16)
            })
            Spacer()
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Yearly salary") {
                    CalculatorTextField(textFieldName: "Gross salary:", value: $vm.grossSalary, frontSymbol: "£")
                }
                Section("Pention contribution") {
                    CalculatorTextFieldWithPersents(textFieldName: "Personal:", percents: $vm.personalContributionPercents, pounds: $vm.personalContributionPounds)
                    CalculatorTextFieldWithPersents(textFieldName: "Company:", percents: $vm.companyContributionPercents, pounds: $vm.companyContributionPounds)
                    CalculatorTextFieldWithPersents(textFieldName: "Private:", percents: $vm.privatePensionPercents, pounds: $vm.privatePensionPounds)
                }
                Section("Additional withdrawls") {
                    TitleAndSum(title: "Tax", sum: $vm.calculatedTax)
                    TitleAndSum(title: "NI", sum: $vm.calculatedNI)
                }
                Section(header: Text("Net salary"), footer: submitButton) {
                    TitleAndSum(title: "Monthly take home", sum: $vm.netSalaryMontly)
                    TitleAndSum(title: "Yearly income", sum: $vm.netSalaryYearly)
                }
            }
            .onChange(of: vm.grossSalary, {
                vm.updateAllCalculations()
            })
            .onChange(of: vm.personalContributionPercents, {
                vm.updateAllCalculations()
            })
            .onChange(of: vm.companyContributionPercents, {
                vm.updateAllCalculations()
            })
            .onChange(of: vm.privatePensionPercents, {
                vm.updateAllCalculations()
            })
            .formStyle(.grouped)
            .navigationTitle("🪙 Calculate your pension")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CalculatorView()
}
