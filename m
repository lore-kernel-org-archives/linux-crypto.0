Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:13348 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfARHPF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 02:15:05 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Cc: atul.gupta@chelsio.com
Subject: [RFC patch 4/4] crypto/chelsio/chtls: IPv6 for Inline TLS
Date: Thu, 17 Jan 2019 23:14:59 -0800
Message-Id: <20190118071459.9737-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Extends support to IPv6 for Inline TLS server and client.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c   | 473 +++++++++++++++++++++++++++---
 drivers/crypto/chelsio/chtls/chtls_cm.h   |   3 +
 drivers/crypto/chelsio/chtls/chtls_main.c |  27 +-
 include/net/transp_v6.h                   |   8 +
 net/ipv6/tcp_ipv6.c                       |  26 +-
 5 files changed, 467 insertions(+), 70 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 9117629..e653335 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -21,13 +21,20 @@
 #include <linux/kallsyms.h>
 #include <linux/kprobes.h>
 #include <linux/if_vlan.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#include <net/transp_v6.h>
+#include <net/ip6_route.h>
 #include <net/inet_common.h>
 #include <net/tcp.h>
 #include <net/dst.h>
 #include <net/tls.h>
+#include <net/addrconf.h>
+#include <net/secure_seq.h>
 
 #include "chtls.h"
 #include "chtls_cm.h"
+#include "clip_tbl.h"
 
 static void chtls_connect_req_arp_failure(void *handle, struct sk_buff *skb);
 
@@ -195,15 +202,35 @@ static void fixup_and_send_ofo(struct chtls_sock *csk, unsigned int tid)
 	}
 }
 
-static struct net_device *chtls_ipv4_netdev(struct chtls_dev *cdev,
+static struct net_device *chtls_find_netdev(struct chtls_dev *cdev,
 					    struct sock *sk)
 {
 	struct net_device *ndev = cdev->ports[0];
-
-	if (likely(!inet_sk(sk)->inet_rcv_saddr))
-		return ndev;
-
-	ndev = ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr);
+	struct net_device *temp;
+	int addr_type;
+
+	switch (sk->sk_family) {
+	case PF_INET:
+		if (likely(!inet_sk(sk)->inet_rcv_saddr))
+			return ndev;
+		ndev = ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr);
+		break;
+	case PF_INET6:
+		addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
+		if (likely(addr_type == IPV6_ADDR_ANY))
+			return ndev;
+
+	for_each_netdev_rcu(&init_net, temp) {
+		if (ipv6_chk_addr(&init_net, (struct in6_addr *)
+				  &sk->sk_v6_rcv_saddr, temp, 1)) {
+			ndev = temp;
+			break;
+		}
+	}
+	break;
+	default:
+		return NULL;
+	}
 	if (!ndev)
 		return NULL;
 
@@ -581,7 +608,10 @@ void chtls_destroy_sock(struct sock *sk)
 	free_tls_keyid(sk);
 	stop_hndsk_work(sk);
 	kref_put(&csk->kref, chtls_sock_release);
-	sk->sk_prot = &tcp_prot;
+	if (sk->sk_family == AF_INET)
+		sk->sk_prot = &tcp_prot;
+	else
+		sk->sk_prot = &tcpv6_prot;
 	sk->sk_prot->destroy(sk);
 }
 
@@ -698,7 +728,7 @@ static void cleanup_syn_rcv_conn(struct sock *child, struct sock *parent)
 	struct request_sock *req;
 	struct chtls_sock *csk;
 
-	csk = rcu_dereference_sk_user_data(child);
+	csk = child->sk_user_data;
 	req = csk->passive_reap_next;
 
 	reqsk_queue_removed(&inet_csk(parent)->icsk_accept_queue, req);
@@ -735,14 +765,16 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 	struct listen_ctx *ctx;
 	struct adapter *adap;
 	struct port_info *pi;
+	bool clip_valid;
 	int stid;
 	int ret;
 
 	if (sk->sk_family != PF_INET)
 		return -EAGAIN;
 
+	clip_valid = false;
 	rcu_read_lock();
-	ndev = chtls_ipv4_netdev(cdev, sk);
+	ndev = chtls_find_netdev(cdev, sk);
 	rcu_read_unlock();
 	if (!ndev)
 		return -EBADF;
@@ -773,16 +805,35 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 	if (!listen_hash_add(cdev, sk, stid))
 		goto free_stid;
 
