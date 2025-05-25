package ru.hse.shop.config;

import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

import javax.sql.DataSource;

@Configuration
public class DataSourceConfiguration {

    @Bean
    @Primary
    @ConfigurationProperties(prefix = "spring.datasource")
    public DataSourceProperties customDataSourceProperties() {
        return new DataSourceProperties();
    }

    @Bean
    @Primary
    public DataSource trackingDataSource(DataSourceProperties customDataSourceProperties) {
        return customDataSourceProperties.initializeDataSourceBuilder().build();
    }

    @Bean
    @Primary
    public NamedParameterJdbcTemplate shopParameterJdbcTemplate(
            DataSource trackingDataSource,
            DataSourceProperties customDataSourceProperties
    ) {
        return new NamedParameterJdbcTemplate(trackingDataSource);
    }

}
