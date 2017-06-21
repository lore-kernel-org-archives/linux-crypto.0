From: Radu Solea <radu.solea@nxp.com>
Subject: [RFC PATCH] gcm - fix setkey cache coherence issues
Date: Wed, 21 Jun 2017 17:29:21 +0300
Message-ID: <1498055361-12493-1-git-send-email-radu.solea@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <horia.geanta@nxp.com>,
        Radu Solea <radu.solea@nxp.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0078.outbound.protection.outlook.com ([104.47.37.78]:21030
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752391AbdFUO3o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Jun 2017 10:29:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Generic GCM is likely to end up using a hardware accelerator to do
part of the job. Allocating hash, iv and result in a contiguous memory
area increases the risk of dma mapping multiple ranges on the same
cacheline. Also having dma and cpu written data on the same cacheline
will cause coherence issues.

Signed-off-by: Radu Solea <radu.solea@nxp.com>
---
Hi!

I've encountered cache coherence issues when using GCM with CAAM and this was
one way of fixing them but it has its drawbacks. Another would be to allocate
each element instead of all at once, but that only decreases the likelyhood of
this happening. Does anyone know of a better way of fixing this?

Thanks,
Radu.

 crypto/gcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index b7ad808..657eefe 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -117,9 +117,9 @@ static int crypto_gcm_setkey(struct crypto_aead *aead, const u8 *key,
 	struct crypto_skcipher *ctr = ctx->ctr;
 	struct {
 		be128 hash;
-		u8 iv[16];
+		u8 iv[16] ____cacheline_aligned;
 
-		struct crypto_gcm_setkey_result result;
+		struct crypto_gcm_setkey_result result ____cacheline_aligned;
 
 		struct scatterlist sg[1];
 		struct skcipher_request req;
-- 
2.7.4
