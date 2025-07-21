# Uhome Feature Guide

This document provides an overview of the `home` feature.

## Overview

The Uhome feature provides functionality to manage and display LUhome data.

## Architecture

The feature follows Clean Architecture principles with the following layers:

- **Data Layer**: Handles data sources, models, and repository implementations
- **Domain Layer**: Contains business entities, repository interfaces, and use cases
- **Presentation Layer**: User interface components and state management

## Components

### Data Layer

- `home_model.dart`: Data model representing a LUhome
- `home_remote_datasource.dart`: Handles API calls for LUhome data
- `home_local_datasource.dart`: Handles local storage for LUhome data
- `home_repository_impl.dart`: Implements the repository interface

### Domain Layer

- `home_entity.dart`: Core business entity
- `home_repository.dart`: Repository interface defining data operations
- `get_all_homes.dart`: Use case to retrieve all LUhomes
- `get_home_by_id.dart`: Use case to retrieve a specific LUhome

### Presentation Layer

- `home_list_screen.dart`: Screen to display a list of LUhomes
- `home_detail_screen.dart`: Screen to display details of a specific LUhome
- `home_list_item.dart`: Widget to display a single LUhome in a list

### Providers

- `home_providers.dart`: Riverpod providers for the feature
- `home_ui_providers.dart`: UI-specific state providers

## Usage

### Adding a Uhome

1. Navigate to the Uhome List Screen
2. Tap the + button
3. Fill in the required fields
4. Submit the form

### Viewing Uhome Details

1. Navigate to the Uhome List Screen
2. Tap on a Uhome item to view its details

## Implementation Notes

- The feature uses Riverpod for state management
- Error handling follows the Either pattern from dartz
- Repository pattern is used to abstract data sources
