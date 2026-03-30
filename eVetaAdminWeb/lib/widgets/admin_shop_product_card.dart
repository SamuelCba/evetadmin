import 'package:flutter/material.dart';

import '../utils/cloudinary_image_url.dart';

String? adminFirstProductImageUrl(Map<String, dynamic> product) {
  final images = product['images'];
  if (images is List && images.isNotEmpty) {
    return images.first.toString();
  }
  if (images is String && images.isNotEmpty) {
    return images;
  }
  return null;
}

/// Tarjeta visual alineada con eVetaShop (sin carrito).
class AdminShopProductCard extends StatelessWidget {
  const AdminShopProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  final Map<String, dynamic> product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = product['name']?.toString() ?? 'Sin nombre';
    final rawPrice = product['price'];
    final priceStr = rawPrice != null ? rawPrice.toString() : '0';
    double? priceVal;
    try {
      priceVal = double.parse(priceStr);
    } catch (_) {
      priceVal = null;
    }
    final stock = product['stock'] is int
        ? product['stock'] as int
        : int.tryParse(product['stock']?.toString() ?? '') ?? 0;
    final active = product['is_active'] != false;
    final url = adminFirstProductImageUrl(product);
    final imageUrl = (url != null && url.isNotEmpty)
        ? evetaImageDeliveryUrl(url, EvetaImageDelivery.card)
        : '';
    final isOut = stock <= 0;

    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 132,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: Colors.grey.shade200,
                          child: Icon(Icons.image_not_supported_outlined,
                              color: Colors.grey.shade400, size: 40),
                        ),
                      )
                    : ColoredBox(
                        color: Colors.grey.shade100,
                        child: Icon(Icons.inventory_2_outlined,
                            color: Colors.grey.shade400, size: 36),
                      ),
              ),
              if (isOut)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45),
                      alignment: Alignment.center,
                      child: const Text(
                        'AGOTADO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              if (!active)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Inactivo',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Divider(color: Colors.grey.shade200, height: 1),
              const SizedBox(height: 6),
              Text(
                priceVal != null ? 'Bs ${priceVal.toStringAsFixed(priceVal.truncateToDouble() == priceVal ? 0 : 2)}' : 'Precio N/A',
                style: TextStyle(
                  color: Colors.grey.shade900,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Stock: $stock',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: column,
        ),
      ),
    );
  }
}
