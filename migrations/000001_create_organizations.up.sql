CREATE TABLE IF NOT EXISTS organizations (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS customers (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    organization_id BIGINT NOT NULL,
    name TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,

    CONSTRAINT fk_customers_organization
        FOREIGN KEY (organization_id) 
        REFERENCES organizations(id)
        ON DELETE RESTRICT,

    CONSTRAINT uq_customers_organization_id
        UNIQUE (organization_id, id)
);

CREATE TABLE IF NOT EXISTS projects (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    organization_id BIGINT NOT NULL,
    customer_id BIGINT NOT NULL,
    name TEXT NOT NULL,
    price NUMERIC(14, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_projects_organization
        FOREIGN KEY (organization_id)
        REFERENCES organizations(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_projects_customer
        FOREIGN KEY (organization_id, customer_id)
        REFERENCES customers(organization_id, id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_projects_price
        CHECK (price >= 0),

    CONSTRAINT chk_name
        CHECK (LENGTH(TRIM(name)) > 0)
);

CREATE INDEX idx_customers_organization_id
    ON customers(organization_id);

CREATE INDEX idx_projects_organization_id
    ON projects(organization_id);

CREATE INDEX idx_projects_customer_id
    ON projects(organization_id, customer_id);