-	ret = cxgb4_create_server(ndev, stid,
-				  inet_sk(sk)->inet_rcv_saddr,
-				  inet_sk(sk)->inet_sport, 0,
-				  cdev->lldi->rxq_ids[0]);
+	if (sk->sk_family == PF_INET) {
+		ret = cxgb4_create_server(ndev, stid,
+					  inet_sk(sk)->inet_rcv_saddr,
+					  inet_sk(sk)->inet_sport, 0,
+					  cdev->lldi->rxq_ids[0]);
+	} else {
+		int addr_type;
+
+		addr_type = ipv6_addr_type(&sk->sk_v6_rcv_saddr);
+		if (addr_type != IPV6_ADDR_ANY) {
+			ret = cxgb4_clip_get(ndev, (const u32 *)
+					     &sk->sk_v6_rcv_saddr, 1);
+			if (ret)
+				goto del_hash;
+			clip_valid = true;
+		}
+		ret = cxgb4_create_server6(ndev, stid,
+					   &sk->sk_v6_rcv_saddr,
+					   inet_sk(sk)->inet_sport,
+					   cdev->lldi->rxq_ids[0]);
+	}
 	if (ret > 0)
 		ret = net_xmit_errno(ret);
 	if (ret)
 		goto del_hash;
 	return 0;
 del_hash:
+	if (clip_valid)
+		cxgb4_clip_release(ndev, (const u32 *)&sk->sk_v6_rcv_saddr, 1);
 	listen_hash_del(cdev, sk);
 free_stid:
 	cxgb4_free_stid(cdev->tids, stid, sk->sk_family);
@@ -796,6 +847,8 @@ int chtls_listen_start(struct chtls_dev *cdev, struct sock *sk)
 void chtls_listen_stop(struct chtls_dev *cdev, struct sock *sk)
 {
 	struct listen_ctx *listen_ctx;
+	struct chtls_sock *csk;
+	int addr_type = 0;
 	int stid;
 
 	stid = listen_hash_del(cdev, sk);
@@ -806,7 +859,16 @@ void chtls_listen_stop(struct chtls_dev *cdev, struct sock *sk)
 	chtls_reset_synq(listen_ctx);
 
 	cxgb4_remove_server(cdev->lldi->ports[0], stid,
-			    cdev->lldi->rxq_ids[0], 0);
+			    cdev->lldi->rxq_ids[0], sk->sk_family == PF_INET6);
+
+	if (sk->sk_family == PF_INET6) {
+		csk = sk->sk_user_data;
+		addr_type = ipv6_addr_type((const struct in6_addr *)
+					  &sk->sk_v6_rcv_saddr);
+		if (addr_type != IPV6_ADDR_ANY)
+			cxgb4_clip_release(csk->egress_dev, (const u32 *)
+					   &sk->sk_v6_rcv_saddr, 1);
+	}
 	chtls_disconnect_acceptq(sk);
 }
 
