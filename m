From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 09/24] staging: ccree: replace open coded loop with for
Date: Mon, 13 Nov 2017 14:45:37 +0000
Message-ID: <1510584358-29473-10-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Replace open coded register writing loop with a for.
Further simplify code by using a local var to precompute
the register address for readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index f5041f7..65c4d9f 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -164,15 +164,17 @@ static inline void enqueue_seq(
 	void __iomem *cc_base,
 	struct cc_hw_desc seq[], unsigned int seq_len)
 {
-	int i;
+	int i, w;
+	void * __iomem reg = cc_base + CC_REG(DSCRPTR_QUEUE_WORD0);
+
+	/*
+	 * We do indeed write all 6 command words to the same
+	 * register. The HW supports this.
+	 */
 
 	for (i = 0; i < seq_len; i++) {
-		writel_relaxed(seq[i].word[0], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[1], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[2], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[3], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[4], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[5], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		for (w = 0; w <= 5; w++)
+			writel_relaxed(seq[i].word[w], reg);
 #ifdef DX_DUMP_DESCS
 		dev_dbg(dev, "desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
 			i, seq[i].word[0], seq[i].word[1], seq[i].word[2],
-- 
2.7.4
