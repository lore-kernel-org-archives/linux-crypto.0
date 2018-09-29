From: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Subject: [PATCH cryptodev-2.6 3/4] crypto: cavium/nitrox - NITROX command queue changes.
Date: Sat, 29 Sep 2018 13:49:09 +0530
Message-ID: <20180929081910.17652-3-Jampala.Srikanth@cavium.com>
References: <20180929081910.17652-1-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgadam@cavium.com, Jampala.Srikanth@cavium.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180929081910.17652-1-Jampala.Srikanth@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use node based allocations for queues. consider the dma address
alignment changes, while calculating the queue base address.
added checks in cleanup functions. Minor changes to queue variable names

Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Reviewed-by: Gadam Sreerama <sgadam@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_dev.h    | 55 ++++++------
 drivers/crypto/cavium/nitrox/nitrox_hal.c    |  2 +-
 drivers/crypto/cavium/nitrox/nitrox_isr.c    |  2 +-
 drivers/crypto/cavium/nitrox/nitrox_lib.c    | 90 +++++++++++---------
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 24 +++---
 5 files changed, 94 insertions(+), 79 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_dev.h b/drivers/crypto/cavium/nitrox/nitrox_dev.h
index abb5c8ac54e5..62fb75923bfe 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_dev.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_dev.h
@@ -9,44 +9,51 @@
 
 #define VERSION_LEN 32
 
+/**
+ * struct nitrox_cmdq - NITROX command queue
+ * @cmd_qlock: command queue lock
+ * @resp_qlock: response queue lock
+ * @backlog_qlock: backlog queue lock
+ * @ndev: NITROX device
+ * @response_head: submitted request list
+ * @backlog_head: backlog queue
+ * @dbell_csr_addr: doorbell register address for this queue
+ * @base: command queue base address
+ * @dma: dma address of the base
+ * @pending_count: request pending at device
+ * @backlog_count: backlog request count
+ * @write_idx: next write index for the command
+ * @instr_size: command size
+ * @qno: command queue number
+ * @qsize: command queue size
+ * @unalign_base: unaligned base address
+ * @unalign_dma: unaligned dma address
+ */
 struct nitrox_cmdq {
-	/* command queue lock */
-	spinlock_t cmdq_lock;
-	/* response list lock */
-	spinlock_t response_lock;
-	/* backlog list lock */
-	spinlock_t backlog_lock;
-
-	/* request submitted to chip, in progress */
+	spinlock_t cmd_qlock;
+	spinlock_t resp_qlock;
+	spinlock_t backlog_qlock;
+
+	struct nitrox_device *ndev;
 	struct list_head response_head;
-	/* hw queue full, hold in backlog list */
 	struct list_head backlog_head;
 
-	/* doorbell address */
 	u8 __iomem *dbell_csr_addr;
-	/* base address of the queue */
-	u8 *head;
+	u8 *base;
+	dma_addr_t dma;
 
-	struct nitrox_device *ndev;
-	/* flush pending backlog commands */
 	struct work_struct backlog_qflush;
 
-	/* requests posted waiting for completion */
 	atomic_t pending_count;
-	/* requests in backlog queues */
 	atomic_t backlog_count;
 
 	int write_idx;
-	/* command size 32B/64B */
 	u8 instr_size;
 	u8 qno;
 	u32 qsize;
 
-	/* unaligned addresses */
-	u8 *head_unaligned;
-	dma_addr_t dma_unaligned;
-	/* dma address of the base */
-	dma_addr_t dma;
+	u8 *unalign_base;
+	dma_addr_t unalign_dma;
 };
 
 /**
@@ -152,7 +159,7 @@ enum vf_mode {
  * @nr_queues: Number of command queues
  * @mode: Device mode PF/VF
  * @ctx_pool: DMA pool for crypto context
- * @pkt_cmdqs: SE Command queues
+ * @pkt_inq: Packet input rings
  * @msix: MSI-X information
  * @bh: post processing work
  * @hw: hardware information
@@ -177,7 +184,7 @@ struct nitrox_device {
 	enum vf_mode mode;
 
 	struct dma_pool *ctx_pool;
-	struct nitrox_cmdq *pkt_cmdqs;
+	struct nitrox_cmdq *pkt_inq;
 
 	struct nitrox_msix msix;
 	struct nitrox_bh bh;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
index 4627a1976176..a9b82387cf53 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -119,7 +119,7 @@ void nitrox_config_pkt_input_rings(struct nitrox_device *ndev)
 	int i;
 
 	for (i = 0; i < ndev->nr_queues; i++) {
-		struct nitrox_cmdq *cmdq = &ndev->pkt_cmdqs[i];
+		struct nitrox_cmdq *cmdq = &ndev->pkt_inq[i];
 		union nps_pkt_in_instr_rsize pkt_in_rsize;
 		u64 offset;
 
diff --git a/drivers/crypto/cavium/nitrox/nitrox_isr.c b/drivers/crypto/cavium/nitrox/nitrox_isr.c
index 4f4334929f35..baeacacbddbe 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_isr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_isr.c
@@ -335,7 +335,7 @@ static int nitrox_setup_pkt_slc_bh(struct nitrox_device *ndev)
 		offset = NPS_PKT_SLC_CNTSX(i);
 		/* pre calculate completion count address */
 		bh->completion_cnt_csr_addr = NITROX_CSR_ADDR(ndev, offset);
