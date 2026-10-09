Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CCB4D598D
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 11:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791546379; cv=none; b=KUM0yGauRIPwC/WnfAEZ6mKEM9V/WzKwjRsbxO3XQvCFj2IxflFZZVrSgCUC+GzDQY0ie8mwBnAgaluHg2PoicbzcyWs8MUjhec6BkV7hZzIXmW92WS19KTzhruAJ/+frI1St6wg+tJgulKuQXU03OjqpEu2oGkmhLvmcDRG+Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791546379; c=relaxed/simple;
	bh=6OyfUkCcq+5a4+jKjfXr9o2UC0BND5RBfqZsYyoudLc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tHCqWGQZf4iHAbhMoXR8l5SS8fytdpgmk6O/sXkLAbI1HhtXFh1O4vrdXOJ0yi/U5Vi1y9bkJbyK6e49JgtR/gHfVubixO2X1egWgV6ePmj5oc+DW+dNGCICRxOQxsx2iCMVF7RGmUHNqrRH5h3H2lgO7W/mb0pzlOPI4xnqB/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=EGkQH4iS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="EGkQH4iS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=7RAuYbVHxMfFVKoS2Ro3Heg1nEJZmX33jSr6Ebia+AU=; b=EGkQH
	4iSnL8yen6oZho9r1Ddi0ajMdBEaqAC1HCY3I2eLkVh1+VaUU3ptf7muJEqPbUFOtVRq0a9+8nuKA
	B226M/Xx5upLoidUhCLlrPq6bLGGvWQsxPbZZ77xez4Bnjk70Xd3OX8rlp8JpZsc5rJN+cdAuZiyP
	jV0h33YhaX/l6LEkvNYnjKtaptY6D66TN7TQCXh76MTmha0/Xy8bvWP0/HjHdJnirjepdxBbZIDM1
	pJHs7jNbNbdOEj+aPqbdPDXpQZpKzk1Lnlfr4r6Lgd3ayVtmfrUB9+y7WoqGUVB5uxR3N7APbzk8x
	r6e3l9fD9lgRd1s0GS+rm5/TWrTqg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xF92x-00000002Ck4-47Gp;
	Fri, 09 Oct 2026 19:45:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Oct 2026 22:45:55 +1100
Date: Fri, 9 Oct 2026 22:45:55 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH] crypto: aes - Add import_core/export_core to cmac/xcbc/cbcmac
Message-ID: <asjT87HAZ_UUbbvm@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The export format for cmac-aes-lib, xcbc-aes-lib and cbcmac-aes-lib
did not match that of the generic templates.  Add custom export and
import functions to align with the generic tempaltes.

For cmac and xcbc, perform an extra encryption on the withheld block
for export_core so that the information isn't lost.

Reported-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/aes.c b/crypto/aes.c
index 94791f481e98..a1af4d5a7608 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -18,7 +18,10 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/utils.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 static_assert(__alignof__(struct aes_key) <= CRYPTO_MINALIGN);
 static_assert(__alignof__(struct aes_enckey) <= CRYPTO_MINALIGN);
@@ -95,6 +98,71 @@ static int __maybe_unused crypto_aes_cmac_digest(struct shash_desc *desc,
 	return 0;
 }
 
+static int crypto_cmac_export_core(struct shash_desc *desc, void *out)
+{
+	struct aes_cmac_ctx *ctx = AES_CMAC_CTX(desc);
+	struct aes_cmac_ctx ctx1;
+	u8 *h = ctx->h;
+
+	if (!ctx->partial_len)
+		;
+	else if (ctx->partial_len != AES_BLOCK_SIZE)
+		return -EINVAL;
+	else {
+		union {
+			long l;
+			char c;
+		} u = {};
+
+		BUILD_BUG_ON(sizeof(u) >= AES_BLOCK_SIZE);
+		ctx1 = *ctx;
+		aes_cmac_update(&ctx1, &u.c, sizeof(u));
+		h = ctx1.h;
+	}
+
+	memcpy(out, h, AES_BLOCK_SIZE);
+	memzero_explicit(&ctx1, sizeof(ctx1));
+	return 0;
+}
+
+static int crypto_cmac_import_core(struct shash_desc *desc, const void *in)
+{
+	struct aes_cmac_ctx *ctx = AES_CMAC_CTX(desc);
+
+	ctx->key = AES_CMAC_KEY(desc->tfm);
+	memcpy(ctx->h, in, AES_BLOCK_SIZE);
+	ctx->partial_len = 0;
+	return 0;
+}
+
+static int crypto_cmac_export(struct shash_desc *desc, void *out)
+{
+	struct aes_cmac_ctx *ctx = AES_CMAC_CTX(desc);
+	unsigned int partial = ctx->partial_len;
+	u8 *p = out;
+
+	memcpy(p, ctx->h, AES_BLOCK_SIZE);
+	memset(p + AES_BLOCK_SIZE, 0, AES_BLOCK_SIZE);
+	p[AES_BLOCK_SIZE * 2] = partial;
+	return 0;
+}
+
+static int crypto_cmac_import(struct shash_desc *desc, const void *in)
+{
+	struct aes_cmac_ctx *ctx = AES_CMAC_CTX(desc);
+	unsigned int partial;
+	const u8 *p = in;
+
+	crypto_cmac_import_core(desc, p);
+	p += AES_BLOCK_SIZE;
+	partial = p[AES_BLOCK_SIZE];
+	if (partial > AES_BLOCK_SIZE)
+		return -EOVERFLOW;
+	crypto_xor(ctx->h, p, partial);
+	ctx->partial_len = partial;
+	return 0;
+}
+
 #define AES_CBCMAC_KEY(tfm) ((struct aes_enckey *)crypto_shash_ctx(tfm))
 #define AES_CBCMAC_CTX(desc) ((struct aes_cbcmac_ctx *)shash_desc_ctx(desc))
 
