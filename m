From: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Subject: [PATCH v6 3/5] crypto: Change LZ4 modules to work with new LZ4 module version
Date: Fri, 27 Jan 2017 23:02:02 +0100
Message-ID: <1485554524-4844-4-git-send-email-4sschmid@informatik.uni-hamburg.de>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1485554524-4844-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Cc: bongkyu.kim@lge.com, rsalvaterra@gmail.com,
        sergey.senozhatsky@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com,
        Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
To: akpm@linux-foundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:36650 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751864AbdA0WEu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Jan 2017 17:04:50 -0500
In-Reply-To: <1485554524-4844-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch updates the crypto modules using LZ4 compression
to work with the new LZ4 module version.

Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
---
 crypto/lz4.c   | 21 ++++++++-------------
 crypto/lz4hc.c | 21 ++++++++-------------
 2 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index 99c1b2c..40fd2c2 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -66,15 +66,13 @@ static void lz4_exit(struct crypto_tfm *tfm)
 static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
 				 u8 *dst, unsigned int *dlen, void *ctx)
 {
-	size_t tmp_len = *dlen;
-	int err;
+	int out_len = LZ4_compress_default(src, dst,
+		slen, (int)((size_t)dlen), ctx);
 
-	err = lz4_compress(src, slen, dst, &tmp_len, ctx);
-
-	if (err < 0)
+	if (!out_len)
 		return -EINVAL;
 
-	*dlen = tmp_len;
+	*dlen = out_len;
 	return 0;
 }
 
@@ -96,16 +94,13 @@ static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
-	int err;
-	size_t tmp_len = *dlen;
-	size_t __slen = slen;
+	int out_len = LZ4_decompress_safe(src, dst, slen, (int)((size_t)dlen));
 
-	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
-	if (err < 0)
+	if (out_len < 0)
 		return -EINVAL;
 
-	*dlen = tmp_len;
-	return err;
+	*dlen = out_len;
+	return out_len;
 }
 
 static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 75ffc4a..6f16f96 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -65,15 +65,13 @@ static void lz4hc_exit(struct crypto_tfm *tfm)
 static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
 				   u8 *dst, unsigned int *dlen, void *ctx)
 {
-	size_t tmp_len = *dlen;
-	int err;
+	int out_len = LZ4_compress_HC(src, dst, slen,
+		(int)((size_t)dlen), LZ4HC_DEFAULT_CLEVEL, ctx);
 
-	err = lz4hc_compress(src, slen, dst, &tmp_len, ctx);
-
-	if (err < 0)
+	if (out_len == 0)
 		return -EINVAL;
 
-	*dlen = tmp_len;
+	*dlen = out_len;
 	return 0;
 }
 
@@ -97,16 +95,13 @@ static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
 				     u8 *dst, unsigned int *dlen, void *ctx)
 {
-	int err;
-	size_t tmp_len = *dlen;
-	size_t __slen = slen;
+	int out_len = LZ4_decompress_safe(src, dst, slen, (int)((size_t)dlen));
 
-	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
-	if (err < 0)
+	if (out_len < 0)
 		return -EINVAL;
 
-	*dlen = tmp_len;
-	return err;
+	*dlen = out_len;
+	return out_len;
 }
 
 static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
-- 
2.1.4
