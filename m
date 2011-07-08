From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 4/8] crypto: talitos - don't bad_key in ablkcipher setkey
Date: Fri, 8 Jul 2011 17:57:25 -0500
Message-ID: <1310165849-22177-4-git-send-email-kim.phillips@freescale.com>
References: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:2046
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562Ab1GHW6L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 18:58:11 -0400
Received: from mail123-am1 (localhost.localdomain [127.0.0.1])	by
 mail123-am1-R.bigfish.com (Postfix) with ESMTP id 917461798094	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:09 +0000 (UTC)
Received: from AM1EHSMHS017.bigfish.com (unknown [10.3.201.245])	by
 mail123-am1.bigfish.com (Postfix) with ESMTP id 3D02C3F004B	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:09 +0000 (UTC)
In-Reply-To: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto/ablkcipher.c's setkey() has already checked against the min, max
key sizes before it calls here, and all max_keysize assignments in the
algorithm template array do not exceed TALITOS_MAX_KEY_SIZE.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 521244e..8a0bb41 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1378,22 +1378,11 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
 			     const u8 *key, unsigned int keylen)
 {
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	struct ablkcipher_alg *alg = crypto_ablkcipher_alg(cipher);
-
-	if (keylen > TALITOS_MAX_KEY_SIZE)
-		goto badkey;
-
-	if (keylen < alg->min_keysize || keylen > alg->max_keysize)
-		goto badkey;
 
 	memcpy(&ctx->key, key, keylen);
 	ctx->keylen = keylen;
 
 	return 0;
-
-badkey:
-	crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	return -EINVAL;
 }
 
 static void common_nonsnoop_unmap(struct device *dev,
-- 
1.7.6
