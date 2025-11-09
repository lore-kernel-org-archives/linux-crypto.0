Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93339279334;
	Sun,  9 Nov 2025 23:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762732199; cv=none; b=oUpOngq0ajoJZSTohvMzHgjDF1juEl12DcKh6Z0/BTDLgBcWoYX7iYWCen3gtEwEwWTG/2k+C4HwNCVmhaxDNi4/OnfGxQ5KKSxWKssIMjUp8cxmmMOhzb/lWX46+utfdtU4zbirlV44kxN05VsukYh0cBNHbIrqYBXRmSOKP+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762732199; c=relaxed/simple;
	bh=2leaOrFbqznRLU4+BYb8NBfLyGhNn4xW0et6YGcfWf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MCosg9xpK0RWU4tCmOXJXcEChU8cexsyP3ma5crY1cu/fF4vMJoAJFf9rOBZYOwn63APVCZ5/AXoQB0cAlc9Dz0l+X1fitINrjLpoby8hXdStZ65RSA0FYJ+7cMUibEJEVYikxQsbTL3l5qK3U6Kqu8TUNteIeKk9e3d0euL0VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mARffpHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mARffpHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C42C19425;
	Sun,  9 Nov 2025 23:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762732199;
	bh=2leaOrFbqznRLU4+BYb8NBfLyGhNn4xW0et6YGcfWf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mARffpHeuuaMDLSViepYaTkFEu5QarpqxY0LviMNOxMIwif5k6YxybXIF3mzEbLrl
	 oBsEeqiIOYlzR4Buc/0be/5VePH5lxDqJ3Krx7tuP8kEu7ayaBSrChCAOmPSrmJa6P
	 e8WuAB36oZ4QbNuGb6keNbyNoOcEG9/xiUwRQdNRjXEaa/xRSijQQiSgyJ/VryRJVm
	 5jjcA5SmsxYkPAgl2JDcQXQgppBebACP9B10DVqhEoBs0m3IBfmuiAga2T/HpxUOT+
	 ua+W935IHxxn8eQnZeC0tk33I52ZiudGlvKY53ZNkDo6eC82VkisbkZGMT12O5f9uO
	 EuuLLTbdPpCWA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6/9] crypto: hctr2 - Convert to use POLYVAL library
Date: Sun,  9 Nov 2025 15:47:21 -0800
Message-ID: <20251109234726.638437-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251109234726.638437-1-ebiggers@kernel.org>
References: <20251109234726.638437-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The "hash function" in hctr2 is fixed at POLYVAL; it can never vary.
Just use the POLYVAL library, which is much easier to use than the
crypto_shash API.  It's faster, uses fixed-size structs, and never fails
(all the functions return void).

Note that this eliminates the only known user of the polyval support in
crypto_shash.  A later commit will remove support for polyval from
crypto_shash, given that the library API is sufficient.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig   |   2 +-
 crypto/hctr2.c   | 226 ++++++++++++++---------------------------------
 crypto/testmgr.c |   3 +-
 3 files changed, 66 insertions(+), 165 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 57b85e903cf0..805172f75bf1 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -694,11 +694,11 @@ config CRYPTO_ECB
 	  ECB (Electronic Codebook) mode (NIST SP800-38A)
 
 config CRYPTO_HCTR2
 	tristate "HCTR2"
 	select CRYPTO_XCTR
-	select CRYPTO_POLYVAL
+	select CRYPTO_LIB_POLYVAL
 	select CRYPTO_MANAGER
 	help
 	  HCTR2 length-preserving encryption mode
 
 	  A mode for storage encryption that is efficient on processors with
