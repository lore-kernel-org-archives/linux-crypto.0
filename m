From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 1/3] crypto: talitos - fix icv management on outbound direction
Date: Wed, 19 Sep 2012 21:53:38 +0300
Message-ID: <1348080820-22250-2-git-send-email-horia.geanta@freescale.com>
References: <1348080820-22250-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [216.32.181.185] ([216.32.181.185]:23287 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755446Ab2ISP6r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2012 11:58:47 -0400
In-Reply-To: <1348080820-22250-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

For IPsec encryption, in the case when:
-the input buffer is fragmented (edesc->src_nents > 0)
-the output buffer is not fragmented (edesc->dst_nents = 0)
the ICV is not output in the link table, but after the encrypted payload.

Copying the ICV must be avoided in this case; consequently the condition
edesc->dma_len > 0 must be more specific, i.e. must depend on the type
of the output buffer - fragmented or not.

Testing was performed by modifying testmgr to support src != dst,
since currently native kernel IPsec does in-place encryption
(src == dst).

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/talitos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index efff788..9d56763 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -825,7 +825,7 @@ static void ipsec_esp_encrypt_done(struct device *dev,
 	ipsec_esp_unmap(dev, edesc, areq);
 
 	/* copy the generated ICV to dst */
-	if (edesc->dma_len) {
+	if (edesc->dst_nents) {
 		icvdata = &edesc->link_tbl[edesc->src_nents +
 					   edesc->dst_nents + 2];
 		sg = sg_last(areq->dst, edesc->dst_nents);
-- 
1.7.7.6
