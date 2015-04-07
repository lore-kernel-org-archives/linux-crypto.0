From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 06/10] crypto: atmel-sha: correct the max burst size
Date: Tue, 7 Apr 2015 17:45:07 +0800
Message-ID: <1428399911-23325-7-git-send-email-leilei.zhao@atmel.com>
References: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>,
	Leilei Zhao <leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas.ferre@atmel.com>, <Ludovic.Desroches@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The maximum source and destination burst size is 16
according to the datasheet of Atmel DMA. And the value
is also checked in function at_xdmac_csize of Atmel
DMA driver. With the restrict, the value beyond maximum
value will not be processed in DMA driver, so SHA384 and
SHA512 will not work and the program will wait forever.

So here change the max burst size of all the cases to 16
in order to make SHA384 and SHA512 work and keep consistent
with DMA driver and datasheet.

Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/crypto/atmel-sha.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 6430f6a..99a632c 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -432,14 +432,8 @@ static int atmel_sha_xmit_dma(struct atmel_sha_dev *dd, dma_addr_t dma_addr1,
 	dev_dbg(dd->dev, "xmit_dma: digcnt: 0x%llx 0x%llx, length: %d, final: %d\n",
 		ctx->digcnt[1], ctx->digcnt[0], length1, final);
 
-	if (ctx->flags & (SHA_FLAGS_SHA1 | SHA_FLAGS_SHA224 |
-			SHA_FLAGS_SHA256)) {
-		dd->dma_lch_in.dma_conf.src_maxburst = 16;
-		dd->dma_lch_in.dma_conf.dst_maxburst = 16;
-	} else {
-		dd->dma_lch_in.dma_conf.src_maxburst = 32;
-		dd->dma_lch_in.dma_conf.dst_maxburst = 32;
-	}
+	dd->dma_lch_in.dma_conf.src_maxburst = 16;
+	dd->dma_lch_in.dma_conf.dst_maxburst = 16;
 
 	dmaengine_slave_config(dd->dma_lch_in.chan, &dd->dma_lch_in.dma_conf);
 
-- 
1.7.9.5
