import os

import shutil
from config.conf import AppSettings
from scr.utils.extractor import data_extractor
from pyspark.sql import SparkSession, Row, types as ps_types, functions as ps_func
from pyspark.sql.types import FloatType, IntegerType
import pdfplumber
import logging

Logger = logging.getLogger(__name__)

def process_prices():
    settings = AppSettings()
    spark = None 
    error = None
    try: 
        file_prices = data_extractor(settings.base_url.format('prices'), 'prices.xml')
        
        Logger.info('starting session in spark')
        spark = SparkSession.builder \
            .appName("process_prices") \
            .config("spark.jars.packages", "com.databricks:spark-xml_2.12:0.15.0") \
            .getOrCreate()
        
        Logger.info('reading xml of prices')
        df = spark.read.format("xml") \
            .option("rowTag", "place") \
            .option("encoding", "utf-8")\
            .load(file_prices)
            
        Logger.info('exploding the gas_price column')
        df = df.withColumn("gas_price", ps_func.explode("gas_price"))

        Logger.info('selecting and casting columns of prices table')
        df = df.select(
            ps_func.col("_place_id").cast(IntegerType()).alias("place_id"),
            ps_func.col("gas_price._VALUE").cast(FloatType()).alias("price"),
            ps_func.col("gas_price._type").alias("type_product")
        )
        df = df.withColumn("fuel_type", ps_func.when(df.type_product == 'diesel', 'diesel').otherwise('gasolina'))


        path_name = os.path.join(settings.project_path, 'data/trans', 'prices.parquet')
        os.makedirs(os.path.join(settings.project_path, 'data/trans'), exist_ok=True)
        if os.path.exists(path_name):
            shutil.rmtree(path_name)
        
        Logger.info('writing the final file of the prices table')
        df.write.parquet(path_name)
        
        return path_name
    
    except Exception as e:
        error = e
    finally:
        if spark is not None: 
            spark.stop()
        if error is not None:
            raise error


def process_places():
    settings = AppSettings()
    spark = None 
    error = None
    try: 
        file_places = data_extractor(settings.base_url.format('places'), 'places.xml')
        
        Logger.info('starting session in spark')
        spark = SparkSession.builder \
            .appName("process_places") \
            .config("spark.jars.packages", "com.databricks:spark-xml_2.12:0.15.0") \
            .getOrCreate()
            
        Logger.info('reading xml of places')
        df = spark.read.format("xml") \
            .option("rowTag", "place") \
            .option("encoding", "utf-8")\
            .load(file_places)

        Logger.info('selecting and casting columns of prices table')
        df = df.select(
            ps_func.col("_place_id").cast(IntegerType()).alias("place_id"),
            ps_func.col("cre_id"),
            ps_func.col("location.x").cast(FloatType()).alias("longitude"),
            ps_func.col("location.y").cast(FloatType()).alias("latitude"),
            ps_func.col("name").alias("place_name")
        )

        path_name = os.path.join(settings.project_path, 'data/trans', 'places.parquet')
        os.makedirs(os.path.join(settings.project_path, 'data/trans'), exist_ok=True)
        if os.path.exists(path_name):
            shutil.rmtree(path_name)
            
        Logger.info('writing the final file of the prices table')
        df.write.parquet(path_name)
        
        return path_name

    except Exception as e:
        error = e
    finally:
        if spark is not None: 
            spark.stop()
        if error is not None:
            raise error


def process_places_details():
    settings = AppSettings()
    spark = None 
    error = None
    try: 
        
        places_detail = data_extractor(settings.url_place_details, 'places_detail.pdf', verify=False)
        
        Logger.info('starting session in spark')
        spark = SparkSession.builder \
            .appName("process_places") \
            .getOrCreate()
            
        cols = ['turn', 'permission', 'place_name', 'place_code', 'date_entry', 
                'plenary_date', 'address', 'colony', 'cp', 'city', 'state']
        
        data = []
        pages = None
        Logger.info('reading the number pages of the PDF')
        with pdfplumber.open(places_detail) as pdf:
            pages = len(pdf.pages)
            Logger.info('the PDF contains {} pages'.format(pages))
            
        for i in range(pages):
            Logger.info('reading page {}'.format(i))
            with pdfplumber.open(places_detail) as pdf:
                data_temp = pdf.pages[i].extract_table()
                if data_temp:
                    data += [Row(**dict(zip(cols, x))) for x in data_temp]
        
        Logger.info('Generating a dataframe of the places details table')
        df = spark.createDataFrame(data)
        df = df.filter(df.colony != 'Colonia')
        
        Logger.info('selecting and casting columns of prices table')
        df = df.select(
                ps_func.col('turn'),
                ps_func.col('permission'),
                ps_func.col('place_name'),
                ps_func.col('place_code'),
                ps_func.col('date_entry'),
                ps_func.col('plenary_date'),
                ps_func.col('address'),
                ps_func.col('colony'),
                ps_func.col('cp').cast(ps_types.IntegerType()).alias('cp'),
                ps_func.col('city'),
                ps_func.col('state')
        )

        path_name = os.path.join(settings.project_path, 'data/trans', 'places_details.parquet')
        os.makedirs(os.path.join(settings.project_path, 'data/trans'), exist_ok=True)
        if os.path.exists(path_name):
            shutil.rmtree(path_name)
        
        Logger.info('writing the final file of the prices table')
        df.write.parquet(path_name)
        
        return path_name
    
    except Exception as e:
        error = e
    finally:
        if spark is not None: 
            spark.stop()
        if error is not None:
            raise error
