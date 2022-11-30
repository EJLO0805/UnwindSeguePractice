//
//  Profile.swift
//  UnwindSeguePractice
//
//  Created by 羅以捷 on 2022/11/23.
//

import Foundation

struct ProfileItem : Codable {
    var name : String
    var phone : String
    var height : Double
    var weight : Double
    var birthday : Date
    var zodiacSign : ZodiacSign.RawValue
    var isMale : Bool
    var imageData : Data?
    
    static var fileManager = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadProfiles() -> [Self]? {
        let decoder = JSONDecoder()
        let userDefault = UserDefaults.standard
        guard let data = userDefault.data(forKey: "profiles") else { return nil}
        return try? decoder.decode([ProfileItem].self, from: data)
    }
    
    static func saveProfile(_ profiles : [Self]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(profiles) else {return}
        let userDefault = UserDefaults.standard
        userDefault.set(data, forKey: "profiles")
    }
    
    static func documentsLoadProfiles() -> [Self]? {
        let decoder = JSONDecoder()
        let url = Self.fileManager.appendingPathComponent("profile")
        if let data = try? Data(contentsOf: url), let profiles = try? decoder.decode([Self].self, from: data){
            return profiles
        } else {
            return nil
        }
    }
    
    static func documentsSaveProfile(_ profiles : [Self]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(profiles) else {return}
        let url = Self.fileManager.appendingPathComponent("profile")
        try! data.write(to:url )
    }
}

enum ZodiacSign: String {
    case aquarius = "Aquarius 水瓶座"
    case pisces = "Pisces 雙魚座"
    case aries = "Aries 牡羊座"
    case taurus = "Taurus 金牛座"
    case gemini = "Gemini 雙子座"
    case cancer = "Cancer 巨蟹座"
    case leo = "Leo 獅子座"
    case virgo = "Virgo 處女座"
    case libra = "Libra 天秤座"
    case scorpio = "Scorpio 天蠍座"
    case sagittarius = "Sagittarius 射手座"
    case capricorn = "Capricorn 摩羯座"
}
