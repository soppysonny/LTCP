import Foundation
import CleanJSON

struct LTCPModel: Codable {
    let user: LTCUser
    let workers: LTCWorkerDict
    let market: LTCMarket
}

struct LTCUser: Codable {
    let hash_rate: Double
    let expected_24h_rewards: Double
    let unpaid_rewards: Double
    let past_24h_rewards: Double
    let blocks_found: Int
}

struct LTCWorker: Codable {
    let connected: Bool
    let hash_rate: Double
    let hash_rate_24h: Float
    let valid_shares: Int
    let stale_shares: Int
    let invalid_shares: Int
    let rewards: Float
    let rewards_24h: Float
    let last_share_time: Int
    let reset_time: Int
}

typealias LTCWorkerDict = [String: LTCWorker]

struct LTCMarket: Codable {
    let ltc_usd: Float
}

public extension Decodable {
    static func decode(data: Data, format: DateFormat? = nil) throws -> Self {
        let decoder = CleanJSONDecoder()
        if data.isEmpty {
            return try decoder.decode(self, from: "{}".data(using: .utf8) ?? Data())
        }
        if let format = format {
            let formatter = DateFormatter()
            formatter.dateFormat = format.rawValue
            formatter.locale = Locale(identifier: "en_US_POSIX")
            decoder.dateDecodingStrategy = .formatted(formatter)
        }
        return try decoder.decode(self, from: data)
    }
}

public enum DateFormat: String, CaseIterable {
    case debug                      = "yyyy-MM-dd HH:mm:ss"
    case birthday                   = "yyyy-MM-dd"
    case numberOnly                 = "yyyyMMddHHmmss"
    case dateSlash                  = "yyyy/MM/dd"
    case dateSlashAndWeek           = "yyyy/M/d (E)"
    case monthDayOnly               = "M/d"
    case ymd                        = "yyyyMMdd"
    case siteCata                   = "HH:mm-EEEE"
    case timeStamp                  = "yyyy/MM/dd HH:mm:ss"
    case pointHistoryTimeStamp      = "yyyy/MM/dd HH:mm"
    case pointTimeStamp             = "yyyy.MM.dd HH:mm"
    case scheduleDate               = "M/dd（E）"
    case schedule                   = "M/dd（E）HH:mm"
    case hourMinutesOnly            = "HH:mm"
    case chinese                    = "yyyy年MM月dd日"
    case longSchedule               = "yyyy/M/d（E）HH:mm"
    case facebookDate               = "MM/dd/yyyy"
    case webApi                     = "yyyy-MM-dd'T'HH:mm:ss"
    case monthDayWeek               = "M/d（E）"
    case monthDayTime               = "M/d HH:mm"
    case hourMinuteSecond           = "HH:mm:ss"
    case minuteSecondOnly           = "mm:ss"
    case webApi2                    = "yyyy-MM-dd'T'HH:mm:ss.SSS"
}
