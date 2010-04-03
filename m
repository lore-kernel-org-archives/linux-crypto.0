From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 6/7] net/mac80211: convert wep from arc4 to arc4blk
Date: Sat,  3 Apr 2010 09:49:28 +0200
Message-ID: <1270280969-11357-7-git-send-email-sebastian@breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53103 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414Ab0DCHtl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Apr 2010 03:49:41 -0400
In-Reply-To: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

ecb(arc4) is getting replaced by arc4 which is a blkcipher by itself.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 net/mac80211/Kconfig |    3 +--
 net/mac80211/wep.c   |   11 +++++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index a10d508..d14fe06 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -2,8 +2,7 @@ config MAC80211
 	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
 	depends on CFG80211
 	select CRYPTO
-	select CRYPTO_ECB
-	select CRYPTO_ARC4
+	select CRYPTO_ARC4BLK
 	select CRYPTO_AES
 	select CRC32
 	---help---
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 247123f..4314b50 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/mm.h>
 #include <linux/scatterlist.h>
+#include <crypto/arc4.h>
 #include <asm/unaligned.h>
 
 #include <net/mac80211.h>
@@ -29,12 +30,12 @@ int ieee80211_wep_init(struct ieee80211_local *local)
 	/* start WEP IV from a random value */
 	get_random_bytes(&local->wep_iv, WEP_IV_LEN);
 
-	local->wep_tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
+	local->wep_tx_tfm = crypto_alloc_blkcipher("arc4", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(local->wep_tx_tfm))
 		return PTR_ERR(local->wep_tx_tfm);
 
-	local->wep_rx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
+	local->wep_rx_tfm = crypto_alloc_blkcipher("arc4", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(local->wep_rx_tfm)) {
 		crypto_free_blkcipher(local->wep_tx_tfm);
@@ -125,13 +126,14 @@ void ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 				size_t klen, u8 *data, size_t data_len)
 {
 	struct blkcipher_desc desc = { .tfm = tfm };
+	struct arc4_iv *iv = crypto_blkcipher_crt(tfm)->iv;
 	struct scatterlist sg;
 	__le32 icv;
 
 	icv = cpu_to_le32(~crc32_le(~0, data, data_len));
 	put_unaligned(icv, (__le32 *)(data + data_len));
 
-	crypto_blkcipher_setkey(tfm, rc4key, klen);
+	arc4_setup_iv(iv, rc4key, klen);
 	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
 	crypto_blkcipher_encrypt(&desc, &sg, &sg, sg.length);
 }
@@ -181,10 +183,11 @@ int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len)
 {
 	struct blkcipher_desc desc = { .tfm = tfm };
+	struct arc4_iv *iv = crypto_blkcipher_crt(tfm)->iv;
 	struct scatterlist sg;
 	__le32 crc;
 
-	crypto_blkcipher_setkey(tfm, rc4key, klen);
+	arc4_setup_iv(iv, rc4key, klen);
 	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
 	crypto_blkcipher_decrypt(&desc, &sg, &sg, sg.length);
 
-- 
1.6.6

