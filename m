Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:7854 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727248AbfARHNh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 02:13:37 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Cc: atul.gupta@chelsio.com
Subject: [RFC patch 1/4] net/tls: connect routine for Inline TLS client
Date: Thu, 17 Jan 2019 23:13:31 -0800
Message-Id: <20190118071331.9532-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Define tls_hw_connect to setup Inline TLS client before
TLS handshake and key program

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 include/net/tls.h  |  5 +++++
 net/tls/tls_main.c | 23 +++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index 90bf52d..f467cc1 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -77,6 +77,8 @@
  * void (*unhash)(struct tls_device *device, struct sock *sk);
  *     This function cleans listen state set by Inline TLS driver
  *
+ * int  (*connect)(struct tls_device *device, struct sock *sk,
+ *                 struct sockaddr *uaddr, int addr_len);
  * void (*release)(struct kref *kref);
  *     Release the registered device and allocated resources
  * @kref: Number of reference to tls_device
@@ -87,6 +89,8 @@ struct tls_device {
 	int  (*feature)(struct tls_device *device);
 	int  (*hash)(struct tls_device *device, struct sock *sk);
 	void (*unhash)(struct tls_device *device, struct sock *sk);
+	int  (*connect)(struct tls_device *device, struct sock *sk,
+			struct sockaddr *uaddr, int addr_len);
 	void (*release)(struct kref *kref);
 	struct kref kref;
 };
@@ -245,6 +249,7 @@ struct tls_context {
 			   int __user *optlen);
 	int  (*hash)(struct sock *sk);
 	void (*unhash)(struct sock *sk);
+	int  (*connect)(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 };
 
 struct tls_offload_context_rx {
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index d36d095..aec7b2a 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -592,6 +592,28 @@ static void tls_hw_sk_destruct(struct sock *sk)
 	icsk->icsk_ulp_data = NULL;
 }
 
+static int tls_hw_connect(struct sock *sk, struct sockaddr *uaddr,
+			  int addr_len)
+{
+	struct tls_device *dev;
+	int err;
+
+	spin_lock_bh(&device_spinlock);
+	list_for_each_entry(dev, &device_list, dev_list) {
+		if (dev->connect) {
+			kref_get(&dev->kref);
+			spin_unlock_bh(&device_spinlock);
+			err = dev->connect(dev, sk, uaddr, addr_len);
+			kref_put(&dev->kref, dev->release);
+			spin_lock_bh(&device_spinlock);
+			if (!err)
+				break;
+		}
+	}
+	spin_unlock_bh(&device_spinlock);
+	return err;
+}
+
 static int tls_hw_prot(struct sock *sk)
 {
 	struct tls_context *ctx;
@@ -709,6 +731,7 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_HW_RECORD][TLS_HW_RECORD] = *base;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].hash		= tls_hw_hash;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].unhash	= tls_hw_unhash;
+	prot[TLS_HW_RECORD][TLS_HW_RECORD].connect	= tls_hw_connect;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].close	= tls_sk_proto_close;
 }
 
-- 
1.8.3.1
