import * as vscode from 'vscode';
// import { WasmContext, Memory } from '@vscode/wasm-component-model';

// this exposes the vscode library globally so we can access it in the Dart runtime
// @ts-ignore any
globalThis.vscode = vscode;
// // @ts-ignore any
// globalThis.WasmContext = WasmContext;
// // @ts-ignore any
// globalThis.Memory = Memory;
// // @ts-ignore any
// globalThis.WebAssembly = WebAssembly_;

