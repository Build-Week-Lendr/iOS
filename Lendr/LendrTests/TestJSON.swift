//
//  TestJSON.swift
//  LendrTests
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

let validItemsJSON = """
[
    {
        "itemid": 8,
        "itemname": "Chop Saw",
        "itemdescription": "Dewalt Chop Saw",
        "lentto": "Allen",
        "lentdate": "November 21, 2019",
        "lendnotes": null
    },
    {
        "itemid": 9,
        "itemname": "Drill",
        "itemdescription": "Dewalt Drill",
        "lentto": "Allen",
        "lentdate": "November 21, 2019",
        "lendnotes": null
    },
    {
        "itemid": 10,
        "itemname": "Chain Saw",
        "itemdescription": null,
        "lentto": null,
        "lentdate": null,
        "lendnotes": null
    },
    {
        "itemid": 15,
        "itemname": "Drills",
        "itemdescription": "Dewalt Cordless Drill",
        "lentto": "Tyler",
        "lentdate": "May 31, 2019",
        "lendnotes": "Need it back by June 15 for a job."
    }
]
""".data(using: .utf8)!

let validItems2JSON = """
[
    {
        "itemid": 8,
        "itemname": "Chop Saw2",
        "itemdescription": "Dewalt Chop Saw2",
        "lentto": "Allen",
        "lentdate": "November 21, 2019",
        "lendnotes": null
    },
    {
        "itemid": 9,
        "itemname": "Drill2",
        "itemdescription": "Dewalt Drill2",
        "lentto": "Allen",
        "lentdate": "November 21, 2019",
        "lendnotes": null
    },
    {
        "itemid": 10,
        "itemname": "Chain Saw2",
        "itemdescription": null,
        "lentto": null,
        "lentdate": null,
        "lendnotes": null
    },
    {
        "itemid": 15,
        "itemname": "Drills2",
        "itemdescription": "Dewalt Cordless Drill2",
        "lentto": "Tyler",
        "lentdate": "May 31, 2019",
        "lendnotes": "Need it back by June 15 for a job."
    }
]
""".data(using: .utf8)!