@@ -136,6 +204,49 @@ static int __maybe_unused crypto_aes_cbcmac_digest(struct shash_desc *desc,
 	return 0;
 }
 
+static int crypto_cbcmac_export_core(struct shash_desc *desc, void *out)
+{
+	memcpy(out, AES_CBCMAC_CTX(desc)->h, AES_BLOCK_SIZE);
+	return 0;
+}
+
+static int crypto_cbcmac_import_core(struct shash_desc *desc, const void *in)
+{
+	struct aes_cbcmac_ctx *ctx = AES_CBCMAC_CTX(desc);
+
+	ctx->key = AES_CBCMAC_KEY(desc->tfm);
+	memcpy(ctx->h, in, AES_BLOCK_SIZE);
+	ctx->partial_len = 0;
+	return 0;
+}
+
+static int crypto_cbcmac_export(struct shash_desc *desc, void *out)
+{
+	struct aes_cbcmac_ctx *ctx = AES_CBCMAC_CTX(desc);
+	unsigned int partial = ctx->partial_len;
+	u8 *p = out;
+
+	memset(p + AES_BLOCK_SIZE, 0, AES_BLOCK_SIZE);
+	p[AES_BLOCK_SIZE * 2] = partial;
+	return crypto_cbcmac_export_core(desc, p);
+}
+
+static int crypto_cbcmac_import(struct shash_desc *desc, const void *in)
+{
+	struct aes_cbcmac_ctx *ctx = AES_CBCMAC_CTX(desc);
+	unsigned int partial;
+	const u8 *p = in;
+
+	crypto_cbcmac_import_core(desc, p);
+	p += AES_BLOCK_SIZE;
+	partial = p[AES_BLOCK_SIZE];
+	if (partial > AES_BLOCK_SIZE)
+		return -EOVERFLOW;
+	crypto_xor(ctx->h, p, partial);
+	ctx->partial_len = partial;
+	return 0;
+}
+
 static struct crypto_alg alg = {
 	.cra_name = "aes",
 	.cra_driver_name = "aes-lib",
@@ -166,7 +277,12 @@ static struct shash_alg mac_algs[] = {
 		.update = crypto_aes_cmac_update,
 		.final = crypto_aes_cmac_final,
 		.digest = crypto_aes_cmac_digest,
+		.export	= crypto_cmac_export,
+		.import = crypto_cmac_import,
+		.export_core = crypto_cmac_export_core,
+		.import_core = crypto_cmac_import_core,
 		.descsize = sizeof(struct aes_cmac_ctx),
+		.statesize = AES_BLOCK_SIZE * 2 + 1,
 	},
 #endif
 #if IS_ENABLED(CONFIG_CRYPTO_XCBC)
@@ -187,7 +303,12 @@ static struct shash_alg mac_algs[] = {
 		.update = crypto_aes_cmac_update,
 		.final = crypto_aes_cmac_final,
 		.digest = crypto_aes_cmac_digest,
+		.export	= crypto_cmac_export,
+		.import = crypto_cmac_import,
+		.export_core = crypto_cmac_export_core,
+		.import_core = crypto_cmac_import_core,
 		.descsize = sizeof(struct aes_cmac_ctx),
+		.statesize = AES_BLOCK_SIZE * 2 + 1,
 	},
 #endif
 #if IS_ENABLED(CONFIG_CRYPTO_CCM)
@@ -204,7 +325,12 @@ static struct shash_alg mac_algs[] = {
 		.update = crypto_aes_cbcmac_update,
 		.final = crypto_aes_cbcmac_final,
 		.digest = crypto_aes_cbcmac_digest,
+		.export	= crypto_cbcmac_export,
+		.import = crypto_cbcmac_import,
+		.export_core = crypto_cbcmac_export_core,
+		.import_core = crypto_cbcmac_import_core,
 		.descsize = sizeof(struct aes_cbcmac_ctx),
+		.statesize = AES_BLOCK_SIZE * 2 + 1,
 	},
 #endif
 };
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
