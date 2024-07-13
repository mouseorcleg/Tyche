//
//  CalculatorTextField.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/07/2024.
//

import SwiftUI

struct CalculatorTextField: View {
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

#Preview {
    @State var value = 10
    return CalculatorTextField(textFieldName: "Example title", value: $value)
}
