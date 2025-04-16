Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38ADA22A807
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785794; cv=none; b=c5X5pq7Lxe+pQM2GF1oK6jtcQb/E/3d6bOPUroWMNKMjxasOEiHI0tsqgVwglukQclpG7PMTZZ47fT4XHiP4UNLiRqZTyTuOzz1lC7N0//BIz0ijkxIeGyv0y4aY5bJ5r6INx09pR0HKOhoxUiJiTfJuG+3ii4Wriv2vdu1fP3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785794; c=relaxed/simple;
	bh=TXsbLk/yQVdNE09iHjUROsvstAEzMM5Tevs29ug1ghY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=A08E+rN17bLVFdnChSbDBEfvO9zPshyvp/GCTn2WjI4S43eq3yaH8Lnqaar8ywmGVzsLYG3um8Bo34xaM4iTA64NNRSg8JOC9/UoW8iReorhGmsDH0xqSt3TL0yII8vTGqkto08Wmb0AZpd/xxQs5ntym1UACebPjwPXWSAgpmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MYCzKw2p; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MYCzKw2p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J6ShQM6tsFa6PnLhRe5FjIHZ5gYLSB48yGbShMiX25k=; b=MYCzKw2p3alssgiV0NKzne9N9c
	pm5nZviwQIlyDTLq9BhGk5/BGVZCn7A/buAA7Ci4TAuKYvM46Zbl1V1lGzLHmVFNGdH5v8XsvcNBa
	WA11S5u8b9C0zl1ecflKxDYnHVDKtCxIzE/94lQvKwYi4IqVek2YnrhMh5akc5hmE4ri/9KxGQDLj
	tdjg3QHX7vJNkcZk0LvLCa4BXZ622LrF4fDlaUhj0cQq4LwRJc1WK/t08/ISM2cCvNrk8y+6S60Lg
	Sc5EmPxK9n0Vw8gSWA2kWrR/4SmBlo17nG6AfnBXwMSQEnCJvHf1Ban2cIlYKDoaI2ftC72sInAwf
	DP5X5Jdg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wUG-00G6IG-0k;
	Wed, 16 Apr 2025 14:43:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:43:08 +0800
Date: Wed, 16 Apr 2025 14:43:08 +0800
Message-Id: <77132917055447ec137ecc2d036ccadacb8b9aee.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/67] crypto: md5-generic - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/md5.c         | 102 ++++++++++++++++---------------------------
 include/crypto/md5.h |   3 +-
 2 files changed, 40 insertions(+), 65 deletions(-)

diff --git a/crypto/md5.c b/crypto/md5.c
index 72c0c46fb5ee..994005cd977d 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -17,11 +17,9 @@
  */
 #include <crypto/internal/hash.h>
 #include <crypto/md5.h>
-#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/types.h>
-#include <asm/byteorder.h>
 
 const u8 md5_zero_message_hash[MD5_DIGEST_SIZE] = {
 	0xd4, 0x1d, 0x8c, 0xd9, 0x8f, 0x00, 0xb2, 0x04,
@@ -120,10 +118,11 @@ static void md5_transform(__u32 *hash, __u32 const *in)
 	hash[3] += d;
 }
 
-static inline void md5_transform_helper(struct md5_state *ctx)
+static inline void md5_transform_helper(struct md5_state *ctx,
+					u32 block[MD5_BLOCK_WORDS])
 {
-	le32_to_cpu_array(ctx->block, sizeof(ctx->block) / sizeof(u32));
-	md5_transform(ctx->hash, ctx->block);
+	le32_to_cpu_array(block, MD5_BLOCK_WORDS);
+	md5_transform(ctx->hash, block);
 }
 
 static int md5_init(struct shash_desc *desc)
@@ -142,91 +141,66 @@ static int md5_init(struct shash_desc *desc)
 static int md5_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 {
 	struct md5_state *mctx = shash_desc_ctx(desc);
-	const u32 avail = sizeof(mctx->block) - (mctx->byte_count & 0x3f);
+	u32 block[MD5_BLOCK_WORDS];
 
 	mctx->byte_count += len;
-
-	if (avail > len) {
-		memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
-		       data, len);
-		return 0;
-	}
-
-	memcpy((char *)mctx->block + (sizeof(mctx->block) - avail),
-	       data, avail);
-
-	md5_transform_helper(mctx);
-	data += avail;
-	len -= avail;
-
-	while (len >= sizeof(mctx->block)) {
-		memcpy(mctx->block, data, sizeof(mctx->block));
-		md5_transform_helper(mctx);
-		data += sizeof(mctx->block);
-		len -= sizeof(mctx->block);
-	}
-
-	memcpy(mctx->block, data, len);
-
-	return 0;
+	do {
+		memcpy(block, data, sizeof(block));
+		md5_transform_helper(mctx, block);
+		data += sizeof(block);
+		len -= sizeof(block);
+	} while (len >= sizeof(block));
+	memzero_explicit(block, sizeof(block));
+	mctx->byte_count -= len;
+	return len;
 }
 
