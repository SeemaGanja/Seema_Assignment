/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ModelNowPlaying : Codable {
	let dates : Dates?
	let page : Int?
	var results : [Results]?
	let totalPages : Int?
	let totalResults : Int?

	enum CodingKeys: String, CodingKey {

		case dates = "dates"
		case page = "page"
		case results = "results"
		case totalPages = "total_pages"
		case totalResults = "total_results"
	}

}

struct Dates : Codable {
    let maximum : String?
    let minimum : String?

    enum CodingKeys: String, CodingKey {

        case maximum = "maximum"
        case minimum = "minimum"
    }

   

}

struct Results : Codable {
    let adult : Bool?
    let backdropPath : String?
    let genreIds : [Int]?
    let id : Int?
    let originalLanguage : String?
    let originalTitle : String?
    let overview : String?
    let popularity : Double?
    let posterPath : String?
    let releaseDate : String?
    let title : String?
    let video : Bool?
    let voteAverage : Double?
    let voteCount : Int?

    enum CodingKeys: String, CodingKey {

        case adult = "adult"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id = "id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    

}


