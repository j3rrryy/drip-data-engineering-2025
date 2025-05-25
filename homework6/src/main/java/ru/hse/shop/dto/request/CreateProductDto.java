package ru.hse.shop.dto.request;

import java.math.BigDecimal;
import java.util.UUID;

public record CreateProductDto(
        String name,
        UUID categoryId,
        String description,
        BigDecimal price,
        String imageUrl,
        Integer stock
) {

}
