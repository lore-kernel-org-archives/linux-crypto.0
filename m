Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D87126868F
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 02:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945145; cv=none; b=muZumNUrhDgPhzZrimzGP8vCi5+OWGeymBIVI2n/PcsMlDpZWJoB1tvhgfDnXiqGEkbgQPrfF3r03W9PakMzrx7cjzVZqtSmW/IsgPWGkdkBrpe732F8YvLo6T3hNvmAWAFv2UfoykH83xcMIK5zkvuPRe9Hv6yu8yQHLVoZu5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945145; c=relaxed/simple;
	bh=FJjud+hNfHgy5tSXCXBZAghbTx2AYajZLflR+gJDzSY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=n+bHTvMbTpyb53U1NswnboxGygPP5SjpDf580763DmlQ/nGxYUPKLX896ZjwdiuYhMRY5tHQibYmVA9gI40RzggTe9QG/tBQ0tcdVU/tkUPdrnDv90B//nNmZctPw9Un20uHpDe9hZR9kVDobyZKTpoYZR3er4X73wykgzN0F+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VylG4F64; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VylG4F64"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ddCkJtMDNuUWsev+N1WMQRbK+DN1LmeR25+dPyu0u+s=; b=VylG4F64bWkOsZzPY3gERYof0f
	/hQCdzvKL5eso3NmF1yZTi16uIfsBy1PWztRjqKWSqEibXkCcVMxC7e9j435/O7CVXLbD5n83bEgA
	kOfv3XzFs3X5+X/UH3sBT976BoScocTjNzpSUXkWRIotILw/kODPr/tq+KYyyKzEggjjT5Fqcx+nT
	IWLmx6yYWBet9gPW+IrpSNxKOEssRgPWFHCJmTOFHJotirGSO50GbIcf9KH6UVu2t3h6a09aeJdQP
	bTV8mwar/c6d+hC0/LqKApD/p+kkD4Wmhky7BAhsoH7BGY36na5tnczoTFvwqtqEqifjRZKW+eU/w
	84XSiQrg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u5bwR-00Ge3w-1m;
	Fri, 18 Apr 2025 10:59:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Apr 2025 10:58:59 +0800
Date: Fri, 18 Apr 2025 10:58:59 +0800
Message-Id: <e470f0daf1ca40dd2126b1e2b562228e2e5cea58.1744945025.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744945025.git.herbert@gondor.apana.org.au>
References: <cover.1744945025.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 09/67] crypto: s390/ghash - Use API partial block handling
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Use the Crypto API partial block handling.

Also switch to the generic export format.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/ghash_s390.c | 110 ++++++++++++++++------------------
 1 file changed, 50 insertions(+), 60 deletions(-)

diff --git a/arch/s390/crypto/ghash_s390.c b/arch/s390/crypto/ghash_s390.c
index 0800a2a5799f..dcbcee37cb63 100644
--- a/arch/s390/crypto/ghash_s390.c
+++ b/arch/s390/crypto/ghash_s390.c
@@ -8,29 +8,28 @@
  * Author(s): Gerald Schaefer <gerald.schaefer@de.ibm.com>
  */
 
-#include <crypto/internal/hash.h>
-#include <linux/module.h>
-#include <linux/cpufeature.h>
 #include <asm/cpacf.h>
