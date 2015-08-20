From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 2/8] crypto/lzo: support decompress_noctx
Date: Thu, 20 Aug 2015 15:34:58 +0900
Message-ID: <1440052504-15442-3-git-send-email-iamjoonsoo.kim@lge.com>
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

lzo's decompression doesn't requires any scratch buffer so
it doesn't need tfm context. Hence, it can support
crypto compression noctx API and this patch implements it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/lzo.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/crypto/lzo.c b/crypto/lzo.c
index 9ca516b..f1844dd 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -80,6 +80,22 @@ static int lzo_decompress(struct crypto_tfm *tfm, const u8 *src,
 
 }
 
+static int lzo_decompress_noctx(const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen)
+{
+	int err;
+	size_t tmp_len = *dlen; /* size_t(ulong) <-> uint on 64 bit */
+
+	err = lzo1x_decompress_safe(src, slen, dst, &tmp_len);
+
+	if (err != LZO_E_OK)
+		return -EINVAL;
+
+	*dlen = tmp_len;
+	return 0;
+
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "lzo",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -91,7 +107,7 @@ static struct crypto_alg alg = {
 	.coa_compress 		= lzo_compress,
 	.coa_decompress		= lzo_decompress,
 	.coa_compress_noctx	= NULL,
-	.coa_decompress_noctx	= NULL } }
+	.coa_decompress_noctx	= lzo_decompress_noctx } }
 };
 
 static int __init lzo_mod_init(void)
-- 
1.9.1
