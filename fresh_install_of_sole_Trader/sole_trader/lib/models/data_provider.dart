import 'package:flutter/foundation.dart';
import 'package:sole_trader/database_helper.dart';
import 'package:sole_trader/models/backup_reminders_model.dart';
import 'client_model.dart';
import 'job_model.dart';
import 'my_details_model.dart';
import 'dart:async';
import 'quote_model.dart';

class DataProvider with ChangeNotifier {
  MyDetails _myDetails;
  List<Client> _clientList;
  Map<int, int> _jobsCountMap;
  List<Job> _jobList;
  Client _client;

  Quote _quote;
  List<Quote> _quoteList;
  QuoteEntry _quoteEntry;
  List<QuoteEntry> _quoteEntryList;

  Future<MyDetails> getMyDetails() async {
    _myDetails = await DatabaseHelper.instance.getMyDetails();
    return _myDetails;
  }

  updateMyDetails(myDetails) async {
    await DatabaseHelper.instance
        .updateMyDetails(myDetails)
        .whenComplete(() async {
      _myDetails = await DatabaseHelper.instance.getMyDetails();
    });
    notifyListeners();
  }

  Future<List<Client>> getClientList() async {
    _clientList = await DatabaseHelper.instance.getClientList();
    return _clientList;
  }

  Future<List<Client>> getArchivedClientList() async {
    _clientList = await DatabaseHelper.instance.getArchivedClientList();
    return _clientList;
  }

  Future<Map<int, int>> getJobsCountMap() async {
    _jobsCountMap = await DatabaseHelper.instance.getJobsCountPerClient();
    return _jobsCountMap;
  }

  Future<Map<int, int>> getJobsCountForArchivedClientsMap() async {
    _jobsCountMap =
        await DatabaseHelper.instance.getJobsCountPerArchivedClient();
    return _jobsCountMap;
  }

  addClient(Client client) async {
    await DatabaseHelper.instance.addClient(client);
    notifyListeners();
  }

  updateClient(Client client) async {
    await DatabaseHelper.instance.updateClient(client);
    notifyListeners();
  }

  deleteClient(int clientId) async {
    await DatabaseHelper.instance.deleteClient(clientId);
    await DatabaseHelper.instance.deleteAllJobsForClient(clientId);
    notifyListeners();
  }

  archiveAllJobsForClient(int clientId) async {
    await DatabaseHelper.instance.archiveAllJobsForClient(clientId);
    notifyListeners();
  }

  restoreAllJobsForClient(int clientId) async {
    await DatabaseHelper.instance.restoreAllJobsForClient(clientId);
    notifyListeners();
  }

  Future<List<Job>> getJobList(int clientId) async {
    _jobList = await DatabaseHelper.instance.getJobList(clientId);
    return _jobList;
  }

  Future<List<Job>> getJobListWithArchived(int clientId) async {
    _jobList = await DatabaseHelper.instance.getJobListWithArchived(clientId);
    return _jobList;
  }

  addJob(Job job) async {
    await DatabaseHelper.instance.addJob(job);
    notifyListeners();
  }

  duplicateJob(Job job) async {
    await DatabaseHelper.instance.duplicateJob(job);
    notifyListeners();
  }

  updateJob(Job job) async {
    await DatabaseHelper.instance.updateJob(job);
    notifyListeners();
  }

  archiveJob(Job job) async {
    await DatabaseHelper.instance.archiveJob(job);
    notifyListeners();
  }

  deleteJob(int jobId) async {
    await DatabaseHelper.instance.deleteJob(jobId);
    notifyListeners();
  }

  deleteJobWithUndo(Job job) async {
    await DatabaseHelper.instance.addUndoJob(job).whenComplete(() async {
      await DatabaseHelper.instance.deleteJob(job.jobId);
    });
    notifyListeners();
  }

  restoreJob() async {
    await DatabaseHelper.instance.restoreJob();
    notifyListeners();
  }

  Future<Client> getClient(int clientId) async {
    _client = await DatabaseHelper.instance.getClient(clientId);
    return _client;
  }

  Future<Client> getArchivedClient(int clientId) async {
    _client = await DatabaseHelper.instance.getArchivedClient(clientId);
    return _client;
  }

  Future<BackupReminder> getBackupReminder() async {
    BackupReminder _backupReminder =
        await DatabaseHelper.instance.getBackupReminder();
    return _backupReminder;
  }

  updateBackupReminder(BackupReminder backupReminder) async {
    await DatabaseHelper.instance.updateBackupReminder(backupReminder);
    notifyListeners();
  }

  // The functions below deal with quotes
  Future<int> deleteAllQuotesForClient(int clientId) async {
    int result =
        await DatabaseHelper.instance.deleteAllQuotesForClient(clientId);
    return result;
  }

  Future<List<Quote>> getQuoteList(int clientId) async {
    _quoteList = await DatabaseHelper.instance.getQuoteList(clientId);
    return _quoteList;
  }

  Future<Quote> getQuote(int quoteId, int clientId) async {
    Quote quote = await DatabaseHelper.instance.getQuote(quoteId, clientId);
    return quote;
  }

  addQuote(Quote quote) async {
    await DatabaseHelper.instance.addQuote(quote);
    notifyListeners();
  }

  updateQuote(Quote quote) async {
    await DatabaseHelper.instance.updateQuote(quote);
    notifyListeners();
  }

  deleteQuote(int quoteId) async {
    await DatabaseHelper.instance.deleteQuote(quoteId);
    notifyListeners();
  }

  Future<List<QuoteEntry>> getQuoteEntryList(int quoteId) async {
    _quoteEntryList = await DatabaseHelper.instance.getQuoteEntryList(quoteId);
    return _quoteEntryList;
  }

  addQuoteEntry(QuoteEntry quoteEntry) async {
    await DatabaseHelper.instance.addQuoteEntry(quoteEntry);
    notifyListeners();
  }

  updateQuoteEntry(QuoteEntry quoteEntry) async {
    await DatabaseHelper.instance.updateQuoteEntry(quoteEntry);
    notifyListeners();
  }

  deleteQuoteEntry(QuoteEntry quoteEntry) async {
    await DatabaseHelper.instance.deleteQuoteEntry(quoteEntry);
    notifyListeners();
  }

  restoreQuoteEntry() async {
    await DatabaseHelper.instance.restoreQuoteEntry();
    notifyListeners();
  }
}