diff --git a/crypto/hctr2.c b/crypto/hctr2.c
index c8932777bba8..f4cd6c29b4d3 100644
--- a/crypto/hctr2.c
+++ b/crypto/hctr2.c
@@ -15,11 +15,10 @@
  * For more details, see the paper: "Length-preserving encryption with HCTR2"
  * (https://eprint.iacr.org/2021/1441.pdf)
  */
 
 #include <crypto/internal/cipher.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/polyval.h>
 #include <crypto/scatterwalk.h>
 #include <linux/module.h>
 
@@ -35,97 +34,65 @@
 #define TWEAK_SIZE		32
 
 struct hctr2_instance_ctx {
 	struct crypto_cipher_spawn blockcipher_spawn;
 	struct crypto_skcipher_spawn xctr_spawn;
-	struct crypto_shash_spawn polyval_spawn;
 };
 
 struct hctr2_tfm_ctx {
 	struct crypto_cipher *blockcipher;
 	struct crypto_skcipher *xctr;
-	struct crypto_shash *polyval;
+	struct polyval_key poly_key;
+	struct polyval_elem hashed_tweaklens[2];
 	u8 L[BLOCKCIPHER_BLOCK_SIZE];
-	int hashed_tweak_offset;
-	/*
-	 * This struct is allocated with extra space for two exported hash
-	 * states.  Since the hash state size is not known at compile-time, we
-	 * can't add these to the struct directly.
-	 *
-	 * hashed_tweaklen_divisible;
-	 * hashed_tweaklen_remainder;
-	 */
 };
 
 struct hctr2_request_ctx {
 	u8 first_block[BLOCKCIPHER_BLOCK_SIZE];
 	u8 xctr_iv[BLOCKCIPHER_BLOCK_SIZE];
 	struct scatterlist *bulk_part_dst;
 	struct scatterlist *bulk_part_src;
 	struct scatterlist sg_src[2];
 	struct scatterlist sg_dst[2];
+	struct polyval_elem hashed_tweak;
 	/*
-	 * Sub-request sizes are unknown at compile-time, so they need to go
-	 * after the members with known sizes.
+	 * skcipher sub-request size is unknown at compile-time, so it needs to
+	 * go after the members with known sizes.
 	 */
 	union {
-		struct shash_desc hash_desc;
+		struct polyval_ctx poly_ctx;
 		struct skcipher_request xctr_req;
 	} u;
-	/*
-	 * This struct is allocated with extra space for one exported hash
-	 * state.  Since the hash state size is not known at compile-time, we
-	 * can't add it to the struct directly.
-	 *
-	 * hashed_tweak;
-	 */
 };
 
-static inline u8 *hctr2_hashed_tweaklen(const struct hctr2_tfm_ctx *tctx,
-					bool has_remainder)
-{
-	u8 *p = (u8 *)tctx + sizeof(*tctx);
-
-	if (has_remainder) /* For messages not a multiple of block length */
-		p += crypto_shash_statesize(tctx->polyval);
-	return p;
-}
-
-static inline u8 *hctr2_hashed_tweak(const struct hctr2_tfm_ctx *tctx,
-				     struct hctr2_request_ctx *rctx)
-{
-	return (u8 *)rctx + tctx->hashed_tweak_offset;
-}
-
 /*
  * The input data for each HCTR2 hash step begins with a 16-byte block that
  * contains the tweak length and a flag that indicates whether the input is evenly
  * divisible into blocks.  Since this implementation only supports one tweak
  * length, we precompute the two hash states resulting from hashing the two
  * possible values of this initial block.  This reduces by one block the amount of
  * data that needs to be hashed for each encryption/decryption
  *
  * These precomputed hashes are stored in hctr2_tfm_ctx.
  */
-static int hctr2_hash_tweaklen(struct hctr2_tfm_ctx *tctx, bool has_remainder)
+static void hctr2_hash_tweaklens(struct hctr2_tfm_ctx *tctx)
 {
-	SHASH_DESC_ON_STACK(shash, tfm->polyval);
-	__le64 tweak_length_block[2];
-	int err;
-
-	shash->tfm = tctx->polyval;
-	memset(tweak_length_block, 0, sizeof(tweak_length_block));
-
-	tweak_length_block[0] = cpu_to_le64(TWEAK_SIZE * 8 * 2 + 2 + has_remainder);
-	err = crypto_shash_init(shash);
-	if (err)
-		return err;
-	err = crypto_shash_update(shash, (u8 *)tweak_length_block,
-				  POLYVAL_BLOCK_SIZE);
-	if (err)
-		return err;
-	return crypto_shash_export(shash, hctr2_hashed_tweaklen(tctx, has_remainder));
+	struct polyval_ctx ctx;
+
+	for (int has_remainder = 0; has_remainder < 2; has_remainder++) {
+		const __le64 tweak_length_block[2] = {
+			cpu_to_le64(TWEAK_SIZE * 8 * 2 + 2 + has_remainder),
+		};
+
+		polyval_init(&ctx, &tctx->poly_key);
+		polyval_update(&ctx, (const u8 *)&tweak_length_block,
+			       sizeof(tweak_length_block));
+		static_assert(sizeof(tweak_length_block) == POLYVAL_BLOCK_SIZE);
+		polyval_export_blkaligned(
+			&ctx, &tctx->hashed_tweaklens[has_remainder]);
+	}
+	memzero_explicit(&ctx, sizeof(ctx));
 }
 
 static int hctr2_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			unsigned int keylen)
 {
@@ -154,98 +121,75 @@ static int hctr2_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	memset(tctx->L, 0, sizeof(tctx->L));
 	tctx->L[0] = 0x01;
 	crypto_cipher_encrypt_one(tctx->blockcipher, tctx->L, tctx->L);
 
-	crypto_shash_clear_flags(tctx->polyval, CRYPTO_TFM_REQ_MASK);
-	crypto_shash_set_flags(tctx->polyval, crypto_skcipher_get_flags(tfm) &
-			       CRYPTO_TFM_REQ_MASK);
-	err = crypto_shash_setkey(tctx->polyval, hbar, BLOCKCIPHER_BLOCK_SIZE);
-	if (err)
-		return err;
+	static_assert(sizeof(hbar) == POLYVAL_BLOCK_SIZE);
+	polyval_preparekey(&tctx->poly_key, hbar);
 	memzero_explicit(hbar, sizeof(hbar));
 
-	return hctr2_hash_tweaklen(tctx, true) ?: hctr2_hash_tweaklen(tctx, false);
+	hctr2_hash_tweaklens(tctx);
+	return 0;
 }
 
