/* Tenéis desde las 18.30 hasta las 21.30 de hoy (30/10/24), para responder a la siguiente pregunta sobre la empresa ficticia que se representa en la base de datos Employees.

¿Es la empresa sexista? 🤔

Debes adjuntar tu respuesta en fichero .sql , dentro del cual deben estar todas las consultas que justifican tu respuesta además de los comentarios necesarios.

Recuerda que para comentar en SQL puedes:
hacer comentarios de 1 linea empezando la linea por dos guiones medios (--) 
comentarios de varias líneas puedes envolverlo dentro de /* aqui puedes poner comentarios de la longitud que necesites en varias líneas*/
/* Dentro de los datos de la empresa podemos fundamentar nuestra respuesta en base a varios criterios y factores, pensad en la info de la que disponemos en todas las tablas y empezad a haceros preguntas.

Ánimo con ello!*/

-- 1) Empecemos por el principio. No la gallina y el huevo, si no, cantidad de Generos.
SELECT distinct(gender) FROM employees;
-- Vale, si ser transfoba y binaria o como se diga es sexista, por ahora la empresa se lo gana al tener solo dos Generos M y F

-- 2) Ahora veamos el numero y porcentaje de empleados de cada genero que actualmente trabajan. Ya que queremos saber si la empresa es sexista ahora, no historicamente, que habria que hacerlo por YTY o MTM o lo que 
-- sea y es un dolor de cabeza.
SELECT 
    gender genero
    , COUNT(*) num_empleados
    , CONCAT(ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2), "%") porcentaje
FROM 
    employees
INNER JOIN
	salaries using(emp_no)
WHERE 
	to_date = "9999-1-1"
GROUP BY 
    gender;
    
-- De entrada vemos que tenemos un 60.02% de hombres y un 39.98% de mujeres. Luego el sesgo se decanta a favor de mas empleados masculinos que femeninos.

-- 3) Pasemos a comprobar la media de salarios entre generos binarios que tenemos

SELECT 
    gender genero
    , ROUND(AVG(salary), 2) salario_promedio
    ,  CONCAT(ROUND(100.0 * AVG(salary) / SUM(AVG(salary)) OVER (), 2), "%") porcentaje
FROM 
    employees
INNER JOIN 
	salaries using(emp_no)
WHERE 
    to_date = '9999-01-01'
GROUP BY 
    gender;

-- Vale, el salario promedio entre generos esta bastante equilibrado. 
-- Siendo la el sueldo medio de los varones 72044.66, un 50.03% del total. Y el sueldo medio de las mujeres 71963.57, un 49.97% del total.
    
-- INTERMEDIO -- Y si ya que estoy y vamos estar todo el rato dale que te pego juntando lo mismo(employees, salaries, dept_emp, etc) sacamos una vista a lo bruto de los sospechosos habituales(genero y amigos)?
-- Vale, me ha costado, pero creo que esta esta bastante bien para saber que empleados tenemos trabajando ahora, con su numero, GENNERRO, dia de contratac...
CREATE VIEW empleados_actuales AS
SELECT 
    e.emp_no
    , e.gender
    , e.hire_date
    , s.salary salario_actual
    , d.dept_no departamento
    , d.dept_name nombre_departamento
    , t.title titulo
FROM 
    employees e
INNER JOIN 
	salaries s ON e.emp_no = s.emp_no AND s.to_date = '9999-01-01'
INNER JOIN 
	dept_emp de ON e.emp_no = de.emp_no AND de.to_date = '9999-01-01'
INNER JOIN 
	departments d ON de.dept_no = d.dept_no
INNER JOIN 
	titles t ON e.emp_no = t.emp_no AND t.to_date = '9999-01-01';
    
SELECT * FROM empleados_actuales;

-- 4) ¿Y por departamento? ¿Como se reparten nuestros dos queridos y clasicos generos?

SELECT 
    nombre_departamento departamento
    , gender genero
    , COUNT(*) num_empleados
    , CONCAT(ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY nombre_departamento), 2), "%") porcentaje
FROM 
    empleados_actuales
GROUP BY 
    nombre_departamento, genero
ORDER BY 
	nombre_departamento, genero DESC;

/* Pues aqui tenemos una cosa curiosa pero que cumple nuestra consulta numero 2. Mas o menos todos los departamentos 
tienen la misma distribucion de generos que la distribucion total de empleados por genero, acercandose todos al 40 - 60 
(¿Reparticion tipica aleatoria pero equilibrada de Base de datos de practicas detectada o algo mas siniestro? Quiza el Jefe o RH sea un gran fan del equilibrio 40/60)*/

-- 5)¿¿Y si juntamos las dos anteriores, y hacemos el salario por genero y departamento?? amos a ver que nos da

-- Salario promedio por género en cada departamento y su porcentaje respecto al salario total del departamento
SELECT 
    nombre_departamento departamento
    , gender genero
    , ROUND(AVG(salario_actual), 2) salario_medio
    , CONCAT(ROUND(100.0 * AVG(salario_actual) / SUM(AVG(salario_actual)) OVER (PARTITION BY nombre_departamento), 2), "%") porcentaje
