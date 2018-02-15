From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [Crypto v5 03/12] support for inline tls
Date: Thu, 15 Feb 2018 12:24:45 +0530
Message-ID: <1518677694-28448-4-git-send-email-atul.gupta@chelsio.com>
References: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
Cc: sd@queasysnail.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, ganeshgr@chelsio.com
To: davejwatson@fb.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:56523 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754783AbeBOGzi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 01:55:38 -0500
In-Reply-To: <1518677694-28448-1-git-send-email-atul.gupta@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Facility to register Inline TLS drivers to net/tls. Setup
TLS_FULL_HW prot to listen on offload device.

Cases handled
1. Inline TLS device exists, setup prot for TLS_FULL_HW
2. Atleast one Inline TLS exists, sets TLS_FULL_HW. If
non-inline capable device establish connection, move to TLS_SW_TX
3. default mode TLS_SW_TX continues

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 net/tls/tls_main.c | 124 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 117 insertions(+), 7 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index e07ee3a..81c61e9 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -38,6 +38,7 @@
 #include <linux/highmem.h>
 #include <linux/netdevice.h>
 #include <linux/sched/signal.h>
+#include <linux/inetdevice.h>
 
 #include <net/tls.h>
 
@@ -45,13 +46,9 @@
 MODULE_DESCRIPTION("Transport Layer Security Support");
 MODULE_LICENSE("Dual BSD/GPL");
 
-enum {
-	TLS_BASE_TX,
-	TLS_SW_TX,
-	TLS_NUM_CONFIG,
-};
-
-static struct proto tls_prots[TLS_NUM_CONFIG];
+static LIST_HEAD(device_list);
+static DEFINE_MUTEX(device_mutex);
+struct proto tls_prots[TLS_NUM_CONFIG];
 
 static inline void update_sk_prot(struct sock *sk, struct tls_context *ctx)
 {
@@ -260,6 +257,38 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	sk_proto_close(sk, timeout);
 }
 
+static struct net_device *get_netdev(struct sock *sk)
+{
+	struct inet_sock *inet = inet_sk(sk);
+	struct net_device *netdev = NULL;
+
+	netdev = dev_get_by_index(sock_net(sk), inet->cork.fl.flowi_oif);
+	return netdev;
+}
+
+static int get_tls_offload_dev(struct sock *sk)
+{
+	struct net_device *netdev;
+	struct tls_device *dev;
+	int rc = -EINVAL;
+
+	netdev = get_netdev(sk);
+	if (!netdev)
+		goto out;
+
+	mutex_lock(&device_mutex);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->netdev && dev->netdev(dev, netdev)) {
+			rc = 0;
+			break;
+		}
+	}
+	mutex_unlock(&device_mutex);
+	dev_put(netdev);
+out:
+	return rc;
+}
+
 static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 				int __user *optlen)
 {
@@ -401,6 +430,15 @@ static int do_tls_setsockopt_tx(struct sock *sk, char __user *optval,
 		goto out;
 	}
 
+	rc = get_tls_offload_dev(sk);
+	if (rc) {
+		goto out;
+	} else {
+		/* Retain HW unhash for cleanup and move to SW Tx */
+		sk->sk_prot[TLS_BASE_TX].unhash =
+			sk->sk_prot[TLS_FULL_HW].unhash;
+	}
+
 	/* currently SW is default, we will have ethtool in future */
 	rc = tls_set_sw_offload(sk, ctx);
 	tx_conf = TLS_SW_TX;
@@ -448,6 +486,54 @@ static int tls_setsockopt(struct sock *sk, int level, int optname,
 	return do_tls_setsockopt(sk, optname, optval, optlen);
 }
 
+static int tls_hw_prot(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_device *dev;
+
+	mutex_lock(&device_mutex);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->feature && dev->feature(dev)) {
+			ctx->tx_conf = TLS_FULL_HW;
+			update_sk_prot(sk, ctx);
+			break;
+		}
+	}
+	mutex_unlock(&device_mutex);
+	return ctx->tx_conf;
+}
+
+static void tls_hw_unhash(struct sock *sk)
+{
+	struct tls_device *dev;
+
+	mutex_lock(&device_mutex);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->unhash)
+			dev->unhash(dev, sk);
+	}
+	mutex_unlock(&device_mutex);
+	tcp_prot.unhash(sk);
+}
+
+static int tls_hw_hash(struct sock *sk)
+{
+	struct tls_device *dev;
+	int err;
+
+	err = tcp_prot.hash(sk);
+	mutex_lock(&device_mutex);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->hash)
+			err |= dev->hash(dev, sk);
+	}
+	mutex_unlock(&device_mutex);
+
+	if (err)
+		tls_hw_unhash(sk);
+	return err;
+}
+
 static int tls_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -466,6 +552,9 @@ static int tls_init(struct sock *sk)
 	ctx->sk_proto_close = sk->sk_prot->close;
 
 	ctx->tx_conf = TLS_BASE_TX;
+	if (tls_hw_prot(sk) == TLS_FULL_HW)
+		goto out;
+
 	update_sk_prot(sk, ctx);
 out:
 	return rc;
@@ -487,7 +576,27 @@ static void build_protos(struct proto *prot, struct proto *base)
 	prot[TLS_SW_TX] = prot[TLS_BASE_TX];
 	prot[TLS_SW_TX].sendmsg		= tls_sw_sendmsg;
 	prot[TLS_SW_TX].sendpage	= tls_sw_sendpage;
+
+	prot[TLS_FULL_HW] = prot[TLS_BASE_TX];
+	prot[TLS_FULL_HW].hash          = tls_hw_hash;
+	prot[TLS_FULL_HW].unhash        = tls_hw_unhash;
+}
+
+void tls_register_device(struct tls_device *device)
+{
+	mutex_lock(&device_mutex);
+	list_add_tail(&device->dev_list, &device_list);
+	mutex_unlock(&device_mutex);
+}
+EXPORT_SYMBOL(tls_register_device);
+
+void tls_unregister_device(struct tls_device *device)
+{
+	mutex_lock(&device_mutex);
+	list_del(&device->dev_list);
+	mutex_unlock(&device_mutex);
 }
+EXPORT_SYMBOL(tls_unregister_device);
 
 static int __init tls_register(void)
 {
@@ -497,6 +606,7 @@ static int __init tls_register(void)
 
 	return 0;
 }
+EXPORT_SYMBOL(tls_prots);
 
 static void __exit tls_unregister(void)
 {
-- 
1.8.3.1
