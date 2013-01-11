From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH 1/2] crypto: caam - Fix DMA size in descriptor in ahash_digest()
Date: Fri, 11 Jan 2013 15:33:56 +0530
Message-ID: <1357898637-18971-2-git-send-email-vakul@freescale.com>
References: <1357898637-18971-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:9357 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133Ab3AKKGY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jan 2013 05:06:24 -0500
Received: from mail52-va3 (localhost [127.0.0.1])	by mail52-va3-R.bigfish.com
 (Postfix) with ESMTP id 5E0AC1C01BE	for <linux-crypto@vger.kernel.org>; Fri,
 11 Jan 2013 10:06:22 +0000 (UTC)
Received: from VA3EHSMHS013.bigfish.com (unknown [10.7.14.237])	by
 mail52-va3.bigfish.com (Postfix) with ESMTP id 3E9ED480082	for
 <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2013 10:06:21 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by az84smr01.freescale.net
 (8.14.3/8.14.0) with ESMTP id r0BA6EZ3008314	for
 <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2013 03:06:17 -0700
In-Reply-To: <1357898637-18971-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Steve Cornelius <steve.cornelius@freescale.com>

Save of DMA size in extended descriptor was missing.
Thus crashes could occur during post-request unmapping.

Signed-off-by: Steve Cornelius <steve.cornelius@freescale.com>
---
 drivers/crypto/caam/caamhash.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 32aba7a..6a26b6b 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1065,6 +1065,7 @@ static int ahash_digest(struct ahash_request *req)
 			  DESC_JOB_IO_LEN;
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
+	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->src_nents = src_nents;
 	edesc->chained = chained;
 
-- 
1.7.7.6
