From: Ondrej Mosnacek <omosnacek@gmail.com>
Subject: [RFC PATCH 5/6] crypto: aesni-intel - Add bulk request support
Date: Thu, 12 Jan 2017 13:59:57 +0100
Message-ID: <c32a28630157c619ac2a7c851be586e72f193c68.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Cc: Ondrej Mosnacek <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Binoy Jayan <binoy.jayan@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34624 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751390AbdALNAy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 08:00:54 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so3500167wmi.1
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 05:00:53 -0800 (PST)
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
In-Reply-To: <cover.1484215956.git.omosnacek@gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch implements bulk request handling in the AES-NI crypto drivers.
The major advantage of this is that with bulk requests, the kernel_fpu_*
functions (which are usually quite slow) are now called only once for the whole
request.

Signed-off-by: Ondrej Mosnacek <omosnacek@gmail.com>
---
 arch/x86/crypto/aesni-intel_glue.c        | 267 +++++++++++++++++++++++-------
 arch/x86/crypto/glue_helper.c             |  23 ++-
 arch/x86/include/asm/crypto/glue_helper.h |   2 +-
 3 files changed, 221 insertions(+), 71 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 36ca150..5f67afc 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -364,70 +364,116 @@ static int aesni_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 				  crypto_skcipher_ctx(tfm), key, len);
 }
 
-static int ecb_encrypt(struct skcipher_request *req)
+typedef void (*aesni_crypt_t)(struct crypto_aes_ctx *ctx,
+			      u8 *out, const u8 *in, unsigned int len);
+
+typedef void (*aesni_ivcrypt_t)(struct crypto_aes_ctx *ctx,
+				u8 *out, const u8 *in, unsigned int len,
+				u8 *iv);
+
+static int ecb_crypt(struct crypto_aes_ctx *ctx, struct skcipher_walk *walk,
+		     aesni_crypt_t crypt)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
-	struct skcipher_walk walk;
 	unsigned int nbytes;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
-
 	kernel_fpu_begin();
-	while ((nbytes = walk.nbytes)) {
-		aesni_ecb_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK);
+	while ((nbytes = walk->nbytes)) {
+		crypt(ctx, walk->dst.virt.addr, walk->src.virt.addr,
+		      nbytes & AES_BLOCK_MASK);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = skcipher_walk_done(&walk, nbytes);
+		err = skcipher_walk_done(walk, nbytes);
 	}
 	kernel_fpu_end();
 
 	return err;
 }
 
-static int ecb_decrypt(struct skcipher_request *req)
+static int cbc_crypt(struct crypto_aes_ctx *ctx, struct skcipher_walk *walk,
+		     aesni_ivcrypt_t crypt)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
-	struct skcipher_walk walk;
 	unsigned int nbytes;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
-
 	kernel_fpu_begin();
-	while ((nbytes = walk.nbytes)) {
-		aesni_ecb_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK);
+	while ((nbytes = walk->nbytes)) {
+		crypt(ctx, walk->dst.virt.addr, walk->src.virt.addr,
+		      nbytes & AES_BLOCK_MASK, walk->iv);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = skcipher_walk_done(&walk, nbytes);
+		err = skcipher_walk_done(walk, nbytes);
 	}
 	kernel_fpu_end();
 
 	return err;
 }
 
-static int cbc_encrypt(struct skcipher_request *req)
+static int ecb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
 	struct skcipher_walk walk;
-	unsigned int nbytes;
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
-	kernel_fpu_begin();
-	while ((nbytes = walk.nbytes)) {
-		aesni_cbc_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK, walk.iv);
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-	kernel_fpu_end();
+	return ecb_crypt(ctx, &walk, aesni_ecb_enc);
+}
 
-	return err;
+static int ecb_decrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
+
+	return ecb_crypt(ctx, &walk, aesni_ecb_dec);
+}
+
+static int ecb_encrypt_bulk(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt_bulk(&walk, req, true);
+	if (err)
+		return err;
+
+	return ecb_crypt(ctx, &walk, aesni_ecb_enc);
+}
+
+static int ecb_decrypt_bulk(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt_bulk(&walk, req, true);
+	if (err)
+		return err;
+
+	return ecb_crypt(ctx, &walk, aesni_ecb_dec);
+}
+
+static int cbc_encrypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
+	return cbc_crypt(ctx, &walk, aesni_cbc_enc);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -435,21 +481,44 @@ static int cbc_decrypt(struct skcipher_request *req)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
 	struct skcipher_walk walk;
