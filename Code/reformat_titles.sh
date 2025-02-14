#!/bin/bash


cut -d"," -f1,2,4 $1 | tr '[:upper:]' '[:lower:]' > "temp.txt"


-----------

#!/bin/bash

new="most_popular.csv"
interm="todel.csv"

  cut -d"," -f8-15 $1 > $interm

  # prefix each line with its sum
for line in read $interm; do

  #get the values (cut) in variables 8-15:
  let "sum=0"
  for item in $line; do
    let "sum++"
  done

  echo "${sum},line" >> $new
done

  #rm $interm
  sort $new | head -n 10 | cut -d "," -f2- > $new
  cat $new




  #!/bin/bash

file=clean-$1
cp $1 $file

while grep -q '\("[^"][^"]*\),\(.*"\)' $file ;do
  sed -i 's/\("[^"][^"]*\),\(.*"\)/\1;\2/g' $file
done


#!/bin/bash

# Give the path of the file as first argument to the script:
input="$1"
let "id=1"

#Here we are using a space as a separator - see how there is a space:
while IFS="\n" read -r line
do
  #Below is an example of how you might grab the class info from each line.
  #NB - this is a backtick, not a single quote.
  #Backticks evaluate the content between them and pass on that output.

  class=`echo $line | tr -s " " | cut -d" " -f1`
  age=`echo $line | tr -s " " | cut -d" " -f2`
  sex=`echo $line | tr -s " " | cut -d" " -f3`
  survived=`echo $line | tr -s " " | cut -d" " -f4`

  mysql -D "Titanic" -e "insert into titanic (id,class,age,sex,survived) values($id,$class,$sex,$age,$survived);"
  let "id=id+1"

done <"$input"
