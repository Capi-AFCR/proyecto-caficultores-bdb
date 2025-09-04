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

export const getAbonos = async () => {
  try {
    const response = await axios.get(`${API_BASE}/abonos`);
    return response.data;
  } catch (error) {
    console.error('Error consultando abonos:', error);
    throw error;
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

export const getMonederos = async () => {
  try {
    const response = await axios.get(`${API_BASE}/abonos`);
    return response.data;
  } catch (error) {
    console.error('Error consultando monederos:', error);
    throw error;
  }
};