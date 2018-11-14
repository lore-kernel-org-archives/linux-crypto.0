Return-Path: <SRS0=/v7T=NZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbeKOG0b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Nov 2018 01:26:31 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: drop mask=CRYPTO_ALG_ASYNC from 'shash' tfm allocations
Date: Wed, 14 Nov 2018 12:21:11 -0800
Message-Id: <20181114202111.99005-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

'shash' algorithms are always synchronous, so passing CRYPTO_ALG_ASYNC
in the mask to crypto_alloc_shash() has no effect.  Many users therefore
already don't pass it, but some still do.  This inconsistency can cause
confusion, especially since the way the 'mask' argument works is
somewhat counterintuitive.

Thus, just remove the unneeded CRYPTO_ALG_ASYNC flags.

This patch shouldn't change any actual behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/block/drbd/drbd_receiver.c          | 2 +-
 drivers/md/dm-integrity.c                   | 2 +-
 drivers/net/wireless/intersil/orinoco/mic.c | 6 ++----
 fs/ubifs/auth.c                             | 5 ++---
 net/bluetooth/smp.c                         | 2 +-
 security/apparmor/crypto.c                  | 2 +-
 security/integrity/evm/evm_crypto.c         | 3 +--
 security/keys/encrypted-keys/encrypted.c    | 4 ++--
 security/keys/trusted.c                     | 4 ++--
 9 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 61c392752fe4b..ccfcf00f2798d 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3623,7 +3623,7 @@ static int receive_protocol(struct drbd_connection *connection, struct packet_in
 		 * change.
 		 */
 
-		peer_integrity_tfm = crypto_alloc_shash(integrity_alg, 0, CRYPTO_ALG_ASYNC);
+		peer_integrity_tfm = crypto_alloc_shash(integrity_alg, 0, 0);
 		if (IS_ERR(peer_integrity_tfm)) {
 			peer_integrity_tfm = NULL;
 			drbd_err(connection, "peer data-integrity-alg %s not supported\n",
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index bb3096bf2cc6b..d4ad0bfee2519 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2804,7 +2804,7 @@ static int get_mac(struct crypto_shash **hash, struct alg_spec *a, char **error,
 	int r;
 
 	if (a->alg_string) {
-		*hash = crypto_alloc_shash(a->alg_string, 0, CRYPTO_ALG_ASYNC);
+		*hash = crypto_alloc_shash(a->alg_string, 0, 0);
 		if (IS_ERR(*hash)) {
 			*error = error_alg;
 			r = PTR_ERR(*hash);
diff --git a/drivers/net/wireless/intersil/orinoco/mic.c b/drivers/net/wireless/intersil/orinoco/mic.c
index 08bc7822f8209..709d9ab3e7bcb 100644
--- a/drivers/net/wireless/intersil/orinoco/mic.c
+++ b/drivers/net/wireless/intersil/orinoco/mic.c
@@ -16,8 +16,7 @@
 /********************************************************************/
 int orinoco_mic_init(struct orinoco_private *priv)
 {
-	priv->tx_tfm_mic = crypto_alloc_shash("michael_mic", 0,
-					      CRYPTO_ALG_ASYNC);
+	priv->tx_tfm_mic = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->tx_tfm_mic)) {
 		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
 		       "crypto API michael_mic\n");
@@ -25,8 +24,7 @@ int orinoco_mic_init(struct orinoco_private *priv)
 		return -ENOMEM;
 	}
 
-	priv->rx_tfm_mic = crypto_alloc_shash("michael_mic", 0,
-					      CRYPTO_ALG_ASYNC);
+	priv->rx_tfm_mic = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->rx_tfm_mic)) {
 		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
 		       "crypto API michael_mic\n");
diff --git a/fs/ubifs/auth.c b/fs/ubifs/auth.c
index 124e965a28b30..5bf5fd08879e6 100644
--- a/fs/ubifs/auth.c
+++ b/fs/ubifs/auth.c
@@ -269,8 +269,7 @@ int ubifs_init_authentication(struct ubifs_info *c)
 		goto out;
 	}
 
-	c->hash_tfm = crypto_alloc_shash(c->auth_hash_name, 0,
-					 CRYPTO_ALG_ASYNC);
+	c->hash_tfm = crypto_alloc_shash(c->auth_hash_name, 0, 0);
 	if (IS_ERR(c->hash_tfm)) {
 		err = PTR_ERR(c->hash_tfm);
 		ubifs_err(c, "Can not allocate %s: %d",
@@ -286,7 +285,7 @@ int ubifs_init_authentication(struct ubifs_info *c)
 		goto out_free_hash;
 	}
 
-	c->hmac_tfm = crypto_alloc_shash(hmac_name, 0, CRYPTO_ALG_ASYNC);
+	c->hmac_tfm = crypto_alloc_shash(hmac_name, 0, 0);
 	if (IS_ERR(c->hmac_tfm)) {
 		err = PTR_ERR(c->hmac_tfm);
 		ubifs_err(c, "Can not allocate %s: %d", hmac_name, err);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 1f94a25beef69..621146d04c038 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -3912,7 +3912,7 @@ int __init bt_selftest_smp(void)
 		return PTR_ERR(tfm_aes);
 	}
 
-	tfm_cmac = crypto_alloc_shash("cmac(aes)", 0, CRYPTO_ALG_ASYNC);
+	tfm_cmac = crypto_alloc_shash("cmac(aes)", 0, 0);
 	if (IS_ERR(tfm_cmac)) {
 		BT_ERR("Unable to create CMAC crypto context");
 		crypto_free_cipher(tfm_aes);
diff --git a/security/apparmor/crypto.c b/security/apparmor/crypto.c
index 136f2a0478367..af03d98c75520 100644
--- a/security/apparmor/crypto.c
+++ b/security/apparmor/crypto.c
@@ -112,7 +112,7 @@ static int __init init_profile_hash(void)
 	if (!apparmor_initialized)
 		return 0;
 
-	tfm = crypto_alloc_shash("sha1", 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_shash("sha1", 0, 0);
 	if (IS_ERR(tfm)) {
 		int error = PTR_ERR(tfm);
 		AA_ERROR("failed to setup profile sha1 hashing: %d\n", error);
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 8c25f949ebdb6..1820099dc74bf 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -97,8 +97,7 @@ static struct shash_desc *init_desc(char type, uint8_t hash_algo)
 		mutex_lock(&mutex);
 		if (*tfm)
 			goto out;
-		*tfm = crypto_alloc_shash(algo, 0,
-					  CRYPTO_ALG_ASYNC | CRYPTO_NOLOAD);
+		*tfm = crypto_alloc_shash(algo, 0, CRYPTO_NOLOAD);
 		if (IS_ERR(*tfm)) {
 			rc = PTR_ERR(*tfm);
 			pr_err("Can not allocate %s (reason: %ld)\n", algo, rc);
diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index d92cbf9687c33..a3891ae9fa0fc 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -342,7 +342,7 @@ static int calc_hmac(u8 *digest, const u8 *key, unsigned int keylen,
 	struct crypto_shash *tfm;
 	int err;
 
-	tfm = crypto_alloc_shash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
+	tfm = crypto_alloc_shash(hmac_alg, 0, 0);
 	if (IS_ERR(tfm)) {
 		pr_err("encrypted_key: can't alloc %s transform: %ld\n",
 		       hmac_alg, PTR_ERR(tfm));
@@ -984,7 +984,7 @@ static int __init init_encrypted(void)
 {
 	int ret;
 
-	hash_tfm = crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
+	hash_tfm = crypto_alloc_shash(hash_alg, 0, 0);
 	if (IS_ERR(hash_tfm)) {
 		pr_err("encrypted_key: can't allocate %s transform: %ld\n",
 		       hash_alg, PTR_ERR(hash_tfm));
diff --git a/security/keys/trusted.c b/security/keys/trusted.c
index ff6789365a12f..2d4f16b2a7c55 100644
--- a/security/keys/trusted.c
+++ b/security/keys/trusted.c
@@ -1199,14 +1199,14 @@ static int __init trusted_shash_alloc(void)
 {
 	int ret;
 
-	hmacalg = crypto_alloc_shash(hmac_alg, 0, CRYPTO_ALG_ASYNC);
+	hmacalg = crypto_alloc_shash(hmac_alg, 0, 0);
 	if (IS_ERR(hmacalg)) {
 		pr_info("trusted_key: could not allocate crypto %s\n",
 			hmac_alg);
 		return PTR_ERR(hmacalg);
 	}
 
-	hashalg = crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);
+	hashalg = crypto_alloc_shash(hash_alg, 0, 0);
 	if (IS_ERR(hashalg)) {
 		pr_info("trusted_key: could not allocate crypto %s\n",
 			hash_alg);
-- 
2.19.1.930.g4563a0d9d0-goog
