#!/bin/bash
################################################################################
#    This script will help you uninstall Canon CAPT Printer Driver from a      #
#    based Linux distribution.                                                 #
#                                                                              #
#    @author Radu Cotescu                                                      #
#    @version 2.4                                                              #
#                                                                              #
# For more details please visit:                                               #
#   http://radu.cotescu.com/?p=1194                                            #
################################################################################

param="$1"
param_no="$#"

display_usage() {
	echo "Usage, simple run: ./`basename $0`"
}

check_superuser() {
	if [[ "$UID" != "0" ]]; then
		echo "This script must be run with superuser privileges!"
		display_usage
		exit 1
	fi
}

check_args() {
	if [[ $param_no -gt 1 ]]; then
		display_usage
		exit 1
	fi
	if [[ "$param" == "-h" || "$param" == "--help" ]]; then
			display_usage
			exit 0
	fi
	if [[ -n $param ]]; then
		echo "Error: Unkown parameter!"
		display_usage
		exit 1
	fi
}

uninstall() {
	if [[ -e "/usr/sbin/ccpdadmin" ]]; then
		installed_model=`ccpdadmin | grep LBP | awk '{print $3}'`
		if [[ -n $installed_model ]]; then
			echo "Found printer model $installed_model..."
			echo "Stopping ccpd daemon..."
			/etc/init.d/ccpd stop
			echo "Removing printer from ccpdadmin..."
			ccpdadmin -x $installed_model
			echo "Removing printer from lpadmin..."
			lpadmin -x $installed_model
			echo "Disable driver..."
			services ccpd off
			echo "Stop service..."
			services ccpd stop
			echo "Removing driver..."
			removing canon-capt-drv
			removing canon-capt-drv-common
			echo "Done!"
		fi
	else
		echo "Canon CAPT printer driver not found."
	fi
}

exit_message() {
	echo -e "\n\tCanon Printer Driver uninstaller"
	echo -e "\tCharles K. Barcza for blackPanther OS and original script author Radu Cotescu"
	echo -e "\thttp://www.blackpanther.hu - http://radu.cotescu.com\n"
}

check_args
check_superuser
uninstall
exit_message
exit 0

