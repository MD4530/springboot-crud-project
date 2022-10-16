package com.atiq.crudproject.repository;

import com.atiq.crudproject.model.Crud;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

public interface CrudRepository extends JpaRepository<Crud, String> {
//    all the crud method
}
