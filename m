Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA5B2686B1
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945244; cv=none; b=BpbRpgTgOqn/jkGtg7UfwZDHPzmyUbiRfMpC+YgGDfexFpuP2xTJ33s/L83fQTRjky28QhwwVjTCOp0NLFQq+lFXq2LrmzqxQOcaykOBsFGR2PRkdUEoS/M0bFEL7nEdrV/YwvOUiUqr84PfSr75lSMrBpwbftxXMl7lV8cSJwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945244; c=relaxed/simple;
	bh=/D8pmQd17lFZpferQVIrbaSOdkFDu/Fyj3keE+ky0N0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=pj0Oh+XLrgtYjjiZafc0k6dPY5GbodVao5MtNhTwheeMWInLVkBFyinsVB+GdDXrTkWxQuo+/Ua/lMO6JsUCNiA93hjIEVF9plXl3gBvgG2SZ/JGjDXyhkgTN/H3Olu7h/4e2WzYwyZTxTPo90mF0LU++9W58vMsidzBENdapQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sYVQPvJW; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sYVQPvJW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6sWZPkZ7sTQaY7Me3UGzKNk2/7nTobCLXJtToAZzvVM=; b=sYVQPvJW2Vyb1wSFpmMJbSYDc+
	5FzcWmsCbaDL+a319XPwG77q1XdsIobcAKZfpRrs2FgSs6J12yG8/BOynhOF19qxwrZzCeaKO3OXp
	oPsNF6E3bMVT569KU+KV5rW/Jg+qAao7aqbRxQEiW/7h08OwCnzQBbCZ/H6xZNFjGTZbxcEYSHkhs
	bkZj2mFxRk1c4h6ZqFbYKXpiUmfT5ypqcr37owjJ3ty/GKPsx1H6Tpo4MiZSt0DrvlFzK4a4khp+r
	VtmTQFZweMoWAr+1py+Vh81iv9nilLofRkOXqoq2n7lz7nHWvSIPStxC8eTq6TNxUqhM72fQIX/xC
	94e9JJNg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5by2-00GeGF-2Y;
	Fri, 18 Apr 2025 11:00:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:38 +0800
Date: Fri, 18 Apr 2025 11:00:38 +0800
Message-Id: <b9eed6aaa971feb5edcae78c4cc5e5b1ab1d8abb.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 52/67] crypto: s390/sha512 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/sha.h         |  14 ++--
 arch/s390/crypto/sha512_s390.c |  45 ++++++------
 arch/s390/crypto/sha_common.c  | 124 ++++-----------------------------
 3 files changed, 47 insertions(+), 136 deletions(-)

diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
index d95437ebe1ca..0a3cc1739144 100644
--- a/arch/s390/crypto/sha.h
+++ b/arch/s390/crypto/sha.h
@@ -10,28 +10,32 @@
 #ifndef _CRYPTO_ARCH_S390_SHA_H
 #define _CRYPTO_ARCH_S390_SHA_H
 
+#include <crypto/sha2.h>
 #include <crypto/sha3.h>
 #include <linux/types.h>
 
 /* must be big enough for the largest SHA variant */
 #define CPACF_MAX_PARMBLOCK_SIZE	SHA3_STATE_SIZE
 #define SHA_MAX_BLOCK_SIZE		SHA3_224_BLOCK_SIZE
-#define S390_SHA_CTX_SIZE		offsetof(struct s390_sha_ctx, buf)
+#define S390_SHA_CTX_SIZE		sizeof(struct s390_sha_ctx)
 
 struct s390_sha_ctx {
 	u64 count;		/* message length in bytes */
-	u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
+	union {
+		u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
+		struct {
+			u64 state[SHA512_DIGEST_SIZE];
+			u64 count_hi;
+		} sha512;
+	};
 	int func;		/* KIMD function to use */
 	bool first_message_part;
-	u8 buf[SHA_MAX_BLOCK_SIZE];
 };
 
 struct shash_desc;
 
-int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len);
 int s390_sha_update_blocks(struct shash_desc *desc, const u8 *data,
 			   unsigned int len);
-int s390_sha_final(struct shash_desc *desc, u8 *out);
 int s390_sha_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 		   u8 *out);
 
diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index 04f11c407763..14818fcc9cd4 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -7,14 +7,13 @@
  * Copyright IBM Corp. 2007
  * Author(s): Jan Glauber (jang@de.ibm.com)
  */
+#include <asm/cpacf.h>
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
+#include <linux/cpufeature.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/cpufeature.h>
-#include <asm/cpacf.h>
 
 #include "sha.h"
 
