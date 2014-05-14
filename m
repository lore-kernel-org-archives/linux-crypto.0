From: Marek Vasut <marex@denx.de>
Subject: [PATCH 5/7] crypto: n2: Don't use tfm->__crt_alg->cra_name directly
Date: Wed, 14 May 2014 11:41:01 +0200
Message-ID: <1400060463-11644-5-git-send-email-marex@denx.de>
References: <1400060463-11644-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:57387 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaENJlH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:41:07 -0400
In-Reply-To: <1400060463-11644-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/crypto/n2_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

NOTE: I didn't compile-test those, but the change should not break anything.
      If possible, please test on relevant hardware.

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index e1f0ab4..7263c10 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -356,7 +356,7 @@ static int n2_hash_async_finup(struct ahash_request *req)
 
 static int n2_hash_cra_init(struct crypto_tfm *tfm)
 {
-	const char *fallback_driver_name = tfm->__crt_alg->cra_name;
+	const char *fallback_driver_name = crypto_tfm_alg_name(tfm);
 	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
 	struct n2_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct crypto_ahash *fallback_tfm;
@@ -391,7 +391,7 @@ static void n2_hash_cra_exit(struct crypto_tfm *tfm)
 
 static int n2_hmac_cra_init(struct crypto_tfm *tfm)
 {
-	const char *fallback_driver_name = tfm->__crt_alg->cra_name;
+	const char *fallback_driver_name = crypto_tfm_alg_name(tfm);
 	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
 	struct n2_hmac_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct n2_hmac_alg *n2alg = n2_hmac_alg(tfm);
-- 
2.0.0.rc0
