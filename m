From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH 1/3] crypto: marvell/cesa - replace dma_to_phys with dma_map_single
Date: Thu, 17 Mar 2016 18:02:15 -0400
Message-ID: <1458252137-24497-1-git-send-email-okaya@codeaurora.org>
Cc: Sinan Kaya <okaya@codeaurora.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, timur@codeaurora.org,
	cov@codeaurora.org, nwatters@codeaurora.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43724 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031953AbcCQWC2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Mar 2016 18:02:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Getting ready to remove dma_to_phys API. Drivers should not be
using this API for DMA operations. Instead, they should go
through the dma_map or dma_alloc APIs.

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/crypto/marvell/cesa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index c0656e7..52ddfa4 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -350,8 +350,8 @@ static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
 	if (IS_ERR(engine->sram))
 		return PTR_ERR(engine->sram);
 
-	engine->sram_dma = phys_to_dma(cesa->dev,
-				       (phys_addr_t)res->start);
+	engine->sram_dma = dma_map_single(cesa->dev, engine->sram,
+					  DMA_TO_DEVICE);
 
 	return 0;
 }
-- 
1.8.2.1
