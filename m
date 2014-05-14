From: Marek Vasut <marex@denx.de>
Subject: [PATCH 7/7] crypto: sahara: Don't use tfm->__crt_alg->cra_name directly
Date: Wed, 14 May 2014 11:41:03 +0200
Message-ID: <1400060463-11644-7-git-send-email-marex@denx.de>
References: <1400060463-11644-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:49124 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaENJlH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:41:07 -0400
In-Reply-To: <1400060463-11644-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/crypto/sahara.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

NOTE: I didn't compile-test those, but the change should not break anything.
      If possible, please test on relevant hardware.

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 07a5987..164e1ec 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -728,7 +728,7 @@ static int sahara_aes_cbc_decrypt(struct ablkcipher_request *req)
 
 static int sahara_aes_cra_init(struct crypto_tfm *tfm)
 {
-	const char *name = tfm->__crt_alg->cra_name;
+	const char *name = crypto_tfm_alg_name(tfm);
 	struct sahara_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	ctx->fallback = crypto_alloc_ablkcipher(name, 0,
-- 
2.0.0.rc0
