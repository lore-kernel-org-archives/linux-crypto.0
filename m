From: Kees Cook <keescook@chromium.org>
Subject: [PATCH crypto-next 03/23] lib80211: Remove VLA usage of skcipher
Date: Tue, 18 Sep 2018 19:10:40 -0700
Message-ID: <20180919021100.3380-4-keescook@chromium.org>
References: <20180919021100.3380-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919021100.3380-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the quest to remove all stack VLA usage from the kernel[1], this
replaces struct crypto_skcipher and SKCIPHER_REQUEST_ON_STACK() usage
with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
which uses a fixed stack size.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c  | 34 +++++++++----------
 drivers/staging/rtl8192e/rtllib_crypt_wep.c   | 28 +++++++--------
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c | 34 +++++++++----------
 .../rtl8192u/ieee80211/ieee80211_crypt_wep.c  | 26 +++++++-------
 net/wireless/lib80211_crypt_tkip.c            | 34 +++++++++----------
 net/wireless/lib80211_crypt_wep.c             | 28 +++++++--------
 6 files changed, 89 insertions(+), 95 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
index 9f18be14dda6..f38f1f74fcd6 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
@@ -49,9 +49,9 @@ struct rtllib_tkip_data {
 	u32 dot11RSNAStatsTKIPLocalMICFailures;
 
 	int key_idx;
-	struct crypto_skcipher *rx_tfm_arc4;
+	struct crypto_sync_skcipher *rx_tfm_arc4;
 	struct crypto_shash *rx_tfm_michael;
-	struct crypto_skcipher *tx_tfm_arc4;
+	struct crypto_sync_skcipher *tx_tfm_arc4;
 	struct crypto_shash *tx_tfm_michael;
 	/* scratch buffers for virt_to_page() (crypto API) */
 	u8 rx_hdr[16];
@@ -66,8 +66,7 @@ static void *rtllib_tkip_init(int key_idx)
 	if (priv == NULL)
 		goto fail;
 	priv->key_idx = key_idx;
-	priv->tx_tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0,
-						  CRYPTO_ALG_ASYNC);
+	priv->tx_tfm_arc4 = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
 		pr_debug("Could not allocate crypto API arc4\n");
 		priv->tx_tfm_arc4 = NULL;
@@ -81,8 +80,7 @@ static void *rtllib_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0,
-						  CRYPTO_ALG_ASYNC);
+	priv->rx_tfm_arc4 = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
 		pr_debug("Could not allocate crypto API arc4\n");
 		priv->rx_tfm_arc4 = NULL;
@@ -100,9 +98,9 @@ static void *rtllib_tkip_init(int key_idx)
 fail:
 	if (priv) {
 		crypto_free_shash(priv->tx_tfm_michael);
-		crypto_free_skcipher(priv->tx_tfm_arc4);
+		crypto_free_sync_skcipher(priv->tx_tfm_arc4);
 		crypto_free_shash(priv->rx_tfm_michael);
-		crypto_free_skcipher(priv->rx_tfm_arc4);
+		crypto_free_sync_skcipher(priv->rx_tfm_arc4);
 		kfree(priv);
 	}
 
@@ -116,9 +114,9 @@ static void rtllib_tkip_deinit(void *priv)
 
 	if (_priv) {
 		crypto_free_shash(_priv->tx_tfm_michael);
-		crypto_free_skcipher(_priv->tx_tfm_arc4);
+		crypto_free_sync_skcipher(_priv->tx_tfm_arc4);
 		crypto_free_shash(_priv->rx_tfm_michael);
-		crypto_free_skcipher(_priv->rx_tfm_arc4);
+		crypto_free_sync_skcipher(_priv->rx_tfm_arc4);
 	}
 	kfree(priv);
 }
@@ -337,7 +335,7 @@ static int rtllib_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	*pos++ = (tkey->tx_iv32 >> 24) & 0xff;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
 
 		icv = skb_put(skb, 4);
 		crc = ~crc32_le(~0, pos, len);
@@ -349,8 +347,8 @@ static int rtllib_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		sg_init_one(&sg, pos, len+4);
 
 
-		crypto_skcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-		skcipher_request_set_tfm(req, tkey->tx_tfm_arc4);
+		crypto_sync_skcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
+		skcipher_request_set_sync_tfm(req, tkey->tx_tfm_arc4);
 		skcipher_request_set_callback(req, 0, NULL, NULL);
 		skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
 		ret = crypto_skcipher_encrypt(req);
