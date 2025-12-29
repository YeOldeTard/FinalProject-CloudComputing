import math
from collections import defaultdict
from sqlalchemy import text

class SimpleRecommender:
    def __init__(self, db_session):
        self.db = db_session

    def calculate_distance(self, lat1, lon1, lat2, lon2):
        """Hitung jarak Haversine dalam KM"""
        # Default jarak jauh jika koordinat tidak valid
        if None in [lat1, lon1, lat2, lon2]:
            return 99.0
            
        try:
            lat1, lon1, lat2, lon2 = map(float, [lat1, lon1, lat2, lon2])
        except ValueError:
            return 99.0
        
        R = 6371  # Radius bumi (km)
        dlat = math.radians(lat2 - lat1)
        dlon = math.radians(lon2 - lon1)
        a = math.sin(dlat/2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon/2)**2
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
        return round(R * c, 1)
    
    def get_user_order_history(self, user_id):
        """Ambil riwayat order user"""
        if not user_id:
            return []
        
        query = text("""
            SELECT 
                store_id,
                COUNT(*) as order_count,
                MAX(created_at) as last_order
            FROM customer_order_master 
            WHERE user_id = :user_id
            AND status_order NOT IN ('WAITING_PAYMENT', 'WAITING_SPLIT_PAYMENT')
            GROUP BY store_id
            ORDER BY order_count DESC
        """)
        
        try:
            result = self.db.execute(query, {"user_id": user_id}).mappings().all()
            return result
        except Exception as e:
            print(f"Error fetching history: {e}")
            return []
    
    def get_most_ordered_menus(self, user_id):
        """Ambil menu yang paling sering dipesan user"""
        query = text("""
            SELECT 
                oi.menu_name,
                COUNT(*) as order_count,
                SUM(oi.qty) as total_qty
            FROM customer_order_items oi
            JOIN customer_order_master m ON m.order_id = oi.order_id
            WHERE m.user_id = :user_id
            AND m.status_order NOT IN ('WAITING_PAYMENT', 'WAITING_SPLIT_PAYMENT')
            GROUP BY oi.menu_name
            ORDER BY order_count DESC
            LIMIT 10
        """)
        
        try:
            result = self.db.execute(query, {"user_id": user_id}).mappings().all()
            return result
        except:
            return []

    def get_users_with_similar_taste(self, user_id):
        """Cari user dengan selera yang mirip"""
        query = text("""
            WITH user_stores AS (
                SELECT DISTINCT store_id 
                FROM customer_order_master 
                WHERE user_id = :user_id
                AND status_order NOT IN ('WAITING_PAYMENT', 'WAITING_SPLIT_PAYMENT')
            )
            SELECT 
                m.user_id,
                COUNT(DISTINCT m.store_id) as common_stores,
                u.name
            FROM customer_order_master m
            JOIN users u ON u.id = m.user_id
            WHERE m.user_id != :user_id
            AND m.store_id IN (SELECT store_id FROM user_stores)
            AND m.status_order NOT IN ('WAITING_PAYMENT', 'WAITING_SPLIT_PAYMENT')
            GROUP BY m.user_id, u.name
            HAVING common_stores > 0
            ORDER BY common_stores DESC
            LIMIT 3
        """)
        
        try:
            result = self.db.execute(query, {"user_id": user_id}).mappings().all()
            return result
        except:
            return []

    def get_quick_recommendations(self, user_id, lat, lon):
        """Rekomendasi cepat untuk user"""
        try:
            recommendations = []
            excluded_store_ids = set()

            # 1. CEK RIWAYAT ORDER (PERSONALISASI)
            user_history = self.get_user_order_history(user_id)
            
            if user_history:
                # Loop 2 toko teratas
                for history in user_history[:2]:
                    store_id = history['store_id']
                    if store_id in excluded_store_ids: continue

                    store_query = text("SELECT * FROM stores WHERE id = :store_id")
                    store = self.db.execute(store_query, {"store_id": store_id}).mappings().fetchone()
                    
                    if store:
                        dist = self.calculate_distance(lat, lon, store['latitude'], store['longitude'])
                        recommendations.append({
                            "id": store['id'],
                            "name": store['name'],
                            "logo": store['logo'],
                            "category": store['category'] or "Restoran",
                            "distance": dist,
                            "rating": 4.8, 
                            "reason": "⭐ Sering Anda pesan",
                            "match_score": 95,
                            "type": "favorite",
                            "order_count": history['order_count']
                        })
                        excluded_store_ids.add(store['id'])
                        
                        # CARI TOKO SERUPA (SAMA KATEGORI)
                        if store['category']:
                            similar_query = text("""
                                SELECT * FROM stores 
                                WHERE id != :sid AND category = :cat AND is_active = 1
                                LIMIT 2
                            """)
                            similar_stores = self.db.execute(similar_query, {
                                "sid": store_id, 
                                "cat": store['category']
                            }).mappings().all()

                            for sim in similar_stores:
                                if sim['id'] in excluded_store_ids: continue
                                
                                s_dist = self.calculate_distance(lat, lon, sim['latitude'], sim['longitude'])
                                recommendations.append({
                                    "id": sim['id'],
                                    "name": sim['name'],
                                    "logo": sim['logo'],
                                    "category": sim['category'],
                                    "distance": s_dist,
                                    "rating": 4.5,
                                    "reason": "🏷️ Serupa dengan favorit Anda",
                                    "match_score": 85,
                                    "type": "similar",
                                    "order_count": 0
                                })
                                excluded_store_ids.add(sim['id'])

            # 2. JIKA BELUM ADA REKOMENDASI -> AMBIL POPULER
            if not recommendations:
                popular_query = text("""
                    SELECT s.*, COUNT(m.id) as total_orders
                    FROM stores s
                    LEFT JOIN customer_order_master m ON m.store_id = s.id
                    WHERE s.is_active = 1
                    GROUP BY s.id
                    ORDER BY total_orders DESC
                    LIMIT 4
                """)
                popular_stores = self.db.execute(popular_query).mappings().all()
                
                for store in popular_stores:
                    if store['id'] in excluded_store_ids: continue
                    
                    dist = self.calculate_distance(lat, lon, store['latitude'], store['longitude'])
                    recommendations.append({
                        "id": store['id'],
                        "name": store['name'],
                        "logo": store['logo'],
                        "category": store['category'] or "Restoran",
                        "distance": dist,
                        "rating": 4.6,
                        "reason": "🔥 Populer di Easy Food",
                        "match_score": 80,
                        "type": "popular",
                        "order_count": store['total_orders']
                    })
                    excluded_store_ids.add(store['id'])

            # 3. FILL-IN DENGAN TOKO TERDEKAT (JIKA KURANG DARI 6)
            if len(recommendations) < 6:
                needed = 6 - len(recommendations)
                
                # Ambil semua toko sisa
                if excluded_store_ids:
                    ex_str = ",".join(map(str, excluded_store_ids))
                    nearby_query = text(f"SELECT * FROM stores WHERE is_active = 1 AND id NOT IN ({ex_str})")
                else:
                    nearby_query = text("SELECT * FROM stores WHERE is_active = 1")
                
                all_remaining = self.db.execute(nearby_query).mappings().all()
                
                # Hitung jarak untuk semua toko sisa di Python (lebih aman daripada SQL complex)
                scored_stores = []
                for s in all_remaining:
                    d = self.calculate_distance(lat, lon, s['latitude'], s['longitude'])
                    scored_stores.append({**dict(s), "calc_dist": d})
                
                # Urutkan berdasarkan jarak terdekat
                scored_stores.sort(key=lambda x: x['calc_dist'])
                
                # Ambil top N sesuai kebutuhan
                for store in scored_stores[:needed]:
                    recommendations.append({
                        "id": store['id'],
                        "name": store['name'],
                        "logo": store['logo'],
                        "category": store['category'] or "Restoran",
                        "distance": store['calc_dist'],
                        "rating": 4.2, # Mock rating
                        "reason": "📍 Terdekat dari Anda",
                        "match_score": 75 - int(store['calc_dist'] * 2), # Score turun jika jauh
                        "type": "nearby",
                        "order_count": 0
                    })

            return recommendations

        except Exception as e:
            print(f"Error Recommendation System: {e}")
            import traceback
            traceback.print_exc()
            return []