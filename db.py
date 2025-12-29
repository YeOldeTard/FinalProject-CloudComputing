import pymysql

def getdb():
    return pymysql.connect(
        host="localhost",
        user="root",
        password="",
        database="easyfood_db",
        cursorclass=pymysql.cursors.DictCursor
    )
