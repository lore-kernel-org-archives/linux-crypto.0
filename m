Return-Path: <SRS0=/v7T=NZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbeKOGYh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Nov 2018 01:24:37 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: drop mask=CRYPTO_ALG_ASYNC from 'cipher' tfm allocations
Date: Wed, 14 Nov 2018 12:19:39 -0800
Message-Id: <20181114201939.97592-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

'cipher' algorithms (single block ciphers) are always synchronous, so
passing CRYPTO_ALG_ASYNC in the mask to crypto_alloc_cipher() has no
effect.  Many users therefore already don't pass it, but some still do.
This inconsistency can cause confusion, especially since the way the
'mask' argument works is somewhat counterintuitive.

Thus, just remove the unneeded CRYPTO_ALG_ASYNC flags.

This patch shouldn't change any actual behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/s390/crypto/aes_s390.c                               | 2 +-
 drivers/crypto/amcc/crypto4xx_alg.c                       | 3 +--
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c                  | 4 +---
 drivers/crypto/geode-aes.c                                | 2 +-
 drivers/md/dm-crypt.c                                     | 2 +-
 drivers/net/wireless/cisco/airo.c                         | 2 +-
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c              | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c | 2 +-
 drivers/usb/wusbcore/crypto.c                             | 2 +-
 net/bluetooth/smp.c                                       | 6 +++---
 net/mac80211/wep.c                                        | 4 ++--
 net/wireless/lib80211_crypt_ccmp.c                        | 2 +-
 net/wireless/lib80211_crypt_tkip.c                        | 4 ++--
 net/wireless/lib80211_crypt_wep.c                         | 4 ++--
 14 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 812d9498d97be..dd456725189f2 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -137,7 +137,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
 	sctx->fallback.cip = crypto_alloc_cipher(name, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+						 CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(sctx->fallback.cip)) {
 		pr_err("Allocating AES fallback algorithm %s failed\n",
diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index f5c07498ea4f0..4092c2aad8e21 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -520,8 +520,7 @@ static int crypto4xx_compute_gcm_hash_key_sw(__le32 *hash_start, const u8 *key,
 	uint8_t src[16] = { 0 };
 	int rc = 0;
 
-	aes_tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC |
-				      CRYPTO_ALG_NEED_FALLBACK);
+	aes_tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(aes_tfm)) {
 		rc = PTR_ERR(aes_tfm);
 		pr_warn("could not load aes cipher driver: %d\n", rc);
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 3c6fe57f91f8c..9108015e56cc5 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -346,9 +346,7 @@ static int ccp_aes_cmac_cra_init(struct crypto_tfm *tfm)
 
 	crypto_ahash_set_reqsize(ahash, sizeof(struct ccp_aes_cmac_req_ctx));
 
-	cipher_tfm = crypto_alloc_cipher("aes", 0,
-					 CRYPTO_ALG_ASYNC |
-					 CRYPTO_ALG_NEED_FALLBACK);
+	cipher_tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(cipher_tfm)) {
 		pr_warn("could not load aes cipher driver\n");
 		return PTR_ERR(cipher_tfm);
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index eb2a0a73cbed1..b4c24a35b3d08 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -261,7 +261,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
 	op->fallback.cip = crypto_alloc_cipher(name, 0,
-				CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+					       CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(op->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b8eec515a003c..a7195eb5b8d89 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -377,7 +377,7 @@ static struct crypto_cipher *alloc_essiv_cipher(struct crypt_config *cc,
 	int err;
 
 	/* Setup the essiv_tfm with the given salt */
-	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
+	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
 	if (IS_ERR(essiv_tfm)) {
 		ti->error = "Error allocating crypto tfm for ESSIV";
 		return essiv_tfm;
diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 04dd7a9365938..6fab69fe6c92c 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -1359,7 +1359,7 @@ static int micsetup(struct airo_info *ai) {
 	int i;
 
 	if (ai->tfm == NULL)
-	        ai->tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+		ai->tfm = crypto_alloc_cipher("aes", 0, 0);
 
         if (IS_ERR(ai->tfm)) {
                 airo_print_err(ai->dev->name, "failed to load transform for AES");
diff --git a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
index bc45cf098b04e..91871503364d4 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
@@ -67,7 +67,7 @@ static void *rtllib_ccmp_init(int key_idx)
 		goto fail;
 	priv->key_idx = key_idx;
 
-	priv->tfm = (void *)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+	priv->tfm = (void *)crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(priv->tfm)) {
 		pr_debug("Could not allocate crypto API aes\n");
 		priv->tfm = NULL;
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
index 041f1b123888b..3534ddb900d1e 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
@@ -71,7 +71,7 @@ static void *ieee80211_ccmp_init(int key_idx)
 		goto fail;
 	priv->key_idx = key_idx;
 
-	priv->tfm = (void *)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+	priv->tfm = (void *)crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(priv->tfm)) {
 		pr_debug("ieee80211_crypt_ccmp: could not allocate crypto API aes\n");
 		priv->tfm = NULL;
diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index 68ddee86a8861..edb7263bff403 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -316,7 +316,7 @@ ssize_t wusb_prf(void *out, size_t out_size,
 		goto error_setkey_cbc;
 	}
 
-	tfm_aes = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+	tfm_aes = crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(tfm_aes)) {
 		result = PTR_ERR(tfm_aes);
 		printk(KERN_ERR "E: can't load AES: %d\n", (int)result);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index c822e626761bd..1f94a25beef69 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1390,7 +1390,7 @@ static struct smp_chan *smp_chan_create(struct l2cap_conn *conn)
 	if (!smp)
 		return NULL;
 
-	smp->tfm_aes = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+	smp->tfm_aes = crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(smp->tfm_aes)) {
 		BT_ERR("Unable to create AES crypto context");
 		goto zfree_smp;
@@ -3233,7 +3233,7 @@ static struct l2cap_chan *smp_add_cid(struct hci_dev *hdev, u16 cid)
 	if (!smp)
 		return ERR_PTR(-ENOMEM);
 
-	tfm_aes = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+	tfm_aes = crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(tfm_aes)) {
 		BT_ERR("Unable to create AES crypto context");
 		kzfree(smp);
@@ -3906,7 +3906,7 @@ int __init bt_selftest_smp(void)
 	struct crypto_kpp *tfm_ecdh;
 	int err;
 
-	tfm_aes = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+	tfm_aes = crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(tfm_aes)) {
 		BT_ERR("Unable to create AES crypto context");
 		return PTR_ERR(tfm_aes);
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 73e8f347802ec..bfe9ed9f4c48d 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -30,13 +30,13 @@ int ieee80211_wep_init(struct ieee80211_local *local)
 	/* start WEP IV from a random value */
 	get_random_bytes(&local->wep_iv, IEEE80211_WEP_IV_LEN);
 
-	local->wep_tx_tfm = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
+	local->wep_tx_tfm = crypto_alloc_cipher("arc4", 0, 0);
 	if (IS_ERR(local->wep_tx_tfm)) {
 		local->wep_rx_tfm = ERR_PTR(-EINVAL);
 		return PTR_ERR(local->wep_tx_tfm);
 	}
 
-	local->wep_rx_tfm = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
+	local->wep_rx_tfm = crypto_alloc_cipher("arc4", 0, 0);
 	if (IS_ERR(local->wep_rx_tfm)) {
 		crypto_free_cipher(local->wep_tx_tfm);
 		local->wep_tx_tfm = ERR_PTR(-EINVAL);
diff --git a/net/wireless/lib80211_crypt_ccmp.c b/net/wireless/lib80211_crypt_ccmp.c
index 6beab0cfcb99e..55214fe925b2a 100644
--- a/net/wireless/lib80211_crypt_ccmp.c
+++ b/net/wireless/lib80211_crypt_ccmp.c
@@ -75,7 +75,7 @@ static void *lib80211_ccmp_init(int key_idx)
 		goto fail;
 	priv->key_idx = key_idx;
 
-	priv->tfm = crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
+	priv->tfm = crypto_alloc_cipher("aes", 0, 0);
 	if (IS_ERR(priv->tfm)) {
 		priv->tfm = NULL;
 		goto fail;
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index b5e235573c8a0..35f06563207dd 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -99,7 +99,7 @@ static void *lib80211_tkip_init(int key_idx)
 
 	priv->key_idx = key_idx;
 
-	priv->tx_tfm_arc4 = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
+	priv->tx_tfm_arc4 = crypto_alloc_cipher("arc4", 0, 0);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
 		priv->tx_tfm_arc4 = NULL;
 		goto fail;
@@ -111,7 +111,7 @@ static void *lib80211_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
+	priv->rx_tfm_arc4 = crypto_alloc_cipher("arc4", 0, 0);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
 		priv->rx_tfm_arc4 = NULL;
 		goto fail;
diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
index 6015f6b542a67..20c1ad63ad446 100644
--- a/net/wireless/lib80211_crypt_wep.c
+++ b/net/wireless/lib80211_crypt_wep.c
@@ -48,13 +48,13 @@ static void *lib80211_wep_init(int keyidx)
 		goto fail;
 	priv->key_idx = keyidx;
 
-	priv->tx_tfm = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
+	priv->tx_tfm = crypto_alloc_cipher("arc4", 0, 0);
 	if (IS_ERR(priv->tx_tfm)) {
 		priv->tx_tfm = NULL;
 		goto fail;
 	}
 
-	priv->rx_tfm = crypto_alloc_cipher("arc4", 0, CRYPTO_ALG_ASYNC);
+	priv->rx_tfm = crypto_alloc_cipher("arc4", 0, 0);
 	if (IS_ERR(priv->rx_tfm)) {
 		priv->rx_tfm = NULL;
 		goto fail;
-- 
2.19.1.930.g4563a0d9d0-goog
