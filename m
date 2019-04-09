Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D60C10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F2F2208C0
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbfDIPYx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:24:53 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:2401 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfDIPYx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 11:24:53 -0400
Received: from beagle7.asicdesigners.com (beagle7.asicdesigners.com [10.192.192.157])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x39FOhTQ003425;
        Tue, 9 Apr 2019 08:24:43 -0700
From:   Atul Gupta <atul.gupta@chelsio.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com, atul.gupta@chelsio.com
Subject: [crypto 3/4] crypto/chelsio/chtls: CPL for TLS client
Date:   Tue,  9 Apr 2019 08:24:41 -0700
Message-Id: <20190409152441.11256-1-atul.gupta@chelsio.com>
X-Mailer: git-send-email 2.20.0.rc2.7.g965798d
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CPL processing for Inline TLS client. Exchange messages with
hardware to setup connection.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls.h        |  12 +-
 drivers/crypto/chelsio/chtls/chtls_cm.c     | 306 +++++++++++++++++++++++-----
 drivers/crypto/chelsio/chtls/chtls_cm.h     |   3 +
 drivers/crypto/chelsio/chtls/chtls_hw.c     |   1 +
 drivers/crypto/chelsio/chtls/chtls_io.c     |  51 ++---
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h |  18 ++
 6 files changed, 309 insertions(+), 82 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index 9742613..a14ed26 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -44,6 +44,7 @@
 #define SCMD_CIPH_MODE_AES_GCM		2
 /* Any MFS size should work and come from openssl */
 #define TLS_MFS				16384
+#define INVALID_TID			0xffffffffU
 
 #define RSS_HDR sizeof(struct rss_header)
 #define TLS_WR_CPL_LEN \
