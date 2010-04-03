From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 4/7] net/wireless: switch lib80211_crypt_tkip from arc4 to arc4blk
Date: Sat,  3 Apr 2010 09:49:26 +0200
Message-ID: <1270280969-11357-5-git-send-email-sebastian@breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53101 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379Ab0DCHtk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Apr 2010 03:49:40 -0400
In-Reply-To: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ecb(arc4) is getting replaced by arc4 which is a blkcipher by itself. The
required selects are now pulled in by LIB80211_CRYPT_TKIP instead of
selecting it by every driver.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 net/wireless/Kconfig               |    2 ++
 net/wireless/lib80211_crypt_tkip.c |   11 +++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 90e93a5..119f1eb 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -147,6 +147,8 @@ config LIB80211_CRYPT_CCMP
 	tristate
 
 config LIB80211_CRYPT_TKIP
+	select CRYPTO
+	select CRYPTO_ARC4BLK
 	tristate
 
 config LIB80211_DEBUG
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index c362873..089f84f 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -28,6 +28,7 @@
 #include <net/iw_handler.h>
 
 #include <linux/crypto.h>
+#include <crypto/arc4.h>
 #include <linux/crc32.h>
 
 #include <net/lib80211.h>
@@ -94,7 +95,7 @@ static void *lib80211_tkip_init(int key_idx)
 
 	priv->key_idx = key_idx;
 
-	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
+	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("arc4", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
 		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
@@ -112,7 +113,7 @@ static void *lib80211_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
+	priv->rx_tfm_arc4 = crypto_alloc_blkcipher("arc4", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
 		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
@@ -360,6 +361,7 @@ static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
 	struct blkcipher_desc desc = { .tfm = tkey->tx_tfm_arc4 };
+	struct arc4_iv *iv = crypto_blkcipher_crt(tkey->tx_tfm_arc4)->iv;
 	int len;
 	u8 rc4key[16], *pos, *icv;
 	u32 crc;
@@ -392,7 +394,7 @@ static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_blkcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
+	arc4_setup_iv(iv, rc4key, 16);
 	sg_init_one(&sg, pos, len + 4);
 	return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
 }
@@ -414,6 +416,7 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
 	struct blkcipher_desc desc = { .tfm = tkey->rx_tfm_arc4 };
+	struct arc4_iv *iv = crypto_blkcipher_crt(tkey->rx_tfm_arc4)->iv;
 	u8 rc4key[16];
 	u8 keyidx, *pos;
 	u32 iv32;
@@ -485,7 +488,7 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	plen = skb->len - hdr_len - 12;
 
-	crypto_blkcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
+	arc4_setup_iv(iv, rc4key, 16);
 	sg_init_one(&sg, pos, plen + 4);
 	if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4)) {
 		if (net_ratelimit()) {
-- 
1.6.6

