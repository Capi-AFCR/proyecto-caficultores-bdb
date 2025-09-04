unit Abonos;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Comp.Client, Data.DB,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, FireDAC.Stan.Param,
  FireDAC.Phys.Oracle;

type
  [ResourceName('Abonos')]
  {$METHODINFO ON}
  TAbonosResource = class
  published
  [EndPointRequestSummary('Tests', 'GetMonederos', 'Retrieves list of monederos', 'application/json', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure GetMonederos(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [EndPointRequestSummary('Tests', 'PostAbono', 'Registers a payment to wallet', '', 'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'Abono data', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(400, 'Bad Request', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure PostAbono(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [EndPointRequestSummary('Tests', 'GetAbonosPorCaficultor', 'Retrieves abonos by caficultor with date filters', 'application/json', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'id', 'A caficultor ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Query, 'fechaInicio', 'Start date (YYYY-MM-DD)', false, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Query, 'fechaFin', 'End date (YYYY-MM-DD)', false, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(400, 'Bad Request', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{id}')]
    procedure GetAbonosPorCaficultor(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [EndPointRequestSummary('Tests', 'PutAbono', 'Updates abono with specified ID', '', 'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'item', 'A abono ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'Abono changes', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{item}')]
    procedure PutAbono(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [EndPointRequestSummary('Tests', 'DeleteAbono', 'Deletes abono with specified ID', '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'item', 'A abono ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{item}')]
    procedure DeleteAbono(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

procedure TAbonosResource.GetMonederos(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
begin
  try
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := TFDConnection.Create(nil);
      Query.Connection.Params.DriverID := 'Ora';
      Query.Connection.Params.Database := 'XE';
      Query.Connection.Params.UserName := 'system';
      Query.Connection.Params.Password := 'admin';
      Query.SQL.Text := 'SELECT p.id_producto, p.numero_producto, c.nombre FROM productos p JOIN caficultores c ON p.id_caficultor = c.id_caficultor WHERE p.tipo_producto = ''MVI''';
      Query.Open;
      JSONArray := TJSONArray.Create;
      while not Query.Eof do
      begin
        JSONObject := TJSONObject.Create;
        JSONObject.AddPair('id_producto', TJSONNumber.Create(Query.FieldByName('id_producto').AsInteger));
        JSONObject.AddPair('label', Query.FieldByName('numero_producto').AsString + ' - ' + Query.FieldByName('nombre').AsString);
        JSONArray.AddElement(JSONObject);
        Query.Next;
      end;
      AResponse.Body.SetValue(JSONArray, True);
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      AResponse.RaiseError(500, 'Error al consultar monederos: ', E.Message);
      Exit;
    end;
  end;
end;

procedure TAbonosResource.PostAbono(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  JSON: TJSONObject;
  IdProducto, IdAbono: Integer;
  Monto: Double;
  FechaAbono: TDateTime;
  Descripcion: string;
  NuevoSaldo: Double;
begin
  try
    // Obtener el cuerpo de la solicitud como JSON
    if not Assigned(ARequest.Body) then
    begin
      AResponse.RaiseBadRequest('Cuerpo de solicitud vacío o inválido');
      Exit;
    end;
    JSON := ARequest.Body.GetObject as TJSONObject;
    if not Assigned(JSON) then
    begin
      AResponse.RaiseBadRequest('Formato JSON inválido');
      Exit;
    end;

    // Extraer valores del JSON
    IdProducto := JSON.GetValue<Integer>('id_producto', 0);
    Monto := JSON.GetValue<Double>('monto', 0.0);
    FechaAbono := JSON.GetValue<TDateTime>('fecha_abono', Now);
    Descripcion := JSON.GetValue<string>('descripcion', '');

    // Validaciones básicas
    if IdProducto <= 0 then
    begin
      AResponse.RaiseBadRequest('ID de producto inválido');
      Exit;
    end;
    if Monto <= 0 then
    begin
      AResponse.RaiseBadRequest('Monto debe ser mayor a 0');
      Exit;
    end;

    // Iniciar conexión y transacción
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := TFDConnection.Create(nil);
      Query.Connection.Params.DriverID := 'Ora';
      Query.Connection.Params.Database := 'XE';
      Query.Connection.Params.UserName := 'system';
      Query.Connection.Params.Password := 'admin';
      // Verificar si el producto existe
      Query.SQL.Text := 'SELECT saldo FROM productos WHERE id_producto = :id_producto';
      Query.Params.ParamByName('id_producto').DataType := ftInteger;
      Query.Params.ParamByName('id_producto').AsInteger := IdProducto;
      Query.Open;
      if Query.IsEmpty then
      begin
        AResponse.RaiseNotFound('Producto no encontrado');
        Exit;
      end;
      NuevoSaldo := Query.FieldByName('saldo').AsFloat + Monto;
      Query.Close;

      // Insertar abono
      Query.SQL.Text := 'BEGIN registrar_abono(:p_id_producto, :p_monto, :p_descripcion, :p_id_abono); END;';
      Query.Params.ParamByName('p_id_producto').DataType := ftInteger;
      Query.Params.ParamByName('p_id_producto').AsInteger := IdProducto;
      Query.Params.ParamByName('p_monto').DataType := ftFloat;
      Query.Params.ParamByName('p_monto').AsFloat := Monto;
      Query.Params.ParamByName('p_descripcion').DataType := ftString;
      Query.Params.ParamByName('p_descripcion').AsString := Descripcion;
      Query.Params.ParamByName('p_id_abono').DataType := ftInteger;
      Query.Params.ParamByName('p_id_abono').ParamType := ptOutput;
      Query.ExecSQL;
      IdAbono := Query.Params.ParamByName('p_id_abono').AsInteger;

      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Abono '+InttoStr(IdAbono)+' registrado con éxito').AddPair('nuevo_saldo', TJSONNumber.Create(NuevoSaldo)), True);
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      AResponse.RaiseError(500, 'Error al registrar abono: ', E.Message);
      Exit;
    end;
  end;
end;

procedure TAbonosResource.GetAbonosPorCaficultor(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  IdCaficultor: Integer;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  FechaInicio, FechaFin: TDateTime;
  FechaInicioStr, FechaFinStr: string;
  fs: TFormatSettings;
begin
  try
    IdCaficultor := StrToIntDef(ARequest.Params.Values['id'], -1);
    if IdCaficultor <= 0 then
    begin
      AResponse.RaiseBadRequest('ID de caficultor inválido');
      Exit;
    end;

    // Obtener parámetros de fecha de la solicitud
    FechaInicioStr := ARequest.Params.Values['fechaInicio'];
    FechaFinStr := ARequest.Params.Values['fechaFin'];

    // Convertir cadenas a TDateTime, manejar valores vacíos
    FechaInicio := 0;
    FechaFin := 0;
    fs := TFormatSettings.Create;
    fs.DateSeparator := '-';
    fs.ShortDateFormat := 'yyyy-MM-dd';
    if FechaInicioStr <> '' then
    begin
      try
        FechaInicio := StrToDate(FechaInicioStr,fs);
      except
        AResponse.RaiseBadRequest('Formato de fechaInicio inválido (YYYY-MM-DD)');
        Exit;
      end;
    end;
    if FechaFinStr <> '' then
    begin
      try
        FechaFin := StrToDate(FechaFinStr,fs);
      except
        AResponse.RaiseBadRequest('Formato de fechaFin inválido (YYYY-MM-DD)');
        Exit;
      end;
    end;

    // Validar que fechaInicio no sea mayor a fechaFin si ambas están definidas
    if (FechaInicioStr <> '') and (FechaFinStr <> '') and (FechaInicio > FechaFin) then
    begin
      AResponse.RaiseBadRequest('fechaInicio no puede ser mayor a fechaFin');
      Exit;
    end;

    Query := TFDQuery.Create(nil);
    try
      Query.Connection := TFDConnection.Create(nil);
      Query.Connection.Params.DriverID := 'Ora';
      Query.Connection.Params.Database := 'XE';
      Query.Connection.Params.UserName := 'system';
      Query.Connection.Params.Password := 'admin';

      Query.SQL.Text := 'SELECT a.id_abono, a.id_producto, a.monto, a.fecha_abono, a.descripcion ' +
                       'FROM abonos a ' +
                       'JOIN productos p ON a.id_producto = p.id_producto ' +
                       'WHERE p.id_caficultor = :id_caficultor ' +
                       'AND p.tipo_producto = ''MVI''';
      Query.Params.ParamByName('id_caficultor').DataType := ftInteger;
      Query.Params.ParamByName('id_caficultor').AsInteger := IdCaficultor;

      // Agregar filtros de fecha si se proporcionan
      if FechaInicioStr <> '' then
        Query.SQL.Text := Query.SQL.Text + ' AND a.fecha_abono >= :fechaInicio';
      if FechaFinStr <> '' then
        Query.SQL.Text := Query.SQL.Text + ' AND a.fecha_abono <= :fechaFin';

      Query.Params.ParamByName('id_caficultor').AsInteger := IdCaficultor;
      if FechaInicioStr <> '' then
      begin
        Query.Params.CreateParam(ftDate, 'fechaInicio', ptInput);
        Query.Params.ParamByName('fechaInicio').AsDateTime := FechaInicio;
      end;
      if FechaFinStr <> '' then
      begin
        Query.Params.CreateParam(ftDate, 'fechaFin', ptInput);
        Query.Params.ParamByName('fechaFin').AsDateTime := FechaFin;
      end;

      Query.Open;

      JSONArray := TJSONArray.Create;
      while not Query.Eof do
      begin
        JSONObject := TJSONObject.Create;
        JSONObject.AddPair('id_abono', TJSONNumber.Create(Query.FieldByName('id_abono').AsInteger));
        JSONObject.AddPair('id_producto', TJSONNumber.Create(Query.FieldByName('id_producto').AsInteger));
        JSONObject.AddPair('monto', TJSONNumber.Create(Query.FieldByName('monto').AsFloat));
        JSONObject.AddPair('fecha_abono', DateTimeToStr(Query.FieldByName('fecha_abono').AsDateTime));
        JSONObject.AddPair('descripcion', Query.FieldByName('descripcion').AsString);
        JSONArray.AddElement(JSONObject);
        Query.Next;
      end;

      if JSONArray.Count = 0 then
      begin
        Query.SQL.Text := 'SELECT 1 FROM caficultores WHERE id_caficultor = :id_caficultor';
        Query.Params.ParamByName('id_caficultor').DataType := ftInteger;
        Query.Params.ParamByName('id_caficultor').AsInteger := IdCaficultor;
        Query.Open;
        if Query.IsEmpty then
        begin
          AResponse.RaiseNotFound('Caficultor no encontrado');
        end
        else
        begin
          AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'No se encontraron abonos para este caficultor'), True);
          AResponse.StatusCode := 200;
        end;
      end
      else
      begin
        AResponse.Body.SetValue(JSONArray, True);
        AResponse.StatusCode := 200;
      end;
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      AResponse.RaiseError(500, 'Error al consultar abonos: ', E.Message);
      Exit;
    end;
  end;
end;

procedure TAbonosResource.PutAbono(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
  Query: TFDQuery;
  JSON: TJSONObject;
  IdAbono, IdProducto: Integer;
  Monto: Double;
  FechaAbono: TDateTime;
  Descripcion: string;
begin
  LItem := ARequest.Params.Values['item'];
  if not TryStrToInt(LItem, IdAbono) then
  begin
    AResponse.RaiseBadRequest('ID de abono inválido');
    Exit;
  end;
  if not Assigned(ARequest.Body) then
  begin
    AResponse.RaiseBadRequest('Cuerpo de solicitud vacío o inválido');
    Exit;
  end;
  JSON := ARequest.Body.GetObject as TJSONObject;
  if not Assigned(JSON) then
  begin
    AResponse.RaiseBadRequest('Formato JSON inválido');
    Exit;
  end;
  IdProducto := JSON.GetValue<Integer>('id_producto', 0);
  Monto := JSON.GetValue<Double>('monto', 0.0);
  FechaAbono := JSON.GetValue<TDateTime>('fecha_abono', 0);
  Descripcion := JSON.GetValue<string>('descripcion', '');
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TFDConnection.Create(nil);
    Query.Connection.Params.DriverID := 'Ora';
    Query.Connection.Params.Database := 'XE';
    Query.Connection.Params.UserName := 'system';
    Query.Connection.Params.Password := 'admin';
    Query.SQL.Text := 'UPDATE abonos SET id_producto = :id_producto, monto = :monto, fecha_abono = :fecha_abono, descripcion = :descripcion WHERE id_abono = :id';
    Query.Params.ParamByName('id_producto').AsInteger := IdProducto;
    Query.Params.ParamByName('monto').AsFloat := Monto;
    if FechaAbono <> 0 then
      Query.Params.ParamByName('fecha_abono').AsDateTime := FechaAbono;
    Query.Params.ParamByName('descripcion').AsString := Descripcion;
    Query.Params.ParamByName('id').AsInteger := IdAbono;
    Query.ExecSQL;
    if Query.RowsAffected = 0 then
      AResponse.RaiseNotFound('Abono no encontrado')
    else
      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Abono actualizado'), True);
    AResponse.StatusCode := 200;
  finally
    Query.Free;
    JSON.Free;
  end;
end;

procedure TAbonosResource.DeleteAbono(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
  Query: TFDQuery;
  IdAbono: Integer;
begin
  LItem := ARequest.Params.Values['item'];
  if not TryStrToInt(LItem, IdAbono) then
  begin
    AResponse.RaiseBadRequest('ID de abono inválido');
    Exit;
  end;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TFDConnection.Create(nil);
    Query.Connection.Params.DriverID := 'Ora';
    Query.Connection.Params.Database := 'XE';
    Query.Connection.Params.UserName := 'system';
    Query.Connection.Params.Password := 'admin';
    Query.SQL.Text := 'DELETE FROM abonos WHERE id_abono = :id';
    Query.Params.ParamByName('id').AsInteger := IdAbono;
    Query.ExecSQL;
    if Query.RowsAffected = 0 then
      AResponse.RaiseNotFound('Abono no encontrado')
    else
      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Abono eliminado'), True);
    AResponse.StatusCode := 200;
  finally
    Query.Free;
  end;
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TAbonosResource));
end;

initialization
  Register;
end.