-	unsigned int nbytes;
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
+	return cbc_crypt(ctx, &walk, aesni_cbc_dec);
+}
 
-	kernel_fpu_begin();
-	while ((nbytes = walk.nbytes)) {
-		aesni_cbc_dec(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK, walk.iv);
-		nbytes &= AES_BLOCK_SIZE - 1;
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-	kernel_fpu_end();
+static int cbc_encrypt_bulk(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	int err;
 
-	return err;
+	err = skcipher_walk_virt_bulk(&walk, req, true);
+	if (err)
+		return err;
+	return cbc_crypt(ctx, &walk, aesni_cbc_enc);
+}
+
+static int cbc_decrypt_bulk(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt_bulk(&walk, req, true);
+	if (err)
+		return err;
+	return cbc_crypt(ctx, &walk, aesni_cbc_dec);
+}
+
+static unsigned int aesni_reqsize_bulk(struct crypto_skcipher *tfm,
+				       unsigned int maxmsgs)
+{
+	return 0;
 }
 
 #ifdef CONFIG_X86_64
@@ -487,32 +556,58 @@ static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
 }
 #endif
 
-static int ctr_crypt(struct skcipher_request *req)
+static int ctr_crypt_common(struct crypto_aes_ctx *ctx,
+			    struct skcipher_walk *walk)
 {
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
-	struct skcipher_walk walk;
 	unsigned int nbytes;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, true);
-
 	kernel_fpu_begin();
-	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
-		aesni_ctr_enc_tfm(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			              nbytes & AES_BLOCK_MASK, walk.iv);
+	while ((nbytes = walk->nbytes)) {
+		if (nbytes < AES_BLOCK_SIZE) {
+			ctr_crypt_final(ctx, walk);
+			err = skcipher_walk_done(walk, nbytes);
+			continue;
+		}
+
+		aesni_ctr_enc_tfm(ctx, walk->dst.virt.addr, walk->src.virt.addr,
+				  nbytes & AES_BLOCK_MASK, walk->iv);
 		nbytes &= AES_BLOCK_SIZE - 1;
-		err = skcipher_walk_done(&walk, nbytes);
-	}
-	if (walk.nbytes) {
-		ctr_crypt_final(ctx, &walk);
-		err = skcipher_walk_done(&walk, 0);
+		err = skcipher_walk_done(walk, nbytes);
 	}
 	kernel_fpu_end();
 
 	return err;
 }
 
+static int ctr_crypt(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
+
+	return ctr_crypt_common(ctx, &walk);
+}
+
+static int ctr_crypt_bulk(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt_bulk(&walk, req, true);
+	if (err)
+		return err;
+
+	return ctr_crypt_common(ctx, &walk);
+}
+
 static int xts_aesni_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
@@ -592,8 +687,14 @@ static int xts_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int err;
 