-static int hctr2_hash_tweak(struct skcipher_request *req)
+static void hctr2_hash_tweak(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct hctr2_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct hctr2_request_ctx *rctx = skcipher_request_ctx(req);
-	struct shash_desc *hash_desc = &rctx->u.hash_desc;
-	int err;
+	struct polyval_ctx *poly_ctx = &rctx->u.poly_ctx;
 	bool has_remainder = req->cryptlen % POLYVAL_BLOCK_SIZE;
 
-	hash_desc->tfm = tctx->polyval;
-	err = crypto_shash_import(hash_desc, hctr2_hashed_tweaklen(tctx, has_remainder));
-	if (err)
-		return err;
-	err = crypto_shash_update(hash_desc, req->iv, TWEAK_SIZE);
-	if (err)
-		return err;
+	polyval_import_blkaligned(poly_ctx, &tctx->poly_key,
+				  &tctx->hashed_tweaklens[has_remainder]);
+	polyval_update(poly_ctx, req->iv, TWEAK_SIZE);
 
 	// Store the hashed tweak, since we need it when computing both
 	// H(T || N) and H(T || V).
-	return crypto_shash_export(hash_desc, hctr2_hashed_tweak(tctx, rctx));
+	static_assert(TWEAK_SIZE % POLYVAL_BLOCK_SIZE == 0);
+	polyval_export_blkaligned(poly_ctx, &rctx->hashed_tweak);
 }
 
