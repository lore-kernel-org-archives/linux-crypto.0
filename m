Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745002505BE;
	Wed, 30 Apr 2025 10:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746009269; cv=none; b=X5x3YfVkVaIJCAXShIG5CD9VngSHlHOTdcUI8UBU3zbeLDYgAp+Etf5X28MO/D1in55YnWaYtvfTgzW1+co9LNem5Y2/AGNClzxtytXxy4G5hNHt7w08cuThBUrQZGZsS1HFG4gvoTrLPZNGMdeJiR3P/hkJxWQgHEEIbt6Y7h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746009269; c=relaxed/simple;
	bh=XJYNywt1rWr3YArrndoLaWM96DG+2bFlaSjQ0fVDVh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/rel7KwTtLz3NQ7PLJtbw//HeAY3/Vqbcy4CRn7uPvC0eyYE4zGXwNeM7ZpmCZ7ejd2whltilrZdic7J5BsakAqEm5bBRni3QOszHHvDhdhVozeRe9uMQJAz8DoxGiOj2AR5iZtekNj61cclbQcVF715U5P+NstQbGTJdJ1eGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ga09qoaV; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ga09qoaV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YvbyhZIVhrVcZrECRwfD/1Dt4t5xRDekoFM+vI/X2N8=; b=ga09qoaVhH5U8vCV3jeUhlCoZP
	DjiD1VuEBTQf14I8wlurGlsiX09KJlq7GCUx81PKyYDIxDfrDGQ5Mn5LW9KbPhXSRZ//DIHN6VfjA
	5WHdujhl3sU+eLWxrcS0Wu4WjuaPikO4Z+F8zBloYZ/LUxytgrSqZ4ry2882cZc2TTZPfl/UtI8qj
	giN3MplvcAuay18BIly+t5hGPb5WIYmDiOgly0On6QuzvwHr/NLRsx1dkhcHjzYm3hpo4nWbs9X0y
	nZ6ztHf3vXJvvq/UEOssCD5tp5Vlr2uT3LlzzBWq/Npup7DcTAr8y+EvPjuz8R8qt+lmk7D0wHPCF
	DH8GR82g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uA4lb-002F9j-1B;
	Wed, 30 Apr 2025 18:34:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 30 Apr 2025 18:34:15 +0800
Date: Wed, 30 Apr 2025 18:34:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH] crypto: s390/hmac - Use API partial block handling
Message-ID: <aBH8p-YEF3wEe4Qm@gondor.apana.org.au>
References: <cover.1745916278.git.herbert@gondor.apana.org.au>
 <81cab16fad98103d8b5c28f2870de08b337c2d78.1745916278.git.herbert@gondor.apana.org.au>
 <a0a6f359-27c8-4381-8619-d4aa2cd186fc@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0a6f359-27c8-4381-8619-d4aa2cd186fc@ti.com>

On Tue, Apr 29, 2025 at 05:34:18PM +0530, T Pratham wrote:
>
> Why do pointer increment with different types through a union which is un-intuitive to understand and prone to easy errors in future. It is easy to mix up the layout of the data being stored. Why not just typecast void * to a struct exposing different fields? Same with sha512.

You can't cast a void * to a random struct and start writing to
it because of alignment faults.  Now s390 actually happens to be
OK in that respect, but this way of writing exports is used by
my ahash patches as well and I would like to keep them consistent.

> Can use uniform naming here. total_hi and total_lo.

Thanks.  I've got rid of them altogether.

It turns out that the patch I sent out yesterday is actually
wrong as it predates the shash partial block API.  Here is a
more up-to-date version:

---8<---
Use the Crypto API partial block handling.

Also switch to the generic export format.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/hmac_s390.c | 154 ++++++++++++++++++++++++-----------
 1 file changed, 108 insertions(+), 46 deletions(-)

diff --git a/arch/s390/crypto/hmac_s390.c b/arch/s390/crypto/hmac_s390.c
index e6edf1013228..474b4233effd 100644
--- a/arch/s390/crypto/hmac_s390.c
+++ b/arch/s390/crypto/hmac_s390.c
@@ -9,10 +9,14 @@
 #define pr_fmt(fmt)	KMSG_COMPONENT ": " fmt
 
 #include <asm/cpacf.h>
-#include <crypto/sha2.h>
 #include <crypto/internal/hash.h>
