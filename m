From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/4] crypto/talitos: fix premature done handling
Date: Mon, 16 Jun 2008 11:10:50 -0500
Message-ID: <20080616111050.596c245b.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:45680 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbYFPQLh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jun 2008 12:11:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Since the h/w doesn't support out-of-order processing within a channel,
abort channel flush processing in the no-done-bits-and-no-error case
so as to not allow premature passthrough to the callback (and thus
dropped packets).

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index ce4787e..64ddad2 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -307,8 +307,13 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		status = ((request->desc->hdr & DESC_HDR_DONE)
-			  == DESC_HDR_DONE) ? 0 : error;
+		if ((request->desc->hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
+			status = 0;
+		else
+			if (!error)
+				break;
+			else
+				status = error;
 
 		dma_unmap_single(dev, request->dma_desc,
 			sizeof(struct talitos_desc), DMA_BIDIRECTIONAL);
-- 
1.5.6.rc2.26.g8c37