-		bh->cmdq = &ndev->pkt_cmdqs[i];
+		bh->cmdq = &ndev->pkt_inq[i];
 
 		tasklet_init(&bh->resp_handler, pkt_slc_resp_handler,
 			     (unsigned long)bh);
diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/cavium/nitrox/nitrox_lib.c
index 7a721c7c12a4..ed08aa9380ee 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_lib.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
@@ -17,30 +17,27 @@
 
 #define CRYPTO_CTX_SIZE	256
 
-/* command queue alignments */
-#define PKT_IN_ALIGN	16
+/* packet inuput ring alignments */
+#define PKTIN_Q_ALIGN_BYTES 16
 
-static int cmdq_common_init(struct nitrox_cmdq *cmdq)
+static int nitrox_cmdq_init(struct nitrox_cmdq *cmdq, int align_bytes)
 {
 	struct nitrox_device *ndev = cmdq->ndev;
-	u32 qsize;
-
-	qsize = (ndev->qlen) * cmdq->instr_size;
-	cmdq->head_unaligned = dma_zalloc_coherent(DEV(ndev),
-						   (qsize + PKT_IN_ALIGN),
-						   &cmdq->dma_unaligned,
-						   GFP_KERNEL);
-	if (!cmdq->head_unaligned)
+
+	cmdq->qsize = (ndev->qlen * cmdq->instr_size) + align_bytes;
+	cmdq->unalign_base = dma_zalloc_coherent(DEV(ndev), cmdq->qsize,
+						 &cmdq->unalign_dma,
+						 GFP_KERNEL);
+	if (!cmdq->unalign_base)
 		return -ENOMEM;
 
-	cmdq->head = PTR_ALIGN(cmdq->head_unaligned, PKT_IN_ALIGN);
-	cmdq->dma = PTR_ALIGN(cmdq->dma_unaligned, PKT_IN_ALIGN);
-	cmdq->qsize = (qsize + PKT_IN_ALIGN);
+	cmdq->dma = PTR_ALIGN(cmdq->unalign_dma, align_bytes);
+	cmdq->base = cmdq->unalign_base + (cmdq->dma - cmdq->unalign_dma);
 	cmdq->write_idx = 0;
 
-	spin_lock_init(&cmdq->response_lock);
-	spin_lock_init(&cmdq->cmdq_lock);
-	spin_lock_init(&cmdq->backlog_lock);
+	spin_lock_init(&cmdq->cmd_qlock);
+	spin_lock_init(&cmdq->resp_qlock);
+	spin_lock_init(&cmdq->backlog_qlock);
 
 	INIT_LIST_HEAD(&cmdq->response_head);
 	INIT_LIST_HEAD(&cmdq->backlog_head);
@@ -51,68 +48,79 @@ static int cmdq_common_init(struct nitrox_cmdq *cmdq)
 	return 0;
 }
 
