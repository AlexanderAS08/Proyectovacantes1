import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class MainService {

  constructor(
    private http: HttpClient
  ) { }

  uri: string = "http://localhost:9000/api";

  getEntityBy(entity: string, filter: any = {}) {
    return this.http.post(`${this.uri}/${entity}/by`, {filter: filter});
  }

  saveEntity(entity: string, body: any) {
    return this.http.post(`${this.uri}/${entity}/create`, body);
  }

  updateEntity(entity: string, body: any) {
    return this.http.put(`${this.uri}/${entity}/update`, body);
  }

  uploadDocument(formData: FormData) {
    return this.http.post(`${this.uri}/upload-document`, formData);
  }
}
