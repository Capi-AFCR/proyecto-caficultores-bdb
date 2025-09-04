import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import CaficultorForm from './components/CaficultorForm';
import TablaCaficultores from './components/TablaCaficultores';
import TablaAbonos from './components/TablaAbonos';
import AbonoForm from './components/AbonoForm';

function App() {
  return (
    <BrowserRouter>
      <div style={{ padding: '20px' }}>
        <h1>Plataforma FNC</h1>
        <Routes>
          <Route path="/" element={<TablaCaficultores />} />
          <Route path="/registrar" element={<CaficultorForm />} />
          <Route path="/abonos/:idCaficultor" element={<TablaAbonos />} />
          <Route path="/abonos/registrar" element={<AbonoForm />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;