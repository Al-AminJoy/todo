import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/loading_view.dart';
import 'package:todo/models/Todo.dart';
import 'package:todo/todos_cubit.dart';
class TodosView extends StatefulWidget {
  const TodosView({Key key}) : super(key: key);

  @override
  _TodosViewState createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
      ),
      floatingActionButton: _floatingActionButton(context),
      body: BlocBuilder<TodoCubit,TodoState>(
        builder: (context, state) {
          if(state is ListTodoSuccess){
            return state.todos.isEmpty?_emptyTodosView(): _todosListView(state.todos);
          }
          else if(state is ListTodosFailure){
            return _exceptionView(state.exception);
          }
          else {
            return LoadingView();
          }
        },
      ),
    );
  }

  Widget _exceptionView(Exception exception){
    return Center(
      child: Text('$exception'),
    );
  }

  Widget _floatingActionButton(BuildContext context){
    return FloatingActionButton(
      onPressed: (){
        showModalBottomSheet(context: context,
          builder: (context) => _newTodoView(),);
      },
      child: Icon(Icons.add),);
  }

  Widget _emptyTodosView(){
    return Center(
      child: Text('No Todos Found'),
    );
  }

  Widget _todosListView(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          child: CheckboxListTile(
            title: Text(todo.title),
            value: todo.isComplete,
            onChanged: (newValue){
              BlocProvider.of<TodoCubit>(context).updateTodos(todo, newValue);
            },
          ),
        );
      },);
  }

  Widget _newTodoView() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
              hintText: 'Enter Todo Title'
          ),
        ),
        ElevatedButton(onPressed: (){
          BlocProvider.of<TodoCubit>(context).createTodos(_titleController.text);
          _titleController.text='';
          Navigator.of(context).pop();
        },
            child: Text('Save'))
      ],
    );
  }
}

