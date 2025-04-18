Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA7D267F47
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945138; cv=none; b=cT3pMPCcptrh7p4sA/fBrZH2VQCy5m93sYjlvPeZ483+GevpBdwBILn+S3wPCkXlXB5152XNtOGbJxdAxxmd5JiPyyI3dKZH2taOiey5x6wOAl4oH6N9YCH/eYb9UFYo3YI+rqXe2LZPvfoLyNI/gyyqr45MtS8I4L5q76uoed0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945138; c=relaxed/simple;
	bh=MssqPNwPuP4uwwROVlnz8fNcqY2lsGr88+65AXGrfEc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=jpKeoF6u/4u5rypi8KU6jyOcmjg7acJuUaLg5TihWGAvH9Q7bExOgu5bvvaQ2i8nsOcpHTtfpl5m2owQ0SyxjjOJ2oHqeqbruVOct0qr5wEPU95ZZ0xeI0Z1qED5Oq0g1Kd1nAAG9ZtoOi2c6OQ2s5dCNYFkc4igA4Fu2LHKcdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=YDZc43Bt; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="YDZc43Bt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZP9qz8OoCYC8GYuInRsCY56h0mbHwRWTL7dGJCBX2W0=; b=YDZc43BtmeW/1zYCO302ChyYBC
	kHXX9pfBWN2Frgr1h/FLOERT7E+v7YyUMvjr6qI9lINTnYNw4TfTFo3xiP5w/DEeR6hItDUyCIcNa
	/sd2Xzd5u1RKGZFtkU5Ttz1f5531PaIGQHr5moXZ8JfK8zN24d175mMtzNh2BaRM98X/IGI0ghN3I
	Emi3EfA4pFLhjsuhFbiWrb8Dc1zWK8ZhMs/b577ebqPoEUPVj5+wZLKD64NrufC6f0WyRG6RhUFtO
	uDv9KmivVM2ngi77uIqKUcmlOTLvFP8tl8KXFGbjy8mnJadREPVJSJDDHMyr5CVHbyRhM6RfEqooB
	3FfulBgA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwK-00Ge31-1z;
	Fri, 18 Apr 2025 10:58:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:58:52 +0800
Date: Fri, 18 Apr 2025 10:58:52 +0800
Message-Id: <b05df579e39c9b12bfe0de2fa965b366c4331383.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 06/67] crypto: arm/ghash - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also switch to the generic export format.

Finally remove a couple of stray may_use_simd() calls in gcm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm/crypto/ghash-ce-glue.c | 110 +++++++++++++++-----------------
 1 file changed, 50 insertions(+), 60 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index aabfcf522a2c..a52dcc8c1e33 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -8,22 +8,22 @@
 
 #include <asm/hwcap.h>
 #include <asm/neon.h>
-#include <asm/simd.h>
-#include <linux/unaligned.h>
 #include <crypto/aes.h>
-#include <crypto/gcm.h>
 #include <crypto/b128ops.h>
-#include <crypto/cryptd.h>
+#include <crypto/gcm.h>
+#include <crypto/gf128mul.h>
+#include <crypto/ghash.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/gf128mul.h>
 #include <crypto/scatterwalk.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
+#include <linux/errno.h>
 #include <linux/jump_label.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 MODULE_DESCRIPTION("GHASH hash function using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
@@ -32,9 +32,6 @@ MODULE_ALIAS_CRYPTO("ghash");
 MODULE_ALIAS_CRYPTO("gcm(aes)");
 MODULE_ALIAS_CRYPTO("rfc4106(gcm(aes))");
 
