PROJECTNAME="PROJECTNAME"
PROJECTTESTNAME=""
TESTDBNAME=""
HASMAINSQL="false"
HASTESTSQL="false"

# CODE


get_project_name() {
  testExt=".Tests"
  found="false"
  pwd
  for testFolder in *; do
    if [ ${testFolder} == *.Tests ]; then
      PROJECTNAME="${testFolder/$testExt}"
    fi
  done
  for folder in *; do
    if [ ${folder} == ${PROJECTNAME} ]; then
      found="true"
    fi
  done
}

# db setup

# gets custom name of student's database, prints to output if student did not put sql file in top level of directory
get_db_name(){
  dbExt=".sql"
  testExt="_test"
  found="false"
  files=$(ls ./*.sql);
  forwardSlash="./"
  if (( ${#files} )); then
    found="true"
    testFile=$(ls ./*_test.sql);
    if (( ${#testFile} )); then
      HASMAINSQL="true"
      HASTESTSQL="true"
      tempFile=${#testFile/$forwardSlash}
      TESTDBNAME=${#tempFile/$dbExt}
      DBNAME=${TESTDBNAME/$testExt}
    fi
  fi
}


# specific to MySQL
main_db_setup() {
  /Applications/MAMP/Library/bin/mysql --host=localhost -uroot -proot -e "CREATE DATABASE IF NOT EXISTS ${DBNAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
  USE '${DBNAME}';"
  /Applications/MAMP/Library/bin/mysql --host=localhost -uroot -proot ${DBNAME} < ${DBNAME}.sql
}

# specific to MySQL
test_db_setup() {
  /Applications/MAMP/Library/bin/mysql --host=localhost -uroot -proot -e "CREATE DATABASE IF NOT EXISTS ${TESTDBNAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
  USE '${TESTDBNAME}';"
  /Applications/MAMP/Library/bin/mysql --host=localhost -uroot -proot ${TESTDBNAME} < ${TESTDBNAME}.sql
}

# uses MySQL specific syntax
drop_main_db() {
  /Applications/MAMP/Library/bin/mysql --host=localhost -uroot -proot -e "DROP DATABASE ${DBNAME};"
}
drop_test_db() {
  /Applications/MAMP/Library/bin/mysql --host=localhost -uroot -proot -e "DROP DATABASE ${TESTDBNAME};"
}

get_db_name()
drop_main_db()
drop_test_db()
main_db_setup()
test_db_setup()
