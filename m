Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5187267F62
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945226; cv=none; b=OJ8vGK2vPMzwKxxhgbroSNlsfndKC/D8pt7SdtyqoBQ/IPToGGv3jex62SArvfIWFGfNK1I2nHoo3CsDJglrqWueBW+yikE7E8XrbcntnqTXz5m7aW4XyYIAdswAUgG1+CpbSVEMDtmBd3yMm+5trxKBPKOKxIVZUIPjRJ42alg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945226; c=relaxed/simple;
	bh=PGPXyoRkh+P/KyHpgJxeayybp+DWdUZpptPRS7QEKuI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=LTDG8XkfnkzbxDI/cKUc0IucsYSOxuriz1ZO2ow70rcXgbD6w4edL1SzwAaP3qat+hB8Iu2xIK5tNCOYjkbiDamTqy6ekpIe/NLvhpdPLXWaMWneHOza81AkqWTfts6LK6403dLRTkhDdAjFgQo28EZyGZuGrS024XopTx0v9NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cMhmxdIh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cMhmxdIh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b94ooEKlqlYjFWw6S6vLac/TUl6o8Q6QLEq1tvu/81Y=; b=cMhmxdIhBzGd5O5Cau/cPHmpZ/
	/Ro9WtHMwBtEFH8qIer0Vq6rXvYB1TPIkL05KTE/IvDJcTokm/vFiUKRT+hqppbczIH5kd81fju8v
	goURhxENGTWQj+yOsZplqs571UsymxwcAS20tyWg++Hc85VLBQjWgHNyUnnQT4AT+hNFMMlgWulIg
	i91hO32u9RNOUGZIGuRwOeBLbWcbJZX+jswfjY91uQDGOoM8HALweCK4wiHrN4sbTpNs5+A2BKbQ2
	ODD83ZoVdbM1y/ly4RyuvY7cLxrWUcVuuUcgKNwNVqBgPQcyHhJCe3F/hjZLZ/uHj8lcz/i0spwzL
	Xx4pSRRA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bxk-00GeC6-1P;
	Fri, 18 Apr 2025 11:00:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:20 +0800
Date: Fri, 18 Apr 2025 11:00:20 +0800
Message-Id: <11925f9c82be8bb73997ca2a98b416dccc579095.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 44/67] crypto: x86/sha512 - Use API partial block handling
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
 arch/x86/crypto/sha512_ssse3_glue.c | 79 ++++++++++-------------------
 include/crypto/sha2.h               |  1 +
 include/crypto/sha512_base.h        | 54 ++++++++++++++++++--
 3 files changed, 77 insertions(+), 57 deletions(-)

diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 6d3b85e53d0e..067684c54395 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -27,17 +27,13 @@
 
 #define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
 
-#include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-#include <linux/string.h>
-#include <linux/types.h>
-#include <crypto/sha2.h>
-#include <crypto/sha512_base.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
+#include <crypto/internal/hash.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <crypto/sha2.h>
+#include <crypto/sha512_base.h>
 
 asmlinkage void sha512_transform_ssse3(struct sha512_state *state,
 				       const u8 *data, int blocks);
