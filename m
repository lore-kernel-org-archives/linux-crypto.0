From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 15/18] staging: rtl8192e: ieee80211: Convert from ahash to shash
Date: Tue, 24 Jul 2018 09:49:33 -0700
Message-ID: <20180724164936.37477-16-keescook@chromium.org>
References: <20180724164936.37477-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Howells <dhowe
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724164936.37477-1-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is an identical change to the wireless/lib80211 of the same name.
In preparing to remove all stack VLA usage from the kernel[1], this
removes the discouraged use of AHASH_REQUEST_ON_STACK in favor of
the smaller SHASH_DESC_ON_STACK by converting from ahash-wrapped-shash
to direct shash. By removing a layer of indirection this both improves
performance and reduces stack usage. The stack allocation will be made
a fixed size in a later patch to the crypto subsystem.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c | 56 ++++++++++----------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
index ae103b0b7a2a..9f18be14dda6 100644
--- a/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/rtllib_crypt_tkip.c
@@ -50,9 +50,9 @@ struct rtllib_tkip_data {
 
 	int key_idx;
 	struct crypto_skcipher *rx_tfm_arc4;
-	struct crypto_ahash *rx_tfm_michael;
+	struct crypto_shash *rx_tfm_michael;
 	struct crypto_skcipher *tx_tfm_arc4;
-	struct crypto_ahash *tx_tfm_michael;
+	struct crypto_shash *tx_tfm_michael;
 	/* scratch buffers for virt_to_page() (crypto API) */
 	u8 rx_hdr[16];
 	u8 tx_hdr[16];
@@ -74,8 +74,7 @@ static void *rtllib_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->tx_tfm_michael = crypto_alloc_ahash("michael_mic", 0,
-						  CRYPTO_ALG_ASYNC);
+	priv->tx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->tx_tfm_michael)) {
 		pr_debug("Could not allocate crypto API michael_mic\n");
 		priv->tx_tfm_michael = NULL;
@@ -90,8 +89,7 @@ static void *rtllib_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_michael = crypto_alloc_ahash("michael_mic", 0,
-						  CRYPTO_ALG_ASYNC);
+	priv->rx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->rx_tfm_michael)) {
 		pr_debug("Could not allocate crypto API michael_mic\n");
 		priv->rx_tfm_michael = NULL;
@@ -101,9 +99,9 @@ static void *rtllib_tkip_init(int key_idx)
 
 fail:
 	if (priv) {
-		crypto_free_ahash(priv->tx_tfm_michael);
+		crypto_free_shash(priv->tx_tfm_michael);
 		crypto_free_skcipher(priv->tx_tfm_arc4);
-		crypto_free_ahash(priv->rx_tfm_michael);
+		crypto_free_shash(priv->rx_tfm_michael);
 		crypto_free_skcipher(priv->rx_tfm_arc4);
 		kfree(priv);
 	}
@@ -117,9 +115,9 @@ static void rtllib_tkip_deinit(void *priv)
 	struct rtllib_tkip_data *_priv = priv;
 
 	if (_priv) {
-		crypto_free_ahash(_priv->tx_tfm_michael);
+		crypto_free_shash(_priv->tx_tfm_michael);
 		crypto_free_skcipher(_priv->tx_tfm_arc4);
-		crypto_free_ahash(_priv->rx_tfm_michael);
+		crypto_free_shash(_priv->rx_tfm_michael);
 		crypto_free_skcipher(_priv->rx_tfm_arc4);
 	}
 	kfree(priv);
@@ -504,29 +502,31 @@ static int rtllib_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 }
 
 
-static int michael_mic(struct crypto_ahash *tfm_michael, u8 *key, u8 *hdr,
+static int michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
 		       u8 *data, size_t data_len, u8 *mic)
 {
-	AHASH_REQUEST_ON_STACK(req, tfm_michael);
-	struct scatterlist sg[2];
+	SHASH_DESC_ON_STACK(desc, tfm_michael);
 	int err;
 
-	if (tfm_michael == NULL) {
-		pr_warn("michael_mic: tfm_michael == NULL\n");
-		return -1;
-	}
-	sg_init_table(sg, 2);
-	sg_set_buf(&sg[0], hdr, 16);
-	sg_set_buf(&sg[1], data, data_len);
+	desc->tfm = tfm_michael;
+	desc->flags = 0;
 
-	if (crypto_ahash_setkey(tfm_michael, key, 8))
+	if (crypto_shash_setkey(tfm_michael, key, 8))
 		return -1;
 
-	ahash_request_set_tfm(req, tfm_michael);
-	ahash_request_set_callback(req, 0, NULL, NULL);
-	ahash_request_set_crypt(req, sg, mic, data_len + 16);
-	err = crypto_ahash_digest(req);
-	ahash_request_zero(req);
+	err = crypto_shash_init(desc);
+	if (err)
+		goto out;
+	err = crypto_shash_update(desc, hdr, 16);
+	if (err)
+		goto out;
+	err = crypto_shash_update(desc, data, data_len);
+	if (err)
+		goto out;
+	err = crypto_shash_final(desc, mic);
+
+out:
+	shash_desc_zero(desc);
 	return err;
 }
 
@@ -663,9 +663,9 @@ static int rtllib_tkip_set_key(void *key, int len, u8 *seq, void *priv)
 {
 	struct rtllib_tkip_data *tkey = priv;
 	int keyidx;
-	struct crypto_ahash *tfm = tkey->tx_tfm_michael;
+	struct crypto_shash *tfm = tkey->tx_tfm_michael;
 	struct crypto_skcipher *tfm2 = tkey->tx_tfm_arc4;
-	struct crypto_ahash *tfm3 = tkey->rx_tfm_michael;
+	struct crypto_shash *tfm3 = tkey->rx_tfm_michael;
 	struct crypto_skcipher *tfm4 = tkey->rx_tfm_arc4;
 
 	keyidx = tkey->key_idx;
-- 
2.17.1
