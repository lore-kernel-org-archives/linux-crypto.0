From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 5/7] net/wireless: switch lib80211_crypt_wep from arc4 to arc4blk
Date: Sat,  3 Apr 2010 09:49:27 +0200
Message-ID: <1270280969-11357-6-git-send-email-sebastian@breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53095 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab0DCHtk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Apr 2010 03:49:40 -0400
In-Reply-To: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ecb(arc4) is getting replaced by arc4 which is a blkcipher by itself. The
required selects are now pulled in by LIB80211_CRYPT_WEP instead of
selecting it by every driver. Since there is no dependency on ecb and arc4
therr are removed from the idividual driver.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/net/wireless/hostap/Kconfig  |    3 ---
 drivers/net/wireless/ipw2x00/Kconfig |    3 ---
 net/wireless/Kconfig                 |    2 ++
 net/wireless/lib80211_crypt_wep.c    |   11 +++++++----
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/hostap/Kconfig b/drivers/net/wireless/hostap/Kconfig
index 287d827..dab2c6b 100644
--- a/drivers/net/wireless/hostap/Kconfig
+++ b/drivers/net/wireless/hostap/Kconfig
@@ -4,11 +4,8 @@ config HOSTAP
 	select WEXT_SPY
 	select WEXT_PRIV
 	select CRYPTO
-	select CRYPTO_ARC4
-	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
 	select CRC32
 	select LIB80211
 	select LIB80211_CRYPT_WEP
diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 2715b10..6fe1995 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -158,11 +158,8 @@ config LIBIPW
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select CRYPTO
-	select CRYPTO_ARC4
-	select CRYPTO_ECB
 	select CRYPTO_AES
 	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
 	select CRC32
 	select LIB80211
 	select LIB80211_CRYPT_WEP
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 119f1eb..267eb42 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -141,6 +141,8 @@ config LIB80211
 	  you want this built into your kernel.
 
 config LIB80211_CRYPT_WEP
+	select CRYPTO
+	select CRYPTO_ARC4BLK
 	tristate
 
 config LIB80211_CRYPT_CCMP
diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index 6d41e05..3759e46 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -23,6 +23,7 @@
 #include <net/lib80211.h>
 
 #include <linux/crypto.h>
+#include <crypto/arc4.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
@@ -48,7 +49,7 @@ static void *lib80211_wep_init(int keyidx)
 		goto fail;
 	priv->key_idx = keyidx;
 
-	priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->tx_tfm = crypto_alloc_blkcipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm)) {
 		printk(KERN_DEBUG "lib80211_crypt_wep: could not allocate "
 		       "crypto API arc4\n");
@@ -56,7 +57,7 @@ static void *lib80211_wep_init(int keyidx)
 		goto fail;
 	}
 
-	priv->rx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->rx_tfm = crypto_alloc_blkcipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm)) {
 		printk(KERN_DEBUG "lib80211_crypt_wep: could not allocate "
 		       "crypto API arc4\n");
@@ -139,6 +140,7 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_wep_data *wep = priv;
 	struct blkcipher_desc desc = { .tfm = wep->tx_tfm };
+	struct arc4_iv *iv = crypto_blkcipher_crt(wep->tx_tfm)->iv;
 	u32 crc, klen, len;
 	u8 *pos, *icv;
 	struct scatterlist sg;
@@ -170,7 +172,7 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_blkcipher_setkey(wep->tx_tfm, key, klen);
+	arc4_setup_iv(iv, key, klen);
 	sg_init_one(&sg, pos, len + 4);
 	return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
 }
@@ -186,6 +188,7 @@ static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_wep_data *wep = priv;
 	struct blkcipher_desc desc = { .tfm = wep->rx_tfm };
+	struct arc4_iv *iv = crypto_blkcipher_crt(wep->rx_tfm)->iv;
 	u32 crc, klen, plen;
 	u8 key[WEP_KEY_LEN + 3];
 	u8 keyidx, *pos, icv[4];
@@ -210,7 +213,7 @@ static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	/* Apply RC4 to data and compute CRC32 over decrypted data */
 	plen = skb->len - hdr_len - 8;
 
-	crypto_blkcipher_setkey(wep->rx_tfm, key, klen);
+	arc4_setup_iv(iv, key, klen);
 	sg_init_one(&sg, pos, plen + 4);
 	if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4))
 		return -7;
-- 
1.6.6

