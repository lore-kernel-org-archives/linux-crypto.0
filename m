From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 4/9] crypto, lzo: Implement zbufsize()
Date: Thu,  2 Aug 2018 14:51:13 -0700
Message-ID: <20180802215118.17752-5-keescook@chromium.org>
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
lzo, based on the logic originally used by pstore.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/lzo.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/crypto/lzo.c b/crypto/lzo.c
index 218567d717d6..ea18f62c5247 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -120,6 +120,24 @@ static int lzo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __lzo_decompress(src, slen, dst, dlen);
 }
 
+static int __lzo_zbufsize(unsigned int slen, unsigned int *dlen)
+{
+	*dlen = lzo1x_worst_compress(slen);
+	return 0;
+}
+
+static int lzo_zbufsize(struct crypto_tfm *tfm, unsigned int slen,
+			unsigned int *dlen)
+{
+	return __lzo_zbufsize(slen, dlen);
+}
+
+static int lzo_szbufsize(struct crypto_scomp *tfm, unsigned int slen,
+			 unsigned int *dlen, void *ctx)
+{
+	return __lzo_zbufsize(slen, dlen);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "lzo",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -129,7 +147,8 @@ static struct crypto_alg alg = {
 	.cra_exit		= lzo_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lzo_compress,
-	.coa_decompress		= lzo_decompress } }
+	.coa_decompress		= lzo_decompress,
+	.coa_zbufsize		= lzo_zbufsize } }
 };
 
 static struct scomp_alg scomp = {
@@ -137,6 +156,7 @@ static struct scomp_alg scomp = {
 	.free_ctx		= lzo_free_ctx,
 	.compress		= lzo_scompress,
 	.decompress		= lzo_sdecompress,
+	.zbufsize		= lzo_szbufsize,
 	.base			= {
 		.cra_name	= "lzo",
 		.cra_driver_name = "lzo-scomp",
-- 
2.17.1
