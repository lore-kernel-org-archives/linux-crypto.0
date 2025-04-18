Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E632686AF
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945280; cv=none; b=RN0Pj+HMJiTF9KgMDb0xmYQnrxDDOptyXPA+knCunmgh5M6z4+AwSsMWZ1/IGgx5l2slybiumnSXOC0m/3Qiv9ieJ3oep5u5Zybv8OkrNP1/UE1UjiOtzRvNc+2Njc9ybleXqTRq+CUokNfjPn1NRjyc8wuX1XMxBDElAzoiRJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945280; c=relaxed/simple;
	bh=KhmpsruxnlHp+Fg1BlYuPjZ7qgNhkkibctNbkxSZlfs=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=gnlH12c3ZBoYaB9Lj0yQ2yfewxpxpcNtCTjI0mTGDWIhb+LIX63WW/2a1aWO+rXRn8kjwN3+adzT67khBqTEROm4zqZ8l8+GXUwJSvV1stJvFsszwjdssWJZWCbyRUtpJo0jj+taXDlstOCEga3wvOjJtTt3mZSOwMDE/QG791o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=qd+yDLF7; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="qd+yDLF7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Wg5g2WJqoY7ca4qBdSssffKEBxlfKR4Xdj+2+d9Dp5w=; b=qd+yDLF79O+ENNzADx5ubruWsd
	A88el6AlO00VZpo+fWVKyWtcPHiq/1LRstq3vXDyGDdU3Ak5po3qEnvOR6eg4UUqMmtByIUoHwNf+
	kNmaYnepxag5gaNvJyG4fm9jllMcLzqC8B/lAO3Ol0Mv++YDl97o4FOycv2GBC0BUmn8JFjOMqxZx
	L2XWwJAWm9Lv2lvqL1pl4zC5XXG0GNfX+ic6zP5eBds7jZ4w/rZGzexTaxE1ytcWMsOPDtj6KFuBa
	xk5tcnYTJVwjIBk5/nHrgKlf+3175BCZY/BAw0v6liOPCocuS8V5OnvXU1iTZMAYuAvvGpWIx4NiR
	nEuVbrKg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5byb-00GeL0-36;
	Fri, 18 Apr 2025 11:01:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:01:13 +0800
Date: Fri, 18 Apr 2025 11:01:13 +0800
Message-Id: <360cc1107ee8d4bbb87f532ce82f727ea28ad1fc.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 67/67] crypto: padlock-sha - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/padlock-sha.c | 464 +++++++++++------------------------
 1 file changed, 138 insertions(+), 326 deletions(-)

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 466493907d48..c89b9c6b5f4c 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -7,59 +7,83 @@
  * Copyright (c) 2006  Michal Ludvig <michal@logix.cz>
  */
 
+#include <asm/cpu_device_id.h>
 #include <crypto/internal/hash.h>
 #include <crypto/padlock.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
+#include <linux/cpufeature.h>
 #include <linux/err.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/interrupt.h>
 #include <linux/kernel.h>
-#include <linux/scatterlist.h>
-#include <asm/cpu_device_id.h>
-#include <asm/fpu/api.h>
+#include <linux/module.h>
 
-struct padlock_sha_desc {
-	struct shash_desc fallback;
-};
+#define PADLOCK_SHA_DESCSIZE (128 + ((PADLOCK_ALIGNMENT - 1) & \
+				     ~(CRYPTO_MINALIGN - 1)))
 
 struct padlock_sha_ctx {
-	struct crypto_shash *fallback;
+	struct crypto_ahash *fallback;
 };
 
-static int padlock_sha_init(struct shash_desc *desc)
+static inline void *padlock_shash_desc_ctx(struct shash_desc *desc)
 {
-	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
-	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	return PTR_ALIGN(shash_desc_ctx(desc), PADLOCK_ALIGNMENT);
+}
 
