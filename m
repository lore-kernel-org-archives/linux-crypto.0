From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH cryptodev-2.6 2/3] crypto: cavium/nitrox - add support for per device request statistics.
Date: Fri, 21 Sep 2018 17:08:01 +0530
Message-ID: <20180921113802.26475-2-Jampala.Srikanth@cavium.com>
References: <20180921113802.26475-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgadam@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921113802.26475-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add per device statistics like number of requests posted,
dropped and completed etc.

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_dev.h    | 7 +++++++
 drivers/crypto/cavium/nitrox/nitrox_main.c   | 5 +++++
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 9 ++++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cavium/nitrox/nitrox_dev.h
index 1059495ee541..a1442006f256 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -75,6 +75,12 @@ struct nitrox_hw {
 	u8 zip_cores;
 };
 
+struct nitrox_stats {
+	atomic64_t posted;
+	atomic64_t completed;
+	atomic64_t dropped;
+};
+
 #define MAX_MSIX_VECTOR_NAME	20
 /**
  * vectors for queues (64 AE, 64 SE and 64 ZIP) and
@@ -176,6 +182,7 @@ struct nitrox_device {
 	struct nitrox_msix msix;
 	struct nitrox_bh bh;
 
+	struct nitrox_stats stats;
 	struct nitrox_hw hw;
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *debugfs_dir;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_main.c b/drivers/crypto/cavium/nitrox/nitrox_main.c
index acce0f0b9c7a..362e7217354c 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_main.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_main.c
@@ -542,6 +542,11 @@ static int nitrox_probe(struct pci_dev *pdev,
 	if (err)
 		goto pf_hw_fail;
 
+	/* clear the statistics */
+	atomic64_set(&ndev->stats.posted, 0);
+	atomic64_set(&ndev->stats.completed, 0);
+	atomic64_set(&ndev->stats.dropped, 0);
+
 	atomic_set(&ndev->state, __NDEV_READY);
 	/* barrier to sync with other cpus */
 	smp_mb__after_atomic();
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index 4a362fc22f62..f325b48ba904 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -460,6 +460,9 @@ static void post_se_instr(struct nitrox_softreq *sr,
 	cmdq->write_idx = incr_index(idx, 1, ndev->qlen);
 
 	spin_unlock_bh(&cmdq->cmdq_lock);
+
+	/* increment the posted command count */
+	atomic64_inc(&ndev->stats.posted);
 }
 
 static int post_backlog_cmds(struct nitrox_cmdq *cmdq)
@@ -508,8 +511,11 @@ static int nitrox_enqueue_request(struct nitrox_softreq *sr)
 	post_backlog_cmds(cmdq);
 
 	if (unlikely(cmdq_full(cmdq, ndev->qlen))) {
-		if (!(sr->flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+		if (!(sr->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
+			/* increment drop count */
+			atomic64_inc(&ndev->stats.dropped);
 			return -ENOSPC;
+		}
 		/* add to backlog list */
 		backlog_list_add(sr, cmdq);
 		return -EBUSY;
@@ -694,6 +700,7 @@ static void process_response_list(struct nitrox_cmdq *cmdq)
 					    READ_ONCE(sr->resp.orh));
 		}
 		atomic_dec(&cmdq->pending_count);
+		atomic64_inc(&ndev->stats.completed);
 		/* sync with other cpus */
 		smp_mb__after_atomic();
 		/* remove from response list */
-- 
2.17.1
