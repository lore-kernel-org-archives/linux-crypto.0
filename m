Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AC929DB79;
	Tue, 29 Apr 2025 08:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745916581; cv=none; b=M/YyPlf5dH1Abw+55uUlpD8P6p/TAbS1g5wMO/crC5C0GZ48tKaK9rzAGjQe/3/aI8QdD8nxc5oYBdnprfCT4f8ouUyJzV9OPTVeu+uos5fg6RBlq8u1AscfyDeXqYquNOeXrOC+t5/qCEXK4j5Z+0dGM2NXOTsVQrrs1ejyJ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745916581; c=relaxed/simple;
	bh=jg+lymy4mj5ThNoZxb00tNuhdEbP/S1gRXJYL3X8Q2k=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=UvO9Yw131aQXi/QOj7ImOyIEgrZ9G+iMlCFtc4SHszlUs8AcUrEH+Kq1j3bCPbjHRILQKyn8tNyTv9R0XutVzVR5Y/JohacY/TNBwigEubt/8sKJ+XzpLlcl8ajr260Rd2UYFbyMxG/hqCI4RmcGeLhhmekVnjXjHYNLlGt81lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Mh3FYn1P; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Mh3FYn1P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fNZHqYKyf8pJWU/Udc/dkvjl+m1VOEutDtQ/8YuT3E4=; b=Mh3FYn1PZEOAoQaxjF9u9DfolB
	mdmYQhRyEppBp6FzZ0m/NwOSrEBNNnyNw7w2HZYk6fryryQDyKAV0XSjPknh1EDIWJ83JGfC3H+kw
	WSnJytLzcUPTrTEVw121ow6pTea7XxFXRyHEsqNRSsafwQM17UQrsdSOit4syqiW0Sj0IXS3/Q/K6
	TlJfsXXL5LjqHoGsP43tWsAh3ZmYSBz09p5Dim9K6yWjMeBfKsPEqT1ewrakDp77Pn7DkZ1OAS61r
	uF375GrZ2hbg8u/TW3NTcTcS53MAMqGFXlfjxwJKNXuvM7R/tUMYq1HdmjisNxkQriyd2YzRrxSdT
	7ENfuXiA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9gel-001t5u-0G;
	Tue, 29 Apr 2025 16:49:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Apr 2025 16:49:35 +0800
Date: Tue, 29 Apr 2025 16:49:35 +0800
Message-Id: <81cab16fad98103d8b5c28f2870de08b337c2d78.1745916278.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1745916278.git.herbert@gondor.apana.org.au>
References: <cover.1745916278.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/2] crypto: s390/hmac - Use generic hash export format
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Harald Freudenberger <freude@linux.ibm.com>, Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Convert the hash export format to match that of the generic
algorithm.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/s390/crypto/Kconfig     |   4 +-
 arch/s390/crypto/hmac_s390.c | 175 ++++++++++++++++++++++++++++++++++-
 2 files changed, 173 insertions(+), 6 deletions(-)

diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index e2c27588b21a..342c639ce2dc 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -91,7 +91,9 @@ config CRYPTO_DES_S390
 
 config CRYPTO_HMAC_S390
 	tristate "Keyed-hash message authentication code: HMAC"
-	select CRYPTO_HASH
+	select CRYPTO_HMAC
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	help
 	  s390 specific HMAC hardware support for SHA224, SHA256, SHA384 and
 	  SHA512.
diff --git a/arch/s390/crypto/hmac_s390.c b/arch/s390/crypto/hmac_s390.c
index e6edf1013228..44f2a5d394d1 100644
--- a/arch/s390/crypto/hmac_s390.c
+++ b/arch/s390/crypto/hmac_s390.c
@@ -53,6 +53,7 @@
 #define SHA2_KEY_OFFSET(bs)	(SHA2_CV_SIZE(bs) + SHA2_IMBL_SIZE(bs))
 
 struct s390_hmac_ctx {
+	struct crypto_shash *fb;
 	u8 key[MAX_BLOCK_SIZE];
 };
 
