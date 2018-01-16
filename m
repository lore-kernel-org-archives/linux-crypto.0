From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [RFT PATCH] crypto: ahash.c: Require export/import in ahash
Date: Tue, 16 Jan 2018 11:35:44 +0100
Message-ID: <2a8e710f-9d1c-726b-3355-5d671e04cb68@partner.samsung.com>
References: <CGME20180116103545eucas1p230af34b97f903f8dc7db5e634297f4f8@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Export and import were optional in async hash. As drivers were rewritten,
they become mandatory now, so correct init of ahash transformation.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
Tested with crypto run-time self test on Odroid-U3 with Exynos 4412 CPU,
with insmod s5p-sss.ko
Please test with other crypto hash drivers.

 crypto/ahash.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3a35d67de7d9..7a8906d5af53 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -434,16 +434,6 @@ static int ahash_def_finup(struct ahash_request *req)
 	return ahash_def_finup_finish1(req, err);
 }
 
-static int ahash_no_export(struct ahash_request *req, void *out)
-{
-	return -ENOSYS;
-}
-
-static int ahash_no_import(struct ahash_request *req, const void *in)
-{
-	return -ENOSYS;
-}
-
 static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
@@ -451,8 +441,8 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 
 	hash->setkey = ahash_nosetkey;
 	hash->has_setkey = false;
-	hash->export = ahash_no_export;
-	hash->import = ahash_no_import;
+	hash->export = alg->export;
+	hash->import = alg->import;
 
 	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
 		return crypto_init_shash_ops_async(tfm);
@@ -467,10 +457,6 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 		hash->setkey = alg->setkey;
 		hash->has_setkey = true;
 	}
-	if (alg->export)
-		hash->export = alg->export;
-	if (alg->import)
-		hash->import = alg->import;
 
 	return 0;
 }
-- 
2.15.0
