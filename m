Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1539BC43460
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E873161949
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 06:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhELGbl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 02:31:41 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3725 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhELGbc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 02:31:32 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fg4ZS4XLczmgKx;
        Wed, 12 May 2021 14:26:56 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Wed, 12 May 2021 14:30:10 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 6/8] crypto: hisilicon/hpre - use 'GENMASK' to generate mask value
Date:   Wed, 12 May 2021 14:27:09 +0800
Message-ID: <1620800831-53346-7-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620800831-53346-1-git-send-email-tanghui20@huawei.com>
References: <1620800831-53346-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use 'GENMASK' to generate mask value, just make the code clearer.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  6 +++---
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 14 +++++++-------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 3a3af82..fb8e9c0 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -326,9 +326,9 @@ static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,

 #define HPRE_NO_HW_ERR		0
 #define HPRE_HW_TASK_DONE	3
-#define HREE_HW_ERR_MASK	0x7ff
-#define HREE_SQE_DONE_MASK	0x3
-#define HREE_ALG_TYPE_MASK	0x1f
+#define HREE_HW_ERR_MASK	GENMASK(10, 0)
+#define HREE_SQE_DONE_MASK	GENMASK(1, 0)
+#define HREE_ALG_TYPE_MASK	GENMASK(4, 0)
 	id = (int)le16_to_cpu(sqe->tag);
 	req = ctx->req_list[id];
 	hpre_rm_req_from_ctx(req);
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 1e7d1fb..46c24f9 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -36,7 +36,7 @@
 #define HPRE_INT_MASK			0x301400
 #define HPRE_INT_STATUS			0x301800
 #define HPRE_CORE_INT_ENABLE		0
-#define HPRE_CORE_INT_DISABLE		0x003fffff
+#define HPRE_CORE_INT_DISABLE		GENMASK(21, 0)
 #define HPRE_RDCHN_INI_ST		0x301a00
 #define HPRE_CLSTR_BASE			0x302000
 #define HPRE_CORE_EN_OFFSET		0x04
@@ -69,12 +69,12 @@
 #define HPRE_DBGFS_VAL_MAX_LEN		20
 #define HPRE_PCI_DEVICE_ID		0xa258
 #define HPRE_PCI_VF_DEVICE_ID		0xa259
-#define HPRE_QM_USR_CFG_MASK		0xfffffffe
-#define HPRE_QM_AXI_CFG_MASK		0xffff
-#define HPRE_QM_VFG_AX_MASK		0xff
-#define HPRE_BD_USR_MASK		0x3
-#define HPRE_CLUSTER_CORE_MASK_V2	0xf
-#define HPRE_CLUSTER_CORE_MASK_V3	0xff
+#define HPRE_QM_USR_CFG_MASK		GENMASK(31, 1)
+#define HPRE_QM_AXI_CFG_MASK		GENMASK(15, 0)
+#define HPRE_QM_VFG_AX_MASK		GENMASK(7, 0)
+#define HPRE_BD_USR_MASK		GENMASK(1, 0)
+#define HPRE_CLUSTER_CORE_MASK_V2	GENMASK(3, 0)
+#define HPRE_CLUSTER_CORE_MASK_V3	GENMASK(7, 0)

 #define HPRE_AM_OOO_SHUTDOWN_ENB	0x301044
 #define HPRE_AM_OOO_SHUTDOWN_ENABLE	BIT(0)
--
2.8.1

