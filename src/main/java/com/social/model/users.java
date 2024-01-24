package com.social.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;

import javax.persistence.*;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor

@Entity
@Table(name = "users", schema = "public")

public class users {
    @Id
    @Column
    private UUID userId;

    @Column
    private String fullName;

    @Column
    private String userName;

    @Column
    private String email;

    @Column
    private String description;

    @Column
    @Transient
    private String password;

    @JsonIgnore
    @Column
    private String passwordHash;

    @JsonIgnore
    @Column
    private boolean enabled = false;

    @JsonIgnore
    @Column
    private boolean locked = false;

    @Column
    private Boolean admin;

    @Column
    Date dateOfBirth;

    @Column
    private String profilePicUrl;

    @Column
    private String coverPicUrl;

    @CreatedDate
    @Column
    Date createdAt;

//    @Transient
//    AuthResponse tokens;

//    @JsonIgnore
//    @Override
//    public UUID getId() {
//        return userId;
//    }
//
//    @JsonIgnore
//    @Override
//    public boolean isNew() {
//        if (getId()==null) setUserId(UUID.randomUUID());
//        if (createdAt == null) setCreatedAt(new Date());
//        return getId()==null;
//    }
//
//    @JsonIgnore
//    @Override
//    public boolean equals(Object o){ return EqualsBuilder.reflectionEquals(this,o);}




}
