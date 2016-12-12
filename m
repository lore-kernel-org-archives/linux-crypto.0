From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH] orinoco: Use shash instead of ahash for MIC calculations
Date: Mon, 12 Dec 2016 12:55:55 -0800
Message-ID: <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Andy Lutomirski <luto@kernel.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752138AbcLLUz7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2016 15:55:59 -0500
In-Reply-To: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers pointed out that the orinoco driver pointed scatterlists
at the stack.

Fix it by switching from ahash to shash.  The result should be
simpler, faster, and more correct.

Cc: stable@vger.kernel.org # 4.9 only
Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---

Compile-tested only.

drivers/net/wireless/intersil/orinoco/mic.c     | 44 +++++++++++++++----------
 drivers/net/wireless/intersil/orinoco/mic.h     |  3 +-
 drivers/net/wireless/intersil/orinoco/orinoco.h |  4 +--
 3 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/mic.c b/drivers/net/wireless/intersil/orinoco/mic.c
index bc7397d709d3..08bc7822f820 100644
--- a/drivers/net/wireless/intersil/orinoco/mic.c
+++ b/drivers/net/wireless/intersil/orinoco/mic.c
@@ -16,7 +16,7 @@
 /********************************************************************/
 int orinoco_mic_init(struct orinoco_private *priv)
 {
-	priv->tx_tfm_mic = crypto_alloc_ahash("michael_mic", 0,
+	priv->tx_tfm_mic = crypto_alloc_shash("michael_mic", 0,
 					      CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_mic)) {
 		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
@@ -25,7 +25,7 @@ int orinoco_mic_init(struct orinoco_private *priv)
 		return -ENOMEM;
 	}
 
-	priv->rx_tfm_mic = crypto_alloc_ahash("michael_mic", 0,
+	priv->rx_tfm_mic = crypto_alloc_shash("michael_mic", 0,
 					      CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm_mic)) {
 		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
@@ -40,17 +40,16 @@ int orinoco_mic_init(struct orinoco_private *priv)
 void orinoco_mic_free(struct orinoco_private *priv)
 {
 	if (priv->tx_tfm_mic)
-		crypto_free_ahash(priv->tx_tfm_mic);
+		crypto_free_shash(priv->tx_tfm_mic);
 	if (priv->rx_tfm_mic)
-		crypto_free_ahash(priv->rx_tfm_mic);
+		crypto_free_shash(priv->rx_tfm_mic);
 }
 
-int orinoco_mic(struct crypto_ahash *tfm_michael, u8 *key,
+int orinoco_mic(struct crypto_shash *tfm_michael, u8 *key,
 		u8 *da, u8 *sa, u8 priority,
 		u8 *data, size_t data_len, u8 *mic)
 {
-	AHASH_REQUEST_ON_STACK(req, tfm_michael);
-	struct scatterlist sg[2];
+	SHASH_DESC_ON_STACK(desc, tfm_michael);
 	u8 hdr[ETH_HLEN + 2]; /* size of header + padding */
 	int err;
 
@@ -67,18 +66,27 @@ int orinoco_mic(struct crypto_ahash *tfm_michael, u8 *key,
 	hdr[ETH_ALEN * 2 + 2] = 0;
 	hdr[ETH_ALEN * 2 + 3] = 0;
 
-	/* Use scatter gather to MIC header and data in one go */
-	sg_init_table(sg, 2);
-	sg_set_buf(&sg[0], hdr, sizeof(hdr));
-	sg_set_buf(&sg[1], data, data_len);
+	desc->tfm = tfm_michael;
+	desc->flags = 0;
 
-	if (crypto_ahash_setkey(tfm_michael, key, MIC_KEYLEN))
-		return -1;
+	err = crypto_shash_setkey(tfm_michael, key, MIC_KEYLEN);
+	if (err)
+		return err;
+
+	err = crypto_shash_init(desc);
+	if (err)
+		return err;
+
+	err = crypto_shash_update(desc, hdr, sizeof(hdr));
+	if (err)
+		return err;
+
+	err = crypto_shash_update(desc, data, data_len);
+	if (err)
+		return err;
+
+	err = crypto_shash_final(desc, mic);
+	shash_desc_zero(desc);
 
-	ahash_request_set_tfm(req, tfm_michael);
-	ahash_request_set_callback(req, 0, NULL, NULL);
-	ahash_request_set_crypt(req, sg, mic, data_len + sizeof(hdr));
-	err = crypto_ahash_digest(req);
-	ahash_request_zero(req);
 	return err;
 }
diff --git a/drivers/net/wireless/intersil/orinoco/mic.h b/drivers/net/wireless/intersil/orinoco/mic.h
index ce731d05cc98..e8724e889219 100644
--- a/drivers/net/wireless/intersil/orinoco/mic.h
+++ b/drivers/net/wireless/intersil/orinoco/mic.h
@@ -6,6 +6,7 @@
 #define _ORINOCO_MIC_H_
 
 #include <linux/types.h>
+#include <crypto/hash.h>
 
 #define MICHAEL_MIC_LEN 8
 
@@ -15,7 +16,7 @@ struct crypto_ahash;
 
 int orinoco_mic_init(struct orinoco_private *priv);
 void orinoco_mic_free(struct orinoco_private *priv);
-int orinoco_mic(struct crypto_ahash *tfm_michael, u8 *key,
+int orinoco_mic(struct crypto_shash *tfm_michael, u8 *key,
 		u8 *da, u8 *sa, u8 priority,
 		u8 *data, size_t data_len, u8 *mic);
 
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco.h b/drivers/net/wireless/intersil/orinoco/orinoco.h
index 2f0c84b1c440..5fa1c3e3713f 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco.h
+++ b/drivers/net/wireless/intersil/orinoco/orinoco.h
@@ -152,8 +152,8 @@ struct orinoco_private {
 	u8 *wpa_ie;
 	int wpa_ie_len;
 
-	struct crypto_ahash *rx_tfm_mic;
-	struct crypto_ahash *tx_tfm_mic;
+	struct crypto_shash *rx_tfm_mic;
+	struct crypto_shash *tx_tfm_mic;
 
 	unsigned int wpa_enabled:1;
 	unsigned int tkip_cm_active:1;
-- 
2.9.3
