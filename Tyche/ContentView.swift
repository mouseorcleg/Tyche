//
//  ContentView.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/06/2024.
//

import SwiftUI

struct ContentView: View {
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
                    TextFieldStack(textFieldName: "Gross salary:", value: $vm.grossSalary, frontSymbol: "£")
                }
                Section("Pention contribution") {
                    TextFieldStackWPersents(textFieldName: "Personal:", percents: $vm.personalContributionPercents, pounds: $vm.personalContributionPounds)
                    TextFieldStackWPersents(textFieldName: "Company:", percents: $vm.companyContributionPercents, pounds: $vm.companyContributionPounds)
                    TextFieldStackWPersents(textFieldName: "Private:", percents: $vm.privatePensionPercents, pounds: $vm.privatePensionPounds)
                }
                Section("Additional withdrawls") {
                    NameAndSum(name: "Tax", sum: $vm.calculatedTax)
                    NameAndSum(name: "NI", sum: $vm.calculatedNI)
                }
                Section(header: Text("Net salary"), footer: submitButton) {
                    NameAndSum(name: "Monthly take home", sum: $vm.netSalaryMontly)
                    NameAndSum(name: "Yearly income", sum: $vm.netSalaryYearly)
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
    ContentView()
}

struct TextFieldStack: View {
    var textFieldName: String
    @Binding var value: Int
    var endSymbol: String?
    var frontSymbol: String?
    var bold: Bool = true
    
    var symbolInFront: some View {
        Group {
            if let frontSymbol = frontSymbol {
                Text(frontSymbol)
                    .foregroundColor(.purple)
                    .fontWeight(bold ? .bold : .semibold)
            }
        }
    }
    
    var symbolAtTheBack: some View {
        Group {
            if let endSymbol = endSymbol {
                Text(endSymbol)
                    .foregroundColor(.purple)
                    .fontWeight(bold ? .bold : .semibold)
            }
        }
    }
    
    var body: some View {
        HStack{
            Text(textFieldName)
                .fontWeight(.medium)
                .frame(width: 110, alignment: .leading)
            Spacer()
            symbolInFront
            TextField(textFieldName, value: $value, formatter: NumberFormatter())
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.purple, lineWidth: 1))
                .frame(minWidth: 100, maxWidth: 120)
            symbolAtTheBack
        }
    }
}

struct TextFieldStackWPersents: View {
    var textFieldName: String
    @Binding var percents: Int
    @Binding var pounds: Int
    
    
    var body: some View {
        HStack {
            Text(textFieldName)
                .fontWeight(.medium)
                .frame(width: 90, alignment: .leading)
            TextField(textFieldName, value: $percents, formatter: NumberFormatter())
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.purple, lineWidth: 1))
                .frame(width: 60)
            Text("%")
                .foregroundColor(.purple)
                .fontWeight(.bold)
            Spacer()
            Text("£ \(pounds)")
                .foregroundColor(.purple.opacity(0.8))
                .fontWeight(.semibold)
        }
    }
}

struct NameAndSum: View {
    var name: String
    @Binding var sum: Int
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.medium)
                .frame(maxWidth: 150, alignment: .leading)
            Spacer()
            Text("£")
                .foregroundColor(.purple.opacity(0.8))
                .fontWeight(.semibold)
            Text("\(sum)")
                .foregroundColor(.purple.opacity(0.8))
                .fontWeight(.semibold)
        }
    }
}
