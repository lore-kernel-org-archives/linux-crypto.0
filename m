From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 2/4] crypto: omap-sham - remove debug print
Date: Wed, 20 Apr 2011 13:34:56 +0300
Message-ID: <79afb79275170168b230b0a75dea11b0d01510ce.1303295558.git.dmitry.kasatkin@nokia.com>
References: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
References: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index e36032b..50aca41 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -890,8 +890,6 @@ static int omap_sham_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 	struct omap_sham_ctx *tctx = crypto_tfm_ctx(tfm);
 	const char *alg_name = crypto_tfm_alg_name(tfm);
 
-	pr_info("enter\n");
-
 	/* Allocate a fallback and abort if it failed. */
 	tctx->fallback = crypto_alloc_shash(alg_name, 0,
 					    CRYPTO_ALG_NEED_FALLBACK);
-- 
1.7.1

