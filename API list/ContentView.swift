//
//  ContentView.swift
//  API list
//
//  Created by Betzy Moreno on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var categories = [String]()
    var body: some View {
        NavigationView {
            List(categories, id: \.self) { category in
                NavigationLink(destination: Text(category)) {
                    Text(category)
                }
            }
            .navigationTitle("API Categories")
        }
        .task {
            await getCategories()
        }
    }
    
    func getCategories() async {
        let query = "https://api.publicapis.org/categories"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try?
                    JSONDecoder().decode(Categories.self, from: data) {
                    categories = decodedResponse.categories
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Categories: Codable {
    var categories: [String]
}
