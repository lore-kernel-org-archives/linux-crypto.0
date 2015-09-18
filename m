From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v3 2/9] crypto/lzo: support decompress_noctx
Date: Fri, 18 Sep 2015 14:19:17 +0900
Message-ID: <1442553564-3476-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

lzo's decompression doesn't requires any scratch buffer so
it doesn't need tfm context. Hence, it can support
crypto compression noctx API and this patch implements it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/lzo.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/lzo.c b/crypto/lzo.c
index ec0f7b3..3cc0ce7 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -80,6 +80,12 @@ static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
 
 }
 
+static int lzo_decompress_noctx(const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen)
+{
+	return lzo_decompress(NULL, src, slen, dst, dlen);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "lzo",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -90,7 +96,7 @@ static struct crypto_alg alg = {
 	.cra_u			= { .compress = {
 	.coa_compress 		= lzo_compress,
 	.coa_decompress		= lzo_decompress,
-	.coa_decompress_noctx	= NULL } }
+	.coa_decompress_noctx	= lzo_decompress_noctx } }
 };
 
 static int __init lzo_mod_init(void)
-- 
1.9.1
