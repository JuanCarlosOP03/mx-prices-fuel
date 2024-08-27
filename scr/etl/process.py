import os

import shutil
from config.conf import AppSettings
from scr.utils.extractor import data_extractor
from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from pyspark.sql.functions import explode, col, when
from pyspark.sql.types import FloatType, IntegerType


def process_prices():
    settings = AppSettings()
    file_prices = data_extractor(settings.base_url.format('prices'), 'prices.xml')
    
    spark = SparkSession.builder \
        .appName("process_prices") \
        .config("spark.jars.packages", "com.databricks:spark-xml_2.12:0.15.0") \
        .getOrCreate()
    
    df = spark.read.format("xml") \
        .option("rowTag", "place") \
        .option("encoding", "utf-8")\
        .load(file_prices)
        
    df = df.withColumn("gas_price", explode("gas_price"))

    df = df.select(
        col("_place_id").cast(IntegerType()).alias("place_id"),
        col("gas_price._VALUE").cast(FloatType()).alias("price"),
        col("gas_price._type").alias("type_product")
    )
    df = df.withColumn("fuel_type", when(df.type_product == 'diesel', 'diesel').otherwise('gasolina'))

    path_name = os.path.join(settings.project_path, 'data/trans', 'prices.parquet')
    os.makedirs(os.path.join(settings.project_path, 'data/trans'), exist_ok=True)
    if os.path.exists(path_name):
        shutil.rmtree(path_name)
    df.write.parquet(path_name)
    
    spark.stop()
    
    return path_name


def process_places():
    settings = AppSettings()
    file_places = data_extractor(settings.base_url.format('places'), 'places.xml')
    
    spark = SparkSession.builder \
        .appName("process_places") \
        .config("spark.jars.packages", "com.databricks:spark-xml_2.12:0.15.0") \
        .getOrCreate()
        
    df = spark.read.format("xml") \
        .option("rowTag", "place") \
        .option("encoding", "utf-8")\
        .load(file_places)

    df = df.select(
        col("_place_id").cast(IntegerType()).alias("place_id"),
        col("cre_id"),
        col("location.x").cast(FloatType()).alias("longitude"),
        col("location.y").cast(FloatType()).alias("latitude"),
        col("name").alias("place_name")
    )

    path_name = os.path.join(settings.project_path, 'data/trans', 'places.parquet')
    os.makedirs(os.path.join(settings.project_path, 'data/trans'), exist_ok=True)
    if os.path.exists(path_name):
        shutil.rmtree(path_name)
    df.write.parquet(path_name)
    
    spark.stop()
    
    return path_name
