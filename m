Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:39448 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfARE4O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 23:56:14 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Cc: atul.gupta@chelsio.com
Subject: [net-next 1/3] net/tls: build_protos moved to common routine
Date: Thu, 17 Jan 2019 20:55:53 -0800
Message-Id: <20190118045553.2774-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

build protos is required for tls_hw_prot also hence moved to
'tls_build_proto' and called as required from tls_init
and tls_hw_proto. This is required since build_protos
for v4 is moved from tls_register to tls_init in
commit <28cb6f1eaffdc5a6a9707cac55f4a43aa3fd7895>

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 net/tls/tls_main.c | 54 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 78cb4a5..fc97a10 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -61,6 +61,8 @@ enum {
 static DEFINE_SPINLOCK(device_spinlock);
 static struct proto tls_prots[TLS_NUM_PROTS][TLS_NUM_CONFIG][TLS_NUM_CONFIG];
 static struct proto_ops tls_sw_proto_ops;
+static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
+			 struct proto *base);
 
 static void update_sk_prot(struct sock *sk, struct tls_context *ctx)
 {
@@ -551,6 +553,32 @@ static struct tls_context *create_ctx(struct sock *sk)
 	return ctx;
 }
 
+static void tls_build_proto(struct sock *sk)
+{
+	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
+
+	/* Build IPv6 TLS whenever the address of tcpv6 _prot changes */
+	if (ip_ver == TLSV6 &&
+	    unlikely(sk->sk_prot != smp_load_acquire(&saved_tcpv6_prot))) {
+		mutex_lock(&tcpv6_prot_mutex);
+		if (likely(sk->sk_prot != saved_tcpv6_prot)) {
+			build_protos(tls_prots[TLSV6], sk->sk_prot);
+			smp_store_release(&saved_tcpv6_prot, sk->sk_prot);
+		}
+		mutex_unlock(&tcpv6_prot_mutex);
+	}
+
+	if (ip_ver == TLSV4 &&
+	    unlikely(sk->sk_prot != smp_load_acquire(&saved_tcpv4_prot))) {
+		mutex_lock(&tcpv4_prot_mutex);
+		if (likely(sk->sk_prot != saved_tcpv4_prot)) {
+			build_protos(tls_prots[TLSV4], sk->sk_prot);
+			smp_store_release(&saved_tcpv4_prot, sk->sk_prot);
+		}
+		mutex_unlock(&tcpv4_prot_mutex);
+	}
+}
+
 static int tls_hw_prot(struct sock *sk)
 {
 	struct tls_context *ctx;
@@ -564,12 +592,15 @@ static int tls_hw_prot(struct sock *sk)
 			if (!ctx)
 				goto out;
 
+			spin_unlock_bh(&device_spinlock);
+			tls_build_proto(sk);
 			ctx->hash = sk->sk_prot->hash;
 			ctx->unhash = sk->sk_prot->unhash;
 			ctx->sk_proto_close = sk->sk_prot->close;
 			ctx->rx_conf = TLS_HW_RECORD;
 			ctx->tx_conf = TLS_HW_RECORD;
 			update_sk_prot(sk, ctx);
+			spin_lock_bh(&device_spinlock);
 			rc = 1;
 			break;
 		}
@@ -668,7 +699,6 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 
 static int tls_init(struct sock *sk)
 {
-	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
 	struct tls_context *ctx;
 	int rc = 0;
 
@@ -691,27 +721,7 @@ static int tls_init(struct sock *sk)
 		goto out;
 	}
 
-	/* Build IPv6 TLS whenever the address of tcpv6	_prot changes */
-	if (ip_ver == TLSV6 &&
-	    unlikely(sk->sk_prot != smp_load_acquire(&saved_tcpv6_prot))) {
-		mutex_lock(&tcpv6_prot_mutex);
-		if (likely(sk->sk_prot != saved_tcpv6_prot)) {
-			build_protos(tls_prots[TLSV6], sk->sk_prot);
-			smp_store_release(&saved_tcpv6_prot, sk->sk_prot);
-		}
-		mutex_unlock(&tcpv6_prot_mutex);
-	}
-
-	if (ip_ver == TLSV4 &&
-	    unlikely(sk->sk_prot != smp_load_acquire(&saved_tcpv4_prot))) {
-		mutex_lock(&tcpv4_prot_mutex);
-		if (likely(sk->sk_prot != saved_tcpv4_prot)) {
-			build_protos(tls_prots[TLSV4], sk->sk_prot);
-			smp_store_release(&saved_tcpv4_prot, sk->sk_prot);
-		}
-		mutex_unlock(&tcpv4_prot_mutex);
-	}
-
+	tls_build_proto(sk);
 	ctx->tx_conf = TLS_BASE;
 	ctx->rx_conf = TLS_BASE;
 	update_sk_prot(sk, ctx);
-- 
1.8.3.1
