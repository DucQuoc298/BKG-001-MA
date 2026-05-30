# BKG-001-MA — Luvista

> **Ngôn ngữ / Framework:** Dart · Flutter  
> **Phiên bản SDK:** Dart ^3.11.5  
> **Kiến trúc áp dụng:** Clean Architecture (Feature-first)

---

## Trạng Thái Hiện Tại

Project đang ở giai đoạn **khởi tạo ban đầu**. Hiện có:

| File / Thư mục | Trạng thái | Ghi chú |
|---|---|---|
| `lib/main.dart` | ✅ Có code | Chứa toàn bộ logic màn hình Login (chưa tách lớp) |
| `lib/app.dart` | ⬜ Rỗng | Chưa triển khai |
| `lib/core/` | ⬜ Rỗng | Chưa triển khai |
| `lib/features/` | ⬜ Rỗng | Chưa triển khai |
| `lib/shared/` | ⬜ Rỗng | Chưa triển khai |

> ⚠️ `main.dart` hiện vi phạm Clean Architecture — toàn bộ UI, state, và logic đang nằm trong 1 file. Cần tái cấu trúc.

---

## Kiến Trúc — Clean Architecture (Feature-first)

### Nguyên tắc cốt lõi

```
Presentation → Domain ← Data
```

- **Dependency Rule**: Các lớp bên ngoài phụ thuộc vào lớp bên trong, **không bao giờ ngược lại**.
- **Domain layer** là trung tâm, **không phụ thuộc** vào Flutter hay bất kỳ framework nào.
- Mỗi **feature** tự chứa đầy đủ 3 lớp của mình.

---

## Sơ Đồ Cấu Trúc Thư Mục

```
lib/
├── main.dart                        # Entry point — chỉ khởi tạo app
├── app.dart                         # MaterialApp, routing, theme, DI setup
│
├── core/                            # Hạ tầng dùng chung toàn app
│   ├── error/
│   │   ├── exceptions.dart          # Custom exceptions (ServerException, CacheException...)
│   │   └── failures.dart            # Failure sealed classes (ServerFailure, NetworkFailure...)
│   ├── network/
│   │   ├── network_info.dart        # Interface kiểm tra kết nối mạng
│   │   └── api_client.dart          # Dio/http client wrapper
│   ├── usecase/
│   │   └── usecase.dart             # Abstract UseCase<Type, Params> base class
│   ├── constants/
│   │   ├── app_constants.dart       # Hằng số toàn app (timeout, page size...)
│   │   └── api_endpoints.dart       # URL endpoints
│   └── utils/
│       ├── typedef.dart             # Type aliases (EitherFailureOr<T>...)
│       └── extensions.dart          # Extension methods
│
├── shared/                          # Widgets & services tái sử dụng qua nhiều feature
│   ├── widgets/
│   │   ├── app_button.dart          # Primary button component
│   │   ├── app_text_field.dart      # Styled text field component
│   │   └── loading_overlay.dart     # Loading indicator
│   ├── theme/
│   │   ├── app_theme.dart           # ThemeData configuration
│   │   ├── app_colors.dart          # Color palette (brand colors)
│   │   └── app_text_styles.dart     # Typography definitions
│   └── services/
│       └── storage_service.dart     # Local storage abstraction (SharedPrefs/Hive)
│
└── features/                        # Các tính năng của app
    │
    ├── auth/                        # ── FEATURE: Xác thực
    │   ├── domain/                  # Layer 1: DOMAIN (thuần Dart, 0 dependencies)
    │   │   ├── entities/
    │   │   │   └── user_entity.dart          # Business object User
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart      # Abstract interface repository
    │   │   └── usecases/
    │   │       ├── login_usecase.dart        # UC: Đăng nhập
    │   │       ├── logout_usecase.dart       # UC: Đăng xuất
    │   │       └── get_current_user_usecase.dart
    │   │
    │   ├── data/                    # Layer 2: DATA (implement domain interfaces)
    │   │   ├── models/
    │   │   │   └── user_model.dart           # UserModel extends UserEntity (JSON parsing)
    │   │   ├── datasources/
    │   │   │   ├── auth_remote_datasource.dart  # Gọi API
    │   │   │   └── auth_local_datasource.dart   # Cache token/user
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart    # Implement AuthRepository
    │   │
    │   └── presentation/            # Layer 3: PRESENTATION (Flutter widgets)
    │       ├── bloc/                # State management (BLoC/Cubit)
    │       │   ├── login_bloc.dart
    │       │   ├── login_event.dart
    │       │   └── login_state.dart
    │       ├── pages/
    │       │   ├── login_page.dart
    │       │   └── forgot_password_page.dart
    │       └── widgets/
    │           └── login_form.dart           # Form widget tách biệt
    │
    ├── home/                        # ── FEATURE: Trang chủ
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    │
    └── [feature_name]/              # ── Thêm feature mới theo cùng pattern
        ├── domain/
        ├── data/
        └── presentation/
```

---

## Chi Tiết Từng Layer

### 🟡 Domain Layer — "Trái tim" của ứng dụng

```dart
// core/usecase/usecase.dart
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
```

| Thành phần | Trách nhiệm |
|---|---|
| **Entities** | Business objects thuần Dart, không phụ thuộc framework |
| **Repositories (abstract)** | Interface định nghĩa contract với Data layer |
| **Use Cases** | Một business rule cụ thể, gọi repository |

