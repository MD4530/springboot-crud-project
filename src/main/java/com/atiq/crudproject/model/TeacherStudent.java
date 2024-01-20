package com.atiq.crudproject.model;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "teacherStudent")
public class TeacherStudent {

    @EmbeddedId
    private TeacherStudentId teacherStudentId;

    @ManyToOne
    @JoinColumn(name= "s_id", insertable = false, updatable = false)
    private  Student student;

    @ManyToOne
    @JoinColumn(name= "te_id", insertable = false, updatable = false)
    private  Teacher teacher;


    @Column(name = "createDate")
    private LocalDate createDate;

    public TeacherStudent(Student student, Teacher teacher, LocalDate createDate) {
        this.teacher = teacher;
        this.student = student;
        System.out.println("student id "+student.getS_id());
        this.teacherStudentId = new TeacherStudentId(student.getS_id(), teacher.getTe_id());
        this.createDate =createDate;
    }

    public TeacherStudent() {

    }

//    public TeacherStudent(Student student, Teacher teacher, LocalDate createDate) {
//        this.student = student;
//        this.teacher = teacher;
//        this.createDate = createDate;
//    }
    //
//    public TeacherStudent() {
//    }

//    @Override
//    public boolean equals(Objects o){
//        if (this == 0) return true;
//
//    }

//    @Override
//    public  int hashCode(){
//        return Objects.hash(student, teacher);
//    }

//        this.teacherStudentId = new TeacherStudentId(student.getS_id(), teacher.getTe_id());

}