-static void cmdq_common_cleanup(struct nitrox_cmdq *cmdq)
+static void nitrox_cmdq_reset(struct nitrox_cmdq *cmdq)
+{
+	cmdq->write_idx = 0;
+	atomic_set(&cmdq->pending_count, 0);
+	atomic_set(&cmdq->backlog_count, 0);
+}
+
+static void nitrox_cmdq_cleanup(struct nitrox_cmdq *cmdq)
 {
 	struct nitrox_device *ndev = cmdq->ndev;
 
+	if (!cmdq->unalign_base)
+		return;
+
 	cancel_work_sync(&cmdq->backlog_qflush);
 
 	dma_free_coherent(DEV(ndev), cmdq->qsize,
-			  cmdq->head_unaligned, cmdq->dma_unaligned);
-
-	atomic_set(&cmdq->pending_count, 0);
-	atomic_set(&cmdq->backlog_count, 0);
+			  cmdq->unalign_base, cmdq->unalign_dma);
+	nitrox_cmdq_reset(cmdq);
 
 	cmdq->dbell_csr_addr = NULL;
-	cmdq->head = NULL;
+	cmdq->unalign_base = NULL;
+	cmdq->base = NULL;
+	cmdq->unalign_dma = 0;
 	cmdq->dma = 0;
 	cmdq->qsize = 0;
 	cmdq->instr_size = 0;
 }
 
-static void nitrox_cleanup_pkt_cmdqs(struct nitrox_device *ndev)
+static void nitrox_free_pktin_queues(struct nitrox_device *ndev)
 {
 	int i;
 
 	for (i = 0; i < ndev->nr_queues; i++) {
-		struct nitrox_cmdq *cmdq = &ndev->pkt_cmdqs[i];
+		struct nitrox_cmdq *cmdq = &ndev->pkt_inq[i];
 
-		cmdq_common_cleanup(cmdq);
+		nitrox_cmdq_cleanup(cmdq);
 	}
-	kfree(ndev->pkt_cmdqs);
-	ndev->pkt_cmdqs = NULL;
+	kfree(ndev->pkt_inq);
+	ndev->pkt_inq = NULL;
 }
 
-static int nitrox_init_pkt_cmdqs(struct nitrox_device *ndev)
+static int nitrox_alloc_pktin_queues(struct nitrox_device *ndev)
 {
-	int i, err, size;
+	int i, err;
 
-	size = ndev->nr_queues * sizeof(struct nitrox_cmdq);
-	ndev->pkt_cmdqs = kzalloc(size, GFP_KERNEL);
-	if (!ndev->pkt_cmdqs)
+	ndev->pkt_inq = kcalloc_node(ndev->nr_queues,
+				     sizeof(struct nitrox_cmdq),
+				     GFP_KERNEL, ndev->node);
+	if (!ndev->pkt_inq)
 		return -ENOMEM;
 
 	for (i = 0; i < ndev->nr_queues; i++) {
 		struct nitrox_cmdq *cmdq;
 		u64 offset;
 
-		cmdq = &ndev->pkt_cmdqs[i];
+		cmdq = &ndev->pkt_inq[i];
 		cmdq->ndev = ndev;
 		cmdq->qno = i;
 		cmdq->instr_size = sizeof(struct nps_pkt_instr);
 
+		/* packet input ring doorbell address */
 		offset = NPS_PKT_IN_INSTR_BAOFF_DBELLX(i);
-		/* SE ring doorbell address for this queue */
 		cmdq->dbell_csr_addr = NITROX_CSR_ADDR(ndev, offset);
 
-		err = cmdq_common_init(cmdq);
+		err = nitrox_cmdq_init(cmdq, PKTIN_Q_ALIGN_BYTES);
 		if (err)
-			goto pkt_cmdq_fail;
+			goto pktq_fail;
 	}
 	return 0;
 
-pkt_cmdq_fail:
-	nitrox_cleanup_pkt_cmdqs(ndev);
+pktq_fail:
+	nitrox_free_pktin_queues(ndev);
 	return err;
 }
 
@@ -194,7 +202,7 @@ int nitrox_common_sw_init(struct nitrox_device *ndev)
 	if (err)
 		return err;
 
-	err = nitrox_init_pkt_cmdqs(ndev);
+	err = nitrox_alloc_pktin_queues(ndev);
 	if (err)
 		destroy_crypto_dma_pool(ndev);
 
