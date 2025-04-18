Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BEB268C78
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945260; cv=none; b=rydB8e6y2RdLThZaIJwb7ypSl+U3mBkBobJSu/pof9M8aXn2qEoUhmoma9zOqVunsyYPmj3GWhbH1wTgQ+CUU2TK9sNaJpaB7i58v5ZVwqqDQumELIlFUqXN68bLGp7Uvpa7fJv4P8PXTPN5jQoFIg2xOmTglqxrKg1wRhZKUcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945260; c=relaxed/simple;
	bh=6vKcKSwsot/01pGKGy9wWSt1QAyV0jcgI1h6HVgFk1I=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=bJ1wf16dSHL/6ES9E3xmfRIdXRUgVKIy8nxcKq36R0zezEU3uUHUJ1IoTZDlF7U3f9RdS9dYoPYT8SssW1E7RjDMwlAwAnPy9LMeoYNyhsgaq2ryKOM0l1vTEzcPnuY/wRrVU5+dls2OKA227p5ON26HwXohJGte5uhR2GfJ6vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fQttbIBF; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fQttbIBF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=r61ksuYuSwf6Z8tX8wsL2j9DD3cYkyMkm1meLQA2zhM=; b=fQttbIBFQH28WzB3vu0oeX6fze
	ZYWVLo/PA8+8CwINC/htlAfQ3mJIT09m8dR+odZxphqq9JwYGcEJ/JUvRsB55TqSUnerOaE04aLQb
	j0Wax2mLttnrdKiYCRmaTc96j538At9f228Er9MpGJvOnNnin8D/p39PojRYmbZO4xcLSR5mjJl/k
	MVdKgOl2tihz2wqg+AlzOEtXMlnu96mCawqHsWYciaOSbRDvvgIm8nYFEj8BbrvgNX6M4FHkAeIzn
	6VzVH8vuTq4YpRwt2IeI6AZ8TR5hM7dAfMYf4GRBB5BgYXEuecozwx90VNSye3lb7CFaS/jhWUX5Z
	DkpUwqNA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5byJ-00GeIG-0d;
	Fri, 18 Apr 2025 11:00:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:55 +0800
Date: Fri, 18 Apr 2025 11:00:55 +0800
Message-Id: <1e50900465e80b6a6fc8b831a6f9b97cd23d0310.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 59/67] crypto: x86/sm3 - Use API partial block handling
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
 arch/x86/crypto/sm3_avx_glue.c | 54 +++++++---------------------------
 1 file changed, 10 insertions(+), 44 deletions(-)

diff --git a/arch/x86/crypto/sm3_avx_glue.c b/arch/x86/crypto/sm3_avx_glue.c
index 661b6f22ffcd..6e8c42b9dc8e 100644
--- a/arch/x86/crypto/sm3_avx_glue.c
+++ b/arch/x86/crypto/sm3_avx_glue.c
@@ -10,12 +10,11 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/internal/simd.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/types.h>
 #include <crypto/sm3.h>
 #include <crypto/sm3_base.h>
-#include <asm/simd.h>
+#include <linux/cpufeature.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 
 asmlinkage void sm3_transform_avx(struct sm3_state *state,
 			const u8 *data, int nblocks);
@@ -23,13 +22,7 @@ asmlinkage void sm3_transform_avx(struct sm3_state *state,
 static int sm3_avx_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
 {
-	struct sm3_state *sctx = shash_desc_ctx(desc);
-
-	if (!crypto_simd_usable() ||
-			(sctx->count % SM3_BLOCK_SIZE) + len < SM3_BLOCK_SIZE) {
-		sm3_update(sctx, data, len);
-		return 0;
-	}
+	int remain;
 
 	/*
 	 * Make sure struct sm3_state begins directly with the SM3
@@ -38,45 +31,17 @@ static int sm3_avx_update(struct shash_desc *desc, const u8 *data,
 	BUILD_BUG_ON(offsetof(struct sm3_state, state) != 0);
 
 	kernel_fpu_begin();
-	sm3_base_do_update(desc, data, len, sm3_transform_avx);
+	remain = sm3_base_do_update_blocks(desc, data, len, sm3_transform_avx);
 	kernel_fpu_end();
-
-	return 0;
+	return remain;
 }
 
 static int sm3_avx_finup(struct shash_desc *desc, const u8 *data,
 		      unsigned int len, u8 *out)
 {
-	if (!crypto_simd_usable()) {
-		struct sm3_state *sctx = shash_desc_ctx(desc);
-
-		if (len)
-			sm3_update(sctx, data, len);
-
-		sm3_final(sctx, out);
-		return 0;
-	}
-
 	kernel_fpu_begin();
-	if (len)
-		sm3_base_do_update(desc, data, len, sm3_transform_avx);
-	sm3_base_do_finalize(desc, sm3_transform_avx);
+	sm3_base_do_finup(desc, data, len, sm3_transform_avx);
 	kernel_fpu_end();
-
-	return sm3_base_finish(desc, out);
-}
-
-static int sm3_avx_final(struct shash_desc *desc, u8 *out)
-{
-	if (!crypto_simd_usable()) {
-		sm3_final(shash_desc_ctx(desc), out);
-		return 0;
-	}
-
-	kernel_fpu_begin();
-	sm3_base_do_finalize(desc, sm3_transform_avx);
-	kernel_fpu_end();
-
 	return sm3_base_finish(desc, out);
 }
 
@@ -84,13 +49,14 @@ static struct shash_alg sm3_avx_alg = {
 	.digestsize	=	SM3_DIGEST_SIZE,
 	.init		=	sm3_base_init,
 	.update		=	sm3_avx_update,
-	.final		=	sm3_avx_final,
 	.finup		=	sm3_avx_finup,
-	.descsize	=	sizeof(struct sm3_state),
+	.descsize	=	SM3_STATE_SIZE,
 	.base		=	{
 		.cra_name	=	"sm3",
 		.cra_driver_name =	"sm3-avx",
 		.cra_priority	=	300,
+		.cra_flags	 =	CRYPTO_AHASH_ALG_BLOCK_ONLY |
+					CRYPTO_AHASH_ALG_FINUP_MAX,
 		.cra_blocksize	=	SM3_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
-- 
2.39.5

