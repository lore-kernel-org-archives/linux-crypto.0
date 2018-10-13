From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v2 1/1]  crypto:chelsio: Update ntx queue received from cxgb4
Date: Sat, 13 Oct 2018 13:46:56 +0530
Message-ID: <c9489de40840ee72e9fcc9c5b3e8008592e8dc6d.1539418425.git.harsh@chelsio.com>
References: <cover.1539418425.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, atul.gupta@chelsio.com,
        indranil@chelsio.com, swise@opengridcomputing.com,
        varun@chelsio.com, ganeshgr@chelsio.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, LinoSanfilippo@gmx.de
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1539418425.git.harsh@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Update cxgb4 to send No. of Tx Queue created in lldinfo struct
and use the same ntxq in chcr driver.

This patch depends on following commit
commit  add92a817e60e308a419693413a38d9d1e663aff
"Fix memory corruption in DMA Mapped buffers"

v2:
Free txq_info in error case as pointed by Lino Sanfilippo.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c             |  3 +--
 drivers/crypto/chelsio/chcr_core.c             |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 20 ++++++++++++++++----
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 010bbf6..9b937cb 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1337,8 +1337,7 @@ static int chcr_device_init(struct chcr_context *ctx)
 		}
 		ctx->dev = u_ctx->dev;
 		adap = padap(ctx->dev);
-		ntxq = min_not_zero((unsigned int)u_ctx->lldi.nrxq,
-				    adap->vres.ncrypto_fc);
+		ntxq = u_ctx->lldi.ntxq;
 		rxq_perchan = u_ctx->lldi.nrxq / u_ctx->lldi.nchan;
 		txq_perchan = ntxq / u_ctx->lldi.nchan;
 		spin_lock(&ctx->dev->lock_chcr_dev);
diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index 04f277c..2399ce3 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -43,7 +43,7 @@ static chcr_handler_func work_handlers[NUM_CPL_CMDS] = {
 static struct cxgb4_uld_info chcr_uld_info = {
 	.name = DRV_MODULE_NAME,
 	.nrxq = MAX_ULD_QSETS,
-	.ntxq = MAX_ULD_QSETS,
+	/* Max ntxq will be derived from fw config file*/
 	.rxq_size = 1024,
 	.add = chcr_uld_add,
 	.state_change = chcr_uld_state_change,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 4bc2110..7947ae7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -520,10 +520,20 @@ setup_sge_txq_uld(struct adapter *adap, unsigned int uld_type,
 	txq_info = kzalloc(sizeof(*txq_info), GFP_KERNEL);
 	if (!txq_info)
 		return -ENOMEM;
+	if (uld_type == CXGB4_ULD_CRYPTO) {
+		i = min_t(int, adap->vres.ncrypto_fc,
+			  num_online_cpus());
+		txq_info->ntxq = rounddown(i, adap->params.nports);
+		if (txq_info->ntxq <= 0) {
+			dev_warn(adap->pdev_dev, "Crypto Tx Queues can't be zero\n");
+			kfree(txq_info);
+			return -EINVAL;
+		}
 
-	i = min_t(int, uld_info->ntxq, num_online_cpus());
-	txq_info->ntxq = roundup(i, adap->params.nports);
-
+	} else {
+		i = min_t(int, uld_info->ntxq, num_online_cpus());
+		txq_info->ntxq = roundup(i, adap->params.nports);
+	}
 	txq_info->uldtxq = kcalloc(txq_info->ntxq, sizeof(struct sge_uld_txq),
 				   GFP_KERNEL);
 	if (!txq_info->uldtxq) {
@@ -546,11 +556,14 @@ static void uld_queue_init(struct adapter *adap, unsigned int uld_type,
 			   struct cxgb4_lld_info *lli)
 {
 	struct sge_uld_rxq_info *rxq_info = adap->sge.uld_rxq_info[uld_type];
+	int tx_uld_type = TX_ULD(uld_type);
+	struct sge_uld_txq_info *txq_info = adap->sge.uld_txq_info[tx_uld_type];
 
 	lli->rxq_ids = rxq_info->rspq_id;
 	lli->nrxq = rxq_info->nrxq;
 	lli->ciq_ids = rxq_info->rspq_id + rxq_info->nrxq;
 	lli->nciq = rxq_info->nciq;
+	lli->ntxq = txq_info->ntxq;
 }
 
 int t4_uld_mem_alloc(struct adapter *adap)
@@ -634,7 +647,6 @@ static void uld_init(struct adapter *adap, struct cxgb4_lld_info *lld)
 	lld->ports = adap->port;
 	lld->vr = &adap->vres;
 	lld->mtus = adap->params.mtus;
-	lld->ntxq = adap->sge.ofldqsets;
 	lld->nchan = adap->params.nports;
 	lld->nports = adap->params.nports;
 	lld->wr_cred = adap->params.ofldq_wr_cred;
-- 
2.1.4
