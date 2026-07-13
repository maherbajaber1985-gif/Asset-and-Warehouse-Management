-- ============================================================
-- نظام صيانة المقار والمباني - وطن الأول للموارد البشرية
-- Facilities Maintenance Module - Data Model
-- ============================================================
-- هذا الملف يوثّق هيكل البيانات. النسخة الحالية (HTML) تخزّن
-- البيانات محلياً في المتصفح، لكن هذا الـ schema هو المرجع
-- عند الانتقال لقاعدة بيانات مشتركة (Google Sheets / SQL) لاحقاً.
-- ============================================================

-- المواقع والمباني (سكنات، فروع، مراكز توزيع، مكاتب)
CREATE TABLE sites (
    id          INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,              -- اسم الموقع
    city        TEXT NOT NULL,              -- الرياض / جدة / الدمام / أبها ...
    type        TEXT NOT NULL,              -- سكن | فرع | مركز توزيع | مكتب
    address     TEXT,                       -- العنوان
    notes       TEXT
);

-- الأصول داخل كل موقع (تكييف، مولدات، أثاث، معدات ...)
CREATE TABLE assets (
    id           INTEGER PRIMARY KEY,
    site_id      INTEGER NOT NULL REFERENCES sites(id),
    name         TEXT NOT NULL,             -- اسم الأصل
    category     TEXT,                      -- تكييف | كهرباء | سباكة ...
    serial_no    TEXT,                      -- الرقم التسلسلي
    install_date DATE,
    status       TEXT DEFAULT 'يعمل'        -- يعمل | معطّل | خارج الخدمة
);

-- بلاغات الصيانة / أوامر العمل (قلب النظام)
CREATE TABLE maintenance_requests (
    id           INTEGER PRIMARY KEY,
    site_id      INTEGER NOT NULL REFERENCES sites(id),
    asset_id     INTEGER REFERENCES assets(id),   -- اختياري
    title        TEXT NOT NULL,             -- وصف مختصر للعطل
    description  TEXT,                       -- التفاصيل
    category     TEXT NOT NULL,             -- تكييف | كهرباء | سباكة | أثاث ومعدات | إنشائي/دهان | أمن وسلامة | نظافة عامة | أخرى
    priority     TEXT NOT NULL,             -- عاجل | عالي | متوسط | منخفض
    status       TEXT NOT NULL DEFAULT 'مفتوح', -- مفتوح | قيد التنفيذ | بانتظار مورد/قطع | مغلق | ملغي
    reporter     TEXT,                       -- اسم مقدّم البلاغ (المشرف)
    assigned_to  TEXT,                       -- الفني/المورد المكلّف
    cost         DECIMAL(10,2) DEFAULT 0,    -- تكلفة الإصلاح (ريال)
    created_at   TIMESTAMP,
    closed_at    TIMESTAMP,
    notes        TEXT
);

-- الصيانة الوقائية المجدولة
CREATE TABLE preventive_schedules (
    id          INTEGER PRIMARY KEY,
    site_id     INTEGER NOT NULL REFERENCES sites(id),
    asset_id    INTEGER REFERENCES assets(id),
    task        TEXT NOT NULL,              -- المهمة (مثال: تنظيف فلاتر التكييف)
    frequency   TEXT NOT NULL,             -- شهري | ربع سنوي | نصف سنوي | سنوي
    last_done   DATE,
    next_due    DATE
);

-- الموردون والفنيون
CREATE TABLE vendors (
    id          INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    specialty   TEXT,                       -- التخصص
    phone       TEXT,
    notes       TEXT
);