FROM 
    empleados_actuales
GROUP BY 
    nombre_departamento, genero
ORDER BY 
	nombre_departamento, genero DESC;

/* Esto ya roza lo sospechosamente equilibrado infinito, aunque es verdad que estamos mirando solo las medias, 
pero basicamente es siempre un 50/50 o una diferencia nimia que no baja del 49.81/50.19. */

/* 6) Vale, dejemonos de tonterias de dineros y de generos, vamos a lo importante para saber si es una empresa sexista o no: 
el techo de cristal(Suena a museo o crucero, pero es cosa seria, no reirse leñe ¬¬) 

Empecemos por la proporcion de generos en cada titulo de trabajo con su porcentaje*/ 

SELECT 
    titulo titulo
    , gender genero
    , COUNT(*) num_empleados
    , CONCAT(ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY titulo), 2), "%") porcentaje
FROM 
    empleados_actuales
GROUP BY 
    titulo, genero
ORDER BY 
	titulo, genero DESC;

/* Vale, en linea con todo lo anterior...todos los titulos siguen teniendo una proporcion casi 40/60 que se ajusta a
nuestro 40% mujeres/60% hombres. Excepto curiosamente los Manager, que sube a 44.44/55.56 con 4 mujeres y 5 hombres. Gracias 
a este desbarajuste, probablemente provocado por la poca cantidad de managers, tenemos una proporcion casi del 50/50 */

/* 7) Hmm, ¿y en los ascensos? ¿Como es la proporcion de nuestros generos que han tenido al menos un ascenso? */

/* Aviso a navectores...no tengo ni idea de si esto hace lo que quiero bien, pero a mis ojos lo hace. Basicamente 
compruebo si ha tenido alguna vez un ascenso, con salario positivo. Y si lo ha tenido, se añade al numero de promocionados.
 Luego le hago un porcentaje, del total de su genero, para ver cual porcentaje de promocionados tenemos en el mismo. */

WITH cambios_salario AS (
    SELECT 
        emp_no
        , CASE 
            WHEN salary > LAG(salary) OVER (PARTITION BY emp_no ORDER BY from_date) 
            THEN 1 
            ELSE 0 
        END cambio_salario_positivo
    FROM 
        salaries
),
cambios_titulo_por_emp AS (
    SELECT 
        e.emp_no
        , e.gender genero
        , COUNT(DISTINCT t.title) cambios_titulo
        , SUM(cs.cambio_salario_positivo) cambios_salario_positivos
    FROM 
        employees e
    LEFT JOIN titles t ON e.emp_no = t.emp_no
    LEFT JOIN cambios_salario cs ON e.emp_no = cs.emp_no
    GROUP BY 
        e.emp_no, e.gender
),
promociones_genero AS (
    SELECT 
        genero
        , COUNT(emp_no) num_empleados
        , SUM(CASE WHEN cambios_titulo > 1 OR cambios_salario_positivos > 0 THEN 1 ELSE 0 END) num_promocionados
    FROM 
        cambios_titulo_por_emp
    GROUP BY 
        genero
)
SELECT 
    genero
    , num_empleados
    , num_promocionados
    , CONCAT(ROUND(100.0 * num_promocionados / num_empleados, 2), "%") porcentaje_promocion
FROM 
    promociones_genero;


/* Hmm, por lo que veo si mis calculos son buenos, se promociona practicamente igualmente proporcionalmente
a todo tipo de humanos(hombres, mujeres y viceversa). Dentro de los hombres tenemos un 96.60% de ascendidos/promocionados
y en las mujeres un 96.74% */ 

/* 8) Pues seguimos, ahora con la media de cambios de salario para cada genero y su porcentaje sobre el total de 
cambios, yo ya no se que inventar y comprobar...En este caso me da igual que el cambio sea positivo o no*/

WITH salario_cambios AS (
    SELECT 
        e.emp_no
        , e.gender
        , CASE 
            WHEN s.salary != LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY s.from_date) 
            THEN 1 
            ELSE 0 
        END cambio_salario
    FROM 
        employees e
    JOIN salaries s ON e.emp_no = s.emp_no
),
total_cambios_por_emp AS (
    SELECT 
        emp_no
        , gender
        , SUM(cambio_salario) num_cambios_salario
    FROM 
        salario_cambios
    GROUP BY 
        emp_no, gender
)
SELECT 
    gender genero
    , ROUND(AVG(num_cambios_salario), 2) media_cambios_salario
    , CONCAT(ROUND(100.0 * AVG(num_cambios_salario) / SUM(AVG(num_cambios_salario)) OVER (), 2), "%") porcentaje
FROM 
    total_cambios_por_emp
GROUP BY 
    gender;

/* De verdad...estos porcentajes me dicen soy una tabla de practicas aleatorizada casi al 50/50. Basicamente cada 
genero ha tenido una media de 8 cambios de salario/promociones/ascensos/descensos, ambos igual...*/

