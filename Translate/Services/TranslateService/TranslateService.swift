//
//  TranslateService.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Alamofire
import Foundation
import RxSwift

class TranslateService {

    // MARK: - Public
    func detectLanguage() {
    }

    func listLanguages() -> Observable<[Language]> {
        if Reachability.isConnectedToNetwork == false {
            return .error(TranslateServiceError.networkNotAvailable)
        }

        let parameters = ["folderId": folderId]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(IAMToken)"]
        let encoder = JSONParameterEncoder.default

        let request = AF.request("\(api)/languages", method: .post, parameters: parameters, encoder: encoder, headers: headers)

        return .create { observer in
            request.response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let decodedData = try decoder.decode(ListLanguagesResponse.self, from: data)
                            observer.onNext(decodedData.languages)
                            observer.onCompleted()
                        } catch {
                            observer.onError(TranslateServiceError.dataNotDecoded)
                        }
                    } else {
                        observer.onError(TranslateServiceError.dataNotLoaded)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    func translate() {
    }

    // MARK: - Private
    private let api = "https://translate.api.cloud.yandex.net/translate/v2"
    private let folderId = "b1gpbci6glk31i4ncf9r"
    private let IAMToken = "t1.9f7L7euelZqJipfOlozGzc2ek8ySm8bPjuXz9yZpZgT6739VL1T83fP3ZhdkBPrvf1UvVPw.2OdOlHc4_INFbZMDqMtTVUPx1BllJcnUkVyW224aD9nujSj8PqkuKN0LldokAzb73iJg9ifKhBpMn8L9J9e3CA"
}
