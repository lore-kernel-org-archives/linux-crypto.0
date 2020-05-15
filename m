Return-Path: <SRS0=Yf/g=65=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C08C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A5DE2065C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 May 2020 09:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgEOJPU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 May 2020 05:15:20 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4788 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727844AbgEOJPU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 May 2020 05:15:20 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CC07E23F0FED4B1D9E48;
        Fri, 15 May 2020 17:15:18 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 15 May 2020 17:15:08 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH 2/7] crypto: hisilicon/qm - add debugfs to the QM state machine
Date:   Fri, 15 May 2020 17:13:55 +0800
Message-ID: <1589534040-50725-3-git-send-email-tanshukun1@huawei.com>
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

From: Longfang Liu <liulongfang@huawei.com>

The QM driver uses debugfs to provides the current state of
the QM state machine

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 Documentation/ABI/testing/debugfs-hisi-hpre |  7 ++++++
 Documentation/ABI/testing/debugfs-hisi-sec  |  7 ++++++
 Documentation/ABI/testing/debugfs-hisi-zip  |  7 ++++++
 drivers/crypto/hisilicon/qm.c               | 34 +++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+)

diff --git a/Documentation/ABI/testing/debugfs-hisi-hpre b/Documentation/ABI/testing/debugfs-hisi-hpre
index 1f96665..093cf46 100644
--- a/Documentation/ABI/testing/debugfs-hisi-hpre
+++ b/Documentation/ABI/testing/debugfs-hisi-hpre
@@ -86,3 +86,10 @@ Date:           Apr 2020
 Contact:        linux-crypto@vger.kernel.org
 Description:    Dump the number of failed QM mailbox commands.
 		Available for both PF and VF, and take no other effect on HPRE.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/status
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the status of the QM.
+		Four states: initiated, started, stopped and closed.
+		Available for both PF and VF, and take no other effect on HPRE.
diff --git a/Documentation/ABI/testing/debugfs-hisi-sec b/Documentation/ABI/testing/debugfs-hisi-sec
index c3ba09c..54699a1 100644
--- a/Documentation/ABI/testing/debugfs-hisi-sec
+++ b/Documentation/ABI/testing/debugfs-hisi-sec
@@ -72,3 +72,10 @@ Date:           Apr 2020
 Contact:        linux-crypto@vger.kernel.org
 Description:    Dump the number of failed QM mailbox commands.
 		Available for both PF and VF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec2/<bdf>/qm/status
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the status of the QM.
+		Four states: initiated, started, stopped and closed.
+		Available for both PF and VF, and take no other effect on SEC.
diff --git a/Documentation/ABI/testing/debugfs-hisi-zip b/Documentation/ABI/testing/debugfs-hisi-zip
index cc568fd..1002a01 100644
--- a/Documentation/ABI/testing/debugfs-hisi-zip
+++ b/Documentation/ABI/testing/debugfs-hisi-zip
@@ -79,3 +79,10 @@ Date:           Apr 2020
 Contact:        linux-crypto@vger.kernel.org
 Description:    Dump the number of failed QM mailbox commands.
 		Available for both PF and VF, and take no other effect on ZIP.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/status
+Date:           Apr 2020
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the status of the QM.
+		Four states: initiated, started, stopped and closed.
+		Available for both PF and VF, and take no other effect on ZIP.
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 744d131..7c1982f 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -175,6 +175,7 @@
 #define QM_SQE_DATA_ALIGN_MASK		GENMASK(6, 0)
 #define QMC_ALIGN(sz)			ALIGN(sz, 32)
 
+#define QM_DBG_READ_LEN		256
 #define QM_DBG_TMP_BUF_LEN		22
 #define QM_PCI_COMMAND_INVALID		~0
 
@@ -2268,6 +2269,37 @@ int hisi_qm_stop(struct hisi_qm *qm)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_stop);
 
+static ssize_t qm_status_read(struct file *filp, char __user *buffer,
+			      size_t count, loff_t *pos)
+{
+	struct hisi_qm *qm = filp->private_data;
+	char buf[QM_DBG_READ_LEN];
+	int val, cp_len, len;
+
+	if (*pos)
+		return 0;
+
+	if (count < QM_DBG_READ_LEN)
+		return -ENOSPC;
+
+	val = atomic_read(&qm->status.flags);
+	len = snprintf(buf, QM_DBG_READ_LEN, "%s\n", qm_s[val]);
+	if (!len)
+		return -EFAULT;
+
+	cp_len = copy_to_user(buffer, buf, len);
+	if (cp_len)
+		return -EFAULT;
+
+	return (*pos = len);
+}
+
+static const struct file_operations qm_status_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = qm_status_read,
+};
+
 static int qm_debugfs_atomic64_set(void *data, u64 val)
 {
 	if (val)
@@ -2314,6 +2346,8 @@ int hisi_qm_debug_init(struct hisi_qm *qm)
 
 	debugfs_create_file("qm_regs", 0444, qm->debug.qm_d, qm, &qm_regs_fops);
 
+	debugfs_create_file("status", 0444, qm->debug.qm_d, qm,
+			&qm_status_fops);
 	for (i = 0; i < ARRAY_SIZE(qm_dfx_files); i++) {
 		data = (atomic64_t *)((uintptr_t)dfx + qm_dfx_files[i].offset);
 		debugfs_create_file(qm_dfx_files[i].name,
-- 
2.7.4

