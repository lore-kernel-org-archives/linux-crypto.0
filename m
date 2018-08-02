From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 7/9] crypto, lz4: Implement zbufsize()
Date: Thu,  2 Aug 2018 14:51:16 -0700
Message-ID: <20180802215118.17752-8-keescook@chromium.org>
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
lz4, based on the logic originally used by pstore.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/lz4.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/crypto/lz4.c b/crypto/lz4.c
index 2ce2660d3519..42003d080967 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -117,6 +117,24 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
 }
 
+static int __lz4_zbufsize_crypto(unsigned int slen, unsigned int *dlen)
+{
+	*dlen = LZ4_compressBound(slen);
+	return 0;
+}
+
+static int lz4_szbufsize(struct crypto_scomp *tfm, unsigned int slen,
+			 unsigned int *dlen, void *ctx)
+{
+	return __lz4_zbufsize_crypto(slen, dlen);
+}
+
+static int lz4_zbufsize_crypto(struct crypto_tfm *tfm, unsigned int slen,
+			       unsigned int *dlen)
+{
+	return __lz4_zbufsize_crypto(slen, dlen);
+}
+
 static struct crypto_alg alg_lz4 = {
 	.cra_name		= "lz4",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -127,7 +145,8 @@ static struct crypto_alg alg_lz4 = {
 	.cra_exit		= lz4_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lz4_compress_crypto,
-	.coa_decompress		= lz4_decompress_crypto } }
+	.coa_decompress		= lz4_decompress_crypto,
+	.coa_zbufsize		= lz4_zbufsize_crypto } }
 };
 
 static struct scomp_alg scomp = {
@@ -135,6 +154,7 @@ static struct scomp_alg scomp = {
 	.free_ctx		= lz4_free_ctx,
 	.compress		= lz4_scompress,
 	.decompress		= lz4_sdecompress,
+	.zbufsize		= lz4_szbufsize,
 	.base			= {
 		.cra_name	= "lz4",
 		.cra_driver_name = "lz4-scomp",
-- 
2.17.1
