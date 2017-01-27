From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp: Fix double add when creating new DMA command
Date: Fri, 27 Jan 2017 17:09:04 -0600
Message-ID: <20170127230904.31399.58184.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0081.outbound.protection.outlook.com ([104.47.32.81]:52727
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750720AbdA0XKG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Jan 2017 18:10:06 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eliminate a double-add by creating a new list to manage
command descriptors when created; move the descriptor to
the pending list when the command is submitted. This


Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dev.h       |    1 +
 drivers/crypto/ccp/ccp-dmaengine.c |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 830f35e..649e561 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -238,6 +238,7 @@ struct ccp_dma_chan {
 	struct ccp_device *ccp;
 
 	spinlock_t lock;
+	struct list_head created;
 	struct list_head pending;
 	struct list_head active;
 	struct list_head complete;
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index 6553912..e5d9278 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -63,6 +63,7 @@ static void ccp_free_chan_resources(struct dma_chan *dma_chan)
 	ccp_free_desc_resources(chan->ccp, &chan->complete);
 	ccp_free_desc_resources(chan->ccp, &chan->active);
 	ccp_free_desc_resources(chan->ccp, &chan->pending);
+	ccp_free_desc_resources(chan->ccp, &chan->created);
 
 	spin_unlock_irqrestore(&chan->lock, flags);
 }
@@ -273,6 +274,7 @@ static dma_cookie_t ccp_tx_submit(struct dma_async_tx_descriptor *tx_desc)
 	spin_lock_irqsave(&chan->lock, flags);
 
 	cookie = dma_cookie_assign(tx_desc);
+	list_del(&desc->entry);
 	list_add_tail(&desc->entry, &chan->pending);
 
 	spin_unlock_irqrestore(&chan->lock, flags);
@@ -426,7 +428,7 @@ static struct ccp_dma_desc *ccp_create_desc(struct dma_chan *dma_chan,
 
 	spin_lock_irqsave(&chan->lock, sflags);
 
-	list_add_tail(&desc->entry, &chan->pending);
+	list_add_tail(&desc->entry, &chan->created);
 
 	spin_unlock_irqrestore(&chan->lock, sflags);
 
@@ -610,6 +612,7 @@ static int ccp_terminate_all(struct dma_chan *dma_chan)
 	/*TODO: Purge the complete list? */
 	ccp_free_desc_resources(chan->ccp, &chan->active);
 	ccp_free_desc_resources(chan->ccp, &chan->pending);
+	ccp_free_desc_resources(chan->ccp, &chan->created);
 
 	spin_unlock_irqrestore(&chan->lock, flags);
 
@@ -679,6 +682,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
 		chan->ccp = ccp;
 
 		spin_lock_init(&chan->lock);
+		INIT_LIST_HEAD(&chan->created);
 		INIT_LIST_HEAD(&chan->pending);
 		INIT_LIST_HEAD(&chan->active);
 		INIT_LIST_HEAD(&chan->complete);
