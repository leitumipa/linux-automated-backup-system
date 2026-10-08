# Linux Automated Backup System

A simple Linux backup system built with Bash that creates timestamped compressed backups, verifies backup archives, maintains a retention policy, logs backup activities, and provides a safe restore mechanism.

## 1. Project Overview

This project simulates a small automated backup system in a Linux environment.

The system takes files from a source directory, creates a `.tar.gz` archive, adds a timestamp to the backup filename, verifies the archive, stores backup logs, removes old backups according to a retention policy, and provides a restore script.

The project was designed as a beginner-friendly Linux portfolio project to practice Bash scripting, file management, archive management, logging, error handling, backup and restore concepts, and Linux task scheduling.

---

## 2. Objectives

The main objectives of this project are:

- Understand the fundamental concept of backup.
- Understand source and backup destinations.
- Create archives using `tar`.
- Compress archives using `gzip`.
- Generate timestamped backup filenames.
- Use Bash variables and functions.
- Handle errors using exit status.
- Verify backup archives.
- Record backup activities in log files.
- Implement a backup retention policy.
- Restore files from a backup archive.
- Automate backups using Linux cron.
- Practice basic Linux troubleshooting.

---

## 3. Environment

- Windows
- WSL2
- Ubuntu Linux
- Bash
- tar
- gzip
- cron
- Git

---

## 4. Features

### Backup

Creates a compressed `.tar.gz` archive from the source directory.

### Timestamp

Each backup receives a timestamped filename.

Example:

```text
backup-2026-10-08_164500.tar.gz
```

### Verification

The generated archive is checked using `tar -tzf` before the backup process is considered successful.

### Logging

Backup activities and errors are recorded in:

```text
logs/backup.log
```

Restore activities are recorded in:

```text
logs/restore.log
```

### Retention

The system keeps the latest five backup archives.

Older backups are automatically removed.

### Restore

The restore script extracts a selected backup into:

```text
restore-test/
```

This prevents the original `data/` directory from being overwritten during testing.

### Cron Automation

The backup script can be scheduled using Linux cron.

---

## 5. Architecture

```text
                         Windows
                            |
                            v
                           WSL2
                            |
                            v
                      Ubuntu Linux
                            |
                            v
                          cron
                            |
                            v
                       backup.sh
                            |
              +-------------+-------------+
              |             |             |
              v             v             v
            data/       timestamp       logs/
              |
              v
             tar
              |
              v
            gzip
              |
              v
           backup/
              |
              v
        verification
              |
              v
          retention
              |
              v
       old backups removed


                       Restore
                          |
                          v
                     restore.sh
                          |
                          v
                  archive validation
                          |
                          v
                      tar -xzf
                          |
                          v
                   restore-test/
```

---

## 6. Directory Structure

```text
backup-lab/
├── data/
│   ├── documents/
│   │   └── report.txt
│   ├── projects/
│   │   └── project-alpha.txt
│   └── notes/
│       ├── lab.txt
│       └── todo.txt
│
├── backup/
│   └── *.tar.gz
│
├── logs/
│   ├── backup.log
│   └── restore.log
│
├── scripts/
│   ├── backup.sh
│   └── restore.sh
│
├── restore-test/
│   └── restored files
│
└── README.md
```

---

## 7. Backup Process

The backup process follows these steps:

```text
1. Start backup
       |
2. Check source directory
       |
3. Generate timestamp
       |
4. Create .tar.gz archive
       |
5. Verify archive
       |
6. Apply retention policy
       |
7. Write log
       |
8. Finish
```

The backup command uses:

```bash
tar -czf
```

Where:

- `-c` = create archive
- `-z` = gzip compression
- `-f` = specify archive filename

---

## 8. Restore Process

The restore process follows:

```text
1. Select backup
       |
2. Check file exists
       |
3. Verify archive
       |
4. Extract archive
       |
5. Store result in restore-test/
       |
6. Write restore log
```

The extraction command uses:

```bash
tar -xzf
```

Where:

- `-x` = extract
- `-z` = gzip
- `-f` = archive file

---

## 9. Retention Policy

The project uses a count-based retention policy.

Configuration:

```bash
RETENTION_COUNT=5
```

This means the system keeps the five newest backup archives.

Example:

```text
Backup 7  <- KEEP
Backup 6  <- KEEP
Backup 5  <- KEEP
Backup 4  <- KEEP
Backup 3  <- KEEP
Backup 2  <- DELETE
Backup 1  <- DELETE
```

Retention prevents unlimited growth of backup files.

---

## 10. Logging

Backup activity is recorded in:

```text
logs/backup.log
```

Example:

```text
2026-10-08 16:50:01 - Backup started
2026-10-08 16:50:01 - Creating backup: backup/backup-2026-10-08_165001.tar.gz
2026-10-08 16:50:01 - Backup archive created
2026-10-08 16:50:01 - Backup verification successful
2026-10-08 16:50:01 - Total backups: 5
2026-10-08 16:50:01 - Backup completed successfully
```

Logging makes troubleshooting easier because the administrator can inspect what happened without relying only on terminal output.

---

## 11. Cron Automation

The backup script can be scheduled using cron.

Example:

```text
*/5 * * * * /home/<username>/backup-lab/scripts/backup.sh
```

