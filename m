From: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
Subject: [v2 PATCH 4/5] Bluetooth: ecdh_helper - fix leak of private key
Date: Thu, 28 Sep 2017 17:14:54 +0300
Message-ID: <20170928141455.15336-5-tudor.ambarus@microchip.com>
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

tmp buffer contains the swapped private key. In case the setkey call
failed, the tmp buffer was freed without clearing the private key.

Zeroize the temporary buffer so we don't leak the private key.

Signed-off-by: Tudor Ambarus <tudor.ambarus-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org>
---
 net/bluetooth/ecdh_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
index 22c8daa..16e022f 100644
--- a/net/bluetooth/ecdh_helper.c
+++ b/net/bluetooth/ecdh_helper.c
@@ -122,7 +122,7 @@ int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 free_req:
 	kpp_request_free(req);
 free_tmp:
-	kfree(tmp);
+	kzfree(tmp);
 	return err;
 }
 
-- 
2.9.4
