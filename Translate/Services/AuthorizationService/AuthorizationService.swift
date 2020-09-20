//
//  AuthorizationService.swift
//  Translate
//
//  Created by Anton Pryakhin on 20.09.2020.
//

import Alamofire
import Foundation
import RxSwift

class AuthorizationService {

    // MARK: - Public
    let folderId = "b1gpbci6glk31i4ncf9r"

    func getIamToken() -> Observable<String> {
        return checkIamToken()
            .flatMap { isValid -> Observable<String> in
                if let iamToken = self.iamToken, isValid == true {
                    return .just(iamToken)
                } else {
                    return self.createIamToken()
                }
            }
    }

    // MARK: - Private
    private let api = "https://iam.api.cloud.yandex.net/iam/v1"
    private let yandexPassportOauthToken = "AgAAAABFe2FtAATuwebgFvLOyE0mv5GsVcqyROs"

    private var iamToken: String?
    private var expiresAt: Date?

    private func checkIamToken() -> Observable<Bool> {
        return .create { [unowned self] observer in
            if let expiresAt = self.expiresAt, expiresAt > Date() {
                observer.onNext(true)
            } else {
                observer.onNext(false)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }

    private func createIamToken() -> Observable<String> {
        if Reachability.isConnectedToNetwork == false {
            return .error(AuthorizationServiceError.networkNotAvailable)
        }

        let parameters = TokenRequest(yandexPassportOauthToken: yandexPassportOauthToken)
        let encoder = JSONParameterEncoder.default
        let request = AF.request("\(api)/tokens", method: .post, parameters: parameters, encoder: encoder)

        return .create { [unowned self] observer in
            request.response { response in
                switch response.result {
                case .success(let data):
                    if let data = data {
                        do {
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(formatter)
                            let decodedData = try decoder.decode(TokenResponse.self, from: data)
                            self.iamToken = decodedData.iamToken
                            self.expiresAt = decodedData.expiresAt
                            observer.onNext(decodedData.iamToken)
                            observer.onCompleted()
                        } catch {
                            observer.onError(AuthorizationServiceError.dataNotDecoded)
                        }
                    } else {
                        observer.onError(AuthorizationServiceError.dataNotLoaded)
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
