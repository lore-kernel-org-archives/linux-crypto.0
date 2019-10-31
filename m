Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F070CA9EC3
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 07:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F6762087F
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 07:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfJaHjN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 03:39:13 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52434 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726963AbfJaHjM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 03:39:12 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2E9C338070375DF20242;
        Thu, 31 Oct 2019 15:39:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Thu, 31 Oct 2019 15:39:02 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <liulongfang@huawei.com>, <wangzhou1@hisilicon.com>,
        <linuxarm@huawei.com>, <zhangwei375@huawei.com>,
        <yekai13@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH 3/5] Documentation: add DebugFS doc for HiSilicon SEC
Date:   Thu, 31 Oct 2019 15:35:28 +0800
Message-ID: <1572507330-34502-4-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1572507330-34502-1-git-send-email-xuzaibo@huawei.com>
References: <1572507330-34502-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

This Documentation is for HiSilicon SEC DebugFS.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Kai Ye <yekai13@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 Documentation/ABI/testing/debugfs-hisi-sec | 43 ++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-sec

diff --git a/Documentation/ABI/testing/debugfs-hisi-sec b/Documentation/ABI/testing/debugfs-hisi-sec
new file mode 100644
index 0000000..06adb89
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-sec
@@ -0,0 +1,43 @@
+What:           /sys/kernel/debug/hisi_sec/<bdf>/sec_dfx
+Date:           Oct 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump the debug registers of SEC cores.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_sec/<bdf>/clear_enable
+Date:           Oct 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    Enabling/disabling of clear action after reading
+		the SEC debug registers.
+		0: disable, 1: enable.
+		Only available for PF, and take no other effect on SEC.
+
+What:           /sys/kernel/debug/hisi_sec/<bdf>/current_qm
+Date:           Oct 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    One SEC controller has one PF and multiple VFs, each function
+		has a QM. This file can be used to select the QM which below
+		qm refers to.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_sec/<bdf>/qm/qm_regs
+Date:           Oct 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump of QM related debug registers.
+		Available for PF and VF in host. VF in guest currently only
+		has one debug register.
+
+What:           /sys/kernel/debug/hisi_sec/<bdf>/qm/current_q
+Date:           Oct 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    One QM of SEC may contain multiple queues. Select specific
+		queue to show its debug registers in above 'qm_regs'.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_sec/<bdf>/qm/clear_enable
+Date:           Oct 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    Enabling/disabling of clear action after reading
+		the SEC's QM debug registers.
+		0: disable, 1: enable.
+		Only available for PF, and take no other effect on SEC.
-- 
2.8.1

