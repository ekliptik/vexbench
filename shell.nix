# Copyright HighTec EDV-Systeme GmbH
# SPDX-License-Identifier: MIT

{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ sbt verilator zlib file ];
}