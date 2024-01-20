package com.atiq.crudproject.repository;


import com.atiq.crudproject.model.Teacher;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface TeacherRepository extends JpaRepository<Teacher, UUID> {

}
