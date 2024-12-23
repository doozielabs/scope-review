

List<TimeZones> timeZoneList = List<TimeZones>.from(timeZoneJson.map((e) => TimeZones.fromJson(e)));
class TimeZones {
    // String value;
    String abbr;
    String offset;
    String offsetInHours;
    // bool isdst;
    String text;
    // List<String> utc;

    TimeZones({
        // required this.value,
        required this.abbr,
        required this.offset,
        required this.offsetInHours,
        // required this.isdst,
        required this.text,
        // required this.utc,
    });

    factory TimeZones.fromJson(Map<String, dynamic> json) => TimeZones(
        // value: json["value"]??'',
        abbr: json["abbr"]??'',
        offset: json["offset"],
        offsetInHours: json["offsetInHours"],
        // isdst: json["isdst"]??false,
        text: json["text"]??'',
        // utc: json["utc"] == null? []:List<String>.from(json["utc"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        // "value": value,
        "abbr": abbr,
        "offset": offset,
        "offsetInHours": offsetInHours,
        // "isdst": isdst,
        "text": text,
        // "utc": List<dynamic>.from(utc.map((x) => x)),
    };
}

List<Map<String, dynamic>> timeZoneJson = [
  {
    "text": "Atlantic Standard Time (AST) [GMT-4]",
    "offset": "-04:00",
    "offsetInHours": "-4",
    "abbr": "AST"
  },
  {
    "text": "Eastern Standard Time (EST) [GMT-5]",
    "offset": "-05:00",
    "offsetInHours": "-5",
    "abbr": "EST"
  },
  {
    "text": "Central Standard Time (CST) [GMT-6]",
    "offset": "-06:00",
    "offsetInHours": "-6",
    "abbr": "CST"
  },
  {
    "text": "Mountain Standard Time (MST) [GMT-7]",
    "offset": "-07:00",
    "offsetInHours": "-7",
    "abbr": "MST"
  },
  {
    "text": "Pacific Standard Time (PST) [GMT-8]",
    "offset": "-08:00",
    "offsetInHours": "-8",
    "abbr": "PST"
  },
  {
    "text": "Alaska Standard Time (AKST) [GMT-9]",
    "offset": "-09:00",
    "offsetInHours": "-9",
    "abbr": "AKST"
  },
  {
    "text": "Hawaii-Aleutian Standard Time (HAST) [GMT-10]",
    "offset": "-10:00",
    "offsetInHours": "-10",
    "abbr": "HAST"
  },
  {
    "text": "Newfoundland Standard Time (NST) [GMT-3:30]",
    "offset": "-03:30",
    "offsetInHours": "-3.5",
    "abbr": "NST"
  },
  {
    "text": "Greenwich Mean Time (GMT) [GMT+0]",
    "offset": "00:00",
    "offsetInHours": "0",
    "abbr": "GMT"
  },
  {
    "text": "British Summer Time (BST) [GMT+1]",
    "offset": "+01:00",
    "offsetInHours": "1",
    "abbr": "BST"
  },
  {
    "text": "Central European Time (CET) [GMT+1]",
    "offset": "+01:00",
    "offsetInHours": "1",
    "abbr": "CET"
  },
  {
    "text": "Eastern European Time (EET) [GMT+2]",
    "offset": "+02:00",
    "offsetInHours": "2",
    "abbr": "EET"
  },
  {
    "text": "Moscow Standard Time (MSK) [GMT+3]",
    "offset": "+03:00",
    "offsetInHours": "3",
    "abbr": "MSK"
  },
  {
    "text": "Arabian Standard Time (AST) [GMT+3]",
    "offset": "+03:00",
    "offsetInHours": "3",
    "abbr": "AST"
  },
  {
    "text": "Iran Standard Time (IRST) [GMT+3:30]",
    "offset": "+03:30",
    "offsetInHours": "3.5",
    "abbr": "IRST"
  },
  {
    "text": "Gulf Standard Time (GST) [GMT+4]",
    "offset": "+04:00",
    "offsetInHours": "4",
    "abbr": "GST"
  },
  {
    "text": "Pakistan Standard Time (PKT) [GMT+5]",
    "offset": "+05:00",
    "offsetInHours": "5",
    "abbr": "PKT"
  },
  {
    "text": "India Standard Time (IST) [GMT+5:30]",
    "offset": "+05:30",
    "offsetInHours": "5.5",
    "abbr": ""
  },
  {
    "text": "Bangladesh Standard Time (BST) [GMT+6]",
    "offset": "+06:00",
    "offsetInHours": "6",
    "abbr": "BST"
  },
  {
    "text": "Myanmar Standard Time (MMT) [GMT+6:30]",
    "offset": "+06:30",
    "offsetInHours": "6.5",
    "abbr": "MMT"
  },
  {
    "text": "Indochina Time (ICT) [GMT+7]",
    "offset": "+07:00",
    "offsetInHours": "7",
    "abbr": "ICT"
  },
  {
    "text": "China Standard Time (CST) [GMT+8]",
    "offset": "+08:00",
    "offsetInHours": "8",
    "abbr": "CST"
  },
  {
    "text": "Japan Standard Time (JST) [GMT+9]",
    "offset": "+09:00",
    "offsetInHours": "9",
    "abbr": "JST"
  },
  {
    "text": "Korea Standard Time (KST) [GMT+9]",
    "offset": "+09:00",
    "offsetInHours": "9",
    "abbr": "KST"
  },
  {
    "text": "Australian Eastern Standard Time (AEST) [GMT+10]",
    "offset": "+10:00",
    "offsetInHours": "10",
    "abbr": "AEST"
  },
  {
    "text": "Australian Central Standard Time (ACST) [GMT+9:30]",
    "offset": "+09:00",
    "offsetInHours": "9",
    "abbr": "ACST"
  },
  {
    "text": "Australian Western Standard Time (AWST) [GMT+8]",
    "offset": "+08:00",
    "offsetInHours": "8",
    "abbr": "AWST"
  },
  {
    "text": "New Zealand Standard Time (NZST) [GMT+12]",
    "offset": "+12:00",
    "offsetInHours": "12",
    "abbr": "NZST"
  }
];

