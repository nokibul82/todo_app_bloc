import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../blocs/todo_form/todo_form_bloc.dart';

class AddTodoSheetWidget extends StatelessWidget {
  const AddTodoSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.viewInsetsOf(context),
      child: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TitleFieldWidget(),
            SizedBox(
              height: 15,
            ),
            DetailsFieldWidget(),
            // SizedBox(
            //   height: 15,
            // ),
            // CategoryFieldWidget(),
            SizedBox(
              height: 15,
            ),
            DateFieldWidget(),
            SizedBox(
              height: 15,
            ),
            AddButtonWidget(),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class AddButtonWidget extends StatelessWidget {
  const AddButtonWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<TodoFormBloc>().state;
    final isLoading = state.status == TodoFormStatus.loading;

    return FilledButton(
        onPressed: isLoading || !state.isFormValid
            ? null
            : () {
                context.read<TodoFormBloc>().add(const TodoSubmitted());
                Navigator.pop(context);
              },
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                "Save",
                style: textTheme.titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ));
  }
}

class DateFieldWidget extends StatelessWidget {
  const DateFieldWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bloc = context.read<TodoFormBloc>();
    final state = context.watch<TodoFormBloc>().state;

    final formattedDate = state.initialTodo == null
        ? DateFormat("dd/MM/yyyy").format(state.date)
        : DateFormat("dd/MM/yyyy").format(state.initialTodo!.date);

    return GestureDetector(
      onTap: () async {
        final today = DateTime.now();
        final selectedDate = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            lastDate: DateTime(today.year + 50));
        if (selectedDate != null) {
          bloc.add(TodoDateChanged(selectedDate));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Date',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onBackground.withOpacity(0.4),
              height: 1,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Text(formattedDate, style: textTheme.titleLarge),
        ],
      ),
    );
  }
}

// class CategoryFieldWidget extends StatelessWidget {
//   const CategoryFieldWidget({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;
//     final colorScheme = theme.colorScheme;
//     final bloc = context.read<TodoFormBloc>();
//     final state = context.watch<TodoFormBloc>().state;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           'Select Category',
//           style: textTheme.labelLarge?.copyWith(
//             color: colorScheme.onBackground.withOpacity(0.4),
//             height: 1,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 0,
//           children: Category.values
//               .where((category) => category != Category.all)
//               .map((currentCategory) => ChoiceChip(
//                     label: Text(currentCategory.toName),
//                     selected: currentCategory == state.category,
//                     onSelected: (_) => bloc.add(
//                       ExpenseCategoryChanged(currentCategory),
//                     ),
//                   ))
//               .toList(),
//         ),
//       ],
//     );
//   }
// }

class DetailsFieldWidget extends StatelessWidget {
  const DetailsFieldWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<TodoFormBloc>().state;

    return TextFormField(
      keyboardType: TextInputType.number,
      style: textTheme.displaySmall?.copyWith(fontSize: 20),
      onChanged: (value) {
        context.read<TodoFormBloc>().add(TodoDetailsChanged(value));
      },
      initialValue: state.initialTodo?.details,
      decoration: InputDecoration(
          enabled: state.status != TodoFormStatus.loading,
          border: InputBorder.none,
          hintText: "Details",),
    );
  }
}

class TitleFieldWidget extends StatelessWidget {
  const TitleFieldWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<TodoFormBloc>().state;

    return TextFormField(
      style: textTheme.displaySmall?.copyWith(fontSize: 30),
      onChanged: (value) {
        context.read<TodoFormBloc>().add(TodoTitleChanged(value));
      },
      initialValue: state.initialTodo?.title,
      decoration: InputDecoration(
          enabled: state.status != TodoFormStatus.loading,
          border: InputBorder.none,
          hintText: "Title"),
    );
  }
}
