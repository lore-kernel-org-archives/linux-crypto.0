Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFCE1DF98B
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 06:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745993186; cv=none; b=cnxw+3DUcm27Y3OBXxsbKeExxFlDxn22Z1fHEsCVjp5Nq/qnUYpW/9rhWxIL2kGrKbPbUqWOxUMgscCTQD+QTKRSqmEpmH8VNX1DTdYqSL9VTlparKHOvq4mopkJVGDqmLpQ4s+SJn2h2F5HM8STbpwOR7JyGTlWOgtT9IaZOBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745993186; c=relaxed/simple;
	bh=xzaECuIPX2cEmS9/bpR4Rq4DYccphIHkRnnZ50G1e9k=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=W28ZSk3UTakET0lAybmNGvxZQe2XM+Hl6n6kKLZu+cAjhZLU8DX2xH2s6mTlrRIeL8PYKf1b5d64D1cgzbPJVqca21qZRm13P/JsX0RWi54pjYyy7jNPn3bRS32w2s4O67omO/PhFyUWfurzJcgw6x7trS6ndDLPpa5h3+QXEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OdncnId3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OdncnId3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9d0d860ELFIql1LMFy5cpVC6s7KV6vgFs2lZFi7SqmU=; b=OdncnId335plVHZvmlDIqUsUpU
	IhIzGdyGBNxu60B9oXDSBVnr12hriQHJKYcu3tl8/k/gQSG0jKua5NgWkQRcpBxxKYbcUKxIwMzU+
	xKJ8pbMqNJC0xPQtR81zZSbSrYs3Fw9QCiBdeTqeZC4xbo7U2tZOTRXDa+LbQ4ZfsZqxdVTyhlePg
	aTTTN8hIOtUvV9ybGdwlI2MEayyKYViEUPtmwl8JANWNtBaYpWbpClFIp4aVb85rAjDEXxNSgADKQ
	AWcM4RZ+N2GWPDOFGG6rneJvvXN0MSNyz+1BRO7ZCjR3A1ZfAfwBNWsPRB2IWVy5mVmKJeE2UnOtI
	5pOsHPMw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA0aJ-002AZq-2f;
	Wed, 30 Apr 2025 14:06:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 14:06:19 +0800
Date: Wed, 30 Apr 2025 14:06:19 +0800
Message-Id: <297e69bbb2e4c649a6a361e0d607674495aee74a.1745992998.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745992998.git.herbert@gondor.apana.org.au>
References: <cover.1745992998.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 02/12] crypto: sha256 - Use the partial block API for generic
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

The shash interface already handles partial blocks, use it for
sha224-generic and sha256-generic instead of going through the
lib/sha256 interface.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/sha256.c       | 60 +++++++++++++++++--------------------------
 include/crypto/sha2.h | 14 ++++++++--
 2 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/crypto/sha256.c b/crypto/sha256.c
