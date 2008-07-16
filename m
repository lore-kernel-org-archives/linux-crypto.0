From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/6] crypto: talitos - correct dst != src case handling
Date: Wed, 16 Jul 2008 18:21:53 -0500
Message-ID: <20080716182153.1e6e098e.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev <linuxppc-dev@ozlabs.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:64462 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690AbYGPXWl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 19:22:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lee Nipper <lee.nipper@freescale.com>

Seems that dst == src, but this fixes the logic in case it's not.

Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 01e6595..f644fba 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1022,7 +1022,7 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 		dst_nents = src_nents;
 	} else {
 		dst_nents = sg_count(areq->dst, areq->cryptlen + ctx->authsize);
-		dst_nents = (dst_nents == 1) ? 0 : src_nents;
+		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
 	}
 
 	/*
-- 
1.5.6

