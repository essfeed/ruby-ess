require 'ess/helpers'
require 'time'
require 'resolv'

module ESS
  module Validation
    ##
    # Varous classes for validation of tag values. Should not be used directly,
    # instances of it's classes are part of the DTD.
    #

    class ValidationError < StandardError
      ##
      # This exception is generated when the validator find an error
      # in the document. It should contain a message describing what
      # was the value which caused it to be raised.
      #
    end

    class TextIsNotNull
      def validate tag
        if tag.text!.strip == ''
          raise ValidationError, "the <#{tag.tag_name}> element cannot be empty"
        end
      end
    end

    class TextIsValidEmail
      def validate tag
        return if valid_domain?(tag.text!)
        raise InvalidValueError, "the email \"#{tag.text!}\" could not be validated"
      end

      EMAIL_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      SERVER_TIMEOUT = 10

      def valid_domain?(email)
        domain = email.match(EMAIL_PATTERN)[2]
        dns = Resolv::DNS.new
        Timeout::timeout(SERVER_TIMEOUT) do

          # Check the MX record
          mx_records = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)

          mx_records.sort_by {|mx| mx.preference}.each do |mx|
            a_records = dns.getresources(mx.exchange.to_s, Resolv::DNS::Resource::IN::A)
            return true if a_records.any?
          end

           #Try a straight A record
           a_records = dns.getresources(domain, Resolv::DNS::Resource::IN::A)
           a_records.any?
         end
      rescue Timeout::Error, Errno::ECONNREFUSED
        false
      end
    end

    class URLValidation
      def validate_url text
        unless text =~ /^(http|https|ftp):\/\/([A-Z0-9][A-Z0-9_-]*(?:\.[A-Z0-9][A-Z0-9_-]*)+):?(\d+)?\/?/i || text.length > 10
          unless isValidIP text
            raise ValidationError, "invalid URL: #{text}"
          end
        end
      end

      private
        def isValidIP text
          unless text =~ /^((1?\d{1,2}|2[0-4]\d|25[0-5])\.){3}(1?\d{1,2}|2[0-4]\d|25[0-5])$/
            return false
          end
          return text.split('.').map { |part| part.to_i <= 255 }.all?
        end
    end

    class TextIsValidURL < URLValidation
      def validate tag
        validate_url tag.text!
      end
    end

    class XmlnsIsValidURL < URLValidation
      def validate ess_tag
        validate_url ess_tag.xmlns_attr
      end
    end

    class TextIsValidLatitude
      def validate tag
        unless tag.text! =~ /^-?([0-8]?[0-9]|90)\.[0-9]{1,6}$/
          raise ValidationError, "invalid latitude: #{tag.text!}"
        end
      end
    end

    class TextIsValidLongitude
      def validate tag
        unless tag.text! =~ /^-?((1?[0-7]?|[0-9]?)[0-9]|180)\.[0-9]{1,6}$/
          raise ValidationError, "invalid longitude: #{tag.text!}"
        end
      end
    end

    class TextIsValidCountryCode
      COUNTRY_CODES = {
        "AU" => "Australia",
        "AF" => "Afghanistan",
        "AL" => "Albania",
        "DZ" => "Algeria",
        "AS" => "American Samoa",
        "AD" => "Andorra",
        "AO" => "Angola",
        "AI" => "Anguilla",
        "AQ" => "Antarctica",
        "AG" => "Antigua & Barbuda",
        "AR" => "Argentina",
        "AM" => "Armenia",
        "AW" => "Aruba",
        "AT" => "Austria",
        "AZ" => "Azerbaijan",
        "BS" => "Bahamas",
        "BH" => "Bahrain",
        "BD" => "Bangladesh",
        "BB" => "Barbados",
        "BY" => "Belarus",
        "BE" => "Belgium",
        "BZ" => "Belize",
        "BJ" => "Benin",
        "BM" => "Bermuda",
        "BT" => "Bhutan",
        "BO" => "Bolivia",
        "BA" => "Bosnia/Hercegovina",
        "BW" => "Botswana",
        "BV" => "Bouvet Island",
        "BR" => "Brazil",
        "IO" => "British Indian Ocean Territory",
        "BN" => "Brunei Darussalam",
        "BG" => "Bulgaria",
        "BF" => "Burkina Faso",
        "BI" => "Burundi",
        "KH" => "Cambodia",
        "CM" => "Cameroon",
        "CA" => "Canada",
        "CV" => "Cape Verde",
        "KY" => "Cayman Is",
        "CF" => "Central African Republic",
        "TD" => "Chad",
        "CL" => "Chile",
        "CN" => "China, People's Republic of",
        "CX" => "Christmas Island",
        "CC" => "Cocos Islands",
        "CO" => "Colombia",
        "KM" => "Comoros",
        "CG" => "Congo",
        "CD" => "Congo, Democratic Republic",
        "CK" => "Cook Islands",
        "CR" => "Costa Rica",
        "CI" => "Cote d'Ivoire",
        "HR" => "Croatia",
        "CU" => "Cuba",
        "CY" => "Cyprus",
        "CZ" => "Czech Republic",
        "DK" => "Denmark",
        "DJ" => "Djibouti",
        "DM" => "Dominica",
        "DO" => "Dominican Republic",
        "TP" => "East Timor",
        "EC" => "Ecuador",
        "EG" => "Egypt",
        "SV" => "El Salvador",
        "GQ" => "Equatorial Guinea",
        "ER" => "Eritrea",
        "EE" => "Estonia",
        "ET" => "Ethiopia",
        "FK" => "Falkland Islands",
        "FO" => "Faroe Islands",
        "FJ" => "Fiji",
        "FI" => "Finland",
        "FR" => "France",
        "FX" => "France, Metropolitan",
        "GF" => "French Guiana",
        "PF" => "French Polynesia",
        "TF" => "French South Territories",
        "GA" => "Gabon",
        "GM" => "Gambia",
        "GE" => "Georgia",
        "DE" => "Germany",
        "GH" => "Ghana",
        "GI" => "Gibraltar",
        "GR" => "Greece",
        "GL" => "Greenland",
        "GD" => "Grenada",
        "GP" => "Guadeloupe",
        "GU" => "Guam",
        "GT" => "Guatemala",
        "GN" => "Guinea",
        "GW" => "Guinea-Bissau",
        "GY" => "Guyana",
        "HT" => "Haiti",
        "HM" => "Heard Island And Mcdonald Island",
        "HN" => "Honduras",
        "HK" => "Hong Kong",
        "HU" => "Hungary",
        "IS" => "Iceland",
        "IN" => "India",
        "ID" => "Indonesia",
        "IR" => "Iran",
        "IQ" => "Iraq",
        "IE" => "Ireland",
        "IL" => "Israel",
        "IT" => "Italy",
        "JM" => "Jamaica",
        "JP" => "Japan",
        "JT" => "Johnston Island",
        "JO" => "Jordan",
        "KZ" => "Kazakhstan",
        "KE" => "Kenya",
        "KI" => "Kiribati",
        "KP" => "Korea, Democratic Peoples Republic",
        "KR" => "Korea, Republic of",
        "KW" => "Kuwait",
        "KG" => "Kyrgyzstan",
        "LA" => "Lao People's Democratic Republic",
        "LV" => "Latvia",
        "LB" => "Lebanon",
        "LS" => "Lesotho",
        "LR" => "Liberia",
        "LY" => "Libyan Arab Jamahiriya",
        "LI" => "Liechtenstein",
        "LT" => "Lithuania",
        "LU" => "Luxembourg",
        "MO" => "Macau",
        "MK" => "Macedonia",
        "MG" => "Madagascar",
        "MW" => "Malawi",
        "MY" => "Malaysia",
        "MV" => "Maldives",
        "ML" => "Mali",
        "MT" => "Malta",
        "MH" => "Marshall Islands",
        "MQ" => "Martinique",
        "MR" => "Mauritania",
        "MU" => "Mauritius",
        "YT" => "Mayotte",
        "MX" => "Mexico",
        "FM" => "Micronesia",
        "MD" => "Moldavia",
        "MC" => "Monaco",
        "MN" => "Mongolia",
        "ME" => "Montenegro",
        "MS" => "Montserrat",
        "MA" => "Morocco",
        "MZ" => "Mozambique",
        "MM" => "Union Of Myanmar",
        "NA" => "Namibia",
        "NR" => "Nauru Island",
        "NP" => "Nepal",
        "NL" => "Netherlands",
        "AN" => "Netherlands Antilles",
        "NC" => "New Caledonia",
        "NZ" => "New Zealand",
        "NI" => "Nicaragua",
        "NE" => "Niger",
        "NG" => "Nigeria",
        "NU" => "Niue",
        "NF" => "Norfolk Island",
        "MP" => "Mariana Islands, Northern",
        "NO" => "Norway",
        "OM" => "Oman",
        "PK" => "Pakistan",
        "PW" => "Palau Islands",
        "PS" => "Palestine",
        "PA" => "Panama",
        "PG" => "Papua New Guinea",
        "PY" => "Paraguay",
        "PE" => "Peru",
        "PH" => "Philippines",
        "PN" => "Pitcairn",
        "PL" => "Poland",
        "PT" => "Portugal",
        "PR" => "Puerto Rico",
        "QA" => "Qatar",
        "RE" => "Reunion Island",
        "RO" => "Romania",
        "RU" => "Russian Federation",
        "RW" => "Rwanda",
        "WS" => "Samoa",
        "SH" => "St Helena",
        "KN" => "St Kitts & Nevis",
        "LC" => "St Lucia",
        "PM" => "St Pierre & Miquelon",
        "VC" => "St Vincent",
        "SM" => "San Marino",
        "ST" => "Sao Tome & Principe",
        "SA" => "Saudi Arabia",
        "SN" => "Senegal",
        "RS" => "Serbia",
        "SC" => "Seychelles",
        "SL" => "Sierra Leone",
        "SG" => "Singapore",
        "SK" => "Slovakia",
        "SI" => "Slovenia",
        "SB" => "Solomon Islands",
        "SO" => "Somalia",
        "ZA" => "South Africa",
        "GS" => "South Georgia and South Sandwich",
        "ES" => "Spain",
        "LK" => "Sri Lanka",
        "XX" => "Stateless Persons",
        "SD" => "Sudan",
        "SR" => "Suriname",
        "SJ" => "Svalbard and Jan Mayen",
        "SZ" => "Swaziland",
        "SE" => "Sweden",
        "CH" => "Switzerland",
        "SY" => "Syrian Arab Republic",
        "TW" => "Taiwan, Republic of China",
        "TJ" => "Tajikistan",
        "TZ" => "Tanzania",
        "TH" => "Thailand",
        "TL" => "Timor Leste",
        "TG" => "Togo",
        "TK" => "Tokelau",
        "TO" => "Tonga",
        "TT" => "Trinidad & Tobago",
        "TN" => "Tunisia",
        "TR" => "Turkey",
        "TM" => "Turkmenistan",
        "TC" => "Turks And Caicos Islands",
        "TV" => "Tuvalu",
        "UG" => "Uganda",
        "UA" => "Ukraine",
        "AE" => "United Arab Emirates",
        "GB" => "United Kingdom",
        "UM" => "US Minor Outlying Islands",
        "US" => "USA",
        "HV" => "Upper Volta",
        "UY" => "Uruguay",
        "UZ" => "Uzbekistan",
        "VU" => "Vanuatu",
        "VA" => "Vatican City State",
        "VE" => "Venezuela",
        "VN" => "Vietnam",
        "VG" => "Virgin Islands (British)",
        "VI" => "Virgin Islands (US)",
        "WF" => "Wallis And Futuna Islands",
        "EH" => "Western Sahara",
        "YE" => "Yemen Arab Rep.",
        "YD" => "Yemen Democratic",
        "YU" => "Yugoslavia",
        "ZR" => "Zaire",
        "ZM" => "Zambia",
        "ZW" => "Zimbabwe"
      }

      def validate tag
        unless COUNTRY_CODES.keys.include? tag.text!.strip.upcase
          raise ValidationError, "invalid country code: #{tag.text!}"
        end
      end
    end

    class TextIsValidCurrency
      CURRENCIES = {
        'AF' => 'AFA',
        'AL' => 'ALL',
        'DZ' => 'DZD',
        'AS' => 'USD',
        'AD' => 'EUR',
        'AO' => 'AOA',
        'AI' => 'XCD',
        'AQ' => 'NOK',
        'AG' => 'XCD',
        'AR' => 'ARA',
        'AM' => 'AMD',
        'AW' => 'AWG',
        'AU' => 'AUD',
        'AT' => 'EUR',
        'AZ' => 'AZM',
        'BS' => 'BSD',
        'BH' => 'BHD',
        'BD' => 'BDT',
        'BB' => 'BBD',
        'BY' => 'BYR',
        'BE' => 'EUR',
        'BZ' => 'BZD',
        'BJ' => 'XAF',
        'BM' => 'BMD',
        'BT' => 'BTN',
        'BO' => 'BOB',
        'BA' => 'BAM',
        'BW' => 'BWP',
        'BV' => 'NOK',
        'BR' => 'BRL',
        'IO' => 'GBP',
        'BN' => 'BND',
        'BG' => 'BGN',
        'BF' => 'XAF',
        'BI' => 'BIF',
        'KH' => 'KHR',
        'CM' => 'XAF',
        'CA' => 'CAD',
        'CV' => 'CVE',
        'KY' => 'KYD',
        'CF' => 'XAF',
        'TD' => 'XAF',
        'CL' => 'CLF',
        'CN' => 'CNY',
        'CX' => 'AUD',
        'CC' => 'AUD',
        'CO' => 'COP',
        'KM' => 'KMF',
        'CD' => 'CDZ',
        'CG' => 'XAF',
        'CK' => 'NZD',
        'CR' => 'CRC',
        'HR' => 'HRK',
        'CU' => 'CUP',
        'CY' => 'EUR',
        'CZ' => 'CZK',
        'DK' => 'DKK',
        'DJ' => 'DJF',
        'DM' => 'XCD',
        'DO' => 'DOP',
        'TP' => 'TPE',
        'EC' => 'USD',
        'EG' => 'EGP',
        'SV' => 'USD',
        'GQ' => 'XAF',
        'ER' => 'ERN',
        'EE' => 'EEK',
        'ET' => 'ETB',
        'FK' => 'FKP',
        'FO' => 'DKK',
        'FJ' => 'FJD',
        'FI' => 'EUR',
        'FR' => 'EUR',
        'FX' => 'EUR',
        'GF' => 'EUR',
        'PF' => 'XPF',
        'TF' => 'EUR',
        'GA' => 'XAF',
        'GM' => 'GMD',
        'GE' => 'GEL',
        'DE' => 'EUR',
        'GH' => 'GHC',
        'GI' => 'GIP',
        'GR' => 'EUR',
        'GL' => 'DKK',
        'GD' => 'XCD',
        'GP' => 'EUR',
        'GU' => 'USD',
        'GT' => 'GTQ',
        'GN' => 'GNS',
        'GW' => 'GWP',
        'GY' => 'GYD',
        'HT' => 'HTG',
        'HM' => 'AUD',
        'VA' => 'EUR',
        'HN' => 'HNL',
        'HK' => 'HKD',
        'HU' => 'HUF',
        'IS' => 'ISK',
        'IN' => 'INR',
        'ID' => 'IDR',
        'IR' => 'IRR',
        'IQ' => 'IQD',
        'IE' => 'EUR',
        'IL' => 'ILS',
        'IT' => 'EUR',
        'CI' => 'XAF',
        'JM' => 'JMD',
        'JP' => 'JPY',
        'JO' => 'JOD',
        'KZ' => 'KZT',
        'KE' => 'KES',
        'KI' => 'AUD',
        'KP' => 'KPW',
        'KR' => 'KRW',
        'KW' => 'KWD',
        'KG' => 'KGS',
        'LA' => 'LAK',
        'LV' => 'LVL',
        'LB' => 'LBP',
        'LS' => 'LSL',
        'LR' => 'LRD',
        'LY' => 'LYD',
        'LI' => 'CHF',
        'LT' => 'LTL',
        'LU' => 'EUR',
        'MO' => 'MOP',
        'MK' => 'MKD',
        'MG' => 'MGF',
        'MW' => 'MWK',
        'MY' => 'MYR',
        'MV' => 'MVR',
        'ML' => 'XAF',
        'MT' => 'EUR',
        'MH' => 'USD',
        'MQ' => 'EUR',
        'MR' => 'MRO',
        'MU' => 'MUR',
        'YT' => 'EUR',
        'MX' => 'MXN',
        'FM' => 'USD',
        'MD' => 'MDL',
        'MC' => 'EUR',
        'MN' => 'MNT',
        'MS' => 'XCD',
        'MA' => 'MAD',
        'MZ' => 'MZM',
        'MM' => 'MMK',
        'NA' => 'NAD',
        'NR' => 'AUD',
        'NP' => 'NPR',
        'NL' => 'EUR',
        'AN' => 'ANG',
        'NC' => 'XPF',
        'NZ' => 'NZD',
        'NI' => 'NIC',
        'NE' => 'XOF',
        'NG' => 'NGN',
        'NU' => 'NZD',
        'NF' => 'AUD',
        'MP' => 'USD',
        'NO' => 'NOK',
        'OM' => 'OMR',
        'PK' => 'PKR',
        'PW' => 'USD',
        'PA' => 'PAB',
        'PG' => 'PGK',
        'PY' => 'PYG',
        'PE' => 'PEI',
        'PH' => 'PHP',
        'PN' => 'NZD',
        'PL' => 'PLN',
        'PT' => 'EUR',
        'PR' => 'USD',
        'QA' => 'QAR',
        'RE' => 'EUR',
        'RO' => 'ROL',
        'RU' => 'RUB',
        'RW' => 'RWF',
        'KN' => 'XCD',
        'LC' => 'XCD',
        'VC' => 'XCD',
        'WS' => 'WST',
        'SM' => 'EUR',
        'ST' => 'STD',
        'SA' => 'SAR',
        'SN' => 'XOF',
        'CS' => 'EUR',
        'SC' => 'SCR',
        'SL' => 'SLL',
        'SG' => 'SGD',
        'SK' => 'EUR',
        'SI' => 'EUR',
        'SB' => 'SBD',
        'SO' => 'SOS',
        'ZA' => 'ZAR',
        'GS' => 'GBP',
        'ES' => 'EUR',
        'LK' => 'LKR',
        'SH' => 'SHP',
        'PM' => 'EUR',
        'SD' => 'SDG',
        'SR' => 'SRG',
        'SJ' => 'NOK',
        'SZ' => 'SZL',
        'SE' => 'SEK',
        'CH' => 'CHF',
        'SY' => 'SYP',
        'TW' => 'TWD',
        'TJ' => 'TJR',
        'TZ' => 'TZS',
        'TH' => 'THB',
        'TG' => 'XAF',
        'TK' => 'NZD',
        'TO' => 'TOP',
        'TT' => 'TTD',
        'TN' => 'TND',
        'TR' => 'TRY',
        'TM' => 'TMM',
        'TC' => 'USD',
        'TV' => 'AUD',
        'UG' => 'UGS',
        'UA' => 'UAH',
        'SU' => 'SUR',
        'AE' => 'AED',
        'GB' => 'GBP',
        'US' => 'USD',
        'UM' => 'USD',
        'UY' => 'UYU',
        'UZ' => 'UZS',
        'VU' => 'VUV',
        'VE' => 'VEF',
        'VN' => 'VND',
        'VG' => 'USD',
        'VI' => 'USD',
        'WF' => 'XPF',
        'XO' => 'XOF',
        'EH' => 'MAD',
        'ZM' => 'ZMK',
        'ZW' => 'USD'
      }

      def validate tag
        unless CURRENCIES.values.include? tag.text!.strip.upcase
          raise ValidationError, "invalid currency: #{tag.text!}"
        end
      end
    end

    class CurrMandatoryIfValueGT0
      def validate price_tag
        if price_tag.value.text!.to_i != 0
          if price_tag.currency.text! == ""
            raise ValidationError, "the <currency> element of a price item cannot be empty if <value> is not 0"
          end
        end
      end
    end

    class LangIsValid
      LANGUAGES = {
        'aa' => 'Afar',
        'ab' => 'Abkhaz',
        'ae' => 'Avestan',
        'af' => 'Afrikaans',
        'ak' => 'Akan',
        'am' => 'Amharic',
        'an' => 'Aragonese',
        'ar' => 'Arabic',
        'as' => 'Assamese',
        'av' => 'Avaric',
        'ay' => 'Aymara',
        'az' => 'Azerbaijani',
        'ba' => 'Bashkir',
        'be' => 'Belarusian',
        'bg' => 'Bulgarian',
        'bh' => 'Bihari',
        'bi' => 'Bislama',
        'bm' => 'Bambara',
        'bn' => 'Bengali',
        'bo' => 'Tibetan Standard, Tibetan, Central',
        'br' => 'Breton',
        'bs' => 'Bosnian',
        'ca' => 'Catalan; Valencian',
        'ce' => 'Chechen',
        'ch' => 'Chamorro',
        'co' => 'Corsican',
        'cr' => 'Cree',
        'cs' => 'Czech',
        'cu' => 'Old Church Slavonic, Church Slavic, Church Slavonic, Old Bulgarian, Old Slavonic',
        'cv' => 'Chuvash',
        'cy' => 'Welsh',
        'da' => 'Danish',
        'de' => 'German',
        'dv' => 'Divehi; Dhivehi; Maldivian;',
        'dz' => 'Dzongkha',
        'ee' => 'Ewe',
        'el' => 'Greek, Modern',
        'en' => 'English',
        'eo' => 'Esperanto',
        'es' => 'Spanish; Castilian',
        'et' => 'Estonian',
        'eu' => 'Basque',
        'fa' => 'Persian',
        'ff' => 'Fula; Fulah; Pulaar; Pular',
        'fi' => 'Finnish',
        'fj' => 'Fijian',
        'fo' => 'Faroese',
        'fr' => 'French',
        'fy' => 'Western Frisian',
        'ga' => 'Irish',
        'gd' => 'Scottish Gaelic; Gaelic',
        'gl' => 'Galician',
        'gn' => 'Guaran',
        'gu' => 'Gujarati',
        'gv' => 'Manx',
        'ha' => 'Hausa',
        'he' => 'Hebrew (modern)',
        'hi' => 'Hindi',
        'ho' => 'Hiri Motu',
        'hr' => 'Croatian',
        'ht' => 'Haitian; Haitian Creole',
        'hu' => 'Hungarian',
        'hy' => 'Armenian',
        'hz' => 'Herero',
        'ia' => 'Interlingua',
        'id' => 'Indonesian',
        'ie' => 'Interlingue',
        'ig' => 'Igbo',
        'ii' => 'Nuosu',
        'ik' => 'Inupiaq',
        'io' => 'Ido',
        'is' => 'Icelandic',
        'it' => 'Italian',
        'iu' => 'Inuktitut',
        'ja' => 'Japanese (ja)',
        'jv' => 'Javanese (jv)',
        'ka' => 'Georgian',
        'kg' => 'Kongo',
        'ki' => 'Kikuyu, Gikuyu',
        'kj' => 'Kwanyama, Kuanyama',
        'kk' => 'Kazakh',
        'kl' => 'Kalaallisut, Greenlandic',
        'km' => 'Khmer',
        'kn' => 'Kannada',
        'ko' => 'Korean',
        'kr' => 'Kanuri',
        'ks' => 'Kashmiri',
        'ku' => 'Kurdish',
        'kv' => 'Komi',
        'kw' => 'Cornish',
        'ky' => 'Kirghiz, Kyrgyz',
        'la' => 'Latin',
        'lb' => 'Luxembourgish, Letzeburgesch',
        'lg' => 'Luganda',
        'li' => 'Limburgish, Limburgan, Limburger',
        'ln' => 'Lingala',
        'lo' => 'Lao',
        'lt' => 'Lithuanian',
        'lu' => 'Luba-Katanga',
        'lv' => 'Latvian',
        'mg' => 'Malagasy',
        'mh' => 'Marshallese',
        'mi' => 'Maori',
        'mk' => 'Macedonian',
        'ml' => 'Malayalam',
        'mn' => 'Mongolian',
        'mr' => 'Marathi (Mara?hi)',
        'ms' => 'Malay',
        'mt' => 'Maltese',
        'my' => 'Burmese',
        'na' => 'Nauru',
        'nb' => 'Norwegian Bokm',
        'nd' => 'North Ndebele',
        'ne' => 'Nepali',
        'ng' => 'Ndonga',
        'nl' => 'Dutch',
        'nn' => 'Norwegian Nynorsk',
        'no' => 'Norwegian',
        'nr' => 'South Ndebele',
        'nv' => 'Navajo, Navaho',
        'ny' => 'Chichewa; Chewa; Nyanja',
        'oc' => 'Occitan',
        'oj' => 'Ojibwe, Ojibwa',
        'om' => 'Oromo',
        'or' => 'Oriya',
        'os' => 'Ossetian, Ossetic',
        'pa' => 'Panjabi, Punjabi',
        'pi' => 'Pali',
        'pl' => 'Polish',
        'ps' => 'Pashto, Pushto',
        'pt' => 'Portuguese',
        'qu' => 'Quechua',
        'rm' => 'Romansh',
        'rn' => 'Kirundi',
        'ro' => 'Romanian, Moldavian, Moldovan',
        'ru' => 'Russian',
        'rw' => 'Kinyarwanda',
        'sa' => 'Sanskrit (Sa?sk?ta)',
        'sc' => 'Sardinian',
        'sd' => 'Sindhi',
        'se' => 'Northern Sami',
        'sg' => 'Sango',
        'si' => 'Sinhala, Sinhalese',
        'sk' => 'Slovak',
        'sl' => 'Slovene',
        'sm' => 'Samoan',
        'sn' => 'Shona',
        'so' => 'Somali',
        'sq' => 'Albanian',
        'sr' => 'Serbian',
        'ss' => 'Swati',
        'st' => 'Southern Sotho',
        'su' => 'Sundanese',
        'sv' => 'Swedish',
        'sw' => 'Swahili',
        'ta' => 'Tamil',
        'te' => 'Telugu',
        'tg' => 'Tajik',
        'th' => 'Thai',
        'ti' => 'Tigrinya',
        'tk' => 'Turkmen',
        'tl' => 'Tagalog',
        'tn' => 'Tswana',
        'to' => 'Tonga (Tonga Islands)',
        'tr' => 'Turkish',
        'ts' => 'Tsonga',
        'tt' => 'Tatar',
        'tw' => 'Twi',
        'ty' => 'Tahitian',
        'ug' => 'Uighur, Uyghur',
        'uk' => 'Ukrainian',
        'ur' => 'Urdu',
        'uz' => 'Uzbek',
        've' => 'Venda',
        'vi' => 'Vietnamese',
        'vo' => 'Volapk',
        'wa' => 'Walloon',
        'wo' => 'Wolof',
        'xh' => 'Xhosa',
        'yi' => 'Yiddish',
        'yo' => 'Yoruba',
        'za' => 'Zhuang, Chuang',
        'zh' => 'Chinese',
        'zu' => 'Zulu'
      }

      def validate ess_tag
        unless LANGUAGES.has_key?(ess_tag.lang_attr) || ess_tag.lang_attr == ""
          raise ValidationError, "the \"lang\" attribute value is invalid: #{ess_tag.lang_attr}"
        end
      end
    end

    class UnitMandatoryIfRecurrent
      def validate item_tag
        if item_tag.type_attr == "recurrent"
          unless item_tag.unit_attr != ""
            raise ValidationError, "the \"unit\" attribute is mandatory in a date item if type is recurrent"
          end
        end
      end
    end

    DAYS_OF_WEEK = [ 'monday', 'tuesday', 'wednesday', 'thursday', 'friday',
                     'saturday', 'sunday']
    class SelectedDayCheck
      def validate date_item_tag
        sday = date_item_tag.selected_day_attr
        if !sday.empty?
          values = sday.split(",")
          bad_values = values.delete_if { |day| DAYS_OF_WEEK.include?(day) || day.to_i.to_s == day }
          if bad_values.any?
            raise ValidationError, "the values \"#{bad_values}\" are not allowed in the \"selected_day\" attribute of date items"
          end
        end
      end
    end

  end
end

