From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 5/6] crypto: talitos - stop leaking memory in error path
Date: Wed, 16 Jul 2008 18:22:23 -0500
Message-ID: <20080716182223.08b2ee07.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev <linuxppc-dev@ozlabs.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:39703 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228AbYGPXXN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 19:23:13 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

free edescriptor when returning error (such as -EAGAIN).

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Acked-by: Lee Nipper <lee.nipper@freescale.com>
---
 drivers/crypto/talitos.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 79fdba2..a81265b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -880,7 +880,7 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 	unsigned int cryptlen = areq->cryptlen;
 	unsigned int authsize = ctx->authsize;
 	unsigned int ivsize;
-	int sg_count;
+	int sg_count, ret;
 
 	/* hmac key */
 	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
@@ -984,7 +984,12 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 	map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv, 0,
 			       DMA_FROM_DEVICE);
 
-	return talitos_submit(dev, desc, callback, areq);
+	ret = talitos_submit(dev, desc, callback, areq);
+	if (ret != -EINPROGRESS) {
+		ipsec_esp_unmap(dev, edesc, areq);
+		kfree(edesc);
+	}
+	return ret;
 }
 
 
-- 
1.5.6