-static int hctr2_hash_message(struct skcipher_request *req,
-			      struct scatterlist *sgl,
-			      u8 digest[POLYVAL_DIGEST_SIZE])
+static void hctr2_hash_message(struct skcipher_request *req,
+			       struct scatterlist *sgl,
+			       u8 digest[POLYVAL_DIGEST_SIZE])
 {
-	static const u8 padding[BLOCKCIPHER_BLOCK_SIZE] = { 0x1 };
+	static const u8 padding = 0x1;
 	struct hctr2_request_ctx *rctx = skcipher_request_ctx(req);
-	struct shash_desc *hash_desc = &rctx->u.hash_desc;
+	struct polyval_ctx *poly_ctx = &rctx->u.poly_ctx;
 	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
 	struct sg_mapping_iter miter;
-	unsigned int remainder = bulk_len % BLOCKCIPHER_BLOCK_SIZE;
 	int i;
-	int err = 0;
 	int n = 0;
 
 	sg_miter_start(&miter, sgl, sg_nents(sgl),
 		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
 	for (i = 0; i < bulk_len; i += n) {
 		sg_miter_next(&miter);
 		n = min_t(unsigned int, miter.length, bulk_len - i);
-		err = crypto_shash_update(hash_desc, miter.addr, n);
-		if (err)
-			break;
+		polyval_update(poly_ctx, miter.addr, n);
 	}
 	sg_miter_stop(&miter);
 
-	if (err)
-		return err;
-
-	if (remainder) {
-		err = crypto_shash_update(hash_desc, padding,
-					  BLOCKCIPHER_BLOCK_SIZE - remainder);
-		if (err)
-			return err;
-	}
-	return crypto_shash_final(hash_desc, digest);
+	if (req->cryptlen % BLOCKCIPHER_BLOCK_SIZE)
+		polyval_update(poly_ctx, &padding, 1);
+	polyval_final(poly_ctx, digest);
 }
 
 static int hctr2_finish(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct hctr2_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct hctr2_request_ctx *rctx = skcipher_request_ctx(req);
+	struct polyval_ctx *poly_ctx = &rctx->u.poly_ctx;
 	u8 digest[POLYVAL_DIGEST_SIZE];
-	struct shash_desc *hash_desc = &rctx->u.hash_desc;
-	int err;
 
 	// U = UU ^ H(T || V)
 	// or M = MM ^ H(T || N)
-	hash_desc->tfm = tctx->polyval;
-	err = crypto_shash_import(hash_desc, hctr2_hashed_tweak(tctx, rctx));
-	if (err)
-		return err;
-	err = hctr2_hash_message(req, rctx->bulk_part_dst, digest);
-	if (err)
-		return err;
+	polyval_import_blkaligned(poly_ctx, &tctx->poly_key,
+				  &rctx->hashed_tweak);
+	hctr2_hash_message(req, rctx->bulk_part_dst, digest);
 	crypto_xor(rctx->first_block, digest, BLOCKCIPHER_BLOCK_SIZE);
 
 	// Copy U (or M) into dst scatterlist
 	scatterwalk_map_and_copy(rctx->first_block, req->dst,
 				 0, BLOCKCIPHER_BLOCK_SIZE, 1);
@@ -267,11 +211,10 @@ static int hctr2_crypt(struct skcipher_request *req, bool enc)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct hctr2_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct hctr2_request_ctx *rctx = skcipher_request_ctx(req);
 	u8 digest[POLYVAL_DIGEST_SIZE];
 	int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
-	int err;
 
 	// Requests must be at least one block
 	if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
 		return -EINVAL;
 
@@ -285,16 +228,12 @@ static int hctr2_crypt(struct skcipher_request *req, bool enc)
 	rctx->bulk_part_dst = scatterwalk_ffwd(rctx->sg_dst, req->dst,
 					       BLOCKCIPHER_BLOCK_SIZE);
 
 	// MM = M ^ H(T || N)
 	// or UU = U ^ H(T || V)
-	err = hctr2_hash_tweak(req);
-	if (err)
-		return err;
-	err = hctr2_hash_message(req, rctx->bulk_part_src, digest);
-	if (err)
-		return err;
+	hctr2_hash_tweak(req);
+	hctr2_hash_message(req, rctx->bulk_part_src, digest);
 	crypto_xor(digest, rctx->first_block, BLOCKCIPHER_BLOCK_SIZE);
 
 	// UU = E(MM)
 	// or MM = D(UU)
 	if (enc)
@@ -336,12 +275,10 @@ static int hctr2_init_tfm(struct crypto_skcipher *tfm)
 	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
 	struct hctr2_instance_ctx *ictx = skcipher_instance_ctx(inst);
 	struct hctr2_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *xctr;
 	struct crypto_cipher *blockcipher;
-	struct crypto_shash *polyval;
-	unsigned int subreq_size;
 	int err;
 
 	xctr = crypto_spawn_skcipher(&ictx->xctr_spawn);
 	if (IS_ERR(xctr))
 		return PTR_ERR(xctr);
@@ -350,35 +287,21 @@ static int hctr2_init_tfm(struct crypto_skcipher *tfm)
 	if (IS_ERR(blockcipher)) {
 		err = PTR_ERR(blockcipher);
 		goto err_free_xctr;
 	}
 
-	polyval = crypto_spawn_shash(&ictx->polyval_spawn);
-	if (IS_ERR(polyval)) {
-		err = PTR_ERR(polyval);
-		goto err_free_blockcipher;
-	}
-
 	tctx->xctr = xctr;
 	tctx->blockcipher = blockcipher;
-	tctx->polyval = polyval;
 
 	BUILD_BUG_ON(offsetofend(struct hctr2_request_ctx, u) !=
 				 sizeof(struct hctr2_request_ctx));
-	subreq_size = max(sizeof_field(struct hctr2_request_ctx, u.hash_desc) +
-			  crypto_shash_descsize(polyval),
-			  sizeof_field(struct hctr2_request_ctx, u.xctr_req) +
-			  crypto_skcipher_reqsize(xctr));
-
-	tctx->hashed_tweak_offset = offsetof(struct hctr2_request_ctx, u) +
-				    subreq_size;
-	crypto_skcipher_set_reqsize(tfm, tctx->hashed_tweak_offset +
-				    crypto_shash_statesize(polyval));
+	crypto_skcipher_set_reqsize(
+		tfm, max(sizeof(struct hctr2_request_ctx),
+			 offsetofend(struct hctr2_request_ctx, u.xctr_req) +
+				 crypto_skcipher_reqsize(xctr)));
 	return 0;
 
-err_free_blockcipher:
-	crypto_free_cipher(blockcipher);
 err_free_xctr:
 	crypto_free_skcipher(xctr);
 	return err;
 }
 
@@ -386,34 +309,29 @@ static void hctr2_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct hctr2_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_cipher(tctx->blockcipher);
 	crypto_free_skcipher(tctx->xctr);
-	crypto_free_shash(tctx->polyval);
 }
 
 static void hctr2_free_instance(struct skcipher_instance *inst)
 {
 	struct hctr2_instance_ctx *ictx = skcipher_instance_ctx(inst);
 
 	crypto_drop_cipher(&ictx->blockcipher_spawn);
 	crypto_drop_skcipher(&ictx->xctr_spawn);
-	crypto_drop_shash(&ictx->polyval_spawn);
 	kfree(inst);
 }
 
