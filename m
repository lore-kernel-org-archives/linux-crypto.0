From: Pan Bian <bianpan2016@163.com>
Subject: crypto: ccp: use dma_mapping_error to check map error
Date: Tue,  8 Aug 2017 21:42:47 +0800
Message-ID: <1502199767-2578-1-git-send-email-bianpan2016@163.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pan Bian <bianpan2016@163.com>
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:43387 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752082AbdHHNnm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Aug 2017 09:43:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The return value of dma_map_single() should be checked by
dma_mapping_error(). However, in function ccp_init_dm_workarea(), its
return value is checked against NULL, which could result in failures.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/crypto/ccp/ccp-ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index c0dfdac..ca83d19 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -168,7 +168,7 @@ static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
 
 		wa->dma.address = dma_map_single(wa->dev, wa->address, len,
 						 dir);
-		if (!wa->dma.address)
+		if (dma_mapping_error(wa->dev, wa->dma.address))
 			return -ENOMEM;
 
 		wa->dma.length = len;
-- 
1.9.1
