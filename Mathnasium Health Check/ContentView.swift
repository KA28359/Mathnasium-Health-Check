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
import Combine

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

let qArray = ("A fever of 99.6°F or greater now or in the preceding 3 days (or would have, but used fever reducing medicine)?","A new or worsening cough?","A sore throat?","Muscle or body aches?","Shortness of breath or difficulty breathing?","New loss of taste or smell?","Had a confirmed case of COVID-19?","Had close contact with anyone with a suspected or confirmed case of COVID-19?","Been tested or advised to be tested due to a known or suspected exposure to COVID-19?","Been advised or directed to quarantine or self-isolate due to COVID-19?","Traveled to or from a restricted area?")

var savedName = UserDefaults.standard.string(forKey: "Name")

struct ContentView: View {
    
    @EnvironmentObject var view: ViewOptions

    var body: some View {
        
        VStack{
                    
            if view.studentName == "" {
                LoginView()
                    //.animation(.spring())
                    //.transition(.slide)
            }else{
                WelcomeView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewOptions())
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

func updateVals(stuName: String, responseArray: (String, String, String, String, String, String, String, String, String, String, String)){
    
    
    lock.lock()
    
    readCells(stuName: stuName, responseArray: responseArray)
        
    lock.unlock()
    
}


func readCells(stuName: String, responseArray: (String, String, String, String, String, String, String, String, String, String, String)) {
        
    let sheetID = "1yfrNE5mr1wajNaBaTE9yvQ69jSxjbxGhWjTU-soTVYU"
    
    let startRange = 1
    let endRange = 100
    
    let range = "A\(startRange):L\(endRange)"
    
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

                let writeRange = "A\(valuesSize+1):L\(valuesSize+1)"
                
                let requestParams = [
                    "values": [
                        [stuName, responseArray.0,responseArray.1,responseArray.2,responseArray.3,responseArray.4,responseArray.5,responseArray.6,responseArray.7,responseArray.8,responseArray.9,responseArray.10],
                        ]
                    ]
                
                let WriteRequestURL = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(writeRange)?valueInputOption=USER_ENTERED"
                
                let req = AF.request(WriteRequestURL, method: .put, parameters: requestParams, encoding: JSONEncoding.default, headers: header)
                req.responseJSON { response in debugPrint("response") }
                
                
            }else{
                //First row is empty
                print("Does not contain")
                let writeRange = "A1:L1"
                let requestParams = [
                    "values": [
                        [stuName, responseArray.0,responseArray.1,responseArray.2,responseArray.3,responseArray.4,responseArray.5,responseArray.6,responseArray.7,responseArray.8,responseArray.9,responseArray.10],
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

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .frame(height: 55)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 4)
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                .padding([.horizontal], 24)
            .font(Font.system(size: 20))
            .multilineTextAlignment(.center)
    }
}


struct LoginView: View {
    
    @State var exit = false
    @EnvironmentObject var view: ViewOptions
    @Environment(\.colorScheme) var colorScheme
    @State private var stuName = ""
    
//    @ObservedObject var stuName = NumbersOnly()
    
    @ObservedObject var settings = UserSettings()
    
    @State private var showingAlert = false
    
    func limitText(_ upper: Int) {
        if stuName.count > upper {
            stuName = String(stuName.prefix(upper))
            }
        }
    
    var body: some View {
        VStack {
            
            if exit{
                
                ContentView()
                    //.animation(.spring())
                    //.transition(.slide)
            }else{
                
                Spacer()
                
                Text("Mathnasium\n Health Check")
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .font(Font.system(size: UIScreen.main.bounds.size.height/15))
                    .multilineTextAlignment(.center)
            
            Spacer()
            
                TextField(
                    "Student ID",
                    text: $stuName)
                    //.keyboardType(.decimalPad)
                    .disableAutocorrection(true)
                    .textFieldStyle(OvalTextFieldStyle())
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    
                    //.frame(width:UIScreen.main.bounds.size.width*4/5,height:40)
                    .onReceive(Just(stuName)) { _ in limitText(6) }
                    
            
                
            Spacer()
            
                Button(action: {
                    //view.showLoginView = false
//                    view.studentName = GetStudentFromID(studentID: stuName)
                    
                    GetStudentFromID(studentID: stuName.uppercased()){ name in
                        
                        view.studentName = name
                        
                        if(view.studentName != ""){
                            showingAlert = false
                            view.showQuestionView = true
                            exit = true
                            
                            UserDefaults.standard.set(name, forKey: "Name")
                            
                        }else{
                            showingAlert = true
                        }
                        
                    }
                    
                    
                }) {
                    HStack {
                        Text("Next")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .background(stuName == "" ? Color.gray : Color.red)
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                    
                }.disabled(stuName == "")
                .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Student ID not found"), message: Text("The ID you entered was not found. Please try again."), dismissButton: .default(Text("Got it!")))
                }
            
            Spacer()
           }
        }
            
    }
}

struct Students{
    var studentID : Int
    var studentName : String
}


func GetStudentFromID(studentID: String, completionHandler: @escaping (String) -> Void) {
    
    var name = ""
    
    var found = false
    
    let sheetID = "15TOeP3XHdtawq5dk3czlgJ_r9Ysl3LoiEZ0vvVylCnU"
    
    let startRange = 1
    let endRange = 200
    
    let range = "A\(startRange):B\(endRange)"
    
    let header : HTTPHeaders = ["Authorization":"Bearer \(bToken)"]
    let requestURL = "https://sheets.googleapis.com/v4/spreadsheets/\(sheetID)/values/\(range)"
    AF.request(requestURL, method: .get, parameters:nil,encoding: JSONEncoding.default,headers: header).responseJSON { response in
        //print("Request: \(String(describing: response.request))")
        //print("Response: \(String(describing: response.response))")
        //print("Error: \(String(describing: response.error))")
        
        let json = response.value as! NSDictionary
        

        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            
            if utf8Text.contains("values"){
                let values = json["values"] as! NSArray
                let valuesSize = values.count
                
                print("Value size:")
                print(valuesSize)
                
                
                let objCArray = NSMutableArray(array: values)
                
                var arr : [[String]] = []

                if let swiftArray = objCArray as? [[String]] {

                    arr = swiftArray
                }
                
                for a in arr{
                    
                    if a.first == String(studentID){
                        name = a.last!
                        found = true
                    }
                    
                    if found { break }
                    
                }
                
                if found {
                    completionHandler(name)
                }else{
                    completionHandler("")
                }
                
                                
            }else{
                //First row is empty
                print("Does not contain")
                
            }
            
        }
        
    }
   
    
    
}


struct QuestionZeroView: View {
    
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @EnvironmentObject var view: ViewOptions
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
        
            if view.showQuestionOneView{
                
                QuestionOneView()
                
            }else{
                
                Spacer()

                Text("Do you or any member of your household have any of the following symptoms:")
                    .padding()
                    .multilineTextAlignment(.center)
                    .id("TitleQuestion")

                Spacer()
                    .frame(height: 50)

                    Text(qArray.0)
                    .padding()
                    .multilineTextAlignment(.center)
                    .id("Q0")
                    .frame(height: 150)

                Spacer()
                    .frame(height: 50)

                HStack{

                    Spacer()

                    Button(action: {
                        
                        if(didTapNo == false){
                        self.didTapNo.toggle()
                        if(didTapYes){
                            self.didTapYes.toggle()
                        }
                        }
                        
                            
                        }){
                            Text("No")
                                .fontWeight(.bold)
                                .font(.title)
                                .padding()
                                .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                                .cornerRadius(40)
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                .padding(10)
                                .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.red, lineWidth: 5)
                                        )
                        
                        
                        }

                    Spacer()

                    Button(action: {
                        
                        if(didTapYes == false){
                        self.didTapYes.toggle()
                        if(didTapNo){
                            self.didTapNo.toggle()
                        }
                        }
                    }){
                        Text("Yes")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                        
                    }

                    Spacer()

                }
                
                Spacer()
                
                            
                Button(action: {
                    
                    if(didTapYes){
                        view.responses.0 = "yes"
                        view.recivedYes = true
                    }else if(didTapNo){
                        view.responses.0 = "no"
                    }
                    
                    view.showQuestionOneView = true
                    
                    }){
                    HStack {
                        Text("Next")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                }.disabled(didTapNo == false && didTapYes == false)
                
                Spacer()
                
            }
            
        }
        
    }
    
}