-static int hctr2_create_common(struct crypto_template *tmpl,
-			       struct rtattr **tb,
-			       const char *xctr_name,
-			       const char *polyval_name)
+static int hctr2_create_common(struct crypto_template *tmpl, struct rtattr **tb,
+			       const char *xctr_name)
 {
 	struct skcipher_alg_common *xctr_alg;
 	u32 mask;
 	struct skcipher_instance *inst;
 	struct hctr2_instance_ctx *ictx;
 	struct crypto_alg *blockcipher_alg;
-	struct shash_alg *polyval_alg;
 	char blockcipher_name[CRYPTO_MAX_ALG_NAME];
 	int len;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
@@ -455,46 +373,27 @@ static int hctr2_create_common(struct crypto_template *tmpl,
 	/* Require blocksize of 16 bytes */
 	err = -EINVAL;
 	if (blockcipher_alg->cra_blocksize != BLOCKCIPHER_BLOCK_SIZE)
 		goto err_free_inst;
 
-	/* Polyval ε-∆U hash function */
-	err = crypto_grab_shash(&ictx->polyval_spawn,
-				skcipher_crypto_instance(inst),
-				polyval_name, 0, mask);
-	if (err)
-		goto err_free_inst;
-	polyval_alg = crypto_spawn_shash_alg(&ictx->polyval_spawn);
-
-	/* Ensure Polyval is being used */
-	err = -EINVAL;
-	if (strcmp(polyval_alg->base.cra_name, "polyval") != 0)
-		goto err_free_inst;
-
 	/* Instance fields */
 
 	err = -ENAMETOOLONG;
 	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "hctr2(%s)",
 		     blockcipher_alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
-		     "hctr2_base(%s,%s)",
-		     xctr_alg->base.cra_driver_name,
-		     polyval_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		     "hctr2_base(%s,polyval-lib)",
+		     xctr_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_free_inst;
 
 	inst->alg.base.cra_blocksize = BLOCKCIPHER_BLOCK_SIZE;
-	inst->alg.base.cra_ctxsize = sizeof(struct hctr2_tfm_ctx) +
-				     polyval_alg->statesize * 2;
+	inst->alg.base.cra_ctxsize = sizeof(struct hctr2_tfm_ctx);
 	inst->alg.base.cra_alignmask = xctr_alg->base.cra_alignmask;
-	/*
-	 * The hash function is called twice, so it is weighted higher than the
-	 * xctr and blockcipher.
-	 */
 	inst->alg.base.cra_priority = (2 * xctr_alg->base.cra_priority +
-				       4 * polyval_alg->base.cra_priority +
-				       blockcipher_alg->cra_priority) / 7;
+				       blockcipher_alg->cra_priority) /
+				      3;
 
 	inst->alg.setkey = hctr2_setkey;
 	inst->alg.encrypt = hctr2_encrypt;
 	inst->alg.decrypt = hctr2_decrypt;
 	inst->alg.init = hctr2_init_tfm;
@@ -523,12 +422,15 @@ static int hctr2_create_base(struct crypto_template *tmpl, struct rtattr **tb)
 		return PTR_ERR(xctr_name);
 
 	polyval_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(polyval_name))
 		return PTR_ERR(polyval_name);
