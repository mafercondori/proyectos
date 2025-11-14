import csv  # Importamos la librería para trabajar con archivos CSV

# Función para obtener pedidos desde el archivo CSV
def obtener_pedidos(nombre_archivo):
    with open(nombre_archivo, newline='', encoding='utf-8') as archivo:
        lector = csv.DictReader(archivo)  # Lee el CSV como una lista de diccionarios
        pedidos = [fila for fila in lector]  # Guarda los pedidos en una lista
    print("📦 Pedidos cargados correctamente")
    return pedidos  # Retorna la lista de pedidos

# Función para listar algunos pedidos
def listar_pedidos(pedidos):
    print("📋 Lista de pedidos:")
    for pedido in pedidos[:5]:  # Muestra solo los primeros 5 pedidos
        print(pedido)

# Función para filtrar pedidos por estado
def filtrar_pedidos(pedidos, estado):
    filtrados = [p for p in pedidos if p["Status"] == estado]  # Filtra por estado
    print(f"🔎 Pedidos con estado '{estado}': {len(filtrados)} encontrados")
    return filtrados  # Retorna la lista de pedidos filtrados
