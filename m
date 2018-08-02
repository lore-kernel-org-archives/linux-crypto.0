From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/9] crypto, 842: implement zbufsize()
Date: Thu,  2 Aug 2018 14:51:11 -0700
Message-ID: <20180802215118.17752-3-keescook@chromium.org>
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
842, based on the logic originally used by pstore.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/842.c          | 17 ++++++++++++++++-
 include/linux/sw842.h |  9 +++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/crypto/842.c b/crypto/842.c
index bc26dc942821..c6d9ad6512f8 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -101,6 +101,19 @@ static int crypto842_sdecompress(struct crypto_scomp *tfm,
 	return sw842_decompress(src, slen, dst, dlen);
 }
 
+static int crypto842_zbufsize(struct crypto_tfm *tfm,
+			      unsigned int slen, unsigned int *dlen)
+{
+	return sw842_zbufsize(slen, dlen);
+}
+
+static int crypto842_szbufsize(struct crypto_scomp *tfm,
+			       unsigned int slen, unsigned int *dlen,
+			       void *ctx)
+{
+	return sw842_zbufsize(slen, dlen);
+}
+
 static struct crypto_alg alg = {
 	.cra_name		= "842",
 	.cra_driver_name	= "842-generic",
@@ -112,7 +125,8 @@ static struct crypto_alg alg = {
 	.cra_exit		= crypto842_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= crypto842_compress,
-	.coa_decompress		= crypto842_decompress } }
+	.coa_decompress		= crypto842_decompress,
+	.coa_zbufsize		= crypto842_zbufsize } }
 };
 
 static struct scomp_alg scomp = {
@@ -120,6 +134,7 @@ static struct scomp_alg scomp = {
 	.free_ctx		= crypto842_free_ctx,
 	.compress		= crypto842_scompress,
 	.decompress		= crypto842_sdecompress,
+	.zbufsize		= crypto842_szbufsize,
 	.base			= {
 		.cra_name	= "842",
 		.cra_driver_name = "842-scomp",
diff --git a/include/linux/sw842.h b/include/linux/sw842.h
index 3e29f5dcc62b..9760554beb26 100644
--- a/include/linux/sw842.h
+++ b/include/linux/sw842.h
@@ -10,4 +10,13 @@ int sw842_compress(const u8 *src, unsigned int srclen,
 int sw842_decompress(const u8 *src, unsigned int srclen,
 		     u8 *dst, unsigned int *destlen);
 
+static inline int sw842_zbufsize(unsigned int srclen,
+				 unsigned int *destlen)
+{
+	/* Worst case is uncompressed sized. */
+	*destlen = srclen;
+
+	return 0;
+}
+
 #endif
-- 
2.17.1
