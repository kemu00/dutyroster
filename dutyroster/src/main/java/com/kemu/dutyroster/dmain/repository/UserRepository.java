package com.kemu.dutyroster.dmain.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.kemu.dutyroster.dmain.model.entity.Users;

public interface UserRepository extends JpaRepository<Users, Long> {
}