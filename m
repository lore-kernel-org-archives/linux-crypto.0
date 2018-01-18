From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH 5/5] crypto: ahash.c: Require export/import in ahash
Date: Thu, 18 Jan 2018 19:34:04 +0100
Message-ID: <20180118183404.12583-6-k.konieczny@partner.samsung.com>
References: <20180118183404.12583-1-k.konieczny@partner.samsung.com>
        <CGME20180118183441eucas1p2ee3f046a594945299ea7b75ffb13e2ca@eucas1p2.samsung.com>
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Vasut <marex@denx.de>,
        Sonic Zhang <sonic.zhang@analog.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Joakim Bech <joakim.bech@linaro.org>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20180118183404.12583-1-k.konieczny@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Export and import are mandatory in async hash. As drivers were
rewritten, drop empty wrappers and correct init of ahash transformation.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 crypto/ahash.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 3a35d67de7d9..c3cce508c1d4 100644
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
@@ -451,8 +441,6 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 
 	hash->setkey = ahash_nosetkey;
 	hash->has_setkey = false;
-	hash->export = ahash_no_export;
-	hash->import = ahash_no_import;
 
 	if (tfm->__crt_alg->cra_type != &crypto_ahash_type)
 		return crypto_init_shash_ops_async(tfm);
@@ -462,15 +450,13 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	hash->final = alg->final;
 	hash->finup = alg->finup ?: ahash_def_finup;
 	hash->digest = alg->digest;
+	hash->export = alg->export;
+	hash->import = alg->import;
 
 	if (alg->setkey) {
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