index c2588d08ee3e..9463c06ea39c 100644
--- a/crypto/sha256.c
+++ b/crypto/sha256.c
@@ -30,15 +30,19 @@ EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
 
 static int crypto_sha256_init(struct shash_desc *desc)
 {
-	sha256_init(shash_desc_ctx(desc));
+	sha256_block_init(shash_desc_ctx(desc));
 	return 0;
 }
 
 static int crypto_sha256_update_generic(struct shash_desc *desc, const u8 *data,
 					unsigned int len)
 {
-	sha256_update_generic(shash_desc_ctx(desc), data, len);
-	return 0;
+	struct crypto_sha256_state *sctx = shash_desc_ctx(desc);
+	int remain = len - round_down(len, SHA256_BLOCK_SIZE);
+
+	sctx->count += len - remain;
+	sha256_blocks_generic(sctx->state, data, len / SHA256_BLOCK_SIZE);
+	return remain;
 }
 
 static int crypto_sha256_update_arch(struct shash_desc *desc, const u8 *data,
@@ -48,12 +52,6 @@ static int crypto_sha256_update_arch(struct shash_desc *desc, const u8 *data,
 	return 0;
 }
 
-static int crypto_sha256_final_generic(struct shash_desc *desc, u8 *out)
-{
-	sha256_final_generic(shash_desc_ctx(desc), out);
-	return 0;
-}
-
 static int crypto_sha256_final_arch(struct shash_desc *desc, u8 *out)
 {
 	sha256_final(shash_desc_ctx(desc), out);
@@ -63,10 +61,13 @@ static int crypto_sha256_final_arch(struct shash_desc *desc, u8 *out)
 static int crypto_sha256_finup_generic(struct shash_desc *desc, const u8 *data,
 				       unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
+	struct crypto_sha256_state *sctx = shash_desc_ctx(desc);
+	int remain = len;
 
-	sha256_update_generic(sctx, data, len);
-	sha256_final_generic(sctx, out);
+	if (remain >= SHA256_BLOCK_SIZE)
+		remain = crypto_sha256_update_generic(desc, data, remain);
+	sha256_finup(sctx, data + len - remain, remain, out,
+		     crypto_shash_digestsize(desc->tfm), true, false);
 	return 0;
 }
 
@@ -83,12 +84,8 @@ static int crypto_sha256_finup_arch(struct shash_desc *desc, const u8 *data,
 static int crypto_sha256_digest_generic(struct shash_desc *desc, const u8 *data,
 					unsigned int len, u8 *out)
 {
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-
-	sha256_init(sctx);
-	sha256_update_generic(sctx, data, len);
-	sha256_final_generic(sctx, out);
-	return 0;
+	crypto_sha256_init(desc);
+	return crypto_sha256_finup_generic(desc, data, len, out);
 }
 
 static int crypto_sha256_digest_arch(struct shash_desc *desc, const u8 *data,
@@ -100,13 +97,7 @@ static int crypto_sha256_digest_arch(struct shash_desc *desc, const u8 *data,
 
 static int crypto_sha224_init(struct shash_desc *desc)
 {
-	sha224_init(shash_desc_ctx(desc));
-	return 0;
-}
-
-static int crypto_sha224_final_generic(struct shash_desc *desc, u8 *out)
-{
-	sha224_final_generic(shash_desc_ctx(desc), out);
+	sha224_block_init(shash_desc_ctx(desc));
 	return 0;
 }
 
@@ -147,35 +138,30 @@ static struct shash_alg algs[] = {
 		.base.cra_name		= "sha256",
 		.base.cra_driver_name	= "sha256-generic",
 		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.base.cra_blocksize	= SHA256_BLOCK_SIZE,
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= SHA256_DIGEST_SIZE,
 		.init			= crypto_sha256_init,
 		.update			= crypto_sha256_update_generic,
-		.final			= crypto_sha256_final_generic,
 		.finup			= crypto_sha256_finup_generic,
 		.digest			= crypto_sha256_digest_generic,
-		.descsize		= sizeof(struct sha256_state),
-		.statesize		= sizeof(struct crypto_sha256_state) +
-					  SHA256_BLOCK_SIZE + 1,
-		.import			= crypto_sha256_import_lib,
-		.export			= crypto_sha256_export_lib,
+		.descsize		= sizeof(struct crypto_sha256_state),
 	},
 	{
 		.base.cra_name		= "sha224",
 		.base.cra_driver_name	= "sha224-generic",
 		.base.cra_priority	= 100,
+		.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					  CRYPTO_AHASH_ALG_FINUP_MAX,
 		.base.cra_blocksize	= SHA224_BLOCK_SIZE,
 		.base.cra_module	= THIS_MODULE,
 		.digestsize		= SHA224_DIGEST_SIZE,
 		.init			= crypto_sha224_init,
 		.update			= crypto_sha256_update_generic,
-		.final			= crypto_sha224_final_generic,
-		.descsize		= sizeof(struct sha256_state),
-		.statesize		= sizeof(struct crypto_sha256_state) +
-					  SHA256_BLOCK_SIZE + 1,
-		.import			= crypto_sha256_import_lib,
-		.export			= crypto_sha256_export_lib,
+		.finup			= crypto_sha256_finup_generic,
+		.descsize		= sizeof(struct crypto_sha256_state),
 	},
 	{
 		.base.cra_name		= "sha256",
diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index 9853cd2d1291..4912572578dc 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -88,7 +88,7 @@ struct sha512_state {
 	u8 buf[SHA512_BLOCK_SIZE];
 };
 
-static inline void sha256_init(struct sha256_state *sctx)
+static inline void sha256_block_init(struct crypto_sha256_state *sctx)
 {
 	sctx->state[0] = SHA256_H0;
 	sctx->state[1] = SHA256_H1;
@@ -100,11 +100,16 @@ static inline void sha256_init(struct sha256_state *sctx)
 	sctx->state[7] = SHA256_H7;
 	sctx->count = 0;
 }
+
+static inline void sha256_init(struct sha256_state *sctx)
+{
+	sha256_block_init(&sctx->ctx);
+}
 void sha256_update(struct sha256_state *sctx, const u8 *data, size_t len);
 void sha256_final(struct sha256_state *sctx, u8 out[SHA256_DIGEST_SIZE]);
 void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE]);
 
-static inline void sha224_init(struct sha256_state *sctx)
+static inline void sha224_block_init(struct crypto_sha256_state *sctx)
 {
 	sctx->state[0] = SHA224_H0;
 	sctx->state[1] = SHA224_H1;
@@ -116,6 +121,11 @@ static inline void sha224_init(struct sha256_state *sctx)
 	sctx->state[7] = SHA224_H7;
 	sctx->count = 0;
 }
+
+static inline void sha224_init(struct sha256_state *sctx)
+{
+	sha224_block_init(&sctx->ctx);
+}
 /* Simply use sha256_update as it is equivalent to sha224_update. */
 void sha224_final(struct sha256_state *sctx, u8 out[SHA224_DIGEST_SIZE]);
 
-- 
2.39.5

