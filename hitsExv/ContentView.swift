//
//  ContentView.swift
//  hitsExv
//
//  Created by 阿久津栄一 on 2022/11/17.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //データベースを取り扱う
    @Environment(\.managedObjectContext) private var viewContext
    
    //コアデータよりデータ取得
    @FetchRequest(
        //ソート条件
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    //画面構築
    var body: some View {
        //ナビゲーションバー
        NavigationView {
            //データを取得しリスト表示
            List {
                ForEach(items) { item in
                    //ナビゲーションバーと連動
                    NavigationLink {
                        //データ取得
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                //Editボタン
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                //プラスボタン
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            //謎
            Text("Select an item")
        }
    }

    //+ボタンを押したときの動作
    private func addItem() {
        //アニメーション化
        withAnimation {
            //アイテムを保存
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            //保存
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

    //削除ボタンの動作
    private func deleteItems(offsets: IndexSet) {
        //アニメーション動作
        withAnimation {
            //offsets でボタンの要素番号を渡せる
            offsets.map { items[$0] }.forEach(viewContext.delete)

            //保存作業
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

//日付表示型を管理
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//初期値管理
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
