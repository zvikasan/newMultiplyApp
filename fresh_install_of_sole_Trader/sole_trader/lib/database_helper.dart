import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'models/client_model.dart';
import 'models/job_model.dart';
import 'models/my_details_model.dart';
import 'models/backup_reminders_model.dart';
import 'models/quote_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;
  DatabaseHelper._instance();

  // Variables for the clients table
  String clientsTable = 'clients_table';
  String clientId = 'client_id';
  String clientNickname = 'client_nickname';
  String clientBillingName = 'client_billing_name';
  String clientAddress = 'client_address';
  String clientHourlyRate = 'client_hourly_rate';

  // Variables for the jobs table
  String jobsTable = 'jobs_table';
  String jobId = 'job_id';
  String jobName = 'job_name';
  String jobHourlyRate = 'job_hourly_rate';
  String jobDescription = 'job_description';
  String jobStartTime = 'job_start_time';
  String jobEndTime = 'job_end_time';
  String jobAddedCosts = 'job_added_costs';
  String jobNotes = 'job_notes';
  String jobStatus = 'job_status';

  // Variables for my_details table
  String myDetailsTable = 'my_details_table';
  String myDetailsTableId = 'my_table_id';
  String myBillingName = 'my_billing_name';
  String myBillingAddress = 'my_billing_address';
  String myAdditionalInfo = 'my_additional_info';
  String myExpectedPaymentPeriod = 'my_expected_payment_period';
  String myPaymentDetails = 'my_payment_details';
  String gstRequired = 'gst_required';
  String myMobile = 'my_mobile';
  String myEmail = 'my_email';
  String myTaxRate = 'my_tax_rate';
  String nextInvoiceNumber = 'next_invoice_number';

  //Additional variables for undo_delete table
  String undoTable = 'undo_table';
  String undoId = 'undo_id';

  //Additional variable for adding the archive feature
  String isArchived = 'is_archived';

  // Additional variables for backup reminders. Will be added to myDetails table
  String lastNotifiedDate = 'last_notified_date';
  String notificationPeriod = 'notification_period';

  //Variables for quotes functionality
  String quotesTable = 'quotes_table';
  String quoteId = 'quote_id';
  String quoteDate = 'date';
  String quoteValidUntil = 'valid_until';
  String quoteNumber = 'quote_number';

  String quoteEntriesTable = 'quote_entries_table';
  String quoteEntriesUndoTable = 'quote_entries_undo_table';
  String quoteEntryId = 'quote_entry_id';
  String quoteEntryDescription = 'description';
  String quoteEntryHourlyRate = 'hourly_rate';
  String quoteEntryEstimatedDuration = 'estimated_duration';
  String quoteEntryAddedCosts = 'added_costs';
  String quoteEntryNotes = 'notes';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'sole_trader.db');

    final soleTraderDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return soleTraderDb;
  }

  void _createDb(Database db, int version) async {
    String _timeNow = DateTime.now().toIso8601String();
    //creating the database
    await db.execute(
        'CREATE TABLE $clientsTable($clientId	INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, $clientNickname TEXT, $clientBillingName TEXT, $clientHourlyRate REAL, $clientAddress TEXT, $isArchived INTEGER)');
    await db.execute(
        'CREATE TABLE $jobsTable($jobId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, $clientId INTEGER, $jobName TEXT, $jobHourlyRate REAL, $jobStartTime TEXT, $jobEndTime TEXT, $jobDescription TEXT, $jobAddedCosts REAL, $jobNotes TEXT, $jobStatus INTEGER, $isArchived INTEGER)');
    await db.execute(
        'CREATE TABLE $myDetailsTable($myDetailsTableId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, $myBillingName TEXT, $myBillingAddress TEXT, $myAdditionalInfo TEXT, $myExpectedPaymentPeriod INTEGER, $myPaymentDetails TEXT, $gstRequired INTEGER, $myMobile TEXT, $myEmail TEXT, $myTaxRate REAL, $nextInvoiceNumber INTEGER, $lastNotifiedDate TEXT, $notificationPeriod INTEGER)');
    await db.execute(
        'CREATE TABLE $undoTable($undoId INTEGER, $jobId INTEGER, $clientId INTEGER, $jobName TEXT, $jobHourlyRate REAL, $jobStartTime TEXT, $jobEndTime TEXT, $jobDescription TEXT, $jobAddedCosts REAL, $jobNotes TEXT, $jobStatus INTEGER, $isArchived INTEGER)');
    await db.execute(
        'CREATE TABLE $quotesTable($quoteId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, $clientId INTEGER, $quoteNumber INTEGER, $quoteDate TEXT, $quoteValidUntil TEXT)');
    await db.execute(
        'CREATE TABLE $quoteEntriesTable($quoteEntryId INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE, $quoteId INTEGER, $quoteEntryDescription TEXT, $quoteEntryHourlyRate REAL, $quoteEntryEstimatedDuration REAL, $quoteEntryAddedCosts REAL, $quoteEntryNotes TEXT)');
    await db.execute(
        'CREATE TABLE $quoteEntriesUndoTable($undoId INTEGER, $quoteId INTEGER, $quoteEntryDescription TEXT, $quoteEntryHourlyRate REAL, $quoteEntryEstimatedDuration REAL, $quoteEntryAddedCosts REAL, $quoteEntryNotes TEXT)');

    //Adding the first dummy line in to the undo_table. DO NOT DELETE IT.
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $undoTable($undoId, $jobId, $clientId, $jobName, $jobHourlyRate, $jobDescription, $jobAddedCosts, $jobNotes, $jobStatus, $isArchived) VALUES(1, 1, 1, "blank job name", 0.0, "blank job description", 0.0, "blank job notes", 0, 0)');
    });
    //Adding the first dummy line in to the quote_entries_undo_table. DO NOT DELETE IT.
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $quoteEntriesUndoTable($undoId, $quoteId, $quoteEntryDescription, $quoteEntryHourlyRate, $quoteEntryEstimatedDuration, $quoteEntryAddedCosts, $quoteEntryNotes) VALUES(1, 1, "blank quote entry description", 0.0, 0.0, 0.0, "blank quote notes")');
    });

    //Adding template text into 'my_details' table that user will have to replace, and also backup reminder setting
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $myDetailsTable($myBillingName, $myBillingAddress, $myAdditionalInfo, $myExpectedPaymentPeriod, $myPaymentDetails, $gstRequired, $myMobile, $myEmail, $myTaxRate, $nextInvoiceNumber, $lastNotifiedDate, $notificationPeriod) VALUES("John Doe.", "123 Somewhere St, Suburbia VIC 1234", "ABN: 4568987521", 14, "ACC: 123456, BSB: 789101, Somebank", 0, "0411234567", "john_doe@gmails.com", 10, 1, "$_timeNow", 2)');
    });
    //Adding initial data into my_details_table
    //TODO Remove the initial data after testing is done
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $jobsTable($clientId, $jobName, $jobHourlyRate, $jobDescription, $jobAddedCosts, $jobNotes, $jobStatus, $isArchived) VALUES(1, "Cutting Grass", 55.4, "Cutting the very tall grass on backyard", 120, "added the cost of mower fuel", 0, 0)');
    });
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $jobsTable($clientId, $jobName, $jobHourlyRate, $jobDescription, $jobAddedCosts, $jobNotes, $jobStatus, $isArchived) VALUES(1, "Cleaning roof", 55.4, "Cleaning the dirty roof and gutters", 300.9, "included the cost of gutter netting", 0, 0)');
    });
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $jobsTable($clientId, $jobName, $jobHourlyRate, $jobDescription, $jobAddedCosts, $jobNotes, $jobStatus, $isArchived) VALUES(2, "Washing Car", 32.6, "Washing his very dirty expensive car", 31.4, "car wax premium added", 0, 0)');
    });
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $jobsTable($clientId, $jobName, $jobHourlyRate, $jobDescription, $jobAddedCosts, $jobNotes, $jobStatus, $isArchived) VALUES(2, "Mens Haircut", 32.6, "Cutting that long curly hair", 5.8, "exclusive hair styling gel price added", 0, 0)');
    });
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $clientsTable($clientNickname, $clientBillingName, $clientHourlyRate, $clientAddress, $isArchived) VALUES("Gosha", "Gosha  Kutsenko", 55.4, "4/10 Denbigh Street, Mornington, VIC 3198", 0)');
    });
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $clientsTable($clientNickname, $clientBillingName, $clientHourlyRate, $clientAddress, $isArchived) VALUES("Vasiliy", "Vasiliy Poopkin", 32.6, "12/4 Kars Street, Melbourne, VIC 3000", 0)');
    });
  }

  void deleteDb() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'sole_trader.db');
    await deleteDatabase(path);
  }

  void closeDatabase() async {
    Database db = await this.db;
    await db.close();
    _db = null;
  }

  Future<List<Map<String, dynamic>>> getClientMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(clientsTable);
    return result;
  }

  Future<List<Client>> getClientList() async {
    //gets only not archived clients
    final List<Map<String, dynamic>> clientMapList = await getClientMapList();
    final List<Client> clientList = [];
    clientMapList.forEach((element) {
      if (Client.fromMap(element).isArchived == 0) {
        clientList.add(Client.fromMap(element));
      }
    });
    clientList.sort(
        (clientB, clientA) => clientA.clientId.compareTo(clientB.clientId));
    return clientList;
  }

  Future<List<Client>> getFullClientList() async {
    //gets list of all clients (archived + not archived)
    final List<Map<String, dynamic>> clientMapList = await getClientMapList();
    final List<Client> clientList = [];
    clientMapList.forEach((element) {
      clientList.add(Client.fromMap(element));
    });
    return clientList;
  }

  Future<List<Client>> getArchivedClientList() async {
    //gets only archived clients
    final List<Map<String, dynamic>> clientMapList = await getClientMapList();
    final List<Client> clientList = [];
    clientMapList.forEach((element) {
      if (Client.fromMap(element).isArchived == 1) {
        clientList.add(Client.fromMap(element));
      }
    });
    clientList.sort(
        (clientB, clientA) => clientA.clientId.compareTo(clientB.clientId));
    return clientList;
  }

  Future<Client> getClient(int clientId) async {
    final List<Client> clientList = await getClientList();
    Client finalClient;
    for (Client client in clientList) {
      if (client.clientId == clientId) {
        finalClient = client;
        break;
      }
    }
    return finalClient;
  }

  Future<Client> getArchivedClient(int clientId) async {
    final List<Client> clientList = await getArchivedClientList();
    Client finalClient;
    for (Client client in clientList) {
      if (client.clientId == clientId) {
        finalClient = client;
        break;
      }
    }
    return finalClient;
  }

  Future<int> addClient(Client client) async {
    Database db = await this.db;
    final int result = await db.insert(clientsTable, client.toMap());
    return result;
  }

  Future<int> updateClient(Client client) async {
    Database db = await this.db;
    final int result = await db.update(
      clientsTable,
      client.toMap(),
      where: '$clientId = ?',
      whereArgs: [client.clientId],
    );
    return result;
  }

  Future<int> deleteClient(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      clientsTable,
      where: '$clientId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> deleteAllJobsForClient(int id) async {
    Database db = await this.db;
    var jobList = await getJobList(id);
    int result;
    if (jobList.isNotEmpty) {
      result = await db.delete(
        jobsTable,
        where: '$clientId = ?',
        whereArgs: [id],
      );
    } else {
      result = 0;
    }
    return result;
  }

  Future archiveAllJobsForClient(int id) async {
    var jobList = await getJobList(id);
    if (jobList.isNotEmpty) {
      for (Job job in jobList) {
        job.isArchived = 1;
        DatabaseHelper.instance.updateJob(job);
      }
    }
  }

  Future restoreAllJobsForClient(int id) async {
    var jobList = await getJobListWithArchived(id);
    if (jobList.isNotEmpty) {
      for (Job job in jobList) {
        job.isArchived = 0;
        DatabaseHelper.instance.updateJob(job);
      }
    }
  }

  Future<List<Map<String, dynamic>>> getJobMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(jobsTable);
    return result;
  }

  Future<List<Job>> getJobList(int clientId) async {
    // returns only not archived jobs
    final List<Map<String, dynamic>> jobMapList = await getJobMapList();
    final List<Job> jobList = [];

    for (Map<String, dynamic> job in jobMapList) {
      if (Job.fromMap(job).clientId == clientId &&
          Job.fromMap(job).isArchived == 0) {
        jobList.add(Job.fromMap(job));
      }
    }
    jobList.sort((jobB, jobA) => jobA.startTime.compareTo(jobB.startTime));
    return jobList;
  }

  Future<List<Job>> getJobListWithArchived(int clientId) async {
    // returns all jobs including archived ones
    final List<Map<String, dynamic>> jobMapList = await getJobMapList();
    final List<Job> jobList = [];

    for (Map<String, dynamic> job in jobMapList) {
      if (Job.fromMap(job).clientId == clientId) {
        jobList.add(Job.fromMap(job));
      }
    }
    jobList.sort((jobB, jobA) => jobA.startTime.compareTo(jobB.startTime));
    return jobList;
  }

  Future<Map<int, int>> getJobsCountPerClient() async {
    final List<Client> clientList = await getClientList();
    final Map<int, int> jobsCountMap = {};
    List<Job> jobsList = [];

    for (Client client in clientList) {
      jobsList = await getJobListWithArchived(client.clientId);
      jobsCountMap[client.clientId] = jobsList.length;
    }
    return jobsCountMap;
  }

  Future<Map<int, int>> getJobsCountPerArchivedClient() async {
    final List<Client> clientList = await getArchivedClientList();
    final Map<int, int> jobsCountMap = {};
    List<Job> jobsList = [];

    for (Client client in clientList) {
      jobsList = await getJobListWithArchived(client.clientId);
      jobsCountMap[client.clientId] = jobsList.length;
    }
    return jobsCountMap;
  }

  Future<List<Job>> getJobRangeList(
      //will not include archived jobs even when in selected date range
      int clientId,
      DateTime startDate,
      DateTime endDate) async {
    final List<Map<String, dynamic>> jobMapList = await getJobMapList();
    final List<Job> jobRangeList = [];
    jobMapList.forEach((element) {
      if (Job.fromMap(element).clientId == clientId &&
          Job.fromMap(element).isArchived == 0) {
        if (Job.fromMap(element).startTime.isAfter(startDate) &&
                Job.fromMap(element).startTime.isBefore(endDate) ||
            Job.fromMap(element).startTime.day == endDate.day) {
          jobRangeList.add(Job.fromMap(element));
        }
      }
    });
    jobRangeList.sort((jobA, jobB) => jobA.startTime.compareTo(jobB.startTime));
    return jobRangeList;
  }

  Future<List<Job>> getJobRangeListFinishedJobsOnly(
      //will not include archived jobs even when in selected date range
      int clientId,
      DateTime startDate,
      DateTime endDate) async {
    final List<Map<String, dynamic>> jobMapList = await getJobMapList();
    final List<Job> jobRangeList = [];
    jobMapList.forEach((element) {
      if (Job.fromMap(element).clientId == clientId &&
          Job.fromMap(element).isArchived == 0 &&
          Job.fromMap(element).jobStatus == 2) {
        if (Job.fromMap(element).startTime.isAfter(startDate) &&
                Job.fromMap(element).startTime.isBefore(endDate) ||
            Job.fromMap(element).startTime.day == endDate.day) {
          jobRangeList.add(Job.fromMap(element));
        }
      }
    });
    jobRangeList.sort((jobA, jobB) => jobA.startTime.compareTo(jobB.startTime));
    return jobRangeList;
  }

  Future<Job> getJob(int jobId) async {
    final List<Job> jobList = await getJobList(jobId);
    Job requestedJob;
    for (Job job in jobList) {
      if (job.jobId == jobId) {
        requestedJob = job;
        break;
      }
    }
    return requestedJob;
  }

  Future<int> addJob(Job job) async {
    Database db = await this.db;
    final int result = await db.insert(jobsTable, job.toMap());
    return result;
  }

  Future<int> addUndoJob(Job job) async {
    Database db = await this.db;
    final int result = await db.delete(
      undoTable,
      where: '$undoId = ?',
      whereArgs: [1],
    ).whenComplete(() async {
      await db.insert(undoTable, job.toUndoMap());
    });
    return result;
  }

  Future<int> restoreJob() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> undoTableMap = await db.query(undoTable);
    Job jobToUndo = Job.fromMap(undoTableMap[0]);
    final int result = await db.insert(jobsTable, jobToUndo.toMap());
    return result;
  }

  Future<int> duplicateJob(Job job) async {
    Database db = await this.db;
    Job dupJob = Job(
      clientId: job.clientId,
      jobName: job.jobName,
      jobDescription: job.jobDescription,
      jobHourlyRate: job.jobHourlyRate,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(seconds: 1)),
      jobAddedCosts: job.jobAddedCosts,
      jobNotes: job.jobNotes,
      jobStatus: 0,
      isArchived: 0,
    );

    final int result = await db.insert(jobsTable, dupJob.toMap());
    return result;
  }

  Future<int> updateJob(Job job) async {
    Database db = await this.db;
    final int result = await db.update(
      jobsTable,
      job.toMap(),
      where: '$jobId = ?',
      whereArgs: [job.jobId],
    );
    return result;
  }

  Future<int> archiveJob(Job job) async {
    Database db = await this.db;
    job.isArchived = 1;
    if (job.jobStatus == 1) {
      // needed when trying to archive job in progress
      job.endTime = DateTime.now();
      job.jobStatus = 2;
    }
    final int result = await DatabaseHelper.instance.updateJob(job);
    return result;
  }

  Future<int> deleteJob(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      jobsTable,
      where: '$jobId = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<List<Map<String, dynamic>>> getMyDetailsListMap() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(myDetailsTable);
    return result;
  }

  Future<MyDetails> getMyDetails() async {
    final List<Map<String, dynamic>> myDetailsMapList =
        await getMyDetailsListMap();
    final MyDetails myDetails = MyDetails.fromMap(myDetailsMapList[0]);
    return myDetails;
  }

  Future<int> updateMyDetails(MyDetails myDetails) async {
    Database db = await this.db;
    final int result = await db.update(
      myDetailsTable,
      myDetails.toMap(),
    );
    return result;
  }

  Future<BackupReminder> getBackupReminder() async {
    final List<Map<String, dynamic>> myDetailsMapList =
        await getMyDetailsListMap();
    final BackupReminder backupReminder =
        BackupReminder.fromMap(myDetailsMapList[0]);
    return backupReminder;
  }

  Future<int> updateBackupReminder(BackupReminder backupReminder) async {
    Database db = await this.db;
    final int result = await db.update(
      myDetailsTable,
      backupReminder.toMap(),
    );
    return result;
  }

  // Everything below deals with quotes section
  Future<List<Map<String, dynamic>>> getQuoteMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(quotesTable);
    return result;
  }

  Future<List<Quote>> getQuoteList(int clientId) async {
    //gets only not archived clients
    final List<Map<String, dynamic>> quoteMapList = await getQuoteMapList();
    final List<Quote> quoteList = [];
    quoteMapList.forEach((element) {
      if (Quote.fromMap(element).clientId == clientId) {
        quoteList.add(Quote.fromMap(element));
      }
    });
    quoteList.sort((quoteA, quoteB) => quoteA.date.compareTo(quoteB.date));
    return quoteList;
  }

  Future<Quote> getQuote(int quoteId, int clientId) async {
    final List<Quote> quoteList = await getQuoteList(clientId);
    Quote finalQuote;
    for (Quote quote in quoteList) {
      if (quote.quoteId == quoteId) {
        finalQuote = quote;
        break;
      }
    }
    return finalQuote;
  }

  Future<int> addQuote(Quote quote) async {
    Database db = await this.db;
    final int result = await db.insert(quotesTable, quote.toMap());
    return result;
  }

  Future<int> updateQuote(Quote quote) async {
    Database db = await this.db;
    final int result = await db.update(
      quotesTable,
      quote.toMap(),
      where: '$quoteId = ?',
      whereArgs: [quote.quoteId],
    );
    return result;
  }

  Future<int> deleteQuote(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      quotesTable,
      where: '$quoteId = ?',
      whereArgs: [id],
    );
    await deleteAllQuoteEntriesForQuote(id);

    return result;
  }

  Future<int> deleteAllQuoteEntriesForQuote(int id) async {
    Database db = await this.db;
    var quoteEntryList = await getQuoteEntryList(id);
    int result;
    if (quoteEntryList.isNotEmpty) {
      result = await db.delete(
        quoteEntriesTable,
        where: '$quoteId = ?',
        whereArgs: [id],
      );
    } else {
      result = 0;
    }
    return result;
  }

  Future<int> deleteAllQuotesForClient(int id) async {
    Database db = await this.db;
    var quoteList = await getQuoteList(id);
    int result;
    if (quoteList.isNotEmpty) {
      for (Quote quote in quoteList) {
        await deleteAllQuoteEntriesForQuote(quote.quoteId);
      }
      result = await db.delete(
        quotesTable,
        where: '$clientId = ?',
        whereArgs: [id],
      );
    } else {
      result = 0;
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getQuoteEntryMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(quoteEntriesTable);
    return result;
  }

  Future<List<QuoteEntry>> getQuoteEntryList(int quoteId) async {
    final List<Map<String, dynamic>> quoteEntryMapList =
        await getQuoteEntryMapList();
    final List<QuoteEntry> quoteEntryList = [];

    for (Map<String, dynamic> quoteEntry in quoteEntryMapList) {
      if (QuoteEntry.fromMap(quoteEntry).quoteId == quoteId) {
        quoteEntryList.add(QuoteEntry.fromMap(quoteEntry));
      }
    }
    return quoteEntryList;
  }

  Future<QuoteEntry> getQuoteEntry(int quoteEntryId, int quoteId) async {
    final List<QuoteEntry> quoteEntryList = await getQuoteEntryList(quoteId);
    QuoteEntry requestedQuoteEntry;
    for (QuoteEntry quoteEntry in quoteEntryList) {
      if (quoteEntry.quoteEntryId == quoteEntryId) {
        requestedQuoteEntry = quoteEntry;
        break;
      }
    }
    return requestedQuoteEntry;
  }

  Future<int> addQuoteEntry(QuoteEntry quoteEntry) async {
    Database db = await this.db;
    final int result = await db.insert(quoteEntriesTable, quoteEntry.toMap());
    return result;
  }

  Future<int> addUndoQuoteEntry(QuoteEntry quoteEntry) async {
    Database db = await this.db;
    final int result = await db.delete(
      quoteEntriesUndoTable,
      where: '$undoId = ?',
      whereArgs: [1],
    ).whenComplete(() async {
      await db.insert(quoteEntriesUndoTable, quoteEntry.toUndoMap());
    });
    return result;
  }

  Future<int> restoreQuoteEntry() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> quoteEntriesUndoTableMap =
        await db.query(quoteEntriesUndoTable);
    QuoteEntry quoteEntryToUndo =
        QuoteEntry.fromMap(quoteEntriesUndoTableMap[0]);
    final int result =
        await db.insert(quoteEntriesTable, quoteEntryToUndo.toMap());
    return result;
  }

  Future<int> updateQuoteEntry(QuoteEntry quoteEntry) async {
    Database db = await this.db;
    final int result = await db.update(
      quoteEntriesTable,
      quoteEntry.toMap(),
      where: '$quoteEntryId = ?',
      whereArgs: [quoteEntry.quoteEntryId],
    );
    return result;
  }

  Future<int> deleteQuoteEntry(QuoteEntry quoteEntry) async {
    Database db = await this.db;
    int result;
    await addUndoQuoteEntry(quoteEntry).whenComplete(() async {
      result = await db.delete(
        quoteEntriesTable,
        where: '$quoteEntryId = ?',
        whereArgs: [quoteEntry.quoteEntryId],
      );
    });
    return result;
  }
}
