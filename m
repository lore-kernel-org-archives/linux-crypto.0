Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588D72512E6
	for <linux-crypto@vger.kernel.org>; Tue, 29 Apr 2025 08:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745916149; cv=none; b=IGi83M4Q5TNxtRp7FIcN6hOmK9xwPygbKwGbBKDy91T2WtBm+KKIgVrJaE8I9jXCTAt8ATM4+MpC2oyejUV/fBQyrbxTz8U03KZnAC5QF6h7PbpbQvVouTs1Vr0h1ez/B+sZKo+916u3MynCB+523Jjhmf85KR+vzYs1N9BKw84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745916149; c=relaxed/simple;
	bh=Ge2w+/EPykKcLxus3kfqvBGx3n9pJAPXT1GRuda1fp8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=jn0aRtCPA1gV4CWpemAT9U3568DQcZahQjIDDrJFaidlv9+SgPwwCtRM0zMdmNQ1gvZVATvQLIbOJXil3xbSlb3bgkZD8Ac7/mw4nHVRkSyBC0C+z9SeCaKfQ9ZmCe4ua6rZDns7NIfgG7/KtS2O5mQNmjbaOcAQFC0pqOGNVAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HOlZoMDV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HOlZoMDV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hnlOPqsJLcrzCh0GJZ1SpfnoXYDQBzZwhebuIio75Kw=; b=HOlZoMDVgbgWSKN32unNn9rY8Z
	E0w7POA9yQbur54D9vUJB/UsYnyGVIGOakq8vlTpEvkBbw2Lc/pzKA4SiF0rYe0yNCzf0eOWbi8r2
	W71qfWP1utlQ+ZP0IilWnZtVDSbfwRdFXed42AYUvh2ocR6jxyoXnCM0pHuWSOyV1ptB+MZeMJb9P
	GQu+/5S6uxCaoT2XtD523sRQ89+yIcTstAvGL63EbAthTzUrz3CU7NNJPimWct/mX41LEq/PtTDB9
	YY/+WP/qNoHUrbm3N23QDRjEqB2ISSSLKy+QxQqpLvWt39clV+uKPznq3C36IRvx0zkj9K0MGzOkb
	h4gmD8cw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9gXk-001t15-0z;
	Tue, 29 Apr 2025 16:42:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Apr 2025 16:42:20 +0800
Date: Tue, 29 Apr 2025 16:42:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: rmd160 - Use API partial block handling
Message-ID: <aBCQ7OhRuTJ2zwJa@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Use the Crypto API partial block handling.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/rmd160.c | 86 ++++++++++++++++++++-----------------------------
 1 file changed, 35 insertions(+), 51 deletions(-)

diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index 1599f603fbaa..9860b60c9be4 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -9,18 +9,14 @@
  * Copyright (c) 2008 Adrian-Ken Rueegsegger <ken@codelabs.ch>
  */
 #include <crypto/internal/hash.h>
-#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/types.h>
-#include <asm/byteorder.h>
-
+#include <linux/string.h>
 #include "ripemd.h"
 
 struct rmd160_ctx {
 	u64 byte_count;
 	u32 state[5];
-	__le32 buffer[16];
 };
 
 #define K1  RMD_K1
@@ -265,72 +261,59 @@ static int rmd160_init(struct shash_desc *desc)
 	rctx->state[3] = RMD_H3;
 	rctx->state[4] = RMD_H4;
 
