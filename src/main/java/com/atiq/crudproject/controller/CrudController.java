package com.atiq.crudproject.controller;

import lombok.extern.slf4j.Slf4j;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Controller
public class CrudController {
    @GetMapping("/testPoint")
    public ResponseEntity<String> getPointTest(){
        log.info(HttpStatus.OK.toString() + " : test point");
        return new ResponseEntity<>("Hello World!", HttpStatus.OK);
    }

//    @GetMapping("{fName}")
//    public List<Student> useCustom(@PathVariable String fName){
//        return studentService.getStudentByFirstName(fName);
//    }
//
//
//    // last name query need to work
//    @GetMapping("{lName}")
//    public List<Student> getStudentByLastName(@PathVariable String lName){
//        return studentService.findbylastNames(lName);
//    }
//
//
//    @PostMapping
//    public ResponseEntity<Student> addsS (@RequestBody Student student){
//        UUID s =UUID.randomUUID();
//        Student c= studentService.createStudent(new Student(s, student.getFName(), student.getLName()));
//        return ResponseEntity.ok(c);
//    }



//    @GetMapping
//    public List<Crud> serachByName(@)



//
//    @Autowired
//    StudentRepository studentRepository;
//
//    @GetMapping
//    public List<Crud> getAllStudents(){
//        return studentRepository.findAll();
//    }
//
//    @PostMapping
//    public Crud insertStudent(@RequestBody Crud crud){
//        return studentRepository.save(crud);
//    }
//
//    //get students by the id
//    @GetMapping("{id}")
//    public ResponseEntity<Crud> getStudentById(@PathVariable UUID id){
//
//        Crud crud = studentRepository.findById(id)
//                .orElseThrow(() -> new ResourceNotFoundException("Student id is not existis: "+id));
//
//        return  ResponseEntity.ok(crud);
//    }
//
//    @PutMapping("{id}")
//    public  ResponseEntity<Crud> updateStudentInfo(@PathVariable UUID id, @RequestBody Crud crud){
//        Crud updateStudentInfo = studentRepository.findById(id)
//                                .orElseThrow(() -> new ResourceNotFoundException("Student id is not existis: "+id));
//
//        updateStudentInfo.setLName(crud.getLName());
//        updateStudentInfo.setFName(crud.getFName());
//
//        studentRepository.save(updateStudentInfo);
//
//
//        return ResponseEntity.ok(updateStudentInfo);
//    }
//
//    @DeleteMapping("{id}")
//    public ResponseEntity<HttpStatus> deleteStudentByID(@PathVariable UUID id){
//        Crud crud = studentRepository.findById(id)
//                .orElseThrow(() -> new ResourceNotFoundException("Student id is not existis: "+id));
//        studentRepository.delete(crud);
//
//        return new ResponseEntity<> (HttpStatus.NO_CONTENT);
//
//    }



}
