//
//  PensionContributionViewModel.swift
//  Tyche
//
//  Created by Maria Kharybina on 13/06/2024.
//

import Foundation

class PensionContributionViewModel: ObservableObject {
    @Published var grossSalary: Int = 0
    
    @Published var personalContributionPercents: Int = 0
    @Published var personalContributionPounds: Int = 0
    
    @Published var companyContributionPercents: Int = 0
    @Published var companyContributionPounds: Int = 0
    
    @Published var privatePensionPercents: Int = 0
    @Published var privatePensionPounds: Int = 0
    
    @Published var calculatedTax: Int = 0
    @Published var calculatedNI: Int = 0
    
    @Published var netSalaryMontly: Int = 0
    @Published var netSalaryYearly: Int = 0
    
    @Published var pensionPot: Int = 0
    @Published var taxFreeLumpSumPercent: Int = 25
    @Published var currentAge: Int = 30
    
    @Published var taxFreeLumpSumPounds: Int = 0
    @Published var remainingPot: Int = 0
    @Published var annualIncome: Int = 0
    
    @Published var personalContributionTotal: Int = 0
    @Published var privatePensionTotal: Int = 0
    @Published var companyContributionTotal: Int = 0
    
    var personalTaxAllawance: Int = 12570
    var basicRateMax: Int = 50270
    var higherRateMax: Int = 125140
    
    let constants = Constants(
        taxAllowance: Constants.TaxAllowance(basicAllowance: 12570, taperThreshold: 100000, blindPersonsAllowance: 2870),
        nationalInsurance: Constants.NationalInsurance(lowerEarningsLimit: 6396, primaryThreshold: 12570, secondaryThreshold: 9100, upperEarningsLimit: 50270, employerRates: [0.138, 0.138], employeeRates: [0.12, 0.02]),
        incomeTax: Constants.IncomeTaxBands(scotland: [(0.19, 12570), (0.20, 14732), (0.21, 25000), (0.41, 43430), (0.46, 150000)], restOfUK: [(0.20, 12570), (0.40, 50270), (0.45, 150000)])
    )
    
    func updateAllCalculations() {
        updatePesonalContribution()
        updateCompanyContribution()
        updatePrivatePension()
        updateTax()
        updateNI()
        updateNetIncome()
    }
    
    func calculatePension() {
        self.pensionPot = calculateTotalPension().totalPension
        self.personalContributionTotal = calculateTotalPension().personalContributionTotal
        self.companyContributionTotal = calculateTotalPension().companyContributionTotal
        self.privatePensionTotal = calculateTotalPension().privatePensionTotal
    }
    
    func updatePensionSummary() {
        self.taxFreeLumpSumPounds = pensionPot / 100 * taxFreeLumpSumPercent
        self.remainingPot = pensionPot - taxFreeLumpSumPounds
        self.annualIncome = remainingPot / 30
    }
    
    func calculateTotalPension() -> (totalPension: Int, personalContributionTotal: Int, privatePensionTotal: Int, companyContributionTotal: Int) {
        let remainingYears = 60 - currentAge
        var totalPension: Int = 0
        var personalContributionTotal: Int = 0
        var privatePensionTotal: Int = 0
        var companyContributionTotal: Int = 0
        for _ in 0..<remainingYears {
            let oneYearPersonalContribution = self.personalContributionPounds
            let oneYearPrivatePension = self.privatePensionPounds
            let oneYearCompanyContribution = self.companyContributionPounds
            let oneYearTotalContribution = oneYearPersonalContribution + oneYearPrivatePension + oneYearCompanyContribution
            let oneYearContributionInterest = oneYearTotalContribution / 100 * 7
            let oneYearTotalContributionWithInterest = oneYearTotalContribution + oneYearContributionInterest
            totalPension += oneYearTotalContributionWithInterest
            personalContributionTotal += oneYearPersonalContribution
            privatePensionTotal += oneYearPrivatePension
            companyContributionTotal += oneYearCompanyContribution
        }
        return (totalPension, personalContributionTotal, privatePensionTotal, companyContributionTotal)
    }
    
    
    func calculateTotalPension() -> Int {
        let remainingYears = 60 - currentAge
        var totalPension: Int = 0
        for _ in 0..<remainingYears {
            let oneYearPensionContribution = self.personalContributionPounds + self.privatePensionPounds + self.companyContributionPounds
            let oneYearPensionContributionInterest = oneYearPensionContribution / 100 * 7
            let oneYearPensionContributionWithInterest = oneYearPensionContribution + oneYearPensionContributionInterest
            totalPension += oneYearPensionContributionWithInterest
        }
        return totalPension
    }
    
