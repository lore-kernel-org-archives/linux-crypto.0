From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 1/2] crypto: inside-secure - fix invalidation check in hmac_sha1_setkey
Date: Mon, 17 Jul 2017 11:45:19 +0200
Message-ID: <20170717094520.3497-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:45438 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751288AbdGQJuD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 05:50:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The safexcel_hmac_sha1_setkey function checks if an invalidation command
should be issued, i.e. when the context ipad/opad change. This checks is
done after filling the ipad/opad which and it can't be true. The patch
fixes this by moving the check before the ipad/opad memcpy operations.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 8527a5899a2f..a11b2edb41b9 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -883,9 +883,6 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (ret)
 		return ret;
 
-	memcpy(ctx->ipad, &istate.state, SHA1_DIGEST_SIZE);
-	memcpy(ctx->opad, &ostate.state, SHA1_DIGEST_SIZE);
-
 	for (i = 0; i < ARRAY_SIZE(istate.state); i++) {
 		if (ctx->ipad[i] != le32_to_cpu(istate.state[i]) ||
 		    ctx->opad[i] != le32_to_cpu(ostate.state[i])) {
@@ -894,6 +891,9 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
 		}
 	}
 
+	memcpy(ctx->ipad, &istate.state, SHA1_DIGEST_SIZE);
+	memcpy(ctx->opad, &ostate.state, SHA1_DIGEST_SIZE);
+
 	return 0;
 }
 
-- 
2.13.3
