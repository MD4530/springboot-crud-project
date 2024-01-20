package com.atiq.crudproject.model;

import com.atiq.crudproject.repository.TeacherRepository;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

@Entity
@Table(name = "teacher")
public class Teacher {
    @Id
    @Column(name ="te_id")
    private UUID te_id;


    @Column(name="t_name")
    private String name;

    @OneToMany(
            mappedBy = "teacher",
            cascade = CascadeType.ALL,
            orphanRemoval = true
    )
    private List<TeacherStudent> teacherStudents = new ArrayList<>();

    public Teacher(UUID te_id, String name) {
        this.te_id = te_id;
        this.name = name;
    }

}
