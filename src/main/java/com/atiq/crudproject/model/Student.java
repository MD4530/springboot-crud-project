package com.atiq.crudproject.model;

import lombok.*;

import javax.persistence.*;


import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

@Entity
@Table(name = "student")

public class Student {
    @Id
    @Column(name="s_id")
    private UUID s_id;

     @Column(name="fname")
     private String fName;

     @Column(name="lname")
     private String lName;

     @OneToMany(
             mappedBy = "student",
             cascade = CascadeType.ALL,
             orphanRemoval = true
     )
     private List<TeacherStudent> teacherStudents = new ArrayList<>();

    public Student(UUID s_id, String fName, String lName) {
        this.s_id = s_id;
        this.fName = fName;
        this.lName = lName;
    }

//    public Student(){}
//
//    public Student(String fName, String lName) {
//        this.fName = fName;
//        this.lName = lName;
//    }

//    @Override
//    public  boolean equals(Objects o){
//         if (this == o) return true
//
//         if (o == null || getClass() != o.getClass()) return  false;
//
//         Student s = (Student) o;
//         return Objects.equals(fName, s.fName) && Objects.equals(lName, s.lName);
//    }

//    @Override
//    public  int hashCode(){
//         return Objects.hash(fName, lName);
//    }

    //    public  Crud(String fName, String lName){
//        this.fName=fName;
//        this.lName=lName;
//    }

//    public Crud( UUID id,
//                 String fName,
//                 String lName) {
//        this.id = id;
//        this.fName = fName;
//        this.lName = lName;
//    }


}
