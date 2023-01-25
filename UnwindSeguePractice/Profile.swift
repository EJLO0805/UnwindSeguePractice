//
//  Profile.swift
//  UnwindSeguePractice
//
//  Created by 羅以捷 on 2022/11/23.
//

import Foundation
import CoreData
import UIKit

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

public class ProfileItemOfCoreData: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileItemOfCoreData> {
        return NSFetchRequest<ProfileItemOfCoreData>(entityName: "ProfileItemOfCoreData")
    }
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var height: Double
    @NSManaged public var weight: Double
    @NSManaged public var birthday: Date
    @NSManaged public var zodiacSign: String
    @NSManaged public var isMale: Bool
    @NSManaged public var imageData: Data?
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
    
    static func updateZodiacSign(_ date : Date) -> String{
        let zodiac = ZodiacSign.self
        let current = Calendar.current
        let month = current.component(.month, from: date)
        let day = current.component(.day, from: date)
        switch month {
            case 1 :
                return day > 20 ? zodiac.aquarius.rawValue : zodiac.capricorn.rawValue
            case 2 :
                return day > 19 ? zodiac.pisces.rawValue : zodiac.aquarius.rawValue
            case 3 :
                return day > 20 ? zodiac.aries.rawValue : zodiac.pisces.rawValue
            case 4 :
                return day > 19 ? zodiac.taurus.rawValue : zodiac.aries.rawValue
            case 5 :
                return day > 20 ? zodiac.gemini.rawValue : zodiac.taurus.rawValue
            case 6 :
                return day > 21 ? zodiac.cancer.rawValue : zodiac.gemini.rawValue
            case 7 :
                return day > 22 ? zodiac.leo.rawValue : zodiac.cancer.rawValue
            case 8 :
                return day > 22 ? zodiac.virgo.rawValue : zodiac.leo.rawValue
            case 9 :
                return day > 22 ? zodiac.libra.rawValue : zodiac.virgo.rawValue
            case 10 :
                return day > 23 ? zodiac.scorpio.rawValue : zodiac.libra.rawValue
            case 11 :
                return day > 21 ? zodiac.sagittarius.rawValue : zodiac.scorpio.rawValue
            default :
                return day > 20 ? zodiac.capricorn.rawValue : zodiac.sagittarius.rawValue
        }
    }
}
