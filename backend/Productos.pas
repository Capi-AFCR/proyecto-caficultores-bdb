unit Productos;

interface

uses
  System.SysUtils, System.Classes, System.JSON, FireDAC.Comp.Client, Data.DB,
  EMS.Services, EMS.ResourceAPI, EMS.ResourceTypes, FireDAC.Stan.Param,
  FireDAC.Phys.Oracle;

type
  [ResourceName('Productos')]
  {$METHODINFO ON}
  TProductosResource = class
  published
    [EndPointRequestSummary('Tests', 'GetProductos', 'Retrieves list of products', 'application/json', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spObject, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure GetProductos(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [EndPointRequestSummary('Tests', 'PostProducto', 'Creates new product', '', 'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'A new product content', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(400, 'Bad Request', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    procedure PostProducto(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [EndPointRequestSummary('Tests', 'PutProducto', 'Updates product with specified ID', '', 'application/json')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'item', 'A product ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Body, 'body', 'A product changes', true, TAPIDoc.TPrimitiveType.spObject,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spObject, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{item}')]
    procedure PutProducto(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
    [EndPointRequestSummary('Tests', 'DeleteProducto', 'Deletes product with specified ID', '', '')]
    [EndPointRequestParameter(TAPIDocParameter.TParameterIn.Path, 'item', 'A product ID', true, TAPIDoc.TPrimitiveType.spString,
      TAPIDoc.TPrimitiveFormat.None, TAPIDoc.TPrimitiveType.spString, '', '')]
    [EndPointResponseDetails(200, 'Ok', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [EndPointResponseDetails(404, 'Not Found', TAPIDoc.TPrimitiveType.spNull, TAPIDoc.TPrimitiveFormat.None, '', '')]
    [ResourceSuffix('{item}')]
    procedure DeleteProducto(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;

implementation

procedure TProductosResource.GetProductos(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
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
    Query.SQL.Text := 'SELECT id_producto, id_caficultor, tipo_producto, numero_producto, saldo FROM productos';
    Query.Open;
    JSONArray := TJSONArray.Create;
    while not Query.Eof do
    begin
      JSONObject := TJSONObject.Create;
      JSONObject.AddPair('id_producto', TJSONNumber.Create(Query.FieldByName('id_producto').AsInteger));
      JSONObject.AddPair('id_caficultor', TJSONNumber.Create(Query.FieldByName('id_caficultor').AsInteger));
      JSONObject.AddPair('tipo_producto', Query.FieldByName('tipo_producto').AsString);
      JSONObject.AddPair('numero_producto', Query.FieldByName('numero_producto').AsString);
      JSONObject.AddPair('saldo', TJSONNumber.Create(Query.FieldByName('saldo').AsFloat));
      JSONArray.AddElement(JSONObject);
      Query.Next;
    end;
    AResponse.Body.SetValue(JSONArray, True);
    AResponse.StatusCode := 200;
  finally
    Query.Free;
  end;
end;

procedure TProductosResource.PostProducto(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  Query: TFDQuery;
  JSON: TJSONObject;
  IdCaficultor, IdProducto: Integer;
  TipoProducto, NumeroProducto: string;
  Saldo: Double;
begin
  try
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
    IdCaficultor := JSON.GetValue<Integer>('id_caficultor', 0);
    TipoProducto := JSON.GetValue<string>('tipo_producto', '');
    NumeroProducto := JSON.GetValue<string>('numero_producto', '');
    Saldo := JSON.GetValue<Double>('saldo', 0.0);
    if (IdCaficultor <= 0) or (TipoProducto = '') or (NumeroProducto = '') then
    begin
      AResponse.RaiseBadRequest('id_caficultor, tipo_producto y numero_producto son requeridos');
      Exit;
    end;
    if not (TipoProducto = 'CAA') and not (TipoProducto = 'TAD') and not (TipoProducto = 'SGP') and not (TipoProducto = 'MVI') then
    begin
      AResponse.RaiseBadRequest('Tipo de producto inválido. Use CAA, TAD, SGP o MVI');
      Exit;
    end;
    Query := TFDQuery.Create(nil);
    try
      Query.Connection := TFDConnection.Create(nil);
      Query.Connection.Params.DriverID := 'Ora';
      Query.Connection.Params.Database := 'XE';
      Query.Connection.Params.UserName := 'system';
      Query.Connection.Params.Password := 'admin';
      Query.SQL.Text := 'SELECT 1 FROM caficultores WHERE id_caficultor = :id_caficultor';
      Query.Params.ParamByName('id_caficultor').DataType := ftInteger;
      Query.Params.ParamByName('id_caficultor').AsInteger := IdCaficultor;
      Query.Open;
      if Query.IsEmpty then
      begin
        AResponse.RaiseNotFound('Caficultor no encontrado');
        Exit;
      end;
      Query.Close;
      Query.SQL.Text := 'INSERT INTO productos (id_caficultor, tipo_producto, numero_producto, saldo) VALUES (:id_caficultor, :tipo_producto, :numero_producto, :saldo) RETURNING id_producto INTO :id';
      Query.Params.ParamByName('id_caficultor').DataType := ftInteger;
      Query.Params.ParamByName('id_caficultor').AsInteger := IdCaficultor;
      Query.Params.ParamByName('tipo_producto').DataType := ftString;
      Query.Params.ParamByName('tipo_producto').AsString := TipoProducto;
      Query.Params.ParamByName('numero_producto').DataType := ftString;
      Query.Params.ParamByName('numero_producto').AsString := NumeroProducto;
      Query.Params.ParamByName('saldo').DataType := ftFloat;
      Query.Params.ParamByName('saldo').AsFloat := Saldo;
      Query.Params.ParamByName('id').DataType := ftInteger;
      Query.Params.ParamByName('id').ParamType := ptOutput;
      Query.ExecSQL;
      IdProducto := Query.Params.ParamByName('id').AsInteger;
      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Producto registrado').AddPair('id_producto', TJSONNumber.Create(IdProducto)), True);
      AResponse.StatusCode := 200;
    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      AResponse.RaiseError(500, 'Error interno: ', E.Message);
      Exit;
    end;
  end;
end;

procedure TProductosResource.PutProducto(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
  Query: TFDQuery;
  JSON: TJSONObject;
  IdCaficultor, IdProducto: Integer;
  TipoProducto, NumeroProducto: string;
  Saldo: Double;
begin
  LItem := ARequest.Params.Values['item'];
  if not TryStrToInt(LItem, IdProducto) then
  begin
    AResponse.RaiseBadRequest('ID de producto inválido');
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
  IdCaficultor := JSON.GetValue<Integer>('id_caficultor', 0);
  TipoProducto := JSON.GetValue<string>('tipo_producto', '');
  NumeroProducto := JSON.GetValue<string>('numero_producto', '');
  Saldo := JSON.GetValue<Double>('saldo', 0.0);
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TFDConnection.Create(nil);
    Query.Connection.Params.DriverID := 'Ora';
    Query.Connection.Params.Database := 'XE';
    Query.Connection.Params.UserName := 'system';
    Query.Connection.Params.Password := 'admin';
    Query.SQL.Text := 'UPDATE productos SET id_caficultor = :id_caficultor, tipo_producto = :tipo_producto, numero_producto = :numero_producto, saldo = :saldo WHERE id_producto = :id';
    Query.Params.ParamByName('id_caficultor').AsInteger := IdCaficultor;
    Query.Params.ParamByName('tipo_producto').AsString := TipoProducto;
    Query.Params.ParamByName('numero_producto').AsString := NumeroProducto;
    Query.Params.ParamByName('saldo').AsFloat := Saldo;
    Query.Params.ParamByName('id').AsInteger := IdProducto;
    Query.ExecSQL;
    if Query.RowsAffected = 0 then
      AResponse.RaiseNotFound('Producto no encontrado')
    else
      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Producto actualizado'), True);
    AResponse.StatusCode := 200;
  finally
    Query.Free;
    JSON.Free;
  end;
end;

procedure TProductosResource.DeleteProducto(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
var
  LItem: string;
  Query: TFDQuery;
  IdProducto: Integer;
begin
  LItem := ARequest.Params.Values['item'];
  if not TryStrToInt(LItem, IdProducto) then
  begin
    AResponse.RaiseBadRequest('ID de producto inválido');
    Exit;
  end;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := TFDConnection.Create(nil);
    Query.Connection.Params.DriverID := 'Ora';
    Query.Connection.Params.Database := 'XE';
    Query.Connection.Params.UserName := 'system';
    Query.Connection.Params.Password := 'admin';
    Query.SQL.Text := 'DELETE FROM productos WHERE id_producto = :id';
    Query.Params.ParamByName('id').AsInteger := IdProducto;
    Query.ExecSQL;
    if Query.RowsAffected = 0 then
      AResponse.RaiseNotFound('Producto no encontrado')
    else
      AResponse.Body.SetValue(TJSONObject.Create.AddPair('mensaje', 'Producto eliminado'), True);
    AResponse.StatusCode := 200;
  finally
    Query.Free;
  end;
end;

procedure Register;
begin
  RegisterResource(TypeInfo(TProductosResource));
end;

initialization
  Register;
end.
