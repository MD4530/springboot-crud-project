package com.atiq.crudproject.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;

import javax.persistence.Id;
import javax.persistence.Table;


 @Getter
 @Setter
 @NoArgsConstructor
 @AllArgsConstructor

@Entity
@Table(name = "students")

public class Crud {

    @Id
    private String id;

     @Column(name="fname")
    private String sName;

    @Column(name="lname")
    private String lName;

}