-	return glue_xts_req_128bit(&aesni_enc_xts, req,
+	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+
+	return glue_xts_req_128bit(&aesni_enc_xts, &walk,
 				   XTS_TWEAK_CAST(aesni_xts_tweak),
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx));
@@ -603,8 +704,48 @@ static int xts_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+
+	return glue_xts_req_128bit(&aesni_dec_xts, &walk,
+				   XTS_TWEAK_CAST(aesni_xts_tweak),
+				   aes_ctx(ctx->raw_tweak_ctx),
+				   aes_ctx(ctx->raw_crypt_ctx));
+}
+
+static int xts_encrypt_bulk(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt_bulk(&walk, req, false);
+	if (err)
+		return err;
+
+	return glue_xts_req_128bit(&aesni_enc_xts, &walk,
+				   XTS_TWEAK_CAST(aesni_xts_tweak),
+				   aes_ctx(ctx->raw_tweak_ctx),
+				   aes_ctx(ctx->raw_crypt_ctx));
+}
+
+static int xts_decrypt_bulk(struct skcipher_bulk_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_bulk_reqtfm(req);
+	struct aesni_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct skcipher_walk walk;
+	int err;
+
+	err = skcipher_walk_virt_bulk(&walk, req, false);
+	if (err)
+		return err;
 
-	return glue_xts_req_128bit(&aesni_dec_xts, req,
+	return glue_xts_req_128bit(&aesni_dec_xts, &walk,
 				   XTS_TWEAK_CAST(aesni_xts_tweak),
 				   aes_ctx(ctx->raw_tweak_ctx),
 				   aes_ctx(ctx->raw_crypt_ctx));
@@ -962,6 +1103,9 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= ecb_encrypt,
 		.decrypt	= ecb_decrypt,
+		.encrypt_bulk	= ecb_encrypt_bulk,
+		.decrypt_bulk	= ecb_decrypt_bulk,
+		.reqsize_bulk	= aesni_reqsize_bulk,
 	}, {
 		.base = {
 			.cra_name		= "__cbc(aes)",
@@ -978,6 +1122,9 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= cbc_encrypt,
 		.decrypt	= cbc_decrypt,
+		.encrypt_bulk	= cbc_encrypt_bulk,
+		.decrypt_bulk	= cbc_decrypt_bulk,
+		.reqsize_bulk	= aesni_reqsize_bulk,
 #ifdef CONFIG_X86_64
 	}, {
 		.base = {
@@ -996,6 +1143,9 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= aesni_skcipher_setkey,
 		.encrypt	= ctr_crypt,
 		.decrypt	= ctr_crypt,
+		.encrypt_bulk	= ctr_crypt_bulk,
+		.decrypt_bulk	= ctr_crypt_bulk,
+		.reqsize_bulk	= aesni_reqsize_bulk,
 	}, {
 		.base = {
 			.cra_name		= "__xts(aes)",
@@ -1012,6 +1162,9 @@ static struct skcipher_alg aesni_skciphers[] = {
 		.setkey		= xts_aesni_setkey,
 		.encrypt	= xts_encrypt,
 		.decrypt	= xts_decrypt,
+		.encrypt_bulk	= xts_encrypt_bulk,
+		.decrypt_bulk	= xts_decrypt_bulk,
+		.reqsize_bulk	= aesni_reqsize_bulk,
 #endif
 	}
 };
diff --git a/arch/x86/crypto/glue_helper.c b/arch/x86/crypto/glue_helper.c
index 260a060..7bd28bf 100644
--- a/arch/x86/crypto/glue_helper.c
+++ b/arch/x86/crypto/glue_helper.c
@@ -415,34 +415,31 @@ int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
 EXPORT_SYMBOL_GPL(glue_xts_crypt_128bit);
 
 int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
-			struct skcipher_request *req,
+			struct skcipher_walk *walk,
 			common_glue_func_t tweak_fn, void *tweak_ctx,
 			void *crypt_ctx)
 {
 	const unsigned int bsize = 128 / 8;
-	struct skcipher_walk walk;
 	bool fpu_enabled = false;
 	unsigned int nbytes;
 	int err;
 
-	err = skcipher_walk_virt(&walk, req, false);
-	nbytes = walk.nbytes;
-	if (!nbytes)
-		return err;
+	nbytes = walk->nbytes;
 
 	/* set minimum length to bsize, for tweak_fn */
 	fpu_enabled = glue_skwalk_fpu_begin(bsize, gctx->fpu_blocks_limit,
-					    &walk, fpu_enabled,
+					    walk, fpu_enabled,
 					    nbytes < bsize ? bsize : nbytes);
 
-	/* calculate first value of T */
-	tweak_fn(tweak_ctx, walk.iv, walk.iv);
-
 	while (nbytes) {
-		nbytes = __glue_xts_req_128bit(gctx, crypt_ctx, &walk);
+		/* calculate first value of T */
+		if (walk->nextmsg)
+			tweak_fn(tweak_ctx, walk->iv, walk->iv);
 
-		err = skcipher_walk_done(&walk, nbytes);
-		nbytes = walk.nbytes;
+		nbytes = __glue_xts_req_128bit(gctx, crypt_ctx, walk);
+
+		err = skcipher_walk_done(walk, nbytes);
+		nbytes = walk->nbytes;
 	}
 
 	glue_fpu_end(fpu_enabled);
diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 29e53ea..e9806a8 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -172,7 +172,7 @@ extern int glue_xts_crypt_128bit(const struct common_glue_ctx *gctx,
 				 void *crypt_ctx);
 
 extern int glue_xts_req_128bit(const struct common_glue_ctx *gctx,
-			       struct skcipher_request *req,
+			       struct skcipher_walk *walk,
 			       common_glue_func_t tweak_fn, void *tweak_ctx,
 			       void *crypt_ctx);
 
-- 
2.9.3
