import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/models/ModelProvider.dart';
import 'package:todo/todos_repository.dart';

abstract class TodoState{}
class LoadingTodos extends TodoState{}

class ListTodoSuccess extends TodoState{
  final List<Todo> todos;
  ListTodoSuccess({this.todos});
}

class ListTodosFailure extends TodoState{
  final Exception exception;

  ListTodosFailure({this.exception});
}

class TodoCubit extends Cubit<TodoState>{
  final todosRepository = TodosRepository();
  TodoCubit() : super(LoadingTodos());

  void getTodos()async{
    if(state is ListTodoSuccess == false ){
      emit(LoadingTodos());
    }

    try{
      final todos = await todosRepository.getTodos();
      emit(ListTodoSuccess(todos: todos));
    }
    catch(e){
      emit(ListTodosFailure(exception: e));
    }
  }

  void createTodos(String title)async{
    await todosRepository.createTodos(title);
    getTodos();
  }

  void updateTodos(Todo todo,bool isComplete)async{
    await todosRepository.updateTodos(todo, isComplete);
    getTodos();
  }
}