From: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Subject: [PATCH v6 5/5] crypto: add flag for unstable encoding
Date: Mon, 26 Mar 2018 10:31:45 +0200
Message-ID: <5B389AE0-162B-4E42-98CA-776F9900A625@informatik.uni-hamburg.de>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, minchan@kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        ngupta@vflare.org, Philippe Ombredanne <pombredanne@nexb.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Stephan Mueller <smueller@chronox.de>
To: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
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
index 9db0d43be..e57b5ced5 100644
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
index 63420dac0..372893569 100644
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
