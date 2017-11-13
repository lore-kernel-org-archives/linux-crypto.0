From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 07/24] staging: ccree: remove unneeded cast
Date: Mon, 13 Nov 2017 14:45:35 +0000
Message-ID: <1510584358-29473-8-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove uneeded cast from writel_relaxed parameter.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 597a71f..e23c656 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -167,13 +167,13 @@ static inline void enqueue_seq(
 	int i;
 
 	for (i = 0; i < seq_len; i++) {
-		writel_relaxed(seq[i].word[0], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[1], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[2], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[3], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		writel_relaxed(seq[i].word[4], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[0], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[1], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[2], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[3], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[4], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
 		wmb();
-		writel_relaxed(seq[i].word[5], (volatile void __iomem *)(cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
+		writel_relaxed(seq[i].word[5], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
 #ifdef DX_DUMP_DESCS
 		dev_dbg(dev, "desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
 			i, seq[i].word[0], seq[i].word[1], seq[i].word[2],
-- 
2.7.4
