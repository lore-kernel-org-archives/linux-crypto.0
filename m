From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto:ccp - invoke the DMA callback in a standard way
Date: Tue, 05 Sep 2017 17:08:14 -0500
Message-ID: <20170905220813.18963.86148.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0084.outbound.protection.outlook.com ([104.47.40.84]:22764
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754041AbdIEWHq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2017 18:07:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: amd <amd@sosxen2.amd.com>

Use the provided mechanism in dmaengine.h to invoke the
completion callback.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dmaengine.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index e01b08a28ce5..8afd62052edd 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -231,9 +231,7 @@ static struct ccp_dma_desc *ccp_handle_active_desc(struct ccp_dma_chan *chan,
 		spin_unlock_irqrestore(&chan->lock, flags);
 
 		if (tx_desc) {
-			if (tx_desc->callback &&
-			    (tx_desc->flags & DMA_PREP_INTERRUPT))
-				tx_desc->callback(tx_desc->callback_param);
+			dmaengine_desc_get_callback_invoke(tx_desc, NULL);
 
 			dma_run_dependencies(tx_desc);
 		}
