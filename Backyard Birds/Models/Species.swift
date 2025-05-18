//
//  Species.swift
//  Backyard Birds
//
//  Created by dmu mac 26 on 13/05/2025.
//

import Foundation

enum Species: String, CaseIterable, Identifiable {
    case alle
    case allike, blåmejse, bogfinke, dompap, gærdesmutte,
        grønirisk, gråspurv, husskade, krage, landsvale,
        musvit, råge, skovskade, solsort, stær

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .alle: return "Alle"
        default: return rawValue.capitalized
        }
    }

    //Kun fuglene, uden case "alle"
    static var actualSpecies: [Species] {
        allCases
            .filter { $0 != .alle }
            .sorted { $0.displayName < $1.displayName }
    }
}
