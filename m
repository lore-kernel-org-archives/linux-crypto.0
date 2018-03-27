From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH v13 net-next 01/12] tls: support for Inline tls record
Date: Tue, 27 Mar 2018 23:06:30 +0530
Message-ID: <1522172201-7629-2-git-send-email-atul.gupta@chelsio.com>
References: <1522172201-7629-1-git-send-email-atul.gupta@chelsio.com>
Cc: davejwatson@fb.com, sd@queasysnail.net, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522172201-7629-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Facility to register Inline TLS drivers to net/tls. Setup
TLS_HW_RECORD prot to listen on offload device.

Cases handled
- Inline TLS device exists, setup prot for TLS_HW_RECORD
- Atleast one Inline TLS exists, sets TLS_HW_RECORD.
- If non-inline device establish connection, move to TLS_SW_TX

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
Reviewed-by: Dave Watson <davejwatson@fb.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
---
 include/net/tls.h  |  32 ++++++++++++++-
 net/tls/tls_main.c | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 143 insertions(+), 4 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 437a746..3da8e13 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -56,6 +56,32 @@
 #define TLS_RECORD_TYPE_DATA		0x17
 
 #define TLS_AAD_SPACE_SIZE		13
+#define TLS_DEVICE_NAME_MAX		32
+
+/*
+ * This structure defines the routines for Inline TLS driver.
+ * The following routines are optional and filled with a
+ * null pointer if not defined.
+ *
+ * @name: Its the name of registered Inline tls device
+ * @dev_list: Inline tls device list
+ * int (*feature)(struct tls_device *device);
+ *     Called to return Inline TLS driver capability
+ *
+ * int (*hash)(struct tls_device *device, struct sock *sk);
+ *     This function sets Inline driver for listen and program
+ *     device specific functioanlity as required
+ *
+ * void (*unhash)(struct tls_device *device, struct sock *sk);
+ *     This function cleans listen state set by Inline TLS driver
+ */
+struct tls_device {
+	char name[TLS_DEVICE_NAME_MAX];
+	struct list_head dev_list;
+	int  (*feature)(struct tls_device *device);
+	int  (*hash)(struct tls_device *device, struct sock *sk);
+	void (*unhash)(struct tls_device *device, struct sock *sk);
+};
 
 struct tls_sw_context {
 	struct crypto_aead *aead_send;
@@ -114,7 +140,7 @@ struct tls_context {
 
 	void *priv_ctx;
 
-	u8 conf:2;
+	u8 conf:3;
 
 	struct cipher_context tx;
 	struct cipher_context rx;
@@ -135,6 +161,8 @@ struct tls_context {
 	int  (*getsockopt)(struct sock *sk, int level,
 			   int optname, char __user *optval,
 			   int __user *optlen);
+	int  (*hash)(struct sock *sk);
+	void (*unhash)(struct sock *sk);
 };
 
 int wait_on_pending_writer(struct sock *sk, long *timeo);
@@ -283,5 +311,7 @@ static inline struct tls_offload_context *tls_offload_ctx(
 
 int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type);
+void tls_register_device(struct tls_device *device);
+void tls_unregister_device(struct tls_device *device);
 
 #endif /* _TLS_OFFLOAD_H */
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 6f5c114..0b5a496 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -38,6 +38,7 @@
 #include <linux/highmem.h>
 #include <linux/netdevice.h>
 #include <linux/sched/signal.h>
+#include <linux/inetdevice.h>
 
 #include <net/tls.h>
 
@@ -56,11 +57,14 @@ enum {
 	TLS_SW_TX,
 	TLS_SW_RX,
 	TLS_SW_RXTX,
+	TLS_HW_RECORD,
 	TLS_NUM_CONFIG,
 };
 
 static struct proto *saved_tcpv6_prot;
 static DEFINE_MUTEX(tcpv6_prot_mutex);
+static LIST_HEAD(device_list);
+static DEFINE_MUTEX(device_mutex);
 static struct proto tls_prots[TLS_NUM_PROTS][TLS_NUM_CONFIG];
 static struct proto_ops tls_sw_proto_ops;
 
@@ -241,8 +245,12 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	lock_sock(sk);
 	sk_proto_close = ctx->sk_proto_close;
 
+	if (ctx->conf == TLS_HW_RECORD)
+		goto skip_tx_cleanup;
+
 	if (ctx->conf == TLS_BASE) {
 		kfree(ctx);
+		ctx = NULL;
 		goto skip_tx_cleanup;
 	}
 
@@ -276,6 +284,11 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 skip_tx_cleanup:
 	release_sock(sk);
 	sk_proto_close(sk, timeout);
+	/* free ctx for TLS_HW_RECORD, used by tcp_set_state
+	 * for sk->sk_prot->unhash [tls_hw_unhash]
+	 */
+	if (ctx && ctx->conf == TLS_HW_RECORD)
+		kfree(ctx);
 }
 
 static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
@@ -493,6 +506,80 @@ static int tls_setsockopt(struct sock *sk, int level, int optname,
 	return do_tls_setsockopt(sk, optname, optval, optlen);
 }
 
+static struct tls_context *create_ctx(struct sock *sk)
+{
+	struct inet_connection_sock *icsk = inet_csk(sk);
+	struct tls_context *ctx;
+
+	/* allocate tls context */
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	icsk->icsk_ulp_data = ctx;
+	return ctx;
+}
+
+static int tls_hw_prot(struct sock *sk)
+{
+	struct tls_context *ctx;
+	struct tls_device *dev;
+	int rc = 0;
+
+	mutex_lock(&device_mutex);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->feature && dev->feature(dev)) {
+			ctx = create_ctx(sk);
+			if (!ctx)
+				goto out;
+
+			ctx->hash = sk->sk_prot->hash;
+			ctx->unhash = sk->sk_prot->unhash;
+			ctx->sk_proto_close = sk->sk_prot->close;
+			ctx->conf = TLS_HW_RECORD;
+			update_sk_prot(sk, ctx);
+			rc = 1;
+			break;
+		}
+	}
+out:
+	mutex_unlock(&device_mutex);
+	return rc;
+}
+
+static void tls_hw_unhash(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_device *dev;
+
+	mutex_lock(&device_mutex);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->unhash)
+			dev->unhash(dev, sk);
+	}
+	mutex_unlock(&device_mutex);
+	ctx->unhash(sk);
+}
+
+static int tls_hw_hash(struct sock *sk)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	struct tls_device *dev;
+	int err;
+
+	err = ctx->hash(sk);
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
 static void build_protos(struct proto *prot, struct proto *base)
 {
 	prot[TLS_BASE] = *base;
@@ -511,15 +598,22 @@ static void build_protos(struct proto *prot, struct proto *base)
 	prot[TLS_SW_RXTX] = prot[TLS_SW_TX];
 	prot[TLS_SW_RXTX].recvmsg	= tls_sw_recvmsg;
 	prot[TLS_SW_RXTX].close		= tls_sk_proto_close;
+
+	prot[TLS_HW_RECORD] = *base;
+	prot[TLS_HW_RECORD].hash	= tls_hw_hash;
+	prot[TLS_HW_RECORD].unhash	= tls_hw_unhash;
+	prot[TLS_HW_RECORD].close	= tls_sk_proto_close;
 }
 
 static int tls_init(struct sock *sk)
 {
 	int ip_ver = sk->sk_family == AF_INET6 ? TLSV6 : TLSV4;
-	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tls_context *ctx;
 	int rc = 0;
 
+	if (tls_hw_prot(sk))
+		goto out;
+
 	/* The TLS ulp is currently supported only for TCP sockets
 	 * in ESTABLISHED state.
 	 * Supporting sockets in LISTEN state will require us
@@ -530,12 +624,11 @@ static int tls_init(struct sock *sk)
 		return -ENOTSUPP;
 
 	/* allocate tls context */
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = create_ctx(sk);
 	if (!ctx) {
 		rc = -ENOMEM;
 		goto out;
 	}
-	icsk->icsk_ulp_data = ctx;
 	ctx->setsockopt = sk->sk_prot->setsockopt;
 	ctx->getsockopt = sk->sk_prot->getsockopt;
 	ctx->sk_proto_close = sk->sk_prot->close;
@@ -557,6 +650,22 @@ static int tls_init(struct sock *sk)
 	return rc;
 }
 
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
+}
+EXPORT_SYMBOL(tls_unregister_device);
+
 static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.name			= "tls",
 	.uid			= TCP_ULP_TLS,
-- 
1.8.3.1
