Return-Path: <SRS0=2CiZ=QS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E3A3C169C4
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7914D2070B
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Feb 2019 11:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbfBKLqd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Feb 2019 06:46:33 -0500
Received: from inva021.nxp.com ([92.121.34.21]:52530 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbfBKLqd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Feb 2019 06:46:33 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5224F2000CC;
        Mon, 11 Feb 2019 12:46:30 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 3FD25200009;
        Mon, 11 Feb 2019 12:46:30 +0100 (CET)
Received: from enigma.ea.freescale.net (enigma.ea.freescale.net [10.171.81.110])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E214B205FA;
        Mon, 11 Feb 2019 12:46:29 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, Leo Li <leoyang.li@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>
Subject: [PATCH 1/3] crypto: caam/qi2 - use affine DPIOs
Date:   Mon, 11 Feb 2019 13:46:12 +0200
Message-Id: <20190211114614.24748-2-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.16.2
In-Reply-To: <20190211114614.24748-1-horia.geanta@nxp.com>
References: <20190211114614.24748-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Driver was relying on an older DPIO API, which provided a CPU-affine DPIO
in case it was called with preemption disabled.

Since this is no longer the case, save the CPU-affine DPIO in per-cpu
private structure during setup and further use it on the hot path.

Note that preemption is no longer disabled while trying to enqueue an
FD. Thus it might be possible to run the enqueue on a different CPU
(due to migration, when in process context), however this wouldn't be a
functionality issue.
Since we allow for all cores to enqueue, we take care of data
structures setup to handle the case when number of (Rx, Tx) queue pairs
is smaller than number of cores.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 52 ++++++++++++++++++++++-----------------
 drivers/crypto/caam/caamalg_qi2.h |  2 ++
 2 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 185365a35772..ce27c88e750f 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4502,7 +4502,8 @@ static int __cold dpaa2_dpseci_dpio_setup(struct dpaa2_caam_priv *priv)
 		nctx->cb = dpaa2_caam_fqdan_cb;
 
 		/* Register notification callbacks */
-		err = dpaa2_io_service_register(NULL, nctx, dev);
+		ppriv->dpio = dpaa2_io_service_select(cpu);
+		err = dpaa2_io_service_register(ppriv->dpio, nctx, dev);
 		if (unlikely(err)) {
 			dev_dbg(dev, "No affine DPIO for cpu %d\n", cpu);
 			nctx->cb = NULL;
@@ -4535,7 +4536,7 @@ static int __cold dpaa2_dpseci_dpio_setup(struct dpaa2_caam_priv *priv)
 		ppriv = per_cpu_ptr(priv->ppriv, cpu);
 		if (!ppriv->nctx.cb)
 			break;
-		dpaa2_io_service_deregister(NULL, &ppriv->nctx, dev);
+		dpaa2_io_service_deregister(ppriv->dpio, &ppriv->nctx, dev);
 	}
 
 	for_each_online_cpu(cpu) {
@@ -4555,7 +4556,8 @@ static void __cold dpaa2_dpseci_dpio_free(struct dpaa2_caam_priv *priv)
 
 	for_each_online_cpu(cpu) {
 		ppriv = per_cpu_ptr(priv->ppriv, cpu);
-		dpaa2_io_service_deregister(NULL, &ppriv->nctx, priv->dev);
+		dpaa2_io_service_deregister(ppriv->dpio, &ppriv->nctx,
+					    priv->dev);
 		dpaa2_io_store_destroy(ppriv->store);
 
 		if (++i == priv->num_pairs)
@@ -4653,7 +4655,7 @@ static int dpaa2_caam_pull_fq(struct dpaa2_caam_priv_per_cpu *ppriv)
 
 	/* Retry while portal is busy */
 	do {
-		err = dpaa2_io_service_pull_fq(NULL, ppriv->rsp_fqid,
+		err = dpaa2_io_service_pull_fq(ppriv->dpio, ppriv->rsp_fqid,
 					       ppriv->store);
 	} while (err == -EBUSY);
 
@@ -4721,7 +4723,7 @@ static int dpaa2_dpseci_poll(struct napi_struct *napi, int budget)
 
 	if (cleaned < budget) {
 		napi_complete_done(napi, cleaned);
-		err = dpaa2_io_service_rearm(NULL, &ppriv->nctx);
+		err = dpaa2_io_service_rearm(ppriv->dpio, &ppriv->nctx);
 		if (unlikely(err))
 			dev_err(priv->dev, "Notification rearm failed: %d\n",
 				err);
@@ -4862,21 +4864,31 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 
 	i = 0;
 	for_each_online_cpu(cpu) {
-		dev_dbg(dev, "pair %d: rx queue %d, tx queue %d\n", i,
-			priv->rx_queue_attr[i].fqid,
-			priv->tx_queue_attr[i].fqid);
+		u8 j;
+
+		j = i % priv->num_pairs;
 
 		ppriv = per_cpu_ptr(priv->ppriv, cpu);
-		ppriv->req_fqid = priv->tx_queue_attr[i].fqid;
-		ppriv->rsp_fqid = priv->rx_queue_attr[i].fqid;
-		ppriv->prio = i;
+		ppriv->req_fqid = priv->tx_queue_attr[j].fqid;
+
+		/*
+		 * Allow all cores to enqueue, while only some of them
+		 * will take part in dequeuing.
+		 */
+		if (++i > priv->num_pairs)
+			continue;
+
+		ppriv->rsp_fqid = priv->rx_queue_attr[j].fqid;
+		ppriv->prio = j;
+
+		dev_dbg(dev, "pair %d: rx queue %d, tx queue %d\n", j,
+			priv->rx_queue_attr[j].fqid,
+			priv->tx_queue_attr[j].fqid);
 
 		ppriv->net_dev.dev = *dev;
 		INIT_LIST_HEAD(&ppriv->net_dev.napi_list);
 		netif_napi_add(&ppriv->net_dev, &ppriv->napi, dpaa2_dpseci_poll,
 			       DPAA2_CAAM_NAPI_WEIGHT);
-		if (++i == priv->num_pairs)
-			break;
 	}
 
 	return 0;
@@ -5228,7 +5240,8 @@ int dpaa2_caam_enqueue(struct device *dev, struct caam_request *req)
 {
 	struct dpaa2_fd fd;
 	struct dpaa2_caam_priv *priv = dev_get_drvdata(dev);
-	int err = 0, i, id;
+	struct dpaa2_caam_priv_per_cpu *ppriv;
+	int err = 0, i;
 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -5258,20 +5271,13 @@ int dpaa2_caam_enqueue(struct device *dev, struct caam_request *req)
 	dpaa2_fd_set_len(&fd, dpaa2_fl_get_len(&req->fd_flt[1]));
 	dpaa2_fd_set_flc(&fd, req->flc_dma);
 
-	/*
-	 * There is no guarantee that preemption is disabled here,
-	 * thus take action.
-	 */
-	preempt_disable();
-	id = smp_processor_id() % priv->dpseci_attr.num_tx_queues;
+	ppriv = this_cpu_ptr(priv->ppriv);
 	for (i = 0; i < (priv->dpseci_attr.num_tx_queues << 1); i++) {
-		err = dpaa2_io_service_enqueue_fq(NULL,
-						  priv->tx_queue_attr[id].fqid,
+		err = dpaa2_io_service_enqueue_fq(ppriv->dpio, ppriv->req_fqid,
 						  &fd);
 		if (err != -EBUSY)
 			break;
 	}
-	preempt_enable();
 
 	if (unlikely(err)) {
 		dev_err(dev, "Error enqueuing frame: %d\n", err);
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
index 9823bdefd029..20890780fb82 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -76,6 +76,7 @@ struct dpaa2_caam_priv {
  * @nctx: notification context of response FQ
  * @store: where dequeued frames are stored
  * @priv: backpointer to dpaa2_caam_priv
+ * @dpio: portal used for data path operations
  */
 struct dpaa2_caam_priv_per_cpu {
 	struct napi_struct napi;
@@ -86,6 +87,7 @@ struct dpaa2_caam_priv_per_cpu {
 	struct dpaa2_io_notification_ctx nctx;
 	struct dpaa2_io_store *store;
 	struct dpaa2_caam_priv *priv;
+	struct dpaa2_io *dpio;
 };
 
 /*
-- 
2.16.2

