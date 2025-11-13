const { Sequelize } = require("sequelize");
const { QueryTypes } = require('sequelize');

let connection = new Sequelize(
  "educonectaDB", 
  "root", 
  "123456", 
  {
    host: 'localhost',
    dialect: 'mysql'
  }
);


/**
 * Ejecuta un procedimiento almacenado con parámetros dinámicos.
 * @param {string} procedureName - Nombre del procedimiento almacenado.
 * @param {Array<any>} params - Lista de parámetros en orden.
 */
executeStoredProcedure = async (sequelize, procedureName, params = []) => {
  try {
    // Generar placeholders (?, ?, ?) según la cantidad de parámetros
    console.log(params);
    const placeholders = params.map(() => '?').join(', ');
    const query = `CALL ${procedureName}(${placeholders})`;

    const [results, metadata] = await sequelize.query(query, {
      replacements: params,
      type: QueryTypes.SELECT
    });
    let result = Object.values(results);
    // console.log(`Resultados de ${procedureName}:`, Object.values(result));
    return result;
  } catch (error) {
    console.error(`Error ejecutando ${procedureName}:`, error);
    throw error;
  }
}

module.exports = {
  connection,
  executeStoredProcedure
}