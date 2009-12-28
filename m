From: Max Vozeler <max@hinterhof.net>
Subject: [PATCH 2/4] dm-crypt: multi tfm mode
Date: Mon, 28 Dec 2009 19:59:13 +0100
Message-ID: <1262026755-23056-3-git-send-email-max@hinterhof.net>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net>
Cc: linux-crypto@nl.linux.org, Max Vozeler <max@hinterhof.net>,
	Milan Broz <mbroz@redhat.com>,
	Jari Ruusu <jariruusu@users.sourceforge.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.nusquama.org ([85.131.211.20]:32862 "EHLO
	mail.nusquama.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZL1Tcz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 14:32:55 -0500
In-Reply-To: <1262026755-23056-1-git-send-email-max@hinterhof.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Introduces a mode for dm-crypt which uses multiple
encryption keys (and thus tfms) alternating based on
the sector number and the number of keys.

This change is needed to support loop-AES compatible
block chaining modes, which use "multi:64".

Signed-off-by: Max Vozeler <max@hinterhof.net>
Cc: Milan Broz <mbroz@redhat.com>
Cc: Jari Ruusu <jariruusu@users.sourceforge.net>
---
 Documentation/device-mapper/dm-crypt.txt |    3 +-
 drivers/md/dm-crypt.c                    |  138 +++++++++++++++++++++++++----
 2 files changed, 121 insertions(+), 20 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index 6680cab..0d57442 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -8,11 +8,12 @@ Parameters: <cipher> <key> <iv_offset> <device path> <offset>
 
 <cipher>
     Encryption cipher and an optional IV generation mode.
-    (In format cipher-chainmode-ivopts:ivmode).
+    (In format cipher-chainmode-ivopts:ivmode-multi:nkeys).
     Examples:
        des
        aes-cbc-essiv:sha256
        twofish-ecb
+       aes-lmk3-plain64-multi:64
 
     /proc/crypto contains supported crypto modes
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index e783f93..a7c7c22 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
+#include <asm/div64.h>
 
 #include <linux/device-mapper.h>
 
@@ -120,6 +121,12 @@ struct crypt_config {
 	unsigned int iv_size;
 
 	/*
+	 * crypto context selection
+	 */
+	struct crypto_ablkcipher **tfms;
+	unsigned long numtfms;
+
+	/*
 	 * Layout of each crypto request:
 	 *
 	 *   struct ablkcipher_request
@@ -137,7 +144,6 @@ struct crypt_config {
 
 	char cipher[CRYPTO_MAX_ALG_NAME];
 	char chainmode[CRYPTO_MAX_ALG_NAME];
-	struct crypto_ablkcipher *tfm;
 	unsigned long flags;
 	unsigned int key_size;
 	u8 key[0];
@@ -273,7 +279,7 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 		goto bad;
 	}
 	if (crypto_cipher_blocksize(essiv_tfm) !=
-	    crypto_ablkcipher_ivsize(cc->tfm)) {
+	    crypto_ablkcipher_ivsize(cc->tfms[0])) {
 		ti->error = "Block size of ESSIV cipher does "
 			    "not match IV size of block cipher";
 		err = -EINVAL;
@@ -306,7 +312,7 @@ static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv, sector_t sector)
 static int crypt_iv_benbi_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	unsigned bs = crypto_ablkcipher_blocksize(cc->tfm);
+	unsigned bs = crypto_ablkcipher_blocksize(cc->tfms[0]);
 	int log = ilog2(bs);
 
 	/* we need to calculate how far we must shift the sector count
@@ -376,6 +382,56 @@ static struct crypt_iv_operations crypt_iv_null_ops = {
 	.generator = crypt_iv_null_gen
 };
 
+static void crypt_free_tfms(struct crypt_config *cc)
+{
+	int i;
+
+	for (i=0; i < cc->numtfms; i++)
+		if (cc->tfms[i])
+			crypto_free_ablkcipher(cc->tfms[i]);
+
+	kfree(cc->tfms);
+}
+
+static int crypt_alloc_tfms(struct crypt_config *cc, struct dm_target *ti, char *ciphermode)
+{
+	struct crypto_ablkcipher **tfms;
+	int i;
+
+	tfms = kcalloc(cc->numtfms, sizeof(*tfms), GFP_KERNEL);
+	if (!tfms)
+		return -ENOMEM;
+
+	for (i=0; i < cc->numtfms; i++) {
+		struct crypto_ablkcipher *tfm;
+
+		tfm = crypto_alloc_ablkcipher(ciphermode, 0, 0);
+		if (IS_ERR(tfm)) {
+			crypt_free_tfms(cc);
+
+			ti->error = "Error allocating crypto tfm";
+			return PTR_ERR(tfm);
+		}
+
+		tfms[i] = tfm;
+	}
+
+	cc->tfms = tfms;
+
+	return 0;
+}
+
+static struct crypto_ablkcipher *crypt_select_tfm(struct crypt_config *cc,
+						  struct convert_context *ctx)
+{
+	if (cc->numtfms == 1)
+		return cc->tfms[0];
+	else {
+		sector_t tmp = ctx->sector;
+		return cc->tfms[do_div(tmp, cc->numtfms)];
+	}
+}
+
 static void crypt_convert_init(struct crypt_config *cc,
 			       struct convert_context *ctx,
 			       struct bio *bio_out, struct bio *bio_in,
@@ -415,7 +471,7 @@ static int crypt_convert_block(struct crypt_config *cc,
 
 	dmreq = dmreq_of_req(cc, req);
 	iv = (u8 *)ALIGN((unsigned long)(dmreq + 1),
-			 crypto_ablkcipher_alignmask(cc->tfm) + 1);
+			 crypto_ablkcipher_alignmask(cc->tfms[0]) + 1);
 
 	dmreq->ctx = ctx;
 	sg_init_table(&dmreq->sg_in, 1);
@@ -460,9 +516,15 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
+	struct crypto_ablkcipher *tfm;
+
 	if (!cc->req)
 		cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
-	ablkcipher_request_set_tfm(cc->req, cc->tfm);
+
+	tfm = crypt_select_tfm(cc, ctx);
+
+	ablkcipher_request_set_tfm(cc->req, tfm);
+
 	ablkcipher_request_set_callback(cc->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 					CRYPTO_TFM_REQ_MAY_SLEEP,
 					kcryptd_async_done,
@@ -974,6 +1036,21 @@ static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
 	}
 }
 
+static int crypt_set_subkeys(struct crypt_config *cc, const u8 *key)
+{
+	int i, err = 0;
+	unsigned subkey_size = cc->key_size / cc->numtfms;
+
+	for (i=0; i < cc->numtfms; i++) {
+		err = crypto_ablkcipher_setkey(cc->tfms[i],
+				cc->key + (i * subkey_size), subkey_size);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
 static int crypt_set_key(struct crypt_config *cc, char *key)
 {
 	unsigned key_size = strlen(key) >> 1;
@@ -989,14 +1066,15 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 
 	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 
-	return crypto_ablkcipher_setkey(cc->tfm, cc->key, cc->key_size);
+	return crypt_set_subkeys(cc, cc->key);
 }
 
 static int crypt_wipe_key(struct crypt_config *cc)
 {
 	clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
 	memset(&cc->key, 0, cc->key_size * sizeof(u8));
-	return crypto_ablkcipher_setkey(cc->tfm, cc->key, cc->key_size);
+
+	return crypt_set_subkeys(cc, cc->key);
 }
 
 /*
@@ -1006,12 +1084,13 @@ static int crypt_wipe_key(struct crypt_config *cc)
 static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct crypt_config *cc;
-	struct crypto_ablkcipher *tfm;
 	char *tmp;
 	char *cipher;
 	char *chainmode;
 	char *ivmode;
 	char *ivopts;
+	char *tfmmode;
+	char *tfmopts;
 	unsigned int key_size;
 	unsigned long long tmpll;
 	char ciphermode[CRYPTO_MAX_ALG_NAME];
@@ -1026,6 +1105,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	chainmode = strsep(&tmp, "-");
 	ivopts = strsep(&tmp, "-");
 	ivmode = strsep(&ivopts, ":");
+	tfmopts = strsep(&tmp, "-");
+	tfmmode = strsep(&tfmopts, ":");
 
 	if (tmp)
 		DMWARN("Unexpected additional cipher options");
@@ -1056,15 +1137,32 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_cipher;
 	}
 
-	tfm = crypto_alloc_ablkcipher(ciphermode, 0, 0);
-	if (IS_ERR(tfm)) {
-		ti->error = "Error allocating crypto tfm";
+	strcpy(cc->cipher, cipher);
+	strcpy(cc->chainmode, chainmode);
+
+	/*
+	 * Choose multi key mode. Valid modes: "single", "multi:<n>"
+	 */
+
+	if (tfmmode == NULL || strcmp(tfmmode, "single") == 0)
+		cc->numtfms =  1;
+	else if (strcmp(tfmmode, "multi") == 0) {
+		if (tfmopts == NULL) {
+			ti->error = "Number of keys missing for multi-tfm mode";
+			return -EINVAL;
+		}
+
+		if (strict_strtoul(tfmopts, 10, &cc->numtfms) < 0) {
+			ti->error = "Number of keys badly formatted";
+			return -EINVAL;
+		}
+	} else {
+		ti->error = "Invalid tfm mode";
 		goto bad_cipher;
 	}
 
-	strcpy(cc->cipher, cipher);
-	strcpy(cc->chainmode, chainmode);
-	cc->tfm = tfm;
+	if (crypt_alloc_tfms(cc, ti, ciphermode) < 0)
+		goto bad_cipher;
 
 	if (crypt_set_key(cc, argv[1]) < 0) {
 		ti->error = "Error decoding and setting key";
@@ -1103,7 +1201,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_slab_pool;
 	}
 
-	cc->iv_size = crypto_ablkcipher_ivsize(tfm);
+	cc->iv_size = crypto_ablkcipher_ivsize(cc->tfms[0]);
 	if (cc->iv_size)
 		/* at least a 64 bit sector number should fit in our buffer */
 		cc->iv_size = max(cc->iv_size,
@@ -1124,9 +1222,9 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	cc->dmreq_start = sizeof(struct ablkcipher_request);
-	cc->dmreq_start += crypto_ablkcipher_reqsize(tfm);
+	cc->dmreq_start += crypto_ablkcipher_reqsize(cc->tfms[0]);
 	cc->dmreq_start = ALIGN(cc->dmreq_start, crypto_tfm_ctx_alignment());
-	cc->dmreq_start += crypto_ablkcipher_alignmask(tfm) &
+	cc->dmreq_start += crypto_ablkcipher_alignmask(cc->tfms[0]) &
 			   ~(crypto_tfm_ctx_alignment() - 1);
 
 	cc->req_pool = mempool_create_kmalloc_pool(MIN_IOS, cc->dmreq_start +
@@ -1213,7 +1311,7 @@ bad_slab_pool:
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
 bad_ivmode:
-	crypto_free_ablkcipher(tfm);
+	crypt_free_tfms(cc);
 bad_cipher:
 	/* Must zero key material before freeing */
 	kzfree(cc);
@@ -1238,7 +1336,9 @@ static void crypt_dtr(struct dm_target *ti)
 	kfree(cc->iv_mode);
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
-	crypto_free_ablkcipher(cc->tfm);
+
+	crypt_free_tfms(cc);
+
 	dm_put_device(ti, cc->dev);
 
 	/* Must zero key material before freeing */
-- 
1.6.5.4