@@ -965,7 +1027,7 @@ static void chtls_pass_open_arp_failure(struct sock *sk,
 	struct sock *parent;
 	void *data;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 	cdev = csk->cdev;
 
 	/*
@@ -1022,7 +1084,10 @@ static unsigned int chtls_select_mss(const struct chtls_sock *csk,
 	tp = tcp_sk(sk);
 	tcpoptsz = 0;
 
-	iphdrsz = sizeof(struct iphdr) + sizeof(struct tcphdr);
+	if (sk->sk_family == AF_INET6)
+		iphdrsz = sizeof(struct ipv6hdr) + sizeof(struct tcphdr);
+	else
+		iphdrsz = sizeof(struct iphdr) + sizeof(struct tcphdr);
 	if (sock_net(sk)->ipv4.sysctl_tcp_timestamps)
 		tcpoptsz += round_up(TCPOLEN_TIMESTAMP, 4);
 
@@ -1206,6 +1271,63 @@ static void chtls_act_open_rqst(struct sock *sk, struct sk_buff *skb,
 	req->opt3 = cpu_to_be32(0);
 }
 
+static void chtls_act_open_rqstv6(struct sock *sk, struct sk_buff *skb,
+				  unsigned int qid_atid,
+				  const struct l2t_entry *e)
+{
+	struct cpl_t6_act_open_req6 *req = NULL;
+	struct in6_addr *sip;
+	struct in6_addr *dip;
+	struct chtls_sock *csk;
+	unsigned int opt2;
+	u32 isn;
+
+	csk = sk->sk_user_data;
+	req = (struct cpl_t6_act_open_req6 *)__skb_put(skb, sizeof(*req));
+	INIT_TP_WR(req, 0);
+	sip = &sk->sk_v6_rcv_saddr;
+	dip = &sk->sk_v6_daddr;
+	OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_ACT_OPEN_REQ6, qid_atid));
+	set_wr_txq(skb, CPL_PRIORITY_SETUP, csk->port_id);
+	req->local_port = inet_sk(sk)->inet_sport;
+	req->peer_port = inet_sk(sk)->inet_dport;
+	req->local_ip_hi = *(__be64 *)(sip->s6_addr);
+	req->local_ip_lo = *(__be64 *)(sip->s6_addr + 8);
+	req->peer_ip_hi = *(__be64 *)(dip->s6_addr);
+	req->peer_ip_lo = *(__be64 *)(dip->s6_addr + 8);
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
+	       TX_QUEUE_V(csk->cdev->lldi->tx_modq[csk->tx_chan]) |
+	       RSS_QUEUE_VALID_F |
+	       RSS_QUEUE_V(csk->rss_qid) |
+	       T5_ISS_F |
+	       RX_FC_DISABLE_F |
+	       T5_OPT_2_VALID_F |
+	       RX_FC_VALID_F;
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
 static void act_open_retry_timer(struct timer_list *t)
 {
 	struct inet_connection_sock *icsk;
@@ -1229,13 +1351,18 @@ static void act_open_retry_timer(struct timer_list *t)
 			struct chtls_dev *cdev;
 			unsigned int qid_atid;
 
-			csk = rcu_dereference_sk_user_data(sk);
+			csk = sk->sk_user_data;
 			cdev = csk->cdev;
 			qid_atid = csk->rss_qid << 14 | csk->tid;
 			skb->sk = sk;
 			t4_set_arp_err_handler(skb, NULL,
 					       chtls_connect_req_arp_failure);
-			chtls_act_open_rqst(sk, skb, qid_atid, csk->l2t_entry);
+			if (sk->sk_family == AF_INET)
+				chtls_act_open_rqst(sk, skb, qid_atid,
+						    csk->l2t_entry);
+			else
+				chtls_act_open_rqstv6(sk, skb, qid_atid,
+						      csk->l2t_entry);
 			cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
 		}
 	}
@@ -1272,7 +1399,7 @@ static void chtls_active_open_rpl(struct sock *sk, struct sk_buff *skb)
 		struct chtls_dev *cdev;
 		unsigned int tid;
 
-		csk = rcu_dereference_sk_user_data(sk);
+		csk = sk->sk_user_data;
 		cdev = csk->cdev;
 		tid = GET_TID(rpl);
 
@@ -1297,14 +1424,14 @@ static void chtls_active_open_rpl(struct sock *sk, struct sk_buff *skb)
 			kfree_skb(skb);
 		} else if (status == CPL_ERR_TCAM_PARITY ||
 			   status == CPL_ERR_TCAM_FULL) {
-			csk = rcu_dereference_sk_user_data(sk);
+			csk = sk->sk_user_data;
 			cdev = csk->cdev;
 			skb->sk = sk;
 			chtls_defer_reply(skb, cdev, chtls_deferred_connect);
 		} else {
 			err = act_open_rpl_status_to_errno(status);
 			if (err == EADDRINUSE) {
-				csk = rcu_dereference_sk_user_data(sk);
+				csk = sk->sk_user_data;
 				cdev = csk->cdev;
 				skb->sk = sk;
 				chtls_defer_reply(skb, cdev,
@@ -1316,6 +1443,203 @@ static void chtls_active_open_rpl(struct sock *sk, struct sk_buff *skb)
 	}
 }
 
+int chtls_ndev_found(struct chtls_dev *cdev, struct net_device *ndev)
+{
+	int i;
+
+	for (i = 0; i < cdev->lldi->nports; i++)
+		if (ndev == cdev->ports[i])
+			return 1;
+	return 0;
+}
+
+int chtls_v6_connect(struct tls_device *dev, struct sock *sk,
+		     struct sockaddr *uaddr, int addr_len)
+{
+	struct sockaddr_in6 *usin = (struct sockaddr_in6 *)uaddr;
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct inet_sock *inet = inet_sk(sk);
+	struct ipv6_pinfo *np = inet6_sk(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct ipv6_txoptions *opt;
+	struct net_device *netdev;
+	struct in6_addr *final_p;
+	struct chtls_dev *cdev;
+	struct in6_addr *saddr;
+	struct in6_addr final;
+	struct dst_entry *dst;
+	struct flowi6 fl6;
+	int addr_type;
+	int err;
+	struct inet_timewait_death_row *tcp_death_row =
+		&sock_net(sk)->ipv4.tcp_death_row;
+
+	if (addr_len < SIN6_LEN_RFC2133)
+		return -EINVAL;
+
+	memset(&fl6, 0, sizeof(fl6));
+	if (np->sndflow) {
+		fl6.flowlabel = usin->sin6_flowinfo & IPV6_FLOWINFO_MASK;
+		IP6_ECN_flow_init(fl6.flowlabel);
+		if (fl6.flowlabel & IPV6_FLOWLABEL_MASK) {
+			struct ip6_flowlabel *flowlabel;
+
+			flowlabel = fl6_sock_lookup(sk, fl6.flowlabel);
+			if (!flowlabel)
+				return -EINVAL;
+			fl6_sock_release(flowlabel);
+		}
+	}
+	if (ipv6_addr_any(&usin->sin6_addr))
+		usin->sin6_addr.s6_addr[15] = 0x1;
+	addr_type = ipv6_addr_type(&usin->sin6_addr);
+
+	if (addr_type & IPV6_ADDR_MULTICAST)
+		return -ENETUNREACH;
+
+	if (addr_type & IPV6_ADDR_LINKLOCAL) {
+		if (addr_len >= sizeof(struct sockaddr_in6) &&
+		    usin->sin6_scope_id) {
+			/* If interface is set while binding, indices
+			 * must coincide.
+			 */
+			if (sk->sk_bound_dev_if &&
+			    sk->sk_bound_dev_if != usin->sin6_scope_id)
+				return -EINVAL;
+
+				sk->sk_bound_dev_if = usin->sin6_scope_id;
+		}
+
+		/* Connect to link-local address requires an interface */
+		if (!sk->sk_bound_dev_if)
+			return -EINVAL;
+	}
+
+	if (tp->rx_opt.ts_recent_stamp &&
+	    !ipv6_addr_equal(&sk->sk_v6_daddr, &usin->sin6_addr)) {
+		tp->rx_opt.ts_recent = 0;
+		tp->rx_opt.ts_recent_stamp = 0;
+		tp->write_seq = 0;
+	}
+
+	sk->sk_v6_daddr = usin->sin6_addr;
+	np->flow_label = fl6.flowlabel;
+
+	/* IPv4 mapped */
+	if (addr_type == IPV6_ADDR_MAPPED) {
+		u32 exthdrlen = icsk->icsk_ext_hdr_len;
+		struct sockaddr_in sin;
+
+		if (__ipv6_only_sock(sk))
+			return -ENETUNREACH;
+
+		sin.sin_family = AF_INET;
+		sin.sin_port = usin->sin6_port;
+		sin.sin_addr.s_addr = usin->sin6_addr.s6_addr32[3];
+
+		icsk->icsk_af_ops = &ipv6_mapped;
+		sk->sk_backlog_rcv = tcp_v4_do_rcv;
+#ifdef CONFIG_TCP_MD5SIG
+		tp->af_specific = &tcp_sock_ipv6_mapped_specific;
+#endif
+
+		err = tcp_v4_connect(sk, (struct sockaddr *)&sin, sizeof(sin));
+		if (err) {
+			icsk->icsk_ext_hdr_len = exthdrlen;
+			icsk->icsk_af_ops = &ipv6_specific;
+			sk->sk_backlog_rcv = tcp_v6_do_rcv;
+#ifdef CONFIG_TCP_MD5SIG
+			tp->af_specific = &tcp_sock_ipv6_specific;
+#endif
+			goto failure;
+		}
+		np->saddr = sk->sk_v6_rcv_saddr;
+		return err;
+	}
+
+	if (!ipv6_addr_any(&sk->sk_v6_rcv_saddr))
+		saddr = &sk->sk_v6_rcv_saddr;
+
+	fl6.flowi6_proto = IPPROTO_TCP;
+	fl6.daddr = sk->sk_v6_daddr;
+	fl6.saddr = saddr ? *saddr : np->saddr;
+	fl6.flowi6_oif = sk->sk_bound_dev_if;
+	fl6.flowi6_mark = sk->sk_mark;
+	fl6.fl6_dport = usin->sin6_port;
+	fl6.fl6_sport = inet->inet_sport;
+
+	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
+	final_p = fl6_update_dst(&fl6, opt, &final);
+
+	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
+
+	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	if (IS_ERR(dst)) {
+		err = PTR_ERR(dst);
+		goto failure;
+	}
+
+	if (!saddr) {
+		saddr = &fl6.saddr;
+		sk->sk_v6_rcv_saddr = *saddr;
+	}
+
+	np->saddr = *saddr;
+	inet->inet_rcv_saddr = LOOPBACK4_IPV6;
+	sk->sk_gso_type = SKB_GSO_TCPV6;
+	ip6_dst_store(sk, dst, NULL, NULL);
+	icsk->icsk_ext_hdr_len = 0;
+	if (opt)
+		icsk->icsk_ext_hdr_len = (opt->opt_flen +
+					  opt->opt_nflen);
+
+	tp->rx_opt.mss_clamp = IPV6_MIN_MTU - sizeof(struct tcphdr) -
+				sizeof(struct ipv6hdr);
+	inet->inet_dport = usin->sin6_port;
+	tcp_set_state(sk, TCP_SYN_SENT);
+	err = inet6_hash_connect(tcp_death_row, sk);
+	if (err)
+		goto late_failure;
+
+	sk_set_txhash(sk);
+	cdev = to_chtls_dev(dev);
+	netdev = __sk_dst_get(sk)->dev;
+	if (!chtls_ndev_found(cdev, netdev)) {
+		err = -ENETUNREACH;
+		goto late_failure;
+	}
+
+	if (!chtls_active_open(cdev, sk, netdev))
+		return 0;
+
+	if (likely(!tp->repair)) {
+		if (!tp->write_seq)
+			tp->write_seq =
+				secure_tcpv6_seq(np->saddr.s6_addr32,
+						 sk->sk_v6_daddr.s6_addr32,
+						 inet->inet_sport,
+						 inet->inet_dport);
+			tp->tsoffset =
+				secure_tcpv6_ts_off(sock_net(sk),
+						    np->saddr.s6_addr32,
+						    sk->sk_v6_daddr.s6_addr32);
+	}
+
+	err = tcp_connect(sk);
+	if (err)
+		goto late_failure;
+
+	return 0;
+
+late_failure:
+	tcp_set_state(sk, TCP_CLOSE);
+	__sk_dst_reset(sk);
+failure:
+	inet->inet_dport = 0;
+	sk->sk_route_caps = 0;
+	return err;
+}
+
 static void chtls_connect_req_arp_failure(void *handle, struct sk_buff *skb)
 {
 	struct sock *sk = skb->sk;
@@ -1394,11 +1718,15 @@ static void make_established(struct sock *sk, u32 snd_isn, unsigned int opt)
 
 static void chtls_active_establish(struct sock *sk, struct sk_buff *skb)
 {
-	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
-	struct cpl_act_establish *req = cplhdr(skb) + RSS_HDR;
-	unsigned int rcv_isn = ntohl(req->rcv_isn);
-	struct tcp_sock *tp = tcp_sk(sk);
+	struct cpl_act_establish *req;
+	struct chtls_sock *csk;
+	unsigned int rcv_isn;
+	struct tcp_sock *tp;
 
+	csk = sk->sk_user_data;
+	req = cplhdr(skb) + RSS_HDR;
+	rcv_isn = ntohl(req->rcv_isn);
+	tp = tcp_sk(sk);
 	if (unlikely(sk->sk_state != TCP_SYN_SENT))
 		pr_info("TID %u expected SYN_SENT, found %d\n",
 			csk->tid, sk->sk_state);
@@ -1644,11 +1972,12 @@ int chtls_active_open(struct chtls_dev *cdev, struct sock *sk,
 	csk->sk = sk;
 	csk->egress_dev = ndev;
 	sk->sk_user_data = csk;
-	if (sk->sk_family == AF_INET) {
+	if (sk->sk_family == AF_INET)
 		n = dst_neigh_lookup(dst, &inet_sk(sk)->inet_daddr);
-		if (!n)
-			goto free_atid;
-	}
+	else
+		n = dst_neigh_lookup(dst, &sk->sk_v6_daddr);
+	if (!n)
+		goto free_atid;
 	port_id = cxgb4_port_idx(ndev);
 
 	csk->l2t_entry = cxgb4_l2t_get(cdev->lldi->l2t, n, ndev, 0);
@@ -1707,7 +2036,10 @@ int chtls_active_open(struct chtls_dev *cdev, struct sock *sk,
 	qid_atid = csk->rss_qid << 14;
 	qid_atid |= (unsigned int)atid;
 
-	chtls_act_open_rqst(sk, skb, qid_atid, csk->l2t_entry);
+	if (sk->sk_family == AF_INET)
+		chtls_act_open_rqst(sk, skb, qid_atid, csk->l2t_entry);
+	else
+		chtls_act_open_rqstv6(sk, skb, qid_atid, csk->l2t_entry);
 	cxgb4_l2t_send(csk->egress_dev, skb, csk->l2t_entry);
 	return 0;
 free_atid:
@@ -1742,11 +2074,29 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	if (!newsk)
 		goto free_oreq;
 
-	dst = inet_csk_route_child_sock(lsk, newsk, oreq);
-	if (!dst)
-		goto free_sk;
+	if (lsk->sk_family == AF_INET) {
+		dst = inet_csk_route_child_sock(lsk, newsk, oreq);
+		if (!dst)
+			goto free_sk;
 
-	n = dst_neigh_lookup(dst, &iph->saddr);
+		n = dst_neigh_lookup(dst, &iph->saddr);
+	} else {
+		const struct ipv6hdr *ip6h;
+		struct flowi6 fl6;
+
+		ip6h = (const struct ipv6hdr *)network_hdr;
+		memset(&fl6, 0, sizeof(fl6));
+		fl6.flowi6_proto = IPPROTO_TCP;
+		fl6.saddr = ip6h->daddr;
+		fl6.daddr = ip6h->saddr;
+		fl6.fl6_dport = inet_rsk(oreq)->ir_rmt_port;
+		fl6.fl6_sport = htons(inet_rsk(oreq)->ir_num);
+		security_req_classify_flow(oreq, flowi6_to_flowi(&fl6));
+		dst = ip6_dst_lookup_flow(lsk, &fl6, NULL);
+		if (IS_ERR(dst))
+			goto free_sk;
+		n = dst_neigh_lookup(dst, &ip6h->saddr);
+	}
 	if (!n)
 		goto free_sk;
 
@@ -1769,9 +2119,28 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	tp = tcp_sk(newsk);
 	newinet = inet_sk(newsk);
 
-	newinet->inet_daddr = iph->saddr;
-	newinet->inet_rcv_saddr = iph->daddr;
-	newinet->inet_saddr = iph->daddr;
+	if (iph->version == 0x4) {
+		newinet->inet_daddr = iph->saddr;
+		newinet->inet_rcv_saddr = iph->daddr;
+		newinet->inet_saddr = iph->daddr;
+	} else {
+		struct tcp6_sock *newtcp6sk = (struct tcp6_sock *)newsk;
+		struct inet_request_sock *treq = inet_rsk(oreq);
+		struct ipv6_pinfo *newnp = inet6_sk(newsk);
+		struct ipv6_pinfo *np = inet6_sk(lsk);
+
+		inet_sk(newsk)->pinet6 = &newtcp6sk->inet6;
+		memcpy(newnp, np, sizeof(struct ipv6_pinfo));
+		newsk->sk_v6_daddr = treq->ir_v6_rmt_addr;
+		newsk->sk_v6_rcv_saddr = treq->ir_v6_loc_addr;
+		inet6_sk(newsk)->saddr = treq->ir_v6_loc_addr;
+		newnp->ipv6_fl_list = NULL;
+		newnp->pktoptions = NULL;
+		newsk->sk_bound_dev_if = treq->ir_iif;
+		newinet->inet_opt = NULL;
+		newinet->inet_daddr = LOOPBACK4_IPV6;
+		newinet->inet_saddr = LOOPBACK4_IPV6;
+	}
 
 	oreq->ts_recent = PASS_OPEN_TID_G(ntohl(req->tos_stid));
 	sk_setup_caps(newsk, dst);
@@ -1853,6 +2222,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 	struct sk_buff *reply_skb;
 	struct chtls_sock *csk;
 	struct chtls_dev *cdev;
+	struct ipv6hdr *ip6h;
 	struct tcphdr *tcph;
 	struct sock *newsk;
 	struct ethhdr *eh;
@@ -1907,23 +2277,34 @@ static void chtls_pass_accept_request(struct sock *sk,
 	if (eth_hdr_len == ETH_HLEN) {
 		eh = (struct ethhdr *)(req + 1);
 		iph = (struct iphdr *)(eh + 1);
+		ip6h = (struct ipv6hdr *)(eh + 1);
 		network_hdr = (void *)(eh + 1);
 	} else {
 		vlan_eh = (struct vlan_ethhdr *)(req + 1);
 		iph = (struct iphdr *)(vlan_eh + 1);
+		ip6h = (struct ipv6hdr *)(eh + 1);
 		network_hdr = (void *)(vlan_eh + 1);
 	}
-	if (iph->version != 0x4)
-		goto free_oreq;
 
-	tcph = (struct tcphdr *)(iph + 1);
-	skb_set_network_header(skb, (void *)iph - (void *)req);
+	if (iph->version == 0x4) {
+		tcph = (struct tcphdr *)(iph + 1);
+		skb_set_network_header(skb, (void *)iph - (void *)req);
+	} else {
+		tcph = (struct tcphdr *)(ip6h + 1);
+		skb_set_network_header(skb, (void *)ip6h - (void *)req);
+	}
 
 	tcp_rsk(oreq)->tfo_listener = false;
 	tcp_rsk(oreq)->rcv_isn = ntohl(tcph->seq);
 	chtls_set_req_port(oreq, tcph->source, tcph->dest);
-	chtls_set_req_addr(oreq, iph->daddr, iph->saddr);
-	ip_dsfield = ipv4_get_dsfield(iph);
+	if (iph->version == 0x4) {
+		chtls_set_req_addr(oreq, iph->daddr, iph->saddr);
+		ip_dsfield = ipv4_get_dsfield(iph);
+	} else {
+		inet_rsk(oreq)->ir_v6_rmt_addr = ipv6_hdr(skb)->saddr;
+		inet_rsk(oreq)->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
+		ip_dsfield = ipv6_get_dsfield(ipv6_hdr(skb));
+	}
 	if (req->tcpopt.wsf <= 14 &&
 	    sock_net(sk)->ipv4.sysctl_tcp_window_scaling) {
 		inet_rsk(oreq)->wscale_ok = 1;
@@ -1940,7 +2321,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 
 	newsk = chtls_recv_sock(sk, oreq, network_hdr, req, cdev);
 	if (!newsk)
-		goto reject;
+		goto free_oreq;
 
 	if (chtls_get_module(newsk))
 		goto reject;
@@ -1948,7 +2329,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 	reply_skb->sk = newsk;
 	chtls_install_cpl_ops(newsk);
 	cxgb4_insert_tid(cdev->tids, newsk, tid, newsk->sk_family);
-	csk = rcu_dereference_sk_user_data(newsk);
+	csk = newsk->sk_user_data;
 	listen_ctx = (struct listen_ctx *)lookup_stid(cdev->tids, stid);
 	csk->listen_ctx = listen_ctx;
 	__skb_queue_tail(&listen_ctx->synq, (struct sk_buff *)&csk->synq);
@@ -2016,7 +2397,7 @@ static void chtls_abort_conn(struct sock *sk, struct sk_buff *skb)
 	spin_lock_bh(&reap_list_lock);
 	while (reap_list) {
 		struct sock *sk = reap_list;
-		struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
+		struct chtls_sock *csk = sk->sk_user_data;
 
 		reap_list = csk->passive_reap_next;
 		csk->passive_reap_next = NULL;
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.h b/drivers/crypto/chelsio/chtls/chtls_cm.h
index cea0d22..45ddf85 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.h
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.h
@@ -202,5 +202,8 @@ static inline void enqueue_wr(struct chtls_sock *csk, struct sk_buff *skb)
 
 int chtls_active_open(struct chtls_dev *cdev, struct sock *sk,
 		      struct net_device *ndev);
+int chtls_v6_connect(struct tls_device *dev, struct sock *sk,
+		     struct sockaddr *uaddr, int addr_len);
+int chtls_ndev_found(struct chtls_dev *cdev, struct net_device *ndev);
 void stop_hndsk_work(struct sock *sk);
 #endif
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index 9328bde..1d4f49b 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -16,6 +16,7 @@
 #include <linux/net.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
+#include <net/transp_v6.h>
 #include <net/secure_seq.h>
 #include <net/tcp.h>
 #include <net/tls.h>
@@ -37,6 +38,8 @@
 static RAW_NOTIFIER_HEAD(listen_notify_list);
 static struct proto chtls_cpl_prot;
 struct request_sock_ops chtls_rsk_ops;
+static struct proto chtls_cpl_prot, chtls_cpl_protv6;
+struct request_sock_ops chtls_rsk_ops, chtls_rsk_opsv6;
 static uint send_page_order = (14 - PAGE_SHIFT < 0) ? 0 : 14 - PAGE_SHIFT;
 
 static void register_listen_notifier(struct notifier_block *nb)
@@ -162,16 +165,6 @@ static void chtls_destroy_hash(struct tls_device *dev, struct sock *sk)
 		chtls_stop_listen(cdev, sk);
 }
 
-static int chtls_ndev_found(struct chtls_dev *cdev, struct net_device *ndev)
-{
-	int i;
-
-	for (i = 0; i < cdev->lldi->nports; i++)
-		if (ndev == cdev->ports[i])
-			return 1;
-	return 0;
-}
-
 static int chtls_connect(struct tls_device *dev, struct sock *sk,
 			 struct sockaddr *uaddr, int addr_len)
 {
@@ -192,6 +185,9 @@ static int chtls_connect(struct tls_device *dev, struct sock *sk,
 	if (addr_len < sizeof(struct sockaddr_in))
 		return -EINVAL;
 
+	if (usin->sin_family == AF_INET6)
+		return chtls_v6_connect(dev, sk, uaddr, addr_len);
+
 	if (usin->sin_family != AF_INET)
 		return -EAFNOSUPPORT;
 
@@ -411,7 +407,6 @@ static void *chtls_uld_add(const struct cxgb4_lld_info *info)
 	cdev->tids = lldi->tids;
 	cdev->ports = lldi->ports;
 	cdev->mtus = lldi->mtus;
-	cdev->tids = lldi->tids;
 	cdev->pfvf = FW_VIID_PFN_G(cxgb4_port_viid(lldi->ports[0]))
 			<< FW_VIID_PFN_S;
 
@@ -652,7 +647,7 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
 	int keylen;
 	int rc = 0;
 
-	csk = rcu_dereference_sk_user_data(sk);
+	csk = sk->sk_user_data;
 
 	if (!optval || optlen < sizeof(*crypto_info)) {
 		rc = -EINVAL;
@@ -723,7 +718,10 @@ static int chtls_setsockopt(struct sock *sk, int level, int optname,
 
 void chtls_install_cpl_ops(struct sock *sk)
 {
-	sk->sk_prot = &chtls_cpl_prot;
+	if (sk->sk_family == AF_INET)
+		sk->sk_prot = &chtls_cpl_prot;
+	else
+		sk->sk_prot = &chtls_cpl_protv6;
 }
 
 static void __init chtls_init_ulp_ops(void)
@@ -740,6 +738,9 @@ static void __init chtls_init_ulp_ops(void)
 	chtls_cpl_prot.recvmsg		= chtls_recvmsg;
 	chtls_cpl_prot.setsockopt	= chtls_setsockopt;
 	chtls_cpl_prot.getsockopt	= chtls_getsockopt;
+	chtls_cpl_protv6		= chtls_cpl_prot;
+	chtls_init_rsk_ops(&chtls_cpl_protv6, &chtls_rsk_opsv6,
+			   &tcpv6_prot, PF_INET6);
 }
 
 static int __init chtls_register(void)
diff --git a/include/net/transp_v6.h b/include/net/transp_v6.h
index a8f6020..5b88106 100644
--- a/include/net/transp_v6.h
+++ b/include/net/transp_v6.h
@@ -10,6 +10,13 @@
 extern struct proto udplitev6_prot;
 extern struct proto tcpv6_prot;
 extern struct proto pingv6_prot;
+extern const struct inet_connection_sock_af_ops ipv6_mapped;
+extern const struct inet_connection_sock_af_ops ipv6_specific;
+#ifdef CONFIG_TCP_MD5SIG
+extern const struct tcp_sock_af_ops tcp_sock_ipv6_specific;
+extern const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific;
+#endif
+
 
 struct flowi6;
 
@@ -32,6 +39,7 @@
 void tcpv6_exit(void);
 
 int udpv6_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
+int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb);
 
 /* this does all the common and the specific ctl work */
 void ip6_datagram_recv_ctl(struct sock *sk, struct msghdr *msg,
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index b81eb7c..00142a5 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -75,13 +75,11 @@
 static void	tcp_v6_reqsk_send_ack(const struct sock *sk, struct sk_buff *skb,
 				      struct request_sock *req);
 
-static int	tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb);
-
-static const struct inet_connection_sock_af_ops ipv6_mapped;
-static const struct inet_connection_sock_af_ops ipv6_specific;
+const struct inet_connection_sock_af_ops ipv6_mapped;
+const struct inet_connection_sock_af_ops ipv6_specific;
 #ifdef CONFIG_TCP_MD5SIG
-static const struct tcp_sock_af_ops tcp_sock_ipv6_specific;
-static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific;
+const struct tcp_sock_af_ops tcp_sock_ipv6_specific;
+const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific;
 #else
 static struct tcp_md5sig_key *tcp_v6_md5_do_lookup(const struct sock *sk,
 						   const struct in6_addr *addr)
@@ -1276,7 +1274,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
  * This is because we cannot sleep with the original spinlock
  * held.
  */
-static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
+int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct tcp_sock *tp;
@@ -1403,6 +1401,7 @@ static int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 	kfree_skb(opt_skb);
 	return 0;
 }
+EXPORT_SYMBOL(tcp_v6_do_rcv);
 
 static void tcp_v6_fill_cb(struct sk_buff *skb, const struct ipv6hdr *hdr,
 			   const struct tcphdr *th)
@@ -1685,7 +1684,7 @@ static void tcp_v6_early_demux(struct sk_buff *skb)
 	.twsk_destructor = tcp_twsk_destructor,
 };
 
-static const struct inet_connection_sock_af_ops ipv6_specific = {
+const struct inet_connection_sock_af_ops ipv6_specific = {
 	.queue_xmit	   = inet6_csk_xmit,
 	.send_check	   = tcp_v6_send_check,
 	.rebuild_header	   = inet6_sk_rebuild_header,
@@ -1704,19 +1703,21 @@ static void tcp_v6_early_demux(struct sk_buff *skb)
 #endif
 	.mtu_reduced	   = tcp_v6_mtu_reduced,
 };
+EXPORT_SYMBOL(ipv6_specific);
 
 #ifdef CONFIG_TCP_MD5SIG
-static const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
+const struct tcp_sock_af_ops tcp_sock_ipv6_specific = {
 	.md5_lookup	=	tcp_v6_md5_lookup,
 	.calc_md5_hash	=	tcp_v6_md5_hash_skb,
 	.md5_parse	=	tcp_v6_parse_md5_keys,
 };
+EXPORT_SYMBOL(tcp_sock_ipv6_specific);
 #endif
 
 /*
  *	TCP over IPv4 via INET6 API
  */
-static const struct inet_connection_sock_af_ops ipv6_mapped = {
+const struct inet_connection_sock_af_ops ipv6_mapped = {
 	.queue_xmit	   = ip_queue_xmit,
 	.send_check	   = tcp_v4_send_check,
 	.rebuild_header	   = inet_sk_rebuild_header,
@@ -1734,13 +1735,15 @@ static void tcp_v6_early_demux(struct sk_buff *skb)
 #endif
 	.mtu_reduced	   = tcp_v4_mtu_reduced,
 };
+EXPORT_SYMBOL(ipv6_mapped);
 
 #ifdef CONFIG_TCP_MD5SIG
-static const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
+const struct tcp_sock_af_ops tcp_sock_ipv6_mapped_specific = {
 	.md5_lookup	=	tcp_v4_md5_lookup,
 	.calc_md5_hash	=	tcp_v4_md5_hash_skb,
 	.md5_parse	=	tcp_v6_parse_md5_keys,
 };
+EXPORT_SYMBOL(tcp_sock_ipv6_mapped_specific);
 #endif
 
 /* NOTE: A lot of things set to zero explicitly by call to
@@ -1994,6 +1997,7 @@ struct proto tcpv6_prot = {
 #endif
 	.diag_destroy		= tcp_abort,
 };
+EXPORT_SYMBOL(tcpv6_prot);
 
 /* thinking of making this const? Don't.
  * early_demux can change based on sysctl.
-- 
1.8.3.1
