Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6011422422F
	for <linux-crypto@vger.kernel.org>; Tue, 29 Apr 2025 08:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745916209; cv=none; b=VqnSbPthiZvNkC1mA8sptmbjyUUAFQ0j0F1Uy/7ONuCFNVFrdhvOVNC2kXxwD3IchcxbFbzKG88YK0QLI4R9p2kaFRlwax+nEdk9lFQM0aS0Y0r5PasEQn4Kqr0kR8+eP4rk67aEcdlgMomZVysEhoTfLD2OPU4XJFPpViDxn7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745916209; c=relaxed/simple;
	bh=Yz8jtpq3l5TvUsRlfFOt1rSmMSf28W8300UN3almfjE=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cIuUVcp9ZR5FO83fht0USbQ/g59yjHfUm5XIfSDvGjYgWXgPAspuFPCkJGmEQcIgTzhOn0xClEBpm2l6hTLrkL2sElBS7xO2vLNZQLtlSobegk2AM1ao5lkA4889qCgnieEfK3lWfP5cFFw4Vtmp7qlA+Wpf4MHfDU2y4QLIUDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=d4VNj528; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="d4VNj528"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XzoJbf73O1rVcVhQb35TAm45a83LC4kc/fRmSDCI0RI=; b=d4VNj528nzt7rneHZMlmEXQ6GH
	N8GhtWdo+RrUNlCeh/eN8deslPgpzYQ38N0PrDl3uWgSPAevQUq/iTqydWJlRNA4eiplNiasS+mOg
	jQJZ2FSsi2YxxXTq+0V4J/O9PrkKVnGARHyXuuFcKt1aONx2ii9nwQYwD+Hm+SckBkT+9zEXkd42X
	5aw3gFzOqZ+OMbwE4KuUj6Vs4av8rOnZyNCAh/kTEeTkD1PyVa026RHesEki3udr2lxsTbIPfgl3P
	3uXJSX6WwaeGKa1WtRUvs7jCcj6rBVyPASef/CjyDzSZVE6nXm/Z7MgLI0Rx5XdgAePrJy5rXDcu7
	wT/afvlw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9gYk-001t1d-1X;
	Tue, 29 Apr 2025 16:43:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Apr 2025 16:43:22 +0800
Date: Tue, 29 Apr 2025 16:43:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: streebog - Use API partial block handling
Message-ID: <aBCRKhPYoX3YHru8@gondor.apana.org.au>
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
 crypto/streebog_generic.c | 71 ++++++++++++++-------------------------
 include/crypto/streebog.h |  5 ---
 2 files changed, 25 insertions(+), 51 deletions(-)

diff --git a/crypto/streebog_generic.c b/crypto/streebog_generic.c
index 0cfb63fd5df6..57bbf70f4c22 100644
--- a/crypto/streebog_generic.c
+++ b/crypto/streebog_generic.c
@@ -13,9 +13,10 @@
  */
 
 #include <crypto/internal/hash.h>
-#include <linux/module.h>
-#include <linux/crypto.h>
 #include <crypto/streebog.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 
 static const struct streebog_uint512 buffer0 = { {
 	0, 0, 0, 0, 0, 0, 0, 0
@@ -919,17 +920,6 @@ static int streebog_init(struct shash_desc *desc)
 	return 0;
 }
 
-static void streebog_pad(struct streebog_state *ctx)
-{
-	if (ctx->fillsize >= STREEBOG_BLOCK_SIZE)
-		return;
-
-	memset(ctx->buffer + ctx->fillsize, 0,
-	       sizeof(ctx->buffer) - ctx->fillsize);
-
-	ctx->buffer[ctx->fillsize] = 1;
-}
-
 static void streebog_add512(const struct streebog_uint512 *x,
 			    const struct streebog_uint512 *y,
 			    struct streebog_uint512 *r)
@@ -984,16 +974,23 @@ static void streebog_stage2(struct streebog_state *ctx, const u8 *data)
 	streebog_add512(&ctx->Sigma, &m, &ctx->Sigma);
 }
 
