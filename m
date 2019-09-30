Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE9EC4360C
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 09:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A0132190F
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 09:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730444AbfI3JYC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 05:24:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38026 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730310AbfI3JX6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 05:23:58 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7C70A36B7C16CBE378DA;
        Mon, 30 Sep 2019 17:23:53 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Mon, 30 Sep 2019 17:23:46 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linuxarm@huawei.com>, <forest.zhouchang@huawei.com>,
        Zaibo Xu <xuzaibo@huawei.com>, Hui Tang <tanghui20@huawei.com>
Subject: [PATCH 3/5] Documentation: Add debugfs doc for hisi_hpre
Date:   Mon, 30 Sep 2019 17:20:07 +0800
Message-ID: <1569835209-44326-4-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1569835209-44326-1-git-send-email-xuzaibo@huawei.com>
References: <1569835209-44326-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add debugfs descriptions for HiSilicon HPRE driver.

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 Documentation/ABI/testing/debugfs-hisi-hpre | 57 +++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-hpre

diff --git a/Documentation/ABI/testing/debugfs-hisi-hpre b/Documentation/ABI/testing/debugfs-hisi-hpre
new file mode 100644
index 0000000..ec4a79e
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-hpre
@@ -0,0 +1,57 @@
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/cluster[0-3]/regs
+Date:           Sep 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump debug registers from the HPRE cluster.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/cluster[0-3]/cluster_ctrl
+Date:           Sep 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    Write the HPRE core selection in the cluster into this file,
+		and then we can read the debug information of the core.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/rdclr_en
+Date:           Sep 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    HPRE cores debug registers read clear control. 1 means enable
+		register read clear, otherwise 0. Writing to this file has no
+		functional effect, only enable or disable counters clear after
+		reading of these registers.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/current_qm
+Date:           Sep 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    One HPRE controller has one PF and multiple VFs, each function
+		has a QM. Select the QM which below qm refers to.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/regs
+Date:           Sep 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump debug registers from the HPRE.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/qm_regs
+Date:           Sep 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump debug registers from the QM.
+		Available for PF and VF in host. VF in guest currently only
+		has one debug register.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/current_q
+Date:           Sep 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    One QM may contain multiple queues. Select specific queue to
+		show its debug registers in above qm_regs.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_hpre/<bdf>/qm/clear_enable
+Date:           Sep 2019
+Contact:        linux-crypto@vger.kernel.org
+Description:    QM debug registers(qm_regs) read clear control. 1 means enable
+		register read clear, otherwise 0.
+		Writing to this file has no functional effect, only enable or
+		disable counters clear after reading of these registers.
+		Only available for PF.
-- 
2.8.1

