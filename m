Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73DF27701
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742088088; cv=none; b=PXWpWILO1CroVQK3f8EKIc1aOIxV/9haVf8GeymDsVZMcQOcUnpw0NIaMTyXLDXaNMTv6ODh1VApQ3pe2zt08n9DI8TBmfNMhD6HbLF3gyqeXlSNS6vBlWSae/wYHB+ijhdzUyuzJrFuOYlk2TSWkpWYLbFThEUSiJPqSwnb5ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742088088; c=relaxed/simple;
	bh=ArnD1b/88rgr6McIzCUHvURUBSZZd01qIsXRJtuzwqc=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=OIYjELZueMpGAWk4qNUh7BwCTsXoHTxtXUa7YH3o20Gs6yltX4BOAHWtd/w6BDMzCzRWW2AykT+hraIhHAKJ/F9wsCjH5zBC4vvrPbQSiXxEifcE8fUBd70bzTG6tBpnLHq52/Mb9CzuZ7DPxBNadRbDqjsK2OEeWfdxXXQEia8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GD5qN4W4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GD5qN4W4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qCWss80awS06ofsDUW5ySzos/8z8QafJX83rn9maZmo=; b=GD5qN4W4/svoUqSMDGwDnKzH/P
	lK6+XosMiuY2e0vvKeLEXtRunxgKy+phXXdaHYjBvBgyD501z9A3RRukM/8Af9Rylu0TRYfSytPzZ
	xNYFgXzwqZK2ezjPLHeG1fb0lK9hasNpl/xI01XXZxg5gJLNBoRmtV7J8YFYw2c4xg6dDoIX+y4CT
	MhpVIYPLzjEeTlyMOvi7SmUp2bOtsOMfHxMjf5qpce/eDGpLsygk9O/DZo7w3y0w/63eKZNGvHYJL
	zOciX9W7QXOt4hgn4MghrRmPHVrGXBrTFCwTS93jmyUjrb4Y04i6PsBUgnPNbjce0Su80NqwZDfEx
	fbjFYIZg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttcgs-006xaY-1L;
	Sun, 16 Mar 2025 09:21:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 09:21:22 +0800
Date: Sun, 16 Mar 2025 09:21:22 +0800
Message-Id: <a5271a1313bdb307582f661376de1f18d7e4febb.1742087941.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742087941.git.herbert@gondor.apana.org.au>
References: <cover.1742087941.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 09/11] crypto: cavium/zip - drop obsolete 'comp'
 implementation
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

From: Ard Biesheuvel <ardb@kernel.org>

The 'comp' API is obsolete and will be removed, so remove this comp
implementation.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/cavium/zip/zip_crypto.c | 40 ---------------------
 drivers/crypto/cavium/zip/zip_crypto.h | 11 ------
 drivers/crypto/cavium/zip/zip_main.c   | 50 +-------------------------
 3 files changed, 1 insertion(+), 100 deletions(-)

diff --git a/drivers/crypto/cavium/zip/zip_crypto.c b/drivers/crypto/cavium/zip/zip_crypto.c
index a9c3efce8f2d..02e87f2d50db 100644
--- a/drivers/crypto/cavium/zip/zip_crypto.c
+++ b/drivers/crypto/cavium/zip/zip_crypto.c
@@ -195,46 +195,6 @@ static int zip_decompress(const u8 *src, unsigned int slen,
 	return ret;
 }
 
