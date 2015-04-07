From: Leilei Zhao <leilei.zhao@atmel.com>
Subject: [PATCH 03/10] crypto: atmel-sha: correct the way data are split
Date: Tue, 7 Apr 2015 17:45:04 +0800
Message-ID: <1428399911-23325-4-git-send-email-leilei.zhao@atmel.com>
References: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Leilei Zhao <leilei.zhao@atmel.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nicolas.ferre@atmel.com>, <Ludovic.Desroches@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428399911-23325-1-git-send-email-leilei.zhao@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

When a hash is requested on data bigger than the buffer allocated by the
SHA driver, the way DMA transfers are performed is quite strange:
The buffer is filled at each update request. When full, a DMA transfer
is done. On next update request, another DMA transfer is done. Then we
wait to have a full buffer (or the end of the data) to perform the dma
transfer. Such a situation lead sometimes, on SAMA5D4, to a case where
dma transfer is finished but the data ready irq never comes. Moreover
hash was incorrect in this case.

With this patch, dma transfers are only performed when the buffer is
full or when there is no more data. So it removes the transfer whose size
is equal the update size after the full buffer transmission.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Leilei Zhao <leilei.zhao@atmel.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/crypto/atmel-sha.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index d092313..b471bbe 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -529,7 +529,7 @@ static int atmel_sha_update_dma_slow(struct atmel_sha_dev *dd)
 	if (final)
 		atmel_sha_fill_padding(ctx, 0);
 
-	if (final || (ctx->bufcnt == ctx->buflen && ctx->total)) {
+	if (final || (ctx->bufcnt == ctx->buflen)) {
 		count = ctx->bufcnt;
 		ctx->bufcnt = 0;
 		return atmel_sha_xmit_dma_map(dd, ctx, count, final);
-- 
1.7.9.5
