[Back to list](./../readme.md)

[Task Definition](./task/readme.md)

# Terraform for AWS

- S3 Bucket for state
- Dynamydb for lock (only one person can works)
- VPC public (3 items) and private (3 items) subnets
- ECR (Elastic Container Registry) for Docker-images.
- Elastic IP (1 item)
- NAT Gateway (for Internet access from private subnets)
- EKS (Elastic Kubernetes Service)
- Jenkins (for build and push docker container to ECR)
- ArgoCD (sync cluster-kuber django-app, if git codebase was changed, like new PR in main branch )
- `new` rds module


First off all im creating `S3 bucket`, im use next aws terminal command

```
$ aws s3api create-bucket --bucket rohozhyn-lesson-db-module --region us-east-1
```

![bucket s3](./imgs/aws-s3.png)

then

```
terraform init
```

![terraform init](./imgs/terraform-init.png)

```
terraform plan
```

![terraform plan](./imgs/terraform-plan.png)

Before command `terraform apply` im preparing django application from `lessons 4`. Im create independent repo with django application (<a href="https://github.com/PavloRohozhyn/django-app-for-terraform-1.git">django-app-for-terraform-1</a>) and create there Jenkinsfile for CI/CD process

```
terraform apply

```

![terraform apply](./imgs/terraform-apply.png)


And NOW! lets check what was created ))), firstly update kuberconfig because we have a new kubernetes cluster

```
$ aws eks update-kubeconfig --name dev-lesson-db-module-test-kuber
```

### Функціонал модуля:

use_aurora = true → створюється Aurora Cluster + writer;
use_aurora = false → створюється одна aws_db_instance;
В обох випадках:
створюється aws_db_subnet_group;
створюється aws_security_group;
створюється parameter group з базовими параметрами (max_connections, log_statement, work_mem);
Параметри engine, engine_version, instance_class, multi_az задаються через змінні.

---

## 📖 Документація модуля RDS

### 🚀 Приклад використання

#### Базове використання (звичайна RDS):
```hcl
module "rds" {
  source = "./modules/rds"

  # Основні параметри
  environment   = "dev"
  project_name  = "my-app"
  use_aurora    = false  # звичайна RDS

  # Мережеві параметри
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.private_subnet_ids
  allowed_cidr_blocks  = ["10.0.0.0/16"]

  # Параметри бази даних
  engine           = "postgres"
  engine_version   = "15.4"
  instance_class   = "db.t3.micro"
  
  # База даних та користувач
  db_name     = "myappdb"
  db_username = "appuser"
  manage_master_user_password = true  # AWS Secrets Manager

  # Сховище
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type         = "gp3"

  # Теги
  tags = {
    Project = "my-application"
    Owner   = "team-name"
  }
}
```

#### Використання Aurora Cluster:
```hcl
module "rds_aurora" {
  source = "./modules/rds"

  # Основні параметри
  environment   = "prod"
  project_name  = "my-app"
  use_aurora    = true  # Aurora Cluster

  # Мережеві параметри
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.private_subnet_ids
  allowed_cidr_blocks  = ["10.0.0.0/16"]

  # Параметри бази даних
  engine           = "aurora-postgresql"
  engine_version   = "15.4"
  instance_class   = "db.r6g.large"

  # Aurora специфічні параметри
  aurora_cluster_instances = 3
  aurora_serverless_v2     = false
  
  # Доступність (продакшн)
  multi_az             = true
  deletion_protection  = true
  skip_final_snapshot  = false

  # Моніторинг
  monitoring_interval                   = 30
  performance_insights_enabled         = true
  performance_insights_retention_period = 731  # 2 роки
}
```

#### Aurora Serverless v2:
```hcl
module "rds_serverless" {
  source = "./modules/rds"

  use_aurora           = true
  aurora_serverless_v2 = true
  aurora_min_capacity  = 0.5   # ACU
  aurora_max_capacity  = 16    # ACU
  
  engine = "aurora-postgresql"
  # ... інші параметри
}
```

### 📋 Опис змінних

#### 🔧 Основні параметри
| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `environment` | `string` | `"dev"` | Середовище (dev, staging, prod) |
| `project_name` | `string` | `"lesson-db"` | Назва проекту |
| `use_aurora` | `bool` | `false` | **Головний перемикач**: `true` = Aurora, `false` = RDS |

#### 🌐 Мережеві параметри
| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `vpc_id` | `string` | **обов'язкова** | ID VPC для розміщення RDS |
| `subnet_ids` | `list(string)` | **обов'язкова** | Список ID приватних підмереж (мін. 2) |
| `allowed_cidr_blocks` | `list(string)` | `["10.0.0.0/16"]` | CIDR блоки з доступом до БД |