+	if (strcmp(polyval_name, "polyval") != 0 &&
+	    strcmp(polyval_name, "polyval-lib") != 0)
+		return -ENOENT;
 
-	return hctr2_create_common(tmpl, tb, xctr_name, polyval_name);
+	return hctr2_create_common(tmpl, tb, xctr_name);
 }
 
 static int hctr2_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	const char *blockcipher_name;
@@ -540,11 +442,11 @@ static int hctr2_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	if (snprintf(xctr_name, CRYPTO_MAX_ALG_NAME, "xctr(%s)",
 		    blockcipher_name) >= CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
 
-	return hctr2_create_common(tmpl, tb, xctr_name, "polyval");
+	return hctr2_create_common(tmpl, tb, xctr_name);
 }
 
 static struct crypto_template hctr2_tmpls[] = {
 	{
 		/* hctr2_base(xctr_name, polyval_name) */
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 90d06c3ec967..499e979a56dc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5057,12 +5057,11 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(ghash_tv_template)
 		}
 	}, {
 		.alg = "hctr2(aes)",
-		.generic_driver =
-		    "hctr2_base(xctr(aes-generic),polyval-generic)",
+		.generic_driver = "hctr2_base(xctr(aes-generic),polyval-lib)",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(aes_hctr2_tv_template)
 		}
 	}, {
-- 
2.51.2

