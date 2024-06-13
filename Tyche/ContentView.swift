//
//  ContentView.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/06/2024.
//

import SwiftUI

struct ContentView: View {
    @State var grossSalary: Int = 0
    
    @State var personalContributionPercents: Int = 0
    @State var personalContributionPounds: Int = 0
    
    @State var companyContributionPercents: Int = 0
    @State var companyContributionPounds: Int = 0
    
    @State var privatePensionPercents: Int = 0
    @State var privatePensionPounds: Int = 0
    
    @State var calculatedTax: Int = 0
    @State var calculatedNI: Int = 0
    
    @State var netSalaryMontly: Int = 0
    @State var netSalaryYearly: Int = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Yearly salary") {
                    TextFieldStack(textFieldName: "Gross salary:", value: $grossSalary, endSymbol: "£")
                }
                Section("Pention contribution") {
                    TextFieldStackWPersents(textFieldName: "Personal:", percents: $personalContributionPercents, pounds: $personalContributionPounds)
                    TextFieldStackWPersents(textFieldName: "Company:", percents: $companyContributionPercents, pounds: $companyContributionPounds)
                    TextFieldStackWPersents(textFieldName: "Private:", percents: $privatePensionPercents, pounds: $personalContributionPounds)
                }
                Section("Additional withdrawls") {
                    NameAndSum(name: "Tax", sum: $calculatedTax)
                    NameAndSum(name: "NI", sum: $calculatedNI)
                }
                Section("Net salary") {
                    NameAndSum(name: "Monthly take home", sum: $netSalaryMontly)
                    NameAndSum(name: "Yearly income", sum: $netSalaryYearly)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Calculate your pension")
        }
    }
}

#Preview {
    ContentView()
}

struct TextFieldStack: View {
    var textFieldName: String
    @Binding var value: Int
    var endSymbol: String
    
    var body: some View {
        HStack{
            Text(textFieldName)
                .fontWeight(.medium)
                .frame(width: 110, alignment: .leading)
            Spacer()
            Text(endSymbol)
                .foregroundColor(.purple)
                .fontWeight(.bold)
            TextField(textFieldName, value: $value, formatter: NumberFormatter())
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.purple, lineWidth: 1))
                .frame(minWidth: 100, maxWidth: 120)
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
