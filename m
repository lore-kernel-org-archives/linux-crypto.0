From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] crypto: ccp - use kmem_cache_zalloc instead of kmem_cache_alloc/memset
Date: Thu, 15 Sep 2016 03:28:04 +0000
Message-ID: <1473910084-31739-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35265 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753866AbcIOD2L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Sep 2016 23:28:11 -0400
Received: by mail-pf0-f193.google.com with SMTP id z84so1608468pfi.2
        for <linux-crypto@vger.kernel.org>; Wed, 14 Sep 2016 20:28:11 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Using kmem_cache_zalloc() instead of kmem_cache_alloc() and memset().

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/ccp/ccp-dmaengine.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index ded26f4..2e5a05c 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -299,12 +299,10 @@ static struct ccp_dma_desc *ccp_alloc_dma_desc(struct ccp_dma_chan *chan,
 {
 	struct ccp_dma_desc *desc;
 
-	desc = kmem_cache_alloc(chan->ccp->dma_desc_cache, GFP_NOWAIT);
+	desc = kmem_cache_zalloc(chan->ccp->dma_desc_cache, GFP_NOWAIT);
 	if (!desc)
 		return NULL;
 
-	memset(desc, 0, sizeof(*desc));
-
 	dma_async_tx_descriptor_init(&desc->tx_desc, &chan->dma_chan);
 	desc->tx_desc.flags = flags;
 	desc->tx_desc.tx_submit = ccp_tx_submit;