@@ -221,7 +222,8 @@ struct chtls_sock {
 	u32 smac_idx;
 	u8 port_id;
 	u8 tos;
-	u16 resv2;
+	u8 hsk_done;
+	u8 resv2;
 	u32 delack_mode;
 	u32 delack_seq;
 	u32 snd_win;
@@ -229,6 +231,8 @@ struct chtls_sock {
 
 	void *passive_reap_next;        /* placeholder for passive */
 	struct chtls_hws tlshws;
+	struct delayed_work hsk_work;
+#define TLS_CLIENT_WQ_CLR       0x1
 	struct synq {
 		struct sk_buff *next;
 		struct sk_buff *prev;
@@ -457,9 +461,11 @@ static inline void __chtls_sock_get(const char *fn,
 static inline void send_or_defer(struct sock *sk, struct tcp_sock *tp,
 				 struct sk_buff *skb, int through_l2t)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 
-	if (through_l2t) {
+	if (unlikely(sk->sk_state == TCP_SYN_SENT)) {
+		__skb_queue_tail(&csk->ooq, skb);
+	} else if (through_l2t) {
 		/* send through L2T */
 		cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
 	} else {
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 16140b2..25a23e7 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -51,6 +51,59 @@
 	/* TCP_CLOSING     */ TCP_CLOSING,
 };
 
+void chtls_sock_release(struct kref *ref)
+{
+	struct chtls_sock *csk =
+		container_of(ref, struct chtls_sock, kref);
+
+	kfree(csk);
+}
+
+static int chtls_send_tls_rxmod(struct sock *sk)
+{
+	struct cpl_rx_data_ack *req;
+	struct chtls_sock *csk;
+	struct sk_buff *skb;
+
+	csk = sk->sk_user_data;
+	skb = alloc_skb(sizeof(*req), GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
+	req = (struct cpl_rx_data_ack *)__skb_put(skb, sizeof(*req));
+	memset(req, 0, sizeof(*req));
+	INIT_TP_WR_CPL(req, CPL_RX_DATA_ACK, csk->tid);
+	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_RX_DATA_ACK, csk->tid));
+	req->credit_dack = htonl(RX_MODULATE_RX_F);
+	skb_set_queue_mapping(skb, (csk->txq_idx << 1) | CPL_PRIORITY_ACK);
+	cxgb4_ofld_send(csk->egress_dev, skb);
+
+	if (!(csk->hsk_done & TLS_CLIENT_WQ_CLR))
+		schedule_delayed_work(&csk->hsk_work, TLS_SRV_HELLO_RD_TM);
+
+	return 0;
+}
+
+static void handshake_work(struct work_struct *work)
+{
+	struct chtls_sock *csk =
+		container_of(work, struct chtls_sock, hsk_work.work);
+	struct sock *sk = csk->sk;
+
+	lock_sock(sk);
+	if (!(sk->sk_state == TCP_CLOSE ||
+	      sk->sk_state == TCP_TIME_WAIT ||
+	      csk->hsk_done != TLS_CLIENT_WQ_CLR)) {
+		if (chtls_send_tls_rxmod(sk))
+			schedule_delayed_work(&csk->hsk_work,
+					      TLS_SRV_HELLO_RD_TM);
+	} else {
+		kref_put(&csk->kref, chtls_sock_release);
+		sock_put(sk);
+	}
+	release_sock(sk);
+}
+
 static struct chtls_sock *chtls_sock_create(struct chtls_dev *cdev)
 {
 	struct chtls_sock *csk = kzalloc(sizeof(*csk), GFP_ATOMIC);
@@ -76,17 +129,10 @@ static struct chtls_sock *chtls_sock_create(struct chtls_dev *cdev)
 	csk->tlshws.rxkey = -1;
 	csk->tlshws.mfs = TLS_MFS;
 	skb_queue_head_init(&csk->tlshws.sk_recv_queue);
+	INIT_DELAYED_WORK(&csk->hsk_work, handshake_work);
 	return csk;
 }
 
-static void chtls_sock_release(struct kref *ref)
-{
-	struct chtls_sock *csk =
-		container_of(ref, struct chtls_sock, kref);
-
-	kfree(csk);
-}
-
 static int bh_insert_handle(struct chtls_dev *cdev, struct sock *sk,
 			    int tid)
 {
@@ -98,6 +144,13 @@ static int bh_insert_handle(struct chtls_dev *cdev, struct sock *sk,
 	return id;
 }
 
+static void bh_remove_handle(struct chtls_dev *cdev, int tid)
+{
+	spin_lock_bh(&cdev->idr_lock);
+	idr_remove(&cdev->hwtid_idr, tid);
+	spin_unlock_bh(&cdev->idr_lock);
+}
+
 static int sk_insert_tid(struct chtls_dev *cdev, struct sock *sk,
 			 unsigned int tid)
 {
@@ -179,7 +232,7 @@ static void assign_rxopt(struct sock *sk, unsigned int opt)
 		tp->rx_opt.rcv_wscale = 0;
 	if (tp->rx_opt.tstamp_ok) {
 		tp->tcp_header_len += TCPOLEN_TSTAMP_ALIGNED;
-		tp->rx_opt.mss_clamp -= TCPOLEN_TSTAMP_ALIGNED;
+		tp->mss_cache -= TCPOLEN_TSTAMP_ALIGNED;
 	} else if (csk->opt2 & TSTAMPS_EN_F) {
 		csk->opt2 &= ~TSTAMPS_EN_F;
 		csk->mtu_idx = TCPOPT_MSS_G(opt);
@@ -248,10 +301,21 @@ static void chtls_send_abort(struct sock *sk, int mode, struct sk_buff *skb)
 	struct cpl_abort_req *req;
 	struct chtls_sock *csk;
 	struct tcp_sock *tp;
+	bool use_negadv_tid;
+	unsigned int tid;
 
 	csk = sk->sk_user_data;
 	tp = tcp_sk(sk);
 
+	if (sk->sk_state == TCP_SYN_SENT &&
+	    csk->neg_adv_tid != INVALID_TID) {
+		tid = csk->neg_adv_tid;
+		csk->idr = sk_insert_tid(csk->cdev, sk, tid);
+		use_negadv_tid = true;
+	} else {
+		tid = csk->tid;
+	}
+
 	if (!skb)
 		skb = alloc_ctrl_skb(csk->txdata_skb_cache, sizeof(*req));
 
@@ -261,8 +325,13 @@ static void chtls_send_abort(struct sock *sk, int mode, struct sk_buff *skb)
 	req->rsvd0 = htonl(tp->snd_nxt);
 	req->rsvd1 = !csk_flag_nochk(csk, CSK_TX_DATA_SENT);
 	req->cmd = mode;
-	t4_set_arp_err_handler(skb, csk->cdev, abort_arp_failure);
-	send_or_defer(sk, tp, skb, mode == CPL_ABORT_SEND_RST);
+	if (unlikely(use_negadv_tid)) {
+		__skb_queue_tail(&csk->ooq, skb);
+		fixup_and_send_ofo(csk, tid);
+	} else {
+		t4_set_arp_err_handler(skb, csk->cdev, abort_arp_failure);
+		send_or_defer(sk, tp, skb, mode == CPL_ABORT_SEND_RST);
+	}
 }
 
 static void chtls_send_reset(struct sock *sk, int mode, struct sk_buff *skb)
@@ -467,9 +536,11 @@ static int wait_for_states(struct sock *sk, unsigned int states)
 
 int chtls_disconnect(struct sock *sk, int flags)
 {
+	struct chtls_sock *csk;
 	struct tcp_sock *tp;
 	int err;
 
+	csk = sk->sk_user_data;
 	tp = tcp_sk(sk);
 	chtls_purge_recv_queue(sk);
 	chtls_purge_receive_queue(sk);
@@ -484,6 +555,7 @@ int chtls_disconnect(struct sock *sk, int flags)
 	}
 	chtls_purge_recv_queue(sk);
 	chtls_purge_receive_queue(sk);
+	__skb_queue_purge(&csk->ooq);
 	tp->max_window = 0xFFFF << (tp->rx_opt.snd_wscale);
 	return tcp_disconnect(sk, flags);
 }
@@ -507,6 +579,7 @@ void chtls_destroy_sock(struct sock *sk)
 	csk->ulp_mode = ULP_MODE_NONE;
 	chtls_purge_write_queue(sk);
 	free_tls_keyid(sk);
+	stop_hndsk_work(sk);
 	kref_put(&csk->kref, chtls_sock_release);
 	sk->sk_prot = &tcp_prot;
 	sk->sk_prot->destroy(sk);
@@ -825,8 +898,14 @@ static void chtls_release_resources(struct sock *sk)
 		csk->l2t_entry = NULL;
 	}
 
-	cxgb4_remove_tid(tids, csk->port_id, tid, sk->sk_family);
-	sock_put(sk);
+	if (sk->sk_state == TCP_SYN_SENT) {
+		free_atid(csk, cdev, tid);
+		__skb_queue_purge(&csk->ooq);
+	} else {
+		cxgb4_remove_tid(tids, csk->port_id, tid, sk->sk_family);
+		bh_remove_handle(cdev, csk->idr);
+		sock_put(sk);
+	}
 }
 
 static void chtls_conn_done(struct sock *sk)
@@ -936,7 +1015,7 @@ static unsigned int chtls_select_mss(const struct chtls_sock *csk,
 	unsigned int mss;
 	struct sock *sk;
 
-	mss = ntohs(req->tcpopt.mss);
+	mss = req ? ntohs(req->tcpopt.mss) : 0;
 	sk = csk->sk;
 	dst = __sk_dst_get(sk);
 	cdev = csk->cdev;
@@ -944,7 +1023,7 @@ static unsigned int chtls_select_mss(const struct chtls_sock *csk,
 	tcpoptsz = 0;
 
 	iphdrsz = sizeof(struct iphdr) + sizeof(struct tcphdr);
-	if (req->tcpopt.tstamp)
+	if (sock_net(sk)->ipv4.sysctl_tcp_timestamps)
 		tcpoptsz += round_up(TCPOLEN_TIMESTAMP, 4);
 
 	tp->advmss = dst_metric_advmss(dst);
@@ -1260,6 +1339,155 @@ static void chtls_connect_req_arp_failure(void *handle, struct sk_buff *skb)
 	sock_put(sk);
 }
 
+void chtls_handshake_work(struct sock *sk)
+{
+	struct chtls_sock *csk = sk->sk_user_data;
+
+	sock_hold(sk);
+	kref_get(&csk->kref);
+	schedule_delayed_work(&csk->hsk_work, TLS_SRV_HELLO_BKOFF_TM);
+}
+
+void stop_hndsk_work(struct sock *sk)
+{
+	struct chtls_sock *csk = sk->sk_user_data;
+
+	csk->hsk_done = TLS_CLIENT_WQ_CLR;
+	if (cancel_delayed_work(&csk->hsk_work)) {
+		kref_put(&csk->kref, chtls_sock_release);
+		sock_put(sk);
+	}
+}
+
+void chtls_fix_pending_tx_buffers(struct sock *sk)
+{
+	struct chtls_sock *csk = sk->sk_user_data;
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct sk_buff *skb;
+
+	skb_queue_walk(&csk->txq, skb) {
+		if (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NEED_HDR) {
+			ULP_SKB_CB(skb)->seq = tp->write_seq;
+			tp->write_seq += skb->len;
+		}
+	}
+}
+
+static void make_established(struct sock *sk, u32 snd_isn, unsigned int opt)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	tp->pushed_seq = snd_isn;
+	tp->write_seq = snd_isn;
+	tp->snd_nxt = snd_isn;
+	tp->snd_una = snd_isn;
+	inet_sk(sk)->inet_id = tp->write_seq ^ jiffies;
+	assign_rxopt(sk, opt);
+
+	if (tp->rcv_wnd > (RCV_BUFSIZ_M << 10))
+		tp->rcv_wup -= tp->rcv_wnd - (RCV_BUFSIZ_M << 10);
+	dst_confirm(sk->sk_dst_cache);
+
+	smp_mb();
+	tcp_set_state(sk, TCP_ESTABLISHED);
+}
+
+static void chtls_active_establish(struct sock *sk, struct sk_buff *skb)
+{
+	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct cpl_act_establish *req = cplhdr(skb) + RSS_HDR;
+	unsigned int rcv_isn = ntohl(req->rcv_isn);
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (unlikely(sk->sk_state != TCP_SYN_SENT))
+		pr_info("TID %u expected SYN_SENT, found %d\n",
+			csk->tid, sk->sk_state);
+	tp->rcv_tstamp = tcp_jiffies32;
+	csk->delack_seq = rcv_isn;
+	tp->copied_seq = rcv_isn;
+	tp->rcv_wup = rcv_isn;
+	tp->rcv_nxt = rcv_isn;
+	make_established(sk, ntohl(req->snd_isn), ntohs(req->tcp_opt));
+
+	if (skb_queue_len(&csk->ooq))
+		fixup_and_send_ofo(csk, csk->tid);
+	if (skb_queue_len(&csk->ooq))
+		fixup_and_send_ofo(csk, csk->tid);
+
+	if (likely(!sock_flag(sk, SOCK_DEAD))) {
+		sk->sk_state_change(sk);
+		sk_wake_async(sk, 0, POLL_OUT);
+	}
+	kfree_skb(skb);
+	chtls_fix_pending_tx_buffers(sk);
+	if (chtls_push_frames(csk, 1))
+		sk->sk_write_space(sk);
+	chtls_handshake_work(sk);
+}
+
+static int chtls_act_establish(struct chtls_dev *cdev, struct sk_buff *skb)
+{
+	struct cpl_act_establish *req = cplhdr(skb) + RSS_HDR;
+	struct chtls_sock *csk;
+	unsigned int hwtid;
+	unsigned int atid;
+	struct sock *sk;
+
+	hwtid = GET_TID(req);
+	atid = TID_TID_G(ntohl(req->tos_atid));
+	sk = lookup_tid(cdev->tids, hwtid);
+	if (sk) {
+		if (sk->sk_state == TCP_SYN_SENT &&
+		    csk_flag(sk, CSK_ABORT_RPL_PENDING))
+			return 0;
+		return (CPL_RET_UNKNOWN_TID | CPL_RET_BUF_DONE);
+	}
+
+	csk = lookup_atid(cdev->tids, atid);
+	if (unlikely(!csk)) {
+		__kfree_skb(skb);
+		return (CPL_RET_UNKNOWN_TID | CPL_RET_BUF_DONE);
+	}
+	sk = csk->sk;
+	csk->tid = hwtid;
+	cxgb4_insert_tid(cdev->tids, sk, hwtid, sk->sk_family);
+	csk->idr = bh_insert_handle(cdev, sk, hwtid);
+	cxgb4_free_atid(cdev->tids, atid);
+	conn_remove_handle(cdev, atid);
+	kref_put(&csk->kref, chtls_sock_release);
+
+	process_cpl_msg(chtls_active_establish, sk, skb);
+	return 0;
+}
+
+static int chtls_act_open_rpl(struct chtls_dev *cdev, struct sk_buff *skb)
+{
+	struct cpl_act_open_rpl *rpl = cplhdr(skb) + RSS_HDR;
+	struct chtls_sock *csk;
+	unsigned int status;
+	unsigned int atid;
+	struct sock *sk;
+
+	atid = TID_TID_G(AOPEN_ATID_G(be32_to_cpu(rpl->atid_status)));
+	status = AOPEN_STATUS_G(be32_to_cpu(rpl->atid_status));
+	csk = lookup_atid(cdev->tids, atid);
+
+	if (unlikely(!csk) || is_neg_adv(status)) {
+		pr_err("NO matching conn. atid %u.\n", atid);
+		__kfree_skb(skb);
+		return (CPL_RET_UNKNOWN_TID | CPL_RET_BUF_DONE);
+	}
+	sk = csk->sk;
+	if (status && status != CPL_ERR_TCAM_FULL &&
+	    status != CPL_ERR_CONN_EXIST &&
+	    status != CPL_ERR_ARP_MISS)
+		cxgb4_remove_tid(cdev->tids, csk->port_id, GET_TID(rpl),
+				 sk->sk_family);
+
+	process_cpl_msg(chtls_active_open_rpl, sk, skb);
+	return 0;
+}
+
 static void chtls_write_space(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
@@ -1768,30 +1996,6 @@ static int chtls_pass_accept_req(struct chtls_dev *cdev, struct sk_buff *skb)
 	return 0;
 }
 
-/*
- * Completes some final bits of initialization for just established connections
- * and changes their state to TCP_ESTABLISHED.
- *
- * snd_isn here is the ISN after the SYN, i.e., the true ISN + 1.
- */
-static void make_established(struct sock *sk, u32 snd_isn, unsigned int opt)
-{
-	struct tcp_sock *tp = tcp_sk(sk);
-
-	tp->pushed_seq = snd_isn;
-	tp->write_seq = snd_isn;
-	tp->snd_nxt = snd_isn;
-	tp->snd_una = snd_isn;
-	inet_sk(sk)->inet_id = tp->write_seq ^ jiffies;
-	assign_rxopt(sk, opt);
-
-	if (tp->rcv_wnd > (RCV_BUFSIZ_M << 10))
-		tp->rcv_wup -= tp->rcv_wnd - (RCV_BUFSIZ_M << 10);
-
-	smp_mb();
-	tcp_set_state(sk, TCP_ESTABLISHED);
-}
-
 static void chtls_abort_conn(struct sock *sk, struct sk_buff *skb)
 {
 	struct sk_buff *abort_skb;
@@ -1909,6 +2113,7 @@ static int chtls_pass_establish(struct chtls_dev *cdev, struct sk_buff *skb)
 		csk->wr_max_credits = 64;
 		csk->wr_credits = 64;
 		csk->wr_unacked = 0;
+		csk->delack_mode = 0;
 		make_established(sk, ntohl(req->snd_isn), ntohs(req->tcp_opt));
 		stid = PASS_OPEN_TID_G(ntohl(req->tos_stid));
 		sk->sk_state_change(sk);
@@ -2333,20 +2538,6 @@ static void send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 	cxgb4_ofld_send(cdev->lldi->ports[0], reply_skb);
 }
 
-/*
- * Add an skb to the deferred skb queue for processing from process context.
- */
-static void t4_defer_reply(struct sk_buff *skb, struct chtls_dev *cdev,
-			   defer_handler_t handler)
-{
-	DEFERRED_SKB_CB(skb)->handler = handler;
-	spin_lock_bh(&cdev->deferq.lock);
-	__skb_queue_tail(&cdev->deferq, skb);
-	if (skb_queue_len(&cdev->deferq) == 1)
-		schedule_work(&cdev->deferq_task);
-	spin_unlock_bh(&cdev->deferq.lock);
-}
-
 static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 				 struct chtls_dev *cdev,
 				 int status, int queue)
@@ -2362,7 +2553,7 @@ static void chtls_send_abort_rpl(struct sock *sk, struct sk_buff *skb,
 	reply_skb = get_cpl_skb(skb, sizeof(struct cpl_abort_rpl), gfp_any());
 	if (!reply_skb) {
 		req->status = (queue << 1) | status;
-		t4_defer_reply(skb, cdev, send_defer_abort_rpl);
+		chtls_defer_reply(skb, cdev, send_defer_abort_rpl);
 		return;
 	}
 
@@ -2391,7 +2582,7 @@ static void bl_abort_syn_rcv(struct sock *lsk, struct sk_buff *skb)
 	int queue;
 
 	child = skb->sk;
-	csk = child->sk_user_data;
+	csk = lsk->sk_user_data;
 	queue = csk->txq_idx;
 
 	skb->sk	= NULL;
@@ -2601,6 +2792,7 @@ static void chtls_rx_ack(struct sock *sk, struct sk_buff *skb)
 
 		if (tp->snd_una != snd_una) {
 			tp->snd_una = snd_una;
+			dst_confirm(sk->sk_dst_cache);
 			tp->rcv_tstamp = tcp_time_stamp(tp);
 			if (tp->snd_una == tp->snd_nxt &&
 			    !csk_flag_nochk(csk, CSK_TX_FAILOVER))
@@ -2624,7 +2816,7 @@ static void chtls_rx_ack(struct sock *sk, struct sk_buff *skb)
 static int chtls_wr_ack(struct chtls_dev *cdev, struct sk_buff *skb)
 {
 	struct cpl_fw4_ack *rpl = cplhdr(skb) + RSS_HDR;
-	unsigned int hwtid = GET_TID(rpl);
+	unsigned int hwtid = CPL_FW4_ACK_FLOWID_G(ntohl(OPCODE_TID(rpl)));
 	struct sock *sk;
 
 	sk = lookup_tid(cdev->tids, hwtid);
@@ -2638,6 +2830,8 @@ static int chtls_wr_ack(struct chtls_dev *cdev, struct sk_buff *skb)
 }
 
 chtls_handler_func chtls_handlers[NUM_CPL_CMDS] = {
+	[CPL_ACT_ESTABLISH]     = chtls_act_establish,
+	[CPL_ACT_OPEN_RPL]      = chtls_act_open_rpl,
 	[CPL_PASS_OPEN_RPL]     = chtls_pass_open_rpl,
 	[CPL_CLOSE_LISTSRV_RPL] = chtls_close_listsrv_rpl,
 	[CPL_PASS_ACCEPT_REQ]   = chtls_pass_accept_req,
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.h b/drivers/crypto/chelsio/chtls/chtls_cm.h
index ca3ccb7..cea0d22 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.h
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.h
@@ -45,6 +45,8 @@
  */
 #define MAX_RCV_WND ((1U << 27) - 1)
 #define MAX_MSS     65536
+#define TLS_SRV_HELLO_BKOFF_TM    (msecs_to_jiffies(250))
+#define TLS_SRV_HELLO_RD_TM       (msecs_to_jiffies(100))
 
 /*
  * Min receive window.  We want it to be large enough to accommodate receive
@@ -200,4 +202,5 @@ static inline void enqueue_wr(struct chtls_sock *csk, struct sk_buff *skb)
 
 int chtls_active_open(struct chtls_dev *cdev, struct sock *sk,
 		      struct net_device *ndev);
+void stop_hndsk_work(struct sock *sk);
 #endif
diff --git a/drivers/crypto/chelsio/chtls/chtls_hw.c b/drivers/crypto/chelsio/chtls/chtls_hw.c
index 6266b9e..70bc0cc 100644
--- a/drivers/crypto/chelsio/chtls/chtls_hw.c
+++ b/drivers/crypto/chelsio/chtls/chtls_hw.c
@@ -313,6 +313,7 @@ int chtls_setkey(struct chtls_sock *csk, u32 keylen, u32 optname)
 
 	cdev = csk->cdev;
 	sk = csk->sk;
+	stop_hndsk_work(sk);
 
 	klen = roundup((keylen + AEAD_H_SIZE) + sizeof(*kctx), 32);
 	wrlen = roundup(sizeof(*kwr), 16);
diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 1285a1b..d78ddbd 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -45,7 +45,7 @@ static int data_sgl_len(const struct sk_buff *skb)
 
 static int nos_ivs(struct sock *sk, unsigned int size)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 
 	return DIV_ROUND_UP(size, csk->tlshws.mfs);
 }
@@ -93,7 +93,7 @@ static struct sk_buff *create_flowc_wr_skb(struct sock *sk,
 					   struct fw_flowc_wr *flowc,
 					   int flowclen)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct sk_buff *skb;
 
 	skb = alloc_skb(flowclen, GFP_ATOMIC);
@@ -109,21 +109,26 @@ static struct sk_buff *create_flowc_wr_skb(struct sock *sk,
 static int send_flowc_wr(struct sock *sk, struct fw_flowc_wr *flowc,
 			 int flowclen)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
 	int flowclen16;
+	bool syn_sent;
 	int ret;
 
 	flowclen16 = flowclen / 16;
+	syn_sent = (sk->sk_state == TCP_SYN_SENT);
 
 	if (csk_flag(sk, CSK_TX_DATA_SENT)) {
 		skb = create_flowc_wr_skb(sk, flowc, flowclen);
 		if (!skb)
 			return -ENOMEM;
 
-		skb_entail(sk, skb,
-			   ULPCB_FLAG_NO_HDR | ULPCB_FLAG_NO_APPEND);
+		if (syn_sent)
+			__skb_queue_tail(&csk->ooq, skb);
+		else
+			skb_entail(sk, skb,
+				   ULPCB_FLAG_NO_HDR | ULPCB_FLAG_NO_APPEND);
 		return 0;
 	}
 
@@ -171,7 +176,7 @@ int send_tx_flowc_wr(struct sock *sk, int compl,
 	struct chtls_sock *csk;
 	struct tcp_sock *tp;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	tp = tcp_sk(sk);
 	memset(&sflowc, 0, sizeof(sflowc));
 	flowc = &sflowc.fc;
@@ -230,7 +235,7 @@ static int tls_copy_ivs(struct sock *sk, struct sk_buff *skb)
 	struct page *page;
 	int err = 0;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	hws = &csk->tlshws;
 	number_of_ivs = nos_ivs(sk, skb->len);
 
@@ -286,7 +291,7 @@ static void tls_copy_tx_key(struct sock *sk, struct sk_buff *skb)
 	u32 immdlen;
 	int kaddr;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	hws = &csk->tlshws;
 	cdev = csk->cdev;
 
@@ -359,7 +364,7 @@ static void tls_tx_data_wr(struct sock *sk, struct sk_buff *skb,
 	int iv_imm;
 	int len;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	iv_imm = skb_ulp_tls_iv_imm(skb);
 	dev = csk->egress_dev;
 	adap = netdev2adap(dev);
@@ -446,7 +451,7 @@ static int chtls_expansion_size(struct sock *sk, int data_len,
 				int fullpdu,
 				unsigned short *pducnt)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct chtls_hws *hws = &csk->tlshws;
 	struct tls_scmd *scmd = &hws->scmd;
 	int fragsize = hws->mfs;
@@ -488,7 +493,7 @@ static void make_tlstx_data_wr(struct sock *sk, struct sk_buff *skb,
 	int expn_sz;
 	int pdus;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	hws = &csk->tlshws;
 	pdus = DIV_ROUND_UP(tls_len, hws->mfs);
 	expn_sz = chtls_expansion_size(sk, tls_len, 0, NULL);
@@ -517,7 +522,7 @@ static void make_tx_data_wr(struct sock *sk, struct sk_buff *skb,
 	struct chtls_sock *csk;
 	unsigned int opcode;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	opcode = FW_OFLD_TX_DATA_WR;
 
 	req = (struct fw_ofld_tx_data_wr *)__skb_push(skb, sizeof(*req));
@@ -730,7 +735,7 @@ static void mark_urg(struct tcp_sock *tp, int flags,
  */
 static bool should_push(struct sock *sk)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct chtls_dev *cdev = csk->cdev;
 	struct tcp_sock *tp = tcp_sk(sk);
 
@@ -767,7 +772,7 @@ static bool send_should_push(struct sock *sk, int flags)
 
 void chtls_tcp_push(struct sock *sk, int flags)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	int qlen = skb_queue_len(&csk->txq);
 
 	if (likely(qlen)) {
@@ -821,7 +826,7 @@ static int select_size(struct sock *sk, int io_len, int flags, int len)
 
 void skb_entail(struct sock *sk, struct sk_buff *skb, int flags)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	ULP_SKB_CB(skb)->seq = tp->write_seq;
@@ -851,7 +856,7 @@ static struct sk_buff *get_tx_skb(struct sock *sk, int size)
 
 static struct sk_buff *get_record_skb(struct sock *sk, int size, bool zcopy)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct sk_buff *skb;
 
 	skb = alloc_skb(((zcopy ? 0 : size) + TX_TLSHDR_LEN +
@@ -879,7 +884,7 @@ static void tx_skb_finalize(struct sk_buff *skb)
 
 static void push_frames_if_head(struct sock *sk)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 
 	if (skb_queue_len(&csk->txq) == 1)
 		chtls_push_frames(csk, 1);
@@ -986,7 +991,7 @@ static int csk_wait_memory(struct chtls_dev *cdev,
 
 int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct chtls_dev *cdev = csk->cdev;
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *skb;
@@ -1210,7 +1215,7 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 
 	tp = tcp_sk(sk);
 	copied = 0;
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	cdev = csk->cdev;
 	timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
 
@@ -1309,7 +1314,7 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 
 static void chtls_select_window(struct sock *sk)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned int wnd = tp->rcv_wnd;
 
@@ -1369,7 +1374,7 @@ static u32 send_rx_credits(struct chtls_sock *csk, u32 credits)
  */
 static void chtls_cleanup_rbuf(struct sock *sk, int copied)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct tcp_sock *tp;
 	int must_send;
 	u32 credits;
@@ -1399,7 +1404,7 @@ static void chtls_cleanup_rbuf(struct sock *sk, int copied)
 static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			    int nonblock, int flags, int *addr_len)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+	struct chtls_sock *csk = sk->sk_user_data;
 	struct chtls_hws *hws = &csk->tlshws;
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned long avail;
@@ -1709,7 +1714,7 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		sk_busy_loop(sk, nonblock);
 
 	lock_sock(sk);
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 
 	if (is_tls_rx(csk))
 		return chtls_pt_recvmsg(sk, msg, len, nonblock,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
index 38dd41e..d2aa763 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_msg.h
@@ -287,6 +287,14 @@ struct work_request_hdr {
 #define RSS_QUEUE_VALID_V(x) ((x) << RSS_QUEUE_VALID_S)
 #define RSS_QUEUE_VALID_F    RSS_QUEUE_VALID_V(1U)
 
+#define RSS_RX_COALESCE_S    12
+#define RSS_RX_COALESCE_V(x) ((x) << RX_COALESCE_S)
+#define RSS_RX_COALESCE_F    RSS_RX_COALESCE_V(1U)
+
+#define T5_ISS_S    18
+#define T5_ISS_V(x) ((x) << T5_ISS_S)
+#define T5_ISS_F    T5_ISS_V(1U)
+
 #define RX_FC_DISABLE_S    20
 #define RX_FC_DISABLE_V(x) ((x) << RX_FC_DISABLE_S)
 #define RX_FC_DISABLE_F    RX_FC_DISABLE_V(1U)
@@ -299,6 +307,10 @@ struct work_request_hdr {
 #define RX_CHANNEL_V(x) ((x) << RX_CHANNEL_S)
 #define RX_CHANNEL_F	RX_CHANNEL_V(1U)
 
+#define RX_MODULATE_RX_S    27
+#define RX_MODULATE_RX_V(x) ((x) << RX_MODULATE_RX_S)
+#define RX_MODULATE_RX_F    RX_MODULATE_RX_V(1U)
+
 #define WND_SCALE_EN_S    28
 #define WND_SCALE_EN_V(x) ((x) << WND_SCALE_EN_S)
 #define WND_SCALE_EN_F    WND_SCALE_EN_V(1U)
@@ -1415,6 +1427,12 @@ struct cpl_fw4_ack {
 	__be64 rsvd1;
 };
 
+#define CPL_FW4_ACK_FLOWID_S    0
+#define CPL_FW4_ACK_FLOWID_M    0xffffff
+#define CPL_FW4_ACK_FLOWID_V(x) ((x) << CPL_FW4_ACK_FLOWID_S)
+#define CPL_FW4_ACK_FLOWID_G(x) \
+	(((x) >> CPL_FW4_ACK_FLOWID_S) & CPL_FW4_ACK_FLOWID_M)
+
 enum {
 	CPL_FW4_ACK_FLAGS_SEQVAL	= 0x1,	/* seqn valid */
 	CPL_FW4_ACK_FLAGS_CH		= 0x2,	/* channel change complete */
-- 
1.8.3.1