+#include <crypto/ghash.h>
+#include <crypto/internal/hash.h>
+#include <linux/cpufeature.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 
-#define GHASH_BLOCK_SIZE	16
-#define GHASH_DIGEST_SIZE	16
-
-struct ghash_ctx {
+struct s390_ghash_ctx {
 	u8 key[GHASH_BLOCK_SIZE];
 };
 
-struct ghash_desc_ctx {
+struct s390_ghash_desc_ctx {
 	u8 icv[GHASH_BLOCK_SIZE];
 	u8 key[GHASH_BLOCK_SIZE];
-	u8 buffer[GHASH_BLOCK_SIZE];
-	u32 bytes;
 };
 
 static int ghash_init(struct shash_desc *desc)
 {
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct s390_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
 	memset(dctx, 0, sizeof(*dctx));
 	memcpy(dctx->key, ctx->key, GHASH_BLOCK_SIZE);
@@ -41,7 +40,7 @@ static int ghash_init(struct shash_desc *desc)
 static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
-	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
+	struct s390_ghash_ctx *ctx = crypto_shash_ctx(tfm);
 
 	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
@@ -54,80 +53,71 @@ static int ghash_setkey(struct crypto_shash *tfm,
 static int ghash_update(struct shash_desc *desc,
 			 const u8 *src, unsigned int srclen)
 {
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 	unsigned int n;
-	u8 *buf = dctx->buffer;
-
-	if (dctx->bytes) {
-		u8 *pos = buf + (GHASH_BLOCK_SIZE - dctx->bytes);
-
-		n = min(srclen, dctx->bytes);
-		dctx->bytes -= n;
-		srclen -= n;
-
-		memcpy(pos, src, n);
-		src += n;
-
-		if (!dctx->bytes) {
-			cpacf_kimd(CPACF_KIMD_GHASH, dctx, buf,
-				   GHASH_BLOCK_SIZE);
-		}
-	}
 
 	n = srclen & ~(GHASH_BLOCK_SIZE - 1);
-	if (n) {
-		cpacf_kimd(CPACF_KIMD_GHASH, dctx, src, n);
-		src += n;
-		srclen -= n;
-	}
-
-	if (srclen) {
-		dctx->bytes = GHASH_BLOCK_SIZE - srclen;
-		memcpy(buf, src, srclen);
-	}
-
-	return 0;
+	cpacf_kimd(CPACF_KIMD_GHASH, dctx, src, n);
+	return srclen - n;
 }
 
-static int ghash_flush(struct ghash_desc_ctx *dctx)
+static void ghash_flush(struct s390_ghash_desc_ctx *dctx, const u8 *src,
+			unsigned int len)
 {
-	u8 *buf = dctx->buffer;
+	if (len) {
+		u8 buf[GHASH_BLOCK_SIZE] = {};
 
-	if (dctx->bytes) {
-		u8 *pos = buf + (GHASH_BLOCK_SIZE - dctx->bytes);
-
-		memset(pos, 0, dctx->bytes);
+		memcpy(buf, src, len);
 		cpacf_kimd(CPACF_KIMD_GHASH, dctx, buf, GHASH_BLOCK_SIZE);
-		dctx->bytes = 0;
+		memzero_explicit(buf, sizeof(buf));
 	}
+}
 
+static int ghash_finup(struct shash_desc *desc, const u8 *src,
+		       unsigned int len, u8 *dst)
+{
+	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	ghash_flush(dctx, src, len);
+	memcpy(dst, dctx->icv, GHASH_BLOCK_SIZE);
 	return 0;
 }
 
-static int ghash_final(struct shash_desc *desc, u8 *dst)
+static int ghash_export(struct shash_desc *desc, void *out)
 {
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	int ret;
+	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
 
-	ret = ghash_flush(dctx);
-	if (!ret)
-		memcpy(dst, dctx->icv, GHASH_BLOCK_SIZE);
-	return ret;
+	memcpy(out, dctx->icv, GHASH_DIGEST_SIZE);
+	return 0;
+}
+
+static int ghash_import(struct shash_desc *desc, const void *in)
+{
+	struct s390_ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct s390_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	memcpy(dctx->icv, in, GHASH_DIGEST_SIZE);
+	memcpy(dctx->key, ctx->key, GHASH_BLOCK_SIZE);
+	return 0;
 }
 
 static struct shash_alg ghash_alg = {
 	.digestsize	= GHASH_DIGEST_SIZE,
 	.init		= ghash_init,
 	.update		= ghash_update,
-	.final		= ghash_final,
+	.finup		= ghash_finup,
 	.setkey		= ghash_setkey,
-	.descsize	= sizeof(struct ghash_desc_ctx),
+	.export		= ghash_export,
+	.import		= ghash_import,
+	.statesize	= sizeof(struct ghash_desc_ctx),
+	.descsize	= sizeof(struct s390_ghash_desc_ctx),
 	.base		= {
 		.cra_name		= "ghash",
 		.cra_driver_name	= "ghash-s390",
 		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
 		.cra_blocksize		= GHASH_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct ghash_ctx),
+		.cra_ctxsize		= sizeof(struct s390_ghash_ctx),
 		.cra_module		= THIS_MODULE,
 	},
 };
-- 
2.39.5

