From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 08/24] staging: ccree: make mem barrier per request
Date: Mon, 13 Nov 2017 14:45:36 +0000
Message-ID: <1510584358-29473-9-git-send-email-gilad@benyossef.com>
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

The driver was issuing a write memory barrier per each
HW descriptor written but these descriptors are written
in groups and we really only need one per group.

White at it, document memory barrier reason.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index e23c656..f5041f7 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -172,7 +172,6 @@ static inline void enqueue_seq(
 		writel_relaxed(seq[i].word[2], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
 		writel_relaxed(seq[i].word[3], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
 		writel_relaxed(seq[i].word[4], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
-		wmb();
 		writel_relaxed(seq[i].word[5], (cc_base + CC_REG(DSCRPTR_QUEUE_WORD0)));
 #ifdef DX_DUMP_DESCS
 		dev_dbg(dev, "desc[%02d]: 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X 0x%08X\n",
@@ -359,6 +358,12 @@ int send_request(
 #ifdef FLUSH_CACHE_ALL
 	flush_cache_all();
 #endif
+	/*
+	 * We are about to push command to the HW via the command registers
+	 * that may refernece hsot memory. We need to issue a memory barrier
+	 * to make sure there are no outstnading memory writes
+	 */
+	wmb();
 
 	/* STAT_PHASE_4: Push sequence */
 	enqueue_seq(cc_base, iv_seq, iv_seq_len);
@@ -417,6 +422,12 @@ int send_request_init(
 
 	set_queue_last_ind(&desc[(len - 1)]);
 
+	/*
+	 * We are about to push command to the HW via the command registers
+	 * that may refernece hsot memory. We need to issue a memory barrier
+	 * to make sure there are no outstnading memory writes
+	 */
+	wmb();
 	enqueue_seq(cc_base, desc, len);
 
 	/* Update the free slots in HW queue */
-- 
2.7.4
