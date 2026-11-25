Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795577091;
	b=DJw19lrrJwfXtg/ey1MOlndZDKblzxsn3jlbBtuoW8oHKxyAweNIz1jNh84IPPZ8d/mi
	 KzmDQlwSkMHQTK6Cc7NPZc69uNIwbEifIQdAeRqrD42f31RMKFnkuQndo6aOO9E00n9Oz
	 eKFnAHnXd0bbY5UvPck6IdjKIdazU66NnLlejz8xWM6F20ieIRMWyuOkR44g+aVEf8lZw
	 31XLzSjXbQfLhL13Rp0icoCjihNb/IT6FiQKWkgzPRoP50XGK9A8lxlfeK9/l6GJ5GO19
	 U25eoI1nPQQOzBxd//ACOCvM4QcbIatOSdLXIjEK7wJRbukysl7FialwosRDRJUcLuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795577091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZP2lSXAsATyWfi/nGt5rQaGwkUL0dXYcA/noCKIRtXw=;
	b=yWSMN3n+EP3HMubfe+LUpH/JNOn4uwvabHXb3erCZTqw7JFs14gkp0DJds2EwieDg8fY
	 RzyzSSj8hlEvsL77RzeLNFTg04seUd3lnnZSEqD42MQQrjvmJMKyIOWHhdtYcKMkvKJ1U
	 1NL7XM3J0dGmcjHd98Jzs1CxcGZw9COOR/squGDC0bDHc3GSSwoqATvGtjMArA6nZvrVE
	 ewhUxYKEA1x8CK32JV/osSF1ctdfot7eEXzU/AcyQ/UYkOpK3IThznVW0ZZqA7UCCDIt6
	 MOvhTGkg+pKGnhHdkRhCb+olsp2g3MZTk6OvV8TW+Rk55CZVWHaT3t0ilgktmB1srCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjLvSmAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2BB606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 03:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CjLvSmAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39C11F000C4;
	Wed, 25 Nov 2026 03:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795577091;
	bh=ZP2lSXAsATyWfi/nGt5rQaGwkUL0dXYcA/noCKIRtXw=;
	h=From:To:Cc:Subject:Date;
	b=CjLvSmAWGpTgibFmpNl035B9RzFK/eQaCcWhz+2aFgHDrq0t53EPCx5iowQozt/dM
	 1WagxjXVVj98m1ZOtAzZp5lxICfLl+2JBlC1Kcyi/o55vl8F5DDlIWUrtOpzk0j5Me
	 VB/Q81g701oJURBjplHeYn96haU9JX4FnazJEapilWExt+EfhHTRkXY8nf/+SnFLYC
	 yz97WL9599/vWpBZV/65CTN9eRwdbzchVcIODQduKI3xKXct356yZhn54L5Nos5sBV
	 bBXEg+9wK0ahjZDkitLmL+53mE+WU+obvETH6HEbtY8SegURd9A1CTEHhj76Sa+Bi4
	 zxFAcNVU42vXw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: adiantum - Use the AES library
Date: Tue, 24 Nov 2026 19:24:07 -0800
Message-ID: <20261125032407.126634-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the adiantum template to use the AES library instead of
crypto_cipher.  This simplifies the code and also improves performance.

This necessarily does drop the support for non-AES block ciphers from
"adiantum" (specifically, other crypto_ciphers with a 32-byte key size
and 16-byte block size).  Such instances were technically possible to
create but are not known to be used, nor were they tested or documented
in any user-facing documentation.  The cryptsetup documentation, all
online sources I could find, and all in-kernel references to "adiantum"
all use either "adiantum(xchacha12,aes)", or rarely
"adiantum(xchacha20,aes)".  And the Adiantum paper defines Adiantum to
use XChaCha12 and AES-256; anything else is not actually Adiantum.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig    |   1 +
 crypto/adiantum.c | 125 +++++++++++++++-------------------------------
 2 files changed, 40 insertions(+), 86 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6682ac091b387..7cac0141a73cb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -579,6 +579,7 @@ menu "Length-preserving ciphers and modes"
 config CRYPTO_ADIANTUM
 	tristate "Adiantum"
 	select CRYPTO_CHACHA20
