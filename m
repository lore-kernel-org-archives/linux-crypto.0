From: Joe Perches <joe@perches.com>
Subject: [PATCH 15/35] drivers/crypto: Convert remaining uses of pr_warning to pr_warn
Date: Thu, 16 Feb 2017 23:11:28 -0800
Message-ID: <df566d61c9ed7b6609a493832dac089040bffaf5.1487314667.git.joe@perches.com>
References: <cover.1487314666.git.joe@perches.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1487314666.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

To enable eventual removal of pr_warning

This makes pr_warn use consistent for drivers/crypto

Prior to this patch, there were 3 uses of pr_warning and
12 uses of pr_warn in drivers/crypto

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/crypto/n2_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index c5aac25a5738..82ab91adfee7 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -365,8 +365,8 @@ static int n2_hash_cra_init(struct crypto_tfm *tfm)
 	fallback_tfm = crypto_alloc_ahash(fallback_driver_name, 0,
 					  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
-		pr_warning("Fallback driver '%s' could not be loaded!\n",
-			   fallback_driver_name);
+		pr_warn("Fallback driver '%s' could not be loaded!\n",
+			fallback_driver_name);
 		err = PTR_ERR(fallback_tfm);
 		goto out;
 	}
@@ -402,16 +402,16 @@ static int n2_hmac_cra_init(struct crypto_tfm *tfm)
 	fallback_tfm = crypto_alloc_ahash(fallback_driver_name, 0,
 					  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
-		pr_warning("Fallback driver '%s' could not be loaded!\n",
-			   fallback_driver_name);
+		pr_warn("Fallback driver '%s' could not be loaded!\n",
+			fallback_driver_name);
 		err = PTR_ERR(fallback_tfm);
 		goto out;
 	}
 
 	child_shash = crypto_alloc_shash(n2alg->child_alg, 0, 0);
 	if (IS_ERR(child_shash)) {
-		pr_warning("Child shash '%s' could not be loaded!\n",
-			   n2alg->child_alg);
+		pr_warn("Child shash '%s' could not be loaded!\n",
+			n2alg->child_alg);
 		err = PTR_ERR(child_shash);
 		goto out_free_fallback;
 	}
-- 
2.10.0.rc2.1.g053435c
