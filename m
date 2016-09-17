From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] crypto: ccp - Fix return value check in ccp_dmaengine_register()
Date: Sat, 17 Sep 2016 16:01:22 +0000
Message-ID: <1474128082-14996-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35515 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbcIQQB3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Sep 2016 12:01:29 -0400
Received: by mail-pf0-f196.google.com with SMTP id 6so2023739pfl.2
        for <linux-crypto@vger.kernel.org>; Sat, 17 Sep 2016 09:01:28 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fix the retrn value check which testing the wrong variable
in ccp_dmaengine_register().

Fixes: 58ea8abf4904 ("crypto: ccp - Register the CCP as a DMA resource")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/crypto/ccp/ccp-dmaengine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index 94f77b0..32f645e 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -650,7 +650,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
 	dma_desc_cache_name = devm_kasprintf(ccp->dev, GFP_KERNEL,
 					     "%s-dmaengine-desc-cache",
 					     ccp->name);
-	if (!dma_cmd_cache_name)
+	if (!dma_desc_cache_name)
 		return -ENOMEM;
 	ccp->dma_desc_cache = kmem_cache_create(dma_desc_cache_name,
 						sizeof(struct ccp_dma_desc),
