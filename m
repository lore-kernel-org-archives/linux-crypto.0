From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] crypto: api - Export pcomp through comp
Date: Tue, 13 Jan 2009 16:59:43 +0100
Message-ID: <1231862386-11128-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47641 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752715AbZAMP76 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2009 10:59:58 -0500
In-Reply-To: <1231862386-11128-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Allow "pcomp" algorithms to be used through the old "comp" interface, by
implementing one-shot (de)compression on top of the partial (de)compression
interface.

As the old "comp" interface doesn't support the configuration of
(de)compression parameters by the user, each algorithm must provide a set of
default parameters through pcomp_alg.default_params.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/pcompress.c        |  109 +++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/compress.h |    3 +
 include/linux/crypto.h    |    7 ++-
 3 files changed, 116 insertions(+), 3 deletions(-)

diff --git a/crypto/pcompress.c b/crypto/pcompress.c
index b9e3724..8026d12 100644
--- a/crypto/pcompress.c
+++ b/crypto/pcompress.c
@@ -32,8 +32,117 @@
 #include "internal.h"
 
 
+static int crypto_init_compat(struct crypto_tfm *tfm)
+{
+	struct pcomp_alg *alg = __crypto_pcomp_alg(tfm->__crt_alg);
+	int error;
+
+	error = alg->base.cra_init(tfm);
+	if (error)
+		return error;
+
+	error = alg->setup(tfm, alg->default_params);
+	if (error)
+		pr_debug("pcomp_alg.setup failed %d\n", error);
+
+	return error;
+}
+
+static int crypto_compress_compat(struct crypto_tfm *tfm, const u8 *src,
+				  unsigned int slen, u8 *dst,
+				  unsigned int *dlen)
+{
+	struct pcomp_alg *alg = __crypto_pcomp_alg(tfm->__crt_alg);
+	struct comp_request req;
+	int error;
+
+	pr_debug("src = %p, slen = %u, dst = %p, dlen = %u\n", src, slen, dst,
+		 *dlen);
+
+	error = alg->compress_init(tfm);
+	if (error) {
+		pr_debug("pcomp_alg.compress_init failed %d\n", error);
+		return error;
+	}
+
+	req.next_in = src;
+	req.avail_in = slen;
+	req.next_out = dst;
+	req.avail_out = *dlen;
+
+	error = alg->compress_update(tfm, &req);
+	if (error && (error != -EAGAIN || req.avail_in)) {
+		pr_debug("pcomp_alg.compress_update failed %d\n", error);
+		return error;
+	}
+
+	error = alg->compress_final(tfm, &req);
+	if (error) {
+		pr_debug("pcomp_alg.compress_final failed %d\n", error);
+		return error;
+	}
+
+	*dlen -= req.avail_out;
+
+	return 0;
+}
+
+static int crypto_decompress_compat(struct crypto_tfm *tfm, const u8 *src,
+				    unsigned int slen, u8 *dst,
+				    unsigned int *dlen)
+{
+	struct pcomp_alg *alg = __crypto_pcomp_alg(tfm->__crt_alg);
+	struct comp_request req;
+	int error;
+
+	pr_debug("src = %p, slen = %u, dst = %p, dlen = %u\n", src, slen, dst,
+		 *dlen);
+
+	error = alg->decompress_init(tfm);
+	if (error) {
+		pr_debug("pcomp_alg.decompress_init failed %d\n", error);
+		return error;
+	}
+
+	req.next_in = src;
+	req.avail_in = slen;
+	req.next_out = dst;
+	req.avail_out = *dlen;
+
+	error = alg->decompress_update(tfm, &req);
+	if (error && (error != -EAGAIN || req.avail_in)) {
+		pr_debug("pcomp_alg.decompress_update failed %d\n", error);
+		return error;
+	}
+
+	error = alg->decompress_final(tfm, &req);
+	if (error) {
+		pr_debug("pcomp_alg.decompress_final failed %d\n", error);
+		return error;
+	}
+
+	*dlen -= req.avail_out;
+
+	return 0;
+}
+
+static int crypto_init_pcomp_ops_compat(struct crypto_tfm *tfm)
+{
+	struct compress_tfm *ops = &tfm->crt_compress;
+
+	tfm->init = crypto_init_compat;
+
+	ops->cot_compress = crypto_compress_compat;
+	ops->cot_decompress = crypto_decompress_compat;
+
+	return 0;
+}
+
 static int crypto_init_pcomp_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
+	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_COMPRESS)
+		return crypto_init_pcomp_ops_compat(tfm);
+
 	return 0;
 }
 
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index a6493b9..8b3e816 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -44,6 +44,9 @@ struct pcomp_alg {
 				struct comp_request *req);
 
 	struct crypto_alg base;
+
+	/* for backwards-compatibility with compress_alg only */
+	const void *default_params;
 };
 
 struct crypto_pcomp {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 34db6a6..bb0905b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -30,7 +30,6 @@
  */
 #define CRYPTO_ALG_TYPE_MASK		0x0000000f
 #define CRYPTO_ALG_TYPE_CIPHER		0x00000001
-#define CRYPTO_ALG_TYPE_COMPRESS	0x00000002
 #define CRYPTO_ALG_TYPE_AEAD		0x00000003
 #define CRYPTO_ALG_TYPE_BLKCIPHER	0x00000004
 #define CRYPTO_ALG_TYPE_ABLKCIPHER	0x00000005
@@ -40,11 +39,13 @@
 #define CRYPTO_ALG_TYPE_SHASH		0x00000009
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
+#define CRYPTO_ALG_TYPE_COMPRESS	0x0000000e
 #define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
 #define CRYPTO_ALG_TYPE_BLKCIPHER_MASK	0x0000000c
+#define CRYPTO_ALG_TYPE_COMPRESS_MASK	0x0000000e
 
 #define CRYPTO_ALG_LARVAL		0x00000010
 #define CRYPTO_ALG_DEAD			0x00000020
@@ -1297,7 +1298,7 @@ static inline struct crypto_comp *crypto_alloc_comp(const char *alg_name,
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_COMPRESS;
-	mask |= CRYPTO_ALG_TYPE_MASK;
+	mask |= CRYPTO_ALG_TYPE_COMPRESS_MASK;
 
 	return __crypto_comp_cast(crypto_alloc_base(alg_name, type, mask));
 }
@@ -1316,7 +1317,7 @@ static inline int crypto_has_comp(const char *alg_name, u32 type, u32 mask)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_COMPRESS;
-	mask |= CRYPTO_ALG_TYPE_MASK;
+	mask |= CRYPTO_ALG_TYPE_COMPRESS_MASK;
 
 	return crypto_has_alg(alg_name, type, mask);
 }
-- 
1.6.0.4

