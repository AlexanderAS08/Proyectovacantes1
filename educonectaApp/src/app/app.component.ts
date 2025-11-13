import { CommonModule } from '@angular/common';
import { Component, ElementRef, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { MainService } from './services/main.service';
import { FormsModule } from '@angular/forms';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-root',
  imports: [
    CommonModule,
    FormsModule,
    RouterOutlet
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit {

  constructor(
    private Main: MainService,
    private ElementRef: ElementRef
  ) {

  }

  filter: any = {};

  schools: any[] = [];
  schoolSelected: any;
  gradeSelected: any;
  gradesInSchools: any[] = [];
  newEnrollment: any;

  genders: any[] = [
    {
      id: true,
      name: "Varon",
      image: "male.png"
    },
    {
      id: false,
      name: "Mujer",
      image: "female.png"
    },
  ];

  // FUNCIONES NECESARIAS


  generateRandomText(longitud: number) {
    const caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let resultado = '';
    
    for (let i = 0; i < longitud; i++) {
        const indiceAleatorio = Math.floor(Math.random() * caracteres.length);
        resultado += caracteres[indiceAleatorio];
    }
    
    return resultado;
  }

  ngOnInit(): void {
    this.newEnrollment = undefined;
    this.schoolSelected = undefined;
    this.gradeSelected = undefined;
    this.getSchools();
    this.getGradesInSchools();
  }

  async getSchools() {
    let result: any = await this.Main.getEntityBy("schools", this.filter).toPromise();
    console.log(result);
    this.schools = result.data;
  }

  async getGradesInSchools() {
    let result: any = await this.Main.getEntityBy("grades_in_schools").toPromise();
    this.gradesInSchools = result.data;
    console.log(this.gradesInSchools);
  }

  selectSchool(school: any) {
    this.schoolSelected = school;
    this.schoolSelected.grades = JSON.parse(JSON.stringify(this.gradesInSchools.filter((g) => g.school_id == this.schoolSelected.id)));
    console.log(this.schoolSelected);
  }

  selectGrade(grade: any) {
    if (grade.vacancies === 0) {
      Swal.fire({
        icon: "warning",
        text: `No puedes matricularte ya que el ${grade.grade_name} no tiene vacantes disponibles`
      });
      return;
    }
    this.gradeSelected = grade;
    this.newEnrollment = {
      parents: [], 
      documents: []
    };
  }

  addParent(parent?: any) {
    if (parent) {
      let index = this.newEnrollment.parents.indexOf(parent);
      console.log(index);
      this.newEnrollment.parents.splice(index, 1);
    } else {
      this.newEnrollment.parents.push({});
    }
  }

  addDocument(document?: any) {
    if (document) {
      let index = this.newEnrollment.documents.indexOf(document);
      this.newEnrollment.documents.splice(index, 1);
    } else {
      this.newEnrollment.documents.push({});
    }
  }

  selectGender(gender: boolean) {
    this.newEnrollment.gender = gender;
  }

  resetSelect() {
    this.schoolSelected = undefined;
    this.gradeSelected = undefined;
    this.newEnrollment = undefined;
  }  

  onFileSelected(event: any, document: any) {
    const file: File = event.target.files[0];
    
    if (file) {
      document.info = {
        name: file.name,
        size: file.size,
        type: file.type,
        extension: this.getFileExtension(file.name),
        lastModified: file.lastModified
      };
      console.log('File Info:', document);
    }
  }

  soloNumeros(e: any) {
    if (e.key === '.') {

    } else {
      if (isNaN(parseInt(e.key))) e.preventDefault();
    }
  }


  private getFileExtension(filename: string): string {
    return filename.slice((filename.lastIndexOf('.') - 1 >>> 0) + 2);
  }

  async saveEnrollment() {
    console.log(this.newEnrollment);
    // Creamos la persona

    let newPerson: any[] = [
      this.newEnrollment.code,
      this.newEnrollment.father_last_name,
      this.newEnrollment.mother_last_name,
      this.newEnrollment.names,
      this.newEnrollment.gender,
      this.newEnrollment.birth_date,
    ];
    // CREAMOS PERSONA
    let resultPerson: any = await this.Main.saveEntity("people", {news: newPerson}).toPromise();

    let personCreated: any = resultPerson.data;

    // Creamos los parientes como personas;
    let parentsCreateds: any[] = [];
    for (let index = 0; index < this.newEnrollment.parents.length; index++) {
      const parent: any = this.newEnrollment.parents[index];
      let newParentOfPerson: any[] = [
        parent.code,
        parent.father_last_name,
        parent.mother_last_name,
        parent.names,
        parent.relation == "padre" ? true : false,
        null,
      ];
  
      let resultPersonOfParent: any = await this.Main.saveEntity("people", {news: newParentOfPerson}).toPromise();
      let parentCreated: any = resultPersonOfParent.data;
      parentCreated.relation = parent.relation;
      parentsCreateds.push(parentCreated);
    }

    // CREANDO PARIENTES
    for (let index = 0; index < parentsCreateds.length; index++) {
      const parent = parentsCreateds[index];
      let newParent: any[] = [
        personCreated.id,
        parent.id,
        parent.relation
      ];

      let resultParent: any = await this.Main.saveEntity("parents", {news: newParent}).toPromise();
    }

    let newStudent: any[] = [
      this.newEnrollment.code,
      this.generateRandomText(6),
      personCreated.id
    ];
    // CREANDO ESTUDIANTE
    let resultStudent: any = await this.Main.saveEntity("students", {news: newStudent}).toPromise();
    let studentCreated: any = resultStudent.data;

    let newEnroll: any[] = [
      this.schoolSelected.id,
      studentCreated.id,
      this.gradeSelected.grade_id
    ];
    // CREANDO MATRICULA
    let resultEnroll: any = await this.Main.saveEntity("enrollments", {news: newEnroll}).toPromise();
    let enrollmentCreated = resultEnroll.data;

    let documentsCreateds: any[] = [];
    for (let index = 0; index < this.newEnrollment.documents.length; index++) {
      let file = this.ElementRef.nativeElement.querySelector(`#document-${index}`);
      console.log(file);
      const formData = new FormData();
      formData.append('file', file.files.item(0));

      let resultUpload: any = await this.Main.uploadDocument(formData).toPromise();
      documentsCreateds.push(resultUpload);
    }

    for (let index = 0; index < documentsCreateds.length; index++) {
      const document = documentsCreateds[index];
      let newDocument: any[] = [
        enrollmentCreated.id,
        studentCreated.id,
        document.path
      ];

      let resultDocument: any = await this.Main.saveEntity("documents", {news: newDocument}).toPromise();
    }

    let updateGradeInSchool: any[] = [
      this.gradeSelected.id,
      this.gradeSelected.grade_id,
      this.gradeSelected.school_id,
      this.gradeSelected.vacancies - 1
    ];

    let resultGradeInSchool: any = await this.Main.updateEntity("grades_in_schools", {updateds: updateGradeInSchool}).toPromise();

    Swal.fire({
      icon: "success",
      text: "Se registro correctamente la Matricula",
    });
    this.ngOnInit();


    






  }

}
