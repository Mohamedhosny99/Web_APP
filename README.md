# SMS Management System

A web-based application for managing SMS operations using Twilio, featuring distinct roles for Customers and Administrators. Built with Java Servlets, Rust APIs, PostgreSQL, and a front-end using HTML/CSS.

## Overview

This project provides a platform where:
- **Customers** can send SMS, view their SMS history, and manage their profiles using their Twilio accounts.
- **Administrators** can manage customers and monitor SMS usage statistics.
- Features include user authentication, SMS validation, and bonus inbound SMS support.

## Features

### General
- Two user roles: **Customer** and **Administrator**.
- Secure username/password authentication with role-based homepage redirection.
- SMS details include From, To, and Body.

### Administrator Capabilities
- Manage customers: View, add, edit, delete, and list all customers.
- View statistics on SMS sent per customer.

### Customer Capabilities
- Sign up with profile data (name, birthday, phone number, job, email, address, Twilio SID/Token/SenderID).
- Validate phone number (MSISDN) via Twilio SMS with a random short code.
- Log in using validated account and short code verification.
- Send SMS using Twilio credentials (From, To, Body).
- View, search (by From, To, or date range), and delete SMS history.
- Edit profile and log out to switch accounts.

### Bonus Features
- Inbound SMS support via Twilio Callback URL, stored in the customer database.
- List inbound SMS received on the customer’s Twilio account.

## Prerequisites
- Java Development Kit (JDK)
- Rust (for Rust APIs)
- PostgreSQL
- Twilio account (with SID, Token, and SenderID)
- Web server (e.g., Apache Tomcat) for Servlets


