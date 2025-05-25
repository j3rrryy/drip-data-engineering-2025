package ru.hse.shop.dto.response;

import java.math.BigDecimal;
import java.util.UUID;

public record ProductDto(
        UUID id,
        String name,
        String categoryName,
        String description,
        BigDecimal price,
        BigDecimal rating,
        String imageUrl,
        Integer stock
) {

}
