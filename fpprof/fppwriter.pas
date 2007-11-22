unit FPPWriter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DOM, XMLWrite, XMLRead;
  
type

  { TFPPWriter }

  TFPPWriter = class(TObject)
  private
    XMLDoc: TXMLDocument;
    Node: TDomNode;
  public
    constructor Create; overload;
    constructor Create(Reload: boolean); overload;

    destructor Destroy; override;
    
    procedure AddTrace(position, time, func, source, line: string);
    procedure AddIgnoredFile(const AFileName: string);
    procedure CreateIgnored;
    procedure CreateTraceLog;
    procedure Save;
  end;

implementation

{ TFPPWriter }

constructor TFPPWriter.Create(Reload: boolean);
begin
  if Reload then
    ReadXMLFile(XMLDoc, 'fpprof.xml');

  if not Reload or not Assigned(XMLDoc) then
  begin
    XMLDoc := TXMLDocument.Create;
    XMLDoc.AppendChild(XMLDoc.CreateElement('profilelog'));
  end;
  Node := XMLDoc.FindNode('profilelog');
end;

constructor TFPPWriter.Create;
begin
  Create(False);
end;

destructor TFPPWriter.Destroy;
begin
  XMLDoc.Free;
  inherited Destroy;
end;

procedure TFPPWriter.Save;
begin
  WriteXMLFile(XMLDoc, 'fpprof.xml');
end;

procedure TFPPWriter.CreateTraceLog;
begin
  Node := XMLDoc.DocumentElement;

  //create the tracelog element
  Node.AppendChild(XMLDoc.CreateElement('tracelog'));
  Node := Node.FindNode('tracelog');
end;

procedure TFPPWriter.CreateIgnored;
begin
  Node := XMLDoc.DocumentElement;

  //create the ignored element
  Node.AppendChild(XMLDoc.CreateElement('ignored'));
  Node := Node.FindNode('ignored');
end;

procedure TFPPWriter.AddTrace(position, time, func, source, line: string);
var
  Element: TDomElement;
begin
  Element := XMLDoc.CreateElement('trace');
  with Element do
  begin
    AttribStrings['pos'] := position;
    AttribStrings['time'] := time;
    AttribStrings['func'] := func;
    AttribStrings['source'] := source;
    AttribStrings['line'] := line;
  end;
  Node.AppendChild(Element);
end;

procedure TFPPWriter.AddIgnoredFile(const AFileName: string);
var
  Element: TDomElement;
begin
  Element := XMLDoc.CreateElement('file');
  Element.AttribStrings['name'] := AFileName;
  Node.AppendChild(Element);
end;

end.
