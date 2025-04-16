Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982D923A564
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785860; cv=none; b=omDFXTI8Azc0mcalGpKLAp9x6ToGdunm8gDUNaW8J0y4Kl9K+z0v/S3GQPPIvxifiAuxiOOpWlm/nfMM2m76TwhYQ5rrLnIzaFWUIzGEZP9ytAZw+Q20FeACnmNuHSWcctjTXLn+JrTYsQAvBFAF/NI8tfGt7cjDye+Tqp5hsJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785860; c=relaxed/simple;
	bh=8aCNfjZvuiYmFRY5VA44jitvM2M5nEvBLuzWursiLU4=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=k+sL/2U9HSFxKd6fejNJMu4yyPbkUGsLvMaxiUtokehQvNZouWbGP92a5pMTpCQrifRsisWO2ezjnJ1WvAuiuWGK8oMkCVpkogh61PA7rpIcB8NgEWshhYV0IaHb1mie5DH2dREMtQTdP0YBYt2uuweUs83/y1kfu3mgsLWM0r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Rje4vVCm; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Rje4vVCm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IFi/+fu40NKUavhFBqUF69SVcZm4Bdoit9MyVoucG9M=; b=Rje4vVCm79HP/Iu0OuD0G/QPI2
	/lGyU1h0NSpycBBM+Fd6JDIkaMXyu6+9Rqanne5rBrGFAAGzOqPGpqPp8Loi1u6a8+8b4eY6tKjyr
	XEe6uqKiSxpjKtLH/hlIeCR5oPFPtA16wDAKXlxfbsMt6E/grV0F8c8pAdCpEs07Jb/YEtY/tiO5B
	ANxLFWZxRS0LAc9B/GYVR66zv9jD+K8XA1YrkCxVmxKLX57Y02voahHQ9dnEGkxBX9ZADbRgNKUNF
	LWwl3a8+kflhmgZjmY/RSYAKsMcOxmzWECcsvVMK8yZY+4VphyZ+j9y7R0oVKe9QNmiWeOg+qOhWO
	VfejI10A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVL-00G6OH-05;
	Wed, 16 Apr 2025 14:44:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:15 +0800
Date: Wed, 16 Apr 2025 14:44:15 +0800
Message-Id: <6f7f7dac1f3867ddd7bb572000b6b198e2781b5d.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 40/67] crypto: arm64/sha3-ce - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also remove the unnecessary SIMD fallback path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/sha3-ce-glue.c | 107 +++++++++++++------------------
 arch/s390/crypto/sha.h           |   1 -
 include/crypto/sha3.h            |   4 +-
 3 files changed, 49 insertions(+), 63 deletions(-)

diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
index 5662c3ac49e9..b4f1001046c9 100644
--- a/arch/arm64/crypto/sha3-ce-glue.c
+++ b/arch/arm64/crypto/sha3-ce-glue.c
@@ -12,13 +12,13 @@
 #include <asm/hwcap.h>
 #include <asm/neon.h>
 #include <asm/simd.h>
-#include <linux/unaligned.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/sha3.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
 
 MODULE_DESCRIPTION("SHA3 secure hash using ARMv8 Crypto Extensions");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
@@ -35,74 +35,55 @@ static int sha3_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
-	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	struct crypto_shash *tfm = desc->tfm;
+	unsigned int bs, ds;
+	int blocks;
 
-	if (!crypto_simd_usable())
-		return crypto_sha3_update(desc, data, len);
+	ds = crypto_shash_digestsize(tfm);
+	bs = crypto_shash_blocksize(tfm);
+	blocks = len / bs;
+	len -= blocks * bs;
+	do {
+		int rem;
 
-	if ((sctx->partial + len) >= sctx->rsiz) {
-		int blocks;
-
-		if (sctx->partial) {
-			int p = sctx->rsiz - sctx->partial;
-
-			memcpy(sctx->buf + sctx->partial, data, p);
-			kernel_neon_begin();
-			sha3_ce_transform(sctx->st, sctx->buf, 1, digest_size);
-			kernel_neon_end();
-
-			data += p;
-			len -= p;
-			sctx->partial = 0;
-		}
-
-		blocks = len / sctx->rsiz;
-		len %= sctx->rsiz;
-
-		while (blocks) {
-			int rem;
-
-			kernel_neon_begin();
-			rem = sha3_ce_transform(sctx->st, data, blocks,
-						digest_size);
-			kernel_neon_end();
-			data += (blocks - rem) * sctx->rsiz;
-			blocks = rem;
-		}
-	}
-
-	if (len) {
-		memcpy(sctx->buf + sctx->partial, data, len);
-		sctx->partial += len;
-	}
-	return 0;
+		kernel_neon_begin();
+		rem = sha3_ce_transform(sctx->st, data, blocks, ds);
+		kernel_neon_end();
+		data += (blocks - rem) * bs;
+		blocks = rem;
+	} while (blocks);
+	return len;
 }
 
