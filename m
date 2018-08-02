From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/9] crypto, null: Implement zbufsize()
Date: Thu,  2 Aug 2018 14:51:12 -0700
Message-ID: <20180802215118.17752-4-keescook@chromium.org>
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
the "null" compression implementation (i.e. no change in size).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/crypto_null.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 20ff2c746e0b..d1b6107f8443 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -39,6 +39,13 @@ static int null_compress(struct crypto_tfm *tfm, const u8 *src,
 	return 0;
 }
 
+static int null_zbufsize(struct crypto_tfm *tfm, unsigned int slen,
+			 unsigned int *dlen)
+{
+	*dlen = slen;
+	return 0;
+}
+
 static int null_init(struct shash_desc *desc)
 {
 	return 0;
@@ -146,7 +153,8 @@ static struct crypto_alg null_algs[3] = { {
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .compress = {
 	.coa_compress		=	null_compress,
-	.coa_decompress		=	null_compress } }
+	.coa_decompress		=	null_compress,
+	.coa_zbufsize		=	null_zbufsize } }
 } };
 
 MODULE_ALIAS_CRYPTO("compress_null");
-- 
2.17.1