@@ -420,7 +418,7 @@ static int rtllib_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (!tcb_desc->bHwSec || (skb->cb[0] == 1)) {
-		SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
 
 		if ((iv32 < tkey->rx_iv32 ||
 		    (iv32 == tkey->rx_iv32 && iv16 <= tkey->rx_iv16)) &&
@@ -447,8 +445,8 @@ static int rtllib_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 		sg_init_one(&sg, pos, plen+4);
 
-		crypto_skcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-		skcipher_request_set_tfm(req, tkey->rx_tfm_arc4);
+		crypto_sync_skcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
+		skcipher_request_set_sync_tfm(req, tkey->rx_tfm_arc4);
 		skcipher_request_set_callback(req, 0, NULL, NULL);
 		skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
 		err = crypto_skcipher_decrypt(req);
@@ -664,9 +662,9 @@ static int rtllib_tkip_set_key(void *key, int len, u8 *seq, void *priv)
 	struct rtllib_tkip_data *tkey = priv;
 	int keyidx;
 	struct crypto_shash *tfm = tkey->tx_tfm_michael;
-	struct crypto_skcipher *tfm2 = tkey->tx_tfm_arc4;
+	struct crypto_sync_skcipher *tfm2 = tkey->tx_tfm_arc4;
 	struct crypto_shash *tfm3 = tkey->rx_tfm_michael;
-	struct crypto_skcipher *tfm4 = tkey->rx_tfm_arc4;
+	struct crypto_sync_skcipher *tfm4 = tkey->rx_tfm_arc4;
 
 	keyidx = tkey->key_idx;
 	memset(tkey, 0, sizeof(*tkey));
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_wep.c b/drivers/staging/rtl8192e/rtllib_crypt_wep.c
index b3343a5d0fd6..d11ec39171d5 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_wep.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_wep.c
@@ -27,8 +27,8 @@ struct prism2_wep_data {
 	u8 key[WEP_KEY_LEN + 1];
 	u8 key_len;
 	u8 key_idx;
-	struct crypto_skcipher *tx_tfm;
-	struct crypto_skcipher *rx_tfm;
+	struct crypto_sync_skcipher *tx_tfm;
+	struct crypto_sync_skcipher *rx_tfm;
 };
 
 
@@ -41,13 +41,13 @@ static void *prism2_wep_init(int keyidx)
 		goto fail;
 	priv->key_idx = keyidx;
 
-	priv->tx_tfm = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->tx_tfm = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->tx_tfm)) {
 		pr_debug("rtllib_crypt_wep: could not allocate crypto API arc4\n");
 		priv->tx_tfm = NULL;
 		goto fail;
 	}
-	priv->rx_tfm = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->rx_tfm = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->rx_tfm)) {
 		pr_debug("rtllib_crypt_wep: could not allocate crypto API arc4\n");
 		priv->rx_tfm = NULL;
@@ -61,8 +61,8 @@ static void *prism2_wep_init(int keyidx)
 
 fail:
 	if (priv) {
-		crypto_free_skcipher(priv->tx_tfm);
-		crypto_free_skcipher(priv->rx_tfm);
+		crypto_free_sync_skcipher(priv->tx_tfm);
+		crypto_free_sync_skcipher(priv->rx_tfm);
 		kfree(priv);
 	}
 	return NULL;
@@ -74,8 +74,8 @@ static void prism2_wep_deinit(void *priv)
 	struct prism2_wep_data *_priv = priv;
 
 	if (_priv) {
-		crypto_free_skcipher(_priv->tx_tfm);
-		crypto_free_skcipher(_priv->rx_tfm);
+		crypto_free_sync_skcipher(_priv->tx_tfm);
+		crypto_free_sync_skcipher(_priv->rx_tfm);
 	}
 	kfree(priv);
 }
@@ -135,7 +135,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	memcpy(key + 3, wep->key, wep->key_len);
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
 
 		/* Append little-endian CRC32 and encrypt it to produce ICV */
 		crc = ~crc32_le(~0, pos, len);
@@ -146,8 +146,8 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		icv[3] = crc >> 24;
 
 		sg_init_one(&sg, pos, len+4);
