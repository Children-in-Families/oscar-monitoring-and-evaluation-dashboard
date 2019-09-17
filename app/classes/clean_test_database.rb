class CleanTestDatabase

  TABLE_TO_EXCLUDE = ['spatial_ref_sys', 'schema_migrations', 'ar_internal_metadata']
  CONNECTION = ActiveRecord::Base.connection

  def self.clean(*tenants)
    tenants.each{ |tenant| delete_all_in_tenant(tenant) }
  end

  def self.drop_all_schemas
    schemas = ActiveRecord::Base.connection.select_values <<-SQL
        SELECT
          schema_name
        FROM
          information_schema.schemata
        WHERE
          schema_name NOT IN ('information_schema','public', 'postgis') AND
          schema_name NOT LIKE 'pg%'
    SQL
    schemas.each { |schema| Apartment::Tenant.drop(schema) }
  end

  private

    def self.delete_all_in_tenant(tenant)
      CONNECTION.disable_referential_integrity do
        tables_to_clean(tenant).each do |table|
          delete_from(table) if table_has_new_rows?(table)
        end
      end
    end

    def self.tables_to_clean(tenant)
      tables = CONNECTION.tables - TABLE_TO_EXCLUDE
      tables.map{ |table| "#{tenant}.#{table}" }
    end

    def self.table_has_new_rows?(table_name)
      CONNECTION.select_value("SELECT count(*) FROM #{table_name}").to_i > 0
    end

    def self.delete_from(table_name)
      CONNECTION.execute("DELETE FROM #{table_name}")
    end
end
