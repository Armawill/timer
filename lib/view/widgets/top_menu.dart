import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/view-model/timer_view_model.dart';

class TopMenu extends StatefulWidget {
  const TopMenu({
    super.key,
  });

  @override
  State<TopMenu> createState() => _TopMenuState();
}

class _TopMenuState extends State<TopMenu> {
  @override
  Widget build(BuildContext context) {
    var isEditMode = Provider.of<TimerViewModel>(context).isEditMode;
    var isCheckedAll = Provider.of<TimerViewModel>(context).isCheckedAll;
    return isEditMode
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Provider.of<TimerViewModel>(context, listen: false)
                      .turnOffEditMode();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
              Checkbox(
                value: isCheckedAll,
                onChanged: (value) {
                  Provider.of<TimerViewModel>(context, listen: false)
                      .changeAllCheckState(value);
                },
                side: BorderSide(
                  color: Colors.grey.shade500,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                fillColor: MaterialStateProperty.all(Colors.red),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Provider.of<TimerViewModel>(context, listen: false)
                      .turnOnEditMode();
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              )
            ],
          );
  }
}
