import streamlit as st
import csv
import datetime
import statistics
import pandas as pd
import matplotlib.pyplot as plt

# Definir el nombre del archivo
archivo_csv = "Amazon_Sale_Report.csv"

# Obtener la fecha actual
fecha_actual = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# Leer el archivo y procesar datos
ventas_totales = 0
total_pedidos = 0
productos_mas_vendidos = {}
montos_ventas = []
ventas_ciudad = {}

data = []
with open(archivo_csv, mode="r", encoding="utf-8") as file:
    reader = csv.DictReader(file)
    for row in reader:
        total_pedidos += 1
        monto = float(row["Amount"]) if row["Amount"] else 0
        ventas_totales += monto
        montos_ventas.append(monto)
        
        producto = row["SKU"]
        productos_mas_vendidos[producto] = productos_mas_vendidos.get(producto, 0) + int(row["Qty"]) if row["Qty"] else 0
        
        ciudad = row["City"]
        ventas_ciudad[ciudad] = ventas_ciudad.get(ciudad, 0) + monto
        
        data.append(row)

df = pd.DataFrame(data)
venta_promedio = round(statistics.mean(montos_ventas), 2) if montos_ventas else 0
venta_maxima = max(montos_ventas) if montos_ventas else 0
venta_minima = min(montos_ventas) if montos_ventas else 0

# Producto más vendido
producto_top = max(productos_mas_vendidos, key=productos_mas_vendidos.get) if productos_mas_vendidos else "N/A"
producto_top_qty = productos_mas_vendidos.get(producto_top, 0)

# Ciudades con más ventas
df_ciudades = pd.DataFrame(list(ventas_ciudad.items()), columns=["Ciudad", "Ventas"])
df_ciudades = df_ciudades.sort_values(by="Ventas", ascending=False).head(10)

# Interfaz en Streamlit
st.title("📊 Reporte de Ventas - Análisis Interactivo")
st.write(f"📅 **Fecha del reporte:** {fecha_actual}")

col1, col2, col3 = st.columns(3)
col1.metric("📦 Total de Pedidos", total_pedidos)
col2.metric("💰 Ventas Totales", f"${ventas_totales:,.2f}")
col3.metric("📈 Venta Promedio", f"${venta_promedio:,.2f}")

col4, col5 = st.columns(2)
col4.metric("🔝 Venta Máxima", f"${venta_maxima:,.2f}")
col5.metric("📉 Venta Mínima", f"${venta_minima:,.2f}")

st.write(f"🏆 **Producto más vendido:** {producto_top} con {producto_top_qty} unidades")

# Gráfico de ciudades con más ventas
st.subheader("🌍 Top 10 Ciudades con Más Ventas")
fig, ax = plt.subplots(figsize=(10, 5))
ax.bar(df_ciudades["Ciudad"], df_ciudades["Ventas"], color="skyblue")
ax.set_xlabel("Ciudad")
ax.set_ylabel("Ventas Totales ($)")
ax.set_title("Top 10 Ciudades con Más Ventas")
ax.set_xticklabels(df_ciudades["Ciudad"], rotation=45)
st.pyplot(fig)



