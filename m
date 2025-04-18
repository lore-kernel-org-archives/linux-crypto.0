Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0863D268C6C
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 03:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945255; cv=none; b=C8mb2NMIS2O1CZ+/WX0NF5u4/I0IfVj45QMwoc4qa3vB40BaIlThe7hVIOIXIUD9CvzMwo85wSNMvwfvtsUuIEzB3mrf5XUk6FdPiyEnI97KQiW+fDxCudfT7tjkOG5FE7fZQbm3jFL/IqEE3FfaPtYnV1BepJwzyucRFSNhJkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945255; c=relaxed/simple;
	bh=fpk4GljKRSuuvclONBCyhMGalvMN3iyo3k1bja8Po6U=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=aeJfkKbuyRY81kZkeXuLziyaXNtKOCy4q7jOxzKsHkgRLChcqKfUsIJzZWv0bNgLJnwxm8zaQYfgEA3k5hRGADogx+dXC2uvx3sXsSbxZAx2j86TTQJrEezEpQ2XL8f4M8qNqpFElBVIsVExQjOVRiym3TCzbIkDOhEtNSrynK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TdC9G2lv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TdC9G2lv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SL1B6s5VQHnV/Khwst2w0X6OolZRTQQVoaInxFRrDgE=; b=TdC9G2lvv9pkfgxT0sD5els8W/
	9IFXhzNA4fU/mPqyw9D6l8sUQZaifxhdv4ppX0sJFPoiKj1Rss5xuxmoFVJbBNYN4oq7div96Ca/b
	up72/MXlRSm5nnPC7PAzMpIJShxwKWSDj9DHWlNzJY2ataObZa6VmrYMo+pwNuvcnLIGmjT32ngsY
	QKttZ0D5LAyJO4Oh3CuD8tMhJHuvmnKt5CBBh1h5spwjW+L0Q8V5oENSzL1twxlRZyxng+iEWZj4l
	4MXQKaywHZGgEzlLBo6GSBivsq5hUgq0Xrm1ObVrghlfuOLGexA/w24G6S3ZcgHbh6Qu1xFYUVzf0
	GZKtcohg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5byE-00GeHW-1Z;
	Fri, 18 Apr 2025 11:00:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 11:00:50 +0800
Date: Fri, 18 Apr 2025 11:00:50 +0800
Message-Id: <5a1b7a1c24b9b55f2630fe1947d3c251bc2b62e0.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 57/67] crypto: arm64/sm3-neon - Use API partial block
 handling
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
 arch/arm64/crypto/sm3-neon-glue.c | 48 ++++++-------------------------
 1 file changed, 8 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/crypto/sm3-neon-glue.c b/arch/arm64/crypto/sm3-neon-glue.c
index 8dd71ce79b69..6c4611a503a3 100644
--- a/arch/arm64/crypto/sm3-neon-glue.c
+++ b/arch/arm64/crypto/sm3-neon-glue.c
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
 
 
@@ -23,50 +20,20 @@ asmlinkage void sm3_neon_transform(struct sm3_state *sst, u8 const *src,
 static int sm3_neon_update(struct shash_desc *desc, const u8 *data,
 			   unsigned int len)
 {
-	if (!crypto_simd_usable()) {
-		sm3_update(shash_desc_ctx(desc), data, len);
-		return 0;
-	}
+	int remain;
 
 	kernel_neon_begin();
-	sm3_base_do_update(desc, data, len, sm3_neon_transform);
+	remain = sm3_base_do_update_blocks(desc, data, len, sm3_neon_transform);
 	kernel_neon_end();
-
-	return 0;
-}
-
-static int sm3_neon_final(struct shash_desc *desc, u8 *out)
-{
-	if (!crypto_simd_usable()) {
-		sm3_final(shash_desc_ctx(desc), out);
-		return 0;
-	}
-
-	kernel_neon_begin();
-	sm3_base_do_finalize(desc, sm3_neon_transform);
-	kernel_neon_end();
-
-	return sm3_base_finish(desc, out);
+	return remain;
 }
 
 static int sm3_neon_finup(struct shash_desc *desc, const u8 *data,
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
-		sm3_base_do_update(desc, data, len, sm3_neon_transform);
-	sm3_base_do_finalize(desc, sm3_neon_transform);
+	sm3_base_do_finup(desc, data, len, sm3_neon_transform);
 	kernel_neon_end();
-
 	return sm3_base_finish(desc, out);
 }
 
@@ -74,11 +41,12 @@ static struct shash_alg sm3_alg = {
 	.digestsize		= SM3_DIGEST_SIZE,
 	.init			= sm3_base_init,
 	.update			= sm3_neon_update,
-	.final			= sm3_neon_final,
 	.finup			= sm3_neon_finup,
-	.descsize		= sizeof(struct sm3_state),
+	.descsize		= SM3_STATE_SIZE,
 	.base.cra_name		= "sm3",
 	.base.cra_driver_name	= "sm3-neon",
+	.base.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY |
+				  CRYPTO_AHASH_ALG_FINUP_MAX,
 	.base.cra_blocksize	= SM3_BLOCK_SIZE,
 	.base.cra_module	= THIS_MODULE,
 	.base.cra_priority	= 200,
-- 
2.39.5

