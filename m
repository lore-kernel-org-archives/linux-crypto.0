Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECFB268C4F
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945148; cv=none; b=JQAos2lgbv5C7phnhUfEf1TKMYRc4Vbvmix3foJBy/GrlL4Vz0EuyLqhZnL02MEtF4L8jL6LmHEhxXObQiKiE1HIcNHKIcVwAqWHXsqb5GU6c3y4YOC4N8EPBkgp7vNXanHs5R5OGHdX8SxEq8c0iOOqYW6WhAc8D50Ji+9z3cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945148; c=relaxed/simple;
	bh=UUg+UK4A5chcDyYL2ViEVx0oGFihLemOJcFFeUQs2/8=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=QukKk3GXLyrVNpBupAhoo5h0HtlCfHcrnperqQRwmFDxTsvwfcSdRh5REOfCcAFNfWPnpM6pJSlJlO1RfHERUp5Azn3WfVGmpM3JZcr4FPst1EJKg09u1iAW7yA7/pDRdv6y88m013Lv+059ynjD0O2nV3c7pv302NzTjhKTzYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NFbWHxHv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NFbWHxHv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sKXf1yhTxOcA2agQIsrXOgEWt7rcWj9lIrRNRM6CC/c=; b=NFbWHxHvO8JIVhYrvmNrzDEIXg
	Mn1rFnfy90+7Z6TLp/6rp9d1Qw9aJIMxddTSm9Oyd8qRSfuITdyLW1QmeeJaqF3qCDi1AmdHgVoeH
	OecSWyk0uwi22e3VzJ4qNfFXLPZJE6p7NJqtraLFy9ugmBAEwA6tvm80Wcpqn6vg0oS4YsQwDvUGt
	24rzWiPT+nDfOH4SlxK4i6p8IpJgICh5rIi4dx7H9fb1Fye+8I+F71XnZnyLhK6H+/hQWert3mho5
	+1JRbpD72bHOORAk3lxoJBpVp2nbxF6X+XuXkoZvwJPk+9QfxjzW6iiFIdlIUqY2hKXGwfAe3s72a
	tJDOX2+A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwT-00Ge48-2l;
	Fri, 18 Apr 2025 10:59:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:01 +0800
Date: Fri, 18 Apr 2025 10:59:01 +0800
Message-Id: <0ebaa95a6c8e199d024b1b515a0192c5ec049b02.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 10/67] crypto: x86/ghash - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also remove the unnecessary SIMD fallback path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/x86/crypto/ghash-clmulni-intel_asm.S  |   5 +-
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 301 +++------------------
 2 files changed, 43 insertions(+), 263 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index 99cb983ded9e..c4fbaa82ed7a 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -103,8 +103,8 @@ SYM_FUNC_START(clmul_ghash_mul)
 SYM_FUNC_END(clmul_ghash_mul)
 
 /*
- * void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
- *			   const le128 *shash);
+ * int clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
+ *			  const le128 *shash);
  */
 SYM_FUNC_START(clmul_ghash_update)
 	FRAME_BEGIN
@@ -127,6 +127,7 @@ SYM_FUNC_START(clmul_ghash_update)
 	pshufb BSWAP, DATA
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
+	mov %rdx, %rax
 	FRAME_END
 	RET
 SYM_FUNC_END(clmul_ghash_update)
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index c759ec808bf1..aea5d4d06be7 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -7,41 +7,27 @@
  *   Author: Huang Ying <ying.huang@intel.com>
  */
 
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/crypto.h>
-#include <crypto/algapi.h>
-#include <crypto/cryptd.h>
-#include <crypto/gf128mul.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
+#include <crypto/b128ops.h>
+#include <crypto/ghash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/utils.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 #include <linux/unaligned.h>
 
-#define GHASH_BLOCK_SIZE	16
-#define GHASH_DIGEST_SIZE	16
+asmlinkage void clmul_ghash_mul(char *dst, const le128 *shash);
 
-void clmul_ghash_mul(char *dst, const le128 *shash);
+asmlinkage int clmul_ghash_update(char *dst, const char *src,
+				  unsigned int srclen, const le128 *shash);
 
