From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [crypto 1/8] cxgb4: Inline TLS
Date: Tue,  5 Dec 2017 17:09:13 +0530
Message-ID: <1512473953-6553-1-git-send-email-atul.gupta@chelsio.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, davejwatson@fb.com,
        ganeshgr@chelsio.com, harsh@chelsio.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add new uld driver for Inline TLS support. WR is defined to
submit crypto request to firmware.
Key area size is configured in hw-config file.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  18 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  32 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   7 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |  98 +++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        | 121 ++++++++++++++-
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |   2 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      | 165 ++++++++++++++++++++-
 7 files changed, 425 insertions(+), 18 deletions(-)

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
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index 7e12f24..9a56e0d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -81,6 +81,7 @@ enum {
 	CPL_RX_ISCSI_CMP      = 0x45,
 	CPL_TRACE_PKT_T5      = 0x48,
 	CPL_RX_ISCSI_DDP      = 0x49,
+	CPL_RX_TLS_CMP        = 0x4E,
 
 	CPL_RDMA_READ_REQ     = 0x60,
 
@@ -88,6 +89,7 @@ enum {
 	CPL_ACT_OPEN_REQ6     = 0x83,
 
 	CPL_TX_TLS_PDU     =    0x88,
+	CPL_TX_TLS_SFO        = 0x89,
 	CPL_TX_SEC_PDU        = 0x8A,
 	CPL_TX_TLS_ACK        = 0x8B,
 
@@ -97,6 +99,7 @@ enum {
 	CPL_RX_MPS_PKT        = 0xAF,
 
 	CPL_TRACE_PKT         = 0xB0,
+	CPL_TLS_DATA          = 0xB1,
 	CPL_ISCSI_DATA	      = 0xB2,
 
 	CPL_FW4_MSG           = 0xC0,
@@ -150,6 +153,7 @@ enum {
 	ULP_MODE_RDMA          = 4,
 	ULP_MODE_TCPDDP	       = 5,
 	ULP_MODE_FCOE          = 6,
+	ULP_MODE_TLS           = 8,
 };
 
 enum {
@@ -1414,6 +1418,14 @@ struct cpl_tx_data {
 #define TX_FORCE_S	13
 #define TX_FORCE_V(x)	((x) << TX_FORCE_S)
 
+#define TX_SHOVE_S    14
+#define TX_SHOVE_V(x) ((x) << TX_SHOVE_S)
+
+#define TX_ULP_MODE_S    10
+#define TX_ULP_MODE_M    0x7
+#define TX_ULP_MODE_V(x) ((x) << TX_ULP_MODE_S)
+#define TX_ULP_MODE_G(x) (((x) >> TX_ULP_MODE_S) & TX_ULP_MODE_M)
+
 #define T6_TX_FORCE_S		20
 #define T6_TX_FORCE_V(x)	((x) << T6_TX_FORCE_S)
 #define T6_TX_FORCE_F		T6_TX_FORCE_V(1U)
@@ -1428,12 +1440,21 @@ enum {
 	ULP_TX_SC_NOOP = 0x80,
 	ULP_TX_SC_IMM  = 0x81,
 	ULP_TX_SC_DSGL = 0x82,
-	ULP_TX_SC_ISGL = 0x83
+	ULP_TX_SC_ISGL = 0x83,
+	ULP_TX_SC_MEMRD = 0x86
 };
 
 #define ULPTX_CMD_S    24
 #define ULPTX_CMD_V(x) ((x) << ULPTX_CMD_S)
 
+#define ULPTX_LEN16_S    0
+#define ULPTX_LEN16_M    0xFF
+#define ULPTX_LEN16_V(x) ((x) << ULPTX_LEN16_S)
+
+#define ULP_TX_SC_MORE_S 23
+#define ULP_TX_SC_MORE_V(x) ((x) << ULP_TX_SC_MORE_S)
+#define ULP_TX_SC_MORE_F  ULP_TX_SC_MORE_V(1U)
+
 struct ulptx_sge_pair {
 	__be32 len[2];
 	__be64 addr[2];
@@ -1948,4 +1969,102 @@ enum {
 	X_CPL_RX_MPS_PKT_TYPE_QFC   = 1 << 2,
 	X_CPL_RX_MPS_PKT_TYPE_PTP   = 1 << 3
 };
+
+struct cpl_tx_tls_sfo {
+	__be32 op_to_seg_len;
+	__be32 pld_len;
+	__be32 type_protover;
+	__be32 r1_lo;
+	__be32 seqno_numivs;
+	__be32 ivgen_hdrlen;
+	__be64 scmd1;
+};
+
+/* cpl_tx_tls_sfo macros */
+#define CPL_TX_TLS_SFO_OPCODE_S         24
+#define CPL_TX_TLS_SFO_OPCODE_V(x)      ((x) << CPL_TX_TLS_SFO_OPCODE_S)
+
+#define CPL_TX_TLS_SFO_DATA_TYPE_S      20
+#define CPL_TX_TLS_SFO_DATA_TYPE_V(x)   ((x) << CPL_TX_TLS_SFO_DATA_TYPE_S)
+
+#define CPL_TX_TLS_SFO_CPL_LEN_S        16
+#define CPL_TX_TLS_SFO_CPL_LEN_V(x)     ((x) << CPL_TX_TLS_SFO_CPL_LEN_S)
+
+#define CPL_TX_TLS_SFO_SEG_LEN_S        0
+#define CPL_TX_TLS_SFO_SEG_LEN_M        0xffff
+#define CPL_TX_TLS_SFO_SEG_LEN_V(x)     ((x) << CPL_TX_TLS_SFO_SEG_LEN_S)
+#define CPL_TX_TLS_SFO_SEG_LEN_G(x)     \
+	(((x) >> CPL_TX_TLS_SFO_SEG_LEN_S) & CPL_TX_TLS_SFO_SEG_LEN_M)
+
+#define CPL_TX_TLS_SFO_TYPE_S           24
+#define CPL_TX_TLS_SFO_TYPE_M           0xff
+#define CPL_TX_TLS_SFO_TYPE_V(x)        ((x) << CPL_TX_TLS_SFO_TYPE_S)
+#define CPL_TX_TLS_SFO_TYPE_G(x)        \
+	(((x) >> CPL_TX_TLS_SFO_TYPE_S) & CPL_TX_TLS_SFO_TYPE_M)
+
+#define CPL_TX_TLS_SFO_PROTOVER_S       8
+#define CPL_TX_TLS_SFO_PROTOVER_M       0xffff
+#define CPL_TX_TLS_SFO_PROTOVER_V(x)    ((x) << CPL_TX_TLS_SFO_PROTOVER_S)
+#define CPL_TX_TLS_SFO_PROTOVER_G(x)    \
+	(((x) >> CPL_TX_TLS_SFO_PROTOVER_S) & CPL_TX_TLS_SFO_PROTOVER_M)
+
+struct cpl_tls_data {
+	struct rss_header rsshdr;
+	union opcode_tid ot;
+	__be32 length_pkd;
+	__be32 seq;
+	__be32 r1;
+};
+
+#define CPL_TLS_DATA_OPCODE_S           24
+#define CPL_TLS_DATA_OPCODE_M           0xff
+#define CPL_TLS_DATA_OPCODE_V(x)        ((x) << CPL_TLS_DATA_OPCODE_S)
+#define CPL_TLS_DATA_OPCODE_G(x)        \
+	(((x) >> CPL_TLS_DATA_OPCODE_S) & CPL_TLS_DATA_OPCODE_M)
+
+#define CPL_TLS_DATA_TID_S              0
+#define CPL_TLS_DATA_TID_M              0xffffff
+#define CPL_TLS_DATA_TID_V(x)           ((x) << CPL_TLS_DATA_TID_S)
+#define CPL_TLS_DATA_TID_G(x)           \
+	(((x) >> CPL_TLS_DATA_TID_S) & CPL_TLS_DATA_TID_M)
+
+#define CPL_TLS_DATA_LENGTH_S           0
+#define CPL_TLS_DATA_LENGTH_M           0xffff
+#define CPL_TLS_DATA_LENGTH_V(x)        ((x) << CPL_TLS_DATA_LENGTH_S)
+#define CPL_TLS_DATA_LENGTH_G(x)        \
+	(((x) >> CPL_TLS_DATA_LENGTH_S) & CPL_TLS_DATA_LENGTH_M)
+
+struct cpl_rx_tls_cmp {
+	struct rss_header rsshdr;
+	union opcode_tid ot;
+	__be32 pdulength_length;
+	__be32 seq;
+	__be32 ddp_report;
+	__be32 r;
+	__be32 ddp_valid;
+};
+
+#define CPL_RX_TLS_CMP_OPCODE_S         24
+#define CPL_RX_TLS_CMP_OPCODE_M         0xff
+#define CPL_RX_TLS_CMP_OPCODE_V(x)      ((x) << CPL_RX_TLS_CMP_OPCODE_S)
+#define CPL_RX_TLS_CMP_OPCODE_G(x)      \
+	(((x) >> CPL_RX_TLS_CMP_OPCODE_S) & CPL_RX_TLS_CMP_OPCODE_M)
+
+#define CPL_RX_TLS_CMP_TID_S            0
+#define CPL_RX_TLS_CMP_TID_M            0xffffff
+#define CPL_RX_TLS_CMP_TID_V(x)         ((x) << CPL_RX_TLS_CMP_TID_S)
+#define CPL_RX_TLS_CMP_TID_G(x)         \
+	(((x) >> CPL_RX_TLS_CMP_TID_S) & CPL_RX_TLS_CMP_TID_M)
+
+#define CPL_RX_TLS_CMP_PDULENGTH_S      16
+#define CPL_RX_TLS_CMP_PDULENGTH_M      0xffff
+#define CPL_RX_TLS_CMP_PDULENGTH_V(x)   ((x) << CPL_RX_TLS_CMP_PDULENGTH_S)
+#define CPL_RX_TLS_CMP_PDULENGTH_G(x)   \
+	(((x) >> CPL_RX_TLS_CMP_PDULENGTH_S) & CPL_RX_TLS_CMP_PDULENGTH_M)
+
+#define CPL_RX_TLS_CMP_LENGTH_S         0
+#define CPL_RX_TLS_CMP_LENGTH_M         0xffff
+#define CPL_RX_TLS_CMP_LENGTH_V(x)      ((x) << CPL_RX_TLS_CMP_LENGTH_S)
+#define CPL_RX_TLS_CMP_LENGTH_G(x)      \
+	(((x) >> CPL_RX_TLS_CMP_LENGTH_S) & CPL_RX_TLS_CMP_LENGTH_M)
 #endif  /* __T4_MSG_H */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
index a7cfece..5316b4b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_regs.h
@@ -2740,6 +2740,8 @@
 #define ULP_RX_LA_RDPTR_A 0x19240
 #define ULP_RX_LA_RDDATA_A 0x19244
 #define ULP_RX_LA_WRPTR_A 0x19248
+#define ULP_RX_TLS_KEY_LLIMIT_A 0x192ac
+#define ULP_RX_TLS_KEY_ULIMIT_A 0x192b0
 
 #define HPZ3_S    24
 #define HPZ3_V(x) ((x) << HPZ3_S)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index be36583..c9f75fc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -104,6 +104,7 @@ enum fw_wr_opcodes {
 	FW_RI_INV_LSTAG_WR             = 0x1a,
 	FW_ISCSI_TX_DATA_WR	       = 0x45,
 	FW_PTP_TX_PKT_WR               = 0x46,
+	FW_TLSTX_DATA_WR	       = 0x68,
 	FW_CRYPTO_LOOKASIDE_WR         = 0X6d,
 	FW_LASTC2E_WR                  = 0x70,
 	FW_FILTER2_WR		       = 0x77
@@ -634,6 +635,30 @@ struct fw_ofld_connection_wr {
 #define FW_OFLD_CONNECTION_WR_CPLPASSACCEPTRPL_F       \
 	FW_OFLD_CONNECTION_WR_CPLPASSACCEPTRPL_V(1U)
 
+enum fw_flowc_mnem_tcpstate {
+	FW_FLOWC_MNEM_TCPSTATE_CLOSED   = 0, /* illegal */
+	FW_FLOWC_MNEM_TCPSTATE_LISTEN   = 1, /* illegal */
+	FW_FLOWC_MNEM_TCPSTATE_SYNSENT  = 2, /* illegal */
+	FW_FLOWC_MNEM_TCPSTATE_SYNRECEIVED = 3, /* illegal */
+	FW_FLOWC_MNEM_TCPSTATE_ESTABLISHED = 4, /* default */
+	FW_FLOWC_MNEM_TCPSTATE_CLOSEWAIT = 5, /* got peer close already */
+	FW_FLOWC_MNEM_TCPSTATE_FINWAIT1 = 6, /* haven't gotten ACK for FIN and
+					      * will resend FIN - equiv ESTAB
+					      */
+	FW_FLOWC_MNEM_TCPSTATE_CLOSING  = 7, /* haven't gotten ACK for FIN and
+					      * will resend FIN but have
+					      * received FIN
+					      */
+	FW_FLOWC_MNEM_TCPSTATE_LASTACK  = 8, /* haven't gotten ACK for FIN and
+					      * will resend FIN but have
+					      * received FIN
+					      */
+	FW_FLOWC_MNEM_TCPSTATE_FINWAIT2 = 9, /* sent FIN and got FIN + ACK,
+					      * waiting for FIN
+					      */
+	FW_FLOWC_MNEM_TCPSTATE_TIMEWAIT = 10, /* not expected */
+};
+
 enum fw_flowc_mnem {
 	FW_FLOWC_MNEM_PFNVFN,		/* PFN [15:8] VFN [7:0] */
 	FW_FLOWC_MNEM_CH,
@@ -650,6 +675,8 @@ enum fw_flowc_mnem {
 	FW_FLOWC_MNEM_DCBPRIO,
 	FW_FLOWC_MNEM_SND_SCALE,
 	FW_FLOWC_MNEM_RCV_SCALE,
+	FW_FLOWC_MNEM_ULD_MODE,
+	FW_FLOWC_MNEM_MAX,
 };
 
 struct fw_flowc_mnemval {
@@ -674,6 +701,14 @@ struct fw_ofld_tx_data_wr {
 	__be32 tunnel_to_proxy;
 };
 
+#define FW_OFLD_TX_DATA_WR_ALIGNPLD_S           30
+#define FW_OFLD_TX_DATA_WR_ALIGNPLD_V(x) ((x) << FW_OFLD_TX_DATA_WR_ALIGNPLD_S)
+#define FW_OFLD_TX_DATA_WR_ALIGNPLD_F   FW_OFLD_TX_DATA_WR_ALIGNPLD_V(1U)
+
+#define FW_OFLD_TX_DATA_WR_SHOVE_S           29
+#define FW_OFLD_TX_DATA_WR_SHOVE_V(x)   ((x) << FW_OFLD_TX_DATA_WR_SHOVE_S)
+#define FW_OFLD_TX_DATA_WR_SHOVE_F      FW_OFLD_TX_DATA_WR_SHOVE_V(1U)
+
 #define FW_OFLD_TX_DATA_WR_TUNNEL_S     19
 #define FW_OFLD_TX_DATA_WR_TUNNEL_V(x)  ((x) << FW_OFLD_TX_DATA_WR_TUNNEL_S)
 
@@ -690,10 +725,6 @@ struct fw_ofld_tx_data_wr {
 #define FW_OFLD_TX_DATA_WR_MORE_S       15
 #define FW_OFLD_TX_DATA_WR_MORE_V(x)    ((x) << FW_OFLD_TX_DATA_WR_MORE_S)
 
-#define FW_OFLD_TX_DATA_WR_SHOVE_S      14
-#define FW_OFLD_TX_DATA_WR_SHOVE_V(x)   ((x) << FW_OFLD_TX_DATA_WR_SHOVE_S)
-#define FW_OFLD_TX_DATA_WR_SHOVE_F      FW_OFLD_TX_DATA_WR_SHOVE_V(1U)
-
 #define FW_OFLD_TX_DATA_WR_ULPMODE_S    10
 #define FW_OFLD_TX_DATA_WR_ULPMODE_V(x) ((x) << FW_OFLD_TX_DATA_WR_ULPMODE_S)
 
@@ -1118,6 +1149,12 @@ enum fw_caps_config_iscsi {
 	FW_CAPS_CONFIG_ISCSI_TARGET_CNXOFLD = 0x00000008,
 };
 
+enum fw_caps_config_crypto {
+	FW_CAPS_CONFIG_CRYPTO_LOOKASIDE = 0x00000001,
+	FW_CAPS_CONFIG_TLS_INLINE = 0x00000002,
+	FW_CAPS_CONFIG_IPSEC_INLINE = 0x00000004,
+};
+
 enum fw_caps_config_fcoe {
 	FW_CAPS_CONFIG_FCOE_INITIATOR	= 0x00000001,
 	FW_CAPS_CONFIG_FCOE_TARGET	= 0x00000002,
@@ -1258,6 +1295,8 @@ enum fw_params_param_pfvf {
 	FW_PARAMS_PARAM_PFVF_HPFILTER_START = 0x32,
 	FW_PARAMS_PARAM_PFVF_HPFILTER_END = 0x33,
 	FW_PARAMS_PARAM_PFVF_NCRYPTO_LOOKASIDE = 0x39,
+	FW_PARAMS_PARAM_PFVF_TLS_START = 0x34,
+	FW_PARAMS_PARAM_PFVF_TLS_END = 0x35,
 	FW_PARAMS_PARAM_PFVF_PORT_CAPS32 = 0x3A,
 };
 
@@ -3741,4 +3780,122 @@ struct fw_crypto_lookaside_wr {
 	(((x) >> FW_CRYPTO_LOOKASIDE_WR_HASH_SIZE_S) & \
 	 FW_CRYPTO_LOOKASIDE_WR_HASH_SIZE_M)
 
+struct fw_tlstx_data_wr {
+	__be32 op_to_immdlen;
+	__be32 flowid_len16;
+	__be32 plen;
+	__be32 lsodisable_to_flags;
+	__be32 r5;
+	__be32 ctxloc_to_exp;
+	__be16 mfs;
+	__be16 adjustedplen_pkd;
+	__be16 expinplenmax_pkd;
+	__u8   pdusinplenmax_pkd;
+	__u8   r10;
+};
+
+#define FW_TLSTX_DATA_WR_OPCODE_S       24
+#define FW_TLSTX_DATA_WR_OPCODE_M       0xff
+#define FW_TLSTX_DATA_WR_OPCODE_V(x)    ((x) << FW_TLSTX_DATA_WR_OPCODE_S)
+#define FW_TLSTX_DATA_WR_OPCODE_G(x)    \
+	(((x) >> FW_TLSTX_DATA_WR_OPCODE_S) & FW_TLSTX_DATA_WR_OPCODE_M)
+
+#define FW_TLSTX_DATA_WR_COMPL_S        21
+#define FW_TLSTX_DATA_WR_COMPL_M        0x1
+#define FW_TLSTX_DATA_WR_COMPL_V(x)     ((x) << FW_TLSTX_DATA_WR_COMPL_S)
+#define FW_TLSTX_DATA_WR_COMPL_G(x)     \
+	(((x) >> FW_TLSTX_DATA_WR_COMPL_S) & FW_TLSTX_DATA_WR_COMPL_M)
+#define FW_TLSTX_DATA_WR_COMPL_F        FW_TLSTX_DATA_WR_COMPL_V(1U)
+
+#define FW_TLSTX_DATA_WR_IMMDLEN_S      0
+#define FW_TLSTX_DATA_WR_IMMDLEN_M      0xff
+#define FW_TLSTX_DATA_WR_IMMDLEN_V(x)   ((x) << FW_TLSTX_DATA_WR_IMMDLEN_S)
+#define FW_TLSTX_DATA_WR_IMMDLEN_G(x)   \
+	(((x) >> FW_TLSTX_DATA_WR_IMMDLEN_S) & FW_TLSTX_DATA_WR_IMMDLEN_M)
+
+#define FW_TLSTX_DATA_WR_FLOWID_S       8
+#define FW_TLSTX_DATA_WR_FLOWID_M       0xfffff
+#define FW_TLSTX_DATA_WR_FLOWID_V(x)    ((x) << FW_TLSTX_DATA_WR_FLOWID_S)
+#define FW_TLSTX_DATA_WR_FLOWID_G(x)    \
+	(((x) >> FW_TLSTX_DATA_WR_FLOWID_S) & FW_TLSTX_DATA_WR_FLOWID_M)
+
+#define FW_TLSTX_DATA_WR_LEN16_S        0
+#define FW_TLSTX_DATA_WR_LEN16_M        0xff
+#define FW_TLSTX_DATA_WR_LEN16_V(x)     ((x) << FW_TLSTX_DATA_WR_LEN16_S)
+#define FW_TLSTX_DATA_WR_LEN16_G(x)     \
+	(((x) >> FW_TLSTX_DATA_WR_LEN16_S) & FW_TLSTX_DATA_WR_LEN16_M)
+
+#define FW_TLSTX_DATA_WR_LSODISABLE_S   31
+#define FW_TLSTX_DATA_WR_LSODISABLE_M   0x1
+#define FW_TLSTX_DATA_WR_LSODISABLE_V(x) \
+	((x) << FW_TLSTX_DATA_WR_LSODISABLE_S)
+#define FW_TLSTX_DATA_WR_LSODISABLE_G(x) \
+	(((x) >> FW_TLSTX_DATA_WR_LSODISABLE_S) & FW_TLSTX_DATA_WR_LSODISABLE_M)
+#define FW_TLSTX_DATA_WR_LSODISABLE_F   FW_TLSTX_DATA_WR_LSODISABLE_V(1U)
+
+#define FW_TLSTX_DATA_WR_ALIGNPLD_S     30
+#define FW_TLSTX_DATA_WR_ALIGNPLD_M     0x1
+#define FW_TLSTX_DATA_WR_ALIGNPLD_V(x)  ((x) << FW_TLSTX_DATA_WR_ALIGNPLD_S)
+#define FW_TLSTX_DATA_WR_ALIGNPLD_G(x)  \
+	(((x) >> FW_TLSTX_DATA_WR_ALIGNPLD_S) & FW_TLSTX_DATA_WR_ALIGNPLD_M)
+#define FW_TLSTX_DATA_WR_ALIGNPLD_F     FW_TLSTX_DATA_WR_ALIGNPLD_V(1U)
+
+#define FW_TLSTX_DATA_WR_ALIGNPLDSHOVE_S 29
+#define FW_TLSTX_DATA_WR_ALIGNPLDSHOVE_M 0x1
+#define FW_TLSTX_DATA_WR_ALIGNPLDSHOVE_V(x) \
+	((x) << FW_TLSTX_DATA_WR_ALIGNPLDSHOVE_S)
+#define FW_TLSTX_DATA_WR_ALIGNPLDSHOVE_G(x) \
+	(((x) >> FW_TLSTX_DATA_WR_ALIGNPLDSHOVE_S) & \
+	FW_TLSTX_DATA_WR_ALIGNPLDSHOVE_M)
+#define FW_TLSTX_DATA_WR_ALIGNPLDSHOVE_F FW_TLSTX_DATA_WR_ALIGNPLDSHOVE_V(1U)
+
+#define FW_TLSTX_DATA_WR_FLAGS_S        0
+#define FW_TLSTX_DATA_WR_FLAGS_M        0xfffffff
+#define FW_TLSTX_DATA_WR_FLAGS_V(x)     ((x) << FW_TLSTX_DATA_WR_FLAGS_S)
+#define FW_TLSTX_DATA_WR_FLAGS_G(x)     \
+	(((x) >> FW_TLSTX_DATA_WR_FLAGS_S) & FW_TLSTX_DATA_WR_FLAGS_M)
+
+#define FW_TLSTX_DATA_WR_CTXLOC_S       30
+#define FW_TLSTX_DATA_WR_CTXLOC_M       0x3
+#define FW_TLSTX_DATA_WR_CTXLOC_V(x)    ((x) << FW_TLSTX_DATA_WR_CTXLOC_S)
+#define FW_TLSTX_DATA_WR_CTXLOC_G(x)    \
+	(((x) >> FW_TLSTX_DATA_WR_CTXLOC_S) & FW_TLSTX_DATA_WR_CTXLOC_M)
+
+#define FW_TLSTX_DATA_WR_IVDSGL_S       29
+#define FW_TLSTX_DATA_WR_IVDSGL_M       0x1
+#define FW_TLSTX_DATA_WR_IVDSGL_V(x)    ((x) << FW_TLSTX_DATA_WR_IVDSGL_S)
+#define FW_TLSTX_DATA_WR_IVDSGL_G(x)    \
+	(((x) >> FW_TLSTX_DATA_WR_IVDSGL_S) & FW_TLSTX_DATA_WR_IVDSGL_M)
+#define FW_TLSTX_DATA_WR_IVDSGL_F       FW_TLSTX_DATA_WR_IVDSGL_V(1U)
+
+#define FW_TLSTX_DATA_WR_KEYSIZE_S      24
+#define FW_TLSTX_DATA_WR_KEYSIZE_M      0x1f
+#define FW_TLSTX_DATA_WR_KEYSIZE_V(x)   ((x) << FW_TLSTX_DATA_WR_KEYSIZE_S)
+#define FW_TLSTX_DATA_WR_KEYSIZE_G(x)   \
+	(((x) >> FW_TLSTX_DATA_WR_KEYSIZE_S) & FW_TLSTX_DATA_WR_KEYSIZE_M)
+
+#define FW_TLSTX_DATA_WR_NUMIVS_S       14
+#define FW_TLSTX_DATA_WR_NUMIVS_M       0xff
+#define FW_TLSTX_DATA_WR_NUMIVS_V(x)    ((x) << FW_TLSTX_DATA_WR_NUMIVS_S)
+#define FW_TLSTX_DATA_WR_NUMIVS_G(x)    \
+	(((x) >> FW_TLSTX_DATA_WR_NUMIVS_S) & FW_TLSTX_DATA_WR_NUMIVS_M)
+
+#define FW_TLSTX_DATA_WR_EXP_S          0
+#define FW_TLSTX_DATA_WR_EXP_M          0x3fff
+#define FW_TLSTX_DATA_WR_EXP_V(x)       ((x) << FW_TLSTX_DATA_WR_EXP_S)
+#define FW_TLSTX_DATA_WR_EXP_G(x)       \
+	(((x) >> FW_TLSTX_DATA_WR_EXP_S) & FW_TLSTX_DATA_WR_EXP_M)
+
+#define FW_TLSTX_DATA_WR_ADJUSTEDPLEN_S 1
+#define FW_TLSTX_DATA_WR_ADJUSTEDPLEN_V(x) \
+	((x) << FW_TLSTX_DATA_WR_ADJUSTEDPLEN_S)
+
+#define FW_TLSTX_DATA_WR_EXPINPLENMAX_S 4
+#define FW_TLSTX_DATA_WR_EXPINPLENMAX_V(x) \
+	((x) << FW_TLSTX_DATA_WR_EXPINPLENMAX_S)
+
+#define FW_TLSTX_DATA_WR_PDUSINPLENMAX_S 2
+#define FW_TLSTX_DATA_WR_PDUSINPLENMAX_V(x) \
+	((x) << FW_TLSTX_DATA_WR_PDUSINPLENMAX_S)
+
 #endif /* _T4FW_INTERFACE_H_ */
-- 
1.8.3.1