@@ -22,15 +21,16 @@ static int sha512_init(struct shash_desc *desc)
 {
 	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
 
-	*(__u64 *)&ctx->state[0] = SHA512_H0;
-	*(__u64 *)&ctx->state[2] = SHA512_H1;
-	*(__u64 *)&ctx->state[4] = SHA512_H2;
-	*(__u64 *)&ctx->state[6] = SHA512_H3;
-	*(__u64 *)&ctx->state[8] = SHA512_H4;
-	*(__u64 *)&ctx->state[10] = SHA512_H5;
-	*(__u64 *)&ctx->state[12] = SHA512_H6;
-	*(__u64 *)&ctx->state[14] = SHA512_H7;
+	ctx->sha512.state[0] = SHA512_H0;
+	ctx->sha512.state[2] = SHA512_H1;
+	ctx->sha512.state[4] = SHA512_H2;
+	ctx->sha512.state[6] = SHA512_H3;
+	ctx->sha512.state[8] = SHA512_H4;
+	ctx->sha512.state[10] = SHA512_H5;
+	ctx->sha512.state[12] = SHA512_H6;
+	ctx->sha512.state[14] = SHA512_H7;
 	ctx->count = 0;
+	ctx->sha512.count_hi = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
 
 	return 0;
@@ -42,9 +42,8 @@ static int sha512_export(struct shash_desc *desc, void *out)
 	struct sha512_state *octx = out;
 
 	octx->count[0] = sctx->count;
-	octx->count[1] = 0;
+	octx->count[1] = sctx->sha512.count_hi;
 	memcpy(octx->state, sctx->state, sizeof(octx->state));
-	memcpy(octx->buf, sctx->buf, sizeof(octx->buf));
 	return 0;
 }
 
@@ -53,12 +52,10 @@ static int sha512_import(struct shash_desc *desc, const void *in)
 	struct s390_sha_ctx *sctx = shash_desc_ctx(desc);
 	const struct sha512_state *ictx = in;
 
-	if (unlikely(ictx->count[1]))
-		return -ERANGE;
 	sctx->count = ictx->count[0];
+	sctx->sha512.count_hi = ictx->count[1];
 
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
-	memcpy(sctx->buf, ictx->buf, sizeof(ictx->buf));
 	sctx->func = CPACF_KIMD_SHA_512;
 	return 0;
 }
