

import UIKit
import Alamofire
//import SwiftyJSON


//Swifty json ServiceResponse
//typealias ServiceResponse = (JSON, Error?) -> Void
typealias ServiceResponse = (NSDictionary, Error?) -> Void


//Check internet connection
var isReachable: Bool {
    return NetworkReachabilityManager()!.isReachable
}

class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

var isLoadingIndicatorOpen:Bool = false

@available(iOS 11.0, *)
//MARK: - WebService Class
public class WebService {
    
    //Variable Declaration
    static var call: WebService = WebService()
    
    
    //MARK: - WebService Call
    func withPath(_ url: String, parameter: [String:Any] = [String: Any](), isWithLoading: Bool = true, images: [ModelAPIImg] = [ModelAPIImg](), videoKey: [String] = ["video"], videoData: [Data] = [Data](),documents: [ModelAPIDocument] = [ModelAPIDocument](), audioKey: [String] = ["audio"], audioData: [Data] = [Data](), isNeedToken: Bool = true,isGetPara : Bool = false, methods: HTTPMethod = .post, completionHandler:@escaping ServiceResponse) {
        
        
        let finalURL = WebURL.baseURL + url
        
        print("URL :- \(finalURL)")
        print("Parameter :- \(parameter)")
        
        if (Network.reachability?.isReachable)!{
            
            if isWithLoading {
                if images.count > 0 || videoData.count > 0 || audioData.count > 0 || documents.count > 0 {
                  //  appShared.showProgressHud(processDone: 0.0)
                } else {
                   // appShared.showHud()
                }
                
            }
            
            var headers = HTTPHeaders()
            if isNeedToken {
                
                headers = [
                    "Accept": "application/json",
                    WebURL.tokenKey : ""
                ]
                
            }
            
            if images.count > 0 || videoData.count > 0 || audioData.count > 0 || documents.count > 0{
                
                Alamofire.upload (
                    multipartFormData: { multipartFormData in
                        
                        for (key, value) in parameter {
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                        }
                        
                        for i in 0..<images.count {
                            //                            multipartFormData.append(UIImageJPEGRepresentation(images[i].image, 0.1)!, withName: images[i].key, fileName: "file.jpg", mimeType: "image/jpeg")
                            
                            multipartFormData.append(images[i].image.jpegData(compressionQuality: 0.75)!, withName: images[i].key, fileName: "file.jpg", mimeType: "image/jpeg")
                        }
                        
                        for i in 0..<videoData.count {
                            multipartFormData.append(videoData[i], withName: videoKey[i], fileName: "file.mp4", mimeType: "video/mp4")
                        }
                        
                        for i in 0..<audioData.count {
                            multipartFormData.append(audioData[i], withName: audioKey[i], fileName: "file.m4a", mimeType: "audio/m4a")
                        }
                        
                        for i in 0..<documents.count {
                            
                            if documents[i].type == "pdf" {
                                multipartFormData.append(documents[i].documetData, withName: documents[i].key, fileName: "file.\(documents[i].type)", mimeType: "application/pdf")
                                
                            } else if documents[i].type == "doc" {
                                multipartFormData.append(documents[i].documetData, withName: documents[i].key, fileName: "file.\(documents[i].type)", mimeType: "application/msword")
                                
                            } else {
                                multipartFormData.append(documents[i].documetData, withName: documents[i].key, fileName: "file.\(documents[i].type)", mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
                            }
                        }
                },
                    to: finalURL,
                    headers : headers,
                    encodingCompletion: { encodingResult in
                        
                        
                        switch encodingResult {
                        case .success(let upload, _, _):
                            
                            upload.uploadProgress(closure: { (progress) in
                                
                                //ShowHud
                              //  appShared.showProgressHud(processDone: Float(progress.fractionCompleted))
                                
                            })
                            
                            upload.responseJSON { result in
                                
                                print(result)
                                print(result.result)
                                
                                if let httpError = result.result.error {
                                    
                                    print(NSString(data: result.data!, encoding: String.Encoding.utf8.rawValue)!)
                                    print(httpError._code)
                                    
                                    let response: [String: Any] = [
                                        "errorCode": httpError._code,
                                        "status": false,
                                        "message": "eror"
                                    ]
                                    
                                   
                                    completionHandler(response as NSDictionary, nil)
                                    
                                    if isWithLoading {
                                        //appShared.hideHud()
                                    }
                                }
                                
                                if  result.result.isSuccess {
                                    do{
                                        if let jsonData = result.data{
                                            let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                                            print(parsedData)

                                            let status = parsedData["status"] as? NSInteger ?? 0
                                          //  appShared.hideHud()

                                            if (status == 200){
                                                if let jsonArray = parsedData["data"] as? NSDictionary {
        //                                            completionHandler(jsonArray, nil)
                                                    completionHandler(parsedData as NSDictionary, nil)
                                                }

                                            }else if (status == 2){
                                                print("error message")
                                            }else{
                                                print("error message")
                                                completionHandler(parsedData as NSDictionary, nil)
                                            }
                                        }
                                    }catch{
                                        print("error message")
                                    }
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                            if isWithLoading {
                               // appShared.hideHud()
                            }
                        }
                })
            }
            else
            {
                
                Alamofire.request(finalURL, method: methods ,parameters: parameter,headers: headers)
                    .responseJSON {  result in
                        
                        print(result)
                        print(result.result)
                        
                        if let httpError = result.error {
                           // print(NSString(data: result.data!, encoding: String.Encoding.utf8.rawValue)!)
                           // print(httpError._code)
                            
                            let response: NSDictionary = [
                                "errorCode": httpError._code,
                                "StatusCode": result.response?.statusCode as Any,
                                "status": false,
                                "message": "ValidationMessage.somthingWrong"
                            ]
                            //let json = JSON(response)
                            completionHandler(response,httpError)
                        }
                        
                       
                            if let response = result.value as? NSDictionary{
                                //let json = JSON(response)
                                completionHandler(response, nil)
                            }
                       
                        
                        if isWithLoading {
                           // appShared.hideHud()
                        }
                }
            }
        }
        else {
            print("Internet is not available")
        }
    }
}

//MARK: Model

//ModelAPIImg
class ModelAPIImg {
    
    var key = "images[]"
    var image = UIImage()
    
    init() {
        self.key = "images[]"
        self.image = UIImage()
    }
    
    init(image:UIImage) {
        self.key = "images[]"
        self.image = image
    }
    
    init(image:UIImage,key:String) {
        self.key = key
        self.image = image
    }
}

//ModelAPIDocument
class ModelAPIDocument {
    
    var key = ""
    var type = ""
    var documetData = Data()
    
    init() {
        self.key = ""
        self.type = ""
        self.documetData = Data()
    }
    
    init(key:String,type:String,documetData:Data) {
        self.key = key
        self.type = type
        self.documetData = documetData
    }
}

