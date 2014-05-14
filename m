From: Marek Vasut <marex@denx.de>
Subject: [PATCH 2/7] crypto: ccp: Don't use tfm->__crt_alg->cra_name directly
Date: Wed, 14 May 2014 11:40:58 +0200
Message-ID: <1400060463-11644-2-git-send-email-marex@denx.de>
References: <1400060463-11644-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:57283 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaENJlJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:41:09 -0400
In-Reply-To: <1400060463-11644-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

NOTE: I didn't compile-test those, but the change should not break anything.
      If possible, please test on relevant hardware.

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index 0237ab5..0cc5594 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -191,12 +191,12 @@ static int ccp_aes_xts_cra_init(struct crypto_tfm *tfm)
 	ctx->complete = ccp_aes_xts_complete;
 	ctx->u.aes.key_len = 0;
 
-	fallback_tfm = crypto_alloc_ablkcipher(tfm->__crt_alg->cra_name, 0,
+	fallback_tfm = crypto_alloc_ablkcipher(crypto_tfm_alg_name(tfm), 0,
 					       CRYPTO_ALG_ASYNC |
 					       CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(fallback_tfm)) {
 		pr_warn("could not load fallback driver %s\n",
-			tfm->__crt_alg->cra_name);
+			crypto_tfm_alg_name(tfm));
 		return PTR_ERR(fallback_tfm);
 	}
 	ctx->u.aes.tfm_ablkcipher = fallback_tfm;
-- 
2.0.0.rc0
