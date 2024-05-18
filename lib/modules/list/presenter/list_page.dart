import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:review_bloc/modules/list/bloc/list_bloc.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  TextEditingController controllerName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scheduleMicrotask(() async {
      context.read<ListBloc>().add(const ListEventAllData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          BlocBuilder<ListBloc, ListState>(
            bloc: context.read<ListBloc>(),
            builder: (context, state) {
              if (state is ListStateSuccess) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    state.valueData.isEmpty
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: Text(
                                'Write anything to save:',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
                              itemCount: state.valueData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Dismissible(
                                    key: Key(state.valueData[index]),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      context.read<ListBloc>().add(
                                            ListEventRemovedData(index: index),
                                          );
                                    },
                                    background: Container(
                                      color: Colors.redAccent,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    child: Container(
                                      height: 50,
                                      color: Theme.of(context).colorScheme.inversePrimary,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 10,
                                            ),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: state.valueData[index].length > 2
                                                  ? Text(state.valueData[index].substring(0, 2))
                                                  : Text(state.valueData[index].substring(0, 1)),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              state.valueData[index],
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              //Divider(),
                            ),
                          ),
                  ],
                );
              }
              if (state is ListStateInitial) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: Text(
                      'Write anything to save:',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }
              if (state is ListStateError) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      state.messageError,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }
              if (state is ListStateLoading) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .1,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: TextFormField(controller: controllerName),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (controllerName.text.isNotEmpty) {
                          context
                              .read<ListBloc>()
                              .add(ListEventIncrementData(value: controllerName.text));
                          controllerName.clear();
                        }
                      },
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
