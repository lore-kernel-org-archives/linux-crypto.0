From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: ccp - Make function ccp_get_dma_chan_attr static
Date: Tue,  6 Feb 2018 23:20:01 +0000
Message-ID: <20180206232001.14102-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Function ccp_get_dma_chan_attr is local to the source and does not
need to be in global scope, so make it static.

Cleans up sparse warning:
drivers/crypto/ccp/ccp-dmaengine.c:41:14: warning: symbol
'ccp_get_dma_chan_attr' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/crypto/ccp/ccp-dmaengine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index 8b9da58459df..67155cb21636 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -38,7 +38,7 @@ static unsigned int dma_chan_attr = CCP_DMA_DFLT;
 module_param(dma_chan_attr, uint, 0444);
 MODULE_PARM_DESC(dma_chan_attr, "Set DMA channel visibility: 0 (default) = device defaults, 1 = make private, 2 = make public");
 
-unsigned int ccp_get_dma_chan_attr(struct ccp_device *ccp)
+static unsigned int ccp_get_dma_chan_attr(struct ccp_device *ccp)
 {
 	switch (dma_chan_attr) {
 	case CCP_DMA_DFLT:
-- 
2.15.1
