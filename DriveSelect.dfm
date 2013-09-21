object Form2: TForm2
  Left = 319
  Top = 192
  BorderStyle = bsToolWindow
  Caption = 'Select Disk Drive'
  ClientHeight = 192
  ClientWidth = 156
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 139
    Height = 141
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 40
    Top = 155
    Width = 75
    Height = 25
    Caption = 'Select'
    TabOrder = 1
    OnClick = Button1Click
  end
end
