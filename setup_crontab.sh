#!/bin/bash
#
# =========================
#   script to rebuild crontab
#
#   Author: 
#	Nuruzzaman <nur@fnal.gov> -- 2016-08-07
# =========================
setup_cron() {
	host=`/bin/hostname`
#	sourcedir="/home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/authenticate"
	sourcedir=`/bin/pwd`
	machine="$LOGNAME@$host"

	echo "# crontab for $LOGNAME@$host"
	echo "# generated at `date` by $(basename $BASH_SOURCE) script"
	echo "#"
	echo "# PLEASE DO NOT EDIT THIS CRONTAB BY HAND!"
	echo "#"
	echo "# If you need to modify the crontab on this machine, please edit the"
	echo "# $(basename $BASH_SOURCE) script located in the folder:"
	echo "# $sourcedir "
	echo "# Please commit the updated script to CVS, and then run it."
	echo ""
	
	# first, some generalities
	echo "SHELL=/bin/bash"
	echo "MAILTO=\"\""
	echo ""
	echo ""

# Setup cronjobs for the Control Room machines on haed node (minerva-cr-03)
# ===========================
	if [ "minerva@minerva-cr-03.fnal.gov" = "$machine" ]; then
		cat <<CRONTEXTCR03

## Shift summary plots
#55 5,13,21 * * *  . /home/minerva/.bashrc && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/misc/all_variable.sh && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/MakeShiftSummaryPlot && echo Shift summary plots were created at \`date\` | mail -s "Shift Summary Plots" nur@fnal.gov 
#52 16 * * * . /home/minerva/.bashrc && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/misc/all_variable.sh && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/MakeShiftSummaryPlot && echo Shift summary plots were created at \`date\` | mail -s "Shift Summary Plots" nur@fnal.gov 

## Dummy plot for shift summary
#25 2,10,18 * * * source /home/minerva/.bashrc && source /etc/profile && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/RemoveShiftSummaryPlot
#52 14 * * * source /home/minerva/.bashrc && source /etc/profile && /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/RemoveShiftSummaryPlot

## DAQ clock livetime plot: Hourly plot runs every 10 minutes, Weekly plot runs every Wed at 11.56 pm, monthly plot runs evry 8 hours.
#*/2 * * * * . /home/minerva/.bashrc && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/misc/all_variable.sh && . /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/daq_uptime/live_status_plot 

#55 23 * * 3 source /home/minerva/.bashrc && source /etc/profile && /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/daq_uptime/weekly_plot && echo Weekly DAQ clock livetime plots were created at \`date\` | mail -s "Weekly DAQ Clock Livetime Plots" nur@fnal.gov
#*/10 * * * * source /home/minerva/.bashrc && source /etc/profile && /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/daq_uptime/live_status_plot 
#55 5,13,21 * * * source /home/minerva/.bashrc && source /etc/profile && /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/daq_uptime/plot_daq_livetime 31 

#*/2 * * * * source /home/minerva/.bashrc && source /etc/profile && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/automated_ecl/ecl_post_7_2c/setup.sh && /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/daq_uptime/live_status_plot >> /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/daq_uptime/cronjob.log 2>&1
#*/2 * * * * source /home/minerva/.bashrc && source /etc/profile && /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/daq_uptime/weekly_plot 7 && echo Weekly DAQ clock livetime plots were created at \`date\` | mail -s "Weekly DAQ Clock Livetime Plots" nur@fnal.gov
#*/2 * * * * source /home/minerva/.bashrc && source /etc/profile && /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/daq_uptime/plot_daq_livetime 31 && echo Daily DAQ clock livetime plots were created at \`date\` | mail -s "Daily DAQ Clock Livetime Plots" nur@fnal.gov

## Copy GMBrowser cycle plots to the website
*/2 * * * * source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/gmbrowser_plot_cycle_copy

## Run control log file copy for website
*/2 * * * * source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/daq_uptime/copy_run_control_log_files

## Check all the process for controls every 5 minutes
*/5 * * * * source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/check_process 

## Script to submit ECL entry for run series
*/10 * * * * source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/automated_ecl/ecl_post_7_2c/setup.sh && python /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/automated_ecl/scripts/auto_start_run_series.py

## Start VNC server automatically
@reboot sleep 60 && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/expertShift all restartallvnc && echo Restarted FNAL \`hostname\` VNC server at \`date\` | mail -s "VNC Server" nur@fnal.gov

## Check the disk space of the machine
55 7,15,23 * * *  source /home/minerva/.bashrc && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/data_scripts/space_check

## Check the disk mount on the machine
* * * * *  source /home/minerva/.bashrc && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/data_scripts/mount_check

CRONTEXTCR03

# minerva-cr-01
# ============
	elif [ "minerva@minerva-cr-01.fnal.gov" = "$machine" ]; then
		cat <<CRONTEXTCR01

## Start VNC server automatically
@reboot sleep 60 && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/expertShift fnal restartvnc && echo Restarted FNAL \`hostname\` VNC server at \`date\` | mail -s "VNC Server" nur@fnal.gov

## Check the disk space of the machine
55 7,15,23 * * *  source /home/minerva/.bashrc && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/data_scripts/space_check

CRONTEXTCR01

# minerva-cr-02
# ============
	elif [ "minerva@minerva-cr-02.fnal.gov" = "$machine" ]; then
		cat <<CRONTEXTCR02

## Start VNC server automatically
@reboot sleep 60 && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/SmartShift/expertShift fnal restartvnc && echo Restarted FNAL \`hostname\` VNC server at \`date\` | mail -s "VNC Server" nur@fnal.gov

## Check the disk space of the machine
55 7,15,23 * * *  source /home/minerva/.bashrc && source /home/minerva/cmtuser/Minerva_v10r9p1/Tools/ControlRoomTools/data_scripts/space_check

CRONTEXTCR02

# Setup cronjobs for the DAQ machines on haed node (mnvonline06)
# ============
	elif [ "minerva@mnvonline06.fnal.gov" = "$machine" ]; then
		cat <<CRONTEXTDAQ06

## Clean out the data_vault
07 10 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/runCheckAndDelete.sh 
#00 11 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/checkoutput_checkAndDelete -e
07 15 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/checkdel.sh
11 15 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/checkdel_latest.sh

## Copies log and sam metadata files over to mnvonlinelogger for the echecklist
*/3 * * * * /home/minerva/Tools/ControlRoomTools/data_scripts/copy_nearline_logs_ecklist

## DAQ Livetime Calculation
*/2 * * * * source /home/minerva/Tools/ControlRoomTools/daq_uptime/daq_uptime.sh
## DAQ logfile copy for website
*/2 * * * * source /home/minerva/Tools/ControlRoomTools/daq_uptime/copy_daq_log_files

## Copies rawdata, metadata SAM, and log files offline to /minerva/data2/ on minervagpvm 
00 3,15 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/copy_minerva_raw_data -e nur@FNAL.GOV -f '/work/data/rawdata/*.dat' -r /minerva/data2/rawdata -l /work/data_vault -g /work/logs/copy_logs/ -p rawdata -w 43200
01 3,15 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/copy_minerva_raw_data -e nur@FNAL.GOV -f '/work/data/sam/*.metadata.*' -r /minerva/data2/rawdata -l /work/data_vault -g /work/logs/copy_logs/ -p sam -w 43200
02 3,15 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/copy_minerva_raw_data -e nur@FNAL.GOV -f '/work/data/logs/*Log.txt' -r /minerva/data2/rawdata -l /work/data_vault -g /work/logs/copy_logs/ -p logfiles -w 43200

## Check copy status, archive copied files to the vault
06 8,20 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/check_copied_data -v -f '/work/data/rawdata/copied/*.md5' -r /minerva/data2/rawdata -l /work/data_vault -g /work/logs/copy_logs/ -m -n /work/data/data_vault
06 9,21 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/check_copied_data -v -f '/work/data/sam/copied/*.md5' -r /minerva/data2/rawdata -l /work/data_vault -g /work/logs/copy_logs/ -m -n /work/data/data_vault
06 10,22 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/check_copied_data -v -f '/work/data/logs/copied/*.md5' -r /minerva/data2/rawdata -l /work/data_vault -g /work/logs/copy_logs/ -m -n /work/data/data_vault

00 05,17 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/clean_etsys -v -e -w 43200
50 05 * * * /home/minerva/Tools/ControlRoomTools/data_scripts/copy_sqlitedb 

## Check Minerva DAQ status
@reboot sleep 300; /home/minerva/mnvdaqrunscripts/minerva-check.py >& /work/logs/minerva-check.log
0 */4 * * *  /home/minerva/mnvdaqrunscripts/watch-minerva-check.sh >& /work/logs/watch-minerva-check.log

CRONTEXTDAQ06


# mnvonline04
# ============
	elif [ "minerva@mnvonline04.fnal.gov" = "$machine" ]; then
#		cat <<CRONTEXTDAQ04
                echo "I don't think I'm supposed to be running here.  Not doing anything..." > 2
                exit 0
#CRONTEXTDAQ04


# mnvonline05
# ============
	elif [ "minerva@mnvonline05.fnal.gov" = "$machine" ]; then
#		cat <<CRONTEXTDAQ05
                echo "I don't think I'm supposed to be running here.  Not doing anything..." > 2
                exit 0
#CRONTEXTDAQ05

# mnvonlinelogger06
# ============
	elif [ "nearonline@mnvonlinelogger6.fnal.gov" = "$machine" ]; then
		cat <<CRONTEXTLOGGER6

# "DAQ checker" for the e-Checklist
# Runs every 3 minutes starting on the hour
*/3 * * * * source /home/nearonline/scripts/setup_nearline_software.sh && python /home/nearonline/scripts/eChecklist/mnvchklastev_mnvonline03.py

# "DST checker" for the e-Checklist
# Runs every 3 minutes starting at 2 minutes after the hour
2-59/3 * * * * source /home/nearonline/scripts/setup_nearline_software.sh && python /home/nearonline/scripts/eChecklist/mnvchkdst.py

# make sure that the "watch-and-copy" process for the real-time online monitoring
# is running.  (it maintains a PID file so that it won't run more than one copy
# at the same time.)
# Runs every 5 minutes starting on the hour
*/5 * * * * source /home/nearonline/scripts/setup_nearline_software.sh && python /home/nearonline/scripts/sync_realtime_monitoring_files.py > /dev/null

# clean out old entries in the e-Checklist table
# Runs every 60 minutes on the hour
*/60 * * * * source /home/nearonline/scripts/setup_nearline_software.sh && python /home/nearonline/scripts/eChecklist/chk_currm.py
# Runs at 0400 hours
00 04 * * * source /home/nearonline/scripts/setup_nearline_software.sh && python /home/nearonline/scripts/eChecklist/cp_runs_db1_2_db2.py

# search for warnings or errors in the job logs
# Runs at 0430 hours
30 04 * * * /home/nearonline/scripts/lookForWarnings.sh
# Copy to job log warnings to website
# Runs at 0432 hours
32 04 * * * /home/nearonline/scripts/copy_warning_log_files_to_web.sh

# Veto wall monitoring
# Runs every 10 minutes starting at 4 minutes after the hour
4-59/10 * * * * cd /scratch/nearonline/mirror/cmtuser/Minerva_v10r7p3/Tools/VetoWallTools/launchers && ./VetoDailyPlots.sh
4-59/10 * * * * cd /scratch/nearonline/mirror/cmtuser/Minerva_v10r7p3/Tools/VetoWallTools/launchers && ./VetoDailyLIPlots.sh

# Pedestal Checker
MAILTO="mcgowan@pas.rochester.edu hbudd@fnal.gov nur@fnal.gov"
*/5 * * * * /home/nearonline/cmtuser/current/Cal/CalibrationTools/scripts/pedestal_calibration/nearlinePedQC.sh

# run the cleanup job on /scratch/nearonline/var, /data/nearonline
# Runs at 0100 hours
00 01 * * * /home/nearonline/scripts/nearline_cleanup.sh -v -x -f /scratch/nearonline/var -n 'NearlineCurrent*' -n '*table*.dat*' -e nur@fnal.gov
# Runs at 0200 hours
00 02 * * * /home/nearonline/scripts/nearline_cleanup.sh -v -x -f /data/nearonline -e nur@fnal.gov


CRONTEXTLOGGER6



# otherwise
# =========
	else
		echo "I don't recognize your hostname ('$host') -- I don't think I'm supposed to be running here. Not doing anything..." > 2
		exit 0
	fi

}

# ========================================
#   entry point
# ========================================

echo "Setting up crontab for host: `hostname`..."
echo ""

# get the cron output
output=`setup_cron`

# if setup_cron() exited with an error, don't continue...
if [ $? -gt 0 ]; then
	echo "Crontab setup function exited with an error (code: $?).  You might be able to figure out what went wrong from its output:"
	echo $output
	echo ""
	echo "New crontab was not installed."
	crontab -l
	exit
fi

# get a safe temporary file
cronfile=`mktemp -t crontab.XXXXXXXXXX`

# write the cron output to it
echo "$output" > "$cronfile"

# overwrite the current cron using this file
if crontab "$cronfile"; then
	echo "New crontab successfully installed."
else
	echo ""
	echo "'crontab' exited with an error.  No crontab was installed."
fi

# delete the temp file to be safe
rm -f "$cronfile"

