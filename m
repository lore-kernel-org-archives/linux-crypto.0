Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125A223BCEC
	for <linux-crypto@vger.kernel.org>; Wed, 16 Apr 2025 06:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785897; cv=none; b=SCgNcfdbtAuMSW/aCPBPgtD1PDVNjYe85H+OdVMA6AcdAff68xkYB+qmdBru5Lk2RTK4XMTe2VkRnaHABJWT3pm6cbSJ8jAgw2oiZP2Lg8oiXMlIh1EJwkw6Y60UEJFr0pNVGcTq3oz15xBvCPsyeKcLq6F4Uvy9HgslHDXsZtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785897; c=relaxed/simple;
	bh=CL8cRF1NNWrZpA/XuzaI9xesWNY75T6eDlGj1DolE4M=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=P1ym/OEF/IZunqc2/0Sm5Rn9NtgYA2EIc14ZZ2OGa6ZdZTBs3NzU3G46bMbtALpSskp4ploZZCXaab/jfeShdSvjBo+EHNxRVXRWIGeiZvFNxmILCHyatVm3cI9fKwkGqovRLbGjQhSdSIeNrFckUDxxWWlajr1v2pjthAlly0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=N/gZv44p; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="N/gZv44p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Q/hvU7RsoKjdYCNAHKjwgyCOQnly1jJaXI3c67GAA/E=; b=N/gZv44ptIo/6TfnPKHdXwbs4j
	fg+e7+/8M8eUXwGZJYVV/E82gLrHoF6IM8dcynpg8cbLUlHe8+sSzbRqKQjAjsX7lMCBUBsE46eBB
	w5I8H5HPkMwkP8ks5U/OGqvB7jOxfbi1igpKFzh6Mw5DScQiX9IEnahdwX/7JiT3KUTJ0J07f9mbp
	jV8OvvKFryo87UPCbi7+TueSkiF5SMV1orhs2/X0xWWKPfr2sSDbETnXKy174zUCbVFFl0oi5f31I
	kYMbw+x3kbM0jIP3IZAJWmjgLAPUNRMCaUp291RbpSOOuoHt6/NZfP9iRzRb9WCHqCNA65Dv+kn4W
	wOcIZICw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u4wVw-00G6Rv-15;
	Wed, 16 Apr 2025 14:44:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Apr 2025 14:44:52 +0800
Date: Wed, 16 Apr 2025 14:44:52 +0800
Message-Id: <d9fdc6c2965d47b07aecbc07265e2aad0ecfa819.1744784515.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 56/67] crypto: arm64/sm3-ce - Use API partial block handling
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
 arch/arm64/crypto/sm3-ce-glue.c | 48 ++++++---------------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/crypto/sm3-ce-glue.c b/arch/arm64/crypto/sm3-ce-glue.c
index 1a71788c4cda..eac6f5fa0abe 100644
--- a/arch/arm64/crypto/sm3-ce-glue.c
+++ b/arch/arm64/crypto/sm3-ce-glue.c
@@ -6,14 +6,11 @@
  */
 
 #include <asm/neon.h>
-#include <asm/simd.h>
-#include <linux/unaligned.h>
 #include <crypto/internal/hash.h>
-#include <crypto/internal/simd.h>
 #include <crypto/sm3.h>
 #include <crypto/sm3_base.h>
 #include <linux/cpufeature.h>
-#include <linux/crypto.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 
 MODULE_DESCRIPTION("SM3 secure hash using ARMv8 Crypto Extensions");
@@ -26,50 +23,20 @@ asmlinkage void sm3_ce_transform(struct sm3_state *sst, u8 const *src,
 static int sm3_ce_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
 {
-	if (!crypto_simd_usable()) {
-		sm3_update(shash_desc_ctx(desc), data, len);
-		return 0;
-	}
+	int remain;
 
 	kernel_neon_begin();
-	sm3_base_do_update(desc, data, len, sm3_ce_transform);
+	remain = sm3_base_do_update_blocks(desc, data, len, sm3_ce_transform);
 	kernel_neon_end();
-
-	return 0;
-}
-
-static int sm3_ce_final(struct shash_desc *desc, u8 *out)
-{
-	if (!crypto_simd_usable()) {
-		sm3_final(shash_desc_ctx(desc), out);
-		return 0;
-	}
-
-	kernel_neon_begin();
-	sm3_base_do_finalize(desc, sm3_ce_transform);
-	kernel_neon_end();
-
-	return sm3_base_finish(desc, out);
+	return remain;
 }
 
 static int sm3_ce_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
-	if (!crypto_simd_usable()) {
-		struct sm3_state *sctx = shash_desc_ctx(desc);
-
-		if (len)
-			sm3_update(sctx, data, len);
-		sm3_final(sctx, out);
-		return 0;
-	}
-
 	kernel_neon_begin();
-	if (len)
-		sm3_base_do_update(desc, data, len, sm3_ce_transform);
-	sm3_base_do_finalize(desc, sm3_ce_transform);
+	sm3_base_do_finup(desc, data, len, sm3_ce_transform);
 	kernel_neon_end();
-
 	return sm3_base_finish(desc, out);
 }
 
@@ -77,11 +44,12 @@ static struct shash_alg sm3_alg = {
 	.digestsize		= SM3_DIGEST_SIZE,
 	.init			= sm3_base_init,
 	.update			= sm3_ce_update,
-	.final			= sm3_ce_final,
 	.finup			= sm3_ce_finup,
-	.descsize		= sizeof(struct sm3_state),
+	.descsize		= SM3_STATE_SIZE,
 	.base.cra_name		= "sm3",
 	.base.cra_driver_name	= "sm3-ce",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SM3_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 400,
-- 
2.39.5

