package com.osasea.jenkinscicd.repository;


import com.osasea.jenkinscicd.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByUsername(String username);
}