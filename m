Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B78C43215
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 06:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B19420674
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 06:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574404056;
	bh=t2V8Sq0VvaON+weVpHvFiteFpdcQUZGqb6wrVV0MoQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kc3RHyx4QP+WAtZDy1HjfqQjppSFLkU5gimnjW3OPfYAaWUkmGooPEJwN2a8ipGzp
	 Sj5QWfIiXm0cwnGqmQAZfEMyBBOet+YLEZUjPi8FzpqrMfRf2sxAVxmie7Ii1QOzmo
	 jk97TG1Y9q2t00Xkwm2IR/TzLT9+E7mbpjAsJ+U4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfKVFuY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 00:50:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727655AbfKVFuY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABAC82070E;
        Fri, 22 Nov 2019 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401823;
        bh=t2V8Sq0VvaON+weVpHvFiteFpdcQUZGqb6wrVV0MoQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oUcPcbQfjDTw+ucwaoPXjZ/epAlMPPNxLCDer6ppngcgCk9uh89XsQMmARrlGOpbD
         7FcQYJhD8aIdyZDS4bXMscoT2G2TRp0c4rsszuPc74XrOHAQj4sfGx5AKZEKHLKzma
         /nDvHjSdw5ZVALP4cu7EaWnDj0LNZ5XmJMYpRlC4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Atul Gupta <atul.gupta@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 066/219] crypto/chelsio/chtls: listen fails with multiadapt
Date:   Fri, 22 Nov 2019 00:46:38 -0500
Message-Id: <20191122054911.1750-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Atul Gupta <atul.gupta@chelsio.com>

[ Upstream commit 6422ccc5fbefbd219f3fab133f698e58f5aa44eb ]

listen fails when more than one tls capable device is
registered. tls_hw_hash is called for each dev which loops
again for each cdev_list causing listen failure. Hence
call chtls_listen_start/stop for specific device than loop over all
devices.

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/chelsio/chtls/chtls.h      |  5 +++
 drivers/crypto/chelsio/chtls/chtls_main.c | 50 ++++++++++++++---------
 2 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls.h b/drivers/crypto/chelsio/chtls/chtls.h
index 7725b6ee14efb..fcb6747ed29ea 100644
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
index f59b044ebd255..2bf084afe9b58 100644
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
 
 static void chtls_register_dev(struct chtls_dev *cdev)
-- 
2.20.1

