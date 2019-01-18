Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:11372 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfARE43 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 23:56:29 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Cc: atul.gupta@chelsio.com
Subject: [net-next 2/3] net/tls: free ctx in sock destruct
Date: Thu, 17 Jan 2019 20:56:21 -0800
Message-Id: <20190118045621.2822-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

free tls context in sock destruct. close may not be the last
call to free sock but force releasing the ctx in close
will result in GPF when ctx referred again in tcp_done

[  515.330477] general protection fault: 0000 [#1] SMP PTI
[  515.330539] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 4.20.0-rc7+ #10
[  515.330657] Hardware name: Supermicro X8ST3/X8ST3, BIOS 2.0b
11/07/2013
[  515.330844] RIP: 0010:tls_hw_unhash+0xbf/0xd0
[
[  515.332220] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  515.332340] CR2: 00007fab32c55000 CR3: 000000009261e000 CR4:
00000000000006e0
[  515.332519] Call Trace:
[  515.332632]  <IRQ>
[  515.332793]  tcp_set_state+0x5a/0x190
[  515.332907]  ? tcp_update_metrics+0xe3/0x350
[  515.333023]  tcp_done+0x31/0xd0
[  515.333130]  tcp_rcv_state_process+0xc27/0x111a
[  515.333242]  ? __lock_is_held+0x4f/0x90
[  515.333350]  ? tcp_v4_do_rcv+0xaf/0x1e0
[  515.333456]  tcp_v4_do_rcv+0xaf/0x1e0

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |  4 ++++
 net/tls/tls_main.c                      | 19 +++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index 59b7529..2e11b0d 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -24,6 +24,7 @@
 #include <net/inet_common.h>
 #include <net/tcp.h>
 #include <net/dst.h>
+#include <net/tls.h>
 
 #include "chtls.h"
 #include "chtls_cm.h"
@@ -1015,6 +1016,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 {
 	struct inet_sock *newinet;
 	const struct iphdr *iph;
+	struct tls_context *ctx;
 	struct net_device *ndev;
 	struct chtls_sock *csk;
 	struct dst_entry *dst;
@@ -1063,6 +1065,8 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 
 	oreq->ts_recent = PASS_OPEN_TID_G(ntohl(req->tos_stid));
 	sk_setup_caps(newsk, dst);
+	ctx = tls_get_ctx(lsk);
+	newsk->sk_destruct = ctx->sk_destruct;
 	csk->sk = newsk;
 	csk->passive_reap_next = oreq;
 	csk->tx_chan = cxgb4_port_chan(ndev);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index fc97a10..d36d095 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -266,8 +266,10 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	lock_sock(sk);
 	sk_proto_close = ctx->sk_proto_close;
 
-	if ((ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD) ||
-	    (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE)) {
+	if (ctx->tx_conf == TLS_HW_RECORD && ctx->rx_conf == TLS_HW_RECORD)
+		goto skip_tx_cleanup;
+
+	if (ctx->tx_conf == TLS_BASE && ctx->rx_conf == TLS_BASE) {
 		free_ctx = true;
 		goto skip_tx_cleanup;
 	}
@@ -579,6 +581,17 @@ static void tls_build_proto(struct sock *sk)
 	}
 }
 
+static void tls_hw_sk_destruct(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	ctx->sk_destruct(sk);
+	/* Free ctx */
+	kfree(ctx);
+	icsk->icsk_ulp_data = NULL;
+}
+
 static int tls_hw_prot(struct sock *sk)
 {
 	struct tls_context *ctx;
@@ -597,6 +610,8 @@ static int tls_hw_prot(struct sock *sk)
 			ctx->hash = sk->sk_prot->hash;
 			ctx->unhash = sk->sk_prot->unhash;
 			ctx->sk_proto_close = sk->sk_prot->close;
+			ctx->sk_destruct = sk->sk_destruct;
+			sk->sk_destruct = tls_hw_sk_destruct;
 			ctx->rx_conf = TLS_HW_RECORD;
 			ctx->tx_conf = TLS_HW_RECORD;
 			update_sk_prot(sk, ctx);
-- 
1.8.3.1
