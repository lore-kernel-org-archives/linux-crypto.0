From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH RFC 6/7] crypto/compress: add algorithm type specific flag, DECOMP_NOCTX
Date: Mon,  4 Jan 2016 13:46:57 +0900
Message-ID: <1451882819-2810-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451882819-2810-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/testmgr.c          | 2 ++
 include/crypto/compress.h | 8 ++++++++
 include/linux/crypto.h    | 6 ++++++
 3 files changed, 16 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index bd0c639..acd7428 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1289,6 +1289,8 @@ static int test_comp(struct crypto_tfm *tfm, void *ctx, int type,
 			break;
 
 		case 1:
+			if (crypto_scomp_decomp_noctx(crypto_scomp_cast(tfm)))
+				ctx = NULL;
 			ret = crypto_scomp_decompress(crypto_scomp_cast(tfm),
 						dtemplate[i].input, ilen,
 						result, &dlen, ctx);
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index f1e91c5..21c698e 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -2,6 +2,8 @@
 #define _CRYPTO_COMPRESS_H
 #include <linux/crypto.h>
 
+#define CRYPTO_ALG_SCOMPRESS_DECOMP_NOCTX CRYPTO_ALG_PRIVATE
+
 struct crypto_scomp {
 	struct crypto_tfm base;
 };
@@ -71,6 +73,12 @@ static inline int crypto_scomp_decompress(struct crypto_scomp *tfm,
 						dst, dlen, ctx);
 }
 
+static inline bool crypto_scomp_decomp_noctx(struct crypto_scomp *tfm)
+{
+	return crypto_scomp_tfm(tfm)->__crt_alg->cra_flags &
+			CRYPTO_ALG_SCOMPRESS_DECOMP_NOCTX;
+}
+
 extern int crypto_register_scomp(struct scomp_alg *alg);
 extern int crypto_unregister_scomp(struct scomp_alg *alg);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 86baa61..a8a522c 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -104,6 +104,12 @@
 #define CRYPTO_ALG_INTERNAL		0x00002000
 
 /*
+ * Use this flag as type specific one. For example, it would be used
+ * to check if context is needed or not in CRYPTO_ALG_TYPE_SCOMPRESS.
+ */
+#define CRYPTO_ALG_PRIVATE		0x00004000
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
-- 
1.9.1
