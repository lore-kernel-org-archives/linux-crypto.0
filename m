From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v3 4/9] crypto/lz4hc: support decompress_noctx
Date: Fri, 18 Sep 2015 14:19:19 +0900
Message-ID: <1442553564-3476-5-git-send-email-iamjoonsoo.kim@lge.com>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34084 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbbIRFUA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 01:20:00 -0400
In-Reply-To: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

lz4hc's decompression doesn't requires any scratch buffer so
it doesn't need tfm context. Hence, it can support
crypto compression noctx API and this patch implements it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/lz4hc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 0cb38a7..0797065 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -76,6 +76,12 @@ static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return err;
 }
 
+static int lz4hc_decompress_noctx(const u8 *src, unsigned int slen,
+				  u8 *dst, unsigned int *dlen)
+{
+	return lz4hc_decompress_crypto(NULL, src, slen, dst, dlen);
+}
+
 static struct crypto_alg alg_lz4hc = {
 	.cra_name		= "lz4hc",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -87,7 +93,7 @@ static struct crypto_alg alg_lz4hc = {
 	.cra_u			= { .compress = {
 	.coa_compress		= lz4hc_compress_crypto,
 	.coa_decompress		= lz4hc_decompress_crypto,
-	.coa_decompress_noctx	= NULL } }
+	.coa_decompress_noctx	= lz4hc_decompress_noctx } }
 };
 
 static int __init lz4hc_mod_init(void)
-- 
1.9.1
