Return-Path: <SRS0=nn+h=7V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC680C433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 14:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97065206C3
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 14:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgFHOBk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jun 2020 10:01:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5798 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbgFHOBk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jun 2020 10:01:40 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9221E5032F1536D6C2DD;
        Mon,  8 Jun 2020 22:01:38 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Mon, 8 Jun 2020
 22:01:32 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <kong.kongxinwei@hisilicon.com>, <ike.pan@canonical.com>
Subject: [PATCH] crypto: hisilicon - update SEC driver module parameter
Date:   Mon, 8 Jun 2020 22:01:11 +0800
Message-ID: <1591624871-49173-1-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As stress-ng running SEC engine on the Ubuntu OS,
we found that SEC only supports two threads each with one TFM
based on the default module parameter 'ctx_q_num'.
If running more threads, stress-ng will fail since it cannot
get more TFMs.

In order to fix this, we adjusted the default values
of the module parameters to support more TFMs.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index a4cb58b..57de51f 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -30,9 +30,9 @@
 
 #define SEC_SQE_SIZE			128
 #define SEC_SQ_SIZE			(SEC_SQE_SIZE * QM_Q_DEPTH)
-#define SEC_PF_DEF_Q_NUM		64
+#define SEC_PF_DEF_Q_NUM		256
 #define SEC_PF_DEF_Q_BASE		0
-#define SEC_CTX_Q_NUM_DEF		24
+#define SEC_CTX_Q_NUM_DEF		2
 #define SEC_CTX_Q_NUM_MAX		32
 
 #define SEC_CTRL_CNT_CLR_CE		0x301120
@@ -191,7 +191,7 @@ static const struct kernel_param_ops sec_ctx_q_num_ops = {
 };
 static u32 ctx_q_num = SEC_CTX_Q_NUM_DEF;
 module_param_cb(ctx_q_num, &sec_ctx_q_num_ops, &ctx_q_num, 0444);
-MODULE_PARM_DESC(ctx_q_num, "Queue num in ctx (24 default, 2, 4, ..., 32)");
+MODULE_PARM_DESC(ctx_q_num, "Queue num in ctx (2 default, 2, 4, ..., 32)");
 
 static const struct kernel_param_ops vfs_num_ops = {
 	.set = vfs_num_set,
-- 
2.8.1