@@ -207,6 +215,6 @@ int nitrox_common_sw_init(struct nitrox_device *ndev)
  */
 void nitrox_common_sw_cleanup(struct nitrox_device *ndev)
 {
-	nitrox_cleanup_pkt_cmdqs(ndev);
+	nitrox_free_pktin_queues(ndev);
 	destroy_crypto_dma_pool(ndev);
 }
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
index f325b48ba904..d606c7af4667 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -382,11 +382,11 @@ static inline void backlog_list_add(struct nitrox_softreq *sr,
 {
 	INIT_LIST_HEAD(&sr->backlog);
 
-	spin_lock_bh(&cmdq->backlog_lock);
+	spin_lock_bh(&cmdq->backlog_qlock);
 	list_add_tail(&sr->backlog, &cmdq->backlog_head);
 	atomic_inc(&cmdq->backlog_count);
 	atomic_set(&sr->status, REQ_BACKLOG);
-	spin_unlock_bh(&cmdq->backlog_lock);
+	spin_unlock_bh(&cmdq->backlog_qlock);
 }
 
 static inline void response_list_add(struct nitrox_softreq *sr,
@@ -394,17 +394,17 @@ static inline void response_list_add(struct nitrox_softreq *sr,
 {
 	INIT_LIST_HEAD(&sr->response);
 
-	spin_lock_bh(&cmdq->response_lock);
+	spin_lock_bh(&cmdq->resp_qlock);
 	list_add_tail(&sr->response, &cmdq->response_head);
-	spin_unlock_bh(&cmdq->response_lock);
+	spin_unlock_bh(&cmdq->resp_qlock);
 }
 
 static inline void response_list_del(struct nitrox_softreq *sr,
 				     struct nitrox_cmdq *cmdq)
 {
-	spin_lock_bh(&cmdq->response_lock);
+	spin_lock_bh(&cmdq->resp_qlock);
 	list_del(&sr->response);
-	spin_unlock_bh(&cmdq->response_lock);
+	spin_unlock_bh(&cmdq->resp_qlock);
 }
 
 static struct nitrox_softreq *
@@ -439,11 +439,11 @@ static void post_se_instr(struct nitrox_softreq *sr,
 	int idx;
 	u8 *ent;
 
-	spin_lock_bh(&cmdq->cmdq_lock);
+	spin_lock_bh(&cmdq->cmd_qlock);
 
 	idx = cmdq->write_idx;
 	/* copy the instruction */
-	ent = cmdq->head + (idx * cmdq->instr_size);
+	ent = cmdq->base + (idx * cmdq->instr_size);
 	memcpy(ent, &sr->instr, cmdq->instr_size);
 
 	atomic_set(&sr->status, REQ_POSTED);
@@ -459,7 +459,7 @@ static void post_se_instr(struct nitrox_softreq *sr,
 
 	cmdq->write_idx = incr_index(idx, 1, ndev->qlen);
 
-	spin_unlock_bh(&cmdq->cmdq_lock);
+	spin_unlock_bh(&cmdq->cmd_qlock);
 
 	/* increment the posted command count */
 	atomic64_inc(&ndev->stats.posted);
@@ -474,7 +474,7 @@ static int post_backlog_cmds(struct nitrox_cmdq *cmdq)
 	if (!atomic_read(&cmdq->backlog_count))
 		return 0;
 
-	spin_lock_bh(&cmdq->backlog_lock);
+	spin_lock_bh(&cmdq->backlog_qlock);
 
 	list_for_each_entry_safe(sr, tmp, &cmdq->backlog_head, backlog) {
 		struct skcipher_request *skreq;
@@ -497,7 +497,7 @@ static int post_backlog_cmds(struct nitrox_cmdq *cmdq)
 		/* backlog requests are posted, wakeup with -EINPROGRESS */
 		skcipher_request_complete(skreq, -EINPROGRESS);
 	}
-	spin_unlock_bh(&cmdq->backlog_lock);
+	spin_unlock_bh(&cmdq->backlog_qlock);
 
 	return ret;
 }
@@ -578,7 +578,7 @@ int nitrox_process_se_request(struct nitrox_device *ndev,
 	/* select the queue */
 	qno = smp_processor_id() % ndev->nr_queues;
 
-	sr->cmdq = &ndev->pkt_cmdqs[qno];
+	sr->cmdq = &ndev->pkt_inq[qno];
 
 	/*
 	 * 64-Byte Instruction Format
-- 
2.17.1