-void clmul_ghash_update(char *dst, const char *src, unsigned int srclen,
-			const le128 *shash);
-
-struct ghash_async_ctx {
-	struct cryptd_ahash *cryptd_tfm;
-};
-
-struct ghash_ctx {
+struct x86_ghash_ctx {
 	le128 shash;
 };
 
-struct ghash_desc_ctx {
-	u8 buffer[GHASH_BLOCK_SIZE];
-	u32 bytes;
-};
-
 static int ghash_init(struct shash_desc *desc)
 {
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
@@ -54,7 +40,7 @@ static int ghash_init(struct shash_desc *desc)
 static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
-	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
+	struct x86_ghash_ctx *ctx = crypto_shash_ctx(tfm);
 	u64 a, b;
 
 	if (keylen != GHASH_BLOCK_SIZE)
@@ -95,64 +81,38 @@ static int ghash_setkey(struct crypto_shash *tfm,
 static int ghash_update(struct shash_desc *desc,
 			 const u8 *src, unsigned int srclen)
 {
+	struct x86_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	u8 *dst = dctx->buffer;
+	int remain;
+
+	kernel_fpu_begin();
+	remain = clmul_ghash_update(dst, src, srclen, &ctx->shash);
+	kernel_fpu_end();
+	return remain;
+}
+
+static void ghash_flush(struct x86_ghash_ctx *ctx, struct ghash_desc_ctx *dctx,
+			const u8 *src, unsigned int len)
+{
 	u8 *dst = dctx->buffer;
 
 	kernel_fpu_begin();
-	if (dctx->bytes) {
-		int n = min(srclen, dctx->bytes);
-		u8 *pos = dst + (GHASH_BLOCK_SIZE - dctx->bytes);
-
-		dctx->bytes -= n;
-		srclen -= n;
-
-		while (n--)
-			*pos++ ^= *src++;
-
-		if (!dctx->bytes)
-			clmul_ghash_mul(dst, &ctx->shash);
-	}
-
-	clmul_ghash_update(dst, src, srclen, &ctx->shash);
-	kernel_fpu_end();
-
-	if (srclen & 0xf) {
-		src += srclen - (srclen & 0xf);
-		srclen &= 0xf;
-		dctx->bytes = GHASH_BLOCK_SIZE - srclen;
-		while (srclen--)
-			*dst++ ^= *src++;
-	}
-
-	return 0;
-}
-
-static void ghash_flush(struct ghash_ctx *ctx, struct ghash_desc_ctx *dctx)
-{
-	u8 *dst = dctx->buffer;
-
-	if (dctx->bytes) {
-		u8 *tmp = dst + (GHASH_BLOCK_SIZE - dctx->bytes);
-
-		while (dctx->bytes--)
-			*tmp++ ^= 0;
-
-		kernel_fpu_begin();
+	if (len) {
+		crypto_xor(dst, src, len);
 		clmul_ghash_mul(dst, &ctx->shash);
-		kernel_fpu_end();
 	}
-
-	dctx->bytes = 0;
+	kernel_fpu_end();
 }
 
-static int ghash_final(struct shash_desc *desc, u8 *dst)
+static int ghash_finup(struct shash_desc *desc, const u8 *src,
+		       unsigned int len, u8 *dst)
 {
+	struct x86_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	u8 *buf = dctx->buffer;
 
-	ghash_flush(ctx, dctx);
+	ghash_flush(ctx, dctx, src, len);
 	memcpy(dst, buf, GHASH_BLOCK_SIZE);
 
 	return 0;
@@ -162,186 +122,20 @@ static struct shash_alg ghash_alg = {
 	.digestsize	= GHASH_DIGEST_SIZE,
 	.init		= ghash_init,
 	.update		= ghash_update,
-	.final		= ghash_final,
+	.finup		= ghash_finup,
 	.setkey		= ghash_setkey,
 	.descsize	= sizeof(struct ghash_desc_ctx),
 	.base		= {
-		.cra_name		= "__ghash",
-		.cra_driver_name	= "__ghash-pclmulqdqni",
-		.cra_priority		= 0,
-		.cra_flags		= CRYPTO_ALG_INTERNAL,
+		.cra_name		= "ghash",
+		.cra_driver_name	= "ghash-pclmulqdqni",
+		.cra_priority		= 400,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize		= GHASH_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct ghash_ctx),
+		.cra_ctxsize		= sizeof(struct x86_ghash_ctx),
 		.cra_module		= THIS_MODULE,
 	},
 };
 
-static int ghash_async_init(struct ahash_request *req)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-	struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
-
-	desc->tfm = child;
-	return crypto_shash_init(desc);
-}
-
-static void ghash_init_cryptd_req(struct ahash_request *req)
-{
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-
-	ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
-	ahash_request_set_callback(cryptd_req, req->base.flags,
-				   req->base.complete, req->base.data);
-	ahash_request_set_crypt(cryptd_req, req->src, req->result,
-				req->nbytes);
-}
-
-static int ghash_async_update(struct ahash_request *req)
-{
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-
-	if (!crypto_simd_usable() ||
-	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
-		ghash_init_cryptd_req(req);
-		return crypto_ahash_update(cryptd_req);
-	} else {
-		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-		return shash_ahash_update(req, desc);
-	}
-}
-
-static int ghash_async_final(struct ahash_request *req)
-{
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-
-	if (!crypto_simd_usable() ||
-	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
-		ghash_init_cryptd_req(req);
-		return crypto_ahash_final(cryptd_req);
-	} else {
-		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-		return crypto_shash_final(desc, req->result);
-	}
-}
-
-static int ghash_async_import(struct ahash_request *req, const void *in)
-{
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	ghash_async_init(req);
-	memcpy(dctx, in, sizeof(*dctx));
-	return 0;
-
-}
-
-static int ghash_async_export(struct ahash_request *req, void *out)
-{
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memcpy(out, dctx, sizeof(*dctx));
-	return 0;
-
-}
-
-static int ghash_async_digest(struct ahash_request *req)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct ahash_request *cryptd_req = ahash_request_ctx(req);
-	struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
-
-	if (!crypto_simd_usable() ||
-	    (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
-		ghash_init_cryptd_req(req);
-		return crypto_ahash_digest(cryptd_req);
-	} else {
-		struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
-		struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
-
-		desc->tfm = child;
-		return shash_ahash_digest(req, desc);
-	}
-}
-
-static int ghash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
-			      unsigned int keylen)
-{
-	struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct crypto_ahash *child = &ctx->cryptd_tfm->base;
-
-	crypto_ahash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_ahash_set_flags(child, crypto_ahash_get_flags(tfm)
-			       & CRYPTO_TFM_REQ_MASK);
-	return crypto_ahash_setkey(child, key, keylen);
-}
-
-static int ghash_async_init_tfm(struct crypto_tfm *tfm)
-{
-	struct cryptd_ahash *cryptd_tfm;
-	struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cryptd_tfm = cryptd_alloc_ahash("__ghash-pclmulqdqni",
-					CRYPTO_ALG_INTERNAL,
-					CRYPTO_ALG_INTERNAL);
-	if (IS_ERR(cryptd_tfm))
-		return PTR_ERR(cryptd_tfm);
-	ctx->cryptd_tfm = cryptd_tfm;
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct ahash_request) +
-				 crypto_ahash_reqsize(&cryptd_tfm->base));
-
-	return 0;
-}
-
-static void ghash_async_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	cryptd_free_ahash(ctx->cryptd_tfm);
-}
-
-static struct ahash_alg ghash_async_alg = {
-	.init		= ghash_async_init,
-	.update		= ghash_async_update,
-	.final		= ghash_async_final,
-	.setkey		= ghash_async_setkey,
-	.digest		= ghash_async_digest,
-	.export		= ghash_async_export,
-	.import		= ghash_async_import,
-	.halg = {
-		.digestsize	= GHASH_DIGEST_SIZE,
-		.statesize = sizeof(struct ghash_desc_ctx),
-		.base = {
-			.cra_name		= "ghash",
-			.cra_driver_name	= "ghash-clmulni",
-			.cra_priority		= 400,
-			.cra_ctxsize		= sizeof(struct ghash_async_ctx),
-			.cra_flags		= CRYPTO_ALG_ASYNC,
-			.cra_blocksize		= GHASH_BLOCK_SIZE,
-			.cra_module		= THIS_MODULE,
-			.cra_init		= ghash_async_init_tfm,
-			.cra_exit		= ghash_async_exit_tfm,
-		},
-	},
-};
-
 static const struct x86_cpu_id pcmul_cpu_id[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_PCLMULQDQ, NULL), /* Pickle-Mickle-Duck */
 	{}
@@ -350,29 +144,14 @@ MODULE_DEVICE_TABLE(x86cpu, pcmul_cpu_id);
 
 static int __init ghash_pclmulqdqni_mod_init(void)
 {
-	int err;
-
 	if (!x86_match_cpu(pcmul_cpu_id))
 		return -ENODEV;
 
-	err = crypto_register_shash(&ghash_alg);
-	if (err)
-		goto err_out;
-	err = crypto_register_ahash(&ghash_async_alg);
-	if (err)
-		goto err_shash;
-
-	return 0;
-
-err_shash:
-	crypto_unregister_shash(&ghash_alg);
-err_out:
-	return err;
+	return crypto_register_shash(&ghash_alg);
 }
 
 static void __exit ghash_pclmulqdqni_mod_exit(void)
 {
-	crypto_unregister_ahash(&ghash_async_alg);
 	crypto_unregister_shash(&ghash_alg);
 }
 
-- 
2.39.5