@@ -45,11 +41,7 @@ asmlinkage void sha512_transform_ssse3(struct sha512_state *state,
 static int sha512_update(struct shash_desc *desc, const u8 *data,
 		       unsigned int len, sha512_block_fn *sha512_xform)
 {
-	struct sha512_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable() ||
-	    (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
-		return crypto_sha512_update(desc, data, len);
+	int remain;
 
 	/*
 	 * Make sure struct sha512_state begins directly with the SHA512
@@ -58,22 +50,17 @@ static int sha512_update(struct shash_desc *desc, const u8 *data,
 	BUILD_BUG_ON(offsetof(struct sha512_state, state) != 0);
 
 	kernel_fpu_begin();
-	sha512_base_do_update(desc, data, len, sha512_xform);
+	remain = sha512_base_do_update_blocks(desc, data, len, sha512_xform);
 	kernel_fpu_end();
 
-	return 0;
+	return remain;
 }
 
 static int sha512_finup(struct shash_desc *desc, const u8 *data,
 	      unsigned int len, u8 *out, sha512_block_fn *sha512_xform)
 {
-	if (!crypto_simd_usable())
-		return crypto_sha512_finup(desc, data, len, out);
-
 	kernel_fpu_begin();
-	if (len)
-		sha512_base_do_update(desc, data, len, sha512_xform);
-	sha512_base_do_finalize(desc, sha512_xform);
+	sha512_base_do_finup(desc, data, len, sha512_xform);
 	kernel_fpu_end();
 
 	return sha512_base_finish(desc, out);
@@ -91,23 +78,18 @@ static int sha512_ssse3_finup(struct shash_desc *desc, const u8 *data,
 	return sha512_finup(desc, data, len, out, sha512_transform_ssse3);
 }
 
-/* Add padding and return the message digest. */
-static int sha512_ssse3_final(struct shash_desc *desc, u8 *out)
-{
-	return sha512_ssse3_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg sha512_ssse3_algs[] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_base_init,
 	.update		=	sha512_ssse3_update,
-	.final		=	sha512_ssse3_final,
 	.finup		=	sha512_ssse3_finup,
-	.descsize	=	sizeof(struct sha512_state),
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_driver_name =	"sha512-ssse3",
 		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -115,13 +97,14 @@ static struct shash_alg sha512_ssse3_algs[] = { {
 	.digestsize	=	SHA384_DIGEST_SIZE,
 	.init		=	sha384_base_init,
 	.update		=	sha512_ssse3_update,
-	.final		=	sha512_ssse3_final,
 	.finup		=	sha512_ssse3_finup,
-	.descsize	=	sizeof(struct sha512_state),
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_driver_name =	"sha384-ssse3",
 		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA384_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -167,23 +150,18 @@ static int sha512_avx_finup(struct shash_desc *desc, const u8 *data,
 	return sha512_finup(desc, data, len, out, sha512_transform_avx);
 }
 
-/* Add padding and return the message digest. */
-static int sha512_avx_final(struct shash_desc *desc, u8 *out)
-{
-	return sha512_avx_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg sha512_avx_algs[] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_base_init,
 	.update		=	sha512_avx_update,
-	.final		=	sha512_avx_final,
 	.finup		=	sha512_avx_finup,
-	.descsize	=	sizeof(struct sha512_state),
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_driver_name =	"sha512-avx",
 		.cra_priority	=	160,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -191,13 +169,14 @@ static struct shash_alg sha512_avx_algs[] = { {
 	.digestsize	=	SHA384_DIGEST_SIZE,
 	.init		=	sha384_base_init,
 	.update		=	sha512_avx_update,
-	.final		=	sha512_avx_final,
 	.finup		=	sha512_avx_finup,
-	.descsize	=	sizeof(struct sha512_state),
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_driver_name =	"sha384-avx",
 		.cra_priority	=	160,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA384_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -233,23 +212,18 @@ static int sha512_avx2_finup(struct shash_desc *desc, const u8 *data,
 	return sha512_finup(desc, data, len, out, sha512_transform_rorx);
 }
 
-/* Add padding and return the message digest. */
-static int sha512_avx2_final(struct shash_desc *desc, u8 *out)
-{
-	return sha512_avx2_finup(desc, NULL, 0, out);
-}
-
 static struct shash_alg sha512_avx2_algs[] = { {
 	.digestsize	=	SHA512_DIGEST_SIZE,
 	.init		=	sha512_base_init,
 	.update		=	sha512_avx2_update,
-	.final		=	sha512_avx2_final,
 	.finup		=	sha512_avx2_finup,
-	.descsize	=	sizeof(struct sha512_state),
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha512",
 		.cra_driver_name =	"sha512-avx2",
 		.cra_priority	=	170,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA512_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
@@ -257,13 +231,14 @@ static struct shash_alg sha512_avx2_algs[] = { {
 	.digestsize	=	SHA384_DIGEST_SIZE,
 	.init		=	sha384_base_init,
 	.update		=	sha512_avx2_update,
-	.final		=	sha512_avx2_final,
 	.finup		=	sha512_avx2_finup,
-	.descsize	=	sizeof(struct sha512_state),
+	.descsize	=	SHA512_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sha384",
 		.cra_driver_name =	"sha384-avx2",
 		.cra_priority	=	170,
+		.cra_flags	=	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SHA384_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
index a913bad5dd3b..e9ad7ab955aa 100644
--- a/include/crypto/sha2.h
+++ b/include/crypto/sha2.h
@@ -19,6 +19,7 @@
 
 #define SHA512_DIGEST_SIZE      64
 #define SHA512_BLOCK_SIZE       128
+#define SHA512_STATE_SIZE       80
 
 #define SHA224_H0	0xc1059ed8UL
 #define SHA224_H1	0x367cd507UL
diff --git a/include/crypto/sha512_base.h b/include/crypto/sha512_base.h
index 679916a84cb2..8cb172e52dc0 100644
--- a/include/crypto/sha512_base.h
+++ b/include/crypto/sha512_base.h
@@ -10,10 +10,7 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/sha2.h>
-#include <linux/crypto.h>
-#include <linux/module.h>
 #include <linux/string.h>
-
 #include <linux/unaligned.h>
 
 typedef void (sha512_block_fn)(struct sha512_state *sst, u8 const *src,
@@ -93,6 +90,55 @@ static inline int sha512_base_do_update(struct shash_desc *desc,
 	return 0;
 }
 
+static inline int sha512_base_do_update_blocks(struct shash_desc *desc,
+					       const u8 *data,
+					       unsigned int len,
+					       sha512_block_fn *block_fn)
+{
+	unsigned int remain = len - round_down(len, SHA512_BLOCK_SIZE);
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+
+	len -= remain;
+	sctx->count[0] += len;
+	if (sctx->count[0] < len)
+		sctx->count[1]++;
+	block_fn(sctx, data, len / SHA512_BLOCK_SIZE);
+	return remain;
+}
+
+static inline int sha512_base_do_finup(struct shash_desc *desc, const u8 *src,
+				       unsigned int len,
+				       sha512_block_fn *block_fn)
+{
+	unsigned int bit_offset = SHA512_BLOCK_SIZE / 8 - 2;
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	union {
+		__be64 b64[SHA512_BLOCK_SIZE / 4];
+		u8 u8[SHA512_BLOCK_SIZE * 2];
+	} block = {};
+
+	if (len >= SHA512_BLOCK_SIZE) {
+		int remain;
+
+		remain = sha512_base_do_update_blocks(desc, src, len, block_fn);
+		src += len - remain;
+		len = remain;
+	}
+
+	if (len >= bit_offset * 8)
+		bit_offset += SHA512_BLOCK_SIZE / 8;
+	memcpy(&block, src, len);
+	block.u8[len] = 0x80;
+	sctx->count[0] += len;
+	block.b64[bit_offset] = cpu_to_be64(sctx->count[1] << 3 |
+					    sctx->count[0] >> 61);
+	block.b64[bit_offset + 1] = cpu_to_be64(sctx->count[0] << 3);
+	block_fn(sctx, block.u8, (bit_offset + 2) * 8 / SHA512_BLOCK_SIZE);
+	memzero_explicit(&block, sizeof(block));
+
+	return 0;
+}
+
 static inline int sha512_base_do_finalize(struct shash_desc *desc,
 					  sha512_block_fn *block_fn)
 {
@@ -126,8 +172,6 @@ static inline int sha512_base_finish(struct shash_desc *desc, u8 *out)
 
 	for (i = 0; digest_size > 0; i++, digest_size -= sizeof(__be64))
 		put_unaligned_be64(sctx->state[i], digest++);
-
-	memzero_explicit(sctx, sizeof(*sctx));
 	return 0;
 }
 
-- 
2.39.5

