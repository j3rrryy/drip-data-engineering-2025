package ru.hse.shop.controller;

import io.swagger.v3.oas.annotations.responses.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import ru.hse.shop.dto.request.*;
import ru.hse.shop.dto.response.ProductDto;
import ru.hse.shop.service.ShopService;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ShopController {

    private final ShopService shopService;

    @PostMapping("/product")
    @ApiResponse(responseCode = "201")
    @ResponseStatus(HttpStatus.CREATED)
    public UUID createProduct(@RequestBody CreateProductDto createProductDto) {
        return shopService.createProduct(createProductDto);
    }

    @PatchMapping("/product")
    @ApiResponse(responseCode = "204")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void updateProduct(@RequestBody UpdateProductDto updateProductDto) {
        shopService.updateProduct(updateProductDto);
    }

    @PostMapping("/category")
    @ApiResponse(responseCode = "201")
    @ResponseStatus(HttpStatus.CREATED)
    public UUID createCategory(@RequestBody CreateCategoryDto createCategoryDto) {
        return shopService.createCategory(createCategoryDto);
    }

    @PutMapping("/product-category")
    @ApiResponse(responseCode = "204")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void linkProductWithCategory(@RequestBody LinkProductCategoryDto linkProductCategoryDto) {
        shopService.linkProductWithCategory(linkProductCategoryDto);
    }

    @GetMapping("/products")
    public List<ProductDto> getAllProducts() {
        return shopService.getAllProducts();
    }

}
