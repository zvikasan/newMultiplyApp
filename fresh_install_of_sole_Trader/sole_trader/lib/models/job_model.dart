import 'package:flutter/cupertino.dart';

class Job {
  int jobId;
  int clientId;
  String jobName;
  String jobDescription;
  double jobHourlyRate;
  DateTime startTime;
  DateTime endTime;
  double jobAddedCosts;
  String jobNotes;
  int jobStatus;
  int isArchived;
  // jobStatus variable indicates whether the job hasn't been started (0), in progress (1), or completed (2)

  Job({
    this.clientId,
    this.jobHourlyRate,
    this.jobName,
    this.startTime,
    this.endTime,
    this.jobDescription,
    this.jobAddedCosts,
    this.jobNotes,
    this.jobStatus,
    this.isArchived,
  });
  Job.withId({
    this.jobId,
    this.clientId,
    this.jobHourlyRate,
    this.jobName,
    this.jobDescription,
    this.startTime,
    this.endTime,
    this.jobAddedCosts,
    this.jobNotes,
    this.jobStatus,
    this.isArchived,
  });

  Map<String, dynamic> toMap() {
    //function converting job object into map to store it into the database
    final map = Map<String, dynamic>();
    if (jobId != null) {
      map['job_id'] = jobId;
    }
    map['client_id'] = clientId;
    map['job_hourly_rate'] = jobHourlyRate;
    map['job_name'] = jobName;
    map['job_description'] = jobDescription;
    map['job_added_costs'] = jobAddedCosts;
    map['job_notes'] = jobNotes;
    map['job_status'] = jobStatus;
    map['is_archived'] = isArchived;
    if (startTime != null) {
      map['job_start_time'] = startTime
          .toIso8601String(); // need to convert in order to store in db
    } else {
      map['job_start_time'] = null;
    }
    if (endTime != null) {
      map['job_end_time'] = endTime.toIso8601String();
    } else {
      map['job_end_time'] = null;
    }

    return map;
  }

//Below function needed specifically for the undo table
  Map<String, dynamic> toUndoMap() {
    //function converting job object into map to store it into the database
    final map = Map<String, dynamic>();
    map['undo_id'] = 1;
    map['job_id'] = jobId;
    map['client_id'] = clientId;
    map['job_hourly_rate'] = jobHourlyRate;
    map['job_name'] = jobName;
    map['job_description'] = jobDescription;
    map['job_added_costs'] = jobAddedCosts;
    map['job_notes'] = jobNotes;
    map['job_status'] = jobStatus;
    map['is_archived'] = isArchived;
    if (startTime != null) {
      map['job_start_time'] = startTime
          .toIso8601String(); // need to convert in order to store in db
    } else {
      map['job_start_time'] = null;
    }
    if (endTime != null) {
      map['job_end_time'] = endTime.toIso8601String();
    } else {
      map['job_end_time'] = null;
    }

    return map;
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    DateTime _startTime;
    DateTime _endTime;

    if (map['job_start_time'] != null) {
      _startTime = DateTime.parse(map['job_start_time']);
    } else {
      _startTime = DateTime.now();
    }

    if (map['job_end_time'] != null) {
      _endTime = DateTime.parse(map['job_end_time']);
    } else {
      _endTime = DateTime.now();
    }
    // Retrieves maps from database and converts them back into job objects
    return Job.withId(
      jobId: map['job_id'],
      clientId: map['client_id'],
      jobHourlyRate: map['job_hourly_rate'],
      jobName: map['job_name'],
      jobDescription: map['job_description'],
      startTime: _startTime,
      endTime: _endTime,
      jobAddedCosts: map['job_added_costs'],
      jobNotes: map['job_notes'],
      jobStatus: map['job_status'],
      isArchived: map['is_archived'],
    );
  }

  double calculateJobEarnings(Job job) {
    double earnings;

    // var jobDuration = job.jobStatus == 2
    //     ? job.endTime.difference(job.startTime)
    //     : DateTime.now().difference(job.startTime);

    Duration jobDuration;
    if (job.jobStatus == 2) {
      jobDuration = job.endTime.difference(job.startTime);
    } else if (job.jobStatus == 1) {
      jobDuration = DateTime.now().difference(job.startTime);
    } else {
      jobDuration = Duration(seconds: 0);
    }

    format(jobDuration) => jobDuration
        .toString()
        .split('.')
        .first
        .padLeft(8, "0"); //this outputs the time in format hh:mm
    earnings = job.jobHourlyRate *
            double.parse(format(jobDuration).split(':')[0]) +
        (job.jobHourlyRate / 60) *
            double.parse(format(jobDuration).split(':')[
                1]); // calculating job earnings separately multiplying hours and minutes
    return (double.parse(earnings.toStringAsFixed(2)));

    // .roundToDouble()); //leaving only two digits after the decimal point
  }
}
