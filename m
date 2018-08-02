From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/9] crypto: add zbufsize() interface
Date: Thu,  2 Aug 2018 14:51:10 -0700
Message-ID: <20180802215118.17752-2-keescook@chromium.org>
References: <20180802215118.17752-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Haren Myneni <haren@us.ibm.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802215118.17752-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When pstore was refactored to use the crypto compress API in:

  commit cb3bee0369bc ("pstore: Use crypto compress API")

nearly all the pstore-specific compression routines were replaced with
the existing crypto compression API. One case remained: calculating the
"worst case" compression sizes ahead of time so it could have a buffer
preallocated for doing compression (which was called "zbufsize").

To make pstore fully algorithm-agnostic, the compression API needs to
grow this functionality. This adds the interface to support querying the
"worst case" estimate, with a new "zbufsize" routine that each compressor
can implement. The per-compressor implementations come in later commits.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/compress.c                   |  9 +++++++++
 include/crypto/internal/scompress.h | 11 +++++++++++
 include/linux/crypto.h              | 12 ++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/crypto/compress.c b/crypto/compress.c
index f2d522924a07..29a80bb3b9d3 100644
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -33,12 +33,21 @@ static int crypto_decompress(struct crypto_tfm *tfm,
 	                                                   dlen);
 }
 
+static int crypto_zbufsize(struct crypto_tfm *tfm,
+			   unsigned int slen, unsigned int *dlen)
+{
+	if (!tfm->__crt_alg->cra_compress.coa_zbufsize)
+		return -ENOTSUPP;
+	return tfm->__crt_alg->cra_compress.coa_zbufsize(tfm, slen, dlen);
+}
+
 int crypto_init_compress_ops(struct crypto_tfm *tfm)
 {
 	struct compress_tfm *ops = &tfm->crt_compress;
 
 	ops->cot_compress = crypto_compress;
 	ops->cot_decompress = crypto_decompress;
+	ops->cot_zbufsize = crypto_zbufsize;
 
 	return 0;
 }
diff --git a/include/crypto/internal/scompress.h b/include/crypto/internal/scompress.h
index 0f6ddac1acfc..a4a2a55080ad 100644
--- a/include/crypto/internal/scompress.h
+++ b/include/crypto/internal/scompress.h
@@ -39,6 +39,8 @@ struct scomp_alg {
 	int (*decompress)(struct crypto_scomp *tfm, const u8 *src,
 			  unsigned int slen, u8 *dst, unsigned int *dlen,
 			  void *ctx);
+	int (*zbufsize)(struct crypto_scomp *tfm, unsigned int slen,
+			unsigned int *dlen, void *ctx);
 	struct crypto_alg base;
 };
 
@@ -94,6 +96,15 @@ static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,
 						 ctx);
 }
 
+static inline int crypto_scomp_zbufsize(struct crypto_scomp *tfm,
+					unsigned int slen,
+					unsigned int *dlen, void *ctx)
+{
+	if (!crypto_scomp_alg(tfm)->zbufsize)
+		return -ENOTSUPP;
+	return crypto_scomp_alg(tfm)->zbufsize(tfm, slen, dlen, ctx);
+}
+
 int crypto_init_scomp_ops_async(struct crypto_tfm *tfm);
 struct acomp_req *crypto_acomp_scomp_alloc_ctx(struct acomp_req *req);
 void crypto_acomp_scomp_free_ctx(struct acomp_req *req);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 6eb06101089f..376c056447e7 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -362,6 +362,8 @@ struct compress_alg {
 			    unsigned int slen, u8 *dst, unsigned int *dlen);
 	int (*coa_decompress)(struct crypto_tfm *tfm, const u8 *src,
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
+	int (*coa_zbufsize)(struct crypto_tfm *tfm, unsigned int slen,
+			    unsigned int *dlen);
 };
 
 
@@ -578,6 +580,8 @@ struct compress_tfm {
 	int (*cot_decompress)(struct crypto_tfm *tfm,
 	                      const u8 *src, unsigned int slen,
 	                      u8 *dst, unsigned int *dlen);
+	int (*cot_zbufsize)(struct crypto_tfm *tfm,
+			    unsigned int slen, unsigned int *dlen);
 };
 
 #define crt_ablkcipher	crt_u.ablkcipher
@@ -1660,5 +1664,13 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
 						    src, slen, dst, dlen);
 }
 
+static inline int crypto_comp_zbufsize(struct crypto_comp *tfm,
+				       unsigned int slen,
+				       unsigned int *dlen)
+{
+	return crypto_comp_crt(tfm)->cot_zbufsize(crypto_comp_tfm(tfm),
+						  slen, dlen);
+}
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
2.17.1
