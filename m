From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [Crypto v4 06/12] cxgb4: LLD driver changes to enable TLS
Date: Mon, 12 Feb 2018 17:35:40 +0530
Message-ID: <1518437140-14467-1-git-send-email-atul.gupta@chelsio.com>
Cc: sd@queasysnail.net, linux-crypto@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, ganeshgr@chelsio.com
To: davejwatson@fb.com, herbert@gondor.apana.org.au
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Read FW capability. Read key area size. Dump the TLS record count.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 18 +++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 32 +++++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |  7 ++
 drivers/net/ethernet/chelsio/cxgb4/sge.c           | 98 +++++++++++++++++++++-
 4 files changed, 142 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index cf47183..cfc9210 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -2826,8 +2826,8 @@ static int meminfo_show(struct seq_file *seq, void *v)
 		"Tx payload:", "Rx payload:", "LE hash:", "iSCSI region:",
 		"TDDP region:", "TPT region:", "STAG region:", "RQ region:",
 		"RQUDP region:", "PBL region:", "TXPBL region:",
-		"DBVFIFO region:", "ULPRX state:", "ULPTX state:",
-		"On-chip queues:"
+		"TLSKey region:", "DBVFIFO region:", "ULPRX state:",
+		"ULPTX state:", "On-chip queues:"
 	};
 
 	int i, n;
@@ -2943,6 +2943,12 @@ static int meminfo_show(struct seq_file *seq, void *v)
 	ulp_region(RX_RQUDP);
 	ulp_region(RX_PBL);
 	ulp_region(TX_PBL);
+	if (adap->params.crypto & FW_CAPS_CONFIG_TLS_INLINE) {
+		ulp_region(RX_TLS_KEY);
+	} else {
+		md->base = 0;
+		md->idx = ARRAY_SIZE(region);
+	}
 #undef ulp_region
 	md->base = 0;
 	md->idx = ARRAY_SIZE(region);
@@ -3098,6 +3104,14 @@ static int chcr_show(struct seq_file *seq, void *v)
 		   atomic_read(&adap->chcr_stats.fallback));
 	seq_printf(seq, "IPSec PDU: %10u\n",
 		   atomic_read(&adap->chcr_stats.ipsec_cnt));
