From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 6/9] crypto, zstd: Implement zbufsize()
Date: Thu,  2 Aug 2018 14:51:15 -0700
Message-ID: <20180802215118.17752-7-keescook@chromium.org>
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
zstd, based on the logic originally used by pstore.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/zstd.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 9a76b3ed8b8b..ce8efd40f27f 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -212,6 +212,24 @@ static int zstd_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 	return __zstd_decompress(src, slen, dst, dlen, ctx);
 }
 
+static int __zstd_zbufsize(unsigned int slen, unsigned int *dlen)
+{
+	*dlen = ZSTD_compressBound(slen);
+	return 0;
+}
+
+static int zstd_zbufsize(struct crypto_tfm *tfm, unsigned int slen,
+			 unsigned int *dlen)
+{
+	return __zstd_zbufsize(slen, dlen);
+}
+
+static int zstd_szbufsize(struct crypto_scomp *tfm, unsigned int slen,
+			  unsigned int *dlen, void *ctx)
+{
+	return __zstd_zbufsize(slen, dlen);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "zstd",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -221,7 +239,8 @@ static struct crypto_alg alg = {
 	.cra_exit		= zstd_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= zstd_compress,
-	.coa_decompress		= zstd_decompress } }
+	.coa_decompress		= zstd_decompress,
+	.coa_zbufsize		= zstd_zbufsize } }
 };
 
 static struct scomp_alg scomp = {
@@ -229,6 +248,7 @@ static struct scomp_alg scomp = {
 	.free_ctx		= zstd_free_ctx,
 	.compress		= zstd_scompress,
 	.decompress		= zstd_sdecompress,
+	.zbufsize		= zstd_szbufsize,
 	.base			= {
 		.cra_name	= "zstd",
 		.cra_driver_name = "zstd-scomp",
-- 
2.17.1
