From: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Subject: [v2 PATCH 3/5] Bluetooth: selftest - check for errors when computing ZZ
Date: Thu, 28 Sep 2017 17:14:53 +0300
Message-ID: <20170928141455.15336-4-tudor.ambarus@microchip.com>
References: <20170928141455.15336-1-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
To: <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170928141455.15336-1-tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Sender: linux-bluetooth-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
---
 net/bluetooth/selftest.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/selftest.c b/net/bluetooth/selftest.c
index 126bdc5..ce99648 100644
--- a/net/bluetooth/selftest.c
+++ b/net/bluetooth/selftest.c
@@ -143,7 +143,7 @@ static int __init test_ecdh_sample(struct crypto_kpp *tfm, const u8 priv_a[32],
 				   const u8 pub_b[64], const u8 dhkey[32])
 {
 	u8 *tmp, *dhkey_a, *dhkey_b;
-	int ret = 0;
+	int ret;
 
 	tmp = kmalloc(64, GFP_KERNEL);
 	if (!tmp)
@@ -152,8 +152,13 @@ static int __init test_ecdh_sample(struct crypto_kpp *tfm, const u8 priv_a[32],
 	dhkey_a = &tmp[0];
 	dhkey_b = &tmp[32];
 
-	compute_ecdh_secret(tfm, pub_b, priv_a, dhkey_a);
-	compute_ecdh_secret(tfm, pub_a, priv_b, dhkey_b);
+	ret = compute_ecdh_secret(tfm, pub_b, priv_a, dhkey_a);
+	if (ret)
+		goto out;
+
+	ret = compute_ecdh_secret(tfm, pub_a, priv_b, dhkey_b);
+	if (ret)
+		goto out;
 
 	if (memcmp(dhkey_a, dhkey, 32)) {
 		ret = -EINVAL;
-- 
2.9.4