//   [
//     {
//         "value": "Dateline Standard Time",
//         "abbr": "DST",
//         "offset": "-12:00",
//         "offsetInHours": "-12",
//         "isdst": false,
//         "text": "(UTC-12:00) International Date Line West",
//         "utc": [
//             "Etc/GMT+12"
//         ]
//     },
//     {
//         "value": "UTC-11",
//         "abbr": "U",
//         "offset": "-11:00",
//         "offsetInHours": "-11",
//         "isdst": false,
//         "text": "(UTC-11:00) Coordinated Universal Time-11",
//         "utc": [
//             "Etc/GMT+11",
//             "Pacific/Midway",
//             "Pacific/Niue",
//             "Pacific/Pago_Pago"
//         ]
//     },
//     {
//         "value": "Hawaiian Standard Time",
//         "abbr": "HST",
//         "offset": "-10:00",
//         "offsetInHours": "-10",
//         "isdst": false,
//         "text": "(UTC-10:00) Hawaii",
//         "utc": [
//             "Etc/GMT+10",
//             "Pacific/Honolulu",
//             "Pacific/Johnston",
//             "Pacific/Rarotonga",
//             "Pacific/Tahiti"
//         ]
//     },
//     {
//         "value": "Pacific Standard Time",
//         "abbr": "PST",
//         "offset": "-08:00",
//         "offsetInHours": "-8",
//         "isdst": false,
//         "text": "(UTC-08:00) Pacific Standard Time (US & Canada)",
//         "utc": [
//             "America/Los_Angeles",
//             "America/Tijuana",
//             "America/Vancouver",
//             "PST8PDT"
//         ]
//     },
//     {
//         "value": "US Mountain Standard Time",
//         "abbr": "UMST",
//         "offset": "-07:00",
//         "offsetInHours": "-7",
//         "isdst": false,
//         "text": "(UTC-07:00) Arizona",
//         "utc": [
//             "America/Creston",
//             "America/Dawson",
//             "America/Dawson_Creek",
//             "America/Hermosillo",
//             "America/Phoenix",
//             "America/Whitehorse",
//             "Etc/GMT+7"
//         ]
//     },
//     {
//         "value": "Central America Standard Time",
//         "abbr": "CAST",
//         "offset": "-06:00",
//         "offsetInHours": "-6",
//         "isdst": false,
//         "text": "(UTC-06:00) Central America",
//         "utc": [
//             "America/Belize",
//             "America/Costa_Rica",
//             "America/El_Salvador",
//             "America/Guatemala",
//             "America/Managua",
//             "America/Tegucigalpa",
//             "Etc/GMT+6",
//             "Pacific/Galapagos"
//         ]
//     },
//     {
//         "value": "SA Pacific Standard Time",
//         "abbr": "SPST",
//         "offset": "-05:00",
//         "offsetInHours": "-5",
//         "isdst": false,
//         "text": "(UTC-05:00) Bogota, Lima, Quito",
//         "utc": [
//             "America/Bogota",
//             "America/Cayman",
//             "America/Coral_Harbour",
//             "America/Eirunepe",
//             "America/Guayaquil",
//             "America/Jamaica",
//             "America/Lima",
//             "America/Panama",
//             "America/Rio_Branco",
//             "Etc/GMT+5"
//         ]
//     },
//     {
//         "value": "Venezuela Standard Time",
//         "abbr": "VST",
//         "offset": "-04:30",
//         "offsetInHours": "-4.5",
//         "isdst": false,
//         "text": "(UTC-04:30) Caracas",
//         "utc": [
//             "America/Caracas"
//         ]
//     },
//     {
//         "value": "Paraguay Standard Time",
//         "abbr": "PYT",
//         "offset": "-04:00",
//         "offsetInHours": "-4",
//         "isdst": false,
//         "text": "(UTC-04:00) Asuncion",
//         "utc": [
//             "America/Asuncion"
//         ]
//     },
//     {
//         "value": "E. South America Standard Time",
//         "abbr": "ESAST",
//         "offset": "-03:00",
//         "offsetInHours": "-3",
//         "isdst": false,
//         "text": "(UTC-03:00) Brasilia",
//         "utc": [
//             "America/Sao_Paulo"
//         ]
//     },
//     {
//         "value": "UTC-02",
//         "abbr": "U",
//         "offset": "-02:00",
//         "offsetInHours": "-2",
//         "isdst": false,
//         "text": "(UTC-02:00) Coordinated Universal Time-02",
//         "utc": [
//             "America/Noronha",
//             "Atlantic/South_Georgia",
//             "Etc/GMT+2"
//         ]
//     },
//     {
//         "value": "UTC",
//         "abbr": "UTC",
//         "offset": "00:00",
//         "offsetInHours": "0",
//         "isdst": false,
//         "text": "(UTC) Coordinated Universal Time",
//         "utc": [
//             "America/Danmarkshavn",
//             "Etc/GMT"
//         ]
//     },
//     {
//         "value": "Morocco Standard Time",
//         "abbr": "MDT",
//         "offset": "+01:00",
//         "offsetInHours": "1",
//         "isdst": false,
//         "text": "(UTC+01:00) Casablanca",
//         "utc": [
//             "Africa/Casablanca",
//             "Africa/El_Aaiun"
//         ]
//     },
//     {
//         "value": "W. Europe Standard Time",
//         "abbr": "WEDT",
//         "offset": "+02:00",
//         "offsetInHours": "2",
//         "isdst": false,
//         "text": "(UTC+02:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna",
//         "utc": [
//             "Arctic/Longyearbyen",
//             "Europe/Amsterdam",
//             "Europe/Andorra",
//             "Europe/Berlin",
//             "Europe/Busingen",
//             "Europe/Gibraltar",
//             "Europe/Luxembourg",
//             "Europe/Malta",
//             "Europe/Monaco",
//             "Europe/Oslo",
//             "Europe/Rome",
//             "Europe/San_Marino",
//             "Europe/Stockholm",
//             "Europe/Vaduz",
//             "Europe/Vatican",
//             "Europe/Vienna",
//             "Europe/Zurich"
//         ]
//     },
//     {
//         "value": "GTB Standard Time",
//         "abbr": "GDT",
//         "offset": "+03:00",
//         "offsetInHours": "3",
//         "isdst": false,
//         "text": "(UTC+03:00) Athens, Bucharest",
//         "utc": [
//             "Asia/Nicosia",
//             "Europe/Athens",
//             "Europe/Bucharest",
//             "Europe/Chisinau"
//         ]
//     },
//     {
//         "value": "Samara Time",
//         "abbr": "SAMT",
//         "offset": "+04:00",
//         "offsetInHours": "4",
//         "isdst": false,
//         "text": "(UTC+04:00) Samara, Ulyanovsk, Saratov",
//         "utc": [
//             "Europe/Astrakhan",
//             "Europe/Samara",
//             "Europe/Ulyanovsk"
//         ]
//     },
//     {
//         "value": "Iran Standard Time",
//         "abbr": "IDT",
//         "offset": "+04:30",
//         "offsetInHours": "4.5",
//         "isdst": false,
//         "text": "(UTC+04:30) Tehran",
//         "utc": [
//             "Asia/Tehran"
//         ]
//     },
//     {
//         "value": "Azerbaijan Standard Time",
//         "abbr": "ADT",
//         "offset": "+05:00",
//         "offsetInHours": "5",
//         "isdst": false,
//         "text": "(UTC+05:00) Baku",
//         "utc": [
//             "Asia/Baku"
//         ]
//     },
//     {
//         "value": "India Standard Time",
//         "abbr": "IST",
//         "offset": "+05:30",
//         "offsetInHours": "5.5",
//         "isdst": false,
//         "text": "(UTC+05:30) Chennai, Kolkata, Mumbai, New Delhi",
//         "utc": [
//             "Asia/Kolkata",
//             "Asia/Calcutta"
//         ]
//     },
//     {
//         "value": "Nepal Standard Time",
//         "abbr": "NST",
//         "offset": "+05:45",
//         "offsetInHours": "5.75",
//         "isdst": false,
//         "text": "(UTC+05:45) Kathmandu",
//         "utc": [
//             "Asia/Kathmandu"
//         ]
//     },
//     {
//         "value": "Central Asia Standard Time",
//         "abbr": "CAST",
//         "offset": "+06:00",
//         "offsetInHours": "6",
//         "isdst": false,
//         "text": "(UTC+06:00) Nur-Sultan (Astana)",
//         "utc": [
//             "Antarctica/Vostok",
//             "Asia/Almaty",
//             "Asia/Bishkek",
//             "Asia/Qyzylorda",
//             "Asia/Urumqi",
//             "Etc/GMT-6",
//             "Indian/Chagos"
//         ]
//     },
//     {
//         "value": "Myanmar Standard Time",
//         "abbr": "MST",
//         "offset": "+06:30",
//         "offsetInHours": "6.5",
//         "isdst": false,
//         "text": "(UTC+06:30) Yangon (Rangoon)",
//         "utc": [
//             "Asia/Rangoon",
//             "Indian/Cocos"
//         ]
//     },
//     {
//         "value": "SE Asia Standard Time",
//         "abbr": "SAST",
//         "offset": "+07:00",
//         "offsetInHours": "7",
//         "isdst": false,
//         "text": "(UTC+07:00) Bangkok, Hanoi, Jakarta",
//         "utc": [
//             "Antarctica/Davis",
//             "Asia/Bangkok",
//             "Asia/Hovd",
//             "Asia/Jakarta",
//             "Asia/Phnom_Penh",
//             "Asia/Pontianak",
//             "Asia/Saigon",
//             "Asia/Vientiane",
//             "Etc/GMT-7",
//             "Indian/Christmas"
//         ]
//     },
//     {
//         "value": "China Standard Time",
//         "abbr": "CST",
//         "offset": "+08:00",
//         "offsetInHours": "8",
//         "isdst": false,
//         "text": "(UTC+08:00) Beijing, Chongqing, Hong Kong, Urumqi",
//         "utc": [
//             "Asia/Hong_Kong",
//             "Asia/Macau",
//             "Asia/Shanghai"
//         ]
//     },
//     {
//         "value": "Japan Standard Time",
//         "abbr": "JST",
//         "offset": "+09:00",
//         "offsetInHours": "9",
//         "isdst": false,
//         "text": "(UTC+09:00) Osaka, Sapporo, Tokyo",
//         "utc": [
//             "Asia/Dili",
//             "Asia/Jayapura",
//             "Asia/Tokyo",
//             "Etc/GMT-9",
//             "Pacific/Palau"
//         ]
//     },
//     {
//         "value": "Cen. Australia Standard Time",
//         "abbr": "CAST",
//         "offset": "+09:30",
//         "offsetInHours": "9.5",
//         "isdst": false,
//         "text": "(UTC+09:30) Adelaide",
//         "utc": [
//             "Australia/Adelaide",
//             "Australia/Broken_Hill"
//         ]
//     },
//     {
//         "value": "E. Australia Standard Time",
//         "abbr": "EAST",
//         "offset": "+10:00",
//         "offsetInHours": "10",
//         "isdst": false,
//         "text": "(UTC+10:00) Brisbane",
//         "utc": [
//             "Australia/Brisbane",
//             "Australia/Lindeman"
//         ]
//     },
//     {
//         "value": "Central Pacific Standard Time",
//         "abbr": "CPST",
//         "offset": "+11:00",
//         "offsetInHours": "11",
//         "isdst": false,
//         "text": "(UTC+11:00) Solomon Is., New Caledonia",
//         "utc": [
//             "Antarctica/Macquarie",
//             "Etc/GMT-11",
//             "Pacific/Efate",
//             "Pacific/Guadalcanal",
//             "Pacific/Kosrae",
//             "Pacific/Noumea",
//             "Pacific/Ponape"
//         ]
//     },
//     {
//         "value": "New Zealand Standard Time",
//         "abbr": "NZST",
//         "offset": "+12:00",
//         "offsetInHours": "12",
//         "isdst": false,
//         "text": "(UTC+12:00) Auckland, Wellington",
//         "utc": [
//             "Antarctica/McMurdo",
//             "Pacific/Auckland"
//         ]
//     },
//     {
//         "value": "Kamchatka Standard Time",
//         "abbr": "KDT",
//         "offset": "+13:00",
//         "offsetInHours": "13",
//         "isdst": false,
//         "text": "(UTC+13:00) Petropavlovsk-Kamchatsky - Old",
//         "utc": [
//             "Asia/Kamchatka"
//         ]
//     }
// ];

TimeZones? filterZone(String offset) {
  return timeZoneList.firstWhere((p0) => p0.offset == offset);
}
