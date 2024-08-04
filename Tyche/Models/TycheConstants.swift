//
//  TycheConstants.swift
//  Tyche
//
//  Created by Maria Kharybina on 04/08/2024.
//

import Foundation

struct Constants {
    struct TaxAllowance {
        let basicAllowance: Double
        let taperThreshold: Double
        let blindPersonsAllowance: Double
    }
    
    struct NationalInsurance {
        let lowerEarningsLimit: Double
        let primaryThreshold: Double
        let secondaryThreshold: Double
        let upperEarningsLimit: Double
        let employerRates: [Double]
        let employeeRates: [Double]
    }
    
    struct IncomeTaxBands {
        let scotland: [(Double, Double)]
        let restOfUK: [(Double, Double)]
    }
    
    let taxAllowance: TaxAllowance
    let nationalInsurance: NationalInsurance
    let incomeTax: IncomeTaxBands
}
