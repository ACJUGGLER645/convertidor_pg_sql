import re
import os


INPUT_FILE = 'nomina_dump.sql' 
OUTPUT_FILE = 'nomina_mysql_ready.sql' 

def convertir_postgres_a_mysql_robusto(archivo_entrada, archivo_salida):
    """
    Convierte el dump estándar de pg_dump a sintaxis MySQL,
    manejando COPY, ALTER TABLE y limpieza de comandos.
    """
    if not os.path.exists(archivo_entrada):
        print(f"❌ Error: El archivo de entrada '{archivo_entrada}' no fue encontrado.")
        return

    print(f"Iniciando conversión de '{archivo_entrada}'...")
    
    try:
        with open(archivo_entrada, 'r', encoding='utf8') as infile:
            contenido = infile.read()

        # --- FASE 1: Limpieza y Conversión de Sintaxis Básica ---
        
        # Eliminar comandos de configuración y comentarios específicos de PostgreSQL
        contenido = re.sub(r'^\s*--.*', '', contenido, flags=re.MULTILINE)
        contenido = re.sub(r'^\s*SET .*', '', contenido, flags=re.MULTILINE)
        contenido = re.sub(r'^\s*SELECT pg_catalog\.set_config.*', '', contenido, flags=re.MULTILINE)
        contenido = re.sub(r'^\s*ALTER TABLE public\..* OWNER TO postgres;', '', contenido, flags=re.MULTILINE)
        contenido = re.sub(r'^\s*\\restrict.*|^\s*\\unrestrict.*', '', contenido, flags=re.MULTILINE)
        
        # Ajuste de tipos de datos y sintaxis
        contenido = re.sub(r'character varying', r'VARCHAR', contenido, flags=re.IGNORECASE)
        contenido = re.sub(r'\bdouble precision\b', r'DOUBLE', contenido, flags=re.IGNORECASE)
        contenido = re.sub(r'\s+NOT VALID;', r';', contenido, flags=re.IGNORECASE) # Elimina sintaxis FK incompatible

        # --- FASE 2: Conversión de COPY a INSERT INTO (CRÍTICO) ---
        
        # Patrón que identifica el bloque COPY, capturando tabla, columnas y datos
        copy_pattern = re.compile(
            r'COPY\s+public\.(\w+)\s+\((.*?)\)\s+FROM\s+stdin;\n(.*?)\n\\\.', 
            re.DOTALL | re.IGNORECASE
        )
        
        def convertir_copy_a_insert(match):
            tabla = match.group(1).strip()
            columnas = match.group(2).strip()
            datos_brutos = match.group(3).strip()
            
            if not datos_brutos:
                return '' 
            
            lineas_insert = []
            for linea_datos in datos_brutos.splitlines():
                if not linea_datos.strip(): continue
                
                # 1. Reemplazar \n incrustados en los datos con un espacio (ej: 'Humberto\n José')
                linea_datos = linea_datos.replace('\\n', ' ')

                # 2. Dividir por tabulaciones (el separador de COPY)
                valores = []
                for val in linea_datos.split('\t'):
                    # Si el valor es literal 'NULL'
                    if val.lower() == 'null':
                        valores.append('NULL')
                    # Escapar comillas y encerrar en comillas simples (SOLUCIÓN AL SYNTAXERROR)
                    else:
                        # Reemplaza comillas simples internas por doble comilla simple para SQL (ej: O'Malley -> O''Malley)
                        # Luego, envuelve todo el valor entre comillas simples.
                        valores.append("'" + val.replace("'", "''") + "'")

                lineas_insert.append(f"({', '.join(valores)})")

            if lineas_insert:
                 # El comando INSERT INTO final
                 return f"\nINSERT INTO `{tabla}` ({columnas}) VALUES\n" + ',\n'.join(lineas_insert) + ";\n"
            else:
                 return ''

        contenido_sql = copy_pattern.sub(convertir_copy_a_insert, contenido)


        # --- FASE 3: Corrección de Estructura y Quoting ---
        
        # 1. Quitar el prefijo de esquema 'public.' y corregir comillas dobles a backticks
        contenido_sql = re.sub(r'public\.(\w+)', r'`\1`', contenido_sql, flags=re.IGNORECASE)
        contenido_sql = re.sub(r'"([a-zA-Z0-9_]+)"', r'`\1`', contenido_sql)
        
        # 2. Añadir ENGINE=InnoDB a las sentencias CREATE TABLE (al final de la definición)
        contenido_sql = re.sub(r'(CREATE TABLE `\w+`\s*\([^;]*?\));', r'\1 ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;', contenido_sql, flags=re.IGNORECASE)
        
        # 3. Corregir sintaxis de ALTER TABLE para Claves Primarias y Foráneas (quitar "ONLY")
        contenido_sql = re.sub(r'ALTER TABLE ONLY ', r'ALTER TABLE ', contenido_sql, flags=re.IGNORECASE)

        # 4. Limpiar espacios extra y eliminar líneas vacías
        lineas_limpias = [linea for linea in contenido_sql.splitlines() if linea.strip()]
        contenido_final = '\n'.join(lineas_limpias)

        # 5. Envolver con control de claves foráneas
        contenido_final = "SET FOREIGN_KEY_CHECKS = 0;\n" + contenido_final + "\nSET FOREIGN_KEY_CHECKS = 1;\n"

        with open(archivo_salida, 'w', encoding='utf8') as outfile:
            outfile.write(contenido_final)

        print(f"\n✅ Proceso completado. Archivo listo en: **{archivo_salida}**")

    except Exception as e:
        print(f"❌ Ocurrió un error: {e}")

if __name__ == '__main__':
    convertir_postgres_a_mysql_robusto(INPUT_FILE, OUTPUT_FILE)