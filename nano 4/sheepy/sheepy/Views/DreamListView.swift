//
//  ContentView.swift
//  sheepy
//
//  Created by Isabela Bastos Jastrombek on 24/11/24.
//

import SwiftUI
import SwiftData

struct DreamListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var dreams: [Dream]
    @State private var showAddDream = false
    @State private var searchText = ""
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                
                Image("sheepyImage")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Spacer()
                
                Text(greetingMessage)
                    .foregroundStyle(Color("Cream"))
                    .font(.custom("Shrikhand-Regular", size: .init(20)))
                
                
                Spacer()
            }
            .padding()
            
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color("LightBlue"))
                    .cornerRadius(24)
                    .ignoresSafeArea()
                
                HStack {
                    ZStack {
                        Rectangle()
                            .fill(Color("Cream").opacity(0.6))
                            .frame(height: 40)
                            .cornerRadius(8)
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .fontWeight(.bold)
                                .font(.title2)
                                .foregroundStyle(Color("DarkBlue"))
                                .padding(6)
                            TextField("",
                                      text: $searchText,
                                      prompt: Text("Search")
                                .foregroundColor(Color("LightBlue"))
                            )
                            .foregroundStyle(Color("DarkBlue"))
                            .frame(width: 240)
                        }
                        
                    }
                    
                    Button {
                        withAnimation {
                            isEditing.toggle()
                        }
                    } label: {
                        Image(systemName: isEditing ? "checkmark.circle.fill" : "ellipsis.circle.fill")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundStyle(Color("DarkBlue"))
                    }
                    
                    
                }
                .padding()
                
                NavigationView {
                    
                    List {
                        ForEach(filteredDreams) { dream in
                            NavigationLink {
                                DreamView(dream: dream)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(dream.title)
                                        .font(.custom("Roboto-Bold", size: .init(18)))
                                        .foregroundStyle(Color("LightCream"))
                                    Text(dream.date, style: .date)
                                        .font(.subheadline)
                                        .foregroundStyle(Color("Cream"))
                                }
                                .padding(8)
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("DarkBlue"))
                                .padding(.horizontal)
                                .padding(.vertical, 2)
                        )
                    }
                    .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color("LightBlue"))
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            Button {
                                showAddDream.toggle()
                            } label: {
                                ZStack{
                                    Circle()
                                        .fill(Color("Yellowy"))
                                        .frame(width: 50, height: 50)
                                    Image(systemName: "plus")
                                        .fontWeight(.bold)
                                        .font(.title2)
                                        .foregroundStyle(Color("DarkBlue"))
                                }
                                
                            }
                        }
                    }
                    .toolbarBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                .padding(.top, 72)
            }
            .padding(.horizontal)
        }
        .background{
            LinearGradient(gradient: Gradient(colors: [Color("DarkBlue"), Color("LightBlue")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showAddDream) {
            AddDreamView()
        }
    }
    
    private var greetingMessage: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12:
            return "Good Morning, Sheepy!"
        case 12..<18:
            return "Good Afternoon, Sheepy!"
        default:
            return "Good Evening, Sheepy!"
        }
    }
    
    private var filteredDreams: [Dream] {
        let filtered = searchText.isEmpty
        ? dreams
        : dreams.filter { dream in
            dream.title.localizedCaseInsensitiveContains(searchText) ||
            dream.content.localizedCaseInsensitiveContains(searchText)
        }
        
        return filtered.sorted { $0.date > $1.date }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let indicesToDelete = offsets.compactMap { offset in
                dreams.firstIndex(where: { $0.id == filteredDreams[offset].id })
            }
            for index in indicesToDelete {
                modelContext.delete(dreams[index])
            }
        }
    }
}

struct AddDreamView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("", text: $title, prompt: Text("Title")
                    .foregroundColor(Color("DarkBlue")))
                .listRowBackground(Color("Cream").opacity(0.6))
                .foregroundStyle(Color("DarkBlue"))
                TextEditor(text: $content)
                    .frame(height: 150)
                    .listRowBackground(Color("Cream").opacity(0.6))
                    .foregroundStyle(Color("DarkBlue"))
            }
            .preferredColorScheme(.dark)
            .scrollContentBackground(.hidden)
            .background(Color("LightBlue"))
            .navigationTitle("New Dream")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let newDream = Dream(title: title, content: content)
                        modelContext.insert(newDream)
                        dismiss()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

#Preview {
    DreamListView()
        .modelContainer(for: Dream.self, inMemory: true)
}

