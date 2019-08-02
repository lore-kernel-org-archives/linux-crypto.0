Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA567C32750
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDDC02086A
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 08:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403982AbfHBIQ5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 04:16:57 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50092 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403974AbfHBIQ5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 04:16:57 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B701C3A14E74F41B24A7;
        Fri,  2 Aug 2019 16:16:55 +0800 (CST)
Received: from localhost.localdomain (10.67.212.75) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Fri, 2 Aug 2019 16:16:45 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH v3 5/7] Documentation: Add debugfs doc for hisi_zip
Date:   Fri, 2 Aug 2019 15:57:54 +0800
Message-ID: <1564732676-35987-6-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
References: <1564732676-35987-1-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.75]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add debugfs descriptions for HiSilicon ZIP and QM driver.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 Documentation/ABI/testing/debugfs-hisi-zip | 50 ++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip

diff --git a/Documentation/ABI/testing/debugfs-hisi-zip b/Documentation/ABI/testing/debugfs-hisi-zip
new file mode 100644
index 0000000..a7c63e6
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-zip
@@ -0,0 +1,50 @@
+What:           /sys/kernel/debug/hisi_zip/<bdf>/comp_core[01]/regs
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump of compression cores related debug registers.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/decomp_core[0-5]/regs
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump of decompression cores related debug registers.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/clear_enable
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    Compression/decompression core debug registers read clear
+		control. 1 means enable register read clear, otherwise 0.
+		Writing to this file has no functional effect, only enable or
+		disable counters clear after reading of these registers.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/current_qm
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    One ZIP controller has one PF and multiple VFs, each function
+		has a QM. Select the QM which below qm refers to.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/qm_regs
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    Dump of QM related debug registers.
+		Available for PF and VF in host. VF in guest currently only
+		has one debug register.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/current_q
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    One QM may contain multiple queues. Select specific queue to
+		show its debug registers in above qm_regs.
+		Only available for PF.
+
+What:           /sys/kernel/debug/hisi_zip/<bdf>/qm/clear_enable
+Date:           Nov 2018
+Contact:        linux-crypto@vger.kernel.org
+Description:    QM debug registers(qm_regs) read clear control. 1 means enable
+		register read clear, otherwise 0.
+		Writing to this file has no functional effect, only enable or
+		disable counters clear after reading of these registers.
+		Only available for PF.
-- 
2.8.1

