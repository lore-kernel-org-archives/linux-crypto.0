Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9E5C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 07:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75CFF206A5
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 07:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgGJHll (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 03:41:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:54824 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726664AbgGJHlh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 03:41:37 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9BB6A6B7579B1732FD70;
        Fri, 10 Jul 2020 15:41:32 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 10 Jul 2020 15:41:23 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/6] crypto: hisilicon/hpre - Modify the Macro definition and format
Date:   Fri, 10 Jul 2020 15:40:43 +0800
Message-ID: <1594366846-1313-4-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1594366846-1313-1-git-send-email-yumeng18@huawei.com>
References: <1594366846-1313-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Bit 1 to bit 5 are NFE, not CE.
2. Macro 'HPRE_VF_NUM' is defined in 'qm.h', so delete it here.
3. Delete multiple blank lines.
4. Adjust format alignment.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
Reviewed-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 23f2e5c..da17729 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -12,7 +12,6 @@
 #include <linux/topology.h>
 #include "hpre.h"
 
-#define HPRE_VF_NUM			63
 #define HPRE_QUEUE_NUM_V2		1024
 #define HPRE_QM_ABNML_INT_MASK		0x100004
 #define HPRE_CTRL_CNT_CLR_CE_BIT	BIT(0)
@@ -46,9 +45,9 @@
 #define HPRE_CORE_IS_SCHD_OFFSET	0x90
 
 #define HPRE_RAS_CE_ENB			0x301410
-#define HPRE_HAC_RAS_CE_ENABLE		0x3f
+#define HPRE_HAC_RAS_CE_ENABLE		0x1
 #define HPRE_RAS_NFE_ENB		0x301414
-#define HPRE_HAC_RAS_NFE_ENABLE		0x3fffc0
+#define HPRE_HAC_RAS_NFE_ENABLE		0x3ffffe
 #define HPRE_RAS_FE_ENB			0x301418
 #define HPRE_HAC_RAS_FE_ENABLE		0
 
@@ -264,7 +263,7 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	writel(HPRE_BD_USR_MASK, HPRE_ADDR(qm, HPRE_BD_AWUSR_CFG));
 	writel(0x1, HPRE_ADDR(qm, HPRE_RDCHN_INI_CFG));
 	ret = readl_relaxed_poll_timeout(HPRE_ADDR(qm, HPRE_RDCHN_INI_ST), val,
-			val & BIT(0),
+					 val & BIT(0),
 			HPRE_REG_RD_INTVRL_US,
 			HPRE_REG_RD_TMOUT_US);
 	if (ret) {
@@ -372,7 +371,6 @@ static int hpre_current_qm_write(struct hpre_debugfs_file *file, u32 val)
 	u32 num_vfs = qm->vfs_num;
 	u32 vfq_num, tmp;
 
-
 	if (val > num_vfs)
 		return -EINVAL;
 
@@ -449,7 +447,7 @@ static int hpre_cluster_inqry_write(struct hpre_debugfs_file *file, u32 val)
 }
 
 static ssize_t hpre_ctrl_debug_read(struct file *filp, char __user *buf,
-			       size_t count, loff_t *pos)
+				    size_t count, loff_t *pos)
 {
 	struct hpre_debugfs_file *file = filp->private_data;
 	char tbuf[HPRE_DBGFS_VAL_MAX_LEN];
@@ -477,7 +475,7 @@ static ssize_t hpre_ctrl_debug_read(struct file *filp, char __user *buf,
 }
 
 static ssize_t hpre_ctrl_debug_write(struct file *filp, const char __user *buf,
-				size_t count, loff_t *pos)
+				     size_t count, loff_t *pos)
 {
 	struct hpre_debugfs_file *file = filp->private_data;
 	char tbuf[HPRE_DBGFS_VAL_MAX_LEN];
-- 
2.8.1

