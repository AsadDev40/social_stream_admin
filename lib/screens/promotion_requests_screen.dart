import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_stream_admin/models/user.dart';
import 'package:social_stream_admin/provider/promotion_provider.dart';
import 'promotion_request_detail_screen.dart';

class PromotionRequestsScreen extends StatelessWidget {
  const PromotionRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotion Requests'),
      ),
      body: FutureBuilder(
        future:
            Provider.of<PromotionProvider>(context, listen: false).fetchUsers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else {
            return Consumer<PromotionProvider>(
              builder: (ctx, userProvider, child) {
                final usersWithPromotions = userProvider.users.expand((user) {
                  return user.promotions.map((promotion) {
                    return {
                      'user': user,
                      'promotion': promotion,
                    };
                  }).toList();
                }).toList();

                if (usersWithPromotions.isEmpty) {
                  return const Center(
                      child: Text('No promotion requests found'));
                }

                return ListView.builder(
                  itemCount: usersWithPromotions.length,
                  itemBuilder: (context, index) {
                    final userWithPromotion = usersWithPromotions[index];
                    final user = userWithPromotion['user'] as User;
                    final promotion =
                        userWithPromotion['promotion'] as Promotion;

                    return ListTile(
                      title: Text(user.name),
                      subtitle: Text(promotion.channelName),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PromotionRequestDetailScreen(
                              user: user,
                              promotion: promotion,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