This example runs the backup every five minutes for testing.

For a daily schedule:

```text
0 2 * * * /home/<username>/backup-lab/scripts/backup.sh
```

This means:

```text
Minute = 0
Hour   = 2
Day    = every day
Month  = every month
Weekday = every day
```

For WSL2, the Linux environment has a different lifecycle from a continuously running Linux server. Therefore, cron is useful for learning Linux scheduling, while Windows Task Scheduler can be considered when host-level scheduling is required.

---

## 12. Installation

Clone or copy the project into the Linux environment.

Move into the project:

```bash
cd ~/backup-lab
```

Make the scripts executable:

```bash
chmod +x scripts/backup.sh
chmod +x scripts/restore.sh
```

Verify:

```bash
ls -l scripts/
```

The scripts should have executable permission.

---

## 13. Manual Backup

Run:

```bash
./scripts/backup.sh
```

The script will:

- Check the source directory.
- Create a timestamp.
- Create a compressed archive.
- Verify the archive.
- Apply retention.
- Write logs.

---

## 14. View Backups

List backup files:

```bash
ls -lh backup/
```

List archive contents:

```bash
tar -tzf backup/backup-name.tar.gz
```

---

## 15. Restore

Run:

```bash
./scripts/restore.sh
```

Select one of the available backup files.

The backup will be extracted into:

```text
restore-test/
```

Verify:

```bash
find restore-test -type f
```

---

## 16. Testing

The project was tested using several scenarios.

### Test 1 — Normal Backup

Expected result:

```text
Backup archive created.
Backup verification successful.
Backup completed successfully.
```

### Test 2 — Missing Source Directory

The source directory was temporarily renamed.

Expected result:

```text
ERROR: Source directory 'data' tidak ditemukan.
```

The script exits with a non-zero status.

### Test 3 — Invalid Backup Archive

A fake `.tar.gz` file was created.

Expected result:

```text
ERROR: Backup archive rusak atau tidak valid.
```

### Test 4 — Restore

A valid backup was restored into:

```text
restore-test/
```

The restored files were verified using `find` and `cat`.

### Test 5 — Retention

Multiple backup archives were created.

The system kept the latest five backup files and removed older backups.

---

## 17. Troubleshooting

### Permission Denied

Check:

```bash
ls -l scripts/backup.sh
```

If the script is not executable:

```bash
chmod +x scripts/backup.sh
```

---

### Source Directory Not Found

Check:

```bash
pwd
ls
ls data/
```

Make sure the expected source directory exists.

---

### Backup Not Created

Check:

```bash
ls -lh backup/
```

Then inspect the log:

```bash
tail -n 20 logs/backup.log
```

Test `tar` manually:

```bash
tar -czf /tmp/test-backup.tar.gz data/
```

---

### Restore Failed

Check that the backup exists:

```bash
ls -lh backup/
```

Verify the archive:

```bash
tar -tzf backup/backup-name.tar.gz
```

If the archive cannot be read, it may be invalid or corrupted.

---

### Cron Not Running

Check cron:

```bash
systemctl status cron
```

Check scheduled jobs:

```bash
crontab -l
```

Check script permission:

```bash
ls -l scripts/backup.sh
```

Test the script manually:

```bash
./scripts/backup.sh
```

Check the backup log:

```bash
tail -n 20 logs/backup.log
```

---

## 18. Example Output

```text
================================
 Linux Automated Backup
================================

Source directory : data
Backup directory : backup
Backup file      : backup/backup-2026-10-08_164500.tar.gz

Backup archive created.
Verifying backup...
Backup verification successful.

Applying retention policy...
Total backups: 5
No old backups need to be removed.

Backup completed successfully.
```

---

## 19. Lessons Learned

This project provided practical experience with:

- Linux filesystem structure.
- Bash variables.
- Bash functions.
- Conditional statements.
- Loops.
- Bash arrays.
- Exit status.
- File and directory validation.
- `tar` archives.
- `gzip` compression.
- Timestamp generation.
- Logging.
- Error handling.
- Backup verification.
- Backup retention.
- Restore operations.
- Cron scheduling.
- Linux troubleshooting.

The main lesson is that a backup system is not only about creating an archive.

A reliable backup workflow also needs:

```text
Backup
+
Verification
+
Logging
+
Retention
+
Restore
+
Automation
```

---

## 20. Skills Demonstrated

```text
Linux
Bash Scripting
File Management
Archive Management
tar
gzip
Cron
Logging
Error Handling
Exit Status
Backup & Restore
Retention Policy
Basic Troubleshooting
Linux Automation
```

---

## 21. Future Improvements

Possible future improvements include:

- Backup remote storage.
- Backup to another server using SSH.
- Email or notification alerts.
- Backup encryption.
- Configuration file for backup settings.
- Multiple source directories.
- Size-based retention.
- Age-based retention.
- Backup integrity using checksums.
- Dedicated backup user.
- Systemd timer instead of cron.
- Windows Task Scheduler integration for WSL2.
- Monitoring and alerting.

---

## 22. Project Goal

This project was created as a Linux learning and portfolio project.

The goal is not to build a production-grade enterprise backup solution, but to demonstrate an understanding of how Linux, Bash, filesystem operations, archive management, logging, scheduling, and troubleshooting can be combined into a practical automation system.
