package ru.hse.shop.service;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Service;
import ru.hse.shop.dto.request.*;
import ru.hse.shop.dto.response.ProductDto;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ShopService {

    private final NamedParameterJdbcTemplate shopParameterJdbcTemplate;

    public UUID createProduct(CreateProductDto createProductDto) {
        String sql = """
                    INSERT INTO products (id, name, category_id, description, price, image_url, stock)
                    VALUES (:id, :name, :categoryId, :description, :price, :imageUrl, :stock)
                """;

        UUID id = UUID.randomUUID();
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("id", id)
                .addValue("name", createProductDto.name())
                .addValue("categoryId", createProductDto.categoryId())
                .addValue("description", createProductDto.description())
                .addValue("price", createProductDto.price())
                .addValue("imageUrl", createProductDto.imageUrl())
                .addValue("stock", createProductDto.stock());

        shopParameterJdbcTemplate.update(sql, params);
        return id;
    }

    public void updateProduct(UpdateProductDto updateProductDto) {
        StringBuilder sql = new StringBuilder("UPDATE products SET ");
        MapSqlParameterSource params = new MapSqlParameterSource();
        List<String> updates = new ArrayList<>();

        if (updateProductDto.name() != null) {
            updates.add("name = :name");
            params.addValue("name", updateProductDto.name());
        }
        if (updateProductDto.description() != null) {
            updates.add("description = :description");
            params.addValue("description", updateProductDto.description());
        }
        if (updateProductDto.price() != null) {
            updates.add("price = :price");
            params.addValue("price", updateProductDto.price());
        }
        if (updateProductDto.imageUrl() != null) {
            updates.add("image_url = :imageUrl");
            params.addValue("imageUrl", updateProductDto.imageUrl());
        }
        if (updateProductDto.stock() != null) {
            updates.add("stock = :stock");
            params.addValue("stock", updateProductDto.stock());
        }
        if (updates.isEmpty()) return;

        sql.append(String.join(", ", updates)).append(" WHERE id = :id");
        params.addValue("id", updateProductDto.id());

        shopParameterJdbcTemplate.update(sql.toString(), params);
    }

    public UUID createCategory(CreateCategoryDto createCategoryDto) {
        String sql = """
                    INSERT INTO categories (id, name)
                    VALUES (:id, :name)
                """;

        UUID id = UUID.randomUUID();
        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("id", id)
                .addValue("name", createCategoryDto.name());

        shopParameterJdbcTemplate.update(sql, params);
        return id;
    }

    public void linkProductWithCategory(LinkProductCategoryDto linkProductCategoryDto) {
        String sql = """
                    UPDATE products
                    SET category_id = :categoryId
                    WHERE id = :productId
                """;

        MapSqlParameterSource params = new MapSqlParameterSource()
                .addValue("productId", linkProductCategoryDto.productId())
                .addValue("categoryId", linkProductCategoryDto.categoryId());

        shopParameterJdbcTemplate.update(sql, params);
    }

    public List<ProductDto> getAllProducts() {
        String sql = """
                    SELECT p.id, p.name, p.description, p.price, p.rating, p.image_url, p.stock, c.name AS category_name
                    FROM products p
                    JOIN categories c ON p.category_id = c.id
                    ORDER BY p.name
                """;

        return shopParameterJdbcTemplate.query(sql, (resultSet, rowNum) -> new ProductDto(
                UUID.fromString(resultSet.getString("id")),
                resultSet.getString("name"),
                resultSet.getString("category_name"),
                resultSet.getString("description"),
                resultSet.getBigDecimal("price"),
                resultSet.getBigDecimal("rating"),
                resultSet.getString("image_url"),
                resultSet.getInt("stock")
        ));
    }

}
