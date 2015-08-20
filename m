From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 4/8] crypto/lz4hc: support decompress_noctx
Date: Thu, 20 Aug 2015 15:35:00 +0900
Message-ID: <1440052504-15442-5-git-send-email-iamjoonsoo.kim@lge.com>
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

lz4hc's decompression doesn't requires any scratch buffer so
it doesn't need tfm context. Hence, it can support
crypto compression noctx API and this patch implements it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/lz4hc.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index bcf0baa..a529620 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -76,6 +76,21 @@ static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return err;
 }
 
+static int lz4hc_decompress_noctx(const u8 *src, unsigned int slen,
+				  u8 *dst, unsigned int *dlen)
+{
+	int err;
+	size_t tmp_len = *dlen;
+	size_t __slen = slen;
+
+	err = lz4_decompress_unknownoutputsize(src, __slen, dst, &tmp_len);
+	if (err < 0)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return err;
+}
+
 static struct crypto_alg alg_lz4hc = {
 	.cra_name		= "lz4hc",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -88,7 +103,7 @@ static struct crypto_alg alg_lz4hc = {
 	.coa_compress		= lz4hc_compress_crypto,
 	.coa_decompress		= lz4hc_decompress_crypto,
 	.coa_compress_noctx	= NULL,
-	.coa_decompress_noctx	= NULL } }
+	.coa_decompress_noctx	= lz4hc_decompress_noctx } }
 };
 
 static int __init lz4hc_mod_init(void)
-- 
1.9.1
