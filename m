Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:30839 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbeLKKU6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 05:20:58 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Cc: dt@chelsio.com, atul.gupta@chelsio.com
Subject: [tls 5/5] crypto/chelsio/chtls: send/recv window update
Date: Tue, 11 Dec 2018 02:20:53 -0800
Message-Id: <20181211102053.3712-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

recalculated send and receive window using linkspeed.
Determine correct value of eck_ok from SYN received and
option configured on local system.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls.h    |  2 +
 drivers/crypto/chelsio/chtls/chtls_cm.c | 78 ++++++++++++++++++++++-----------
 2 files changed, 54 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index fcb6747..59bb67d 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -220,6 +220,8 @@ struct chtls_sock {
 	u16 resv2;
 	u32 delack_mode;
 	u32 delack_seq;
+	u32 snd_win;
+	u32 rcv_win;
 
 	void *passive_reap_next;        /* placeholder for passive */
 	struct chtls_hws tlshws;
diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 228b91b..59b7529 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -21,6 +21,7 @@
 #include <linux/kallsyms.h>
 #include <linux/kprobes.h>
 #include <linux/if_vlan.h>
+#include <net/inet_common.h>
 #include <net/tcp.h>
 #include <net/dst.h>
 
@@ -887,24 +888,6 @@ static unsigned int chtls_select_mss(const struct chtls_sock *csk,
 	return mtu_idx;
 }
 
-static unsigned int select_rcv_wnd(struct chtls_sock *csk)
-{
-	unsigned int rcvwnd;
-	unsigned int wnd;
-	struct sock *sk;
-
-	sk = csk->sk;
-	wnd = tcp_full_space(sk);
-
-	if (wnd < MIN_RCV_WND)
-		wnd = MIN_RCV_WND;
-
-	rcvwnd = MAX_RCV_WND;
-
-	csk_set_flag(csk, CSK_UPDATE_RCV_WND);
-	return min(wnd, rcvwnd);
-}
-
 static unsigned int select_rcv_wscale(int space, int wscale_ok, int win_clamp)
 {
 	int wscale = 0;
@@ -951,7 +934,7 @@ static void chtls_pass_accept_rpl(struct sk_buff *skb,
 	csk->mtu_idx = chtls_select_mss(csk, dst_mtu(__sk_dst_get(sk)),
 					req);
 	opt0 = TCAM_BYPASS_F |
-	       WND_SCALE_V((tp)->rx_opt.rcv_wscale) |
+	       WND_SCALE_V(RCV_WSCALE(tp)) |
 	       MSS_IDX_V(csk->mtu_idx) |
 	       L2T_IDX_V(csk->l2t_entry->idx) |
 	       NAGLE_V(!(tp->nonagle & TCP_NAGLE_OFF)) |
@@ -1005,6 +988,25 @@ static int chtls_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static void chtls_set_tcp_window(struct chtls_sock *csk)
+{
+	struct net_device *ndev = csk->egress_dev;
+	struct port_info *pi = netdev_priv(ndev);
+	unsigned int linkspeed;
+	u8 scale;
+
+	linkspeed = pi->link_cfg.speed;
+	scale = linkspeed / SPEED_10000;
+#define CHTLS_10G_RCVWIN (256 * 1024)
+	csk->rcv_win = CHTLS_10G_RCVWIN;
+	if (scale)
+		csk->rcv_win *= scale;
+#define CHTLS_10G_SNDWIN (256 * 1024)
+	csk->snd_win = CHTLS_10G_SNDWIN;
+	if (scale)
+		csk->snd_win *= scale;
+}
+
 static struct sock *chtls_recv_sock(struct sock *lsk,
 				    struct request_sock *oreq,
 				    void *network_hdr,
@@ -1067,6 +1069,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	csk->port_id = port_id;
 	csk->egress_dev = ndev;
 	csk->tos = PASS_OPEN_TOS_G(ntohl(req->tos_stid));
+	chtls_set_tcp_window(csk);
+	tp->rcv_wnd = csk->rcv_win;
+	csk->sndbuf = csk->snd_win;
 	csk->ulp_mode = ULP_MODE_TLS;
 	step = cdev->lldi->nrxq / cdev->lldi->nchan;
 	csk->rss_qid = cdev->lldi->rxq_ids[port_id * step];
@@ -1075,9 +1080,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 			port_id * step;
 	csk->sndbuf = newsk->sk_sndbuf;
 	csk->smac_idx = ((struct port_info *)netdev_priv(ndev))->smt_idx;
-	tp->rcv_wnd = select_rcv_wnd(csk);
 	RCV_WSCALE(tp) = select_rcv_wscale(tcp_full_space(newsk),
-					   WSCALE_OK(tp),
+					   sock_net(newsk)->
+						ipv4.sysctl_tcp_window_scaling,
 					   tp->window_clamp);
 	neigh_release(n);
 	inet_inherit_port(&tcp_hashinfo, lsk, newsk);
@@ -1129,6 +1134,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 	struct cpl_t5_pass_accept_rpl *rpl;
 	struct cpl_pass_accept_req *req;
 	struct listen_ctx *listen_ctx;
+	struct vlan_ethhdr *vlan_eh;
 	struct request_sock *oreq;
 	struct sk_buff *reply_skb;
 	struct chtls_sock *csk;
@@ -1141,6 +1147,10 @@ static void chtls_pass_accept_request(struct sock *sk,
 	unsigned int stid;
 	unsigned int len;
 	unsigned int tid;
+	bool th_ecn, ect;
+	__u8 ip_dsfield; /* IPv4 tos or IPv6 dsfield */
+	u16 eth_hdr_len;
+	bool ecn_ok;
 
 	req = cplhdr(skb) + RSS_HDR;
 	tid = GET_TID(req);
@@ -1179,24 +1189,40 @@ static void chtls_pass_accept_request(struct sock *sk,
 	oreq->mss = 0;
 	oreq->ts_recent = 0;
 
-	eh = (struct ethhdr *)(req + 1);
-	iph = (struct iphdr *)(eh + 1);
+	eth_hdr_len = T6_ETH_HDR_LEN_G(ntohl(req->hdr_len));
+	if (eth_hdr_len == ETH_HLEN) {
+		eh = (struct ethhdr *)(req + 1);
+		iph = (struct iphdr *)(eh + 1);
+		network_hdr = (void *)(eh + 1);
+	} else {
+		vlan_eh = (struct vlan_ethhdr *)(req + 1);
+		iph = (struct iphdr *)(vlan_eh + 1);
+		network_hdr = (void *)(vlan_eh + 1);
+	}
 	if (iph->version != 0x4)
 		goto free_oreq;
 
-	network_hdr = (void *)(eh + 1);
 	tcph = (struct tcphdr *)(iph + 1);
+	skb_set_network_header(skb, (void *)iph - (void *)req);
 
 	tcp_rsk(oreq)->tfo_listener = false;
 	tcp_rsk(oreq)->rcv_isn = ntohl(tcph->seq);
 	chtls_set_req_port(oreq, tcph->source, tcph->dest);
-	inet_rsk(oreq)->ecn_ok = 0;
 	chtls_set_req_addr(oreq, iph->daddr, iph->saddr);
-	if (req->tcpopt.wsf <= 14) {
+	ip_dsfield = ipv4_get_dsfield(iph);
+	if (req->tcpopt.wsf <= 14 &&
+	    sock_net(sk)->ipv4.sysctl_tcp_window_scaling) {
 		inet_rsk(oreq)->wscale_ok = 1;
 		inet_rsk(oreq)->snd_wscale = req->tcpopt.wsf;
 	}
 	inet_rsk(oreq)->ir_iif = sk->sk_bound_dev_if;
+	th_ecn = tcph->ece && tcph->cwr;
+	if (th_ecn) {
+		ect = !INET_ECN_is_not_ect(ip_dsfield);
+		ecn_ok = sock_net(sk)->ipv4.sysctl_tcp_ecn;
+		if ((!ect && ecn_ok) || tcp_ca_needs_ecn(sk))
+			inet_rsk(oreq)->ecn_ok = 1;
+	}
 
 	newsk = chtls_recv_sock(sk, oreq, network_hdr, req, cdev);
 	if (!newsk)
-- 
1.8.3.1
