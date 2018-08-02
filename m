From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 8/9] crypto, lz4hc: Implement zbufsize()
Date: Thu,  2 Aug 2018 14:51:17 -0700
Message-ID: <20180802215118.17752-9-keescook@chromium.org>
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
lz4hc, based on the logic originally used by pstore.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/lz4hc.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 2be14f054daf..cf6f38a1c35b 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -118,6 +118,24 @@ static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return __lz4hc_decompress_crypto(src, slen, dst, dlen, NULL);
 }
 
+static int __lz4hc_zbufsize_crypto(unsigned int slen, unsigned int *dlen)
+{
+	*dlen = LZ4_compressBound(slen);
+	return 0;
+}
+
+static int lz4hc_szbufsize(struct crypto_scomp *tfm, unsigned int slen,
+			   unsigned int *dlen, void *ctx)
+{
+	return __lz4hc_zbufsize_crypto(slen, dlen);
+}
+
+static int lz4hc_zbufsize_crypto(struct crypto_tfm *tfm, unsigned int slen,
+				 unsigned int *dlen)
+{
+	return __lz4hc_zbufsize_crypto(slen, dlen);
+}
+
 static struct crypto_alg alg_lz4hc = {
 	.cra_name		= "lz4hc",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -128,7 +146,8 @@ static struct crypto_alg alg_lz4hc = {
 	.cra_exit		= lz4hc_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lz4hc_compress_crypto,
-	.coa_decompress		= lz4hc_decompress_crypto } }
+	.coa_decompress		= lz4hc_decompress_crypto,
+	.coa_zbufsize		= lz4hc_zbufsize_crypto } }
 };
 
 static struct scomp_alg scomp = {
@@ -136,6 +155,7 @@ static struct scomp_alg scomp = {
 	.free_ctx		= lz4hc_free_ctx,
 	.compress		= lz4hc_scompress,
 	.decompress		= lz4hc_sdecompress,
+	.zbufsize		= lz4hc_szbufsize,
 	.base			= {
 		.cra_name	= "lz4hc",
 		.cra_driver_name = "lz4hc-scomp",
-- 
2.17.1
