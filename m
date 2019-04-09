Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D02FC10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4F2A2084F
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfDIPXu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:23:50 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:44186 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfDIPXu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 11:23:50 -0400
Received: from beagle7.asicdesigners.com (beagle7.asicdesigners.com [10.192.192.157])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x39FNhKB003417;
        Tue, 9 Apr 2019 08:23:43 -0700
From:   Atul Gupta <atul.gupta@chelsio.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com, atul.gupta@chelsio.com
Subject: [crypto 2/4] crypto/chelsio/chtls: hardware connect API
Date:   Tue,  9 Apr 2019 08:23:42 -0700
Message-Id: <20190409152342.11200-1-atul.gupta@chelsio.com>
X-Mailer: git-send-email 2.20.0.rc2.7.g965798d
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hardware specific implementation for TLS client processing.
Added connect routine to prepare hardware for TLS client
handshake.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls.h          |   6 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c       | 539 ++++++++++++++++++++++++--
 drivers/crypto/chelsio/chtls/chtls_cm.h       |   6 +-
 drivers/crypto/chelsio/chtls/chtls_hw.c       |   6 +-
 drivers/crypto/chelsio/chtls/chtls_main.c     | 157 ++++++++
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |   2 +
 net/core/secure_seq.c                         |   1 +
 7 files changed, 682 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index 59bb67d..9742613 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -136,6 +136,8 @@ struct chtls_dev {
 	struct idr stid_idr;
 
 	spinlock_t idr_lock ____cacheline_aligned_in_smp;
+	spinlock_t aidr_lock ____cacheline_aligned_in_smp;
+	struct idr aidr; /* ATID id space */
 
 	struct net_device *egr_dev[NCHAN * 2];
 	struct sk_buff *rspq_skb_cache[1 << RSPQ_HASH_BITS];
@@ -191,6 +193,7 @@ struct chtls_sock {
 	struct net_device *egress_dev;  /* TX_CHAN for act open retry */
 
 	struct sk_buff_head txq;
+	struct sk_buff_head ooq;
 	struct sk_buff *wr_skb_head;
 	struct sk_buff *wr_skb_tail;
 	struct sk_buff *ctrl_skb_cache;
@@ -206,6 +209,7 @@ struct chtls_sock {
 	u32 txq_idx;
 	u32 rss_qid;
 	u32 tid;
+	u32 neg_adv_tid;
 	u32 idr;
 	u32 mss;
 	u32 ulp_mode;
@@ -389,7 +393,7 @@ static inline bool csk_conn_inline(const struct chtls_sock *csk)
 
 static inline int csk_flag(const struct sock *sk, enum csk_flags flag)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 
 	if (!csk_conn_inline(csk))
 		return 0;
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 4e22332..16140b2 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -29,6 +29,7 @@
 #include "chtls.h"
 #include "chtls_cm.h"
 
+static void chtls_connect_req_arp_failure(void *handle, struct sk_buff *skb);
 /*
  * State transitions and actions for close.  Note that if we are in SYN_SENT
  * we remain in that state as we cannot control a connection while it's in
@@ -66,6 +67,7 @@ static struct chtls_sock *chtls_sock_create(struct chtls_dev *cdev)
 	kref_init(&csk->kref);
 	csk->cdev = cdev;
 	skb_queue_head_init(&csk->txq);
+	skb_queue_head_init(&csk->ooq);
 	csk->wr_skb_head = NULL;
 	csk->wr_skb_tail = NULL;
 	csk->mss = MAX_MSS;
@@ -85,6 +87,60 @@ static void chtls_sock_release(struct kref *ref)
 	kfree(csk);
 }
 
+static int bh_insert_handle(struct chtls_dev *cdev, struct sock *sk,
+			    int tid)
+{
+	int id;
+
+	spin_lock_bh(&cdev->idr_lock);
+	id = idr_alloc(&cdev->hwtid_idr, sk, tid, tid + 1, GFP_NOWAIT);
+	spin_unlock_bh(&cdev->idr_lock);
+	return id;
+}
+
+static int sk_insert_tid(struct chtls_dev *cdev, struct sock *sk,
+			 unsigned int tid)
+{
+	int id;
+
+	sock_hold(sk);
+	cxgb4_insert_tid(cdev->tids, sk, tid, sk->sk_family);
+	id = bh_insert_handle(cdev, sk, tid);
+	return id;
+}
+
+#define __FIXUP_WR_MIT_CPL(_w, cpl, _tid) do { \
+	typeof(_w) (w) = (_w); \
+	typeof(_tid) (tid) = (_tid); \
+	(w)->wr.wr_mid = \
+	htonl(FW_WR_LEN16_V(FW_WR_LEN16_G(ntohl((w)->wr.wr_mid))) | \
+	      FW_WR_FLOWID_V(tid)); \
+	OPCODE_TID(w) = htonl(MK_OPCODE_TID(cpl, tid)); \
+} while (0)
+
+#define __FIXUP_FLOWC_WR(_flowc, tid) do { \
+	typeof(_flowc) (flowc) = (_flowc); \
+	(flowc)->flowid_len16 = \
+	htonl(FW_WR_LEN16_V(FW_WR_LEN16_G(ntohl((flowc)->flowid_len16))) | \
+	      FW_WR_FLOWID_V(tid)); \
+} while (0)
+
+static void fixup_and_send_ofo(struct chtls_sock *csk, unsigned int tid)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(&csk->ooq)) != NULL) {
+		struct fw_flowc_wr *flowc = cplhdr(skb);
+		struct cpl_close_con_req *p = cplhdr(skb);
+
+		if (FW_WR_OP_G(ntohl(flowc->op_to_nparams)) == FW_FLOWC_WR)
+			__FIXUP_FLOWC_WR(flowc, tid);
+		else
+			__FIXUP_WR_MIT_CPL(p, p->ot.opcode, tid);
+		cxgb4_ofld_send(csk->egress_dev, skb);
+	}
+}
+
 static struct net_device *chtls_ipv4_netdev(struct chtls_dev *cdev,
 					    struct sock *sk)
 {
@@ -108,7 +164,7 @@ static void assign_rxopt(struct sock *sk, unsigned int opt)
 	struct chtls_sock *csk;
 	struct tcp_sock *tp;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	tp = tcp_sk(sk);
 
 	cdev = csk->cdev;
@@ -142,9 +198,10 @@ static void chtls_purge_receive_queue(struct sock *sk)
 
 static void chtls_purge_write_queue(struct sock *sk)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk;
 	struct sk_buff *skb;
 
+	csk = sk->sk_user_data;
 	while ((skb = __skb_dequeue(&csk->txq))) {
 		sk->sk_wmem_queued -= skb->truesize;
 		__kfree_skb(skb);
@@ -153,10 +210,12 @@ static void chtls_purge_write_queue(struct sock *sk)
 
 static void chtls_purge_recv_queue(struct sock *sk)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
-	struct chtls_hws *tlsk = &csk->tlshws;
+	struct chtls_sock *csk;
+	struct chtls_hws *tlsk;
 	struct sk_buff *skb;
 
+	csk = sk->sk_user_data;
+	tlsk = &csk->tlshws;
 	while ((skb = __skb_dequeue(&tlsk->sk_recv_queue)) != NULL) {
 		skb_dst_set(skb, NULL);
 		kfree_skb(skb);
@@ -190,7 +249,7 @@ static void chtls_send_abort(struct sock *sk, int mode, struct sk_buff *skb)
 	struct chtls_sock *csk;
 	struct tcp_sock *tp;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	tp = tcp_sk(sk);
 
 	if (!skb)
@@ -208,8 +267,9 @@ static void chtls_send_abort(struct sock *sk, int mode, struct sk_buff *skb)
 
 static void chtls_send_reset(struct sock *sk, int mode, struct sk_buff *skb)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk;
 
+	csk = sk->sk_user_data;
 	if (unlikely(csk_flag_nochk(csk, CSK_ABORT_SHUTDOWN) ||
 		     !csk->cdev)) {
 		if (sk->sk_state == TCP_SYN_RECV)
@@ -264,7 +324,7 @@ static void chtls_close_conn(struct sock *sk)
 	unsigned int len;
 
 	len = roundup(sizeof(struct cpl_close_con_req), 16);
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	tid = csk->tid;
 
 	skb = alloc_skb(len, GFP_KERNEL | __GFP_NOFAIL);
@@ -302,7 +362,7 @@ void chtls_close(struct sock *sk, long timeout)
 	int data_lost, prev_state;
 	struct chtls_sock *csk;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 
 	lock_sock(sk);
 	sk->sk_shutdown |= SHUTDOWN_MASK;
@@ -442,7 +502,7 @@ void chtls_destroy_sock(struct sock *sk)
 {
 	struct chtls_sock *csk;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	chtls_purge_recv_queue(sk);
 	csk->ulp_mode = ULP_MODE_NONE;
 	chtls_purge_write_queue(sk);
@@ -454,7 +514,7 @@ void chtls_destroy_sock(struct sock *sk)
 
 static void reset_listen_child(struct sock *child)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(child);
+	struct chtls_sock *csk = child->sk_user_data;
 	struct sk_buff *skb;
 
 	skb = alloc_ctrl_skb(csk->txdata_skb_cache,
@@ -565,7 +625,7 @@ static void cleanup_syn_rcv_conn(struct sock *child, struct sock *parent)
 	struct request_sock *req;
 	struct chtls_sock *csk;
 
-	csk = rcu_dereference_sk_user_data(child);
+	csk = child->sk_user_data;
 	req = csk->passive_reap_next;
 
 	reqsk_queue_removed(&inet_csk(parent)->icsk_accept_queue, req);
@@ -705,6 +765,22 @@ static int chtls_pass_open_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
 	return 0;
 }
 
+static void conn_remove_handle(struct chtls_dev *cdev, int tid)
+{
+	spin_lock(&cdev->aidr_lock);
+	idr_remove(&cdev->aidr, tid);
+	spin_unlock(&cdev->aidr_lock);
+}
+
+static void free_atid(struct chtls_sock *csk, struct chtls_dev *cdev,
+		      unsigned int atid)
+{
+	conn_remove_handle(cdev, atid);
+	cxgb4_free_atid(cdev->tids, atid);
+	sock_put(csk->sk);
+	kref_put(&csk->kref, chtls_sock_release);
+}
+
 static int chtls_close_listsrv_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
 {
 	struct cpl_close_listsvr_rpl *rpl = cplhdr(skb) + RSS_HDR;
@@ -732,7 +808,7 @@ static int chtls_close_listsrv_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
 
 static void chtls_release_resources(struct sock *sk)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct chtls_dev *cdev = csk->cdev;
 	unsigned int tid = csk->tid;
 	struct tid_info *tids;
@@ -810,7 +886,7 @@ static void chtls_pass_open_arp_failure(struct sock *sk,
 	struct sock *parent;
 	void *data;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	cdev = csk->cdev;
 
 	/*
@@ -905,6 +981,304 @@ static unsigned int select_rcv_wscale(int space, int wscale_ok, int win_clamp)
 	return wscale;
 }
 
+/* Active Open Processing */
+static int chtls_conn_insert_hdl(struct chtls_dev *cdev, struct sock *sk,
+				 int tid)
+{
+	int id;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock_bh(&cdev->aidr_lock);
+	id = idr_alloc(&cdev->aidr, sk, tid, tid + 1, GFP_NOWAIT);
+	spin_unlock_bh(&cdev->aidr_lock);
+	idr_preload_end();
+	return id;
+}
+
+static void chtls_act_open_fail(struct sock *sk, int errno)
+{
+	sk->sk_err = errno;
+	sk->sk_error_report(sk);
+	chtls_release_resources(sk);
+	chtls_conn_done(sk);
+	TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+}
+
+static void chtls_deferred_connect(struct chtls_dev *cdev, struct sk_buff *skb)
+{
+	struct sock *sk =  skb->sk;
+	struct inet_sock *inet = inet_sk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+	int err;
+
+	kfree_skb(skb);
+	lock_sock(sk);
+	if (sk->sk_state == TCP_SYN_SENT) {
+		if (sk->sk_user_data)
+			chtls_release_resources(sk);
+		if (!tp->write_seq) {
+			if (sk->sk_family == AF_INET)
+				tp->write_seq = (prandom_u32() & ~7UL) - 1;
+		}
+		inet->inet_id = tp->write_seq ^ jiffies;
+		err = tcp_connect(sk);
+		if (err)
+			goto failure;
+	}
+	release_sock(sk);
+	return;
+failure:
+	tcp_set_state(sk, TCP_CLOSE);
+	sk->sk_route_caps = 0;
+	inet->inet_dport = 0;
+	sk->sk_err = err;
+	sk->sk_error_report(sk);
+	TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+	release_sock(sk);
+}
+
+static int act_open_rpl_status_to_errno(int status)
+{
+	switch (status) {
+	case CPL_ERR_CONN_RESET:
+		return -ECONNREFUSED;
+	case CPL_ERR_ARP_MISS:
+		return -EHOSTUNREACH;
+	case CPL_ERR_CONN_TIMEDOUT:
+		return -ETIMEDOUT;
+	case CPL_ERR_TCAM_FULL:
+		return -ENOMEM;
+	case CPL_ERR_CONN_EXIST:
+		return -EADDRINUSE;
+	default:
+		return -EIO;
+	}
+}
+
+static unsigned long long calc_opt0(struct sock *sk, int nagle)
+{
+	const struct tcp_sock *tp;
+	struct chtls_sock *csk;
+
+	csk = sk->sk_user_data;
+	tp = tcp_sk(sk);
+
+	if (likely(nagle == -1))
+		nagle = ((tp->nonagle & TCP_NAGLE_OFF) == 0);
+
+	return NAGLE_V(nagle) |
+		TCAM_BYPASS_F |
+		KEEP_ALIVE_V(sock_flag(sk, SOCK_KEEPOPEN) != 0) |
+		WND_SCALE_V(RCV_WSCALE(tp)) |
+		MSS_IDX_V(csk->mtu_idx) |
+		DSCP_V((inet_sk(sk)->tos >> 2) & 0x3F) |
+		ULP_MODE_V(ULP_MODE_TLS) |
+		RCV_BUFSIZ_V(min(tp->rcv_wnd >> 10, RCV_BUFSIZ_M));
+}
+
+static void chtls_act_open_rqst(struct sock *sk, struct sk_buff *skb,
+				unsigned int qid_atid,
+				const struct l2t_entry *e)
+{
+	struct cpl_t6_act_open_req *req;
+	struct chtls_sock *csk;
+	unsigned int opt2;
+	u32 isn;
+
+	csk = sk->sk_user_data;
+	req = (struct cpl_t6_act_open_req *)__skb_put(skb, sizeof(*req));
+	INIT_TP_WR(req, 0);
+	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_ACT_OPEN_REQ, qid_atid));
+	set_wr_txq(skb, CPL_PRIORITY_SETUP, csk->port_id);
+	req->local_port = inet_sk(sk)->inet_sport;
+	req->peer_port = inet_sk(sk)->inet_dport;
+	req->local_ip = inet_sk(sk)->inet_saddr;
+	req->peer_ip = inet_sk(sk)->inet_daddr;
+	req->opt0 = cpu_to_be64(calc_opt0(sk, 0) |
+				L2T_IDX_V(e->idx) |
+				SMAC_SEL_V(csk->smac_idx) |
+				ULP_MODE_V(csk->ulp_mode) |
+				TX_CHAN_V(csk->tx_chan));
+	isn = (prandom_u32() & ~7UL) - 1;
+	req->rsvd = cpu_to_be32(isn);
+	req->params =
+	cpu_to_be64(FILTER_TUPLE_V(cxgb4_select_ntuple(csk->egress_dev,
+						       csk->l2t_entry)));
+	opt2 = RX_CHANNEL_V(0) |
+		TX_QUEUE_V(csk->cdev->lldi->tx_modq[csk->tx_chan]) |
+		RSS_QUEUE_VALID_F |
+		RSS_QUEUE_V(csk->rss_qid) |
+		T5_ISS_F |
+		RX_FC_DISABLE_F |
+		T5_OPT_2_VALID_F |
+		RX_FC_VALID_F;
+
+	if (sock_net(sk)->ipv4.sysctl_tcp_window_scaling)
+		opt2 |= WND_SCALE_EN_F;
+	if (sock_net(sk)->ipv4.sysctl_tcp_timestamps)
+		opt2 |= TSTAMPS_EN_F;
+	if (tcp_sk(sk)->ecn_flags & TCP_ECN_OK)
+		opt2 |= CCTRL_ECN_F;
+	if (sock_net(sk)->ipv4.sysctl_tcp_sack)
+		opt2 |= SACK_EN_F;
+	opt2 |= CONG_CNTRL_V(CONG_ALG_NEWRENO);
+	req->opt2 = cpu_to_be32(opt2);
+	req->rsvd2 = cpu_to_be32(0);
+	req->opt3 = cpu_to_be32(0);
+}
+
+static void act_open_retry_timer(struct timer_list *t)
+{
+	struct inet_connection_sock *icsk;
+	struct sk_buff *skb;
+	struct sock *sk;
+	int len;
+
+	sk = from_timer(sk, t, sk_timer);
+	icsk = inet_csk(sk);
+	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		sk_reset_timer(sk, &icsk->icsk_retransmit_timer,
+			       jiffies + HZ / 20);
+	} else {
+		len = roundup(sizeof(struct cpl_t6_act_open_req6), 16);
+		skb = alloc_skb(len, GFP_ATOMIC);
+		if (!skb) {
+			chtls_act_open_fail(sk, ENOMEM);
+		} else {
+			struct chtls_sock *csk;
+			struct chtls_dev *cdev;
+			unsigned int qid_atid;
+
+			csk = sk->sk_user_data;
+			cdev = csk->cdev;
+			qid_atid = csk->rss_qid << 14 | csk->tid;
+			skb->sk = sk;
+			t4_set_arp_err_handler(skb, NULL,
+					       chtls_connect_req_arp_failure);
+			chtls_act_open_rqst(sk, skb, qid_atid, csk->l2t_entry);
+			cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
+		}
+	}
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+/*
+ * Add an skb to the deferred skb queue for processing from process context.
+ */
+static void chtls_defer_reply(struct sk_buff *skb, struct chtls_dev *cdev,
+			      defer_handler_t handler)
+{
+	DEFERRED_SKB_CB(skb)->handler = handler;
+	spin_lock_bh(&cdev->deferq.lock);
+	__skb_queue_tail(&cdev->deferq, skb);
+	if (skb_queue_len(&cdev->deferq) == 1)
+		schedule_work(&cdev->deferq_task);
+	spin_unlock_bh(&cdev->deferq.lock);
+}
+
+static void chtls_active_open_rpl(struct sock *sk, struct sk_buff *skb)
+{
+	struct cpl_act_open_rpl *rpl = cplhdr(skb) + RSS_HDR;
+	struct inet_connection_sock *icsk;
+	struct chtls_dev *cdev;
+	struct chtls_sock *csk;
+	unsigned int status;
+	int err;
+
+	icsk = inet_csk(sk);
+	status = AOPEN_STATUS_G(be32_to_cpu(rpl->atid_status));
+	if (is_neg_adv(status)) {
+		struct chtls_dev *cdev;
+		unsigned int tid;
+
+		csk = sk->sk_user_data;
+		cdev = csk->cdev;
+		tid = GET_TID(rpl);
+
+		if (csk_flag(sk, CSK_ABORT_RPL_PENDING)) {
+			if (!lookup_tid(cdev->tids, tid))
+				csk->idr = sk_insert_tid(cdev, sk, tid);
+		}
+		csk->neg_adv_tid = tid;
+		fixup_and_send_ofo(csk, tid);
+		kfree_skb(skb);
+		return;
+	}
+
+	if (status) {
+		if (status == CPL_ERR_CONN_EXIST &&
+		    icsk->icsk_retransmit_timer.function !=
+		    act_open_retry_timer) {
+			icsk->icsk_retransmit_timer.function =
+				act_open_retry_timer;
+			sk_reset_timer(sk, &icsk->icsk_retransmit_timer,
+				       jiffies + HZ / 2);
+			kfree_skb(skb);
+		} else if (status == CPL_ERR_TCAM_PARITY ||
+			   status == CPL_ERR_TCAM_FULL) {
+			csk = sk->sk_user_data;
+			cdev = csk->cdev;
+			skb->sk = sk;
+			chtls_defer_reply(skb, cdev, chtls_deferred_connect);
+		} else {
+			err = act_open_rpl_status_to_errno(status);
+			if (err == EADDRINUSE) {
+				csk = sk->sk_user_data;
+				cdev = csk->cdev;
+				skb->sk = sk;
+				chtls_defer_reply(skb, cdev,
+						  chtls_deferred_connect);
+			}
+		}
+	} else {
+		kfree_skb(skb);
+	}
+}
+
+static void chtls_connect_req_arp_failure(void *handle, struct sk_buff *skb)
+{
+	struct sock *sk = skb->sk;
+
+	sock_hold(sk);
+	bh_lock_sock(sk);
+	if (sk->sk_state == TCP_SYN_SENT || sk->sk_state == TCP_SYN_RECV) {
+		if (!sock_owned_by_user(sk)) {
+			chtls_act_open_fail(sk, EHOSTUNREACH);
+			__kfree_skb(skb);
+		} else {
+			struct cpl_act_open_rpl *rpl = cplhdr(skb) + RSS_HDR;
+
+			rpl->ot.opcode = CPL_ACT_OPEN_RPL;
+			rpl->atid_status = CPL_ERR_ARP_MISS;
+			BLOG_SKB_CB(skb)->backlog_rcv = chtls_active_open_rpl;
+			__sk_add_backlog(sk, skb);
+		}
+	}
+	bh_unlock_sock(sk);
+	sock_put(sk);
+}
+
+static void chtls_write_space(struct sock *sk)
+{
+	struct socket *sock = sk->sk_socket;
+	struct socket_wq *wq;
+
+	if (sk_stream_wspace(sk) >= sk_stream_min_wspace(sk) && sock) {
+		clear_bit(SOCK_NOSPACE, &sock->flags);
+		rcu_read_lock();
+		wq = rcu_dereference(sk->sk_wq);
+		if (skwq_has_sleeper(sk->sk_wq))
+			wake_up_interruptible_poll(&wq->wait, POLLOUT |
+						   POLLWRNORM |
+						   POLLWRBAND);
+		if (wq && wq->fasync_list && !(sk->sk_shutdown & SEND_SHUTDOWN))
+			sock_wake_async(wq, SOCK_WAKE_SPACE, POLL_OUT);
+		rcu_read_unlock();
+	}
+}
+
 static void chtls_pass_accept_rpl(struct sk_buff *skb,
 				  struct cpl_pass_accept_req *req,
 				  unsigned int tid)
@@ -1008,6 +1382,114 @@ static void chtls_set_tcp_window(struct chtls_sock *csk)
 		csk->snd_win *= scale;
 }
 
