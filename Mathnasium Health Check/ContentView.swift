//
//  ContentView.swift
//  Mathnasium Health Check
//
//  Created by Kevin Aguilar on 6/9/21.
//

//TODO: Auto sign in *
//      Check if cell is already taken *
//      UI
//      Custom input

import SwiftUI
import SwiftJWT
import Alamofire
import GoogleAPIClientForREST
import GoogleSignIn

struct MyClaims: Claims {
    var iss: String
    var sub: String
    var aud: String
    var iat: Date
    var exp: Date
}

var bToken = ""

let lock = NSLock()

let header = Header(kid: "73a230394ec8510f11a82ffc7d94cf371d0e0b04")

let jwt = JWT(header: header, claims: MyClaims(iss: "admin1@mhcapp-315117.iam.gserviceaccount.com", sub: "admin1@mhcapp-315117.iam.gserviceaccount.com", aud: "https://sheets.googleapis.com/", iat: Date(timeIntervalSinceNow: 0), exp: Date(timeIntervalSinceNow: 3600)))

var qArray = ("A fever of 99.6 °F or greater now or in the preceding 3 days (or would have, but used fever reducing medicine)?","A new or worsening cough?","A sore throat?","Muscle or body aches?","Shortness of breath or difficulty breathing?","New loss of taste or smell?")

struct ContentView: View {
    
    //debugging tool
    //@State var counter = 0
    @State var currentQ = 0
    @State var currentMessage = qArray.0
    
    var body: some View {
        VStack{
                    
            
            Spacer()
            
            Text("Do you or any member of your household have any of the following symptoms:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")
            
            Spacer()
            
            if(currentQ == 0){
                Text(qArray.0)
                    .padding()
                    .multilineTextAlignment(.center)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration:1.0)))
                    .id("Q0")
            }else if(currentQ == 1){
                Text(qArray.1)
                    .padding()
                    .multilineTextAlignment(.center)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration:1.0)))
                    .id("Q1")
            }else if(currentQ == 2){
                Text(qArray.2)
                    .padding()
                    .multilineTextAlignment(.center)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration:1.0)))
                    .id("Q2")
            }else if(currentQ == 3){
                Text(qArray.3)
                    .padding()
                    .multilineTextAlignment(.center)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration:1.0)))
                    .id("Q3")
            }else if(currentQ == 4){
                Text(qArray.4)
                    .padding()
                    .multilineTextAlignment(.center)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration:1.0)))
                    .id("Q4")
            }else if(currentQ == 5){
                Text(qArray.5)
                    .padding()
                    .multilineTextAlignment(.center)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration:1.0)))
                    .id("Q5")
            }
            
            Spacer()
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    
                    currentQ = currentQ - 1
                                        
                    }){
                        Text("No")
                    }
                
                Spacer()
                
                Button(action: {
                    
                    currentQ = currentQ + 1
                                        
                    }){
                        Text("Yes")
                    }
                
                Spacer()
                
            }
            
            Spacer()
            
                        
            Button(action: {
                
                updateVals()
                
                }){
                    Text("Push here")
                }
            
            Spacer()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func SignIn(){
    
    var contents = ""
    var jwtString = ""
    
    let path = Bundle.main.path(forResource: "mhcapp-315117-73a230394ec8", ofType: "json")!
    
    do{
    contents = try String(contentsOfFile: path)
    //print(contents)
    }
    catch {
        print(error)
    }
    
    contents = "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC3CK9iWRKkv5+Y\noP8P4W/7wkuO8OklM3xFrX9b4zP5E/C2zH5YMHMRo3hsSlbXOlyxBXgE9Qdarfv8\n4HuNIcg8wjsYmBFi5CPgucfPtwAz1bRO0MDHYHAtLLNcl4mouxkFKtoN5EwvYvdu\nxgqr6SdtSIgM+08s+wdYJsbpshuRaHk02N9k9JSJJEZpYFwPQMbaH1SAsMndeK8m\n2UIP43M97uBPurzsvpBs1mcgvxvOUuPk1GhCCCgnBKgk6julWV7+v1fGeVOv/k+D\nVCnBcRZ+eK8s77Oy8FfbXlkICXkdEN1xTXCRUAsbncAVVtx74dO3heYL8Kf1i+NY\nEcvUdcUbAgMBAAECggEAERxavlLyuebAFhYBl4vNBY17Cs3daIDmU+KNpBrFYmT0\nJ+Kjcmh1GWey0Pd8zs9smDqZUb1RBq/P0tVu4hllDWkK+phHZ9CexK9uzS2fyI4T\nNnBa1Ui1XpkYhhtp3xWT7TZoVCF3jdEurchjJFcTkdUqAtdWO4TsLC1+gvJc6Wbg\nx8bYIYLgxnSmXptt/rDU4rJQNVOJuD+LF1ejbtwZHPwrdF/ZYt0MJyUTMjFppqDb\nJYL8kUWP0hrX8JbODeoquFQ71eTXDuM46P9x3XRFV5U+xvCOaMX88AvRW1tiXNcW\nMHjKqWPfkeohRsLp8TMsy6Bewh+TaSMTQ5up3iDfwQKBgQD0iZsnJDVCJhZ99CdV\n6CFHvqqsSdqoG4dfNfXXrUxPhPZ1wNcVytMGcqBriRQpSADjPYGlUFHFzIzyaBtJ\nlRZxs+uk/nmUS87wFMPNxrysOYzS+qPgSizdh5kJf4DqRosTfiNyt2ZHFVBC0ygY\nbuDQtgejT3LYOMRbCuC8wfRwOQKBgQC/nQzOzT2VL70TlvcXOUdZTEskImaF/mTV\nFdLAvzRcq+FG71tq2XKScAw2O5raV/lYW6HJZWT/eisTP0jKT24wbuqzaqbm2Otb\nIf/xlg3UISg1uBce9LKGf8CSepMEDFYVZ0GYI9l1HcxTRQQdvli7TERGiDDrZZi3\ni5Q4ues38wKBgB8nDKH+5d4IdiMToJM8IElAjAOo4Pc7kpJZkHkqdadHvBIiQARh\ns2KF5dPtQalEqABLDKIfylsVhPs4sgk8ugBAOIvrc1emFLXXH16uq8iRCFS0Y34m\nVPLf3GouWSD/XaZdEm0B2kDCAViSB/Cc530PQ4fVjj7ndHRYvWqultJZAoGAbtVU\n1zn4aRbX80DbY9+J2ak7vYb4boEbqfWZlkwC6aeyAunoowFsOC//oE8R30ILxIQc\nLPYtWWk9CUENxZf0UKeXsnf6WoUWffxIo2D8VrtnGsuE9C7uJMY4iYHFEA5irLax\nRmNWIVw/F9tP6jRz9sLCq1mTklWN5H0kGzvPRukCgYBHcpsqAVboUQXKRHaQysCZ\n/XbJc+Gl22AAa3PtIg48FkM2RmwDUDlVEpvQa9uK6QTRuP4ulOmPPhNxFEt34zWK\nZZuMCu3S12ep1b6WGwNVWirFhY88X9k9XrQGAI066rLfcwjpdJMpotN/cF2kqvWj\nV19PEw+8npfBZbQFoixTmQ==\n-----END PRIVATE KEY-----\n"
    
    
    let privateKey = contents.data(using: .utf8)!
    let rsaJWTEncoder = JWTEncoder(jwtSigner: JWTSigner.rs256(privateKey: privateKey))
    
    do{
    jwtString =  try rsaJWTEncoder.encodeToString(jwt)
    }
    catch{
        print(error)
    }
    //print(jwtString)
    bToken = jwtString
    //print(privateKey)
    
}

