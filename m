From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 5/9] crypto, deflate: Implement zbufsize()
Date: Thu,  2 Aug 2018 14:51:14 -0700
Message-ID: <20180802215118.17752-6-keescook@chromium.org>
References: <20180802215118.17752-1-keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Haren Myneni <haren@us.ibm.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802215118.17752-1-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This implements the worst-case compression size querying interface for
deflate, based on the logic originally used by pstore.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/deflate.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 94ec3b36a8e8..2665af8d49b4 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -277,6 +277,47 @@ static int deflate_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __deflate_decompress(src, slen, dst, dlen, ctx);
 }
 
+static int __deflate_zbufsize(unsigned int slen, unsigned int *dlen)
+{
+	size_t size = slen;
+	size_t cmpr;
+
+	/* Estimated ranges */
+	switch (size) {
+	case 1000 ... 2000:
+		cmpr = 56;
+		break;
+	case 2001 ... 3000:
+		cmpr = 54;
+		break;
+	case 3001 ... 3999:
+		cmpr = 52;
+		break;
+	case 4000 ... 10000:
+		cmpr = 45;
+		break;
+	default:
+		cmpr = 60;
+		break;
+	}
+
+	*dlen = (size * 100) / cmpr;
+
+	return 0;
+}
+
+static int deflate_zbufsize(struct crypto_tfm *tfm, unsigned int slen,
+			    unsigned int *dlen)
+{
+	return __deflate_zbufsize(slen, dlen);
+}
+
+static int deflate_szbufsize(struct crypto_scomp *tfm, unsigned int slen,
+			     unsigned int *dlen, void *ctx)
+{
+	return __deflate_zbufsize(slen, dlen);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "deflate",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -285,8 +326,9 @@ static struct crypto_alg alg = {
 	.cra_init		= deflate_init,
 	.cra_exit		= deflate_exit,
 	.cra_u			= { .compress = {
-	.coa_compress 		= deflate_compress,
-	.coa_decompress  	= deflate_decompress } }
+	.coa_compress		= deflate_compress,
+	.coa_decompress		= deflate_decompress,
+	.coa_zbufsize		= deflate_zbufsize } }
 };
 
 static struct scomp_alg scomp[] = { {
@@ -294,6 +336,7 @@ static struct scomp_alg scomp[] = { {
 	.free_ctx		= deflate_free_ctx,
 	.compress		= deflate_scompress,
 	.decompress		= deflate_sdecompress,
+	.zbufsize		= deflate_szbufsize,
 	.base			= {
 		.cra_name	= "deflate",
 		.cra_driver_name = "deflate-scomp",
@@ -304,6 +347,7 @@ static struct scomp_alg scomp[] = { {
 	.free_ctx		= deflate_free_ctx,
 	.compress		= deflate_scompress,
 	.decompress		= deflate_sdecompress,
+	.zbufsize		= deflate_szbufsize,
 	.base			= {
 		.cra_name	= "zlib-deflate",
 		.cra_driver_name = "zlib-deflate-scomp",
-- 
2.17.1
