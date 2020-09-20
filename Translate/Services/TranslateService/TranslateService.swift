//
//  TranslateService.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Alamofire
import Foundation
import RxSwift
import Swinject

class TranslateService {

    // MARK: - Dependencies
    private var authorizationService: AuthorizationService?

    // MARK: - Init
    init(authorizationService: AuthorizationService?) {
        self.authorizationService = authorizationService
    }

    // MARK: - Public
    func detectLanguage(text: String) -> Observable<String>? {
        if Reachability.isConnectedToNetwork == false {
            return .error(TranslateServiceError.networkNotAvailable)
        }

        return authorizationService?.getIamToken()
            .flatMap { [unowned self] iamToken -> Observable<String> in
                let parameters = DetectLanguageRequest(text: text,
                                                       languageCodeHints: nil,
                                                       folderId: self.authorizationService?.folderId)
                let headers: HTTPHeaders = ["Authorization": "Bearer \(iamToken)"]
                let request = AF.request("\(self.api)/detect", method: .post, parameters: parameters, encoder: self.encoder, headers: headers)

                return .create { observer in
                    request.response { response in
                        switch response.result {
                        case .success(let data):
                            if let data = data {
                                do {
                                    let decoder = JSONDecoder()
                                    let decodedData = try decoder.decode(DetectLanguageResponse.self, from: data)
                                    observer.onNext(decodedData.languageCode)
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
    }

    func listLanguages() -> Observable<[Language]>? {
        if Reachability.isConnectedToNetwork == false {
            return .error(TranslateServiceError.networkNotAvailable)
        }

        return authorizationService?.getIamToken()
            .flatMap { [unowned self] iamToken -> Observable<[Language]> in
                let parameters = ListLanguagesRequest(folderId: self.authorizationService?.folderId)
                let headers: HTTPHeaders = ["Authorization": "Bearer \(iamToken)"]
                let request = AF.request("\(self.api)/languages", method: .post, parameters: parameters, encoder: self.encoder, headers: headers)

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
    }

    func translate(sourceLanguageCode: String, targetLanguageCode: String, text: String) -> Observable<[Translation]>? {
        if Reachability.isConnectedToNetwork == false {
            return .error(TranslateServiceError.networkNotAvailable)
        }

        return authorizationService?.getIamToken()
            .flatMap { [unowned self] iamToken -> Observable<[Translation]> in
                let parameters = TranslateRequest(sourceLanguageCode: sourceLanguageCode,
                                                  targetLanguageCode: targetLanguageCode,
                                                  format: "PLAIN_TEXT",
                                                  texts: [text],
                                                  folderId: self.authorizationService?.folderId)
                let headers: HTTPHeaders = ["Authorization": "Bearer \(iamToken)"]
                let request = AF.request("\(self.api)/translate", method: .post, parameters: parameters, encoder: self.encoder, headers: headers)

                return .create { observer in
                    request.response { response in
                        switch response.result {
                        case .success(let data):
                            if let data = data {
                                do {
                                    let decoder = JSONDecoder()
                                    let decodedData = try decoder.decode(TranslateResponse.self, from: data)
                                    observer.onNext(decodedData.translations)
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
    }

    // MARK: - Private
    private let encoder = JSONParameterEncoder.default
    private let api = "https://translate.api.cloud.yandex.net/translate/v2"
}