-		crypto_skcipher_setkey(wep->tx_tfm, key, klen);
-		skcipher_request_set_tfm(req, wep->tx_tfm);
+		crypto_sync_skcipher_setkey(wep->tx_tfm, key, klen);
+		skcipher_request_set_sync_tfm(req, wep->tx_tfm);
 		skcipher_request_set_callback(req, 0, NULL, NULL);
 		skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
 		err = crypto_skcipher_encrypt(req);
@@ -199,11 +199,11 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 8;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
 
 		sg_init_one(&sg, pos, plen+4);
-		crypto_skcipher_setkey(wep->rx_tfm, key, klen);
-		skcipher_request_set_tfm(req, wep->rx_tfm);
+		crypto_sync_skcipher_setkey(wep->rx_tfm, key, klen);
+		skcipher_request_set_sync_tfm(req, wep->rx_tfm);
 		skcipher_request_set_callback(req, 0, NULL, NULL);
 		skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
 		err = crypto_skcipher_decrypt(req);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
index 1088fa0aee0e..829fa4bd253c 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -53,9 +53,9 @@ struct ieee80211_tkip_data {
 
 	int key_idx;
 
-	struct crypto_skcipher *rx_tfm_arc4;
+	struct crypto_sync_skcipher *rx_tfm_arc4;
 	struct crypto_shash *rx_tfm_michael;
-	struct crypto_skcipher *tx_tfm_arc4;
+	struct crypto_sync_skcipher *tx_tfm_arc4;
 	struct crypto_shash *tx_tfm_michael;
 
 	/* scratch buffers for virt_to_page() (crypto API) */
@@ -71,8 +71,7 @@ static void *ieee80211_tkip_init(int key_idx)
 		goto fail;
 	priv->key_idx = key_idx;
 
-	priv->tx_tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0,
-			CRYPTO_ALG_ASYNC);
+	priv->tx_tfm_arc4 = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
 		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
 				"crypto API arc4\n");
@@ -88,8 +87,7 @@ static void *ieee80211_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0,
-			CRYPTO_ALG_ASYNC);
+	priv->rx_tfm_arc4 = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
 		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
 				"crypto API arc4\n");
@@ -110,9 +108,9 @@ static void *ieee80211_tkip_init(int key_idx)
 fail:
 	if (priv) {
 		crypto_free_shash(priv->tx_tfm_michael);
-		crypto_free_skcipher(priv->tx_tfm_arc4);
+		crypto_free_sync_skcipher(priv->tx_tfm_arc4);
 		crypto_free_shash(priv->rx_tfm_michael);
-		crypto_free_skcipher(priv->rx_tfm_arc4);
+		crypto_free_sync_skcipher(priv->rx_tfm_arc4);
 		kfree(priv);
 	}
 
@@ -126,9 +124,9 @@ static void ieee80211_tkip_deinit(void *priv)
 
 	if (_priv) {
 		crypto_free_shash(_priv->tx_tfm_michael);
-		crypto_free_skcipher(_priv->tx_tfm_arc4);
+		crypto_free_sync_skcipher(_priv->tx_tfm_arc4);
 		crypto_free_shash(_priv->rx_tfm_michael);
-		crypto_free_skcipher(_priv->rx_tfm_arc4);
+		crypto_free_sync_skcipher(_priv->rx_tfm_arc4);
 	}
 	kfree(priv);
 }
@@ -340,7 +338,7 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	*pos++ = (tkey->tx_iv32 >> 24) & 0xff;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
 
 		icv = skb_put(skb, 4);
 		crc = ~crc32_le(~0, pos, len);
@@ -348,9 +346,9 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		icv[1] = crc >> 8;
 		icv[2] = crc >> 16;
 		icv[3] = crc >> 24;
-		crypto_skcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
+		crypto_sync_skcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
 		sg_init_one(&sg, pos, len+4);
-		skcipher_request_set_tfm(req, tkey->tx_tfm_arc4);
+		skcipher_request_set_sync_tfm(req, tkey->tx_tfm_arc4);
 		skcipher_request_set_callback(req, 0, NULL, NULL);
 		skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
 		ret = crypto_skcipher_encrypt(req);