> ℹ️ Domain layer **TUYỆT ĐỐI không** import bất kỳ package Flutter, Dio, hoặc framework nào.

---

### 🔵 Data Layer — Xử lý dữ liệu

```dart
// features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(params);
        await localDataSource.cacheUser(user);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
```

| Thành phần | Trách nhiệm |
|---|---|
| **Models** | Extend Entity, thêm `fromJson`/`toJson` |
| **Remote DataSource** | Gọi REST API / Firebase / GraphQL |
| **Local DataSource** | SharedPreferences / Hive / SQLite |
| **Repository Impl** | Kết hợp remote + local, xử lý lỗi |

---

### 🟢 Presentation Layer — Giao diện người dùng

```
Bloc/Cubit ← Pages ← Widgets
     ↓
  UseCase (Domain)
```

| Thành phần | Trách nhiệm |
|---|---|
| **BLoC / Cubit** | State management, gọi Use Cases |
| **Pages** | Màn hình đầy đủ, inject BLoC qua `BlocProvider` |
| **Widgets** | UI components nhỏ, tái sử dụng trong feature |

---

## Packages Dự Kiến Sử Dụng

| Package | Mục đích | Layer |
|---|---|---|
| `flutter_bloc` | State management | Presentation |
| `get_it` | Dependency Injection | App-wide |
| `dartz` | Functional types (`Either`) | Domain / Data |
| `dio` | HTTP client | Data (Remote) |
| `shared_preferences` | Local storage | Data (Local) |
| `go_router` | Navigation / Routing | Presentation |
| `equatable` | Value equality cho Entity/State | Domain / Presentation |
| `json_annotation` + `build_runner` | JSON serialization | Data |
| `mocktail` | Mocking trong tests | Test |

> ℹ️ Hiện tại `pubspec.yaml` chỉ có `cupertino_icons` và `flutter_lints`. Cần bổ sung các package trên.

---

## Quy Tắc Đặt Tên

| Loại | Convention | Ví dụ |
|---|---|---|
| Feature folder | `snake_case` | `auth/`, `home/`, `user_profile/` |
| Dart files | `snake_case` | `login_usecase.dart` |
| Classes | `PascalCase` | `LoginUseCase`, `UserEntity` |
| Use Cases | `[Action]UseCase` | `LoginUseCase`, `GetUserUseCase` |
| BLoC | `[Feature]Bloc` | `LoginBloc`, `HomeBloc` |
| Cubit | `[Feature]Cubit` | `ProfileCubit` |
| Repository interface | `[Feature]Repository` | `AuthRepository` |
| Repository impl | `[Feature]RepositoryImpl` | `AuthRepositoryImpl` |
| DataSource | `[Feature][Remote/Local]DataSource` | `AuthRemoteDataSource` |

---

## Checklist Triển Khai

- [ ] Tách `main.dart` — chỉ giữ `runApp()`
- [ ] Triển khai `app.dart` — MaterialApp, theme, router
- [ ] Thiết lập `core/error/` — Exceptions & Failures
- [ ] Thiết lập `core/usecase/usecase.dart` — Base UseCase
- [ ] Thiết lập `shared/theme/` — AppColors, AppTextStyles, AppTheme
- [ ] Thiết lập `shared/widgets/` — AppButton, AppTextField
- [ ] Triển khai feature `auth/domain/` — Entity, Repository (abstract), UseCases
- [ ] Triển khai feature `auth/data/` — Model, DataSources, RepositoryImpl
- [ ] Triển khai feature `auth/presentation/` — BLoC, LoginPage, widgets
- [ ] Cấu hình Dependency Injection với `get_it`
- [ ] Cấu hình routing với `go_router`
- [ ] Viết unit tests cho Domain + Data layers

---

## Hướng Dẫn Chạy Project

### Yêu cầu hệ thống

| Công cụ | Phiên bản tối thiểu |
|---|---|
| Flutter SDK | 3.x (stable channel) |
| Dart SDK | ^3.11.5 |
| Android Studio / Xcode | Phiên bản mới nhất |
| VS Code (tuỳ chọn) | Với Flutter & Dart extension |

### 1. Kiểm tra môi trường

```bash
flutter doctor
```

Đảm bảo không có lỗi ❌ nào trước khi tiếp tục.

### 2. Cài đặt dependencies

```bash
flutter pub get
```

### 3. Chạy ứng dụng

#### Android (Emulator hoặc thiết bị thật)

```bash
# Kiểm tra thiết bị đang kết nối
flutter devices

# Chạy trên Android
flutter run
```

#### iOS (chỉ trên macOS)

```bash
# Cài CocoaPods dependencies
cd ios && pod install && cd ..

# Chạy trên iOS Simulator
flutter run -d ios
```

#### Web

```bash
flutter run -d chrome
```

#### macOS Desktop

```bash
flutter run -d macos
```

### 4. Build release

```bash
# Android APK
flutter build apk --release

# Android App Bundle (cho Google Play)
flutter build appbundle --release

# iOS (cần Xcode & Apple Developer account)
flutter build ios --release

# Web
flutter build web --release
```

### Các lệnh hữu ích khác

```bash
# Phân tích code (lint)
flutter analyze

# Chạy tests
flutter test

# Format code
dart format lib/

# Sinh code tự động (khi dùng build_runner)
dart run build_runner build --delete-conflicting-outputs

# Xoá cache & rebuild
flutter clean && flutter pub get
```
