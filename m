From: Marek Vasut <marex@denx.de>
Subject: [PATCH 1/7] crypto: geode: Don't use tfm->__crt_alg->cra_name directly
Date: Wed, 14 May 2014 11:40:57 +0200
Message-ID: <1400060463-11644-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:60237 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaENJlG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:41:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use a standard accessor instead of directly digging into a structure.

Signed-off-by: Marek Vasut <marex@denx.de>
---
 drivers/crypto/geode-aes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

NOTE: I didn't compile-test those, but the change should not break anything.
      If possible, please test on relevant hardware.

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 8e482ce..fe538e5 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -255,7 +255,7 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 
 static int fallback_init_cip(struct crypto_tfm *tfm)
 {
-	const char *name = tfm->__crt_alg->cra_name;
+	const char *name = crypto_tfm_alg_name(tfm);
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
 	op->fallback.cip = crypto_alloc_cipher(name, 0,
@@ -365,7 +365,7 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 
 static int fallback_init_blk(struct crypto_tfm *tfm)
 {
-	const char *name = tfm->__crt_alg->cra_name;
+	const char *name = crypto_tfm_alg_name(tfm);
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
 	op->fallback.blk = crypto_alloc_blkcipher(name, 0,
-- 
2.0.0.rc0