func updateVals(){
    
    
    lock.lock()
    
    readCells()
        
    lock.unlock()
    
}


func readCells() {
    
    let sheetID = "1yfrNE5mr1wajNaBaTE9yvQ69jSxjbxGhWjTU-soTVYU"
    
    let startRange = 1
    let endRange = 100
    
    let range = "A\(startRange):D\(endRange)"
    
    let header : HTTPHeaders = ["Authorization":"Bearer \(bToken)"]
    let requestURL = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(range)"
    AF.request(requestURL, method: .get, parameters:nil,encoding: JSONEncoding.default,headers: header).responseJSON { response in
        //print("Request: \(String(describing: response.request))")
        //print("Response: \(String(describing: response.response))")
        //print("Error: \(String(describing: response.error))")
        
        let json = response.value as! NSDictionary

        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            
            if utf8Text.contains("values"){
                print("Contains YESSS")
                let values = json["values"] as! NSArray
                let valuesSize = values.count

                let writeRange = "A\(valuesSize+1):D\(valuesSize+1)"
                
                let requestParams = [
                    "values": [
                        ["hi1", "hi2","hi3","hi4"],
                        ]
                    ]
                
                let WriteRequestURL = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(writeRange)?valueInputOption=USER_ENTERED"
                
                let req = AF.request(WriteRequestURL, method: .put, parameters: requestParams, encoding: JSONEncoding.default, headers: header)
                req.responseJSON { response in debugPrint("response") }
                
                
            }else{
                //First row is empty
                print("Does not contain")
                let writeRange = "A1:D1"
                let requestParams = [
                    "values": [
                        ["hi1", "hi2","hi3","hi4"],
                        ]
                    ]
                
                let WriteRequestURL = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(writeRange)?valueInputOption=USER_ENTERED"

                let req = AF.request(WriteRequestURL, method: .put, parameters: requestParams, encoding: JSONEncoding.default, headers: header)
                req.responseJSON { response in debugPrint("response") }
            
            }
            
        }
        
    }
    
    return
    
}
