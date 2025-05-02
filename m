Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEAD227E98;
	Fri,  2 May 2025 09:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746176460; cv=none; b=PIRnZf5XK47jEDuPGnl0YuMRaB4tcLxM45CHRH9RLYfZTHShM8wuPK3yNdVQT/fPqs2hz2u0TPOMjGSX9JZaNwoElOOJqyj+ZjBSKar3K/sSo/z1zsKXlTqZXGqae+fVHMPhgLa7qhP4vIEM1E/PfNr/AIbG25HCL0u298ncj8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746176460; c=relaxed/simple;
	bh=lbYCDXtoOwXlWluKTPOylbtvD/UDfULsb6hvONr1z0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ckxeltuQeizznAtGO4dpv/+RoNJ+uh66PfMDs3indIsuXkNMkj6YPSqMXZJJ7HRvK7J3P0bDS9wbEhjCro1erxVLgVEqGwfq8mXxPX3hIBcdhi3/oufMKc7yx2Tx4uTkCDnl1d3wQ+xj3AwMcK3suEMGPHh/bft43H7bzwGMxE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=N7/nwpXN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="N7/nwpXN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AVv7nYvh2USNxewHkTY08ePezuCD7JR7xnlbs2/WTIU=; b=N7/nwpXNn057A00xm87Fn43J+x
	cMf1fG7ON+RwDkXW/830er8pJOqcfXMQzE5CkVCIz2+aMvVqA8UFEnYakrhR9ufUZ5tO82/XmH8Mx
	BPEAWpxT0r+mTmsFvAwvqKcyOiS80Wteg1mVHEtKs/EMcFnaG5AcNgtDetof9JwGOlBP7hDwULJCf
	muPeOCo1WKFnBNBdzW9gL/sDpIuHrBn+0C8tY0ANH7gXc6wygHQ2KcEvGzdsNN5oydMyANIe3xrIc
	/AjlTY47aCi4p97s4NwZuT8bZ0T7zbEtoDK17fD1EraEwANG4J2RvstRor62lxAyNArvPdCktZwcD
	TIGV6pzg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uAmGB-002nnt-20;
	Fri, 02 May 2025 17:00:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 May 2025 17:00:43 +0800
Date: Fri, 2 May 2025 17:00:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [v2 PATCH] crypto: s390/hmac - Use API partial block handling
Message-ID: <aBSJu3PTcPFNHViG@gondor.apana.org.au>
References: <cover.1745916278.git.herbert@gondor.apana.org.au>
 <81cab16fad98103d8b5c28f2870de08b337c2d78.1745916278.git.herbert@gondor.apana.org.au>
 <a0a6f359-27c8-4381-8619-d4aa2cd186fc@ti.com>
 <aBH8p-YEF3wEe4Qm@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBH8p-YEF3wEe4Qm@gondor.apana.org.au>

v2 fixes the export of 224 and 384.

---8<---
Use the Crypto API partial block handling.

Also switch to the generic export format.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/hmac_s390.c | 153 ++++++++++++++++++++++++-----------
 1 file changed, 107 insertions(+), 46 deletions(-)

diff --git a/arch/s390/crypto/hmac_s390.c b/arch/s390/crypto/hmac_s390.c
index e6edf1013228..93a1098d9f8d 100644
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
@@ -273,22 +267,89 @@ static int s390_hmac_sha2_digest(struct shash_desc *desc,
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
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+	unsigned int ds = bs / 2;
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
+	unsigned int bs = crypto_shash_blocksize(desc->tfm);
+	unsigned int ds = bs / 2;
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	int err;
+
+	err = s390_hmac_sha2_init(desc);
+	memcpy(ctx->param, p.u8, ds);
+	p.u8 += ds;
+	ctx->buflen[0] = get_unaligned(p.u64++);
+	if (ds == SHA512_DIGEST_SIZE)
+		ctx->buflen[1] = get_unaligned(p.u64);
+	if (ctx->buflen[0] | ctx->buflen[1])
+		ctx->gr0.ikp = 1;
+	return err;
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
@@ -301,10 +362,10 @@ static struct s390_hmac_alg {
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
