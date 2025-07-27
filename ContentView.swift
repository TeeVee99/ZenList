import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \TodoItemEntity.isCompleted, ascending: true),
            NSSortDescriptor(keyPath: \TodoItemEntity.priorityRaw, ascending: true)
        ],
        animation: .default)
    private var todos: FetchedResults<TodoItemEntity>
    
//    @FetchRequest(
//        sortDescriptors: [],
//        animation: .default
//    ) var todos: FetchedResults<NSManagedObject>

    @State private var newTodo: String = ""
    @State private var newPriority: Priority = .medium

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Minima.list")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)

            Divider()

            List {
                ForEach(todos) { todo in
                    HStack {
                        Button {
                            toggleComplete(todo)
                        } label: {
                            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(todo.isCompleted ? .green : .primary)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Text(todo.text ?? "")
                            .strikethrough(todo.isCompleted)
                            .foregroundColor(todo.isCompleted ? .gray : .primary)

                        Spacer()

                        Circle()
                            .fill(Priority(rawValue: Int(todo.priorityRaw))?.color ?? .gray)
                            .frame(width: 8, height: 8)

                        Button {
                            deleteTodo(todo)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 4)
                }
            }

            Divider()

            HStack {
                TextField("Add task", text: $newTodo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack(spacing: 8) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        PriorityDot(priority: priority,
                                    isSelected: newPriority == priority,
                                    onSelect: {
                                        newPriority = priority
                                    })
                    }
                }
                Button(action: addTodo) {
                    Image(systemName: "plus")
                }
                .keyboardShortcut(.defaultAction)
            }

            Text("Created by TJ ♡")
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(width: 400, height: 550)
    }

    private func addTodo() {
        guard !newTodo.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newItem = TodoItemEntity(context: viewContext)
        newItem.id = UUID()
        newItem.text = newTodo
        newItem.isCompleted = false
        newItem.priorityRaw = Int16(newPriority.rawValue)

        do {
            try viewContext.save()
            newTodo = ""
            newPriority = .medium
        } catch {
            print("Error saving: \(error)")
        }
    }

    private func deleteTodo(_ todo: TodoItemEntity) {
        viewContext.delete(todo)
        try? viewContext.save()
    }

    private func toggleComplete(_ todo: TodoItemEntity) {
        todo.isCompleted.toggle()
        try? viewContext.save()
    }
}