-static int md5_final(struct shash_desc *desc, u8 *out)
+static int md5_finup(struct shash_desc *desc, const u8 *data, unsigned int len,
+		     u8 *out)
 {
 	struct md5_state *mctx = shash_desc_ctx(desc);
-	const unsigned int offset = mctx->byte_count & 0x3f;
-	char *p = (char *)mctx->block + offset;
-	int padding = 56 - (offset + 1);
+	u32 block[MD5_BLOCK_WORDS];
+	unsigned int offset;
+	int padding;
+	char *p;
+
+	memcpy(block, data, len);
+
+	offset = len;
+	p = (char *)block + offset;
+	padding = 56 - (offset + 1);
 
 	*p++ = 0x80;
 	if (padding < 0) {
 		memset(p, 0x00, padding + sizeof (u64));
-		md5_transform_helper(mctx);
-		p = (char *)mctx->block;
+		md5_transform_helper(mctx, block);
+		p = (char *)block;
 		padding = 56;
 	}
 
 	memset(p, 0, padding);
-	mctx->block[14] = mctx->byte_count << 3;
-	mctx->block[15] = mctx->byte_count >> 29;
-	le32_to_cpu_array(mctx->block, (sizeof(mctx->block) -
-	                  sizeof(u64)) / sizeof(u32));
-	md5_transform(mctx->hash, mctx->block);
+	mctx->byte_count += len;
+	block[14] = mctx->byte_count << 3;
+	block[15] = mctx->byte_count >> 29;
+	le32_to_cpu_array(block, (sizeof(block) - sizeof(u64)) / sizeof(u32));
+	md5_transform(mctx->hash, block);
+	memzero_explicit(block, sizeof(block));
 	cpu_to_le32_array(mctx->hash, sizeof(mctx->hash) / sizeof(u32));
 	memcpy(out, mctx->hash, sizeof(mctx->hash));
-	memset(mctx, 0, sizeof(*mctx));
 
 	return 0;
 }
 
-static int md5_export(struct shash_desc *desc, void *out)
-{
-	struct md5_state *ctx = shash_desc_ctx(desc);
-
-	memcpy(out, ctx, sizeof(*ctx));
-	return 0;
-}
-
-static int md5_import(struct shash_desc *desc, const void *in)
-{
-	struct md5_state *ctx = shash_desc_ctx(desc);
-
-	memcpy(ctx, in, sizeof(*ctx));
-	return 0;
-}
-
 static struct shash_alg alg = {
 	.digestsize	=	MD5_DIGEST_SIZE,
 	.init		=	md5_init,
 	.update		=	md5_update,
-	.final		=	md5_final,
-	.export		=	md5_export,
-	.import		=	md5_import,
-	.descsize	=	sizeof(struct md5_state),
-	.statesize	=	sizeof(struct md5_state),
+	.finup		=	md5_finup,
+	.descsize	=	MD5_STATE_SIZE,
 	.base		=	{
 		.cra_name	 =	"md5",
 		.cra_driver_name =	"md5-generic",
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	MD5_HMAC_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
diff --git a/include/crypto/md5.h b/include/crypto/md5.h
index cf9e9dec3d21..198b5d69b92f 100644
--- a/include/crypto/md5.h
+++ b/include/crypto/md5.h
@@ -8,6 +8,7 @@
 #define MD5_HMAC_BLOCK_SIZE	64
 #define MD5_BLOCK_WORDS		16
 #define MD5_HASH_WORDS		4
+#define MD5_STATE_SIZE		24
 
 #define MD5_H0	0x67452301UL
 #define MD5_H1	0xefcdab89UL
@@ -18,8 +19,8 @@ extern const u8 md5_zero_message_hash[MD5_DIGEST_SIZE];
 
 struct md5_state {
 	u32 hash[MD5_HASH_WORDS];
-	u32 block[MD5_BLOCK_WORDS];
 	u64 byte_count;
+	u32 block[MD5_BLOCK_WORDS];
 };
 
 #endif
-- 
2.39.5

