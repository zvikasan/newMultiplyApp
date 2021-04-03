class Quote {
  int quoteId;
  int clientId;
  int quoteNumber;
  DateTime date;
  DateTime validUntil;

  Quote({this.clientId, this.quoteNumber, this.date, this.validUntil});

  Quote.withId(
      {this.quoteId,
      this.clientId,
      this.quoteNumber,
      this.date,
      this.validUntil});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (quoteId != null) {
      map['quote_id'] = quoteId;
    }
    map['client_id'] = clientId;
    map['quote_number'] = quoteNumber;
    if (validUntil != null) {
      map['valid_until'] = validUntil.toIso8601String();
    } else {
      map['valid_until'] = null;
    }
    if (date != null) {
      map['date'] = date.toIso8601String();
    } else {
      map['date'] = null;
    }
    return map;
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    DateTime _quoteDate;
    DateTime _quoteValidUntil;

    if (map['date'] != null) {
      _quoteDate = DateTime.parse(map['date']);
    } else {
      _quoteDate = null;
    }

    if (map['valid_until'] != null) {
      _quoteValidUntil = DateTime.parse(map['valid_until']);
    } else {
      _quoteValidUntil = null;
    }
    return Quote.withId(
      quoteId: map['quote_id'],
      clientId: map['client_id'],
      quoteNumber: map['quote_number'],
      date: _quoteDate,
      validUntil: _quoteValidUntil,
    );
  }
}

class QuoteEntry {
  int quoteEntryId;
  int quoteId;
  String description;
  double hourlyRate;
  double estimatedDuration;
  double addedCosts;
  String notes;

  QuoteEntry(
      {this.quoteId,
      this.description,
      this.hourlyRate,
      this.estimatedDuration,
      this.addedCosts,
      this.notes});

  QuoteEntry.withId(
      {this.quoteEntryId,
      this.quoteId,
      this.description,
      this.hourlyRate,
      this.estimatedDuration,
      this.addedCosts,
      this.notes});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (quoteEntryId != null) {
      map['quote_entry_id'] = quoteEntryId;
    }
    map['quote_id'] = quoteId;
    map['description'] = description;
    map['hourly_rate'] = hourlyRate;
    map['estimated_duration'] = estimatedDuration;
    map['added_costs'] = addedCosts;
    map['notes'] = notes;

    return map;
  }

  Map<String, dynamic> toUndoMap() {
    final map = Map<String, dynamic>();
    map['undo_id'] = 1;
    map['quote_id'] = quoteId;
    map['description'] = description;
    map['hourly_rate'] = hourlyRate;
    map['estimated_duration'] = estimatedDuration;
    map['added_costs'] = addedCosts;
    map['notes'] = notes;

    return map;
  }

  factory QuoteEntry.fromMap(Map<String, dynamic> map) {
    return QuoteEntry.withId(
      quoteEntryId: map['quote_entry_id'],
      quoteId: map['quote_id'],
      description: map['description'],
      hourlyRate: map['hourly_rate'],
      estimatedDuration: map['estimated_duration'],
      addedCosts: map['added_costs'],
      notes: map['notes'],
    );
  }

  double calculateEstimatedCost(QuoteEntry quoteEntry) {
    double estimatedCost;
    if (quoteEntry.addedCosts == null) {
      estimatedCost = quoteEntry.hourlyRate * quoteEntry.estimatedDuration;
    } else {
      estimatedCost = quoteEntry.hourlyRate * quoteEntry.estimatedDuration +
          quoteEntry.addedCosts;
    }
    return (double.parse(estimatedCost.toStringAsFixed(2)));
  }
}

class FormattedQuoteEntry {
  FormattedQuoteEntry(
      {this.description,
      this.estimatedDuration,
      this.hourlyRate,
      this.notes,
      this.addedCosts,
      this.totalCharge});

  String description;
  double estimatedDuration;
  double hourlyRate;
  String notes;
  double addedCosts;
  double totalCharge;

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String _formatDuration(double duration) {
    return '${duration.toString()}h';
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return description;
      case 1:
        return _formatCurrency(hourlyRate);
      case 2:
        return _formatDuration(estimatedDuration);
      case 3:
        return _formatCurrency(addedCosts);
      case 4:
        return notes;
      case 5:
        return _formatCurrency(totalCharge);
    }
    return '';
  }

  FormattedQuoteEntry formattedQuoteEntry(QuoteEntry quoteEntry) {
    FormattedQuoteEntry formatQuoteEntry = FormattedQuoteEntry();
    formatQuoteEntry.description = quoteEntry.description;
    formatQuoteEntry.hourlyRate = quoteEntry.hourlyRate;
    formatQuoteEntry.estimatedDuration = quoteEntry.estimatedDuration;
    formatQuoteEntry.addedCosts = quoteEntry.addedCosts;
    formatQuoteEntry.notes = quoteEntry.notes;
    formatQuoteEntry.totalCharge =
        quoteEntry.calculateEstimatedCost(quoteEntry);
    return formatQuoteEntry;
  }
}

class QuotePdf {
  QuotePdf({this.quoteEntries});
  final List<QuoteEntry> quoteEntries;

  List<FormattedQuoteEntry> formattedQuoteEntriesList() {
    List<FormattedQuoteEntry> formattedQuoteEntries = [];
    quoteEntries.forEach((element) {
      formattedQuoteEntries
          .add(FormattedQuoteEntry().formattedQuoteEntry(element));
    });
    return formattedQuoteEntries;
  }
}
