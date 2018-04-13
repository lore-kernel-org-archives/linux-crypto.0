From: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Subject: [PATCH v7 5/5] crypto: add flag for unstable encoding
Date: Fri, 13 Apr 2018 17:48:40 +0200
Message-ID: <20180413154840.5901-6-4bwarnke@informatik.uni-hamburg.de>
References: <20180413154840.5901-1-4bwarnke@informatik.uni-hamburg.de>
Cc: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        minchan@kernel.org, sergey.senozhatsky.work@gmail.com,
        ngupta@vflare.org, pombredanne@nexb.com, ebiggers3@gmail.com,
        smueller@chronox.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413154840.5901-1-4bwarnke@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The data-format of zBeWalgo, and some other algorithms is unstable. To
identify such unstable algorithms this patch adds a new flag to the
crypto-api.

Signed-off-by: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
---
 crypto/zbewalgo.c      | 2 +-
 include/linux/crypto.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/zbewalgo.c b/crypto/zbewalgo.c
index 9db0d43b..e57b5ced 100644
--- a/crypto/zbewalgo.c
+++ b/crypto/zbewalgo.c
@@ -134,7 +134,7 @@ static int zbewalgo_decompress_crypto_unsafe(struct crypto_tfm *tfm,
 
 static struct crypto_alg crypto_alg_zbewalgo = {
 	.cra_name = "zbewalgo",
-	.cra_flags = CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_flags = CRYPTO_ALG_TYPE_COMPRESS | CRYPTO_ALG_UNSTABLE_ENCODING,
 	.cra_ctxsize = sizeof(struct zbewalgo_ctx),
 	.cra_module = THIS_MODULE,
 	.cra_init = zbewalgo_init,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 6bfb1aea..2228dd08 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -112,6 +112,12 @@
  */
 #define CRYPTO_ALG_OPTIONAL_KEY		0x00004000
 
+/*
+ * Set if the algorithm is new and it is likely that the encoding may
+ * change in near future
+ */
+#define CRYPTO_ALG_UNSTABLE_ENCODING	0x00008000
+
 /*
  * Transform masks and values (for crt_flags).
  */
-- 
2.14.1
