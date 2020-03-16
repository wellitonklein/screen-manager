unit ScreenManager;

interface

uses
  ScreenManager.Interf,
  FMX.Layouts,
  System.Classes,
  System.Generics.Collections,
  FMX.Forms;

type
  TScreenManager = class(TInterfacedObject, IScreenManager, IScreenManagerMethod)
  private
    FForms : TDictionary<TComponentClass, TForm>;
    function clearLayout(const layoutMain: TLayout): IScreenManagerMethod;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IScreenManager;

    // IScreenManager
    function method: IScreenManagerMethod;

    // IScreenManagerMethod
    procedure openForm(const layoutMain: TLayout; const aFormClass: TComponentClass);
    function &EndMethod: IScreenManager;
  end;

implementation

uses
  System.SysUtils;

{ TScreenManager }

function TScreenManager.clearLayout(
  const layoutMain: TLayout): IScreenManagerMethod;
begin
  Result := Self;

  if (Assigned(layoutMain)) then
  begin
    // As long as there are objects in LayoutMain, it will be excluding one by one
    layoutMain.BeginUpdate;

    while (layoutMain.ChildrenCount > 0) do
    begin
      layoutMain.RemoveObject(layoutMain.Children[0]);
    end;

    layoutMain.EndUpdate;
  end;
end;

constructor TScreenManager.Create;
begin
  FForms := TDictionary<TComponentClass, TForm>.Create;
end;

destructor TScreenManager.Destroy;
begin
  FreeAndNil(FForms);
  inherited;
end;

function TScreenManager.EndMethod: IScreenManager;
begin
  Result := Self;
end;

function TScreenManager.method: IScreenManagerMethod;
begin
  Result := Self;
end;

class function TScreenManager.New: IScreenManager;
begin
  Result := Self.Create;
end;

procedure TScreenManager.openForm(const layoutMain: TLayout;
  const aFormClass: TComponentClass);
var
  LComponent: TComponent;
  LForm: TForm;
begin
  // Clean the layout before opening the new screen inside it
  clearLayout(layoutMain);

  // Ensures that every time he opens the screen it will be a new
  if (Assigned(LForm)) then
  begin
    LForm.DisposeOf;
  end;

  // Creates the form to be able to search for the objects
  Application.CreateForm(aFormClass, LForm);
  lComponent := LForm.FindComponent('LayoutMain');

  // Adds all LayoutMain objects to the main screen's LayoutMain
  if (Assigned(lComponent)) then
  begin
    layoutMain.AddObject(TLayout(lComponent));
  end;

  // Control of the creation of the screens to not close an overlap
  if (not FForms.TryGetValue(aFormClass, LForm)) then
  begin
    FForms.AddOrSetValue(aFormClass, LForm);
  end;
end;

end.