+#include <crypto/hmac.h>
+#include <crypto/sha2.h>
 #include <linux/cpufeature.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/string.h>
 
 /*
  * KMAC param block layout for sha2 function codes:
@@ -71,7 +75,6 @@ union s390_kmac_gr0 {
 struct s390_kmac_sha2_ctx {
 	u8 param[MAX_DIGEST_SIZE + MAX_IMBL_SIZE + MAX_BLOCK_SIZE];
 	union s390_kmac_gr0 gr0;
-	u8 buf[MAX_BLOCK_SIZE];
 	u64 buflen[2];
 };
 
@@ -95,8 +98,8 @@ static inline void kmac_sha2_set_imbl(u8 *param, u64 buflen_lo,
 	}
 }
 
-static int hash_key(const u8 *in, unsigned int inlen,
-		    u8 *digest, unsigned int digestsize)
+static int hash_data(const u8 *in, unsigned int inlen,
+		     u8 *digest, unsigned int digestsize, bool final)
 {
 	unsigned long func;
 	union {
@@ -123,19 +126,23 @@ static int hash_key(const u8 *in, unsigned int inlen,
 
 	switch (digestsize) {
 	case SHA224_DIGEST_SIZE:
-		func = CPACF_KLMD_SHA_256;
+		func = final ? CPACF_KLMD_SHA_256 : CPACF_KIMD_SHA_256;
 		PARAM_INIT(256, 224, inlen * 8);
+		if (!final)
+			digestsize = SHA256_DIGEST_SIZE;
 		break;
 	case SHA256_DIGEST_SIZE:
-		func = CPACF_KLMD_SHA_256;
+		func = final ? CPACF_KLMD_SHA_256 : CPACF_KIMD_SHA_256;
 		PARAM_INIT(256, 256, inlen * 8);
 		break;
 	case SHA384_DIGEST_SIZE:
-		func = CPACF_KLMD_SHA_512;
+		func = final ? CPACF_KLMD_SHA_512 : CPACF_KIMD_SHA_512;
 		PARAM_INIT(512, 384, inlen * 8);
+		if (!final)
+			digestsize = SHA512_DIGEST_SIZE;
 		break;
 	case SHA512_DIGEST_SIZE:
-		func = CPACF_KLMD_SHA_512;
+		func = final ? CPACF_KLMD_SHA_512 : CPACF_KIMD_SHA_512;
 		PARAM_INIT(512, 512, inlen * 8);
 		break;
 	default:
@@ -151,6 +158,12 @@ static int hash_key(const u8 *in, unsigned int inlen,
 	return 0;
 }
 
+static int hash_key(const u8 *in, unsigned int inlen,
+		    u8 *digest, unsigned int digestsize)
+{
+	return hash_data(in, inlen, digest, digestsize, true);
+}
+
 static int s390_hmac_sha2_setkey(struct crypto_shash *tfm,
 				 const u8 *key, unsigned int keylen)
 {
@@ -204,50 +217,31 @@ static int s390_hmac_sha2_update(struct shash_desc *desc,
 {
 	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
 	unsigned int bs = crypto_shash_blocksize(desc->tfm);
-	unsigned int offset, n;
+	unsigned int n = round_down(len, bs);
 
-	/* check current buffer */
-	offset = ctx->buflen[0] % bs;
-	ctx->buflen[0] += len;
-	if (ctx->buflen[0] < len)
+	ctx->buflen[0] += n;
+	if (ctx->buflen[0] < n)
 		ctx->buflen[1]++;
-	if (offset + len < bs)
-		goto store;
 
-	/* process one stored block */
-	if (offset) {
-		n = bs - offset;
-		memcpy(ctx->buf + offset, data, n);
-		ctx->gr0.iimp = 1;
-		_cpacf_kmac(&ctx->gr0.reg, ctx->param, ctx->buf, bs);
-		data += n;
-		len -= n;
-		offset = 0;
-	}
 	/* process as many blocks as possible */
-	if (len >= bs) {
-		n = (len / bs) * bs;
-		ctx->gr0.iimp = 1;
-		_cpacf_kmac(&ctx->gr0.reg, ctx->param, data, n);
-		data += n;
-		len -= n;
-	}
-store:
-	/* store incomplete block in buffer */
-	if (len)
-		memcpy(ctx->buf + offset, data, len);
-
-	return 0;
+	ctx->gr0.iimp = 1;
+	_cpacf_kmac(&ctx->gr0.reg, ctx->param, data, n);
+	return len - n;
 }
 
