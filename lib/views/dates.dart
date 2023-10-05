import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salah_mate/controllers/dates_controller.dart';
import 'package:salah_mate/design.dart';
import 'package:salah_mate/views/prayers_due_in_time.dart';

class DatesPage extends ConsumerWidget {
  const DatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dates = ref.read(datesProvider).dates;
    return FutureBuilder(
      future: ref.watch(datesProvider).fetchDates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListTile(
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          ref
                              .read(datesProvider.notifier)
                              .deleteDate(dates[index]);
                        },
                      ),
                      title: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return PrayersDueInTimePage(
                                date: dates[index],
                              );
                            },
                          ));
                        },
                        child: Text(
                          dates[index],
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: dates.length,
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                padding: const EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: TextButton(
                                  child: Text(
                                    "Select the date",
                                    style: dTextTitleStyle100,
                                  ),
                                  onPressed: () async {
                                    await _selectDate(context, ref);
                                    await Future.delayed(Duration.zero, () {
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.add)),
                ]),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      ref
          .read(datesProvider.notifier)
          .addDate(picked.toString().substring(0, 10));
    }
  }
}
