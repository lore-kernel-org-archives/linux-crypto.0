From: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH v2 1/2] crypto: cbc - Propagate NEED_FALLBACK bit
Date: Mon, 27 Feb 2017 09:38:25 -0300
Message-ID: <1488199106-16061-2-git-send-email-marcelo.cerri@canonical.com>
References: <1488199106-16061-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488199106-16061-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When requesting a fallback algorithm, we should propagate the
NEED_FALLBACK bit when search for the underlying algorithm.

This will prevents drivers from allocating unnecessary fallbacks that
are never called. For instance, currently the vmx-crypto driver will use
the following chain of calls when calling the fallback implementation:

p8_aes_cbc -> cbc(p8_aes) -> aes-generic

However p8_aes will always delegate its calls to aes-generic. With this
patch, p8_aes_cbc will be able to use cbc(aes-generic) directly as its
fallback. The same applies to aes_s390.

Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
---
 crypto/cbc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/crypto/cbc.c b/crypto/cbc.c
index bc160a3..b761b1f 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <crypto/algapi.h>
 #include <crypto/cbc.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
@@ -108,8 +109,10 @@ static void crypto_cbc_free(struct skcipher_instance *inst)
 static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
 	struct skcipher_instance *inst;
+	struct crypto_attr_type *algt;
 	struct crypto_spawn *spawn;
 	struct crypto_alg *alg;
+	u32 mask;
 	int err;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER);
@@ -120,8 +123,16 @@ static int crypto_cbc_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (!inst)
 		return -ENOMEM;
 
-	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
-				  CRYPTO_ALG_TYPE_MASK);
+	algt = crypto_get_attr_type(tb);
+	err = PTR_ERR(algt);
+	if (IS_ERR(algt))
+		goto err_free_inst;
+
+	mask = CRYPTO_ALG_TYPE_MASK |
+		crypto_requires_off(algt->type, algt->mask,
+				    CRYPTO_ALG_NEED_FALLBACK);
+
+	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER, mask);
 	err = PTR_ERR(alg);
 	if (IS_ERR(alg))
 		goto err_free_inst;
-- 
2.7.4