/* 9) Otra experimental, ¿y si saco rankings? Ranking de salarios para cada gnero en titulos similares */
WITH ranking_m AS (
    SELECT 
        titulo
        , gender genero_m
        , salario_actual salario_actual_m
        , RANK() OVER (PARTITION BY titulo ORDER BY salario_actual DESC) ranking
    FROM 
        empleados_actuales
    WHERE 
        gender = 'M'
),
ranking_f AS (
    SELECT 
        titulo
        , gender genero_f
        , salario_actual salario_actual_f
        , RANK() OVER (PARTITION BY titulo ORDER BY salario_actual DESC) ranking
    FROM 
        empleados_actuales
    WHERE 
        gender = 'F'
)
-- Segun stack overflow hay que usar un left join y un right join para simular un full outer join que me daba error...y yo ya me he perdido
-- no se si esto lo esta haciendo bien o no, basicamente queria hacer un ranking con los tios y las tias unos al lado de otros
-- y ver como iban...pero yo lo he complicado mucho y me he perdido. A ver, hace algo, y creo que lo hace bien, pero ya me diras tu Vic vic
SELECT 
    rm.titulo
    , rm.genero_m
    , COALESCE(rm.salario_actual_m, '-') salario_actual_m
    , rm.ranking ranking_m
    , rf.genero_f
    , COALESCE(rf.salario_actual_f, '-') salario_actual_f
    , rf.ranking ranking_f
FROM 
    ranking_m rm
LEFT JOIN ranking_f rf ON rm.titulo = rf.titulo AND rm.ranking = rf.ranking

UNION ALL

SELECT 
    rf.titulo
    , rm.genero_m
    , COALESCE(rm.salario_actual_m, '-') salario_actual_m
    , rm.ranking AS ranking_m
    , rf.genero_f
    , COALESCE(rf.salario_actual_f, '-') salario_actual_f
    , rf.ranking ranking_f
FROM 
    ranking_f rf
LEFT JOIN ranking_m rm ON rf.titulo = rm.titulo AND rf.ranking = rm.ranking
ORDER BY 
    titulo, ranking_m, ranking_f;

-- Creo que esta seria una version mas simple de lo que quiero hacer
-- pos no me da tiempo, otro dia

/* 10 ¿Y si miramos en modo historico? Por ejemplo, numero de promociones (cambios positivos de salario) por genero y año, a ver que nos da */

WITH cambios_salario_anual AS (
    SELECT 
        salaries.emp_no
        , gender genero
        , YEAR(from_date) año
        , CASE 
            WHEN salary > LAG(salary) OVER (PARTITION BY emp_no ORDER BY from_date) THEN 1 
            ELSE 0 
        END promocion
    FROM 
        salaries
	INNER JOIN 
		employees ON employees.emp_no = salaries.emp_no
)
SELECT 
    año
    , genero
    , SUM(promocion) num_promociones
    , CONCAT(ROUND(100.0 * SUM(promocion) / SUM(SUM(promocion)) OVER (PARTITION BY año), 2), "%") porcentaje
FROM 
    cambios_salario_anual
WHERE 
    promocion = 1
GROUP BY 
    año, genero;

/* Vale esto ya es la conga de Jalisco...yo lo veo todo igual, da igual la cantidad de angulos por donde lo mire 
Siempre utiliza un porcentaje de 60 en tios y 40 en tias, porque tira de la regla de que el numero de hombres y mujeres
en la empresa tiene basicamente esa proporcion. Me hubiera gustado ponerte mi conclusion de una forma mas elaborada y añadir
aun mas comparaciones que se me ocurrieran, con historicos y acumulaciones de promociones etc...
Pero lo que yo estoy viendo en esta base de datos, es que la unica real diferencia es de un 60% hombres a 40% de mujeres en 
cantidad de empleados, pero en el resto, se mantienen fijamente equilibrados.alter

Tambien si tuviera mas tiempo me lo llevaria a python para hacerle histogramas y similares para ver la distribucion mas graficamente
*/

/* 11) por ultimo ejemplo, voy a comprobar el tiempo que se tarda en ascender por genero */

WITH cambios_salario AS (
    SELECT 
        e.emp_no
        , e.gender
        , s.from_date
        , s.salary
        , CASE 
            WHEN s.salary > LAG(s.salary) OVER (PARTITION BY e.emp_no ORDER BY s.from_date) 
            THEN 1 
            ELSE 0 
        END es_promocion
    FROM 
        employees e
    JOIN salaries s ON e.emp_no = s.emp_no
),
primera_promocion AS (
    SELECT 
        emp_no
        , gender
        , MIN(from_date) AS fecha_primera_promocion
    FROM 
        cambios_salario
    WHERE 
        es_promocion = 1
    GROUP BY 
        emp_no, gender
)
SELECT 
    e.gender genero
    , ROUND(AVG(DATEDIFF(fecha_primera_promocion, e.hire_date)) / 365, 2) tiempo_promedio_anos_primera_promocion
FROM 
    employees e
JOIN primera_promocion pp ON e.emp_no = pp.emp_no
GROUP BY 
    e.gender;

/* PFff...completamente igualados, 3.57/3.57 segun mi criterio, si que haya un 10% mas de homrbes que mujeres significa que hay sexismo, si lo hay
si no, por el resto de metricas, todo me parece completamente equilibrado */
