import 'package:amplify_flutter/amplify.dart';

import 'models/Todo.dart';

class TodosRepository{
  Future<List<Todo>> getTodos()async{
    try{
      final todos = await Amplify.DataStore.query(Todo.classType);
      return todos;
    }
    catch(e){
      throw e;
    }
  }

  Future<void> createTodos(String title)async{
    try{
      final newTodos = Todo(title: title,isComplete: false);
      await Amplify.DataStore.save(newTodos);
    }
    catch(e){
      throw e;
    }
  }

  Future<void> updateTodos(Todo todo,bool isComplete)async{
    try{
      final updatedTodo = todo.copyWith(isComplete: isComplete);
      await Amplify.DataStore.save(updatedTodo);
    }
    catch(e){
      throw e;
    }
  }
}