import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rento/src/shared/theme/app_colors.dart';

class RealEstateCard extends ConsumerWidget {
  final String image;
  final String title;
  final String price;
  final String location;
  final String description;
  final String rate;
  final String status;
  final bool isFavorite;
  final int propertyId;

  const RealEstateCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.location,
    required this.description,
    required this.rate,
    required this.status,
    required this.isFavorite,
    required this.propertyId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        color: const Color(0xFFF6F6F6),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 142,
              child: Stack(
                children: [
                  Image.network(
                    image.isNotEmpty
                        ? image
                        : "https://i.imgur.com/uA14S14.jpeg",
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "images/fig.webp",
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  // Favorite Button (Top-right in RTL)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black54,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            status == 'available'
                                ? AppColors.teal900.withOpacity(0.85)
                                : Colors.red.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status == 'available' ? 'متاح' : 'محجوز',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.teal[900],
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        // Icon(
                        //   Icons.attach_money,
                        //   color: Colors.teal[900],
                        //   size: 20,
                        // ),
                        const SizedBox(width: 2),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: AppColors.teal900,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    " ${double.parse(price).toStringAsFixed(0)} ج.م",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.teal900,
                                ),
                              ),
                              const TextSpan(
                                text: " / لليوم",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFFEB400),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rate == "null" ? "لا تقييم" : rate,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 15,
                        //     vertical: 4,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color:
                        //         status == 'available'
                        //             ? AppColors.teal900.withOpacity(0.85)
                        //             : Colors.red.withOpacity(0.85),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Text(
                        //     status == 'available' ? 'متاح' : 'محجوز',
                        //     style: const TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.bold,
                        //       fontFamily: 'Cairo',
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 10,
                        //     vertical: 5,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFFEAEAEA),
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: const Text(
                        //     "خصم 10 %",
                        //     style: TextStyle(
                        //       color: Colors.black87,
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
