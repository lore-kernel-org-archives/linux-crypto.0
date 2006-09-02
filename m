From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/7] [CRYPTO] users: Use crypto_hash interface instead of crypto_digest
Date: Sat, 02 Sep 2006 21:06:48 +1000
Message-ID: <E1GJTKq-0001Fe-00@gondolin.me.apana.org.au>
References: <20060902110520.GA4690@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42256 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1751051AbWIBLGp
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Sep 2006 07:06:45 -0400
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Michal Ludvig <michal@logix.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] users: Use crypto_hash interface instead of crypto_digest

This patch converts all remaining crypto_digest users to use the new
crypto_hash interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/md/dm-crypt.c                 |   30 ++++++++++++++------------
 drivers/net/ppp_mppe.c                |   34 +++++++++++++++++++-----------
 fs/nfsd/nfs4recover.c                 |   21 +++++++++---------
 net/ieee80211/ieee80211_crypt_tkip.c  |   25 ++++++++++++----------
 net/sunrpc/auth_gss/gss_krb5_crypto.c |   38 +++++++++++++++++++++-------------
 security/seclvl.c                     |   18 ++++++++--------
 6 files changed, 97 insertions(+), 69 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -122,7 +122,8 @@ static int crypt_iv_essiv_ctr(struct cry
 	                      const char *opts)
 {
 	struct crypto_cipher *essiv_tfm;
-	struct crypto_tfm *hash_tfm;
+	struct crypto_hash *hash_tfm;
+	struct hash_desc desc;
 	struct scatterlist sg;
 	unsigned int saltsize;
 	u8 *salt;
@@ -134,29 +135,30 @@ static int crypt_iv_essiv_ctr(struct cry
 	}
 
 	/* Hash the cipher key with the given hash algorithm */
-	hash_tfm = crypto_alloc_tfm(opts, CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (hash_tfm == NULL) {
+	hash_tfm = crypto_alloc_hash(opts, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(hash_tfm)) {
 		ti->error = "Error initializing ESSIV hash";
-		return -EINVAL;
-	}
-
-	if (crypto_tfm_alg_type(hash_tfm) != CRYPTO_ALG_TYPE_DIGEST) {
-		ti->error = "Expected digest algorithm for ESSIV hash";
-		crypto_free_tfm(hash_tfm);
-		return -EINVAL;
+		return PTR_ERR(hash_tfm);
 	}
 
-	saltsize = crypto_tfm_alg_digestsize(hash_tfm);
+	saltsize = crypto_hash_digestsize(hash_tfm);
 	salt = kmalloc(saltsize, GFP_KERNEL);
 	if (salt == NULL) {
 		ti->error = "Error kmallocing salt storage in ESSIV";
-		crypto_free_tfm(hash_tfm);
+		crypto_free_hash(hash_tfm);
 		return -ENOMEM;
 	}
 
 	sg_set_buf(&sg, cc->key, cc->key_size);
-	crypto_digest_digest(hash_tfm, &sg, 1, salt);
-	crypto_free_tfm(hash_tfm);
+	desc.tfm = hash_tfm;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = crypto_hash_digest(&desc, &sg, cc->key_size, salt);
+	crypto_free_hash(hash_tfm);
+
+	if (err) {
+		ti->error = "Error calculating hash in ESSIV";
+		return err;
+	}
 
 	/* Setup the essiv_tfm with the given salt */
 	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
diff --git a/drivers/net/ppp_mppe.c b/drivers/net/ppp_mppe.c
--- a/drivers/net/ppp_mppe.c
+++ b/drivers/net/ppp_mppe.c
@@ -65,12 +65,13 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_ALIAS("ppp-compress-" __stringify(CI_MPPE));
 MODULE_VERSION("1.0.2");
 
-static void
+static unsigned int
 setup_sg(struct scatterlist *sg, const void *address, unsigned int length)
 {
 	sg[0].page = virt_to_page(address);
 	sg[0].offset = offset_in_page(address);
 	sg[0].length = length;
+	return length;
 }
 
 #define SHA1_PAD_SIZE 40
@@ -97,7 +98,7 @@ static inline void sha_pad_init(struct s
  */
 struct ppp_mppe_state {
 	struct crypto_blkcipher *arc4;
-	struct crypto_tfm *sha1;
+	struct crypto_hash *sha1;
 	unsigned char *sha1_digest;
 	unsigned char master_key[MPPE_MAX_KEY_LEN];
 	unsigned char session_key[MPPE_MAX_KEY_LEN];
@@ -137,14 +138,21 @@ struct ppp_mppe_state {
  */
 static void get_new_key_from_sha(struct ppp_mppe_state * state, unsigned char *InterimKey)
 {
+	struct hash_desc desc;
 	struct scatterlist sg[4];
+	unsigned int nbytes;
 
-	setup_sg(&sg[0], state->master_key, state->keylen);
-	setup_sg(&sg[1], sha_pad->sha_pad1, sizeof(sha_pad->sha_pad1));
-	setup_sg(&sg[2], state->session_key, state->keylen);
-	setup_sg(&sg[3], sha_pad->sha_pad2, sizeof(sha_pad->sha_pad2));
+	nbytes = setup_sg(&sg[0], state->master_key, state->keylen);
+	nbytes += setup_sg(&sg[1], sha_pad->sha_pad1,
+			   sizeof(sha_pad->sha_pad1));
+	nbytes += setup_sg(&sg[2], state->session_key, state->keylen);
+	nbytes += setup_sg(&sg[3], sha_pad->sha_pad2,
+			   sizeof(sha_pad->sha_pad2));
 
-	crypto_digest_digest (state->sha1, sg, 4, state->sha1_digest);
+	desc.tfm = state->sha1;
+	desc.flags = 0;
+
+	crypto_hash_digest(&desc, sg, nbytes, state->sha1_digest);
 
 	memcpy(InterimKey, state->sha1_digest, state->keylen);
 }
@@ -204,11 +212,13 @@ static void *mppe_alloc(unsigned char *o
 		goto out_free;
 	}
 
-	state->sha1 = crypto_alloc_tfm("sha1", 0);
-	if (!state->sha1)
+	state->sha1 = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(state->sha1)) {
+		state->sha1 = NULL;
 		goto out_free;
+	}
 
-	digestsize = crypto_tfm_alg_digestsize(state->sha1);
+	digestsize = crypto_hash_digestsize(state->sha1);
 	if (digestsize < MPPE_MAX_KEY_LEN)
 		goto out_free;
 
@@ -233,7 +243,7 @@ static void *mppe_alloc(unsigned char *o
 	    if (state->sha1_digest)
 		kfree(state->sha1_digest);
 	    if (state->sha1)
-		crypto_free_tfm(state->sha1);
+		crypto_free_hash(state->sha1);
 	    if (state->arc4)
 		crypto_free_blkcipher(state->arc4);
 	    kfree(state);
@@ -251,7 +261,7 @@ static void mppe_free(void *arg)
 	    if (state->sha1_digest)
 		kfree(state->sha1_digest);
 	    if (state->sha1)
-		crypto_free_tfm(state->sha1);
+		crypto_free_hash(state->sha1);
 	    if (state->arc4)
 		crypto_free_blkcipher(state->arc4);
 	    kfree(state);
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -33,7 +33,7 @@
 *
 */
 
-
+#include <linux/err.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfs4.h>
@@ -87,34 +87,35 @@ int
 nfs4_make_rec_clidname(char *dname, struct xdr_netobj *clname)
 {
 	struct xdr_netobj cksum;
-	struct crypto_tfm *tfm;
+	struct hash_desc desc;
 	struct scatterlist sg[1];
 	int status = nfserr_resource;
 
 	dprintk("NFSD: nfs4_make_rec_clidname for %.*s\n",
 			clname->len, clname->data);
-	tfm = crypto_alloc_tfm("md5", CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (tfm == NULL)
-		goto out;
-	cksum.len = crypto_tfm_alg_digestsize(tfm);
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	desc.tfm = crypto_alloc_hash("md5", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc.tfm))
+		goto out_no_tfm;
+	cksum.len = crypto_hash_digestsize(desc.tfm);
 	cksum.data = kmalloc(cksum.len, GFP_KERNEL);
 	if (cksum.data == NULL)
  		goto out;
-	crypto_digest_init(tfm);
 
 	sg[0].page = virt_to_page(clname->data);
 	sg[0].offset = offset_in_page(clname->data);
 	sg[0].length = clname->len;
 
-	crypto_digest_update(tfm, sg, 1);
-	crypto_digest_final(tfm, cksum.data);
+	if (crypto_hash_digest(&desc, sg, sg->length, cksum.data))
+		goto out;
 
 	md5_to_hex(dname, cksum.data);
 
 	kfree(cksum.data);
 	status = nfs_ok;
 out:
-	crypto_free_tfm(tfm);
+	crypto_free_hash(desc.tfm);
+out_no_tfm:
 	return status;
 }
 
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -54,7 +54,7 @@ struct ieee80211_tkip_data {
 	int key_idx;
 
 	struct crypto_blkcipher *tfm_arc4;
-	struct crypto_tfm *tfm_michael;
+	struct crypto_hash *tfm_michael;
 
 	/* scratch buffers for virt_to_page() (crypto API) */
 	u8 rx_hdr[16], tx_hdr[16];
@@ -95,10 +95,12 @@ static void *ieee80211_tkip_init(int key
 		goto fail;
 	}
 
-	priv->tfm_michael = crypto_alloc_tfm("michael_mic", 0);
-	if (priv->tfm_michael == NULL) {
+	priv->tfm_michael = crypto_alloc_hash("michael_mic", 0,
+					      CRYPTO_ALG_ASYNC);
+	if (IS_ERR(priv->tfm_michael)) {
 		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
 		       "crypto API michael_mic\n");
+		priv->tfm_michael = NULL;
 		goto fail;
 	}
 
@@ -107,7 +109,7 @@ static void *ieee80211_tkip_init(int key
       fail:
 	if (priv) {
 		if (priv->tfm_michael)
-			crypto_free_tfm(priv->tfm_michael);
+			crypto_free_hash(priv->tfm_michael);
 		if (priv->tfm_arc4)
 			crypto_free_blkcipher(priv->tfm_arc4);
 		kfree(priv);
@@ -120,7 +122,7 @@ static void ieee80211_tkip_deinit(void *
 {
 	struct ieee80211_tkip_data *_priv = priv;
 	if (_priv && _priv->tfm_michael)
-		crypto_free_tfm(_priv->tfm_michael);
+		crypto_free_hash(_priv->tfm_michael);
 	if (_priv && _priv->tfm_arc4)
 		crypto_free_blkcipher(_priv->tfm_arc4);
 	kfree(priv);
@@ -485,6 +487,7 @@ static int ieee80211_tkip_decrypt(struct
 static int michael_mic(struct ieee80211_tkip_data *tkey, u8 * key, u8 * hdr,
 		       u8 * data, size_t data_len, u8 * mic)
 {
+	struct hash_desc desc;
 	struct scatterlist sg[2];
 
 	if (tkey->tfm_michael == NULL) {
@@ -499,12 +502,12 @@ static int michael_mic(struct ieee80211_
 	sg[1].offset = offset_in_page(data);
 	sg[1].length = data_len;
 
-	crypto_digest_init(tkey->tfm_michael);
-	crypto_digest_setkey(tkey->tfm_michael, key, 8);
-	crypto_digest_update(tkey->tfm_michael, sg, 2);
-	crypto_digest_final(tkey->tfm_michael, mic);
+	if (crypto_hash_setkey(tkey->tfm_michael, key, 8))
+		return -1;
 
-	return 0;
+	desc.tfm = tkey->tfm_michael;
+	desc.flags = 0;
+	return crypto_hash_digest(&desc, sg, data_len + 16, mic);
 }
 
 static void michael_mic_hdr(struct sk_buff *skb, u8 * hdr)
@@ -628,7 +631,7 @@ static int ieee80211_tkip_set_key(void *
 {
 	struct ieee80211_tkip_data *tkey = priv;
 	int keyidx;
-	struct crypto_tfm *tfm = tkey->tfm_michael;
+	struct crypto_hash *tfm = tkey->tfm_michael;
 	struct crypto_blkcipher *tfm2 = tkey->tfm_arc4;
 
 	keyidx = tkey->key_idx;
diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -34,6 +34,7 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 
+#include <linux/err.h>
 #include <linux/types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -199,11 +200,9 @@ out:
 static int
 checksummer(struct scatterlist *sg, void *data)
 {
-	struct crypto_tfm *tfm = (struct crypto_tfm *)data;
+	struct hash_desc *desc = data;
 
-	crypto_digest_update(tfm, sg, 1);
-
-	return 0;
+	return crypto_hash_update(desc, sg, sg->length);
 }
 
 /* checksum the plaintext data and hdrlen bytes of the token header */
@@ -212,8 +211,9 @@ make_checksum(s32 cksumtype, char *heade
 		   int body_offset, struct xdr_netobj *cksum)
 {
 	char                            *cksumname;
-	struct crypto_tfm               *tfm = NULL; /* XXX add to ctx? */
+	struct hash_desc                desc; /* XXX add to ctx? */
 	struct scatterlist              sg[1];
+	int err;
 
 	switch (cksumtype) {
 		case CKSUMTYPE_RSA_MD5:
@@ -224,18 +224,28 @@ make_checksum(s32 cksumtype, char *heade
 				" unsupported checksum %d", cksumtype);
 			return GSS_S_FAILURE;
 	}
-	if (!(tfm = crypto_alloc_tfm(cksumname, CRYPTO_TFM_REQ_MAY_SLEEP)))
+	desc.tfm = crypto_alloc_hash(cksumname, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc.tfm))
 		return GSS_S_FAILURE;
-	cksum->len = crypto_tfm_alg_digestsize(tfm);
+	cksum->len = crypto_hash_digestsize(desc.tfm);
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	crypto_digest_init(tfm);
+	err = crypto_hash_init(&desc);
+	if (err)
+		goto out;
 	sg_set_buf(sg, header, hdrlen);
-	crypto_digest_update(tfm, sg, 1);
-	process_xdr_buf(body, body_offset, body->len - body_offset,
-			checksummer, tfm);
-	crypto_digest_final(tfm, cksum->data);
-	crypto_free_tfm(tfm);
-	return 0;
+	err = crypto_hash_update(&desc, sg, hdrlen);
+	if (err)
+		goto out;
+	err = process_xdr_buf(body, body_offset, body->len - body_offset,
+			      checksummer, &desc);
+	if (err)
+		goto out;
+	err = crypto_hash_final(&desc, cksum->data);
+
+out:
+	crypto_free_hash(desc.tfm);
+	return err ? GSS_S_FAILURE : 0;
 }
 
 EXPORT_SYMBOL(make_checksum);
diff --git a/security/seclvl.c b/security/seclvl.c
--- a/security/seclvl.c
+++ b/security/seclvl.c
@@ -16,6 +16,7 @@
  *	(at your option) any later version.
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -197,26 +198,27 @@ static unsigned char hashedPassword[SHA1
 static int
 plaintext_to_sha1(unsigned char *hash, const char *plaintext, unsigned int len)
 {
-	struct crypto_tfm *tfm;
+	struct hash_desc desc;
 	struct scatterlist sg;
+	int err;
+
 	if (len > PAGE_SIZE) {
 		seclvl_printk(0, KERN_ERR, "Plaintext password too large (%d "
 			      "characters).  Largest possible is %lu "
 			      "bytes.\n", len, PAGE_SIZE);
 		return -EINVAL;
 	}
-	tfm = crypto_alloc_tfm("sha1", CRYPTO_TFM_REQ_MAY_SLEEP);
-	if (tfm == NULL) {
+	desc.tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(desc.tfm)) {
 		seclvl_printk(0, KERN_ERR,
 			      "Failed to load transform for SHA1\n");
 		return -EINVAL;
 	}
 	sg_init_one(&sg, (u8 *)plaintext, len);
-	crypto_digest_init(tfm);
-	crypto_digest_update(tfm, &sg, 1);
-	crypto_digest_final(tfm, hash);
-	crypto_free_tfm(tfm);
-	return 0;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	err = crypto_hash_digest(&desc, &sg, len, hash);
+	crypto_free_hash(desc.tfm);
+	return err;
 }
 
 /**

-- 
VGER BF report: H 1.55961e-11
