From: Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: ccree: Don't use volatile for monitor_lock
Date: Mon, 11 Sep 2017 21:29:31 +0530
Message-ID: <1505145571-11248-1-git-send-email-srishtishar@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33454 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdIKP7m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2017 11:59:42 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The use of volatile for the variable monitor_lock is unnecessary.

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/ssi_request_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index e5c2f92..7d77941 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -49,7 +49,7 @@ struct ssi_request_mgr_handle {
 	dma_addr_t dummy_comp_buff_dma;
 	struct cc_hw_desc monitor_desc;

-	volatile unsigned long monitor_lock;
+	unsigned long monitor_lock;
 #ifdef COMP_IN_WQ
 	struct workqueue_struct *workq;
 	struct delayed_work compwork;
