package ru.hse.shop.dto.request;

import java.util.UUID;

public record LinkProductCategoryDto(UUID productId, UUID categoryId) {

}
