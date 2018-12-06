//
//  DateExtrnsions.swift
//  CraftArt
//
//  Created by YusuKe on 2018/11/27.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

extension Date {
    func timeAgoDisplayForEn() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        }else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        }else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        }else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        }else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        }else if secondsAgo < year {
            quotient = secondsAgo / month
            unit = "month"
        }else {
            quotient = secondsAgo / year
            unit = "year"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}

extension Date {
    func timeAgoDisplayForJa() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "秒"
        }else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "分"
        }else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "時間"
        }else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "日"
        }else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "週間"
        }else if secondsAgo < year {
            quotient = secondsAgo / month
            unit = "ヶ月"
        }else {
            quotient = secondsAgo / year
            unit = "年"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "")前"
        
    }
}