-static int sha3_final(struct shash_desc *desc, u8 *out)
+static int sha3_finup(struct shash_desc *desc, const u8 *src, unsigned int len,
+		      u8 *out)
 {
 	struct sha3_state *sctx = shash_desc_ctx(desc);
-	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
+	struct crypto_shash *tfm = desc->tfm;
 	__le64 *digest = (__le64 *)out;
+	u8 block[SHA3_224_BLOCK_SIZE];
+	unsigned int bs, ds;
 	int i;
 
-	if (!crypto_simd_usable())
-		return crypto_sha3_final(desc, out);
+	ds = crypto_shash_digestsize(tfm);
+	bs = crypto_shash_blocksize(tfm);
+	memcpy(block, src, len);
 
-	sctx->buf[sctx->partial++] = 0x06;
-	memset(sctx->buf + sctx->partial, 0, sctx->rsiz - sctx->partial);
-	sctx->buf[sctx->rsiz - 1] |= 0x80;
+	block[len++] = 0x06;
+	memset(block + len, 0, bs - len);
+	block[bs - 1] |= 0x80;
 
 	kernel_neon_begin();
-	sha3_ce_transform(sctx->st, sctx->buf, 1, digest_size);
+	sha3_ce_transform(sctx->st, block, 1, ds);
 	kernel_neon_end();
+	memzero_explicit(block , sizeof(block));
 
-	for (i = 0; i < digest_size / 8; i++)
+	for (i = 0; i < ds / 8; i++)
 		put_unaligned_le64(sctx->st[i], digest++);
 
-	if (digest_size & 4)
+	if (ds & 4)
 		put_unaligned_le32(sctx->st[i], (__le32 *)digest);
 
-	memzero_explicit(sctx, sizeof(*sctx));
 	return 0;
 }
 
@@ -110,10 +91,11 @@ static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_224_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
 	.update			= sha3_update,
-	.final			= sha3_final,
-	.descsize		= sizeof(struct sha3_state),
+	.finup			= sha3_finup,
+	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-224",
 	.base.cra_driver_name	= "sha3-224-ce",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_224_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
@@ -121,10 +103,11 @@ static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_256_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
 	.update			= sha3_update,
-	.final			= sha3_final,
-	.descsize		= sizeof(struct sha3_state),
+	.finup			= sha3_finup,
+	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-256",
 	.base.cra_driver_name	= "sha3-256-ce",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_256_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
@@ -132,10 +115,11 @@ static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_384_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
 	.update			= sha3_update,
-	.final			= sha3_final,
-	.descsize		= sizeof(struct sha3_state),
+	.finup			= sha3_finup,
+	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-384",
 	.base.cra_driver_name	= "sha3-384-ce",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_384_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
@@ -143,10 +127,11 @@ static struct shash_alg algs[] = { {
 	.digestsize		= SHA3_512_DIGEST_SIZE,
 	.init			= crypto_sha3_init,
 	.update			= sha3_update,
-	.final			= sha3_final,
-	.descsize		= sizeof(struct sha3_state),
+	.finup			= sha3_finup,
+	.descsize		= SHA3_STATE_SIZE,
 	.base.cra_name		= "sha3-512",
 	.base.cra_driver_name	= "sha3-512-ce",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 	.base.cra_blocksize	= SHA3_512_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
index b8aeb51b2f3d..d95437ebe1ca 100644
--- a/arch/s390/crypto/sha.h
+++ b/arch/s390/crypto/sha.h
@@ -14,7 +14,6 @@
 #include <linux/types.h>
 
 /* must be big enough for the largest SHA variant */
-#define SHA3_STATE_SIZE			200
 #define CPACF_MAX_PARMBLOCK_SIZE	SHA3_STATE_SIZE
 #define SHA_MAX_BLOCK_SIZE		SHA3_224_BLOCK_SIZE
 #define S390_SHA_CTX_SIZE		offsetof(struct s390_sha_ctx, buf)
diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
index 080f60c2e6b1..661f196193cf 100644
--- a/include/crypto/sha3.h
+++ b/include/crypto/sha3.h
@@ -17,8 +17,10 @@
 #define SHA3_512_DIGEST_SIZE	(512 / 8)
 #define SHA3_512_BLOCK_SIZE	(200 - 2 * SHA3_512_DIGEST_SIZE)
 
+#define SHA3_STATE_SIZE		200
+
 struct sha3_state {
-	u64		st[25];
+	u64		st[SHA3_STATE_SIZE / 8];
 	unsigned int	rsiz;
 	unsigned int	rsizw;
 
-- 
2.39.5

