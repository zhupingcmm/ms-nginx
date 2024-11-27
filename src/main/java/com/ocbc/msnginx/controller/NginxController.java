package com.ocbc.msnginx.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/nginx")
public class NginxController {
    @Autowired
    private Environment environment;
    @GetMapping("/test")
    public String getServePort() {
        return environment.getProperty("local.server.port");
    }
}
