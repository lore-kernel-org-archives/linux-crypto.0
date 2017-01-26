From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH v3 07/12] crypto: atmel-sha: add atmel_sha_cpu_start()
Date: Thu, 26 Jan 2017 17:07:52 +0100
Message-ID: <14bce182b9defe7bb4a41507901566825bc18b89.1485443478.git.cyrille.pitchen@atmel.com>
References: <cover.1485443478.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, Cyrille Pitchen <cyrille.pitchen@atmel.com>,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
 <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <cover.1485443478.git.cyrille.pitchen@atmel.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

This patch adds a simple function to perform data transfer with PIO, hence
handled by the CPU.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/crypto/atmel-sha.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index be0d72cf4352..58d9ca8ac0f2 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -64,6 +64,8 @@
 #define SHA_FLAGS_ERROR		BIT(23)
 #define SHA_FLAGS_PAD		BIT(24)
 #define SHA_FLAGS_RESTORE	BIT(25)
+#define SHA_FLAGS_IDATAR0	BIT(26)
+#define SHA_FLAGS_WAIT_DATARDY	BIT(27)
 
 #define SHA_OP_UPDATE	1
 #define SHA_OP_FINAL	2
@@ -141,6 +143,7 @@ struct atmel_sha_dev {
 	struct ahash_request	*req;
 	bool			is_async;
 	atmel_sha_fn_t		resume;
+	atmel_sha_fn_t		cpu_transfer_complete;
 
 	struct atmel_sha_dma	dma_lch_in;
 
@@ -1317,6 +1320,93 @@ static irqreturn_t atmel_sha_irq(int irq, void *dev_id)
 	return IRQ_NONE;
 }
 
+
+/* CPU transfer functions */
+
+static int atmel_sha_cpu_transfer(struct atmel_sha_dev *dd)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+	const u32 *words = (const u32 *)ctx->buffer;
+	size_t i, num_words;
+	u32 isr, din, din_inc;
+
+	din_inc = (ctx->flags & SHA_FLAGS_IDATAR0) ? 0 : 1;
+	for (;;) {
+		/* Write data into the Input Data Registers. */
+		num_words = DIV_ROUND_UP(ctx->bufcnt, sizeof(u32));
+		for (i = 0, din = 0; i < num_words; ++i, din += din_inc)
+			atmel_sha_write(dd, SHA_REG_DIN(din), words[i]);
+
+		ctx->offset += ctx->bufcnt;
+		ctx->total -= ctx->bufcnt;
+
+		if (!ctx->total)
+			break;
+
+		/*
+		 * Prepare next block:
+		 * Fill ctx->buffer now with the next data to be written into
+		 * IDATARx: it gives time for the SHA hardware to process
+		 * the current data so the SHA_INT_DATARDY flag might be set
+		 * in SHA_ISR when polling this register at the beginning of
+		 * the next loop.
+		 */
+		ctx->bufcnt = min_t(size_t, ctx->block_size, ctx->total);
+		scatterwalk_map_and_copy(ctx->buffer, ctx->sg,
+					 ctx->offset, ctx->bufcnt, 0);
+
+		/* Wait for hardware to be ready again. */
+		isr = atmel_sha_read(dd, SHA_ISR);
+		if (!(isr & SHA_INT_DATARDY)) {
+			/* Not ready yet. */
+			dd->resume = atmel_sha_cpu_transfer;
+			atmel_sha_write(dd, SHA_IER, SHA_INT_DATARDY);
+			return -EINPROGRESS;
+		}
+	}
+
+	if (unlikely(!(ctx->flags & SHA_FLAGS_WAIT_DATARDY)))
+		return dd->cpu_transfer_complete(dd);
+
+	return atmel_sha_wait_for_data_ready(dd, dd->cpu_transfer_complete);
+}
+
+static int atmel_sha_cpu_start(struct atmel_sha_dev *dd,
+			       struct scatterlist *sg,
+			       unsigned int len,
+			       bool idatar0_only,
+			       bool wait_data_ready,
+			       atmel_sha_fn_t resume)
+{
+	struct ahash_request *req = dd->req;
+	struct atmel_sha_reqctx *ctx = ahash_request_ctx(req);
+
+	if (!len)
+		return resume(dd);
+
+	ctx->flags &= ~(SHA_FLAGS_IDATAR0 | SHA_FLAGS_WAIT_DATARDY);
+
+	if (idatar0_only)
+		ctx->flags |= SHA_FLAGS_IDATAR0;
+
+	if (wait_data_ready)
+		ctx->flags |= SHA_FLAGS_WAIT_DATARDY;
+
+	ctx->sg = sg;
+	ctx->total = len;
+	ctx->offset = 0;
+
+	/* Prepare the first block to be written. */
+	ctx->bufcnt = min_t(size_t, ctx->block_size, ctx->total);
+	scatterwalk_map_and_copy(ctx->buffer, ctx->sg,
+				 ctx->offset, ctx->bufcnt, 0);
+
+	dd->cpu_transfer_complete = resume;
+	return atmel_sha_cpu_transfer(dd);
+}
+
+
 static void atmel_sha_unregister_algs(struct atmel_sha_dev *dd)
 {
 	int i;
-- 
2.7.4
