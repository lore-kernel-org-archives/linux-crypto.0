From: Lionel Debieve <lionel.Debieve@st.com>
Subject: [PATCH 2/3] crypto: stm32/hash: fix performance issues
Date: Mon, 29 Jan 2018 15:28:10 +0100
Message-ID: <20180129142811.13273-3-lionel.Debieve@st.com>
References: <20180129142811.13273-1-lionel.Debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ludovic Barre <ludovic.barre@st.com>,
 Lionel Debieve <lionel.debieve@st.com>,
 Benjamin Gaignard <benjamin.gaignard@st.com>,
 Fabien Dessenne <fabien.dessenne@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller"
 <davem@davemloft.net>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@st.com>,
 <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-kernel@vger.kernel.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180129142811.13273-1-lionel.Debieve@st.com>
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

From: Lionel Debieve <lionel.debieve@st.com>

Fixing bugs link to stress tests. Bad results are
detected during testmgr selftests executing in a
faster environment. bufcnt value may be resetted and
false IT are sometimes detected.

Signed-off-by: Lionel Debieve <lionel.debieve@st.com>
---
 drivers/crypto/stm32/stm32-hash.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 73cdc3b4dca8..d8444aeb6609 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -743,13 +743,15 @@ static int stm32_hash_final_req(struct stm32_hash_dev *hdev)
 	struct ahash_request *req = hdev->req;
 	struct stm32_hash_request_ctx *rctx = ahash_request_ctx(req);
 	int err;
+	int buflen = rctx->bufcnt;
+
+	rctx->bufcnt = 0;
 
 	if (!(rctx->flags & HASH_FLAGS_CPU))
 		err = stm32_hash_dma_send(hdev);
 	else
-		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, rctx->bufcnt, 1);
+		err = stm32_hash_xmit_cpu(hdev, rctx->buffer, buflen, 1);
 
-	rctx->bufcnt = 0;
 
 	return err;
 }
@@ -1096,6 +1098,8 @@ static irqreturn_t stm32_hash_irq_handler(int irq, void *dev_id)
 		reg &= ~HASH_SR_OUTPUT_READY;
 		stm32_hash_write(hdev, HASH_SR, reg);
 		hdev->flags |= HASH_FLAGS_OUTPUT_READY;
+		/* Disable IT*/
+		stm32_hash_write(hdev, HASH_IMR, 0);
 		return IRQ_WAKE_THREAD;
 	}
 
-- 
2.15.1
