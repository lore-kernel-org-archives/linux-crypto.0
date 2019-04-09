Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA71C10F0E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA33D2084F
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 15:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfDIPXj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 11:23:39 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:9323 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfDIPXj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 11:23:39 -0400
Received: from beagle7.asicdesigners.com (beagle7.asicdesigners.com [10.192.192.157])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x39FNLVD003414;
        Tue, 9 Apr 2019 08:23:21 -0700
From:   Atul Gupta <atul.gupta@chelsio.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com, atul.gupta@chelsio.com
Subject: [crypto 1/4] net/tls: connect routine for Inine TLS Client
Date:   Tue,  9 Apr 2019 08:23:18 -0700
Message-Id: <20190409152318.11155-1-atul.gupta@chelsio.com>
X-Mailer: git-send-email 2.20.0.rc2.7.g965798d
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Define tls_hw_connect to allow hardware setup Inline TLS
client before TLS handshake and key program.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 include/net/tls.h  |  6 ++++++
 net/tls/tls_main.c | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index a5a9385..655c17e 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -77,6 +77,9 @@
  * void (*unhash)(struct tls_device *device, struct sock *sk);
  *     This function cleans listen state set by Inline TLS driver
  *
+ * int  (*connect)(struct tls_device *device, struct sock *sk,
+ *		   struct sockaddr *uaddr, int addr_len);
+ *
  * void (*release)(struct kref *kref);
  *     Release the registered device and allocated resources
  * @kref: Number of reference to tls_device
@@ -87,6 +90,8 @@ struct tls_device {
 	int  (*feature)(struct tls_device *device);
 	int  (*hash)(struct tls_device *device, struct sock *sk);
 	void (*unhash)(struct tls_device *device, struct sock *sk);
+	int  (*connect)(struct tls_device *device, struct sock *sk,
+			struct sockaddr *uaddr, int addr_len);
 	void (*release)(struct kref *kref);
 	struct kref kref;
 };
@@ -264,6 +269,7 @@ struct tls_context {
 			   int __user *optlen);
 	int  (*hash)(struct sock *sk);
 	void (*unhash)(struct sock *sk);
+	int  (*connect)(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 };
 
 struct tls_offload_context_rx {
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index df921a2..eaf60ca 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -620,6 +620,28 @@ static void tls_hw_sk_destruct(struct sock *sk)
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
@@ -737,6 +759,7 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_HW_RECORD][TLS_HW_RECORD] = *base;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].hash		= tls_hw_hash;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].unhash	= tls_hw_unhash;
+	prot[TLS_HW_RECORD][TLS_HW_RECORD].connect	= tls_hw_connect;
 	prot[TLS_HW_RECORD][TLS_HW_RECORD].close	= tls_sk_proto_close;
 }
 
-- 
1.8.3.1