-static void streebog_stage3(struct streebog_state *ctx)
+static void streebog_stage3(struct streebog_state *ctx, const u8 *src,
+			    unsigned int len)
 {
 	struct streebog_uint512 buf = { { 0 } };
+	union {
+		u8 buffer[STREEBOG_BLOCK_SIZE];
+		struct streebog_uint512 m;
+	} u = {};
 
-	buf.qword[0] = cpu_to_le64(ctx->fillsize << 3);
-	streebog_pad(ctx);
+	buf.qword[0] = cpu_to_le64(len << 3);
+	memcpy(u.buffer, src, len);
+	u.buffer[len] = 1;
 
-	streebog_g(&ctx->h, &ctx->N, &ctx->m);
+	streebog_g(&ctx->h, &ctx->N, &u.m);
 	streebog_add512(&ctx->N, &buf, &ctx->N);
-	streebog_add512(&ctx->Sigma, &ctx->m, &ctx->Sigma);
+	streebog_add512(&ctx->Sigma, &u.m, &ctx->Sigma);
+	memzero_explicit(&u, sizeof(u));
 	streebog_g(&ctx->h, &buffer0, &ctx->N);
 	streebog_g(&ctx->h, &buffer0, &ctx->Sigma);
 	memcpy(&ctx->hash, &ctx->h, sizeof(struct streebog_uint512));
@@ -1003,42 +1000,22 @@ static int streebog_update(struct shash_desc *desc, const u8 *data,
 			   unsigned int len)
 {
 	struct streebog_state *ctx = shash_desc_ctx(desc);
-	size_t chunksize;
 
-	if (ctx->fillsize) {
-		chunksize = STREEBOG_BLOCK_SIZE - ctx->fillsize;
-		if (chunksize > len)
-			chunksize = len;
-		memcpy(&ctx->buffer[ctx->fillsize], data, chunksize);
-		ctx->fillsize += chunksize;
-		len  -= chunksize;
-		data += chunksize;
-
-		if (ctx->fillsize == STREEBOG_BLOCK_SIZE) {
-			streebog_stage2(ctx, ctx->buffer);
-			ctx->fillsize = 0;
-		}
-	}
-
-	while (len >= STREEBOG_BLOCK_SIZE) {
+	do {
 		streebog_stage2(ctx, data);
 		data += STREEBOG_BLOCK_SIZE;
 		len  -= STREEBOG_BLOCK_SIZE;
-	}
+	} while (len >= STREEBOG_BLOCK_SIZE);
 
-	if (len) {
-		memcpy(&ctx->buffer, data, len);
-		ctx->fillsize = len;
-	}
-	return 0;
+	return len;
 }
 
-static int streebog_final(struct shash_desc *desc, u8 *digest)
+static int streebog_finup(struct shash_desc *desc, const u8 *src,
+			  unsigned int len, u8 *digest)
 {
 	struct streebog_state *ctx = shash_desc_ctx(desc);
 
-	streebog_stage3(ctx);
-	ctx->fillsize = 0;
+	streebog_stage3(ctx, src, len);
 	if (crypto_shash_digestsize(desc->tfm) == STREEBOG256_DIGEST_SIZE)
 		memcpy(digest, &ctx->hash.qword[4], STREEBOG256_DIGEST_SIZE);
 	else
@@ -1050,11 +1027,12 @@ static struct shash_alg algs[2] = { {
 	.digestsize	=	STREEBOG256_DIGEST_SIZE,
 	.init		=	streebog_init,
 	.update		=	streebog_update,
-	.final		=	streebog_final,
+	.finup		=	streebog_finup,
 	.descsize	=	sizeof(struct streebog_state),
 	.base		=	{
 		.cra_name	 =	"streebog256",
 		.cra_driver_name =	"streebog256-generic",
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	STREEBOG_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	},
@@ -1062,11 +1040,12 @@ static struct shash_alg algs[2] = { {
 	.digestsize	=	STREEBOG512_DIGEST_SIZE,
 	.init		=	streebog_init,
 	.update		=	streebog_update,
-	.final		=	streebog_final,
+	.finup		=	streebog_finup,
 	.descsize	=	sizeof(struct streebog_state),
 	.base		=	{
 		.cra_name	 =	"streebog512",
 		.cra_driver_name =	"streebog512-generic",
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize	 =	STREEBOG_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
diff --git a/include/crypto/streebog.h b/include/crypto/streebog.h
index cae1b4a01971..570f720a113b 100644
--- a/include/crypto/streebog.h
+++ b/include/crypto/streebog.h
@@ -23,15 +23,10 @@ struct streebog_uint512 {
 };
 
 struct streebog_state {
-	union {
-		u8 buffer[STREEBOG_BLOCK_SIZE];
-		struct streebog_uint512 m;
-	};
 	struct streebog_uint512 hash;
 	struct streebog_uint512 h;
 	struct streebog_uint512 N;
 	struct streebog_uint512 Sigma;
-	size_t fillsize;
 };
 
 #endif /* !_CRYPTO_STREEBOG_H_ */
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
