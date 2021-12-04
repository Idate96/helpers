# script that runs init_clion.py while parsing the arguments 
# user input: init_clion.sh -w <workspace> -p <package>

# check if dir ~/ClionProjects exists else create it 
if [ ! -d ~/ClionProjects ]; then
    mkdir ~/ClionProjects
fi

# parse arguments
while getopts ":w:p:" opt; do
  case $opt in
    w)
      workspace=$OPTARG
      ;;
    p)
      package=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# run init_clion.py with the arguments
python3 ~/git/helpers/src/init_clion.py -w $workspace -n $package -c ~/ClionProjects $package
