Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200CC236A84
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785824; cv=none; b=K7e5C9qH9yboh/ZonKsy+pv1y5s+7oznbp7fvrDNHvvDFTRfo/rTqxrVIe7oZWcKdDonLRH7voZVrfsGTktMtloHU7fY/lhj2hZ1n2lIAnNuqk+jyfgm6JFPOz8CRJj99ufyK9bDsZKITIc5LmmYDt834hSRuMZjmCG+iyodVHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785824; c=relaxed/simple;
	bh=UXvbaJyq9NIKw/sAwp68/dgryXrJ3+tjxZruWNvHLN0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=P8knDPFpr5ZlnQoRAZfLAPPXqZVGXJ5/60kOFAmGhdWgmmDHQ0Iy+43Vwu3QS3lujMag02LPEJ/EjpwD9TVkcIAJ5hMHEcPGaQvOSegAB02h9x6r0VTr8nxipcrcFO122bxIcv/B3z58HSzE5+jWe9HFbAT9sXC6YFKBUvZBWtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=E9nHoYXf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="E9nHoYXf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3hSKvRlcpN+7C5wssnesJEakYLpXDG5dtibTB8aB98I=; b=E9nHoYXfubq+dkuhQmji0IGnD6
	iNVIOqieVdV+FD+Y6x44lFD5DLaTJrQwn+xLVEjGWjsefMf3pwHvz3qVNf9aEBtu9LsVLoCfJ9235
	XWSs857aF9pp1TMhoZJBkKd5aZ6BKvoduuZ7yquHOmqX5TMszegEThFNp6QAyqAzawpdT7OY1MMjZ
	EYBIgGVd69vXpJaWHISF9zdPD1cQITPlw2v8xB2cT1DoTkhMFG7xLfYEzzz/5q2q6pEiim3G4FUM3
	8vkB81YE0ka3gFNF82Vd9nvIG2Pe+xbfKWjgCrtyBdWPPiZdXtSebPHv81V4g9SQXqQwZG6NPTr6+
	glWJB+uQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUk-00G6Ka-0g;
	Wed, 16 Apr 2025 14:43:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:38 +0800
Date: Wed, 16 Apr 2025 14:43:38 +0800
Message-Id: <6b971860a0853cc3af5c70f324dd2749795c3867.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 24/67] crypto: s390/sha1 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/sha.h        | 13 +++---
 arch/s390/crypto/sha1_s390.c  | 22 +++++------
 arch/s390/crypto/sha_common.c | 74 +++++++++++++++++++++++++++++++++++
 3 files changed, 93 insertions(+), 16 deletions(-)

diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
index 2bb22db54c31..b8aeb51b2f3d 100644
--- a/arch/s390/crypto/sha.h
+++ b/arch/s390/crypto/sha.h
@@ -10,27 +10,30 @@
 #ifndef _CRYPTO_ARCH_S390_SHA_H
 #define _CRYPTO_ARCH_S390_SHA_H
 
-#include <linux/crypto.h>
-#include <crypto/sha1.h>
-#include <crypto/sha2.h>
 #include <crypto/sha3.h>
+#include <linux/types.h>
 
 /* must be big enough for the largest SHA variant */
 #define SHA3_STATE_SIZE			200
 #define CPACF_MAX_PARMBLOCK_SIZE	SHA3_STATE_SIZE
 #define SHA_MAX_BLOCK_SIZE		SHA3_224_BLOCK_SIZE
+#define S390_SHA_CTX_SIZE		offsetof(struct s390_sha_ctx, buf)
 
 struct s390_sha_ctx {
 	u64 count;		/* message length in bytes */
 	u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
-	u8 buf[SHA_MAX_BLOCK_SIZE];
 	int func;		/* KIMD function to use */
-	int first_message_part;
+	bool first_message_part;
+	u8 buf[SHA_MAX_BLOCK_SIZE];
 };
 
 struct shash_desc;
 
 int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len);
+int s390_sha_update_blocks(struct shash_desc *desc, const u8 *data,
+			   unsigned int len);
 int s390_sha_final(struct shash_desc *desc, u8 *out);
+int s390_sha_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
+		   u8 *out);
 
 #endif
diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
index bc3a22704e09..d229cbd2ba22 100644
--- a/arch/s390/crypto/sha1_s390.c
+++ b/arch/s390/crypto/sha1_s390.c
@@ -18,12 +18,12 @@
  *   Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
  *   Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
  */
-#include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/cpufeature.h>
-#include <crypto/sha1.h>
 #include <asm/cpacf.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha1.h>
+#include <linux/cpufeature.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 #include "sha.h"
 
@@ -49,7 +49,6 @@ static int s390_sha1_export(struct shash_desc *desc, void *out)
 
 	octx->count = sctx->count;
 	memcpy(octx->state, sctx->state, sizeof(octx->state));