-	memset(rctx->buffer, 0, sizeof(rctx->buffer));
-
 	return 0;
 }
 
 static int rmd160_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
 {
+	int remain = len - round_down(len, RMD160_BLOCK_SIZE);
 	struct rmd160_ctx *rctx = shash_desc_ctx(desc);
-	const u32 avail = sizeof(rctx->buffer) - (rctx->byte_count & 0x3f);
+	__le32 buffer[RMD160_BLOCK_SIZE / 4];
 
-	rctx->byte_count += len;
+	rctx->byte_count += len - remain;
 
-	/* Enough space in buffer? If so copy and we're done */
-	if (avail > len) {
-		memcpy((char *)rctx->buffer + (sizeof(rctx->buffer) - avail),
-		       data, len);
-		goto out;
-	}
+	do {
+		memcpy(buffer, data, sizeof(buffer));
+		rmd160_transform(rctx->state, buffer);
+		data += sizeof(buffer);
+		len -= sizeof(buffer);
+	} while (len >= sizeof(buffer));
 
-	memcpy((char *)rctx->buffer + (sizeof(rctx->buffer) - avail),
-	       data, avail);
-
-	rmd160_transform(rctx->state, rctx->buffer);
-	data += avail;
-	len -= avail;
-
-	while (len >= sizeof(rctx->buffer)) {
-		memcpy(rctx->buffer, data, sizeof(rctx->buffer));
-		rmd160_transform(rctx->state, rctx->buffer);
-		data += sizeof(rctx->buffer);
-		len -= sizeof(rctx->buffer);
-	}
-
-	memcpy(rctx->buffer, data, len);
-
-out:
-	return 0;
+	memzero_explicit(buffer, sizeof(buffer));
+	return remain;
 }
 
 /* Add padding and return the message digest. */
-static int rmd160_final(struct shash_desc *desc, u8 *out)
+static int rmd160_finup(struct shash_desc *desc, const u8 *src,
+			unsigned int len, u8 *out)
 {
+	unsigned int bit_offset = RMD160_BLOCK_SIZE / 8 - 1;
 	struct rmd160_ctx *rctx = shash_desc_ctx(desc);
-	u32 i, index, padlen;
-	__le64 bits;
+	union {
+		__le64 l64[RMD160_BLOCK_SIZE / 4];
+		__le32 l32[RMD160_BLOCK_SIZE / 2];
+		u8 u8[RMD160_BLOCK_SIZE * 2];
+	} block = {};
 	__le32 *dst = (__le32 *)out;
-	static const u8 padding[64] = { 0x80, };
+	u32 i;
 
-	bits = cpu_to_le64(rctx->byte_count << 3);
+	rctx->byte_count += len;
+	if (len >= bit_offset * 8)
+		bit_offset += RMD160_BLOCK_SIZE / 8;
+	memcpy(&block, src, len);
+	block.u8[len] = 0x80;
+	block.l64[bit_offset] = cpu_to_le64(rctx->byte_count << 3);
 
-	/* Pad out to 56 mod 64 */
-	index = rctx->byte_count & 0x3f;
-	padlen = (index < 56) ? (56 - index) : ((64+56) - index);
-	rmd160_update(desc, padding, padlen);
-
-	/* Append length */
-	rmd160_update(desc, (const u8 *)&bits, sizeof(bits));
+	rmd160_transform(rctx->state, block.l32);
+	if (bit_offset > RMD160_BLOCK_SIZE / 8)
+		rmd160_transform(rctx->state,
+				 block.l32 + RMD160_BLOCK_SIZE / 4);
+	memzero_explicit(&block, sizeof(block));
 
 	/* Store state in digest */
 	for (i = 0; i < 5; i++)
 		dst[i] = cpu_to_le32p(&rctx->state[i]);
-
-	/* Wipe context */
-	memset(rctx, 0, sizeof(*rctx));
-
 	return 0;
 }
 
@@ -338,11 +321,12 @@ static struct shash_alg alg = {
 	.digestsize	=	RMD160_DIGEST_SIZE,
 	.init		=	rmd160_init,
 	.update		=	rmd160_update,
-	.final		=	rmd160_final,
+	.finup		=	rmd160_finup,
 	.descsize	=	sizeof(struct rmd160_ctx),
 	.base		=	{
 		.cra_name	 =	"rmd160",
 		.cra_driver_name =	"rmd160-generic",
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	RMD160_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
