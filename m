Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3F3268699
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945156; cv=none; b=nhSosN4W08bHu2mbqxWzRfFHvn2AfgLsQ0PH3xY/yBUnKTER8SqAJVLtTYKomaUAmiuqNtRTMEGSPC8zoyFI9QkEYosTQYf7o76fBBs6Hdacz0E/xZwr3Qc/DT5IonrYhPexe+0ivup8yRGY5q97LvFd6guTEdIy4m4g1Rfw9CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945156; c=relaxed/simple;
	bh=Cy7fC47cEuIs7KRgTcp01SVwQ8Lb7hWDBOauaUxM5hY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=q5elvhnZLY0KmSBzw9B0oD8WHCNZg6DxsLQXJ37dt86H7DDX0+sILWHKDd/8LPO5pXZloTLqD0TIAFJLQYd8xIM+D8EpOQZUJtuZjgv/52VGJceK4kLZrL4KGVRsk4PS9/3zsOVoHSmC1QPQc6Hzn+pJqjw5ZbPbJYW9HzeWd7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=d5fjAhma; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="d5fjAhma"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0LnuIPY/2WNGVJBnBlN/URT9vWJAi5us80zTkozX0vg=; b=d5fjAhmaRDoQLThveJatxXx9p8
	8StdtBrDIzVl0XcfoYFJ7vIQLz2Ok6STWwVP3cnCF6xGc5VicV7kP4JRgK6MzLAUNfhc2Fau9DZIL
	5O7Z9mQToDbb4uyZ7RfX5CxeCUxfsTdTcC+EyM+CyjlBWosEmt7GRKcnhcwCfQFP7dhGHm4k+0V5h
	dXBkwF1SJxWzMWeInhNyPOw3aPh/u3TfJ7fL4CdhvEQfrKVeTG9Ra5TEPcBkj3gpM6SEy2pPGT9CY
	FvWyOe72OYLG9EL5IcuZST+hPpPpkehv94U0/PDHBXECYTlVH5DoWrPpYzuTeY/5MHroRE9H0YmR/
	d9zYPLYg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwd-00Ge4q-0a;
	Fri, 18 Apr 2025 10:59:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:59:11 +0800
Date: Fri, 18 Apr 2025 10:59:11 +0800
Message-Id: <3299f744462ab6a708897507c926981a58870ba8.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 14/67] crypto: sparc/md5 - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also switch to the generic export format.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/sparc/crypto/md5_glue.c | 141 ++++++++++++++++-------------------
 1 file changed, 63 insertions(+), 78 deletions(-)

diff --git a/arch/sparc/crypto/md5_glue.c b/arch/sparc/crypto/md5_glue.c
index 511db98d590a..5b018c6a376c 100644
--- a/arch/sparc/crypto/md5_glue.c
+++ b/arch/sparc/crypto/md5_glue.c
@@ -14,121 +14,105 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
-#include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
-#include <crypto/md5.h>
-
-#include <asm/pstate.h>
 #include <asm/elf.h>
+#include <asm/pstate.h>
+#include <crypto/internal/hash.h>
+#include <crypto/md5.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 #include "opcodes.h"
 