#### 🗄️ Параметри бази даних
| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `engine` | `string` | `"postgres"` | Движок БД (див. підтримувані нижче) |
| `engine_version` | `string` | `"15.4"` | Версія движка |
| `instance_class` | `string` | `"db.t3.micro"` | Клас інстанса |
| `allocated_storage` | `number` | `20` | Розмір сховища ГБ (тільки RDS) |
| `max_allocated_storage` | `number` | `100` | Макс розмір для автомасштабування |
| `storage_type` | `string` | `"gp3"` | Тип сховища (gp2, gp3, io1) |

#### 🔐 Креденшели
| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `db_name` | `string` | `"appdb"` | Назва бази даних |
| `db_username` | `string` | `"dbadmin"` | Ім'я адміністратора |
| `db_password` | `string` | `""` | Пароль (пусто = автогенерація) |
| `manage_master_user_password` | `bool` | `true` | Керування паролем через AWS Secrets Manager |

#### 🌍 Доступність
| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `multi_az` | `bool` | `false` | Розгортання у кількох AZ |
| `publicly_accessible` | `bool` | `false` | Доступність з інтернету |

#### 💾 Бекапи
| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `backup_retention_period` | `number` | `7` | Термін зберігання бекапів (дні) |
| `backup_window` | `string` | `"03:00-04:00"` | Вікно бекапів (UTC) |
| `maintenance_window` | `string` | `"Mon:04:00-Mon:05:00"` | Вікно обслуговування |

#### ⭐ Aurora-специфічні
| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `aurora_cluster_instances` | `number` | `2` | Кількість інстансів у кластері |
| `aurora_serverless_v2` | `bool` | `false` | Використання Serverless v2 |
| `aurora_min_capacity` | `number` | `0.5` | Мін ємність ACU (Serverless) |
| `aurora_max_capacity` | `number` | `2` | Макс ємність ACU (Serverless) |

#### 📊 Моніторинг
| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `monitoring_interval` | `number` | `60` | Інтервал Enhanced Monitoring (сек) |
| `performance_insights_enabled` | `bool` | `true` | Увімкнути Performance Insights |
| `performance_insights_retention_period` | `number` | `7` | Термін зберігання PI (дні) |

#### 🛡️ Безпека
| Змінна | Тип | За замовчуванням | Опис |
|--------|-----|------------------|------|
| `deletion_protection` | `bool` | `false` | Захист від видалення |
| `skip_final_snapshot` | `bool` | `true` | Пропустити фінальний снапшот |
| `copy_tags_to_snapshot` | `bool` | `true` | Копіювати теги до снапшотів |

---

### 🔄 Як змінити параметри БД

#### 1. **Зміна типу БД (RDS ↔ Aurora):**
```hcl
# Звичайна RDS
use_aurora = false

# Aurora Cluster  
use_aurora = true
```

#### 2. **Зміна движка:**
```hcl
# PostgreSQL
engine = "postgres"           # RDS
engine = "aurora-postgresql"  # Aurora

# MySQL
engine = "mysql"              # RDS  
engine = "aurora-mysql"       # Aurora

# MariaDB (тільки RDS)
engine = "mariadb"
```

#### 3. **Зміна класу інстанса:**
```hcl
# Розробка
instance_class = "db.t3.micro"    # 2 vCPU, 1 GB RAM
instance_class = "db.t3.small"    # 2 vCPU, 2 GB RAM

# Продакшн  
instance_class = "db.r6g.large"   # 2 vCPU, 16 GB RAM
instance_class = "db.r6g.xlarge"  # 4 vCPU, 32 GB RAM

# High Performance
instance_class = "db.r6g.2xlarge" # 8 vCPU, 64 GB RAM
```

#### 4. **Зміна версії движка:**
```hcl
# PostgreSQL
engine_version = "15.4"  # Поточна
engine_version = "14.9"  # Попередня
engine_version = "16.1"  # Нова

# MySQL
engine_version = "8.0.35"
engine_version = "5.7.44"
```

#### 5. **Налаштування для різних середовищ:**

**Development:**
```hcl
use_aurora          = false
instance_class      = "db.t3.micro"  
multi_az           = false
deletion_protection = false
allocated_storage   = 20
```

**Staging:**
```hcl
use_aurora          = false
instance_class      = "db.t3.small"
multi_az           = true
deletion_protection = false  
allocated_storage   = 50
```

**Production:**
```hcl
use_aurora          = true           # Aurora для HA
instance_class      = "db.r6g.large"
multi_az           = true
deletion_protection = true           # Захист від видалення
aurora_cluster_instances = 3         # Writer + 2 Readers
backup_retention_period = 30        # 30 днів бекапів
performance_insights_retention_period = 731  # 2 роки
```

