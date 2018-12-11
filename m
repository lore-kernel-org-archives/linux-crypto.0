Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:5258 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbeLKKUb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 05:20:31 -0500
From: Atul Gupta <atul.gupta@chelsio.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Cc: dt@chelsio.com, atul.gupta@chelsio.com
Subject: [tls 3/5] crypto/chelsio/chtls: listen fails with multiadapt
Date: Tue, 11 Dec 2018 02:20:26 -0800
Message-Id: <20181211102026.3610-1-atul.gupta@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

listen fails when more than one tls capable device is
registered. tls_hw_hash is called for each dev which loops
again for each cdev_list causing listen failure. Hence
call chtls_listen_start/stop for specific device than loop over all
devices.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/chtls/chtls.h      |  5 ++++
 drivers/crypto/chelsio/chtls/chtls_main.c | 50 +++++++++++++++++++------------
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index 7725b6e..fcb6747 100644
--- a/drivers/crypto/chelsio/chtls/chtls.h
+++ b/drivers/crypto/chelsio/chtls/chtls.h
@@ -153,6 +153,11 @@ struct chtls_dev {
 	unsigned int cdev_state;
 };
 
+struct chtls_listen {
+	struct chtls_dev *cdev;
+	struct sock *sk;
+};
+
 struct chtls_hws {
 	struct sk_buff_head sk_recv_queue;
 	u8 txqid;
diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index db40ab6..563f8fe 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -55,24 +55,19 @@ static void unregister_listen_notifier(struct notifier_block *nb)
 static int listen_notify_handler(struct notifier_block *this,
 				 unsigned long event, void *data)
 {
-	struct chtls_dev *cdev;
-	struct sock *sk;
-	int ret;
+	struct chtls_listen *clisten;
+	int ret = NOTIFY_DONE;
 
-	sk = data;
-	ret =  NOTIFY_DONE;
+	clisten = (struct chtls_listen *)data;
 
 	switch (event) {
 	case CHTLS_LISTEN_START:
+		ret = chtls_listen_start(clisten->cdev, clisten->sk);
+		kfree(clisten);
+		break;
 	case CHTLS_LISTEN_STOP:
-		mutex_lock(&cdev_list_lock);
-		list_for_each_entry(cdev, &cdev_list, list) {
-			if (event == CHTLS_LISTEN_START)
-				ret = chtls_listen_start(cdev, sk);
-			else
-				chtls_listen_stop(cdev, sk);
-		}
-		mutex_unlock(&cdev_list_lock);
+		chtls_listen_stop(clisten->cdev, clisten->sk);
+		kfree(clisten);
 		break;
 	}
 	return ret;
@@ -90,8 +85,9 @@ static int listen_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
-static int chtls_start_listen(struct sock *sk)
+static int chtls_start_listen(struct chtls_dev *cdev, struct sock *sk)
 {
+	struct chtls_listen *clisten;
 	int err;
 
 	if (sk->sk_protocol != IPPROTO_TCP)
@@ -102,21 +98,33 @@ static int chtls_start_listen(struct sock *sk)
 		return -EADDRNOTAVAIL;
 
 	sk->sk_backlog_rcv = listen_backlog_rcv;
+	clisten = kmalloc(sizeof(*clisten), GFP_KERNEL);
+	if (!clisten)
+		return -ENOMEM;
+	clisten->cdev = cdev;
+	clisten->sk = sk;
 	mutex_lock(&notify_mutex);
 	err = raw_notifier_call_chain(&listen_notify_list,
-				      CHTLS_LISTEN_START, sk);
+				      CHTLS_LISTEN_START, clisten);
 	mutex_unlock(&notify_mutex);
 	return err;
 }
 
-static void chtls_stop_listen(struct sock *sk)
+static void chtls_stop_listen(struct chtls_dev *cdev, struct sock *sk)
 {
+	struct chtls_listen *clisten;
+
 	if (sk->sk_protocol != IPPROTO_TCP)
 		return;
 
+	clisten = kmalloc(sizeof(*clisten), GFP_KERNEL);
+	if (!clisten)
+		return;
+	clisten->cdev = cdev;
+	clisten->sk = sk;
 	mutex_lock(&notify_mutex);
 	raw_notifier_call_chain(&listen_notify_list,
-				CHTLS_LISTEN_STOP, sk);
+				CHTLS_LISTEN_STOP, clisten);
 	mutex_unlock(&notify_mutex);
 }
 
@@ -138,15 +146,19 @@ static int chtls_inline_feature(struct tls_device *dev)
 
 static int chtls_create_hash(struct tls_device *dev, struct sock *sk)
 {
+	struct chtls_dev *cdev = to_chtls_dev(dev);
+
 	if (sk->sk_state == TCP_LISTEN)
-		return chtls_start_listen(sk);
+		return chtls_start_listen(cdev, sk);
 	return 0;
 }
 
 static void chtls_destroy_hash(struct tls_device *dev, struct sock *sk)
 {
+	struct chtls_dev *cdev = to_chtls_dev(dev);
+
 	if (sk->sk_state == TCP_LISTEN)
-		chtls_stop_listen(sk);
+		chtls_stop_listen(cdev, sk);
 }
 
 static void chtls_free_uld(struct chtls_dev *cdev)
-- 
1.8.3.1
