From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [Crypto v4 03/12] support for inline tls
Date: Mon, 12 Feb 2018 17:34:28 +0530
Message-ID: <1518437068-14338-1-git-send-email-atul.gupta@chelsio.com>
Cc: sd@queasysnail.net, linux-crypto@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, ganeshgr@chelsio.com
To: davejwatson@fb.com, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:56933 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753979AbeBLMEp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Feb 2018 07:04:45 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 net/tls/tls_main.c | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index e07ee3a..10a6d5d 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -38,6 +38,7 @@
 #include <linux/highmem.h>
 #include <linux/netdevice.h>
 #include <linux/sched/signal.h>
+#include <linux/inetdevice.h>
 
 #include <net/tls.h>
 
@@ -48,9 +49,12 @@
 enum {
 	TLS_BASE_TX,
 	TLS_SW_TX,
+	TLS_FULL_HW, /* TLS record processed Inline */
 	TLS_NUM_CONFIG,
 };
 
+static LIST_HEAD(device_list);
+static DEFINE_MUTEX(device_mutex);
 static struct proto tls_prots[TLS_NUM_CONFIG];
 
 static inline void update_sk_prot(struct sock *sk, struct tls_context *ctx)
@@ -448,6 +452,92 @@ static int tls_setsockopt(struct sock *sk, int level, int optname,
 	return do_tls_setsockopt(sk, optname, optval, optlen);
 }
 
+static struct net_device *find_netdev(struct sock *sk)
+{
+	struct net_device *netdev = NULL;
+
+	netdev = __ip_dev_find(&init_net, inet_sk(sk)->inet_rcv_saddr, false);
+	return netdev;
+}
+
+static int get_tls_prot(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	struct net_device *netdev;
+	struct tls_device *dev;
+
+	/* Device bound to specific IP */
+	if (inet_sk(sk)->inet_rcv_saddr) {
+		netdev = find_netdev(sk);
+		if (!netdev)
+			goto out;
+
+		/* Device supports Inline record processing */
+		if (!(netdev->features & NETIF_F_HW_TLS_INLINE))
+			goto out;
+
+		mutex_lock(&device_mutex);
+		list_for_each_entry(dev, &device_list, dev_list) {
+			if (dev->netdev && dev->netdev(dev, netdev))
+				break;
+		}
+		mutex_unlock(&device_mutex);
+
+		ctx->tx_conf = TLS_FULL_HW;
+		if (dev->prot)
+			dev->prot(dev, sk);
+	} else { /* src address not known or INADDR_ANY */
+		mutex_lock(&device_mutex);
+		list_for_each_entry(dev, &device_list, dev_list) {
+			if (dev->feature && dev->feature(dev)) {
+				ctx->tx_conf = TLS_FULL_HW;
+				break;
+			}
+		}
+		mutex_unlock(&device_mutex);
+		update_sk_prot(sk, ctx);
+	}
+out:
+	return ctx->tx_conf;
+}
+
+static int tls_hw_prot(struct sock *sk)
+{
+	/* search registered tls device for netdev */
+	return get_tls_prot(sk);
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
@@ -466,6 +556,9 @@ static int tls_init(struct sock *sk)
 	ctx->sk_proto_close = sk->sk_prot->close;
 
 	ctx->tx_conf = TLS_BASE_TX;
+	if (tls_hw_prot(sk) == TLS_FULL_HW)
+		goto out;
+
 	update_sk_prot(sk, ctx);
 out:
 	return rc;
@@ -487,7 +580,27 @@ static void build_protos(struct proto *prot, struct proto *base)
 	prot[TLS_SW_TX] = prot[TLS_BASE_TX];
 	prot[TLS_SW_TX].sendmsg		= tls_sw_sendmsg;
 	prot[TLS_SW_TX].sendpage	= tls_sw_sendpage;
+
+	prot[TLS_FULL_HW]               = prot[TLS_BASE_TX];
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
-- 
1.8.3.1
