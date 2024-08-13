use riesgo_desastre;

select * from historico;

SET SQL_SAFE_UPDATES = 0;
UPDATE historico
SET Fecha = STR_TO_DATE(Fecha, '%d/%m/%Y');

select * from desastre;
select * from tipo_desastre;
select * from impacto_material;
select * from `impacto humano`;
select * from zona;
select * from zonariesgo;

###################################### PREGUNTAS ###################################################3
# ¿Cuántos desastres se han registrado en total en la base de datos? 
select 
	COUNT(id_Historico_Desastre) as Número_desastres,
    MIN(year(Fecha)) as Año_inicio,
    MAX(year(Fecha)) as Año_final
from historico;
select
    Fecha as Año_final
from historico;
select 
	count(IDimpacto_humano) as Cantidad_Impacto_Humano
from `impacto humano`;

select 
	count(IDimpacto_material) as Cantidad_Impacto_Material
from impacto_material;

# ¿Cuántos desastres por tipo se han registrado? 
select
	Event as Desastre,
	count(idDesastre) as Cantidad_desastres
from historico
group by Event;

# ¿Cuántos desastres históricos han ocurrido en cada municipio? 
select
	Municipio,
	count(idDesastre) as Cantidad_desastres
from historico
group by Municipio;

# ¿Cuántos municipios tienen un nivel alto de vulnerabilidad por desatre? 
select
	Desastre,
	count(Municipio) FROM zonariesgo 
WHERE `Nivel de Vulnerabilidad` = 'ALTO'
group by Desastre;


# ¿Cuántos municipios requieren acción inmediata en al menos 1 desastre? 
select
	`Necesidad de Acción`,
    count(distinct(Municipio))*100/(SELECT count(distinct(Municipio)) from zona) as Porcentaje_Municipios
from zonariesgo
where `Necesidad de Acción` = 'SÍ'
group by `Necesidad de Acción`;
SELECT count(Municipio) from zona;

# ¿Cuántas personas han muerto como resultado de desastres en el departamento? 
select
	SUM(Deaths) Total_Muertes,
    SUM(Injured) Total_Heridos,
    SUM(Missing) Total_Desaparecidos
from `impacto humano`;

# Cuántas casas han sido afectadas?
select
	SUM(`Houses Destroyed`) Total_Casas_Destruidas,
    SUM(`Houses Damaged`) Total_Casas_Dañadas
from impacto_material;

# ¿Cuántos desastres han ocurrido en cada subregión del departamento? 
select
	B.Subregion Subregión,
	count(A.Event) Total_Desastres
from historico A
left join zona B on A.Código_DANE= B.Código_DANE
group by B.Subregion;

# ¿Cuántos desastres por tipo de desastres? 
SELECT
	B.`Tipo de Desastre` Tipo_Desastre,
	count(A.Event) Total_Desastres
FROM historico A
left join tipo_desastre B on A.idTipo_Desastre = B.idTipo_Desastre
GROUP BY Tipo_Desastre;


# ¿Cuántos muertos, heridos y desaparecidad hay por tipo de desastres?
SELECT
	C.`Tipo de Desastre` Tipo_Desastre,
	SUM(A.Deaths) Total_Muertos,
    SUM(A.Injured) Total_Heridos,
    SUM(A.Missing) Total_Desaparecidos
FROM `impacto humano` A
inner join historico B on B.IDimpacto_humano = A.IDimpacto_humano
inner join tipo_desastre C on B.idTipo_Desastre = B.idTipo_Desastre
GROUP BY C.`Tipo de Desastre`;