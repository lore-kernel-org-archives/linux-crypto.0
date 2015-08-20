From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 5/8] crypto/842: support decompress_noctx
Date: Thu, 20 Aug 2015 15:35:01 +0900
Message-ID: <1440052504-15442-6-git-send-email-iamjoonsoo.kim@lge.com>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

842's decompression doesn't requires any scratch buffer so
it doesn't need tfm context. Hence, it can support
crypto compression noctx API and this patch implements it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/842.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/crypto/842.c b/crypto/842.c
index b6503ea..9acb595 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -52,6 +52,12 @@ static int crypto842_decompress(struct crypto_tfm *tfm,
 	return sw842_decompress(src, slen, dst, dlen);
 }
 
+static int crypto842_decompress_noctx(const u8 *src, unsigned int slen,
+				      u8 *dst, unsigned int *dlen)
+{
+	return sw842_decompress(src, slen, dst, dlen);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "842",
 	.cra_driver_name	= "842-generic",
@@ -63,7 +69,7 @@ static struct crypto_alg alg = {
 	.coa_compress		= crypto842_compress,
 	.coa_decompress		= crypto842_decompress,
 	.coa_compress_noctx	= NULL,
-	.coa_decompress_noctx	= NULL } }
+	.coa_decompress_noctx	= crypto842_decompress_noctx } }
 };
 
 static int __init crypto842_mod_init(void)
-- 
1.9.1
