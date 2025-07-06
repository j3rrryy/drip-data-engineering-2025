package ru.hse.shop.dto.request;

import java.math.BigDecimal;
import java.util.UUID;

public record UpdateProductDto(
        UUID id,
        String name,
        String description,
        BigDecimal price,
        String imageUrl,
        Integer stock
) {

}
