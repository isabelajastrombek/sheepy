//
//  DreamView.swift
//  sheepy
//
//  Created by Isabela Bastos Jastrombek on 24/11/24.
//

import Foundation
import SwiftUI

struct DreamView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var isEditing = false
    @State private var title: String
    @State private var content: String
    @State private var date: Date

    let dream: Dream

    init(dream: Dream) {
        self.dream = dream
        _title = State(initialValue: dream.title)
        _content = State(initialValue: dream.content)
        _date = State(initialValue: dream.date)
    }

    var body: some View {
        NavigationView {
            Form {
                if isEditing {
                    TextField("Title", text: $title)
                        .foregroundStyle(Color("DarkBlue"))
                        .listRowBackground(Color("Cream").opacity(0.6))
                    TextEditor(text: $content)
                        .foregroundStyle(Color("DarkBlue"))
                        .frame(height: 150)
                        .listRowBackground(Color("Cream").opacity(0.6))
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .foregroundStyle(Color("DarkBlue"))
                        .listRowBackground(Color("Cream").opacity(0.6))
                } else {
                    Text("\(dream.title)")
                        .font(.headline)
                        .foregroundStyle(Color("DarkBlue"))
                        .listRowBackground(Color("Cream").opacity(0.6))
                    Text(dream.content)
                        .font(.body)
                        .foregroundStyle(Color("DarkBlue"))
                        .listRowBackground(Color("Cream").opacity(0.6))
                    Text("\(dream.date, style: .date)")
                        .font(.custom("Roboto-Regular", size: .init(18)))
                        .foregroundStyle(Color("LightBlue"))
                        .listRowBackground(Color("Cream").opacity(0.6))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color("LightBlue"))
//            .navigationTitle(isEditing ? "Edit Dream" : "Dream Details")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save" : "Edit") {
                        if isEditing {
                            saveChanges()
                        }
                        isEditing.toggle()
                    }
                }
                ToolbarItem(placement: .navigation){
                    Text(isEditing ? "Edit Dream" : "Dream Details")
                        .foregroundStyle(Color("DarkBlue"))
                        .bold()
                }
            }
        }
        .preferredColorScheme(.dark)
        .scrollContentBackground(.hidden)
        
    }

    private func saveChanges() {
        do {
            dream.title = title
            dream.content = content
            dream.date = date
            try modelContext.save() 
        } catch {
            print("Failed to save changes: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let sampleDream = Dream(title: "Sample text", content: "test", date: Date())
    DreamView(dream: sampleDream)
        .modelContainer(for: Dream.self, inMemory: true)
}
