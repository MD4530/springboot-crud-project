package com.atiq.crudproject.repository;

import com.atiq.crudproject.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;


import java.util.Collection;
import java.util.UUID;


public interface StudentRepository extends JpaRepository<Student, UUID >{
//    @Query("SELECT s.fName FROM Student s WHERE (:fname is null or s.fName = :fname) and (:lname is null"
//            + " or s.lName = :lname)")
//    List<Student> findStudentsByFNameAndLName(@Param("fname") String fName, @Param("lname") String lName);
//
//
//@Query ("SELECT new com.atiq.crudproject.services.Services_Attribute(t.te_id, t.name, s.s_id, s.lName) FROM Teacher t,Student s , TeacherStudent  st WHERE t.te_id = st.teacher.te_id AND  st.student.s_id =st.student.s_id")
//Collection<Services_Attribute> findStudentById();

//    @Query("select c.lName from  Crud c where c.lName =? 1")
//    List<Crud> findByLastName(String LastName);
//
//    @Query("select new com.atiq.crudproject.services.Services_Attribute(c.lName) from  Crud c")
//    List<Services_Attribute> findByLastName(String lName);




}
