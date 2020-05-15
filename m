Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96F2C433E4
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ED9A2065C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgEOJPX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 05:15:23 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58098 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727837AbgEOJPX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 05:15:23 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BDE2870292547AE91ECD;
        Fri, 15 May 2020 17:15:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 15 May 2020 17:15:10 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 7/7] crypto: hisilicon/qm - change debugfs file name from qm_regs to regs
Date:   Fri, 15 May 2020 17:14:00 +0800
Message-ID: <1589534040-50725-8-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589534040-50725-1-git-send-email-tanshukun1@huawei.com>
References: <1589534040-50725-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The debugfs qm_regs file is already in the qm directory, so no qm_ prefix
is required.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/ABI/testing/debugfs-hisi-hpre | 6 +++---
 Documentation/ABI/testing/debugfs-hisi-sec  | 2 +-
 Documentation/ABI/testing/debugfs-hisi-zip  | 6 +++---
 drivers/crypto/hisilicon/qm.c               | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/ABI/testing/debugfs-hisi-hpre b/Documentation/ABI/testing/debugfs-hisi-hpre
index 1fe3eae..b4be5f1 100644
--- a/Documentation/ABI/testing/debugfs-hisi-hpre
+++ b/Documentation/ABI/testing/debugfs-hisi-hpre
@@ -33,7 +33,7 @@ Contact:        linux-crypto@vger.kernel.org
 Description:    Dump debug registers from the HPRE.
 		Only available for PF.
 
-What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/qm_regs
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/regs
 Date:           Sep 2019
 Contact:        linux-crypto@vger.kernel.org
 Description:    Dump debug registers from the QM.
@@ -44,13 +44,13 @@ What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/current_q
 Date:           Sep 2019
 Contact:        linux-crypto@vger.kernel.org
 Description:    One QM may contain multiple queues. Select specific queue to
-		show its debug registers in above qm_regs.
+		show its debug registers in above regs.
 		Only available for PF.
 
 What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/clear_enable
 Date:           Sep 2019
 Contact:        linux-crypto@vger.kernel.org
-Description:    QM debug registers(qm_regs) read clear control. 1 means enable
+Description:    QM debug registers(regs) read clear control. 1 means enable
 		register read clear, otherwise 0.
 		Writing to this file has no functional effect, only enable or
 		disable counters clear after reading of these registers.
diff --git a/Documentation/ABI/testing/debugfs-hisi-sec b/Documentation/ABI/testing/debugfs-hisi-sec
index 725c780..85feb44 100644
--- a/Documentation/ABI/testing/debugfs-hisi-sec
+++ b/Documentation/ABI/testing/debugfs-hisi-sec
@@ -25,7 +25,7 @@ What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/current_q
 Date:           Oct 2019
 Contact:        linux-crypto@vger.kernel.org
 Description:    One QM of SEC may contain multiple queues. Select specific
-		queue to show its debug registers in above 'qm_regs'.
+		queue to show its debug registers in above 'regs'.
 		Only available for PF.
 
 What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/clear_enable
diff --git a/Documentation/ABI/testing/debugfs-hisi-zip b/Documentation/ABI/testing/debugfs-hisi-zip
index 4832ba0..3034a2b 100644
--- a/Documentation/ABI/testing/debugfs-hisi-zip
+++ b/Documentation/ABI/testing/debugfs-hisi-zip
@@ -26,7 +26,7 @@ Description:    One ZIP controller has one PF and multiple VFs, each function
 		has a QM. Select the QM which below qm refers to.
 		Only available for PF.
 
-What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/qm_regs
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/regs
 Date:           Nov 2018
 Contact:        linux-crypto@vger.kernel.org
 Description:    Dump of QM related debug registers.
@@ -37,13 +37,13 @@ What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/current_q
 Date:           Nov 2018
 Contact:        linux-crypto@vger.kernel.org
 Description:    One QM may contain multiple queues. Select specific queue to
-		show its debug registers in above qm_regs.
+		show its debug registers in above regs.
 		Only available for PF.
 
 What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/clear_enable
 Date:           Nov 2018
 Contact:        linux-crypto@vger.kernel.org
-Description:    QM debug registers(qm_regs) read clear control. 1 means enable
+Description:    QM debug registers(regs) read clear control. 1 means enable
 		register read clear, otherwise 0.
 		Writing to this file has no functional effect, only enable or
 		disable counters clear after reading of these registers.
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 57ad131..a781c02 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2775,7 +2775,7 @@ int hisi_qm_debug_init(struct hisi_qm *qm)
 				goto failed_to_create;
 			}
 
-	debugfs_create_file("qm_regs", 0444, qm->debug.qm_d, qm, &qm_regs_fops);
+	debugfs_create_file("regs", 0444, qm->debug.qm_d, qm, &qm_regs_fops);
 
 	debugfs_create_file("cmd", 0444, qm->debug.qm_d, qm, &qm_cmd_fops);
 
-- 
2.7.4