struct QuestionOneView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if view.showQuestionTwoView{
                
                QuestionTwoView()
                
            }else{
                
            
            Spacer()

            Text("Do you or any member of your household have any of the following symptoms:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.1)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q1")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
                
                Button(action: {
                    if(didTapYes){
                        view.responses.1 = "yes"
                        view.recivedYes = true
                    }else if(didTapNo){
                        view.responses.1 = "no"
                    }
                    
                    view.showQuestionTwoView = true
                }) {
                    HStack {
                        Text("Next")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
    
}



struct QuestionTwoView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if view.showQuestionThreeView{
                
                QuestionThreeView()
                
            }else{
                
            
            Spacer()

            Text("Do you or any member of your household have any of the following symptoms:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.2)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q2")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
            
                        
            Button(action: {
                
                if(didTapYes){
                    view.responses.2 = "yes"
                    view.recivedYes = true
                }else if(didTapNo){
                    view.responses.2 = "no"
                }
                
                view.showQuestionThreeView = true
                
                }){
                HStack {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                .cornerRadius(40)
                .padding(.horizontal, 20)
            }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
}

struct QuestionThreeView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if view.showQuestionFourView{
                
                QuestionFourView()
                
            }else{
                
            
            Spacer()

            Text("Do you or any member of your household have any of the following symptoms:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.3)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q3")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
            
                        
            Button(action: {
                
                if(didTapYes){
                    view.responses.3 = "yes"
                    view.recivedYes = true
                }else if(didTapNo){
                    view.responses.3 = "no"
                }
                
                view.showQuestionFourView = true
                
                }){
                HStack {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                .cornerRadius(40)
                .padding(.horizontal, 20)
            }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
}

struct QuestionFourView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if view.showQuestionFiveView{
                
                QuestionFiveView()
                
            }else{
                
            
            Spacer()

            Text("Do you or any member of your household have any of the following symptoms:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.4)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q4")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
            
                        
            Button(action: {
                
                if(didTapYes){
                    view.responses.4 = "yes"
                    view.recivedYes = true
                }else if(didTapNo){
                    view.responses.4 = "no"
                }
                
                view.showQuestionFiveView = true
                
                }){
                HStack {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                .cornerRadius(40)
                .padding(.horizontal, 20)
            }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
}

struct QuestionFiveView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if view.showQuestionSixView{
                
                QuestionSixView()
                
            }else{
                
            
            Spacer()

            Text("Do you or any member of your household have any of the following symptoms:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.5)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q5")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
            
                        
            Button(action: {
                
                if(didTapYes){
                    view.responses.5 = "yes"
                    view.recivedYes = true
                }else if(didTapNo){
                    view.responses.5 = "no"
                }
                
                view.showQuestionSixView = true
                
                }){
                HStack {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                .cornerRadius(40)
                .padding(.horizontal, 20)
            }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
}

struct QuestionSixView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if view.showQuestionSevenView{
                
                QuestionSevenView()
                
            }else{
                
            
            Spacer()

            Text("In the last 14 days, have you or any member of your household:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.6)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q6")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
            
                        
            Button(action: {
                
                if(didTapYes){
                    view.responses.6 = "yes"
                    view.recivedYes = true
                }else if(didTapNo){
                    view.responses.6 = "no"
                }
                
                view.showQuestionSevenView = true
                
                }){
                HStack {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                .cornerRadius(40)
                .padding(.horizontal, 20)
            }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
}

struct QuestionSevenView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if view.showQuestionEightView{
                
                QuestionEightView()
                
            }else{
                
            
            Spacer()

            Text("In the last 14 days, have you or any member of your household:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.7)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q7")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
            
                        
            Button(action: {
                
                if(didTapYes){
                    view.responses.7 = "yes"
                    view.recivedYes = true
                }else if(didTapNo){
                    view.responses.7 = "no"
                }
                
                view.showQuestionEightView = true
                
                }){
                HStack {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                .cornerRadius(40)
                .padding(.horizontal, 20)
            }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
}

struct QuestionEightView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if view.showQuestionNineView{
                
                QuestionNineView()
                
            }else{
                
            
            Spacer()

            Text("In the last 14 days, have you or any member of your household:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.8)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q8")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
            
                        
            Button(action: {
                
                if(didTapYes){
                    view.responses.8 = "yes"
                    view.recivedYes = true
                }else if(didTapNo){
                    view.responses.8 = "no"
                }
                
                view.showQuestionNineView = true
                
                }){
                HStack {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                .cornerRadius(40)
                .padding(.horizontal, 20)
            }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
}

struct QuestionNineView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if view.showQuestionTenView{
                
                QuestionTenView()
                
            }else{
                
            
            Spacer()

            Text("In the last 14 days, have you or any member of your household:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.9)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q9")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
            
                        
            Button(action: {
                
                if(didTapYes){
                    view.responses.9 = "yes"
                    view.recivedYes = true
                }else if(didTapNo){
                    view.responses.9 = "no"
                }
                
                view.showQuestionTenView = true
                
                }){
                HStack {
                    Text("Next")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                .cornerRadius(40)
                .padding(.horizontal, 20)
            }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
}

struct QuestionTenView: View {
    
    @EnvironmentObject var view: ViewOptions
    @State private var didTapNo:Bool = false
    @State private var didTapYes:Bool = false
    @State private var eval:Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack{
            
            if eval{
                
                if view.recivedYes {
                    
                    FailView()
                    
                }else{
                    
                    SuccessView()
                    
                }
                
            }else{
                
            
            Spacer()

            Text("In the last 14 days, have you or any member of your household:")
                .padding()
                //.font(.title)
                .multilineTextAlignment(.center)
                //.transition(.opacity)
                .id("TitleQuestion")

            Spacer()
                .frame(height: 50)

                Text(qArray.10)
                .padding()
                .multilineTextAlignment(.center)
                    
                .id("Q10")
                .frame(height: 150)

            Spacer()
                .frame(height: 50)

            HStack{

                Spacer()

                Button(action: {
                    
                    if(didTapNo == false){
                    self.didTapNo.toggle()
                    if(didTapYes){
                        self.didTapYes.toggle()
                    }
                    }
                        
                    }){
                        Text("No")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding()
                            .background(didTapNo ? Color.red : Color(UIColor.systemBackground))
                            .cornerRadius(40)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(10)
                            .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red, lineWidth: 5)
                                    )
                    
                    
                    }

                Spacer()

                Button(action: {
                    
                    if(didTapYes == false){
                    self.didTapYes.toggle()
                    if(didTapNo){
                        self.didTapNo.toggle()
                    }
                    }

                }){
                    Text("Yes")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(didTapYes ? Color.red : Color(UIColor.systemBackground))
                        .cornerRadius(40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(10)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.red, lineWidth: 5)
                                )
                    
                }

                Spacer()

            }
            
            Spacer()
            
                        
            Button(action: {
                
                if(didTapYes){
                    view.responses.10 = "yes"
                    view.recivedYes = true
                }else if(didTapNo){
                    view.responses.10 = "no"
                }
                
                eval = true
                updateVals(stuName: view.studentName!, responseArray: view.responses)
                
                }){
                HStack {
                    Text("Done")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                .background((didTapNo == false && didTapYes == false) ? Color.gray : Color.red)
                .cornerRadius(40)
                .padding(.horizontal, 20)
            }.disabled(didTapNo == false && didTapYes == false)
            
            Spacer()
        }
        }
        
    }
}

struct SuccessView: View {
    
    @EnvironmentObject var view: ViewOptions
    
    var body: some View {
        
        ZStack {
                    Color.green
                        .ignoresSafeArea()
        
            VStack{
                
                Spacer()
                Text("✓")
                            .foregroundColor(Color.white)
                            .font(.system(size:UIScreen.main.bounds.size.width/2))
                               .padding(30)
                    .overlay(Circle()
                                .stroke(lineWidth: 20.0)
                                .foregroundColor(Color.white)
                                .frame(width:UIScreen.main.bounds.size.width))
                
                Spacer()
                    
                
                Text(view.studentName!+", you're good to go!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width:UIScreen.main.bounds.size.width*3/4)
                
                Spacer()
                
            }
        
        
        }
        
        
    }
    
    
}

struct FailView: View {
    
    @EnvironmentObject var view: ViewOptions
    
    var body: some View {
        
        ZStack {
                    Color.red
                        .ignoresSafeArea()
        
            VStack{
                
                Spacer()
                Text("X")
                            .foregroundColor(Color.white)
                            .font(.system(size:UIScreen.main.bounds.size.width/2))
                               .padding(30)
                    .overlay(Circle()
                                .stroke(lineWidth: 20.0)
                                .foregroundColor(Color.white)
                                .frame(width:UIScreen.main.bounds.size.width))
                
                Spacer()
                    
                
                Text(view.studentName!+", call the center for more information.")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width:UIScreen.main.bounds.size.width*3/4)
                
                Spacer()
                
            }
        
        
        }
        
        
    }
    
    
}

struct WelcomeView: View {
    
    @EnvironmentObject var view: ViewOptions
    @Environment(\.colorScheme) var colorScheme
    @State var goToLogin = false
    @State var goToQuestions = false
    let hour = Calendar.current.component(.hour, from: Date())
    let NEW_DAY = 0
    let NOON = 12
    let MIDNIGHT = 24
    
    let morningGreeting = "Good Morning\n"
    let afternoonGreeting = "Good Afternoon\n"
    
    var body: some View {
        
        if goToLogin{
            LoginView()
        }else if goToQuestions{
            QuestionZeroView()
        }else{
            
            VStack{
                
                Spacer()
                
                Text((hour > NEW_DAY && hour < NOON) ? morningGreeting+view.studentName! : afternoonGreeting+view.studentName!)
                    .font(.system(size:UIScreen.main.bounds.size.height/20))
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .multilineTextAlignment(.center)
                    .frame(width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height/4)
                    
                
                Spacer()
                
                Button(action: {
                    
                    goToQuestions = true
                    
                }){
                    HStack {
                        Text("Continue")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .background(Color.red)
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                Button(action: {
                    
                    UserDefaults.standard.set(nil, forKey: "Name")
                    view.studentName = ""
                    goToLogin = true
                    
                }){
                    HStack {
                        Text("Log Out")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .background(Color.red)
                    .cornerRadius(40)
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                
            }
            
            
        }
        
    }
    
}


class ViewOptions: ObservableObject{
    
    //@Published var showLoginView: Bool = test == nil ? true : false
    @Published var showQuestionView: Bool = false
    @Published var showQuestionOneView: Bool = false
    @Published var showQuestionTwoView: Bool = false
    @Published var showQuestionThreeView: Bool = false
    @Published var showQuestionFourView: Bool = false
    @Published var showQuestionFiveView: Bool = false
    @Published var showQuestionSixView: Bool = false
    @Published var showQuestionSevenView: Bool = false
    @Published var showQuestionEightView: Bool = false
    @Published var showQuestionNineView: Bool = false
    @Published var showQuestionTenView: Bool = false
    @Published var showQuestionElevenView: Bool = false
    @Published var currentMessage = qArray.0
    
    @Published var studentName = savedName == nil ? "" : savedName
    
    @Published var responses = ("","","","","","","","","","","")
    
    @Published var recivedYes = false
    
}

