From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: [PATCH v2 3/4] crypto: Change LZ4 modules to work with new LZ4 module version
Date: Sat,  7 Jan 2017 17:55:44 +0100
Message-ID: <1483808145-18417-4-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1483808145-18417-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, phillip@squashfs.org.uk,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483808145-18417-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch updates the crypto modules using LZ4 compression to work with the
new LZ4 module version.

Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
---
 crypto/lz4.c   | 27 ++++++++++++++-------------
 crypto/lz4hc.c | 25 +++++++++++++------------
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index 99c1b2c..b969e5f 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -66,15 +66,16 @@ static void lz4_exit(struct crypto_tfm *tfm)
 static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
 				 u8 *dst, unsigned int *dlen, void *ctx)
 {
-	size_t tmp_len = *dlen;
-	int err;
+	int out_len;
 
-	err = lz4_compress(src, slen, dst, &tmp_len, ctx);
+	out_len = LZ4_compress_default(src, dst, slen, (int)((size_t)dlen), ctx);
 
-	if (err < 0)
-		return -EINVAL;
+	if (out_len == 0) {
+		// out_len is 0 means an error occured
+			return -EINVAL;
+	}
 
-	*dlen = tmp_len;
+	*dlen = out_len;
 	return 0;
 }
 
@@ -96,16 +97,16 @@ static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
-	int err;
-	size_t tmp_len = *dlen;
-	size_t __slen = slen;
+	int out_len;
 
-	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
-	if (err < 0)
+	out_len = LZ4_decompress_safe(src, dst, slen, (int)((size_t)dlen));
+	if (out_len < 0) {
+		// out_len of less than 0 means an error occured
 		return -EINVAL;
+	}
 
-	*dlen = tmp_len;
-	return err;
+	*dlen = out_len;
+	return out_len;
 }
 
 static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 75ffc4a..bf2ceb7 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -65,15 +65,16 @@ static void lz4hc_exit(struct crypto_tfm *tfm)
 static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
-	size_t tmp_len = *dlen;
-	int err;
+	int out_len;
 
-	err = lz4hc_compress(src, slen, dst, &tmp_len, ctx);
+	out_len = LZ4_compress_HC(src, dst, slen, (int)((size_t)dlen), LZ4HC_DEFAULT_CLEVEL, ctx);
 
-	if (err < 0)
+	if (out_len == 0) {
+		// out_len of 0 -> error
 		return -EINVAL;
+	}
 
-	*dlen = tmp_len;
+	*dlen = out_len;
 	return 0;
 }
 
@@ -97,16 +98,16 @@ static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
 				     u8 *dst, unsigned int *dlen, void *ctx)
 {
-	int err;
-	size_t tmp_len = *dlen;
-	size_t __slen = slen;
+	int out_len;
 
-	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
-	if (err < 0)
+	out_len = LZ4_decompress_safe(src, dst, slen, (int)((size_t)dlen));
+  if (out_len < 0) {
+		// out_len of less than 0 means an error occured
 		return -EINVAL;
+	}
 
-	*dlen = tmp_len;
-	return err;
+	*dlen = out_len;
+	return out_len;
 }
 
 static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
-- 
2.1.4
