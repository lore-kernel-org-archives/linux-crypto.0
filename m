From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 1/7] crypto: talitos - fix bad kfree
Date: Mon, 12 Dec 2011 14:59:10 -0600
Message-ID: <1323723556-7100-2-git-send-email-kim.phillips@freescale.com>
References: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:8449 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753965Ab1LLVAe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Dec 2011 16:00:34 -0500
In-Reply-To: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix a kfree to an invalid address which causes an oops when running
on SEC v2.0 h/w (introduced in commit 702331b "crypto: talitos - add
hmac algorithms").

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 230509e..d376cc7 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2626,8 +2626,10 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		alg = &t_alg->algt.alg.hash.halg.base;
 		alg->cra_init = talitos_cra_init_ahash;
 		if (!(priv->features & TALITOS_FTR_HMAC_OK) &&
-		    !strncmp(alg->cra_name, "hmac", 4))
+		    !strncmp(alg->cra_name, "hmac", 4)) {
+			kfree(t_alg);
 			return ERR_PTR(-ENOTSUPP);
+		}
 		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
 		    (!strcmp(alg->cra_name, "sha224") ||
 		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
@@ -2835,10 +2837,8 @@ static int talitos_probe(struct platform_device *ofdev)
 			t_alg = talitos_alg_alloc(dev, &driver_algs[i]);
 			if (IS_ERR(t_alg)) {
 				err = PTR_ERR(t_alg);
-				if (err == -ENOTSUPP) {
-					kfree(t_alg);
+				if (err == -ENOTSUPP)
 					continue;
-				}
 				goto err_out;
 			}
 
-- 
1.7.8