-static int s390_hmac_sha2_final(struct shash_desc *desc, u8 *out)
+static int s390_hmac_sha2_finup(struct shash_desc *desc, const u8 *src,
+				unsigned int len, u8 *out)
 {
 	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
 	unsigned int bs = crypto_shash_blocksize(desc->tfm);
 
+	ctx->buflen[0] += len;
+	if (ctx->buflen[0] < len)
+		ctx->buflen[1]++;
+
 	ctx->gr0.iimp = 0;
 	kmac_sha2_set_imbl(ctx->param, ctx->buflen[0], ctx->buflen[1], bs);
-	_cpacf_kmac(&ctx->gr0.reg, ctx->param, ctx->buf, ctx->buflen[0] % bs);
+	_cpacf_kmac(&ctx->gr0.reg, ctx->param, src, len);
 	memcpy(out, ctx->param, crypto_shash_digestsize(desc->tfm));
 
 	return 0;
@@ -273,22 +267,90 @@ static int s390_hmac_sha2_digest(struct shash_desc *desc,
 	return 0;
 }
 
-#define S390_HMAC_SHA2_ALG(x) {						\
+static int s390_hmac_export_zero(struct shash_desc *desc, void *out)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	u8 ipad[SHA512_BLOCK_SIZE];
+	struct s390_hmac_ctx *ctx;
+	unsigned int bs;
+	int err, i;
+
+	ctx = crypto_shash_ctx(tfm);
+	bs = crypto_shash_blocksize(tfm);
+	for (i = 0; i < bs; i++)
+		ipad[i] = ctx->key[i] ^ HMAC_IPAD_VALUE;
+
+	err = hash_data(ipad, bs, out, crypto_shash_digestsize(tfm), false);
+	memzero_explicit(ipad, sizeof(ipad));
+	return err;
+}
+
+static int s390_hmac_export(struct shash_desc *desc, void *out)
+{
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int ds = crypto_shash_digestsize(desc->tfm);
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+	int err = 0;
+
+	if (!ctx->gr0.ikp)
+		err = s390_hmac_export_zero(desc, out);
+	else
+		memcpy(p.u8, ctx->param, ds);
+	p.u8 += ds;
+	put_unaligned(ctx->buflen[0], p.u64++);
+	if (ds == SHA512_DIGEST_SIZE)
+		put_unaligned(ctx->buflen[1], p.u64);
+	return err;
+}
+
+static int s390_hmac_import(struct shash_desc *desc, const void *in)
+{
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	unsigned int ds = crypto_shash_digestsize(desc->tfm);
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int err;
+
+	err = s390_hmac_sha2_init(desc);
+	if (err)
+		return err;
+
+	memcpy(ctx->param, p.u8, ds);
+	p.u8 += ds;
+	ctx->buflen[0] = get_unaligned(p.u64++);
+	if (ds == SHA512_DIGEST_SIZE)
+		ctx->buflen[1] = get_unaligned(p.u64);
+	if (ctx->buflen[0] | ctx->buflen[1])
+		ctx->gr0.ikp = 1;
+	return 0;
+}
+
+#define S390_HMAC_SHA2_ALG(x, ss) {					\
 	.fc = CPACF_KMAC_HMAC_SHA_##x,					\
 	.alg = {							\
 		.init = s390_hmac_sha2_init,				\
 		.update = s390_hmac_sha2_update,			\
-		.final = s390_hmac_sha2_final,				\
+		.finup = s390_hmac_sha2_finup,				\
 		.digest = s390_hmac_sha2_digest,			\
 		.setkey = s390_hmac_sha2_setkey,			\
+		.export = s390_hmac_export,				\
+		.import = s390_hmac_import,				\
 		.descsize = sizeof(struct s390_kmac_sha2_ctx),		\
 		.halg = {						\
+			.statesize = ss,				\
 			.digestsize = SHA##x##_DIGEST_SIZE,		\
 			.base = {					\
 				.cra_name = "hmac(sha" #x ")",		\
 				.cra_driver_name = "hmac_s390_sha" #x,	\
 				.cra_blocksize = SHA##x##_BLOCK_SIZE,	\
 				.cra_priority = 400,			\
+				.cra_flags = CRYPTO_AHASH_ALG_BLOCK_ONLY | \
+					     CRYPTO_AHASH_ALG_FINUP_MAX, \
 				.cra_ctxsize = sizeof(struct s390_hmac_ctx), \
 				.cra_module = THIS_MODULE,		\
 			},						\
@@ -301,10 +363,10 @@ static struct s390_hmac_alg {
 	unsigned int fc;
 	struct shash_alg alg;
 } s390_hmac_algs[] = {
-	S390_HMAC_SHA2_ALG(224),
-	S390_HMAC_SHA2_ALG(256),
-	S390_HMAC_SHA2_ALG(384),
-	S390_HMAC_SHA2_ALG(512),
+	S390_HMAC_SHA2_ALG(224, sizeof(struct crypto_sha256_state)),
+	S390_HMAC_SHA2_ALG(256, sizeof(struct crypto_sha256_state)),
+	S390_HMAC_SHA2_ALG(384, SHA512_STATE_SIZE),
+	S390_HMAC_SHA2_ALG(512, SHA512_STATE_SIZE),
 };
 
 static __always_inline void _s390_hmac_algs_unregister(void)
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
