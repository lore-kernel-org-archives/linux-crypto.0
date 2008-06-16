From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/4] crypto/talitos: unmap h/w generated IV
Date: Mon, 16 Jun 2008 11:10:45 -0500
Message-ID: <20080616111045.c0d3b843.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:45685 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbYFPQLh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jun 2008 12:11:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/talitos.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index f301e95..ce4787e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -654,6 +654,7 @@ static void ipsec_esp_unmap(struct device *dev,
 			    struct ipsec_esp_edesc *edesc,
 			    struct aead_request *areq)
 {
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6], DMA_FROM_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[3], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
-- 
1.5.6.rc2.26.g8c37

