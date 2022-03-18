unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, DBCtrls, DBGrids, Dbf, DB;

type

  { TForm1 }

  TForm1 = class(TForm)
    BBexit: TBitBtn;
    BBdelete: TBitBtn;
    BBimport: TBitBtn;
    BBview: TBitBtn;
    BBok: TBitBtn;
    BBcancel: TBitBtn;
    DBEyear: TDBEdit;
    DBEcode: TDBEdit;
    DBEsport: TDBEdit;
    DBEabbr: TDBEdit;
    DBEk1: TDBEdit;
    DBEk2: TDBEdit;
    DBEk3: TDBEdit;
    DBEtotal: TDBEdit;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    dsfed: TDatasource;
    dsk1: TDatasource;
    dsk2: TDatasource;
    dsk3: TDatasource;
    Dbfed: TDbf;
    Dbk1: TDbf;
    Dbk2: TDbf;
    Dbk3: TDbf;
    FedGrid: TDBGrid;
    GroupKall: TGroupBox;
    GroupFed: TGroupBox;
    ControlFed: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ImportDir: TSelectDirectoryDialog;
    procedure BBcancelClick(Sender: TObject);
    procedure BBexitClick(Sender: TObject);
    procedure BBimportClick(Sender: TObject);
    procedure BBokClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1;
  inpdir, inpfile: string;
  src,dst:file of byte;
  b:byte;

implementation

{ TForm1 }

procedure TForm1.BBexitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.BBcancelClick(Sender: TObject);
begin
  DBfed.Delete;
  DBfed.PackTable;
  DBEyear.ReadOnly := True;
  DBEcode.ReadOnly := True;
  BBok.Enabled := False;
  BBok.Visible := False;
  BBcancel.Enabled := False;
  BBcancel.Visible := False;
  DBEyear.Color := clLime;
  DBEcode.Color := clLime;
  DBEyear.Enabled := False;
  DBEcode.Enabled := False;
  BBimport.Enabled := True;
end;

procedure TForm1.BBimportClick(Sender: TObject);
begin
  DBfed.Append;
  DBEyear.Enabled := True;
  DBEcode.Enabled := True;
  DBEyear.ReadOnly := False;
  DBEyear.SetFocus;
  DBEcode.ReadOnly := False;
  BBok.Enabled := True;
  BBok.Visible := True;
  BBcancel.Enabled := True;
  BBcancel.Visible := True;
  DBEyear.Color := clWhite;
  DBEcode.Color := clWhite;
  BBimport.Enabled := false;
end;

procedure TForm1.BBokClick(Sender: TObject);
begin
  ImportDir.Execute;
  DBEyear.ReadOnly := True;
  DBEcode.ReadOnly := True;
  DBEyear.Color := clLime;
  DBEcode.Color := clLime;
  DBEyear.Enabled := False;
  DBEcode.Enabled := False;
  BBok.Enabled := False;
  BBok.Visible := False;
  BBcancel.Enabled := False;
  BBcancel.Visible := False;
  inpdir := ImportDir.FileName+'\';
  inpfile := DBEcode.Text+'-'+DBEyear.Text+'_';
  AssignFile(src,inpdir+inpfile+'1.dbf'); // источник
  AssignFile(dst,DBfed.AbsolutePath+inpfile+'1.dbf'); // приемник
  reset(src);
  rewrite(dst);
  while not(eof(src)) do
  begin
    read(src,b);
    write(dst,b);
  end;
  CloseFile(src);
  CloseFile(dst);
  AssignFile(src,inpdir+inpfile+'2.dbf'); // источник
  AssignFile(dst,DBfed.AbsolutePath+inpfile+'2.dbf'); // приемник
  reset(src);
  rewrite(dst);
  while not(eof(src)) do
  begin
    read(src,b);
    write(dst,b);
  end;
  CloseFile(src);
  CloseFile(dst);
  AssignFile(src,inpdir+inpfile+'3.dbf'); // источник
  AssignFile(dst,DBfed.AbsolutePath+inpfile+'3.dbf'); // приемник
  reset(src);
  rewrite(dst);
  while not(eof(src)) do
  begin
    read(src,b);
    write(dst,b);
  end;
  CloseFile(src);
  CloseFile(dst);
  DBk1.FilePath := 'data/';
  DBk2.FilePath := 'data/';
  DBk3.FilePath := 'data/';
  DBk1.TableName := inpfile+'1.dbf';
  DBk2.TableName := inpfile+'2.dbf';
  DBk3.TableName := inpfile+'3.dbf';
  DBk1.Exclusive := true;
  DBk2.Exclusive := true;
  DBk3.Exclusive := true;
  DBk1.Active := True;
  DBk2.Active := True;
  DBk3.Active := True;
  GroupKall.Visible := True;
  GroupFed.Visible := False;;
  DBEabbr.Text := DBk1.FieldValues['FEDERATION'];
  DBEsport.Text := DBk1.FieldValues['SPORT'];
  BBimport.Enabled := True;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  DBfed.Active := false;
  DBfed.FilePath := 'data/';
  DBfed.TableName := 'federacii.dbf';
  DBfed.Exclusive := true;
  DBfed.Active := true;
end;


initialization
  {$I unit1.lrs}

end.