-	dctx->fallback.tfm = ctx->fallback;
-	return crypto_shash_init(&dctx->fallback);
+static int padlock_sha1_init(struct shash_desc *desc)
+{
+	struct sha1_state *sctx = padlock_shash_desc_ctx(desc);
+
+	*sctx = (struct sha1_state){
+		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
+	};
+
+	return 0;
+}
+
+static int padlock_sha256_init(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = padlock_shash_desc_ctx(desc);
+
+	sha256_init(sctx);
+	return 0;
 }
 
 static int padlock_sha_update(struct shash_desc *desc,
 			      const u8 *data, unsigned int length)
 {
-	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
+	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	u8 *state = padlock_shash_desc_ctx(desc);
+	HASH_REQUEST_ON_STACK(req, ctx->fallback);
+	int remain;
 
-	return crypto_shash_update(&dctx->fallback, data, length);
+	ahash_request_set_callback(req, 0, NULL, NULL);
+	ahash_request_set_virt(req, data, NULL, length);
+	remain = crypto_ahash_import(req, state) ?:
+		 crypto_ahash_update(req);
+	if (remain < 0)
+		return remain;
+	return crypto_ahash_export(req, state) ?: remain;
 }
 
 static int padlock_sha_export(struct shash_desc *desc, void *out)
 {
-	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
-
-	return crypto_shash_export(&dctx->fallback, out);
+	memcpy(out, padlock_shash_desc_ctx(desc),
+	       crypto_shash_coresize(desc->tfm));
+	return 0;
 }
 
 static int padlock_sha_import(struct shash_desc *desc, const void *in)
 {
-	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
-	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+	unsigned int ss = crypto_shash_coresize(desc->tfm);
+	u64 *state = padlock_shash_desc_ctx(desc);
 
-	dctx->fallback.tfm = ctx->fallback;
-	return crypto_shash_import(&dctx->fallback, in);
+	memcpy(state, in, ss);
+
+	/* Stop evil imports from generating a fault. */
+	state[ss / 8 - 1] &= ~(bs - 1);
+
+	return 0;
 }
 
 static inline void padlock_output_block(uint32_t *src,
@@ -69,65 +93,38 @@ static inline void padlock_output_block(uint32_t *src,
 		*dst++ = swab32(*src++);
 }
 
+static int padlock_sha_finup(struct shash_desc *desc, const u8 *in,
+			     unsigned int count, u8 *out)
+{
+	struct padlock_sha_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	HASH_REQUEST_ON_STACK(req, ctx->fallback);
+
+	ahash_request_set_callback(req, 0, NULL, NULL);
+	ahash_request_set_virt(req, in, out, count);
+	return crypto_ahash_import(req, padlock_shash_desc_ctx(desc)) ?:
+	       crypto_ahash_finup(req);
+}
+
 static int padlock_sha1_finup(struct shash_desc *desc, const u8 *in,
 			      unsigned int count, u8 *out)
 {
 	/* We can't store directly to *out as it may be unaligned. */
 	/* BTW Don't reduce the buffer size below 128 Bytes!
 	 *     PadLock microcode needs it that big. */
-	char buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
-		((aligned(STACK_ALIGN)));
-	char *result = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
-	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
-	struct sha1_state state;
-	unsigned int space;
-	unsigned int leftover;
-	int err;
+	struct sha1_state *state = padlock_shash_desc_ctx(desc);
+	u64 start = state->count;
 
-	err = crypto_shash_export(&dctx->fallback, &state);
-	if (err)
-		goto out;
-
-	if (state.count + count > ULONG_MAX)
-		return crypto_shash_finup(&dctx->fallback, in, count, out);
-
-	leftover = ((state.count - 1) & (SHA1_BLOCK_SIZE - 1)) + 1;
-	space =  SHA1_BLOCK_SIZE - leftover;
-	if (space) {
-		if (count > space) {
-			err = crypto_shash_update(&dctx->fallback, in, space) ?:
-			      crypto_shash_export(&dctx->fallback, &state);
-			if (err)
-				goto out;
-			count -= space;
-			in += space;
-		} else {
-			memcpy(state.buffer + leftover, in, count);
-			in = state.buffer;
-			count += leftover;
-			state.count &= ~(SHA1_BLOCK_SIZE - 1);
-		}
-	}
-
-	memcpy(result, &state.state, SHA1_DIGEST_SIZE);
+	if (start + count > ULONG_MAX)
+		return padlock_sha_finup(desc, in, count, out);
 
 	asm volatile (".byte 0xf3,0x0f,0xa6,0xc8" /* rep xsha1 */
 		      : \
-		      : "c"((unsigned long)state.count + count), \
-			"a"((unsigned long)state.count), \
-			"S"(in), "D"(result));
+		      : "c"((unsigned long)start + count), \
+			"a"((unsigned long)start), \
+			"S"(in), "D"(state));
 
-	padlock_output_block((uint32_t *)result, (uint32_t *)out, 5);
-
-out:
-	return err;
-}
-
-static int padlock_sha1_final(struct shash_desc *desc, u8 *out)
-{
-	const u8 *buf = (void *)desc;
-
-	return padlock_sha1_finup(desc, buf, 0, out);
+	padlock_output_block(state->state, (uint32_t *)out, 5);
+	return 0;
 }
 
 static int padlock_sha256_finup(struct shash_desc *desc, const u8 *in,
@@ -136,79 +133,41 @@ static int padlock_sha256_finup(struct shash_desc *desc, const u8 *in,
 	/* We can't store directly to *out as it may be unaligned. */
 	/* BTW Don't reduce the buffer size below 128 Bytes!
 	 *     PadLock microcode needs it that big. */
-	char buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
-		((aligned(STACK_ALIGN)));
-	char *result = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
-	struct padlock_sha_desc *dctx = shash_desc_ctx(desc);
-	struct sha256_state state;
-	unsigned int space;
-	unsigned int leftover;
-	int err;
+	struct sha256_state *state = padlock_shash_desc_ctx(desc);
+	u64 start = state->count;
 
-	err = crypto_shash_export(&dctx->fallback, &state);
-	if (err)
-		goto out;
-
-	if (state.count + count > ULONG_MAX)
-		return crypto_shash_finup(&dctx->fallback, in, count, out);
-
-	leftover = ((state.count - 1) & (SHA256_BLOCK_SIZE - 1)) + 1;
-	space =  SHA256_BLOCK_SIZE - leftover;
-	if (space) {
-		if (count > space) {
-			err = crypto_shash_update(&dctx->fallback, in, space) ?:
-			      crypto_shash_export(&dctx->fallback, &state);
-			if (err)
-				goto out;
-			count -= space;
-			in += space;
-		} else {
-			memcpy(state.buf + leftover, in, count);
-			in = state.buf;
-			count += leftover;
-			state.count &= ~(SHA1_BLOCK_SIZE - 1);
-		}
-	}
-
-	memcpy(result, &state.state, SHA256_DIGEST_SIZE);
+	if (start + count > ULONG_MAX)
+		return padlock_sha_finup(desc, in, count, out);
 
 	asm volatile (".byte 0xf3,0x0f,0xa6,0xd0" /* rep xsha256 */
 		      : \
-		      : "c"((unsigned long)state.count + count), \
-			"a"((unsigned long)state.count), \
-			"S"(in), "D"(result));
+		      : "c"((unsigned long)start + count), \
+			"a"((unsigned long)start), \
+			"S"(in), "D"(state));
 
-	padlock_output_block((uint32_t *)result, (uint32_t *)out, 8);
-
-out:
-	return err;
-}
-
-static int padlock_sha256_final(struct shash_desc *desc, u8 *out)
-{
-	const u8 *buf = (void *)desc;
-
-	return padlock_sha256_finup(desc, buf, 0, out);
+	padlock_output_block(state->state, (uint32_t *)out, 8);
+	return 0;
 }
 
 static int padlock_init_tfm(struct crypto_shash *hash)
 {
 	const char *fallback_driver_name = crypto_shash_alg_name(hash);
 	struct padlock_sha_ctx *ctx = crypto_shash_ctx(hash);
-	struct crypto_shash *fallback_tfm;
+	struct crypto_ahash *fallback_tfm;
 
 	/* Allocate a fallback and abort if it failed. */
-	fallback_tfm = crypto_alloc_shash(fallback_driver_name, 0,
-					  CRYPTO_ALG_NEED_FALLBACK);
+	fallback_tfm = crypto_alloc_ahash(fallback_driver_name, 0,
+					  CRYPTO_ALG_NEED_FALLBACK |
+					  CRYPTO_ALG_ASYNC);
 	if (IS_ERR(fallback_tfm)) {
 		printk(KERN_WARNING PFX "Fallback driver '%s' could not be loaded!\n",
 		       fallback_driver_name);
 		return PTR_ERR(fallback_tfm);
 	}
 
-	if (crypto_shash_descsize(hash) < sizeof(struct padlock_sha_desc) +
-					  crypto_shash_descsize(fallback_tfm)) {
-		crypto_free_shash(fallback_tfm);
+	if (crypto_shash_statesize(hash) <
+	    crypto_ahash_statesize(fallback_tfm)) {
+		crypto_free_ahash(fallback_tfm);
 		return -EINVAL;
 	}
 
@@ -221,27 +180,27 @@ static void padlock_exit_tfm(struct crypto_shash *hash)
 {
 	struct padlock_sha_ctx *ctx = crypto_shash_ctx(hash);
 
-	crypto_free_shash(ctx->fallback);
+	crypto_free_ahash(ctx->fallback);
 }
 
 static struct shash_alg sha1_alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
-	.init   	= 	padlock_sha_init,
+	.init   	= 	padlock_sha1_init,
 	.update 	=	padlock_sha_update,
 	.finup  	=	padlock_sha1_finup,
-	.final  	=	padlock_sha1_final,
 	.export		=	padlock_sha_export,
 	.import		=	padlock_sha_import,
 	.init_tfm	=	padlock_init_tfm,
 	.exit_tfm	=	padlock_exit_tfm,
-	.descsize	=	sizeof(struct padlock_sha_desc) +
-				sizeof(struct sha1_state),
-	.statesize	=	sizeof(struct sha1_state),
+	.descsize	=	PADLOCK_SHA_DESCSIZE,
+	.statesize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name		=	"sha1",
 		.cra_driver_name	=	"sha1-padlock",
 		.cra_priority		=	PADLOCK_CRA_PRIORITY,
-		.cra_flags		=	CRYPTO_ALG_NEED_FALLBACK,
+		.cra_flags		=	CRYPTO_ALG_NEED_FALLBACK |
+						CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		=	SHA1_BLOCK_SIZE,
 		.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
 		.cra_module		=	THIS_MODULE,
@@ -250,22 +209,22 @@ static struct shash_alg sha1_alg = {
 
 static struct shash_alg sha256_alg = {
 	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init   	= 	padlock_sha_init,
+	.init   	= 	padlock_sha256_init,
 	.update 	=	padlock_sha_update,
 	.finup  	=	padlock_sha256_finup,
-	.final  	=	padlock_sha256_final,
+	.init_tfm	=	padlock_init_tfm,
 	.export		=	padlock_sha_export,
 	.import		=	padlock_sha_import,
-	.init_tfm	=	padlock_init_tfm,
 	.exit_tfm	=	padlock_exit_tfm,
-	.descsize	=	sizeof(struct padlock_sha_desc) +
-				sizeof(struct sha256_state),
-	.statesize	=	sizeof(struct sha256_state),
+	.descsize	=	PADLOCK_SHA_DESCSIZE,
+	.statesize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name		=	"sha256",
 		.cra_driver_name	=	"sha256-padlock",
 		.cra_priority		=	PADLOCK_CRA_PRIORITY,
-		.cra_flags		=	CRYPTO_ALG_NEED_FALLBACK,
+		.cra_flags		=	CRYPTO_ALG_NEED_FALLBACK |
+						CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		=	SHA256_BLOCK_SIZE,
 		.cra_ctxsize		=	sizeof(struct padlock_sha_ctx),
 		.cra_module		=	THIS_MODULE,
@@ -274,207 +233,58 @@ static struct shash_alg sha256_alg = {
 
 /* Add two shash_alg instance for hardware-implemented *
 * multiple-parts hash supported by VIA Nano Processor.*/
-static int padlock_sha1_init_nano(struct shash_desc *desc)
-{
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-
-	*sctx = (struct sha1_state){
-		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
-	};
-
-	return 0;
-}
 
 static int padlock_sha1_update_nano(struct shash_desc *desc,
-			const u8 *data,	unsigned int len)
+				    const u8 *src, unsigned int len)
 {
-	struct sha1_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial, done;
-	const u8 *src;
 	/*The PHE require the out buffer must 128 bytes and 16-bytes aligned*/
-	u8 buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
-		((aligned(STACK_ALIGN)));
-	u8 *dst = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+	struct sha1_state *state = padlock_shash_desc_ctx(desc);
+	int blocks = len / SHA1_BLOCK_SIZE;
 
-	partial = sctx->count & 0x3f;
-	sctx->count += len;
-	done = 0;
-	src = data;
-	memcpy(dst, (u8 *)(sctx->state), SHA1_DIGEST_SIZE);
+	len -= blocks * SHA1_BLOCK_SIZE;
+	state->count += blocks * SHA1_BLOCK_SIZE;
 
-	if ((partial + len) >= SHA1_BLOCK_SIZE) {
-
-		/* Append the bytes in state's buffer to a block to handle */
-		if (partial) {
-			done = -partial;
-			memcpy(sctx->buffer + partial, data,
-				done + SHA1_BLOCK_SIZE);
-			src = sctx->buffer;
-			asm volatile (".byte 0xf3,0x0f,0xa6,0xc8"
-			: "+S"(src), "+D"(dst) \
-			: "a"((long)-1), "c"((unsigned long)1));
-			done += SHA1_BLOCK_SIZE;
-			src = data + done;
-		}
-
-		/* Process the left bytes from the input data */
-		if (len - done >= SHA1_BLOCK_SIZE) {
-			asm volatile (".byte 0xf3,0x0f,0xa6,0xc8"
-			: "+S"(src), "+D"(dst)
-			: "a"((long)-1),
-			"c"((unsigned long)((len - done) / SHA1_BLOCK_SIZE)));
-			done += ((len - done) - (len - done) % SHA1_BLOCK_SIZE);
-			src = data + done;
-		}
-		partial = 0;
-	}
-	memcpy((u8 *)(sctx->state), dst, SHA1_DIGEST_SIZE);
-	memcpy(sctx->buffer + partial, src, len - done);
-
-	return 0;
+	/* Process the left bytes from the input data */
+	asm volatile (".byte 0xf3,0x0f,0xa6,0xc8"
+		      : "+S"(src), "+D"(state)
+		      : "a"((long)-1),
+			"c"((unsigned long)blocks));
+	return len;
 }
 
-static int padlock_sha1_final_nano(struct shash_desc *desc, u8 *out)
-{
-	struct sha1_state *state = (struct sha1_state *)shash_desc_ctx(desc);
-	unsigned int partial, padlen;
-	__be64 bits;
-	static const u8 padding[64] = { 0x80, };
-
-	bits = cpu_to_be64(state->count << 3);
-
-	/* Pad out to 56 mod 64 */
-	partial = state->count & 0x3f;
-	padlen = (partial < 56) ? (56 - partial) : ((64+56) - partial);
-	padlock_sha1_update_nano(desc, padding, padlen);
-
-	/* Append length field bytes */
-	padlock_sha1_update_nano(desc, (const u8 *)&bits, sizeof(bits));
-
-	/* Swap to output */
-	padlock_output_block((uint32_t *)(state->state), (uint32_t *)out, 5);
-
-	return 0;
-}
-
-static int padlock_sha256_init_nano(struct shash_desc *desc)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	*sctx = (struct sha256_state){
-		.state = { SHA256_H0, SHA256_H1, SHA256_H2, SHA256_H3, \
-				SHA256_H4, SHA256_H5, SHA256_H6, SHA256_H7},
-	};
-
-	return 0;
-}
-
-static int padlock_sha256_update_nano(struct shash_desc *desc, const u8 *data,
+static int padlock_sha256_update_nano(struct shash_desc *desc, const u8 *src,
 			  unsigned int len)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial, done;
-	const u8 *src;
 	/*The PHE require the out buffer must 128 bytes and 16-bytes aligned*/
-	u8 buf[128 + PADLOCK_ALIGNMENT - STACK_ALIGN] __attribute__
-		((aligned(STACK_ALIGN)));
-	u8 *dst = PTR_ALIGN(&buf[0], PADLOCK_ALIGNMENT);
+	struct crypto_sha256_state *state = padlock_shash_desc_ctx(desc);
+	int blocks = len / SHA256_BLOCK_SIZE;
 
-	partial = sctx->count & 0x3f;
-	sctx->count += len;
-	done = 0;
-	src = data;
-	memcpy(dst, (u8 *)(sctx->state), SHA256_DIGEST_SIZE);
+	len -= blocks * SHA256_BLOCK_SIZE;
+	state->count += blocks * SHA256_BLOCK_SIZE;
 
-	if ((partial + len) >= SHA256_BLOCK_SIZE) {
-
-		/* Append the bytes in state's buffer to a block to handle */
-		if (partial) {
-			done = -partial;
-			memcpy(sctx->buf + partial, data,
-				done + SHA256_BLOCK_SIZE);
-			src = sctx->buf;
-			asm volatile (".byte 0xf3,0x0f,0xa6,0xd0"
-			: "+S"(src), "+D"(dst)
-			: "a"((long)-1), "c"((unsigned long)1));
-			done += SHA256_BLOCK_SIZE;
-			src = data + done;
-		}
-
-		/* Process the left bytes from input data*/
-		if (len - done >= SHA256_BLOCK_SIZE) {
-			asm volatile (".byte 0xf3,0x0f,0xa6,0xd0"
-			: "+S"(src), "+D"(dst)
-			: "a"((long)-1),
-			"c"((unsigned long)((len - done) / 64)));
-			done += ((len - done) - (len - done) % 64);
-			src = data + done;
-		}
-		partial = 0;
-	}
-	memcpy((u8 *)(sctx->state), dst, SHA256_DIGEST_SIZE);
-	memcpy(sctx->buf + partial, src, len - done);
-
-	return 0;
-}
-
-static int padlock_sha256_final_nano(struct shash_desc *desc, u8 *out)
-{
-	struct sha256_state *state =
-		(struct sha256_state *)shash_desc_ctx(desc);
-	unsigned int partial, padlen;
-	__be64 bits;
-	static const u8 padding[64] = { 0x80, };
-
-	bits = cpu_to_be64(state->count << 3);
-
-	/* Pad out to 56 mod 64 */
-	partial = state->count & 0x3f;
-	padlen = (partial < 56) ? (56 - partial) : ((64+56) - partial);
-	padlock_sha256_update_nano(desc, padding, padlen);
-
-	/* Append length field bytes */
-	padlock_sha256_update_nano(desc, (const u8 *)&bits, sizeof(bits));
-
-	/* Swap to output */
-	padlock_output_block((uint32_t *)(state->state), (uint32_t *)out, 8);
-
-	return 0;
-}
-
-static int padlock_sha_export_nano(struct shash_desc *desc,
-				void *out)
-{
-	int statesize = crypto_shash_statesize(desc->tfm);
-	void *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, statesize);
-	return 0;
-}
-
-static int padlock_sha_import_nano(struct shash_desc *desc,
-				const void *in)
-{
-	int statesize = crypto_shash_statesize(desc->tfm);
-	void *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, statesize);
-	return 0;
+	/* Process the left bytes from input data*/
+	asm volatile (".byte 0xf3,0x0f,0xa6,0xd0"
+		      : "+S"(src), "+D"(state)
+		      : "a"((long)-1),
+		      "c"((unsigned long)blocks));
+	return len;
 }
 
 static struct shash_alg sha1_alg_nano = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
-	.init		=	padlock_sha1_init_nano,
+	.init		=	padlock_sha1_init,
 	.update		=	padlock_sha1_update_nano,
-	.final		=	padlock_sha1_final_nano,
-	.export		=	padlock_sha_export_nano,
-	.import		=	padlock_sha_import_nano,
-	.descsize	=	sizeof(struct sha1_state),
-	.statesize	=	sizeof(struct sha1_state),
+	.finup  	=	padlock_sha1_finup,
+	.export		=	padlock_sha_export,
+	.import		=	padlock_sha_import,
+	.descsize	=	PADLOCK_SHA_DESCSIZE,
+	.statesize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name		=	"sha1",
 		.cra_driver_name	=	"sha1-padlock-nano",
 		.cra_priority		=	PADLOCK_CRA_PRIORITY,
+		.cra_flags		=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		=	SHA1_BLOCK_SIZE,
 		.cra_module		=	THIS_MODULE,
 	}
@@ -482,17 +292,19 @@ static struct shash_alg sha1_alg_nano = {
 
 static struct shash_alg sha256_alg_nano = {
 	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	padlock_sha256_init_nano,
+	.init		=	padlock_sha256_init,
 	.update		=	padlock_sha256_update_nano,
-	.final		=	padlock_sha256_final_nano,
-	.export		=	padlock_sha_export_nano,
-	.import		=	padlock_sha_import_nano,
-	.descsize	=	sizeof(struct sha256_state),
-	.statesize	=	sizeof(struct sha256_state),
+	.finup		=	padlock_sha256_finup,
+	.export		=	padlock_sha_export,
+	.import		=	padlock_sha_import,
+	.descsize	=	PADLOCK_SHA_DESCSIZE,
+	.statesize	=	sizeof(struct crypto_sha256_state),
 	.base		=	{
 		.cra_name		=	"sha256",
 		.cra_driver_name	=	"sha256-padlock-nano",
 		.cra_priority		=	PADLOCK_CRA_PRIORITY,
+		.cra_flags		=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize		=	SHA256_BLOCK_SIZE,
 		.cra_module		=	THIS_MODULE,
 	}
-- 
2.39.5

