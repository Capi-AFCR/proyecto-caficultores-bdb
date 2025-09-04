import React from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import CaficultorForm from './components/CaficultorForm';
import TablaCaficultores from './components/TablaCaficultores';
import TablaAbonos from './components/TablaAbonos';
import AbonoForm from './components/AbonoForm';
import SaldoForm from './components/SaldoForm';
import CaficultorDetail from './components/CaficultorDetail';

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
          <Route path="/abonos/registrar/:id" element={<AbonoForm />} />
          <Route path="/saldos/:id" element={<SaldoForm />} />
          <Route path="/caficultores/:id" element={<CaficultorDetail />} />
          
        </Routes>
      </div>
    </BrowserRouter>
  );
}

export default App;