-	memcpy(octx->buffer, sctx->buf, sizeof(octx->buffer));
 	return 0;
 }
 
@@ -60,7 +59,6 @@ static int s390_sha1_import(struct shash_desc *desc, const void *in)
 
 	sctx->count = ictx->count;
 	memcpy(sctx->state, ictx->state, sizeof(ictx->state));
-	memcpy(sctx->buf, ictx->buffer, sizeof(ictx->buffer));
 	sctx->func = CPACF_KIMD_SHA_1;
 	return 0;
 }
@@ -68,16 +66,18 @@ static int s390_sha1_import(struct shash_desc *desc, const void *in)
 static struct shash_alg alg = {
 	.digestsize	=	SHA1_DIGEST_SIZE,
 	.init		=	s390_sha1_init,
-	.update		=	s390_sha_update,
-	.final		=	s390_sha_final,
+	.update		=	s390_sha_update_blocks,
+	.finup		=	s390_sha_finup,
 	.export		=	s390_sha1_export,
 	.import		=	s390_sha1_import,
-	.descsize	=	sizeof(struct s390_sha_ctx),
-	.statesize	=	sizeof(struct sha1_state),
+	.descsize	=	S390_SHA_CTX_SIZE,
+	.statesize	=	SHA1_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha1",
 		.cra_driver_name=	"sha1-s390",
 		.cra_priority	=	300,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA1_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
diff --git a/arch/s390/crypto/sha_common.c b/arch/s390/crypto/sha_common.c
index 961d7d522af1..013bb37ad3ef 100644
--- a/arch/s390/crypto/sha_common.c
+++ b/arch/s390/crypto/sha_common.c
@@ -58,6 +58,27 @@ int s390_sha_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 }
 EXPORT_SYMBOL_GPL(s390_sha_update);
 
+int s390_sha_update_blocks(struct shash_desc *desc, const u8 *data,
+			   unsigned int len)
+{
+	unsigned int bsize = crypto_shash_blocksize(desc->tfm);
+	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int n;
+	int fc;
+
+	fc = ctx->func;
+	if (ctx->first_message_part)
+		fc |= test_facility(86) ? CPACF_KIMD_NIP : 0;
+
+	/* process as many blocks as possible */
+	n = (len / bsize) * bsize;
+	ctx->count += n;
+	cpacf_kimd(fc, ctx->state, data, n);
+	ctx->first_message_part = 0;
+	return len - n;
+}
+EXPORT_SYMBOL_GPL(s390_sha_update_blocks);
+
 static int s390_crypto_shash_parmsize(int func)
 {
 	switch (func) {
@@ -132,5 +153,58 @@ int s390_sha_final(struct shash_desc *desc, u8 *out)
 }
 EXPORT_SYMBOL_GPL(s390_sha_final);
 
+int s390_sha_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
+		   u8 *out)
+{
+	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
+	int mbl_offset, fc;
+	u64 bits;
+
+	ctx->count += len;
+
+	bits = ctx->count * 8;
+	mbl_offset = s390_crypto_shash_parmsize(ctx->func);
+	if (mbl_offset < 0)
+		return -EINVAL;
+
+	mbl_offset = mbl_offset / sizeof(u32);
+
+	/* set total msg bit length (mbl) in CPACF parmblock */
+	switch (ctx->func) {
+	case CPACF_KLMD_SHA_1:
+	case CPACF_KLMD_SHA_256:
+		memcpy(ctx->state + mbl_offset, &bits, sizeof(bits));
+		break;
+	case CPACF_KLMD_SHA_512:
+		/*
+		 * the SHA512 parmblock has a 128-bit mbl field, clear
+		 * high-order u64 field, copy bits to low-order u64 field
+		 */
+		memset(ctx->state + mbl_offset, 0x00, sizeof(bits));
+		mbl_offset += sizeof(u64) / sizeof(u32);
+		memcpy(ctx->state + mbl_offset, &bits, sizeof(bits));
+		break;
+	case CPACF_KLMD_SHA3_224:
+	case CPACF_KLMD_SHA3_256:
+	case CPACF_KLMD_SHA3_384:
+	case CPACF_KLMD_SHA3_512:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	fc = ctx->func;
+	fc |= test_facility(86) ? CPACF_KLMD_DUFOP : 0;
+	if (ctx->first_message_part)
+		fc |= CPACF_KLMD_NIP;
+	cpacf_klmd(fc, ctx->state, src, len);
+
+	/* copy digest to out */
+	memcpy(out, ctx->state, crypto_shash_digestsize(desc->tfm));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s390_sha_finup);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("s390 SHA cipher common functions");
-- 
2.39.5