### 📤 Outputs модуля

```hcl
# Підключення до БД
database_endpoint     # Endpoint для підключення
database_port        # Порт (5432, 3306)  
database_name        # Назва БД
database_username    # Користувач

# AWS ресурси
master_user_secret_arn        # ARN секрету з паролем
security_group_id            # ID Security Group
db_subnet_group_name         # Назва Subnet Group  

# Моніторинг
rds_instance_id      # ID інстанса (RDS)
aurora_cluster_id    # ID кластера (Aurora)
connection_string    # Готовий connection string
```

### ⚠️ Зауваження

1. **Обов'язкові залежності:** Модуль потребує існуючий VPC з приватними підмережами
2. **Мінімум підмереж:** Потрібно мінімум 2 підмережі в різних AZ  
3. **Aurora vs RDS:** Aurora дорожчий але надійніший для продакшн
4. **Serverless:** Aurora Serverless v2 автоматично масштабується під навантаження
5. **Бекапи:** Увімкнені за замовчуванням з 7-денним зберіганням
6. **Безпека:** Пароль зберігається в AWS Secrets Manager

---

### 💡 Приклади використання outputs

```hcl
# Отримання connection string для додатку
resource "kubernetes_secret" "db_credentials" {
  metadata {
    name = "app-db-credentials"
  }
  
  data = {
    DATABASE_URL = module.rds.connection_string
    DB_HOST      = module.rds.database_endpoint
    DB_PORT      = tostring(module.rds.database_port)
    DB_NAME      = module.rds.database_name
    DB_USER      = module.rds.database_username
    SECRET_ARN   = module.rds.master_user_secret_arn
  }
}

# Використання в інших модулях
module "app_deployment" {
  source = "./modules/app"
  
  database_endpoint = module.rds.database_endpoint
  database_port     = module.rds.database_port
  security_group_id = module.rds.security_group_id
}
```

### 🔧 Troubleshooting

#### Інколи виникають такі помилки:

1. **"Insufficient subnets"**
   ```
   Error: DB Subnet Group requires subnets in at least 2 Availability Zones
   ```
   **Рішення:** Додати підмережі в різні AZ у змінну `subnet_ids`

2. **"Invalid engine combination"**
   ```
   Error: aurora-mysql is not supported for use_aurora = false
   ```
   **Рішення:** Використовувати правильні комбінації:
   - RDS: `postgres`, `mysql`, `mariadb`
   - Aurora: `aurora-postgresql`, `aurora-mysql`

3. **"Instance class not supported"**
   ```
   Error: db.t3.micro is not supported for aurora
   ```
   **Рішення:** Aurora потребує інші класи (db.r6g.*, db.t4g.*)

#### Корисні команди:

```bash
# Перевірка стану RDS
terraform output database_endpoint

# Перевірка секретів AWS
aws secretsmanager get-secret-value --secret-id <secret-arn>

# Підключення до БД через psql
psql -h $(terraform output -raw database_endpoint) \
     -p $(terraform output -raw database_port) \
     -U $(terraform output -raw database_username) \
     $(terraform output -raw database_name)

# Targeted planning/applying (Windows/PowerShell - використовуйте лапки!)
terraform plan -target="module.rds" -target="module.vpc"
terraform apply -target="module.rds" -target="module.vpc"

# Bash/Linux
terraform plan -target=module.rds -target=module.vpc
terraform apply -target=module.rds -target=module.vpc
```

#### ⚠️ **Windows/PowerShell користувачі:**
Завжди використовуйте лапки навколо target значень:
```powershell
# ✅ Правильно
terraform plan -target="module.rds"

# ❌ Помилка в PowerShell  
terraform plan -target=module.rds
```

---

### 🚀 Швидкий старт

1. **Клонувати репозиторій:**
   ```bash
   git clone <repository-url>
   cd lesson-db-module
   ```

2. **Налаштувати змінні (файли знаходяться у кореневій директорії проекту):**
   ```bash
   # Перевірити що файл-приклад існує
   ls terraform.tfvars.example
   
   # Скопіювати приклад конфігурації
   cp terraform.tfvars.example terraform.tfvars
   
   # Відредагувати terraform.tfvars своїми значеннями
   nano terraform.tfvars  # або будь-який інший редактор
   ```

3. **Ініціалізувати та запустити:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Отримати connection string:**
   ```bash
   terraform output database_connection_string
   ```

**Важливо:** 
- `terraform.tfvars.example` - це шаблон з прикладами значень
- `terraform.tfvars` - ваш файл з реальними значеннями (створіть копією з example)
- Файл `terraform.tfvars` додано до `.gitignore` для безпеки