From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 5/8] dmaengine: mv_xor: bug fix for racing condition in
 descriptors cleanup
Date: Tue, 12 May 2015 17:37:40 +0200
Message-ID: <1431445063-20226-6-git-send-email-maxime.ripard@free-electrons.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Lior Amsalem <alior@marvell.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 Thomas Petazzoni <thomas@free-electrons.com>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 Maxime Ripard <maxime.ripard@free-electrons.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Gregory Clement <gregory.clement@free-electrons.com>,
 Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
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

From: Lior Amsalem <alior@marvell.com>

This patch fixes a bug in the XOR driver where the cleanup function can be
called and free descriptors that never been processed by the engine (which
result in data errors).

The cleanup function will free descriptors based on the ownership bit in
the descriptors.

Signed-off-by: Lior Amsalem <alior@marvell.com>
Reviewed-by: Ofer Heifetz <oferh@marvell.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/mv_xor.c | 72 +++++++++++++++++++++++++++++++++-------------------
 drivers/dma/mv_xor.h |  1 +
 2 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index d1110442f0d2..28980483eafb 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -293,7 +293,8 @@ static void mv_chan_slot_cleanup(struct mv_xor_chan *mv_chan)
 	dma_cookie_t cookie = 0;
 	int busy = mv_chan_is_busy(mv_chan);
 	u32 current_desc = mv_chan_get_current_desc(mv_chan);
-	int seen_current = 0;
+	int current_cleaned = 0;
+	struct mv_xor_desc *hw_desc;
 
 	dev_dbg(mv_chan_to_devp(mv_chan), "%s %d\n", __func__, __LINE__);
 	dev_dbg(mv_chan_to_devp(mv_chan), "current_desc %x\n", current_desc);
@@ -305,38 +306,57 @@ static void mv_chan_slot_cleanup(struct mv_xor_chan *mv_chan)
 
 	list_for_each_entry_safe(iter, _iter, &mv_chan->chain,
 					node) {
-		prefetch(_iter);
-		prefetch(&_iter->async_tx);
 
-		/* do not advance past the current descriptor loaded into the
-		 * hardware channel, subsequent descriptors are either in
-		 * process or have not been submitted
-		 */
-		if (seen_current)
-			break;
+		/* clean finished descriptors */
+		hw_desc = iter->hw_desc;
+		if (hw_desc->status & XOR_DESC_SUCCESS) {
+			cookie = mv_desc_run_tx_complete_actions(iter, mv_chan,
+								 cookie);
 
-		/* stop the search if we reach the current descriptor and the
-		 * channel is busy
-		 */
-		if (iter->async_tx.phys == current_desc) {
-			seen_current = 1;
-			if (busy)
+			/* done processing desc, clean slot */
+			mv_desc_clean_slot(iter, mv_chan);
+
+			/* break if we did cleaned the current */
+			if (iter->async_tx.phys == current_desc) {
+				current_cleaned = 1;
 				break;
+			}
+		} else {
+			if (iter->async_tx.phys == current_desc) {
+				current_cleaned = 0;
+				break;
+			}
 		}
-
-		cookie = mv_desc_run_tx_complete_actions(iter, mv_chan, cookie);
-
-		if (mv_desc_clean_slot(iter, mv_chan))
-			break;
 	}
 
 	if ((busy == 0) && !list_empty(&mv_chan->chain)) {
-		struct mv_xor_desc_slot *chain_head;
-		chain_head = list_entry(mv_chan->chain.next,
-					struct mv_xor_desc_slot,
-					node);
-
-		mv_chan_start_new_chain(mv_chan, chain_head);
+		if (current_cleaned) {
+			/*
+			 * current descriptor cleaned and removed, run
+			 * from list head
+			 */
+			iter = list_entry(mv_chan->chain.next,
+					  struct mv_xor_desc_slot,
+					  node);
+			mv_chan_start_new_chain(mv_chan, iter);
+		} else {
+			if (!list_is_last(&iter->node, &mv_chan->chain)) {
+				/*
+				 * descriptors are still waiting after
+				 * current, trigger them
+				 */
+				iter = list_entry(iter->node.next,
+						  struct mv_xor_desc_slot,
+						  node);
+				mv_chan_start_new_chain(mv_chan, iter);
+			} else {
+				/*
+				 * some descriptors are still waiting
+				 * to be cleaned
+				 */
+				tasklet_schedule(&mv_chan->irq_tasklet);
+			}
+		}
 	}
 
 	if (cookie > 0)
diff --git a/drivers/dma/mv_xor.h b/drivers/dma/mv_xor.h
index 71684de37ddb..b7455b42137b 100644
--- a/drivers/dma/mv_xor.h
+++ b/drivers/dma/mv_xor.h
@@ -32,6 +32,7 @@
 #define XOR_OPERATION_MODE_MEMCPY	2
 #define XOR_OPERATION_MODE_IN_DESC      7
 #define XOR_DESCRIPTOR_SWAP		BIT(14)
+#define XOR_DESC_SUCCESS		0x40000000
 
 #define XOR_DESC_OPERATION_XOR          (0 << 24)
 #define XOR_DESC_OPERATION_CRC32C       (1 << 24)
-- 
2.4.0