@@ -157,6 +158,11 @@ static int s390_hmac_sha2_setkey(struct crypto_shash *tfm,
 	struct s390_hmac_ctx *tfm_ctx = crypto_shash_ctx(tfm);
 	unsigned int ds = crypto_shash_digestsize(tfm);
 	unsigned int bs = crypto_shash_blocksize(tfm);
+	int err;
+
+	err = crypto_shash_setkey(tfm_ctx->fb, key, keylen);
+	if (err)
+		return err;
 
 	memset(tfm_ctx, 0, sizeof(*tfm_ctx));
 
@@ -273,7 +279,160 @@ static int s390_hmac_sha2_digest(struct shash_desc *desc,
 	return 0;
 }
 
-#define S390_HMAC_SHA2_ALG(x) {						\
+static int s390_hmac_sha2_init_tfm(struct crypto_shash *tfm)
+{
+	struct s390_hmac_ctx *ctx = crypto_shash_ctx(tfm);
+	struct crypto_shash *fb;
+
+	fb = crypto_alloc_shash(crypto_shash_alg_name(tfm), 0,
+				CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(fb))
+		return PTR_ERR(fb);
+
+	ctx->fb = fb;
+	return 0;
+}
+
+static void s390_hmac_sha2_exit_tfm(struct crypto_shash *tfm)
+{
+	struct s390_hmac_ctx *ctx = crypto_shash_ctx(tfm);
+
+	crypto_free_shash(ctx->fb);
+}
+
+static int s390_hmac_export_zero(struct shash_desc *desc, void *out)
+{
+	struct s390_hmac_ctx *ctx = crypto_shash_ctx(desc->tfm);
+	struct crypto_shash *fb = ctx->fb;
+	SHASH_DESC_ON_STACK(fbdesc, fb);
+
+	fbdesc->tfm = fb;
+	return crypto_shash_init(fbdesc) ?:
+	       crypto_shash_export(fbdesc, out);
+}
+
+static int s390_hmac_export_sha256(struct shash_desc *desc, void *out)
+{
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	u64 total = ctx->buflen[0];
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+	unsigned int remain;
+	u64 hashed;
+	int err = 0;
+
+	hashed = round_down(total, SHA256_BLOCK_SIZE);
+	remain = total - hashed;
+
+	if (!hashed)
+		err = s390_hmac_export_zero(desc, out);
+	else
+		memcpy(p.u8, ctx->param, SHA256_DIGEST_SIZE);
+
+	p.u8 += SHA256_DIGEST_SIZE;
+	put_unaligned(total, p.u64++);
+
+	memcpy(p.u8, ctx->buf, remain);
+
+	return err;
+}
+
+static int s390_hmac_import_sha256(struct shash_desc *desc, const void *in)
+{
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	unsigned int remain;
+	u64 total;
+	int err;
+
+	err = s390_hmac_sha2_init(desc);
+	if (err)
+		return err;
+
+	memcpy(ctx->param, p.u8, SHA256_DIGEST_SIZE);
+	p.u8 += SHA256_DIGEST_SIZE;
+
+	total = get_unaligned(p.u64++);
+	remain = total % SHA256_BLOCK_SIZE;
+	ctx->buflen[0] = total;
+
+	if (total - remain)
+		ctx->gr0.ikp = 1;
+
+	memcpy(ctx->buf, p.u8, remain);
+
+	return 0;
+}
+
+static int s390_hmac_export_sha512(struct shash_desc *desc, void *out)
+{
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	u64 total_hi = ctx->buflen[1];
+	u64 total = ctx->buflen[0];
+	union {
+		u8 *u8;
+		u32 *u32;
+		u64 *u64;
+	} p = { .u8 = out };
+	unsigned int remain;
+	u64 hashed;
+	int err = 0;
+
+	hashed = round_down(total, SHA512_BLOCK_SIZE);
+	remain = total - hashed;
+
+	if (!(hashed | total_hi))
+		err = s390_hmac_export_zero(desc, out);
+	else
+		memcpy(p.u8, ctx->param, SHA512_DIGEST_SIZE);
+
+	p.u8 += SHA512_DIGEST_SIZE;
+	put_unaligned(total, p.u64++);
+	put_unaligned(total_hi, p.u64++);
+
+	memcpy(p.u8, ctx->buf, remain);
+
+	return err;
+}
+
+static int s390_hmac_import_sha512(struct shash_desc *desc, const void *in)
+{
+	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+	unsigned int remain;
+	u64 total, total_hi;
+	int err;
+
+	err = s390_hmac_sha2_init(desc);
+	if (err)
+		return err;
+
+	memcpy(ctx->param, p.u8, SHA512_DIGEST_SIZE);
+	p.u8 += SHA512_DIGEST_SIZE;
+
+	total = get_unaligned(p.u64++);
+	total_hi = get_unaligned(p.u64++);
+	ctx->buflen[0] = total;
+	ctx->buflen[1] = total_hi;
+
+	remain = total % SHA512_BLOCK_SIZE;
+	if ((total - remain) | total_hi)
+		ctx->gr0.ikp = 1;
+
+	memcpy(ctx->buf, p.u8, remain);
+
+	return 0;
+}
+
+#define S390_HMAC_SHA2_ALG(x, exf, imf, state) {			\
 	.fc = CPACF_KMAC_HMAC_SHA_##x,					\
 	.alg = {							\
 		.init = s390_hmac_sha2_init,				\
@@ -281,8 +440,13 @@ static int s390_hmac_sha2_digest(struct shash_desc *desc,
 		.final = s390_hmac_sha2_final,				\
 		.digest = s390_hmac_sha2_digest,			\
 		.setkey = s390_hmac_sha2_setkey,			\
+		.init_tfm = s390_hmac_sha2_init_tfm,			\
+		.exit_tfm = s390_hmac_sha2_exit_tfm,			\
+		.export = exf,						\
+		.import = imf,						\
 		.descsize = sizeof(struct s390_kmac_sha2_ctx),		\
 		.halg = {						\
+			.statesize = sizeof(struct state),		\
 			.digestsize = SHA##x##_DIGEST_SIZE,		\
 			.base = {					\
 				.cra_name = "hmac(sha" #x ")",		\
@@ -291,6 +455,7 @@ static int s390_hmac_sha2_digest(struct shash_desc *desc,
 				.cra_priority = 400,			\
 				.cra_ctxsize = sizeof(struct s390_hmac_ctx), \
 				.cra_module = THIS_MODULE,		\
+				.cra_flags = CRYPTO_ALG_NEED_FALLBACK,	\
 			},						\
 		},							\
 	},								\
@@ -301,10 +466,10 @@ static struct s390_hmac_alg {
 	unsigned int fc;
 	struct shash_alg alg;
 } s390_hmac_algs[] = {
-	S390_HMAC_SHA2_ALG(224),
-	S390_HMAC_SHA2_ALG(256),
-	S390_HMAC_SHA2_ALG(384),
-	S390_HMAC_SHA2_ALG(512),
+	S390_HMAC_SHA2_ALG(224, s390_hmac_export_sha256, s390_hmac_import_sha256, sha256_state),
+	S390_HMAC_SHA2_ALG(256, s390_hmac_export_sha256, s390_hmac_import_sha256, sha256_state),
+	S390_HMAC_SHA2_ALG(384, s390_hmac_export_sha512, s390_hmac_import_sha512, sha512_state),
+	S390_HMAC_SHA2_ALG(512, s390_hmac_export_sha512, s390_hmac_import_sha512, sha512_state),
 };
 
 static __always_inline void _s390_hmac_algs_unregister(void)
-- 
2.39.5

