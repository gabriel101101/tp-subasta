1 - INICIO DE SUBASTA
La subasta se inicia con un valor minimo por defecto 
y un tiempo estimado que se creo con el deploy.

2 - FUNCION CREAR PRODUCTO A SUBASTAR
Tiene una funcion para crear el producto a subastar y 
luego de crear el producto que se subasta se emite un 
evento de comienzo de subasta.

3 - FUNCION OFERTANTE
Tambien posee la funcion del ofertante, donde se envia el monto
de oferta, direccion del ofertante y nombre, que posteriormente 
es guardado en un array.

4 - FUNCION ENTREGAR REMBOLSO
Realiza el rembolso del valor apostado en casso de no haber
comprado el producto subastado.

5 - FUNCION AGREGAR TIEMPO
Incrementaa el ttiempo de la subasta en 600 seg = 10 min.

6 - FUNCION OFRTA WINER
Emite un evento que da el ganador de la subasta y cuanto pago, 
reinicia el contador de oferta en 0.

7 - FUNCION LISTAR OFERTANTE
Muestra lista de ofertantes del producto subastado. 
Esta lista fue creada en un array.

8 - FUNCION DEVOLUCION
Realiza la devolucion a los ofertantes que estubieron en la
subasta y no compraron el producto, pero se les descuenta una 
comision del 2%.