-#define GHASH_BLOCK_SIZE	16
-#define GHASH_DIGEST_SIZE	16
-
 #define RFC4106_NONCE_SIZE	4
 
 struct ghash_key {
@@ -49,10 +46,8 @@ struct gcm_key {
 	u8	nonce[];	// for RFC4106 nonce
 };
 
-struct ghash_desc_ctx {
+struct arm_ghash_desc_ctx {
 	u64 digest[GHASH_DIGEST_SIZE/sizeof(u64)];
-	u8 buf[GHASH_BLOCK_SIZE];
-	u32 count;
 };
 
 asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
@@ -65,9 +60,9 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(use_p64);
 
 static int ghash_init(struct shash_desc *desc)
 {
-	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	*ctx = (struct ghash_desc_ctx){};
+	*ctx = (struct arm_ghash_desc_ctx){};
 	return 0;
 }
 
@@ -85,54 +80,51 @@ static void ghash_do_update(int blocks, u64 dg[], const char *src,
 static int ghash_update(struct shash_desc *desc, const u8 *src,
 			unsigned int len)
 {
-	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	unsigned int partial = ctx->count % GHASH_BLOCK_SIZE;
+	struct ghash_key *key = crypto_shash_ctx(desc->tfm);
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+	int blocks;
 
-	ctx->count += len;
+	blocks = len / GHASH_BLOCK_SIZE;
+	ghash_do_update(blocks, ctx->digest, src, key, NULL);
+	return len - blocks * GHASH_BLOCK_SIZE;
+}
 
-	if ((partial + len) >= GHASH_BLOCK_SIZE) {
-		struct ghash_key *key = crypto_shash_ctx(desc->tfm);
-		int blocks;
+static int ghash_export(struct shash_desc *desc, void *out)
+{
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+	u8 *dst = out;
 
-		if (partial) {
-			int p = GHASH_BLOCK_SIZE - partial;
-
-			memcpy(ctx->buf + partial, src, p);
-			src += p;
-			len -= p;
-		}
-
-		blocks = len / GHASH_BLOCK_SIZE;
-		len %= GHASH_BLOCK_SIZE;
-
-		ghash_do_update(blocks, ctx->digest, src, key,
-				partial ? ctx->buf : NULL);
-		src += blocks * GHASH_BLOCK_SIZE;
-		partial = 0;
-	}
-	if (len)
-		memcpy(ctx->buf + partial, src, len);
+	put_unaligned_be64(ctx->digest[1], dst);
+	put_unaligned_be64(ctx->digest[0], dst + 8);
 	return 0;
 }
 
-static int ghash_final(struct shash_desc *desc, u8 *dst)
+static int ghash_import(struct shash_desc *desc, const void *in)
 {
-	struct ghash_desc_ctx *ctx = shash_desc_ctx(desc);
-	unsigned int partial = ctx->count % GHASH_BLOCK_SIZE;
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+	const u8 *src = in;
 
-	if (partial) {
-		struct ghash_key *key = crypto_shash_ctx(desc->tfm);
-
-		memset(ctx->buf + partial, 0, GHASH_BLOCK_SIZE - partial);
-		ghash_do_update(1, ctx->digest, ctx->buf, key, NULL);
-	}
-	put_unaligned_be64(ctx->digest[1], dst);
-	put_unaligned_be64(ctx->digest[0], dst + 8);
-
-	*ctx = (struct ghash_desc_ctx){};
+	ctx->digest[1] = get_unaligned_be64(src);
+	ctx->digest[0] = get_unaligned_be64(src + 8);
 	return 0;
 }
 
+static int ghash_finup(struct shash_desc *desc, const u8 *src,
+		       unsigned int len, u8 *dst)
+{
+	struct ghash_key *key = crypto_shash_ctx(desc->tfm);
+	struct arm_ghash_desc_ctx *ctx = shash_desc_ctx(desc);
+
+	if (len) {
+		u8 buf[GHASH_BLOCK_SIZE] = {};
+
+		memcpy(buf, src, len);
+		ghash_do_update(1, ctx->digest, buf, key, NULL);
+		memzero_explicit(buf, sizeof(buf));
+	}
+	return ghash_export(desc, dst);
+}
+
 static void ghash_reflect(u64 h[], const be128 *k)
 {
 	u64 carry = be64_to_cpu(k->a) >> 63;
@@ -175,13 +167,17 @@ static struct shash_alg ghash_alg = {
 	.digestsize		= GHASH_DIGEST_SIZE,
 	.init			= ghash_init,
 	.update			= ghash_update,
-	.final			= ghash_final,
+	.finup			= ghash_finup,
 	.setkey			= ghash_setkey,
-	.descsize		= sizeof(struct ghash_desc_ctx),
+	.export			= ghash_export,
+	.import			= ghash_import,
+	.descsize		= sizeof(struct arm_ghash_desc_ctx),
+	.statesize		= sizeof(struct ghash_desc_ctx),
 
 	.base.cra_name		= "ghash",
 	.base.cra_driver_name	= "ghash-ce",
 	.base.cra_priority	= 300,
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
 	.base.cra_ctxsize	= sizeof(struct ghash_key) + sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
@@ -317,9 +313,6 @@ static int gcm_encrypt(struct aead_request *req, const u8 *iv, u32 assoclen)
 	u8 *tag, *dst;
 	int tail, err;
 
-	if (WARN_ON_ONCE(!may_use_simd()))
-		return -EBUSY;
-
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
 
 	kernel_neon_begin();
@@ -409,9 +402,6 @@ static int gcm_decrypt(struct aead_request *req, const u8 *iv, u32 assoclen)
 	u8 *tag, *dst;
 	int tail, err, ret;
 
-	if (WARN_ON_ONCE(!may_use_simd()))
-		return -EBUSY;
-
 	scatterwalk_map_and_copy(otag, req->src,
 				 req->assoclen + req->cryptlen - authsize,
 				 authsize, 0);
-- 
2.39.5

