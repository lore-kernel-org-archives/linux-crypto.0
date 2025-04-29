Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDEC28C5B9;
	Tue, 29 Apr 2025 08:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745916578; cv=none; b=QC6MesqmaroSkSZPuABUrP6qatjCBkdhXBFzA7SSc7yIC0iEaAKVTz4A49whSEFycwR2z1qFTdwSoc4/3eYV9PsETyQPyfv1W2foDDd8TM30sOhGDg0qMhWa7bkT1q9KUuMnF+QWwUtHWXTO1U5yqjX5bry3iI4vZ6f6HyAxwtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745916578; c=relaxed/simple;
	bh=lk0LrX0a+HbVCJGoXwhGrCoxbYS5/SI46HtKwdLTy+M=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=ivj/mEMk63SOl3pWwxSWbVhM2v8CdxHwjrPkdHDBlhUFTm/jTeoEKSBOcUMDmF5ZgZtMuULDT7yKtYgDCyHcPGfu0aH0bzB0k8k9PllPuLwCfpN2RhT7UtS1crv0IyXlASS+LPoRLbT4bXX8iC+LFQVrh2+cDidQlVZg8gBD6rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CyXxzigB; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CyXxzigB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vbsgneqm7qPcW1G8e6QkvQbfl14hNGGdkoz14LFgcro=; b=CyXxzigBC9xiBqHGg15bydfyqD
	XfLj7V0kta7fJ5fz9/5G4zHkWP7hdUGjaPLqIQxBR0eTmi9qDtX/ActTJtd9jY8SygDOE0A/Hg2PL
	TIWROzRjfZ0hJk82LNF5RkDVB6DVXs4hwNjZP2fZbvIg5ZSjoI1vSPM35f5mHwfligjZlAqv7vuPq
	EuZEj1cYRtu0xtF1DHWSoIkMGfhTdWAn0lp32fpXqP+V+DI2tEazlWWxZlVgNshHp4VEkpc/Hq3xg
	c1e5vWdsfcEiitXGiYxseN3tTxUlE2v9liZXZmEKewKKTrV09I9nRkx90mI9btT+LnLYUvBtzH2Rp
	iLzxiBew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9gei-001t5j-2R;
	Tue, 29 Apr 2025 16:49:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Apr 2025 16:49:32 +0800
Date: Tue, 29 Apr 2025 16:49:32 +0800
Message-Id: <cd23dee0d92e06f5b8d489b321dacb5dc4597376.1745916278.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745916278.git.herbert@gondor.apana.org.au>
References: <cover.1745916278.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/2] crypto: s390/hmac - Extend hash length counters to 128
 bits
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As sha512 requires 128-bit counters, extend the hash length counters
to that length.  Previously they were just 32 bits which means that
a >4G sha256 hash would be incorrect.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/hmac_s390.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/s390/crypto/hmac_s390.c b/arch/s390/crypto/hmac_s390.c
index bba9a818dfdc..e6edf1013228 100644
--- a/arch/s390/crypto/hmac_s390.c
+++ b/arch/s390/crypto/hmac_s390.c
@@ -72,23 +72,23 @@ struct s390_kmac_sha2_ctx {
 	u8 param[MAX_DIGEST_SIZE + MAX_IMBL_SIZE + MAX_BLOCK_SIZE];
 	union s390_kmac_gr0 gr0;
 	u8 buf[MAX_BLOCK_SIZE];
-	unsigned int buflen;
+	u64 buflen[2];
 };
 
 /*
  * kmac_sha2_set_imbl - sets the input message bit-length based on the blocksize
  */
-static inline void kmac_sha2_set_imbl(u8 *param, unsigned int buflen,
-				      unsigned int blocksize)
+static inline void kmac_sha2_set_imbl(u8 *param, u64 buflen_lo,
+				      u64 buflen_hi, unsigned int blocksize)
 {
 	u8 *imbl = param + SHA2_IMBL_OFFSET(blocksize);
 
 	switch (blocksize) {
 	case SHA256_BLOCK_SIZE:
-		*(u64 *)imbl = (u64)buflen * BITS_PER_BYTE;
+		*(u64 *)imbl = buflen_lo * BITS_PER_BYTE;
 		break;
 	case SHA512_BLOCK_SIZE:
-		*(u128 *)imbl = (u128)buflen * BITS_PER_BYTE;
+		*(u128 *)imbl = (((u128)buflen_hi << 64) + buflen_lo) << 3;
 		break;
 	default:
 		break;
@@ -176,7 +176,8 @@ static int s390_hmac_sha2_init(struct shash_desc *desc)
 	memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
 	       tfm_ctx->key, bs);
 
-	ctx->buflen = 0;
+	ctx->buflen[0] = 0;
+	ctx->buflen[1] = 0;
 	ctx->gr0.reg = 0;
 	switch (crypto_shash_digestsize(desc->tfm)) {
 	case SHA224_DIGEST_SIZE:
@@ -206,8 +207,10 @@ static int s390_hmac_sha2_update(struct shash_desc *desc,
 	unsigned int offset, n;
 
 	/* check current buffer */
-	offset = ctx->buflen % bs;
-	ctx->buflen += len;
+	offset = ctx->buflen[0] % bs;
+	ctx->buflen[0] += len;
+	if (ctx->buflen[0] < len)
+		ctx->buflen[1]++;
 	if (offset + len < bs)
 		goto store;
 
@@ -243,8 +246,8 @@ static int s390_hmac_sha2_final(struct shash_desc *desc, u8 *out)
 	unsigned int bs = crypto_shash_blocksize(desc->tfm);
 
 	ctx->gr0.iimp = 0;
-	kmac_sha2_set_imbl(ctx->param, ctx->buflen, bs);
-	_cpacf_kmac(&ctx->gr0.reg, ctx->param, ctx->buf, ctx->buflen % bs);
+	kmac_sha2_set_imbl(ctx->param, ctx->buflen[0], ctx->buflen[1], bs);
+	_cpacf_kmac(&ctx->gr0.reg, ctx->param, ctx->buf, ctx->buflen[0] % bs);
 	memcpy(out, ctx->param, crypto_shash_digestsize(desc->tfm));
 
 	return 0;
@@ -262,7 +265,7 @@ static int s390_hmac_sha2_digest(struct shash_desc *desc,
 		return rc;
 
 	ctx->gr0.iimp = 0;
-	kmac_sha2_set_imbl(ctx->param, len,
+	kmac_sha2_set_imbl(ctx->param, len, 0,
 			   crypto_shash_blocksize(desc->tfm));
 	_cpacf_kmac(&ctx->gr0.reg, ctx->param, data, len);
 	memcpy(out, ctx->param, ds);
-- 
2.39.5

