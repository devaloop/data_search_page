import 'package:devaloop_data_list_page/data_list_page.dart';
import 'package:devaloop_data_search_page/data_search_page.dart';
import 'package:devaloop_form_builder/form_builder.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<DataItem> db = List.generate(
        25,
        (index) => DataItem(
            title: 'Data ${index + 1}', subtitle: 'Data ${index + 1}'));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DataSearchPage(
        title: 'Search Doctor',
        subtitle: 'Search Doctor',
        inputFields: const [
          InputText(
            name: 'name',
            label: 'Name',
            isOptional: true,
          ),
          InputText(
            name: 'email',
            label: 'Email (Google Account)',
            isOptional: true,
          ),
        ],
        searchProcess: (inputValues) async {
          List<KeyWord> keywords = [];
          if (inputValues['name']!.getString() != null) {
            keywords.add(KeyWord(
              name: 'name',
              label: 'Name',
              hiddenValue: inputValues['name']!.getString()!,
              showedValue: inputValues['name']!.getString()!,
            ));
          }
          if (inputValues['email']!.getString() != null) {
            keywords.add(KeyWord(
              name: 'email',
              label: 'Email',
              hiddenValue: inputValues['email']!.getString()!,
              showedValue: inputValues['email']!.getString()!,
            ));
          }

          if (keywords.isEmpty) {
            return null;
          } else {
            for (var keyword in keywords) {
              if (keyword.name == 'name') {
                db = db
                    .where(
                      (element) => element.title
                          .toLowerCase()
                          .contains(keyword.hiddenValue.toLowerCase()),
                    )
                    .toList();
              }
              if (keyword.name == 'email') {
                db = db
                    .where(
                      (element) => element.subtitle
                          .toLowerCase()
                          .contains(keyword.hiddenValue.toLowerCase()),
                    )
                    .toList();
              }
            }

            return MapEntry(
              keywords,
              SearchWrapper(
                searchResult: Wrapper(
                  total: db.length,
                  data: db.take(10).toList(),
                ),
                showSearchResultMore: (wrapper, searchKeyWord) => Future(
                  () => MapEntry(
                    keywords,
                    Wrapper(
                      total: db.length,
                      data: db.take(wrapper.data.length + 10).toList(),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
