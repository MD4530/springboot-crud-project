package com.atiq.crudproject.repository;


import com.atiq.crudproject.model.TeacherStudent;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface StudentTeacherRepo extends JpaRepository<TeacherStudent, UUID> {
}
