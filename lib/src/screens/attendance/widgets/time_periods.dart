enum TimePeriod { month, halfYear, year, custom }

final List<Map<String, dynamic>> timePeriods = const [
  {'text': 'За месяц', 'type': TimePeriod.month},
  {'text': 'За 6 месяцев', 'type': TimePeriod.halfYear},
  {'text': 'За год', 'type': TimePeriod.year},
  {'text': 'За период', 'type': TimePeriod.custom},
];