@@ -418,7 +416,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
 
 		if (iv32 < tkey->rx_iv32 ||
 		(iv32 == tkey->rx_iv32 && iv16 <= tkey->rx_iv16)) {
@@ -440,10 +438,10 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 		plen = skb->len - hdr_len - 12;
 
-		crypto_skcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
+		crypto_sync_skcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
 		sg_init_one(&sg, pos, plen+4);
 
-		skcipher_request_set_tfm(req, tkey->rx_tfm_arc4);
+		skcipher_request_set_sync_tfm(req, tkey->rx_tfm_arc4);
 		skcipher_request_set_callback(req, 0, NULL, NULL);
 		skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
 
@@ -663,9 +661,9 @@ static int ieee80211_tkip_set_key(void *key, int len, u8 *seq, void *priv)
 	struct ieee80211_tkip_data *tkey = priv;
 	int keyidx;
 	struct crypto_shash *tfm = tkey->tx_tfm_michael;
-	struct crypto_skcipher *tfm2 = tkey->tx_tfm_arc4;
+	struct crypto_sync_skcipher *tfm2 = tkey->tx_tfm_arc4;
 	struct crypto_shash *tfm3 = tkey->rx_tfm_michael;
-	struct crypto_skcipher *tfm4 = tkey->rx_tfm_arc4;
+	struct crypto_sync_skcipher *tfm4 = tkey->rx_tfm_arc4;
 
 	keyidx = tkey->key_idx;
 	memset(tkey, 0, sizeof(*tkey));
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
index b9f86be9e52b..d4a1bf0caa7a 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
@@ -32,8 +32,8 @@ struct prism2_wep_data {
 	u8 key[WEP_KEY_LEN + 1];
 	u8 key_len;
 	u8 key_idx;
-	struct crypto_skcipher *tx_tfm;
-	struct crypto_skcipher *rx_tfm;
+	struct crypto_sync_skcipher *tx_tfm;
+	struct crypto_sync_skcipher *rx_tfm;
 };
 
 
@@ -46,10 +46,10 @@ static void *prism2_wep_init(int keyidx)
 		return NULL;
 	priv->key_idx = keyidx;
 
-	priv->tx_tfm = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->tx_tfm = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->tx_tfm))
 		goto free_priv;
-	priv->rx_tfm = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->rx_tfm = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->rx_tfm))
 		goto free_tx;
 
@@ -58,7 +58,7 @@ static void *prism2_wep_init(int keyidx)
 
 	return priv;
 free_tx:
-	crypto_free_skcipher(priv->tx_tfm);
+	crypto_free_sync_skcipher(priv->tx_tfm);
 free_priv:
 	kfree(priv);
 	return NULL;
@@ -70,8 +70,8 @@ static void prism2_wep_deinit(void *priv)
 	struct prism2_wep_data *_priv = priv;
 
 	if (_priv) {
-		crypto_free_skcipher(_priv->tx_tfm);
-		crypto_free_skcipher(_priv->rx_tfm);
+		crypto_free_sync_skcipher(_priv->tx_tfm);
+		crypto_free_sync_skcipher(_priv->rx_tfm);
 	}
 	kfree(priv);
 }
@@ -128,7 +128,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	memcpy(key + 3, wep->key, wep->key_len);
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
 
 		/* Append little-endian CRC32 and encrypt it to produce ICV */
 		crc = ~crc32_le(~0, pos, len);
@@ -138,10 +138,10 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		icv[2] = crc >> 16;
 		icv[3] = crc >> 24;
 
-		crypto_skcipher_setkey(wep->tx_tfm, key, klen);
+		crypto_sync_skcipher_setkey(wep->tx_tfm, key, klen);
 		sg_init_one(&sg, pos, len+4);
 
-		skcipher_request_set_tfm(req, wep->tx_tfm);
+		skcipher_request_set_sync_tfm(req, wep->tx_tfm);
 		skcipher_request_set_callback(req, 0, NULL, NULL);
 		skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
 