-asmlinkage void md5_sparc64_transform(u32 *digest, const char *data,
+struct sparc_md5_state {
+	__le32 hash[MD5_HASH_WORDS];
+	u64 byte_count;
+};
+
+asmlinkage void md5_sparc64_transform(__le32 *digest, const char *data,
 				      unsigned int rounds);
 
 static int md5_sparc64_init(struct shash_desc *desc)
 {
-	struct md5_state *mctx = shash_desc_ctx(desc);
+	struct sparc_md5_state *mctx = shash_desc_ctx(desc);
 
-	mctx->hash[0] = MD5_H0;
-	mctx->hash[1] = MD5_H1;
-	mctx->hash[2] = MD5_H2;
-	mctx->hash[3] = MD5_H3;
-	le32_to_cpu_array(mctx->hash, 4);
+	mctx->hash[0] = cpu_to_le32(MD5_H0);
+	mctx->hash[1] = cpu_to_le32(MD5_H1);
+	mctx->hash[2] = cpu_to_le32(MD5_H2);
+	mctx->hash[3] = cpu_to_le32(MD5_H3);
 	mctx->byte_count = 0;
 
 	return 0;
 }
 
-static void __md5_sparc64_update(struct md5_state *sctx, const u8 *data,
-				 unsigned int len, unsigned int partial)
-{
-	unsigned int done = 0;
-
-	sctx->byte_count += len;
-	if (partial) {
-		done = MD5_HMAC_BLOCK_SIZE - partial;
-		memcpy((u8 *)sctx->block + partial, data, done);
-		md5_sparc64_transform(sctx->hash, (u8 *)sctx->block, 1);
-	}
-	if (len - done >= MD5_HMAC_BLOCK_SIZE) {
-		const unsigned int rounds = (len - done) / MD5_HMAC_BLOCK_SIZE;
-
-		md5_sparc64_transform(sctx->hash, data + done, rounds);
-		done += rounds * MD5_HMAC_BLOCK_SIZE;
-	}
-
-	memcpy(sctx->block, data + done, len - done);
-}
-
 static int md5_sparc64_update(struct shash_desc *desc, const u8 *data,
 			      unsigned int len)
 {
-	struct md5_state *sctx = shash_desc_ctx(desc);
-	unsigned int partial = sctx->byte_count % MD5_HMAC_BLOCK_SIZE;
+	struct sparc_md5_state *sctx = shash_desc_ctx(desc);
 
-	/* Handle the fast case right here */
-	if (partial + len < MD5_HMAC_BLOCK_SIZE) {
-		sctx->byte_count += len;
-		memcpy((u8 *)sctx->block + partial, data, len);
-	} else
-		__md5_sparc64_update(sctx, data, len, partial);
-
-	return 0;
+	sctx->byte_count += round_down(len, MD5_HMAC_BLOCK_SIZE);
+	md5_sparc64_transform(sctx->hash, data, len / MD5_HMAC_BLOCK_SIZE);
+	return len - round_down(len, MD5_HMAC_BLOCK_SIZE);
 }
 
 /* Add padding and return the message digest. */
-static int md5_sparc64_final(struct shash_desc *desc, u8 *out)
+static int md5_sparc64_finup(struct shash_desc *desc, const u8 *src,
+			     unsigned int offset, u8 *out)
 {
-	struct md5_state *sctx = shash_desc_ctx(desc);
-	unsigned int i, index, padlen;
-	u32 *dst = (u32 *)out;
-	__le64 bits;
-	static const u8 padding[MD5_HMAC_BLOCK_SIZE] = { 0x80, };
+	struct sparc_md5_state *sctx = shash_desc_ctx(desc);
+	__le64 block[MD5_BLOCK_WORDS] = {};
+	u8 *p = memcpy(block, src, offset);
+	__le32 *dst = (__le32 *)out;
+	__le64 *pbits;
+	int i;
 
-	bits = cpu_to_le64(sctx->byte_count << 3);
-
-	/* Pad out to 56 mod 64 and append length */
-	index = sctx->byte_count % MD5_HMAC_BLOCK_SIZE;
-	padlen = (index < 56) ? (56 - index) : ((MD5_HMAC_BLOCK_SIZE+56) - index);
-
-	/* We need to fill a whole block for __md5_sparc64_update() */
-	if (padlen <= 56) {
-		sctx->byte_count += padlen;
-		memcpy((u8 *)sctx->block + index, padding, padlen);
-	} else {
-		__md5_sparc64_update(sctx, padding, padlen, index);
-	}
-	__md5_sparc64_update(sctx, (const u8 *)&bits, sizeof(bits), 56);
+	src = p;
+	p += offset;
+	*p++ = 0x80;
+	sctx->byte_count += offset;
+	pbits = &block[(MD5_BLOCK_WORDS / (offset > 55 ? 1 : 2)) - 1];
+	*pbits = cpu_to_le64(sctx->byte_count << 3);
+	md5_sparc64_transform(sctx->hash, src, (pbits - block + 1) / 8);
+	memzero_explicit(block, sizeof(block));
 
 	/* Store state in digest */
 	for (i = 0; i < MD5_HASH_WORDS; i++)
 		dst[i] = sctx->hash[i];
 
-	/* Wipe context */
-	memset(sctx, 0, sizeof(*sctx));
-
 	return 0;
 }
 
 static int md5_sparc64_export(struct shash_desc *desc, void *out)
 {
-	struct md5_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(out, sctx, sizeof(*sctx));
+	struct sparc_md5_state *sctx = shash_desc_ctx(desc);
+	union {
+		u8 *u8;
+		u32 *u32;
+		u64 *u64;
+	} p = { .u8 = out };
+	int i;
 
+	for (i = 0; i < MD5_HASH_WORDS; i++)
+		put_unaligned(le32_to_cpu(sctx->hash[i]), p.u32++);
+	put_unaligned(sctx->byte_count, p.u64);
 	return 0;
 }
 
 static int md5_sparc64_import(struct shash_desc *desc, const void *in)
 {
-	struct md5_state *sctx = shash_desc_ctx(desc);
-
-	memcpy(sctx, in, sizeof(*sctx));
+	struct sparc_md5_state *sctx = shash_desc_ctx(desc);
+	union {
+		const u8 *u8;
+		const u32 *u32;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int i;
 
+	for (i = 0; i < MD5_HASH_WORDS; i++)
+		sctx->hash[i] = cpu_to_le32(get_unaligned(p.u32++));
+	sctx->byte_count = get_unaligned(p.u64);
 	return 0;
 }
 
@@ -136,15 +120,16 @@ static struct shash_alg alg = {
 	.digestsize	=	MD5_DIGEST_SIZE,
 	.init		=	md5_sparc64_init,
 	.update		=	md5_sparc64_update,
-	.final		=	md5_sparc64_final,
+	.finup		=	md5_sparc64_finup,
 	.export		=	md5_sparc64_export,
 	.import		=	md5_sparc64_import,
-	.descsize	=	sizeof(struct md5_state),
-	.statesize	=	sizeof(struct md5_state),
+	.descsize	=	sizeof(struct sparc_md5_state),
+	.statesize	=	sizeof(struct sparc_md5_state),
 	.base		=	{
 		.cra_name	=	"md5",
 		.cra_driver_name=	"md5-sparc64",
 		.cra_priority	=	SPARC_CR_OPCODE_PRIORITY,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

