Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 698B5C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Oct 2021 08:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4547060FC3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Oct 2021 08:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhJUIlO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Oct 2021 04:41:14 -0400
Received: from mx22.baidu.com ([220.181.50.185]:42944 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231268AbhJUIlN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Oct 2021 04:41:13 -0400
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id EE4B11267F187F0A31EA;
        Thu, 21 Oct 2021 16:38:56 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 21 Oct 2021 16:38:56 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 21 Oct 2021 16:38:56 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: ccp - Make use of the helper macro kthread_run()
Date:   Thu, 21 Oct 2021 16:38:54 +0800
Message-ID: <20211021083854.1865-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX02.internal.baidu.com (172.31.51.42) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex13_2021-10-21 16:38:56:990
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Repalce kthread_create/wake_up_process() with kthread_run()
to simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/crypto/ccp/ccp-dev-v3.c | 5 ++---
 drivers/crypto/ccp/ccp-dev-v5.c | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
index 0d5576f6ad21..fe69053b2394 100644
--- a/drivers/crypto/ccp/ccp-dev-v3.c
+++ b/drivers/crypto/ccp/ccp-dev-v3.c
@@ -467,8 +467,8 @@ static int ccp_init(struct ccp_device *ccp)
 
 		cmd_q = &ccp->cmd_q[i];
 
-		kthread = kthread_create(ccp_cmd_queue_thread, cmd_q,
-					 "%s-q%u", ccp->name, cmd_q->id);
+		kthread = kthread_run(ccp_cmd_queue_thread, cmd_q,
+				      "%s-q%u", ccp->name, cmd_q->id);
 		if (IS_ERR(kthread)) {
 			dev_err(dev, "error creating queue thread (%ld)\n",
 				PTR_ERR(kthread));
@@ -477,7 +477,6 @@ static int ccp_init(struct ccp_device *ccp)
 		}
 
 		cmd_q->kthread = kthread;
-		wake_up_process(kthread);
 	}
 
 	dev_dbg(dev, "Enabling interrupts...\n");
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 7838f63bab32..7b73332d6aa1 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -950,8 +950,8 @@ static int ccp5_init(struct ccp_device *ccp)
 
 		cmd_q = &ccp->cmd_q[i];
 
-		kthread = kthread_create(ccp_cmd_queue_thread, cmd_q,
-					 "%s-q%u", ccp->name, cmd_q->id);
+		kthread = kthread_run(ccp_cmd_queue_thread, cmd_q,
+				      "%s-q%u", ccp->name, cmd_q->id);
 		if (IS_ERR(kthread)) {
 			dev_err(dev, "error creating queue thread (%ld)\n",
 				PTR_ERR(kthread));
@@ -960,7 +960,6 @@ static int ccp5_init(struct ccp_device *ccp)
 		}
 
 		cmd_q->kthread = kthread;
-		wake_up_process(kthread);
 	}
 
 	dev_dbg(dev, "Enabling interrupts...\n");
-- 
2.25.1

