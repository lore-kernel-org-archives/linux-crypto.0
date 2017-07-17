From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 2/2] crypto: inside-secure - fix the sha state length in hmac_sha1_setkey
Date: Mon, 17 Jul 2017 11:45:20 +0200
Message-ID: <20170717094520.3497-2-antoine.tenart@free-electrons.com>
References: <20170717094520.3497-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:45436 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751279AbdGQJuD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 05:50:03 -0400
In-Reply-To: <20170717094520.3497-1-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A check is performed on the ipad/opad in the safexcel_hmac_sha1_setkey
function, but the index used by the loop doing it is wrong. It is
currently the size of the state array while it should be the size of a
sha1 state. This patch fixes it.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index a11b2edb41b9..3f819399cd95 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -883,7 +883,7 @@ static int safexcel_hmac_sha1_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (ret)
 		return ret;
 
-	for (i = 0; i < ARRAY_SIZE(istate.state); i++) {
+	for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(u32); i++) {
 		if (ctx->ipad[i] != le32_to_cpu(istate.state[i]) ||
 		    ctx->opad[i] != le32_to_cpu(ostate.state[i])) {
 			ctx->base.needs_inv = true;
-- 
2.13.3
