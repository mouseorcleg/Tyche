//
//  TitleAndSum.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/07/2024.
//

import SwiftUI

struct TitleAndSum: View {
    var title: String
    @Binding var sum: Int
    
    var body: some View {
        HStack {
            Text(title)
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

#Preview {
    @State var sum = 99
    return TitleAndSum(title: "Title", sum: $sum)
}
