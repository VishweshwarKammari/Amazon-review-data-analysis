#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.


import logging

from airflow.hooks.postgres_hook import PostgresHook
from airflow.plugins_manager import AirflowPlugin
from airflow.models import BaseOperator
from airflow.utils.decorators import apply_defaults

log = logging.getLogger(__name__)

args = {
    'owner': 'airflow',
}

dag = DAG(
    dag_id='Amazon_review_data',
    default_args=args,
    schedule_interval='0 */8 * * *',
    dagrun_timeout=timedelta(minutes=60),
    tags=['example', 'example2'],
    params={"example_key": "example_value"},
)

run_this_last = DummyOperator(
    task_id='run_this_last',
    dag=dag,
)

class S3ToRedshiftOperator(BaseOperator):
'''
Executes a LOAD command on a s3 CSV file into a Redshift table
:param redshift_conn_id: reference to a specific redshift database
:type redshift_conn_id: string

:param table: reference to a specific table in redshift database
:type table: string

:param s3_bucket: reference to a specific S3 bucket
:type s3_bucket: string

:param s3_access_key_id: reference to a specific S3 key
:type s3_key: string

:param s3_secret_access_key: reference to a specific S3 key
:type s3_key: string

:param delimiter: delimiter for CSV data
:type s3_key: string

:param region: location of the s3 bucket (eg. 'eu-central-1' or 'us-east-1')
:type s3_key: string
'''


@apply_defaults
def __init__(self, redshift_conn_id,table,s3_bucket,s3_path,s3_access_key_id,
  s3_secret_access_key,delimiter,region,*args, **kwargs):

  self.redshift_conn_id = redshift_conn_id
  self.table = table
  self.s3_bucket = s3_bucket
  self.s3_path = s3_path
  self.s3_access_key_id = s3_access_key_id
  self.s3_secret_access_key = s3_secret_access_key
  self.delimiter = delimiter 
  self.region = region

  super(S3ToRedshiftOperator, self).__init__(*args, **kwargs)


def execute(self, context):
  self.hook = PostgresHook(postgres_conn_id=self.redshift_conn_id)
  conn = self.hook.get_conn() 
  cursor = conn.cursor()
  log.info("Connected with " + self.redshift_conn_id)

  load_statement = """
    delete from {0};
    copy
    {0}
    from 's3://{1}/{2}'
    access_key_id '{3}' secret_access_key '{4}'
    delimiter '{5}' region '{6}' """.format(
  self.table, self.s3_bucket, self.s3_path,
  self.s3_access_key_id, self.s3_secret_access_key,
  self.delimiter, self.region)

  cursor.execute(load_statement)
  cursor.close()
  conn.commit()
  log.info("Load command completed")

  return True


class S3ToRedshiftOperatorPlugin(AirflowPlugin):
  name = "redshift_load_plugin"
  operators = [S3ToRedshiftOperator]