@@ -193,12 +193,12 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 8;
 
 	if (!tcb_desc->bHwSec) {
-		SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
 
-		crypto_skcipher_setkey(wep->rx_tfm, key, klen);
+		crypto_sync_skcipher_setkey(wep->rx_tfm, key, klen);
 		sg_init_one(&sg, pos, plen+4);
 
-		skcipher_request_set_tfm(req, wep->rx_tfm);
+		skcipher_request_set_sync_tfm(req, wep->rx_tfm);
 		skcipher_request_set_callback(req, 0, NULL, NULL);
 		skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
 
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index e6bce1f130c9..346e19cbdf59 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -64,9 +64,9 @@ struct lib80211_tkip_data {
 
 	int key_idx;
 
-	struct crypto_skcipher *rx_tfm_arc4;
+	struct crypto_sync_skcipher *rx_tfm_arc4;
 	struct crypto_shash *rx_tfm_michael;
-	struct crypto_skcipher *tx_tfm_arc4;
+	struct crypto_sync_skcipher *tx_tfm_arc4;
 	struct crypto_shash *tx_tfm_michael;
 
 	/* scratch buffers for virt_to_page() (crypto API) */
@@ -99,8 +99,7 @@ static void *lib80211_tkip_init(int key_idx)
 
 	priv->key_idx = key_idx;
 
-	priv->tx_tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0,
-						  CRYPTO_ALG_ASYNC);
+	priv->tx_tfm_arc4 = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
 		priv->tx_tfm_arc4 = NULL;
 		goto fail;
@@ -112,8 +111,7 @@ static void *lib80211_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0,
-						  CRYPTO_ALG_ASYNC);
+	priv->rx_tfm_arc4 = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
 		priv->rx_tfm_arc4 = NULL;
 		goto fail;
@@ -130,9 +128,9 @@ static void *lib80211_tkip_init(int key_idx)
       fail:
 	if (priv) {
 		crypto_free_shash(priv->tx_tfm_michael);
-		crypto_free_skcipher(priv->tx_tfm_arc4);
+		crypto_free_sync_skcipher(priv->tx_tfm_arc4);
 		crypto_free_shash(priv->rx_tfm_michael);
-		crypto_free_skcipher(priv->rx_tfm_arc4);
+		crypto_free_sync_skcipher(priv->rx_tfm_arc4);
 		kfree(priv);
 	}
 
@@ -144,9 +142,9 @@ static void lib80211_tkip_deinit(void *priv)
 	struct lib80211_tkip_data *_priv = priv;
 	if (_priv) {
 		crypto_free_shash(_priv->tx_tfm_michael);
-		crypto_free_skcipher(_priv->tx_tfm_arc4);
+		crypto_free_sync_skcipher(_priv->tx_tfm_arc4);
 		crypto_free_shash(_priv->rx_tfm_michael);
-		crypto_free_skcipher(_priv->rx_tfm_arc4);
+		crypto_free_sync_skcipher(_priv->rx_tfm_arc4);
 	}
 	kfree(priv);
 }
@@ -344,7 +342,7 @@ static int lib80211_tkip_hdr(struct sk_buff *skb, int hdr_len,
 static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
 	int len;
 	u8 rc4key[16], *pos, *icv;
 	u32 crc;
@@ -374,9 +372,9 @@ static int lib80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_skcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
+	crypto_sync_skcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
 	sg_init_one(&sg, pos, len + 4);
-	skcipher_request_set_tfm(req, tkey->tx_tfm_arc4);
+	skcipher_request_set_sync_tfm(req, tkey->tx_tfm_arc4);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
 	err = crypto_skcipher_encrypt(req);
@@ -400,7 +398,7 @@ static inline int tkip_replay_check(u32 iv32_n, u16 iv16_n,
 static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_tkip_data *tkey = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
 	u8 rc4key[16];
 	u8 keyidx, *pos;
 	u32 iv32;
@@ -463,9 +461,9 @@ static int lib80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	plen = skb->len - hdr_len - 12;
 
-	crypto_skcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
+	crypto_sync_skcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
 	sg_init_one(&sg, pos, plen + 4);
-	skcipher_request_set_tfm(req, tkey->rx_tfm_arc4);
+	skcipher_request_set_sync_tfm(req, tkey->rx_tfm_arc4);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
 	err = crypto_skcipher_decrypt(req);
@@ -660,9 +658,9 @@ static int lib80211_tkip_set_key(void *key, int len, u8 * seq, void *priv)
 	struct lib80211_tkip_data *tkey = priv;
 	int keyidx;
 	struct crypto_shash *tfm = tkey->tx_tfm_michael;
-	struct crypto_skcipher *tfm2 = tkey->tx_tfm_arc4;
+	struct crypto_sync_skcipher *tfm2 = tkey->tx_tfm_arc4;
 	struct crypto_shash *tfm3 = tkey->rx_tfm_michael;
-	struct crypto_skcipher *tfm4 = tkey->rx_tfm_arc4;
+	struct crypto_sync_skcipher *tfm4 = tkey->rx_tfm_arc4;
 
 	keyidx = tkey->key_idx;
 	memset(tkey, 0, sizeof(*tkey));
diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index d05f58b0fd04..bdadee497f57 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -35,8 +35,8 @@ struct lib80211_wep_data {
 	u8 key[WEP_KEY_LEN + 1];
 	u8 key_len;
 	u8 key_idx;
-	struct crypto_skcipher *tx_tfm;
-	struct crypto_skcipher *rx_tfm;
+	struct crypto_sync_skcipher *tx_tfm;
+	struct crypto_sync_skcipher *rx_tfm;
 };
 
 static void *lib80211_wep_init(int keyidx)
@@ -48,13 +48,13 @@ static void *lib80211_wep_init(int keyidx)
 		goto fail;
 	priv->key_idx = keyidx;
 
-	priv->tx_tfm = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->tx_tfm = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->tx_tfm)) {
 		priv->tx_tfm = NULL;
 		goto fail;
 	}
 
