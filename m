Return-Path: <SRS0=5LAy=ZF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CBCC17442
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 11:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA2BC222D3
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Nov 2019 11:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfKMLOf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Nov 2019 06:14:35 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:57086 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727421AbfKMLOf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Nov 2019 06:14:35 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id ED89B68DB1B718C5C6D9;
        Wed, 13 Nov 2019 19:14:33 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.439.0; Wed, 13 Nov 2019 19:14:27 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>, <linuxarm@huawei.com>,
        <fanghao11@huawei.com>, <yekai13@huawei.com>,
        <zhangwei375@huawei.com>, <forest.zhouchang@huawei.com>
Subject: [PATCH v3 3/5] Documentation: add DebugFS doc for HiSilicon SEC
Date:   Wed, 13 Nov 2019 19:11:06 +0800
Message-ID: <1573643468-1812-4-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1573643468-1812-1-git-send-email-xuzaibo@huawei.com>
References: <1573643468-1812-1-git-send-email-xuzaibo@huawei.com>
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

