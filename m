From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH] crypto: marvell: Fix wrong flag used for GFP in mv_cesa_dma_add_iv_op
Date: Mon, 18 Jul 2016 11:32:24 +0200
Message-ID: <1468834344-14160-1-git-send-email-romain.perier@free-electrons.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Gregory Clement <gregory.clement@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:36194 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751326AbcGRJc7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jul 2016 05:32:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the parameter 'gfp_flags' instead of 'flag' as second argument of
dma_pool_alloc(). The parameter 'flag' is for the TDMA descriptor, its
content has no sense for the allocator.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/tdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index 942f4b6..51a631d 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -223,7 +223,7 @@ int mv_cesa_dma_add_iv_op(struct mv_cesa_tdma_chain *chain, dma_addr_t src,
 	if (IS_ERR(tdma))
 		return PTR_ERR(tdma);
 
-	iv = dma_pool_alloc(cesa_dev->dma->iv_pool, flags, &dma_handle);
+	iv = dma_pool_alloc(cesa_dev->dma->iv_pool, gfp_flags, &dma_handle);
 	if (!iv)
 		return -ENOMEM;
 
-- 
2.8.1
