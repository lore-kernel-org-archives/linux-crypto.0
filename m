From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH 2/5] crypto: n2_core: Add empty hash export and import
Date: Thu, 18 Jan 2018 19:34:01 +0100
Message-ID: <20180118183404.12583-3-k.konieczny@partner.samsung.com>
References: <20180118183404.12583-1-k.konieczny@partner.samsung.com>
        <CGME20180118183439eucas1p26bfb3043619ddcbc25474ac98e5638ff@eucas1p2.samsung.com>
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

Crypto framework requires export/import in async hash. If driver do not
implement them, wrapper functions in framework will be used, and it will
cause error during ahash alg registration (unless one disables crypto
internal tests). To make change in framework and expose this requirement,
I will remove wrappers from crypto/ahash.c , but this can broke code which
depends on them. Add empty hash export and import, with the same behaviour
as in framework and expose this directly in driver. This can also prevent
OOPS when config option in Cryptographic API 'Disable run-time self tests'
will be enabled.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 drivers/crypto/n2_core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 662e709812cc..80e9c842aad4 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -359,6 +359,16 @@ static int n2_hash_async_finup(struct ahash_request *req)
 	return crypto_ahash_finup(&rctx->fallback_req);
 }
 
+static int n2_hash_async_noimport(struct ahash_request *req, const void *in)
+{
+	return -ENOSYS;
+}
+
+static int n2_hash_async_noexport(struct ahash_request *req, void *out)
+{
+	return -ENOSYS;
+}
+
 static int n2_hash_cra_init(struct crypto_tfm *tfm)
 {
 	const char *fallback_driver_name = crypto_tfm_alg_name(tfm);
@@ -1467,6 +1477,8 @@ static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 	ahash->final = n2_hash_async_final;
 	ahash->finup = n2_hash_async_finup;
 	ahash->digest = n2_hash_async_digest;
+	ahash->export = n2_hash_async_noexport;
+	ahash->import = n2_hash_async_noimport;
 
 	halg = &ahash->halg;
 	halg->digestsize = tmpl->digest_size;
-- 
2.15.0
