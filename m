From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH] crypto: ccp - unmap pages and remove unmap objects in
 callback
Date: Tue, 05 Sep 2017 17:01:51 -0500
Message-ID: <20170905220150.28464.76800.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: thomas.lendacky@amd.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0068.outbound.protection.outlook.com ([104.47.36.68]:20112
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753995AbdIEWBX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2017 18:01:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: amd <amd@sosxen2.amd.com>

Clean up the mapped pages and the unmap object once we are done with
it. This enables the final clean-up of the object once the transfer
is complete.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-dmaengine.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index 901343dd513e..e01b08a28ce5 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -223,6 +223,7 @@ static struct ccp_dma_desc *ccp_handle_active_desc(struct ccp_dma_chan *chan,
 				desc->tx_desc.cookie, desc->status);
 
 			dma_cookie_complete(tx_desc);
+			dma_descriptor_unmap(tx_desc);
 		}
 
 		desc = __ccp_next_dma_desc(chan, desc);