+
+	seq_puts(seq, "\nChelsio Inline TLS Stats\n");
+	seq_printf(seq, "TLS PDU Tx: %u\n",
+		   atomic_read(&adap->chcr_stats.tls_pdu_tx));
+	seq_printf(seq, "TLS PDU Rx: %u\n",
+		   atomic_read(&adap->chcr_stats.tls_pdu_rx));
+	seq_printf(seq, "TLS Keys (DDR) Count: %u\n",
+		   atomic_read(&adap->chcr_stats.tls_key));
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 05a4abf..60eb18b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -4086,18 +4086,32 @@ static int adap_init0(struct adapter *adap)
 		adap->num_ofld_uld += 2;
 	}
 	if (caps_cmd.cryptocaps) {
-		/* Should query params here...TODO */
-		params[0] = FW_PARAM_PFVF(NCRYPTO_LOOKASIDE);
-		ret = t4_query_params(adap, adap->mbox, adap->pf, 0, 2,
-				      params, val);
-		if (ret < 0) {
-			if (ret != -EINVAL)
+		if (ntohs(caps_cmd.cryptocaps) &
+		    FW_CAPS_CONFIG_CRYPTO_LOOKASIDE) {
+			params[0] = FW_PARAM_PFVF(NCRYPTO_LOOKASIDE);
+			ret = t4_query_params(adap, adap->mbox, adap->pf, 0,
+					      2, params, val);
+			if (ret < 0) {
+				if (ret != -EINVAL)
+					goto bye;
+			} else {
+				adap->vres.ncrypto_fc = val[0];
+			}
+			adap->num_ofld_uld += 1;
+		}
+		if (ntohs(caps_cmd.cryptocaps) &
+		    FW_CAPS_CONFIG_TLS_INLINE) {
+			params[0] = FW_PARAM_PFVF(TLS_START);
+			params[1] = FW_PARAM_PFVF(TLS_END);
+			ret = t4_query_params(adap, adap->mbox, adap->pf, 0,
+					      2, params, val);
+			if (ret < 0)
 				goto bye;
-		} else {
-			adap->vres.ncrypto_fc = val[0];
+			adap->vres.key.start = val[0];
+			adap->vres.key.size = val[1] - val[0] + 1;
+			adap->num_uld += 1;
 		}
 		adap->params.crypto = ntohs(caps_cmd.cryptocaps);
-		adap->num_uld += 1;
 	}
 #undef FW_PARAM_PFVF
 #undef FW_PARAM_DEV
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 1d37672..55863f6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -237,6 +237,7 @@ enum cxgb4_uld {
 	CXGB4_ULD_ISCSI,
 	CXGB4_ULD_ISCSIT,
 	CXGB4_ULD_CRYPTO,
+	CXGB4_ULD_TLS,
 	CXGB4_ULD_MAX
 };
 
@@ -287,6 +288,7 @@ struct cxgb4_virt_res {                      /* virtualized HW resources */
 	struct cxgb4_range qp;
 	struct cxgb4_range cq;
 	struct cxgb4_range ocq;
+	struct cxgb4_range key;
 	unsigned int ncrypto_fc;
 };
 
@@ -298,6 +300,9 @@ struct chcr_stats_debug {
 	atomic_t error;
 	atomic_t fallback;
 	atomic_t ipsec_cnt;
+	atomic_t tls_pdu_tx;
+	atomic_t tls_pdu_rx;
+	atomic_t tls_key;
 };
 
 #define OCQ_WIN_OFFSET(pdev, vres) \
@@ -378,6 +383,8 @@ struct cxgb4_uld_info {
 int cxgb4_register_uld(enum cxgb4_uld type, const struct cxgb4_uld_info *p);
 int cxgb4_unregister_uld(enum cxgb4_uld type);
 int cxgb4_ofld_send(struct net_device *dev, struct sk_buff *skb);
+int cxgb4_immdata_send(struct net_device *dev, unsigned int idx,
+		       const void *src, unsigned int len);
 int cxgb4_crypto_send(struct net_device *dev, struct sk_buff *skb);
 unsigned int cxgb4_dbfifo_count(const struct net_device *dev, int lpfifo);
 unsigned int cxgb4_port_chan(const struct net_device *dev);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 6c7b0ac..ec3d2c6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1593,9 +1593,9 @@ static void txq_stop_maperr(struct sge_uld_txq *q)
  *	Stops an offload Tx queue that has become full and modifies the packet
  *	being written to request a wakeup.
  */
-static void ofldtxq_stop(struct sge_uld_txq *q, struct sk_buff *skb)
+static void ofldtxq_stop(struct sge_uld_txq *q, void *src)
 {
-	struct fw_wr_hdr *wr = (struct fw_wr_hdr *)skb->data;
+	struct fw_wr_hdr *wr = (struct fw_wr_hdr *)src;
 
 	wr->lo |= htonl(FW_WR_EQUEQ_F | FW_WR_EQUIQ_F);
 	q->q.stops++;
@@ -1858,6 +1858,100 @@ int cxgb4_ofld_send(struct net_device *dev, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(cxgb4_ofld_send);
 
+static void *inline_tx_header(const void *src,
+			      const struct sge_txq *q,
+			      void *pos, int length)
+{
+	u64 *p;
+	int left = (void *)q->stat - pos;
+
+	if (likely(length <= left)) {
+		memcpy(pos, src, length);
+		pos += length;
+	} else {
+		memcpy(pos, src, left);
+		memcpy(q->desc, src + left, length - left);
+		pos = (void *)q->desc + (length - left);
+	}
+	/* 0-pad to multiple of 16 */
+	p = PTR_ALIGN(pos, 8);
+	if ((uintptr_t)p & 8) {
+		*p = 0;
+		return p + 1;
+	}
+	return p;
+}
+
+/**
+ *      ofld_xmit_direct - copy a WR into offload queue
+ *      @q: the Tx offload queue
+ *      @src: location of WR
+ *      @len: WR length
+ *
+ *      Copy an immediate WR into an uncontended SGE offload queue.
+ */
+static int ofld_xmit_direct(struct sge_uld_txq *q, const void *src,
+			    unsigned int len)
+{
+	u64 *pos;
+	int credits;
+	unsigned int ndesc;
+
+	/* Use the lower limit as the cut-off */
+	if (len > MAX_IMM_OFLD_TX_DATA_WR_LEN) {
+		WARN_ON(1);
+		return NET_XMIT_DROP;
+	}
+
+	/* Don't return NET_XMIT_CN here as the current
+	 * implementation doesn't queue the request
+	 * using an skb when the following conditions not met
+	 */
+	if (!spin_trylock(&q->sendq.lock))
+		return NET_XMIT_DROP;
+
+	if (q->full || !skb_queue_empty(&q->sendq) ||
+	    q->service_ofldq_running) {
+		spin_unlock(&q->sendq.lock);
+		return NET_XMIT_DROP;
+	}
+	ndesc = flits_to_desc(DIV_ROUND_UP(len, 8));
+	credits = txq_avail(&q->q) - ndesc;
+	pos = (u64 *)&q->q.desc[q->q.pidx];
+
+	/* ofldtxq_stop modifies WR header in-situ */
+	inline_tx_header(src, &q->q, pos, len);
+	if (unlikely(credits < TXQ_STOP_THRES))
+		ofldtxq_stop(q, pos);
+	txq_advance(&q->q, ndesc);
+	cxgb4_ring_tx_db(q->adap, &q->q, ndesc);
+
+	spin_unlock(&q->sendq.lock);
+	return NET_XMIT_SUCCESS;
+}
+
+int cxgb4_immdata_send(struct net_device *dev, unsigned int idx,
+		       const void *src, unsigned int len)
+{
+	struct adapter *adap = netdev2adap(dev);
+	struct sge_uld_txq_info *txq_info;
+	struct sge_uld_txq *txq;
+	int ret;
+
+	local_bh_disable();
+	txq_info = adap->sge.uld_txq_info[CXGB4_TX_OFLD];
+	if (unlikely(!txq_info)) {
+		WARN_ON(true);
+		return NET_XMIT_DROP;
+	}
+	txq = &txq_info->uldtxq[idx];
+
+	ret = ofld_xmit_direct(txq, src, len);
+	local_bh_enable();
+	return net_xmit_eval(ret);
+}
+EXPORT_SYMBOL(cxgb4_immdata_send);
+
 /**
  *	t4_crypto_send - send crypto packet
  *	@adap: the adapter
-- 
1.8.3.1