    func updateNetIncome() {
        self.netSalaryYearly = grossSalary - personalContributionPounds - privatePensionPounds - calculatedTax - calculatedNI
        self.netSalaryMontly = netSalaryYearly / 12
    }
    
    func updatePesonalContribution() {
        self.personalContributionPounds = grossSalary / 100 * self.personalContributionPercents
    }
    
    func updateCompanyContribution() {
        self.companyContributionPounds = grossSalary / 100 * self.companyContributionPercents
    }
    
    func updatePrivatePension() {
        self.privatePensionPounds = grossSalary / 100 * self.privatePensionPercents
    }
    
    func updateTax() {
        self.calculatedTax = Int(calculateIncomeTax(taxableIncome: Double(grossSalary - personalTaxAllawance), constants: constants, residentInScotland: false).total)
    }
    
    func calculateIncomeTax(taxableIncome: Double, constants: Constants, residentInScotland: Bool) -> (total: Double, breakdown: [(rate: Double, amount: Double)]) {
        let taxBands = residentInScotland ? constants.incomeTax.scotland : constants.incomeTax.restOfUK
        
        var incomeTax = 0.0
        var remainingIncome = taxableIncome
        var incomeTaxBreakdown: [(rate: Double, amount: Double)] = []
        
        var previousLimit = 0.0
        
        for (currentRate, currentLimit) in taxBands {
            if remainingIncome > 0 {
                let range = currentLimit - previousLimit
                let taxableAtCurrentRate = min(remainingIncome, range)
                let taxAtCurrentRate = taxableAtCurrentRate * currentRate
                incomeTax += taxAtCurrentRate
                remainingIncome -= taxableAtCurrentRate
                incomeTaxBreakdown.append((rate: currentRate, amount: taxAtCurrentRate))
                previousLimit = currentLimit
            }
        }
        
        return (total: incomeTax, breakdown: incomeTaxBreakdown)
    }

    
    func updateNI() {
        self.calculatedNI = Int(calculateNationalInsurance(income: Double(grossSalary), constants: constants, employer: true, noNI: false).total)
    }
    
    func calculateNationalInsurance(income: Double, constants: Constants, employer: Bool, noNI: Bool) -> (total: Double, breakdown: [(rate: Double, amount: Double)]) {
        if noNI {
            return (total: 0.0, breakdown: [])
        }
        
        let niConstants = constants.nationalInsurance
        let firstThreshold = employer ? niConstants.secondaryThreshold : niConstants.primaryThreshold
        let rates = employer ? niConstants.employerRates : niConstants.employeeRates
        
        var remainingIncome = max(0, income - firstThreshold)
        var nationalInsuranceTotal = 0.0
        var nationalInsuranceBreakdown: [(rate: Double, amount: Double)] = []
        
        if remainingIncome > 0 {
            let incomeInFirstBand = min(remainingIncome, niConstants.upperEarningsLimit - firstThreshold)
            if incomeInFirstBand > 0 {
                let niInFirstBand = incomeInFirstBand * rates[0]
                nationalInsuranceTotal += niInFirstBand
                remainingIncome -= incomeInFirstBand
                nationalInsuranceBreakdown.append((rate: rates[0], amount: niInFirstBand))
            }
        }
        
        if remainingIncome > 0 {
            let niInSecondBand = remainingIncome * rates[1]
            nationalInsuranceTotal += niInSecondBand
            nationalInsuranceBreakdown.append((rate: rates[1], amount: niInSecondBand))
        }
        
        return (total: nationalInsuranceTotal, breakdown: nationalInsuranceBreakdown)
    }

}

