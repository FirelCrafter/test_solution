# Image Editor App 🖼️🎨

Тестовое приложение для редактирования изображений, которое позволяет импортировать изображения из галереи, применять к ним фильтры и рисовать при помощи Pencil Kit. Имеет авторизацию при помощи пары email/пароль через Firebase с возможностью регистрации и восстановления пароля.

## 📖 О проекте

### Архитектура

Архитектура устроена по слоям:

- **UILayer**: Содержит SwiftUI Views для отображения, ViewModifiers для изменения внешнего вида элементов, ViewModels для взаимодействия с пользовательским интерфейсом.
- **DataLayer**: Содержит файлы для управления бизнес-логикой и состоянием приложения.
- **NetworkLayer**: Содержит файлы для взаимодействия с сетью.
- **Utils**: Содержит пользовательские расширения и вспомогательные функции.

## 🛠️ Начало работы

### Условия

- Xcode 12 или новее
- Swift 5.3 или новее
- iOS 17.0 или новее

### Установка

1. Клонирование репозитория:
    ```bash
    git clone https://github.com/FirelCrafter/test_solution.git
    ```
2. Открытие проекта в Xcode:
    ```bash
    cd test_solution/test_solution
    open test_solution.xcodeproj
    ```
3. Сборка на симуляторе или другом девайсе.

## 📚 Использование

### Основные фичи

- **Import Image**: Импорт изображений из галереи.
- **Apply Filters**: К импортированному изображению могут быть применены различные фильтры (например, сепия, нуар).
- **Draw on Image**: Рисование прямо на изображении, используя PencilKit.
- **Save Image**: Сохранение изображения в галерею.
- **Share Image**: Поделиться изображением.

### Скриншоты

<img src="https://raw.githubusercontent.com/FirelCrafter/test_solution/main/.git/images/image02.png" alt="Drawing on Image" width="300"/>
<img src="https://raw.githubusercontent.com/FirelCrafter/test_solution/main/.git/images/image01.png" alt="Applied Filter" width="300"/>

## 🧩 Компоненты

### Views

- **HomeView**: Главный экран, содержащий функционал редактора изображений.
- **DrawingView**: Пользовательский экран для отображения и рисования на изображении.
- **ContentView**: Экран входа.
- **SignUpView**: Экран регистрации.
- **PasswordRecoveryView**: Экран восстановления пароля.

### ViewModifiers

- **TextFieldModifier**: Модификатор для текстовых полей.
- **ButtonModifier**: Модификатор для кнопок.

### ViewModels

- **AuthViewModel**: Управляет состоянием и логикой для экранов авторизации.
- **HomeViewModel**: Управляет состоянием и логикой для HomeView.

### Helpers

- **ImagePicker**: Компонент для выбора изображений из галереи.
- **ImageFilter**: Применяет различные фильтры к изображениям.
- **DrawingView**: Компонент для рисования на изображении.
- **ContentView**: Основной экран контента.

### Utils

- **PermissionsManager**: Обрабатывает разрешения на доступ к фото библиотеке и камере.
- **Toast**: Отображает временные уведомления.

## 🚀 Будущие улучшения

- Улучшение производительности при применении фильтров.
- Добавление новых фильтров и эффектов.
- Поддержка многослойного редактирования изображений.
- Интеграция с облачными сервисами для сохранения изображений.

## 📄 Лицензия

Этот проект лицензирован под MIT License - подробности см. в файле [LICENSE](LICENSE).

## 💬 Контакты

E-mail: [firecrafter62@gmail.com](mailto:firecrafter62@gmail.com)  
Telegram: [@mikhail_ios](https://t.me/mikhail_ios)

---

_Developed with ❤️ by [Mikhail Shcherbakov](https://github.com/FirelCrafter)_
