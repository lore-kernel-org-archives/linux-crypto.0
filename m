From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH] crypto: cesa: fix test in mv_cesa_dev_dma_init()
Date: Fri,  5 Feb 2016 17:45:48 +0100
Message-ID: <1454690748-13495-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:58734 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754047AbcBEQpv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Feb 2016 11:45:51 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We are checking twice if dma->cache_pool is not NULL but are never testing
dma->padding_pool value.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 0643e33..c0656e7 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -306,7 +306,7 @@ static int mv_cesa_dev_dma_init(struct mv_cesa_dev *cesa)
 		return -ENOMEM;
 
 	dma->padding_pool = dmam_pool_create("cesa_padding", dev, 72, 1, 0);
-	if (!dma->cache_pool)
+	if (!dma->padding_pool)
 		return -ENOMEM;
 
 	cesa->dma = dma;
-- 
2.1.4