@@ -66,16 +63,18 @@ static int sha512_import(struct shash_desc *desc, const void *in)
 static struct shash_alg sha512_alg = {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_init,
-	.update		=	s390_sha_update,
-	.final		=	s390_sha_final,
+	.update		=	s390_sha_update_blocks,
+	.finup		=	s390_sha_finup,
 	.export		=	sha512_export,
 	.import		=	sha512_import,
 	.descsize	=	sizeof(struct s390_sha_ctx),
-	.statesize	=	sizeof(struct sha512_state),
+	.statesize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_driver_name=	"sha512-s390",
 		.cra_priority	=	300,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -104,17 +103,19 @@ static int sha384_init(struct shash_desc *desc)
 static struct shash_alg sha384_alg = {
 	.digestsize	=	SHA384_DIGEST_SIZE,
 	.init		=	sha384_init,
-	.update		=	s390_sha_update,
-	.final		=	s390_sha_final,
+	.update		=	s390_sha_update_blocks,
+	.finup		=	s390_sha_finup,
 	.export		=	sha512_export,
 	.import		=	sha512_import,
 	.descsize	=	sizeof(struct s390_sha_ctx),
-	.statesize	=	sizeof(struct sha512_state),
+	.statesize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_driver_name=	"sha384-s390",
 		.cra_priority	=	300,
 		.cra_blocksize	=	SHA384_BLOCK_SIZE,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_ctxsize	=	sizeof(struct s390_sha_ctx),
 		.cra_module	=	THIS_MODULE,
 	}
diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index 69e23e0c5394..b5e2c365ea05 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -13,51 +13,6 @@
 #include <asm/cpacf.h>
 #include "sha.h"
 
-int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
-{
-	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
-	unsigned int bsize = crypto_shash_blocksize(desc->tfm);
-	unsigned int index, n;
-	int fc;
-
-	/* how much is already in the buffer? */
-	index = ctx->count % bsize;
-	ctx->count += len;
-
-	if ((index + len) < bsize)
-		goto store;
-
-	fc = ctx->func;
-	if (ctx->first_message_part)
-		fc |= CPACF_KIMD_NIP;
-
-	/* process one stored block */
-	if (index) {
-		memcpy(ctx->buf + index, data, bsize - index);
-		cpacf_kimd(fc, ctx->state, ctx->buf, bsize);
-		ctx->first_message_part = 0;
-		fc &= ~CPACF_KIMD_NIP;
-		data += bsize - index;
-		len -= bsize - index;
-		index = 0;
-	}
-
-	/* process as many blocks as possible */
-	if (len >= bsize) {
-		n = (len / bsize) * bsize;
-		cpacf_kimd(fc, ctx->state, data, n);
-		ctx->first_message_part = 0;
-		data += n;
-		len -= n;
-	}
-store:
-	if (len)
-		memcpy(ctx->buf + index , data, len);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(s390_sha_update);
-
 int s390_sha_update_blocks(struct shash_desc *desc, const u8 *data,
 			   unsigned int len)
 {
@@ -73,6 +28,13 @@ int s390_sha_update_blocks(struct shash_desc *desc, const u8 *data,
 	/* process as many blocks as possible */
 	n = (len / bsize) * bsize;
 	ctx->count += n;
+	switch (ctx->func) {
+	case CPACF_KLMD_SHA_512:
+	case CPACF_KLMD_SHA3_384:
+		if (ctx->count < n)
+			ctx->sha512.count_hi++;
+		break;
+	}
 	cpacf_kimd(fc, ctx->state, data, n);
 	ctx->first_message_part = 0;
 	return len - n;
@@ -98,61 +60,6 @@ static int s390_crypto_shash_parmsize(int func)
 	}
 }
 
-int s390_sha_final(struct shash_desc *desc, u8 *out)
-{
-	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
-	unsigned int bsize = crypto_shash_blocksize(desc->tfm);
-	u64 bits;
-	unsigned int n;
-	int mbl_offset, fc;
-
-	n = ctx->count % bsize;
-	bits = ctx->count * 8;
-	mbl_offset = s390_crypto_shash_parmsize(ctx->func);
-	if (mbl_offset < 0)
-		return -EINVAL;
-
-	mbl_offset = mbl_offset / sizeof(u32);
-
-	/* set total msg bit length (mbl) in CPACF parmblock */
-	switch (ctx->func) {
-	case CPACF_KLMD_SHA_1:
-	case CPACF_KLMD_SHA_256:
-		memcpy(ctx->state + mbl_offset, &bits, sizeof(bits));
-		break;
-	case CPACF_KLMD_SHA_512:
-		/*
-		 * the SHA512 parmblock has a 128-bit mbl field, clear
-		 * high-order u64 field, copy bits to low-order u64 field
-		 */
-		memset(ctx->state + mbl_offset, 0x00, sizeof(bits));
-		mbl_offset += sizeof(u64) / sizeof(u32);
-		memcpy(ctx->state + mbl_offset, &bits, sizeof(bits));
-		break;
-	case CPACF_KLMD_SHA3_224:
-	case CPACF_KLMD_SHA3_256:
-	case CPACF_KLMD_SHA3_384:
-	case CPACF_KLMD_SHA3_512:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	fc = ctx->func;
-	fc |= test_facility(86) ? CPACF_KLMD_DUFOP : 0;
-	if (ctx->first_message_part)
-		fc |= CPACF_KLMD_NIP;
-	cpacf_klmd(fc, ctx->state, ctx->buf, n);
-
-	/* copy digest to out */
-	memcpy(out, ctx->state, crypto_shash_digestsize(desc->tfm));
-	/* wipe context */
-	memset(ctx, 0, sizeof *ctx);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(s390_sha_final);
-
 int s390_sha_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 		   u8 *out)
 {
@@ -171,19 +78,18 @@ int s390_sha_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
 
 	/* set total msg bit length (mbl) in CPACF parmblock */
 	switch (ctx->func) {
+	case CPACF_KLMD_SHA_512:
+		/* The SHA512 parmblock has a 128-bit mbl field. */
+		if (ctx->count < len)
+			ctx->sha512.count_hi++;
+		ctx->sha512.count_hi <<= 3;
+		ctx->sha512.count_hi |= ctx->count >> 61;
+		mbl_offset += sizeof(u64) / sizeof(u32);
+		fallthrough;
 	case CPACF_KLMD_SHA_1:
 	case CPACF_KLMD_SHA_256:
 		memcpy(ctx->state + mbl_offset, &bits, sizeof(bits));
 		break;
-	case CPACF_KLMD_SHA_512:
-		/*
-		 * the SHA512 parmblock has a 128-bit mbl field, clear
-		 * high-order u64 field, copy bits to low-order u64 field
-		 */
-		memset(ctx->state + mbl_offset, 0x00, sizeof(bits));
-		mbl_offset += sizeof(u64) / sizeof(u32);
-		memcpy(ctx->state + mbl_offset, &bits, sizeof(bits));
-		break;
 	case CPACF_KLMD_SHA3_224:
 	case CPACF_KLMD_SHA3_256:
 	case CPACF_KLMD_SHA3_384:
-- 
2.39.5

