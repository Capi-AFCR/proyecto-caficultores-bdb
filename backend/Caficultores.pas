unit Caficultores;

// EMS Resource Module

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Comp.Client, Data.DB,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, FireDAC.Stan.Param,
  FireDAC.Phys.Oracle;

type
  [ResourceName('Caficultores')]
  {$METHODINFO ON}
  TCaficultoresResource = class
  published

    [EndPointRequestSummary('Tests', 'ListItems', 'Retrieves list of items', 'application/json', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure Get(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    [EndPointRequestSummary('Tests', 'GetItem', 'Retrieves item with specified ID', 'application/json', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'item', 'A item ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{item}')]
    procedure GetItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    [EndPointRequestSummary('Tests', 'PostItem', 'Creates new item', '', 'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'A new item content', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(409, 'Item Exist', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure Post(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    [EndPointRequestSummary('Tests', 'PutItem', 'Updates item with specified ID', '', 'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'item', 'A item ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'A item changes', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{item}')]
    procedure PutItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    [EndPointRequestSummary('Tests', 'DeleteItem', 'Deletes item with specified ID', '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'item', 'A item ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{item}')]
    procedure DeleteItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);

    [EndPointRequestSummary('Tests', 'GetDetalleCaficultor', 'Retrieves full caficultor details', 'application/json', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'id', 'A caficultor ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(400, 'Bad Request', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{id}/detalle')]
    procedure GetDetalleCaficultor(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;
  {$METHODINFO OFF}

implementation

procedure TCaficultoresResource.Get(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TFDConnection.Create(nil);
    Query.Connection.Params.DriverID := 'Ora';
    Query.Connection.Params.Database := 'XE';
    Query.Connection.Params.UserName := 'system';
    Query.Connection.Params.Password := 'admin';
    Query.SQL.Text := 'SELECT id_caficultor, nombre, identificacion, ciudad FROM caficultores';
    Query.Open;
    JSONArray := TJSONArray.Create;
    while not Query.Eof do
    begin
      JSONObject := TJSONObject.Create;
      JSONObject.AddPair('id_caficultor', TJSONNumber.Create(Query.FieldByName('id_caficultor').AsInteger));
      JSONObject.AddPair('nombre', Query.FieldByName('nombre').AsString);
      JSONObject.AddPair('identificacion', Query.FieldByName('identificacion').AsString);
      JSONObject.AddPair('ciudad', Query.FieldByName('ciudad').AsString);
      JSONArray.AddElement(JSONObject);
      Query.Next;
    end;
    AResponse.Body.SetValue(JSONArray, True);
  finally
    Query.Free;
  end;
end;

procedure TCaficultoresResource.GetItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
  Query: TFDQuery;
  JSONObject: TJSONObject;
begin
  LItem := ARequest.Params.Values['item'];
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TFDConnection.Create(nil);
    Query.Connection.Params.DriverID := 'Ora';
    Query.Connection.Params.Database := 'XE';
    Query.Connection.Params.UserName := 'system';
    Query.Connection.Params.Password := 'admin';
    Query.SQL.Text := 'SELECT id_caficultor, nombre, identificacion, ciudad FROM caficultores WHERE id_caficultor = :id';
    Query.Params.ParamByName('id').AsInteger := StrToIntDef(LItem, -1);
    Query.Open;
    if not Query.IsEmpty then
    begin
      JSONObject := TJSONObject.Create;
      JSONObject.AddPair('id_caficultor', TJSONNumber.Create(Query.FieldByName('id_caficultor').AsInteger));
      JSONObject.AddPair('nombre', Query.FieldByName('nombre').AsString);
      JSONObject.AddPair('identificacion', Query.FieldByName('identificacion').AsString);
      JSONObject.AddPair('ciudad', Query.FieldByName('ciudad').AsString);
      AResponse.Body.SetValue(JSONObject, True);
    end
    else
    begin
      AResponse.RaiseNotFound('Caficultor no encontrado');
    end;
  finally
    Query.Free;
  end;
end;

procedure TCaficultoresResource.Post(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  JSON: TJSONObject;
  Nombre, Identificacion, Ciudad, TipoProducto: string;
  IdCaficultor: Integer;
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
    Nombre := JSON.GetValue<string>('nombre', '');
    Identificacion := JSON.GetValue<string>('identificacion', '');
    Ciudad := JSON.GetValue<string>('ciudad', '');
    TipoProducto := JSON.GetValue<string>('tipo_producto', '');
    // Validaciones
    if (Nombre = '') or (Identificacion = '') or (Ciudad = '') or (TipoProducto = '') then
    begin
      AResponse.RaiseBadRequest('Todos los campos son requeridos');
      Exit;
    end;
    if not (TipoProducto = 'CAA') and not (TipoProducto = 'TAD') and not (TipoProducto = 'SGP') and not (TipoProducto = 'MVI') then
    begin
      AResponse.RaiseBadRequest('Tipo de producto inválido. Use CAA, TAD, SGP o MVI');
      Exit;
    end;
    if not TryStrToInt(Identificacion, IdCaficultor) then
    begin
      AResponse.RaiseBadRequest('Identificación debe ser numérica');
      Exit;
    end;
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := TFDConnection.Create(nil);
      Query.Connection.Params.DriverID := 'Ora';
      Query.Connection.Params.Database := 'XE';
      Query.Connection.Params.UserName := 'system';
      Query.Connection.Params.Password := 'admin';
      // Verificar identificación única
      Query.SQL.Text := 'SELECT 1 FROM caficultores WHERE identificacion = :identificacion';
      Query.Params.ParamByName('identificacion').DataType := ftString; // Especificar tipo
      Query.Params.ParamByName('identificacion').AsString := Identificacion;
      Query.Open;
      if not Query.IsEmpty then
      begin
        AResponse.RaiseDuplicate('Identificación ya registrada');
        Exit;
      end;
      Query.Close;
      // Insertar caficultor
      Query.SQL.Text := 'INSERT INTO caficultores (nombre, identificacion, ciudad) VALUES (:nombre, :identificacion, :ciudad) RETURNING id_caficultor INTO :id';
      Query.Params.ParamByName('nombre').DataType := ftString;
      Query.Params.ParamByName('nombre').AsString := Nombre;
      Query.Params.ParamByName('identificacion').DataType := ftString;
      Query.Params.ParamByName('identificacion').AsString := Identificacion;
      Query.Params.ParamByName('ciudad').DataType := ftString;
      Query.Params.ParamByName('ciudad').AsString := Ciudad;
      Query.Params.ParamByName('id').DataType := ftInteger;
      Query.Params.ParamByName('id').ParamType := ptOutput;
      Query.ExecSQL;
      IdCaficultor := Query.Params.ParamByName('id').AsInteger;
      // Insertar producto asociado
      Query.SQL.Text := 'INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (:id_caficultor, :tipo_producto, :numero_producto, :saldo)';
      Query.Params.ParamByName('id_caficultor').DataType := ftInteger;
      Query.Params.ParamByName('id_caficultor').AsInteger := IdCaficultor;
      Query.Params.ParamByName('tipo_producto').DataType := ftString;
      Query.Params.ParamByName('tipo_producto').AsString := TipoProducto;
      Query.Params.ParamByName('numero_producto').DataType := ftString;
      Query.Params.ParamByName('numero_producto').AsString := TipoProducto + '-' + FormatDateTime('yyyymmddhhnnss', Now) + '-' + IdCaficultor.ToString;
      Query.Params.ParamByName('saldo').DataType := ftFloat;
      Query.Params.ParamByName('saldo').AsFloat := 0;
      Query.ExecSQL;
      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Caficultor y producto registrados').AddPair('id_caficultor', TJSONNumber.Create(IdCaficultor)), True);
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      AResponse.RaiseError(500, 'Error al registrar caficultor y producto: ', E.Message);
      Exit;
    end;
  end;
end;

procedure TCaficultoresResource.PutItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
  Query: TFDQuery;
  JSON: TJSONObject;
  Nombre, Ciudad: string;
  IdCaficultor: Integer;
begin
  LItem := ARequest.Params.Values['item'];
  if not TryStrToInt(LItem, IdCaficultor) then
  begin
    AResponse.RaiseBadRequest('ID inválido');
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

  Nombre := JSON.GetValue<string>('nombre', '');
  Ciudad := JSON.GetValue<string>('ciudad', '');

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TFDConnection.Create(nil);
    Query.Connection.Params.DriverID := 'Ora';
    Query.Connection.Params.Database := 'XE';
    Query.Connection.Params.UserName := 'system';
    Query.Connection.Params.Password := 'admin';
    Query.SQL.Text := 'UPDATE caficultores SET nombre = :nombre, ciudad = :ciudad WHERE id_caficultor = :id';
    Query.Params.ParamByName('nombre').AsString := Nombre;
    Query.Params.ParamByName('ciudad').AsString := Ciudad;
    Query.Params.ParamByName('id').AsInteger := IdCaficultor;
    Query.ExecSQL;

    if Query.RowsAffected = 0 then
      AResponse.RaiseNotFound('Caficultor no encontrado')
    else
      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Caficultor actualizado'), True);
  finally
    Query.Free;
    JSON.Free;
  end;
end;

procedure TCaficultoresResource.DeleteItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
  Query: TFDQuery;
  IdCaficultor: Integer;
begin
  LItem := ARequest.Params.Values['item'];
  if not TryStrToInt(LItem, IdCaficultor) then
  begin
    AResponse.RaiseBadRequest('ID inválido');
    Exit;
  end;

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TFDConnection.Create(nil);
    Query.Connection.Params.DriverID := 'Ora';
    Query.Connection.Params.Database := 'XE';
    Query.Connection.Params.UserName := 'system';
    Query.Connection.Params.Password := 'admin';
    Query.SQL.Text := 'DELETE FROM caficultores WHERE id_caficultor = :id';
    Query.Params.ParamByName('id').AsInteger := IdCaficultor;
    Query.ExecSQL;

    if Query.RowsAffected = 0 then
      AResponse.RaiseNotFound('Caficultor no encontrado')
    else
      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Caficultor eliminado'), True);
  finally
    Query.Free;
  end;
end;

procedure TCaficultoresResource.GetDetalleCaficultor(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  IdCaficultor: Integer;
  Nombre, Identificacion, Ciudad: string;
  JSONObject, ProductoObj: TJSONObject;
  ProductosArray: TJSONArray;
  ProdCursor: TDataSet;
begin
  try
    IdCaficultor := StrToIntDef(ARequest.Params.Values['id'], -1);
    if IdCaficultor <= 0 then
    begin
      AResponse.RaiseBadRequest('ID de caficultor inválido');
      Exit;
    end;

    Query := TFDQuery.Create(nil);
    try
      Query.Connection := TFDConnection.Create(nil);
      Query.Connection.Params.DriverID := 'Ora';
      Query.Connection.Params.Database := 'XE';
      Query.Connection.Params.UserName := 'system';
      Query.Connection.Params.Password := 'admin';

      Query.SQL.Text := 'BEGIN consultar_detalle_caficultor(:p_id_caficultor, :p_nombre, :p_identificacion, :p_ciudad, :p_productos); END;';
      Query.Params.ParamByName('p_id_caficultor').DataType := ftInteger;
      Query.Params.ParamByName('p_id_caficultor').AsInteger := IdCaficultor;
      Query.Params.ParamByName('p_nombre').DataType := ftString;
      Query.Params.ParamByName('p_nombre').Size := 100; // Ajustar según la definición de la columna
      Query.Params.ParamByName('p_nombre').ParamType := ptOutput;
      Query.Params.ParamByName('p_identificacion').DataType := ftString;
      Query.Params.ParamByName('p_identificacion').Size := 20;
      Query.Params.ParamByName('p_identificacion').ParamType := ptOutput;
      Query.Params.ParamByName('p_ciudad').DataType := ftString;
      Query.Params.ParamByName('p_ciudad').Size := 50;
      Query.Params.ParamByName('p_ciudad').ParamType := ptOutput;
      Query.Params.ParamByName('p_productos').DataType := ftCursor;
      Query.Params.ParamByName('p_productos').ParamType := ptOutput;
      Query.ExecSQL;

      Nombre := Query.Params.ParamByName('p_nombre').AsString;
      Identificacion := Query.Params.ParamByName('p_identificacion').AsString;
      Ciudad := Query.Params.ParamByName('p_ciudad').AsString;


      // Obtener cursores
      ProdCursor := Query.Params.ParamByName('p_productos').AsDataSet;

      // Construir respuesta JSON
      JSONObject := TJSONObject.Create;
      JSONObject.AddPair('id_caficultor', TJSONNumber.Create(IdCaficultor));
      JSONObject.AddPair('nombre', Nombre);
      JSONObject.AddPair('identificacion', Identificacion);
      JSONObject.AddPair('ciudad', Ciudad);

      // Productos
      ProductosArray := TJSONArray.Create;
      if (ProdCursor <> nil) then
      begin
        ProdCursor.First;
        while not ProdCursor.Eof do
        begin
          ProductoObj := TJSONObject.Create;
          ProductoObj.AddPair('id_producto', TJSONNumber.Create(ProdCursor.FieldByName('id_producto').AsInteger));
          ProductoObj.AddPair('numero_producto', ProdCursor.FieldByName('numero_producto').AsString);
          ProductoObj.AddPair('saldo', TJSONNumber.Create(ProdCursor.FieldByName('saldo').AsFloat));
          ProductosArray.AddElement(ProductoObj);
          ProdCursor.Next;
        end;
      end;
      JSONObject.AddPair('productos', ProductosArray);

      AResponse.Body.SetValue(JSONObject, True);
      AResponse.StatusCode := 200;
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      AResponse.RaiseError(500, 'Error al consultar detalle: ',E.Message);
      Exit;
    end;
  end;
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TCaficultoresResource));
end;

initialization
  Register;
end.


