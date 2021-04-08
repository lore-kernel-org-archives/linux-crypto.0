Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402B8C433B4
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 10:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E81EF61175
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 10:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhDHK0u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 06:26:50 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15184 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhDHK0s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 06:26:48 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FGHRS6r8QzpWLN;
        Thu,  8 Apr 2021 18:23:48 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 18:26:25 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yekai13@huawei.com>
Subject: [PATCH 2/2] crypto: hisilicon/sec_drv - use the correct print format
Date:   Thu, 8 Apr 2021 18:23:51 +0800
Message-ID: <1617877431-38290-3-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617877431-38290-1-git-send-email-yekai13@huawei.com>
References: <1617877431-38290-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

According to Documentation/core-api/printk-formats.rst, Use
the correct print format. Printing an unsigned int value should use %u
instead of %d.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec/sec_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index 91ee2bb..819bbb5 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -233,7 +233,7 @@ static int sec_queue_map_io(struct sec_queue *queue)
 				    IORESOURCE_MEM,
 				    2 + queue->queue_id);
 	if (!res) {
-		dev_err(dev, "Failed to get queue %d memory resource\n",
+		dev_err(dev, "Failed to get queue %u memory resource\n",
 			queue->queue_id);
 		return -ENOMEM;
 	}
@@ -653,12 +653,12 @@ static int sec_queue_free(struct sec_queue *queue)
 	struct sec_dev_info *info = queue->dev_info;
 
 	if (queue->queue_id >= SEC_Q_NUM) {
-		dev_err(info->dev, "No queue %d\n", queue->queue_id);
+		dev_err(info->dev, "No queue %u\n", queue->queue_id);
 		return -ENODEV;
 	}
 
 	if (!queue->in_use) {
-		dev_err(info->dev, "Queue %d is idle\n", queue->queue_id);
+		dev_err(info->dev, "Queue %u is idle\n", queue->queue_id);
 		return -ENODEV;
 	}
 
-- 
2.8.1

