From: Marek Vasut <marex@denx.de>
Subject: [PATCH 6/7] crypto: padlock: Don't use tfm->__crt_alg->cra_name directly
Date: Wed, 14 May 2014 11:41:02 +0200
Message-ID: <1400060463-11644-6-git-send-email-marex@denx.de>
References: <1400060463-11644-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:35077 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbaENJlJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:41:09 -0400
In-Reply-To: <1400060463-11644-1-git-send-email-marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/crypto/padlock-sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

NOTE: I didn't compile-test those, but the change should not break anything.
      If possible, please test on relevant hardware.

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index 9266c0e..bace885 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -211,7 +211,7 @@ static int padlock_sha256_final(struct shash_desc *desc, u8 *out)
 static int padlock_cra_init(struct crypto_tfm *tfm)
 {
 	struct crypto_shash *hash = __crypto_shash_cast(tfm);
-	const char *fallback_driver_name = tfm->__crt_alg->cra_name;
+	const char *fallback_driver_name = crypto_tfm_alg_name(tfm);
 	struct padlock_sha_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_shash *fallback_tfm;
 	int err = -ENOMEM;
-- 
2.0.0.rc0