+	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_NH
 	select CRYPTO_LIB_POLY1305
 	select CRYPTO_LIB_POLY1305_GENERIC
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index 825958c6e4769..5e16d2c4699b6 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -16,30 +16,18 @@
  *	Adiantum: length-preserving encryption for entry-level processors
  *      (https://eprint.iacr.org/2018/720.pdf)
  *
- * For flexibility, this implementation also allows other ciphers:
- *
- *	- Stream cipher: XChaCha12 or XChaCha20
- *	- Block cipher: any with a 128-bit block size and 256-bit key
+ * This implementation also allows XChaCha20 to be used instead of XChaCha12.
  */
 
+#include <crypto/aes.h>
 #include <crypto/b128ops.h>
 #include <crypto/chacha.h>
-#include <crypto/internal/cipher.h>
 #include <crypto/internal/poly1305.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/nh.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 
-/*
- * Size of right-hand part of input data, in bytes; also the size of the block
- * cipher's block size and the hash function's output.
- */
-#define BLOCKCIPHER_BLOCK_SIZE		16
-
-/* Size of the block cipher key (K_E) in bytes */
-#define BLOCKCIPHER_KEY_SIZE		32
-
 /* Size of the hash key (K_H) in bytes */
 #define HASH_KEY_SIZE		(2 * POLY1305_BLOCK_SIZE + NH_KEY_BYTES)
 
@@ -54,12 +42,11 @@
 
 struct adiantum_instance_ctx {
 	struct crypto_skcipher_spawn streamcipher_spawn;
-	struct crypto_cipher_spawn blockcipher_spawn;
 };
 
 struct adiantum_tfm_ctx {
+	struct aes_key aes;
 	struct crypto_skcipher *streamcipher;
-	struct crypto_cipher *blockcipher;
 	union {
 		struct {
 			struct poly1305_core_key header_hash_key;
@@ -67,7 +54,7 @@ struct adiantum_tfm_ctx {
 			u32 nh_key[NH_KEY_WORDS];
 		};
 		/* Used only during adiantum_setkey() */
-		u8 derived_keys[BLOCKCIPHER_KEY_SIZE + HASH_KEY_SIZE];
+		u8 derived_keys[AES_KEYSIZE_256 + HASH_KEY_SIZE];
 	};
 };
 
@@ -139,21 +126,15 @@ static int adiantum_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		goto out;
 
 	/* Set the block cipher key (K_E) */
-	crypto_cipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK);
-	crypto_cipher_set_flags(tctx->blockcipher,
-				crypto_skcipher_get_flags(tfm) &
-				CRYPTO_TFM_REQ_MASK);
-	err = crypto_cipher_setkey(tctx->blockcipher, tctx->derived_keys,
-				   BLOCKCIPHER_KEY_SIZE);
-	if (err)
+	err = aes_preparekey(&tctx->aes, tctx->derived_keys, AES_KEYSIZE_256);
+	if (WARN_ON_ONCE(err))
 		goto out;
 
 	/* Set the hash key (K_H) */
-	memcpy(poly_keys, &tctx->derived_keys[BLOCKCIPHER_KEY_SIZE],
+	memcpy(poly_keys, &tctx->derived_keys[AES_KEYSIZE_256],
 	       2 * POLY1305_BLOCK_SIZE);
 	memmove(tctx->nh_key,
-		&tctx->derived_keys[BLOCKCIPHER_KEY_SIZE +
-				    2 * POLY1305_BLOCK_SIZE],
+		&tctx->derived_keys[AES_KEYSIZE_256 + 2 * POLY1305_BLOCK_SIZE],
 		NH_KEY_BYTES);
 	poly1305_core_setkey(&tctx->header_hash_key, &poly_keys[0]);
 	poly1305_core_setkey(&tctx->msg_poly_key,
@@ -206,7 +187,7 @@ static void adiantum_hash_header(struct skcipher_request *req, le128 *out)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
-	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	const unsigned int bulk_len = req->cryptlen - AES_BLOCK_SIZE;
 	struct {
 		__le64 message_bits;
 		__le64 padding;
@@ -349,7 +330,7 @@ static void adiantum_hash_message(struct skcipher_request *req,
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
-	unsigned int len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	unsigned int len = req->cryptlen - AES_BLOCK_SIZE;
 	struct scatter_walk walk;
 
 	nhpoly1305_init(&rctx->u.hash_ctx);
@@ -369,7 +350,7 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct adiantum_request_ctx *rctx = skcipher_request_ctx(req);
-	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	const unsigned int bulk_len = req->cryptlen - AES_BLOCK_SIZE;
 	struct scatterlist *src = req->src, *dst = req->dst;
 	/*
 	 * Buffer for right-hand part of data, i.e.
@@ -388,7 +369,7 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 	unsigned int stream_len;
 	int err;
 
-	if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
+	if (req->cryptlen < AES_BLOCK_SIZE)
 		return -EINVAL;
 
 	/*
@@ -417,11 +398,10 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 
 	/* If encrypting, encrypt P_M with the block cipher to get C_M */
 	if (enc)
-		crypto_cipher_encrypt_one(tctx->blockcipher, rbuf.bytes,
-					  rbuf.bytes);
+		aes_encrypt(&tctx->aes, rbuf.bytes, rbuf.bytes);
 
 	/* Initialize the rest of the XChaCha IV (first part is C_M) */
-	BUILD_BUG_ON(BLOCKCIPHER_BLOCK_SIZE != 16);
+	BUILD_BUG_ON(AES_BLOCK_SIZE != 16);
 	BUILD_BUG_ON(XCHACHA_IV_SIZE != 32);	/* nonce || stream position */
 	rbuf.words[4] = cpu_to_le32(1);
 	rbuf.words[5] = 0;
@@ -452,8 +432,7 @@ static int adiantum_crypt(struct skcipher_request *req, bool enc)
 
 	/* If decrypting, decrypt C_M with the block cipher to get P_M */
 	if (!enc)
-		crypto_cipher_decrypt_one(tctx->blockcipher, rbuf.bytes,
-					  rbuf.bytes);
+		aes_decrypt(&tctx->aes, rbuf.bytes, rbuf.bytes);
 
 	/*
 	 * Second hash step
@@ -499,26 +478,17 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 	struct adiantum_instance_ctx *ictx = skcipher_instance_ctx(inst);
 	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *streamcipher;
-	struct crypto_cipher *blockcipher;
-	int err;
 
 	streamcipher = crypto_spawn_skcipher(&ictx->streamcipher_spawn);
 	if (IS_ERR(streamcipher))
 		return PTR_ERR(streamcipher);
 	if (WARN_ON(crypto_skcipher_reqsize(streamcipher) >
 		    MAX_SYNC_SKCIPHER_REQSIZE)) {
-		err = -EINVAL;
-		goto err_free_streamcipher;
-	}
-
-	blockcipher = crypto_spawn_cipher(&ictx->blockcipher_spawn);
-	if (IS_ERR(blockcipher)) {
-		err = PTR_ERR(blockcipher);
-		goto err_free_streamcipher;
+		crypto_free_skcipher(streamcipher);
+		return -EINVAL;
 	}
 
 	tctx->streamcipher = streamcipher;
-	tctx->blockcipher = blockcipher;
 
 	BUILD_BUG_ON(offsetofend(struct adiantum_request_ctx, u) !=
 		     sizeof(struct adiantum_request_ctx));
@@ -528,10 +498,6 @@ static int adiantum_init_tfm(struct crypto_skcipher *tfm)
 				     u.streamcipher_req) +
 				 crypto_skcipher_reqsize(streamcipher)));
 	return 0;
-
-err_free_streamcipher:
-	crypto_free_skcipher(streamcipher);
-	return err;
 }
 
 static void adiantum_exit_tfm(struct crypto_skcipher *tfm)
@@ -539,7 +505,6 @@ static void adiantum_exit_tfm(struct crypto_skcipher *tfm)
 	struct adiantum_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_skcipher(tctx->streamcipher);
-	crypto_free_cipher(tctx->blockcipher);
 }
 
 static void adiantum_free_instance(struct skcipher_instance *inst)
@@ -547,7 +512,6 @@ static void adiantum_free_instance(struct skcipher_instance *inst)
 	struct adiantum_instance_ctx *ictx = skcipher_instance_ctx(inst);
 
 	crypto_drop_skcipher(&ictx->streamcipher_spawn);
-	crypto_drop_cipher(&ictx->blockcipher_spawn);
 	kfree(inst);
 }
 
@@ -557,16 +521,15 @@ static void adiantum_free_instance(struct skcipher_instance *inst)
  */
 static bool
 adiantum_supported_algorithms(struct skcipher_alg_common *streamcipher_alg,
-			      struct crypto_alg *blockcipher_alg)
+			      const char *blockcipher_name)
 {
 	if (strcmp(streamcipher_alg->base.cra_name, "xchacha12") != 0 &&
 	    strcmp(streamcipher_alg->base.cra_name, "xchacha20") != 0)
 		return false;
 
-	if (blockcipher_alg->cra_cipher.cia_min_keysize > BLOCKCIPHER_KEY_SIZE ||
-	    blockcipher_alg->cra_cipher.cia_max_keysize < BLOCKCIPHER_KEY_SIZE)
-		return false;
-	if (blockcipher_alg->cra_blocksize != BLOCKCIPHER_BLOCK_SIZE)
+	if (strcmp(blockcipher_name, "aes") != 0 &&
+	    /* This is to support the usage by testmgr. */
+	    strcmp(blockcipher_name, "aes-lib") != 0)
 		return false;
 
 	return true;
@@ -578,7 +541,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	struct skcipher_instance *inst;
 	struct adiantum_instance_ctx *ictx;
 	struct skcipher_alg_common *streamcipher_alg;
-	struct crypto_alg *blockcipher_alg;
+	const char *blockcipher_name;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
@@ -590,7 +553,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 		return -ENOMEM;
 	ictx = skcipher_instance_ctx(inst);
 
-	/* Stream cipher, e.g. "xchacha12" */
+	/* Stream cipher: "xchacha12" or "xchacha20" */
 	err = crypto_grab_skcipher(&ictx->streamcipher_spawn,
 				   skcipher_crypto_instance(inst),
 				   crypto_attr_alg_name(tb[1]), 0,
@@ -600,13 +563,12 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 		goto err_free_inst;
 	streamcipher_alg = crypto_spawn_skcipher_alg_common(&ictx->streamcipher_spawn);
 
-	/* Block cipher, e.g. "aes" */
-	err = crypto_grab_cipher(&ictx->blockcipher_spawn,
-				 skcipher_crypto_instance(inst),
-				 crypto_attr_alg_name(tb[2]), 0, mask);
-	if (err)
+	/* Block cipher: "aes" */
+	blockcipher_name = crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(blockcipher_name)) {
+		err = PTR_ERR(blockcipher_name);
 		goto err_free_inst;
-	blockcipher_alg = crypto_spawn_cipher_alg(&ictx->blockcipher_spawn);
+	}
 
 	/*
 	 * Originally there was an optional third parameter, for requesting a
@@ -619,11 +581,9 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	}
 
 	/* Check the set of algorithms */
-	if (!adiantum_supported_algorithms(streamcipher_alg, blockcipher_alg)) {
-		pr_warn("Unsupported Adiantum instantiation: (%s,%s)\n",
-			streamcipher_alg->base.cra_name,
-			blockcipher_alg->cra_name);
-		err = -EINVAL;
+	if (!adiantum_supported_algorithms(streamcipher_alg,
+					   blockcipher_name)) {
+		err = -ENOENT;
 		goto err_free_inst;
 	}
 
@@ -631,26 +591,19 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
-		     "adiantum(%s,%s)", streamcipher_alg->base.cra_name,
-		     blockcipher_alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
+		     "adiantum(%s,aes)",
+		     streamcipher_alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "adiantum(%s,%s)", streamcipher_alg->base.cra_driver_name,
-		     blockcipher_alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		     "adiantum(%s,aes-lib)",
+		     streamcipher_alg->base.cra_driver_name) >=
+	    CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
-	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
+	inst->alg.base.cra_blocksize = AES_BLOCK_SIZE;
 	inst->alg.base.cra_ctxsize = sizeof(struct adiantum_tfm_ctx);
 	inst->alg.base.cra_alignmask = streamcipher_alg->base.cra_alignmask;
-	/*
-	 * The block cipher is only invoked once per message, so for long
-	 * messages (e.g. sectors for disk encryption) its performance doesn't
-	 * matter as much as that of the stream cipher.  Thus, weigh the block
-	 * cipher's ->cra_priority less.
-	 */
-	inst->alg.base.cra_priority = (4 * streamcipher_alg->base.cra_priority +
-				       blockcipher_alg->cra_priority) /
-				      5;
+	inst->alg.base.cra_priority = streamcipher_alg->base.cra_priority;
 
 	inst->alg.setkey = adiantum_setkey;
 	inst->alg.encrypt = adiantum_encrypt;
@@ -671,7 +624,7 @@ static int adiantum_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return err;
 }
 
-/* adiantum(streamcipher_name, blockcipher_name) */
+/* adiantum(xchacha12,aes) or adiantum(xchacha20,aes) */
 static struct crypto_template adiantum_tmpl = {
 	.name = "adiantum",
 	.create = adiantum_create,

base-commit: 04cd6899aaaeeab82afb97e58eb8619fde35b47d
prerequisite-patch-id: 5268ec1436ad909487f950765a39a0cc6eac0c6a
-- 
2.56.1

