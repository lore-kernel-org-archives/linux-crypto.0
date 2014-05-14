From: Marek Vasut <marex@denx.de>
Subject: [PATCH 4/7] crypto: dcp: Don't use tfm->__crt_alg->cra_name directly
Date: Wed, 14 May 2014 11:41:00 +0200
Message-ID: <1400060463-11644-4-git-send-email-marex@denx.de>
References: <1400060463-11644-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:41004 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaENJlH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:41:07 -0400
In-Reply-To: <1400060463-11644-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/crypto/mxs-dcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

NOTE: I didn't compile-test those, but the change should not break anything.
      If possible, please test on relevant hardware.

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 7bbe0ab..9017818 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -482,7 +482,7 @@ static int mxs_dcp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 
 static int mxs_dcp_aes_fallback_init(struct crypto_tfm *tfm)
 {
-	const char *name = tfm->__crt_alg->cra_name;
+	const char *name = crypto_tfm_alg_name(tfm);
 	const uint32_t flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK;
 	struct dcp_async_ctx *actx = crypto_tfm_ctx(tfm);
 	struct crypto_ablkcipher *blk;
-- 
2.0.0.rc0
