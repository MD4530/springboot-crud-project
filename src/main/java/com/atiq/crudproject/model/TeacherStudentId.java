package com.atiq.crudproject.model;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;
import java.util.UUID;

@Embeddable
public class TeacherStudentId implements Serializable {
    @Column(name="te_id")
    private UUID te_id;

    @Column(name="s_id")
    private  UUID s_id;

//    public TeacherStudentId() {
//
//    }
//
    public TeacherStudentId(UUID s_id, UUID te_id) {
        this.s_id = s_id;
        this.te_id = te_id;
    }

    public TeacherStudentId() {

    }

//    @Override
//    public boolean equals(Objects o){
//        if (this === o) return  true;
//
//        if (o== null || getClass() != o.getClass()) return  false;
//
//        TeacherStudentId that = (TeacherStudentId) o;
//        return Objects.equals(s_id, that.s_id) && Objects.equals(te_id, that.te_id);
//
//    }

//    @Override
//    public  int hashCode(){
//        return Objects.hash(te_id, s_id);
//    }
}
