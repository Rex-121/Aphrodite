//
//  AppIconPreview.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/14.
//

import SwiftUI

struct AppIconPreview: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \AppIcon.idiom, ascending: true)],
        animation: .default)
    private var items: FetchedResults<AppIcon>

    
    init() {
        AppleIconsReader().vv()
    }
    
    
    var body: some View {
        
        return NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.idiom ?? "") / \(item.size) / \(item.scale ?? "")")
                    } label: {
                        Text(item.idiom ?? "")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {

        withAnimation {
            let newItem = AppIcon(context: viewContext)
//            newItem.timestamp = Date()
            newItem.size = 60
            newItem.idiom = "iphone"
            newItem.scale = "2x"
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct AppIconPreview_Previews: PreviewProvider {
    static var previews: some View {
        AppIconPreview().environment(\.managedObjectContext, AppIconPersistence.preview.container.viewContext)
    }
}
