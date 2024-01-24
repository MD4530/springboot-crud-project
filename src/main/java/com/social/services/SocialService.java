package com.social.services;

import com.fasterxml.jackson.databind.util.JSONPObject;
import com.social.repository.UsersRepository;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class SocialService {
    @Autowired
    UsersRepository usersRepository;

    public  String TestServiceClass(){
        return "Service class is working";
    }

    public JSONObject singUpDataValidation(JSONObject inputData){

        if (!inputData.has("username") || !inputData.has("pass") || !inputData.has("email")){

        }

        return  inputData;
    }
}