-	priv->rx_tfm = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	priv->rx_tfm = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
 	if (IS_ERR(priv->rx_tfm)) {
 		priv->rx_tfm = NULL;
 		goto fail;
@@ -66,8 +66,8 @@ static void *lib80211_wep_init(int keyidx)
 
       fail:
 	if (priv) {
-		crypto_free_skcipher(priv->tx_tfm);
-		crypto_free_skcipher(priv->rx_tfm);
+		crypto_free_sync_skcipher(priv->tx_tfm);
+		crypto_free_sync_skcipher(priv->rx_tfm);
 		kfree(priv);
 	}
 	return NULL;
@@ -77,8 +77,8 @@ static void lib80211_wep_deinit(void *priv)
 {
 	struct lib80211_wep_data *_priv = priv;
 	if (_priv) {
-		crypto_free_skcipher(_priv->tx_tfm);
-		crypto_free_skcipher(_priv->rx_tfm);
+		crypto_free_sync_skcipher(_priv->tx_tfm);
+		crypto_free_sync_skcipher(_priv->rx_tfm);
 	}
 	kfree(priv);
 }
@@ -129,7 +129,7 @@ static int lib80211_wep_build_iv(struct sk_buff *skb, int hdr_len,
 static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_wep_data *wep = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
 	u32 crc, klen, len;
 	u8 *pos, *icv;
 	struct scatterlist sg;
@@ -162,9 +162,9 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[2] = crc >> 16;
 	icv[3] = crc >> 24;
 
-	crypto_skcipher_setkey(wep->tx_tfm, key, klen);
+	crypto_sync_skcipher_setkey(wep->tx_tfm, key, klen);
 	sg_init_one(&sg, pos, len + 4);
-	skcipher_request_set_tfm(req, wep->tx_tfm);
+	skcipher_request_set_sync_tfm(req, wep->tx_tfm);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
 	err = crypto_skcipher_encrypt(req);
@@ -182,7 +182,7 @@ static int lib80211_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 {
 	struct lib80211_wep_data *wep = priv;
-	SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
 	u32 crc, klen, plen;
 	u8 key[WEP_KEY_LEN + 3];
 	u8 keyidx, *pos, icv[4];
@@ -208,9 +208,9 @@ static int lib80211_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	/* Apply RC4 to data and compute CRC32 over decrypted data */
 	plen = skb->len - hdr_len - 8;
 
-	crypto_skcipher_setkey(wep->rx_tfm, key, klen);
+	crypto_sync_skcipher_setkey(wep->rx_tfm, key, klen);
 	sg_init_one(&sg, pos, plen + 4);
-	skcipher_request_set_tfm(req, wep->rx_tfm);
+	skcipher_request_set_sync_tfm(req, wep->rx_tfm);
 	skcipher_request_set_callback(req, 0, NULL, NULL);
 	skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
 	err = crypto_skcipher_decrypt(req);
-- 
2.17.1
