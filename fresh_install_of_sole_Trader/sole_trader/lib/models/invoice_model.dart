import 'job_model.dart';
import 'package:intl/intl.dart';
import 'package:duration/duration.dart';

class Invoice {
  Invoice({this.jobs});
  final List<Job> jobs;

  List<JobInvoice> formattedJobsList() {
    List<JobInvoice> formattedJobs = [];
    jobs.forEach((element) {
      formattedJobs.add(JobInvoice().formattedJob(element));
    });
    return formattedJobs;
  }
}

class JobInvoice {
  JobInvoice(
      {this.date,
      this.description,
      this.duration,
      this.hourlyRate,
      this.jobAddedCosts,
      this.jobNotes,
      this.totalCharge});

  String date;
  String description;
  String duration;
  double hourlyRate;
  double jobAddedCosts;
  // String jobAddedCosts;
  String jobNotes;
  double totalCharge;

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return date;
      case 1:
        return description;
      case 2:
        return duration;
      case 3:
        return _formatCurrency(hourlyRate);
      case 4:
        return _formatCurrency(jobAddedCosts);
      case 5:
        return jobNotes;
      case 6:
        return _formatCurrency(totalCharge);
    }
    return '';
  }

  JobInvoice formattedJob(Job job) {
    final DateFormat _dateFormatterJobDate = DateFormat('yMMMd');
    //dd MMM, yy
    JobInvoice formatJob = JobInvoice();

    formatJob.date = _dateFormatterJobDate.format(job.endTime);
    formatJob.description = job.jobDescription;
    formatJob.duration = printDuration(job.endTime.difference(job.startTime),
        abbreviated: true, tersity: DurationTersity.minute);
    formatJob.hourlyRate = job.jobHourlyRate;
    formatJob.jobAddedCosts = job.jobAddedCosts;
    formatJob.jobNotes = job.jobNotes;
    formatJob.totalCharge = job.calculateJobEarnings(job) + job.jobAddedCosts;
    return formatJob;
  }
}
