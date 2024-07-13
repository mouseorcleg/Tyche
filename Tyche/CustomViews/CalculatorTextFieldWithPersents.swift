//
//  CalculatorTextFieldWithPersents.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/07/2024.
//

import SwiftUI

struct CalculatorTextFieldWithPersents: View {
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


#Preview {
    @State var percents = 10
    @State var pounds = 1000
    return CalculatorTextFieldWithPersents(textFieldName: "Example value",
                                           percents: $percents,
                                           pounds: $pounds)
}
