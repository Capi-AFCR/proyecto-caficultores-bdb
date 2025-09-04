import axios from 'axios';

const API_BASE = 'http://localhost:8080';  // URL del backend Delphi

export const getCaficultores = async () => {
  try {
    const response = await axios.get(`${API_BASE}/caficultores`);
    return response.data;
  } catch (error) {
    console.error('Error consultando caficultores:', error);
    throw error;
  }
};

export const postCaficultor = async (data) => {
  try {
    const response = await axios.post(`${API_BASE}/caficultores`, data);
    console.log(response);
    return response.data;
  } catch (error) {
    throw error.response?.data?.message || 'Error al registrar caficultor';
  }
};

export const putCaficultor = async (id, data) => {
  try {
    const response = await axios.put(`${API_BASE}/caficultores/${id}`, data);
    return response.data;
  } catch (error) {
    throw error.response?.data?.message || 'Error al actualizar caficultor';
  }
};

export const deleteCaficultor = async (id) => {
  try {
    const response = await axios.delete(`${API_BASE}/caficultores/${id}`);
    return response.data;
  } catch (error) {
    throw error.response?.data?.message || 'Error al eliminar caficultor';
  }
};

export const getAbonos = async (idCaficultor, { params } = {}) => {
  try {
    const response = await axios.get(`${API_BASE}/abonos/${idCaficultor}`, { params });
    return response.data;
  } catch (error) {
    console.error('Error consultando abonos:', error);
    throw error.response?.data?.message || 'Error al consultar abonos';
  }
};

export const postAbono = async (data) => {
  try {
    const response = await axios.post(`${API_BASE}/abonos`, data);
    return response.data;
  } catch (error) {
    throw error.response?.data?.message || 'Error al registrar abono';
  }
};

export const putAbono = async (id, data) => {
  try {
    const response = await axios.put(`${API_BASE}/abonos/${id}`, data);
    return response.data;
  } catch (error) {
    throw error.response?.data?.message || 'Error al actualizar abono';
  }
};

export const deleteAbono = async (id) => {
  try {
    const response = await axios.delete(`${API_BASE}/abonos/${id}`);
    return response.data;
  } catch (error) {
    throw error.response?.data?.message || 'Error al eliminar abono';
  }
};

export const getMonederos = async () => {
  try {
    const response = await axios.get(`${API_BASE}/abonos`);
    return response.data;
  } catch (error) {
    console.error('Error consultando monederos:', error);
    throw error;
  }
};

export const getSaldoPorCaficultor = async (id) => {
  try {
    const response = await axios.get(`${API_BASE}/saldos/${id}`);
    return response.data;
  } catch (error) {
    console.error('Error consultando saldo:', error);
    throw error.response?.data?.message || 'Error al consultar saldo';
  }
};

export const getDetalleCaficultor = async (id) => {
  try {
    const response = await axios.get(`${API_BASE}/caficultores/${id}/detalle`);
    return response.data;
  } catch (error) {
    console.error('Error consultando detalle:', error);
    throw error.response?.data?.message || 'Error al consultar detalle';
  }
};

export const getProductos = async () => {
  try {
    const response = await axios.get(`${API_BASE}/productos`);
    return response.data;
  } catch (error) {
    console.error('Error consultando productos:', error);
    throw error;
  }
};

export const postProducto = async (data) => {
  try {
    const response = await axios.post(`${API_BASE}/productos`, data);
    return response.data;
  } catch (error) {
    throw error.response?.data?.message || 'Error al registrar producto';
  }
};

export const putProducto = async (id, data) => {
  try {
    const response = await axios.put(`${API_BASE}/productos/${id}`, data);
    return response.data;
  } catch (error) {
    throw error.response?.data?.message || 'Error al actualizar producto';
  }
};

export const deleteProducto = async (id) => {
  try {
    const response = await axios.delete(`${API_BASE}/productos/${id}`);
    return response.data;
  } catch (error) {
    throw error.response?.data?.message || 'Error al eliminar producto';
  }
};