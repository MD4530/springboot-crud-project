package com.atiq.crudproject.controller;

import com.atiq.crudproject.exception.ResourceNotFoundException;
import com.atiq.crudproject.model.Crud;
import com.atiq.crudproject.repository.CrudRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/students")
public class CrudController {
    @Autowired
    CrudRepository crudRepository;

    @GetMapping
    public List<Crud> getAllStudents(){
        return crudRepository.findAll();
    }

    @PostMapping
    public Crud insertStudent(@RequestBody Crud crud){
        return crudRepository.save(crud);
    }

    //get students by the id
    @GetMapping("{id}")
    public ResponseEntity<Crud> getStudentById(@PathVariable  String id){

        Crud crud =crudRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student id is not existis: "+id));

        return  ResponseEntity.ok(crud);
    }

    @PutMapping("{id}")
    public  ResponseEntity<Crud> updateStudentInfo(@PathVariable String id, @RequestBody Crud crud){
        Crud updateStudentInfo =crudRepository.findById(id)
                                .orElseThrow(() -> new ResourceNotFoundException("Student id is not existis: "+id));

        updateStudentInfo.setLName(crud.getLName());
        updateStudentInfo.setSName(crud.getSName());

        crudRepository.save(updateStudentInfo);


        return ResponseEntity.ok(updateStudentInfo);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<HttpStatus> deleteStudentByID(@PathVariable String id){
        Crud crud =crudRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Student id is not existis: "+id));
        crudRepository.delete(crud);

        return new ResponseEntity<> (HttpStatus.NO_CONTENT);

    }
    
    public void check(){
        int a;
    }

}
