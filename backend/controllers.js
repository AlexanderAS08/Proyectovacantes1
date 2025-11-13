const Database = require("./database");

let procedures = {
  'POST': {
    'schools/by': 'sp_sel_schools',
    'schools/create': 'sp_ins_schools',
    'people/by': 'sp_sel_people',
    'people/create': 'sp_ins_people',
    'parents/by': 'sp_sel_parents',
    'parents/create': 'sp_ins_parents',
    'students/by': 'sp_sel_students',
    'students/create': 'sp_ins_students',
    'drages/by': 'sp_sel_drages',
    'drages/create': 'sp_ins_drages',
    'enrollments/by': 'sp_sel_enrollments',
    'enrollments/create': 'sp_ins_enrollments',
    'documents/by': 'sp_sel_documents',
    'documents/create': 'sp_ins_documents',
    'grades_in_schools/by': 'sp_sel_grades_in_schools',
    'grades_in_schools/create': 'sp_ins_grades_in_schools',
  },
  'PUT': {
    'schools/update': 'sp_upd_schools',
    'people/update': 'sp_upd_people',
    'parents/update': 'sp_upd_parents',
    'students/update': 'sp_upd_students',
    'drages/update': 'sp_upd_drages',
    'enrollments/update': 'sp_upd_enrollments',
    'documents/update': 'sp_upd_documents',
    'grades_in_schools/update': 'sp_upd_grades_in_schools',
  }
}

ListEntity = (fnName, filter) => new Promise(async (resolve, rejected) => {

  try {
    await Database.connection.authenticate();
    let result = await Database.executeStoredProcedure(Database.connection, fnName, [filter.id || null, filter.search || null]);
    resolve(result);
  } catch (error) {
    rejected({ error: true, message: `Hubo un error: ${error}` });
  }
});

NewEntity = (fnName, data) => new Promise(async (resolve, rejected) => {
  try {
    await Database.connection.authenticate();
    let result = await Database.executeStoredProcedure(Database.connection, fnName, data);
    // let result = [{ data: `SELECT * FROM public.${fnName}('${JSON.stringify(data)}'::jsonb)`}];
    if (result[0] && Object.values(result[0])[0]) {
      resolve(result[0]);
    } else {
      rejected({ error: true, message: `No se pudo registrar: ${JSON.stringify(result)}` });
    }
  } catch (error) {
    rejected({ error: true, message: `Hubo un error: ${error}` });
  }
});

AlterEntity = (fnName, data) => new Promise(async (resolve, rejected) => {
  try {
    await Database.connection.authenticate();
    let result = await Database.executeStoredProcedure(Database.connection, fnName, data);
    if (result[0] && Object.values(result[0])[0]) {
      resolve({ message: "Proceso realizado correctamente" });
    } else {
      rejected({ error: true, message: `No se pudo actualizar: ${JSON.stringify(result)}` });
    }
  } catch (error) {
    rejected({ error: true, message: `Hubo un error: ${error}` });
  }
});

const getDataSource = (method, url) => {
  if (procedures[method] && procedures[method][url]) {
    return procedures[method][url];
  }
  return null;
};

getEntitiesBy = async (req, res) => {
  try {
    let partUrl = req.url.substring(1);
    let procedure = getDataSource(req.method, partUrl);
    console.log(partUrl);
    console.log(procedure);
    if (!procedure) {
      return res.status(404).json({error: true, message: "Endpoint no encontrado"});
    }
    
    let entities = await ListEntity(procedure, req.body.filter || {});
    
    if (entities && entities.error) {
      return res.status(200).json({error: true, message: entities.message});
    }
    
    res.status(200).json({success: true, data: entities});
  } catch (error) {
    res.status(200).json({error: true, message: error.toString()});
  }
}


createEntities = async (req, res) => {
  try {
    if (!req.body.news) {
      return res.status(400).json({error: true, message: "No se proporciona información para insertar"});
    }
    
    let partUrl = req.url.substring(1);
    let procedure = getDataSource(req.method, partUrl);
    
    if (!procedure) {
      return res.status(404).json({error: true, message: "Endpoint no encontrado"});
    }
    
    let entities = await NewEntity(procedure, req.body.news);
    
    if (entities && entities.error) {
      return res.status(200).json({error: true, message: entities.message});
    }
    
    res.status(201).json({success: true, data: entities});
  } catch (error) {
    res.status(200).json({error: true, message: error.toString()});
  }
}

updateEntities = async (req, res) => {
  try {
    if (!req.body.updateds) {
      return res.status(400).json({error: true, message: "No se proporciona información para actualizar"});
    }
    
    let partUrl = req.url.substring(1);
    let procedure = getDataSource(req.method, partUrl);
    
    if (!procedure) {
      return res.status(404).json({error: true, message: "Endpoint no encontrado"});
    }
    
    let entities = await AlterEntity(procedure, req.body.updateds);
    
    if (entities && entities.error) {
      return res.status(200).json({error: true, message: entities.message});
    }
    
    res.status(200).json({success: true, data: entities});
  } catch (error) {
    console.log(error);
    res.status(200).json({error: true, message: error.toString()});
  }
}

uploadDocument = async (req, res) => {
  res.status(200).json(req.file);
}


module.exports = {
  getEntitiesBy,
  createEntities,
  updateEntities,
  uploadDocument
}