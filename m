From: Marek Vasut <marex@denx.de>
Subject: [PATCH 3/7] crypto: cesa: Don't use tfm->__crt_alg->cra_name directly
Date: Wed, 14 May 2014 11:40:59 +0200
Message-ID: <1400060463-11644-3-git-send-email-marex@denx.de>
References: <1400060463-11644-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:51812 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbaENJlH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:41:07 -0400
In-Reply-To: <1400060463-11644-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/crypto/mv_cesa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

NOTE: I didn't compile-test those, but the change should not break anything.
      If possible, please test on relevant hardware.

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 8d1e6f8..1549db7 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -843,7 +843,7 @@ static int mv_hash_setkey(struct crypto_ahash *tfm, const u8 * key,
 static int mv_cra_hash_init(struct crypto_tfm *tfm, const char *base_hash_name,
 			    enum hash_op op, int count_add)
 {
-	const char *fallback_driver_name = tfm->__crt_alg->cra_name;
+	const char *fallback_driver_name = crypto_tfm_alg_name(tfm);
 	struct mv_tfm_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_shash *fallback_tfm = NULL;
 	struct crypto_shash *base_hash = NULL;
-- 
2.0.0.rc0
