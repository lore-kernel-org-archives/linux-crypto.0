From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] crypto: mxs-dcp: fix type of ret for wait_for_completion_timeout
Date: Sat,  7 Feb 2015 03:09:41 -0500
Message-ID: <1423296581-10563-1-git-send-email-hofrat@osadl.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:36377 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbbBGIN7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Feb 2015 03:13:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

return type of wait_for_completion_timeout is unsigned long not int, this
patch changes the type of ret from int to unsigned long.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

As ret is only used here for wait_for_completion_timeout it can simply
be changed to the appropriate type.

Patch was only compile tested with mxs_defconfig 
(implies CONFIG_CRYPTO_DEV_MXS_DCP=y)

Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)

 drivers/crypto/mxs-dcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 829d639..59ed54e 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -153,7 +153,7 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *actx)
 	struct dcp *sdcp = global_sdcp;
 	const int chan = actx->chan;
 	uint32_t stat;
-	int ret;
+	unsigned long ret;
 	struct dcp_dma_desc *desc = &sdcp->coh->desc[actx->chan];
 
 	dma_addr_t desc_phys = dma_map_single(sdcp->dev, desc, sizeof(*desc),
-- 
1.7.10.4