-/* Legacy Compress framework start */
-int zip_alloc_comp_ctx_deflate(struct crypto_tfm *tfm)
-{
-	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
-
-	return zip_ctx_init(zip_ctx, 0);
-}
-
-int zip_alloc_comp_ctx_lzs(struct crypto_tfm *tfm)
-{
-	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
-
-	return zip_ctx_init(zip_ctx, 1);
-}
-
-void zip_free_comp_ctx(struct crypto_tfm *tfm)
-{
-	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
-
-	zip_ctx_exit(zip_ctx);
-}
-
-int  zip_comp_compress(struct crypto_tfm *tfm,
-		       const u8 *src, unsigned int slen,
-		       u8 *dst, unsigned int *dlen)
-{
-	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
-
-	return zip_compress(src, slen, dst, dlen, zip_ctx);
-}
-
-int  zip_comp_decompress(struct crypto_tfm *tfm,
-			 const u8 *src, unsigned int slen,
-			 u8 *dst, unsigned int *dlen)
-{
-	struct zip_kernel_ctx *zip_ctx = crypto_tfm_ctx(tfm);
-
-	return zip_decompress(src, slen, dst, dlen, zip_ctx);
-} /* Legacy compress framework end */
-
 /* SCOMP framework start */
 void *zip_alloc_scomp_ctx_deflate(void)
 {
diff --git a/drivers/crypto/cavium/zip/zip_crypto.h b/drivers/crypto/cavium/zip/zip_crypto.h
index dbe20bfeb3e9..10899ece2d1f 100644
--- a/drivers/crypto/cavium/zip/zip_crypto.h
+++ b/drivers/crypto/cavium/zip/zip_crypto.h
@@ -46,7 +46,6 @@
 #ifndef __ZIP_CRYPTO_H__
 #define __ZIP_CRYPTO_H__
 
-#include <linux/crypto.h>
 #include <crypto/internal/scompress.h>
 #include "common.h"
 #include "zip_deflate.h"
@@ -57,16 +56,6 @@ struct zip_kernel_ctx {
 	struct zip_operation zip_decomp;
 };
 
-int  zip_alloc_comp_ctx_deflate(struct crypto_tfm *tfm);
-int  zip_alloc_comp_ctx_lzs(struct crypto_tfm *tfm);
-void zip_free_comp_ctx(struct crypto_tfm *tfm);
-int  zip_comp_compress(struct crypto_tfm *tfm,
-		       const u8 *src, unsigned int slen,
-		       u8 *dst, unsigned int *dlen);
-int  zip_comp_decompress(struct crypto_tfm *tfm,
-			 const u8 *src, unsigned int slen,
-			 u8 *dst, unsigned int *dlen);
-
 void *zip_alloc_scomp_ctx_deflate(void);
 void *zip_alloc_scomp_ctx_lzs(void);
 void  zip_free_scomp_ctx(void *zip_ctx);
diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index dc5b7bf7e1fd..abd58de4343d 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -371,36 +371,6 @@ static struct pci_driver zip_driver = {
 
 /* Kernel Crypto Subsystem Interface */
 
-static struct crypto_alg zip_comp_deflate = {
-	.cra_name		= "deflate",
-	.cra_driver_name	= "deflate-cavium",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct zip_kernel_ctx),
-	.cra_priority           = 300,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= zip_alloc_comp_ctx_deflate,
-	.cra_exit		= zip_free_comp_ctx,
-	.cra_u			= { .compress = {
-		.coa_compress	= zip_comp_compress,
-		.coa_decompress	= zip_comp_decompress
-		 } }
-};
-
-static struct crypto_alg zip_comp_lzs = {
-	.cra_name		= "lzs",
-	.cra_driver_name	= "lzs-cavium",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct zip_kernel_ctx),
-	.cra_priority           = 300,
-	.cra_module		= THIS_MODULE,
-	.cra_init		= zip_alloc_comp_ctx_lzs,
-	.cra_exit		= zip_free_comp_ctx,
-	.cra_u			= { .compress = {
-		.coa_compress	= zip_comp_compress,
-		.coa_decompress	= zip_comp_decompress
-		 } }
-};
-
 static struct scomp_alg zip_scomp_deflate = {
 	.alloc_ctx		= zip_alloc_scomp_ctx_deflate,
 	.free_ctx		= zip_free_scomp_ctx,
@@ -431,22 +401,10 @@ static int zip_register_compression_device(void)
 {
 	int ret;
 
-	ret = crypto_register_alg(&zip_comp_deflate);
-	if (ret < 0) {
-		zip_err("Deflate algorithm registration failed\n");
-		return ret;
-	}
-
-	ret = crypto_register_alg(&zip_comp_lzs);
-	if (ret < 0) {
-		zip_err("LZS algorithm registration failed\n");
-		goto err_unregister_alg_deflate;
-	}
-
 	ret = crypto_register_scomp(&zip_scomp_deflate);
 	if (ret < 0) {
 		zip_err("Deflate scomp algorithm registration failed\n");
-		goto err_unregister_alg_lzs;
+		return ret;
 	}
 
 	ret = crypto_register_scomp(&zip_scomp_lzs);
@@ -459,18 +417,12 @@ static int zip_register_compression_device(void)
 
 err_unregister_scomp_deflate:
 	crypto_unregister_scomp(&zip_scomp_deflate);
-err_unregister_alg_lzs:
-	crypto_unregister_alg(&zip_comp_lzs);
-err_unregister_alg_deflate:
-	crypto_unregister_alg(&zip_comp_deflate);
 
 	return ret;
 }
 
 static void zip_unregister_compression_device(void)
 {
-	crypto_unregister_alg(&zip_comp_deflate);
-	crypto_unregister_alg(&zip_comp_lzs);
 	crypto_unregister_scomp(&zip_scomp_deflate);
 	crypto_unregister_scomp(&zip_scomp_lzs);
 }
-- 
2.39.5

