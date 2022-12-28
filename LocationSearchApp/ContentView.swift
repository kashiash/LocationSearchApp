//
//  ContentView.swift
//  LocationSearchApp
//
//  Created by Jacek Kosinski U on 25/12/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 16, *){
            NavigationStack{
                SearchView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }else{
            NavigationView{
                SearchView()
                    .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