+int chtls_active_open(struct chtls_dev *cdev, struct sock *sk,
+		      struct net_device *ndev)
+{
+	struct dst_entry *dst = __sk_dst_get(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct chtls_sock *csk;
+	unsigned int qid_atid;
+	struct sk_buff *skb;
+	struct neighbour *n;
+	unsigned int len;
+	struct net *net;
+	bool use_ecn;
+	u16 port_id;
+	int rxq_idx;
+	int step;
+	int atid;
+	int id;
+
+	csk = chtls_sock_create(cdev);
+	if (!csk)
+		return -ENOMEM;
+
+	atid = cxgb4_alloc_atid(cdev->tids, csk);
+	if (atid < 0)
+		goto free_csk;
+
+	id = chtls_conn_insert_hdl(cdev, sk, atid);
+	if (id < 0)
+		goto free_atid;
+
+	sock_hold(sk);
+	csk->sk = sk;
+	csk->egress_dev = ndev;
+	sk->sk_user_data = csk;
+	if (sk->sk_family == AF_INET) {
+		n = dst_neigh_lookup(dst, &inet_sk(sk)->inet_daddr);
+		if (!n)
+			goto free_atid;
+	}
+	port_id = cxgb4_port_idx(ndev);
+
+	csk->l2t_entry = cxgb4_l2t_get(cdev->lldi->l2t, n, ndev, 0);
+	if (!csk->l2t_entry)
+		goto free_atid;
+	neigh_release(n);
+	net = sock_net(sk);
+	tp->ecn_flags = 0;
+	use_ecn = (net->ipv4.sysctl_tcp_ecn == 1) || tcp_ca_needs_ecn(sk);
+	if (!use_ecn) {
+		if (dst && dst_feature(dst, RTAX_FEATURE_ECN))
+			use_ecn = true;
+	}
+	if (use_ecn)
+		tp->ecn_flags = TCP_ECN_OK;
+
+	len = roundup(sizeof(struct cpl_t6_act_open_req6), 16);
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		goto free_atid;
+	skb->sk = sk;
+	t4_set_arp_err_handler(skb, sk, chtls_connect_req_arp_failure);
+	kref_get(&csk->kref);
+
+	chtls_install_cpl_ops(sk);
+	sk->sk_backlog_rcv = chtls_backlog_rcv;
+	csk->tx_chan = cxgb4_port_chan(ndev);
+	csk->tid = atid;
+	if (!tp->window_clamp)
+		tp->window_clamp = dst_metric(dst, RTAX_WINDOW);
+	chtls_write_space(sk);
+	csk_set_flag(csk, CSK_CONN_INLINE);
+	csk->wr_max_credits = 64;
+	csk->wr_credits = 64;
+	csk->wr_unacked = 0;
+	csk->delack_mode = 0;
+	chtls_set_tcp_window(csk);
+	tp->rcv_wnd = csk->rcv_win;
+	csk->sndbuf = csk->snd_win;
+	csk->ulp_mode = ULP_MODE_TLS;
+	step = cdev->lldi->nrxq / cdev->lldi->nchan;
+	csk->port_id = port_id;
+	csk->rss_qid = cdev->lldi->rxq_ids[port_id * step];
+	rxq_idx = port_id * step;
+	csk->txq_idx = (rxq_idx < cdev->lldi->ntxq) ? rxq_idx :
+		port_id * step;
+	csk->mtu_idx = chtls_select_mss(csk, dst_mtu(dst), 0);
+	RCV_WSCALE(tp) = select_rcv_wscale(tcp_full_space(sk),
+					   sock_net(sk)->
+					   ipv4.sysctl_tcp_window_scaling,
+					   tp->window_clamp);
+	sk->sk_err = 0;
+	sock_reset_flag(sk, SOCK_DONE);
+	TCP_INC_STATS(sock_net(sk), TCP_MIB_ACTIVEOPENS);
+	csk->smac_idx = ((struct port_info *)netdev_priv(ndev))->smt_idx;
+	qid_atid = csk->rss_qid << 14;
+	qid_atid |= (unsigned int)atid;
+
+	chtls_act_open_rqst(sk, skb, qid_atid, csk->l2t_entry);
+	cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
+	return 0;
+free_atid:
+	free_atid(csk, cdev, atid);
+free_csk:
+	chtls_sock_release(&csk->kref);
+
+	return -1;
+}
+
 static struct sock *chtls_recv_sock(struct sock *lsk,
 				    struct request_sock *oreq,
 				    void *network_hdr,
@@ -1238,7 +1720,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 	reply_skb->sk = newsk;
 	chtls_install_cpl_ops(newsk);
 	cxgb4_insert_tid(cdev->tids, newsk, tid, newsk->sk_family);
-	csk = rcu_dereference_sk_user_data(newsk);
+	csk = sk->sk_user_data;
 	listen_ctx = (struct listen_ctx *)lookup_stid(cdev->tids, stid);
 	csk->listen_ctx = listen_ctx;
 	__skb_queue_tail(&listen_ctx->synq, (struct sk_buff *)&csk->synq);
@@ -1330,7 +1812,7 @@ static void chtls_abort_conn(struct sock *sk, struct sk_buff *skb)
 	spin_lock_bh(&reap_list_lock);
 	while (reap_list) {
 		struct sock *sk = reap_list;
-		struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+		struct chtls_sock *csk = sk->sk_user_data;
 
 		reap_list = csk->passive_reap_next;
 		csk->passive_reap_next = NULL;
@@ -1514,7 +1996,7 @@ static void chtls_recv_data(struct sock *sk, struct sk_buff *skb)
 	struct chtls_sock *csk;
 	struct tcp_sock *tp;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	tp = tcp_sk(sk);
 
 	if (unlikely(sk->sk_shutdown & RCV_SHUTDOWN)) {
@@ -1577,7 +2059,7 @@ static void chtls_recv_pdu(struct sock *sk, struct sk_buff *skb)
 	struct chtls_hws *tlsk;
 	struct tcp_sock *tp;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	tlsk = &csk->tlshws;
 	tp = tcp_sk(sk);
 
@@ -1640,7 +2122,7 @@ static void chtls_rx_hdr(struct sock *sk, struct sk_buff *skb)
 	struct tcp_sock *tp;
 
 	cmp_cpl = cplhdr(skb);
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	tlsk = &csk->tlshws;
 	tp = tcp_sk(sk);
 
@@ -1704,7 +2186,7 @@ static void chtls_timewait(struct sock *sk)
 
 static void chtls_peer_close(struct sock *sk, struct sk_buff *skb)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 
 	sk->sk_shutdown |= RCV_SHUTDOWN;
 	sock_set_flag(sk, SOCK_DONE);
@@ -1746,7 +2228,7 @@ static void chtls_close_con_rpl(struct sock *sk, struct sk_buff *skb)
 	struct chtls_sock *csk;
 	struct tcp_sock *tp;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	tp = tcp_sk(sk);
 
 	tp->snd_una = ntohl(rpl->snd_nxt) - 1;  /* exclude FIN */
@@ -1825,7 +2307,7 @@ static void send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 	struct sk_buff *reply_skb;
 	struct chtls_sock *csk;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 
 	reply_skb = alloc_skb(sizeof(struct cpl_abort_rpl),
 			      GFP_KERNEL);
@@ -1874,7 +2356,7 @@ static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 	struct chtls_sock *csk;
 	unsigned int tid;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	tid = GET_TID(req);
 
 	reply_skb = get_cpl_skb(skb, sizeof(struct cpl_abort_rpl), gfp_any());
@@ -1909,7 +2391,7 @@ static void bl_abort_syn_rcv(struct sock *lsk, struct sk_buff *skb)
 	int queue;
 
 	child = skb->sk;
-	csk = rcu_dereference_sk_user_data(child);
+	csk = child->sk_user_data;
 	queue = csk->txq_idx;
 
 	skb->sk	= NULL;
@@ -2006,7 +2488,7 @@ static void chtls_abort_rpl_rss(struct sock *sk, struct sk_buff *skb)
 	struct chtls_sock *csk;
 	struct chtls_dev *cdev;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	cdev = csk->cdev;
 
 	if (csk_flag_nochk(csk, CSK_ABORT_RPL_PENDING)) {
@@ -2067,7 +2549,7 @@ static int chtls_conn_cpl(struct chtls_dev *cdev, struct sk_buff *skb)
 
 static struct sk_buff *dequeue_wr(struct sock *sk)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct sk_buff *skb = csk->wr_skb_head;
 
 	if (likely(skb)) {
@@ -2105,10 +2587,11 @@ static void chtls_rx_ack(struct sock *sk, struct sk_buff *skb)
 		if (unlikely(credits < csum)) {
 			pskb->csum = (__force __wsum)(csum - credits);
 			break;
+		} else {
+			dequeue_wr(sk);
+			credits -= csum;
+			kfree_skb(pskb);
 		}
-		dequeue_wr(sk);
-		credits -= csum;
-		kfree_skb(pskb);
 	}
 	if (hdr->seq_vld & CPL_FW4_ACK_FLAGS_SEQVAL) {
 		if (unlikely(before(snd_una, tp->snd_una))) {
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.h b/drivers/crypto/chelsio/chtls/chtls_cm.h
index 78eb3af..ca3ccb7 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.h
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.h
@@ -106,9 +106,6 @@ struct deferred_skb_cb {
 #define skb_ulp_tls_inline(skb)      (ULP_SKB_CB(skb)->ulp.tls.ofld)
 #define skb_ulp_tls_iv_imm(skb)      (ULP_SKB_CB(skb)->ulp.tls.iv)
 
-void chtls_defer_reply(struct sk_buff *skb, struct chtls_dev *dev,
-		       defer_handler_t handler);
-
 /*
  * Returns true if the socket is in one of the supplied states.
  */
@@ -200,4 +197,7 @@ static inline void enqueue_wr(struct chtls_sock *csk, struct sk_buff *skb)
 		WR_SKB_CB(csk->wr_skb_tail)->next_wr = skb;
 	csk->wr_skb_tail = skb;
 }
+
+int chtls_active_open(struct chtls_dev *cdev, struct sock *sk,
+		      struct net_device *ndev);
 #endif
diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c b/drivers/crypto/chelsio/chtls/chtls_hw.c
index 4909607..6266b9e 100644
--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -50,7 +50,7 @@ static void __set_tcb_field(struct sock *sk, struct sk_buff *skb, u16 word,
 	unsigned int wrlen;
 
 	wrlen = roundup(sizeof(*req) + sizeof(*sc), 16);
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 
 	req = (struct cpl_set_tcb_field *)__skb_put(skb, wrlen);
 	__set_tcb_field_direct(csk, req, word, mask, val, cookie, no_reply);
@@ -78,7 +78,7 @@ static int chtls_set_tcb_field(struct sock *sk, u16 word, u64 mask, u64 val)
 		return -ENOMEM;
 
 	credits_needed = DIV_ROUND_UP(wrlen, 16);
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 
 	__set_tcb_field(sk, skb, word, mask, val, 0, 1);
 	skb_set_queue_mapping(skb, (csk->txq_idx << 1) | CPL_PRIORITY_DATA);
@@ -166,7 +166,7 @@ static int get_new_keyid(struct chtls_sock *csk, u32 optname)
 
 void free_tls_keyid(struct sock *sk)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct net_device *dev = csk->egress_dev;
 	struct chtls_dev *cdev = csk->cdev;
 	struct chtls_hws *hws;
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index dd2daf2..dd62969 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -16,6 +16,7 @@
 #include <linux/net.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
+#include <net/secure_seq.h>
 #include <net/tcp.h>
 #include <net/tls.h>
 
@@ -160,6 +161,159 @@ static void chtls_destroy_hash(struct tls_device *dev, struct sock *sk)
 		chtls_stop_listen(cdev, sk);
 }
 
+static int chtls_ndev_found(struct chtls_dev *cdev, struct net_device *ndev)
+{
+	int i;
+
+	for (i = 0; i < cdev->lldi->nports; i++)
+		if (ndev == cdev->ports[i])
+			return 1;
+	return 0;
+}
+
+static int chtls_connect(struct tls_device *dev, struct sock *sk,
+			 struct sockaddr *uaddr, int addr_len)
+{
+	struct sockaddr_in *usin = (struct sockaddr_in *)uaddr;
+	struct inet_sock *inet = inet_sk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct ip_options_rcu *inet_opt;
+	__be16 orig_sport, orig_dport;
+	struct net_device *netdev;
+	struct chtls_dev *cdev;
+	__be32 daddr, nexthop;
+	struct flowi4 *fl4;
+	struct rtable *rt;
+	int err;
+	struct inet_timewait_death_row *tcp_death_row =
+		&sock_net(sk)->ipv4.tcp_death_row;
+
+	if (addr_len < sizeof(struct sockaddr_in))
+		return -EINVAL;
+
+	if (usin->sin_family != AF_INET)
+		return -EAFNOSUPPORT;
+
+	nexthop = usin->sin_addr.s_addr;
+	daddr = usin->sin_addr.s_addr;
+	inet_opt = rcu_dereference_protected(inet->inet_opt,
+					     lockdep_sock_is_held(sk));
+	if (inet_opt && inet_opt->opt.srr) {
+		if (!daddr)
+			return -EINVAL;
+
+		nexthop = inet_opt->opt.faddr;
+	}
+
+	orig_sport = inet->inet_sport;
+	orig_dport = usin->sin_port;
+	fl4 = &inet->cork.fl.u.ip4;
+	rt = ip_route_connect(fl4, nexthop, inet->inet_saddr,
+			      RT_CONN_FLAGS(sk), sk->sk_bound_dev_if,
+			      IPPROTO_TCP,
+			      orig_sport, orig_dport, sk);
+	if (IS_ERR(rt)) {
+		err = PTR_ERR(rt);
+		if (err == -ENETUNREACH)
+			IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
+		return err;
+	}
+
+	if (rt->rt_flags & (RTCF_MULTICAST | RTCF_BROADCAST)) {
+		ip_rt_put(rt);
+		return -ENETUNREACH;
+	}
+
+	if (!inet_opt || !inet_opt->opt.srr)
+		daddr = fl4->daddr;
+
+	if (!inet->inet_saddr)
+		inet->inet_saddr = fl4->saddr;
+	sk_rcv_saddr_set(sk, inet->inet_saddr);
+
+	if (tp->rx_opt.ts_recent_stamp && inet->inet_daddr != daddr) {
+		/* Reset inherited state */
+		tp->rx_opt.ts_recent       = 0;
+		tp->rx_opt.ts_recent_stamp = 0;
+		if (likely(!tp->repair))
+			tp->write_seq = 0;
+	}
+
+	inet->inet_dport = usin->sin_port;
+	sk_daddr_set(sk, daddr);
+
+	inet_csk(sk)->icsk_ext_hdr_len = 0;
+	if (inet_opt)
+		inet_csk(sk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
+
+	tp->rx_opt.mss_clamp = TCP_MSS_DEFAULT;
+
+	/* Socket identity is still unknown (sport may be zero).
+	 * However we set state to SYN-SENT and not releasing socket
+	 * lock select source port, enter ourselves into the hash tables and
+	 * complete initialization after this.
+	 */
+	tcp_set_state(sk, TCP_SYN_SENT);
+	err = inet_hash_connect(tcp_death_row, sk);
+	if (err)
+		goto failure;
+
+	sk_set_txhash(sk);
+
+	rt = ip_route_newports(fl4, rt, orig_sport, orig_dport,
+			       inet->inet_sport, inet->inet_dport, sk);
+	if (IS_ERR(rt)) {
+		err = PTR_ERR(rt);
+		rt = NULL;
+		goto failure;
+	}
+	/* OK, now commit destination to socket.  */
+	sk->sk_gso_type = SKB_GSO_TCPV4;
+	sk_setup_caps(sk, &rt->dst);
+
+	cdev = to_chtls_dev(dev);
+	netdev = __sk_dst_get(sk)->dev;
+	if (!chtls_ndev_found(cdev, netdev)) {
+		err = -ENETUNREACH;
+		rt = NULL;
+		goto failure;
+	}
+
+	err = chtls_active_open(cdev, sk, netdev);
+	if (!err)
+		return 0;
+	rt = NULL;
+
+	if (likely(!tp->repair)) {
+		if (!tp->write_seq)
+			tp->write_seq = secure_tcp_seq(inet->inet_saddr,
+						       inet->inet_daddr,
+						       inet->inet_sport,
+						       usin->sin_port);
+		tp->tsoffset = secure_tcp_ts_off(sock_net(sk),
+						 inet->inet_saddr,
+						 inet->inet_daddr);
+	}
+
+	inet->inet_id = tp->write_seq ^ jiffies;
+	if (tcp_fastopen_defer_connect(sk, &err))
+		return err;
+	if (err)
+		goto failure;
+
+	err = tcp_connect(sk);
+	if (err)
+		goto failure;
+
+	return 0;
+failure:
+	tcp_set_state(sk, TCP_CLOSE);
+	ip_rt_put(rt);
+	sk->sk_route_caps = 0;
+	inet->inet_dport = 0;
+	return err;
+}
+
 static void chtls_free_uld(struct chtls_dev *cdev)
 {
 	int i;
@@ -194,6 +348,7 @@ static void chtls_register_dev(struct chtls_dev *cdev)
 	tlsdev->feature = chtls_inline_feature;
 	tlsdev->hash = chtls_create_hash;
 	tlsdev->unhash = chtls_destroy_hash;
+	tlsdev->connect = chtls_connect;
 	tlsdev->release = chtls_dev_release;
 	kref_init(&tlsdev->kref);
 	tls_register_device(tlsdev);
@@ -269,6 +424,8 @@ static void *chtls_uld_add(const struct cxgb4_lld_info *info)
 	INIT_WORK(&cdev->deferq_task, process_deferq);
 	spin_lock_init(&cdev->listen_lock);
 	spin_lock_init(&cdev->idr_lock);
+	spin_lock_init(&cdev->aidr_lock);
+	idr_init(&cdev->aidr);
 	cdev->send_page_order = min_t(uint, get_order(32768),
 				      send_page_order);
 	cdev->max_host_sndbuf = 48 * 1024;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index b2a618e..8aa47b3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -158,7 +158,9 @@ struct fw_wr_hdr {
 
 /* length in units of 16-bytes (lo) */
 #define FW_WR_LEN16_S           0
+#define FW_WR_LEN16_M		0xff
 #define FW_WR_LEN16_V(x)        ((x) << FW_WR_LEN16_S)
+#define FW_WR_LEN16_G(x)	(((x) >> FW_WR_LEN16_S) & FW_WR_LEN16_M)
 
 #define HW_TPL_FR_MT_PR_IV_P_FC         0X32B
 #define HW_TPL_FR_MT_PR_OV_P_FC         0X327
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index af6ad46..68cee56 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -123,6 +123,7 @@ u32 secure_tcp_ts_off(const struct net *net, __be32 saddr, __be32 daddr)
 	return siphash_2u32((__force u32)saddr, (__force u32)daddr,
 			    &ts_secret);
 }
+EXPORT_SYMBOL_GPL(secure_tcp_ts_off);
 
 /* secure_tcp_seq_and_tsoff(a, b, 0, d) == secure_ipv4_port_ephemeral(a, b, d),
  * but fortunately, `sport' cannot be 0 in any circumstances. If this changes,
-- 
1.8.3.1

