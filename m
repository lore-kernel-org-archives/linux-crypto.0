Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8DDC4320A
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 06:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18837611C5
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Aug 2021 06:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhHGGdR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Aug 2021 02:33:17 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7804 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhHGGdP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Aug 2021 02:33:15 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GhXb304QZzYlgB;
        Sat,  7 Aug 2021 14:32:47 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 7 Aug 2021 14:32:56 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 3/3] crypto: hisilicon - enable hpre device clock gating
Date:   Sat, 7 Aug 2021 14:29:11 +0800
Message-ID: <1628317751-3396-4-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1628317751-3396-1-git-send-email-qianweili@huawei.com>
References: <1628317751-3396-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng930 hpre device supports dynamic clock gating. When doing tasks,
the algorithm core is opened, and when idle, the algorithm core is closed.
This patch enables hpre dynamic clock gating by writing hardware registers.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 63 +++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 8b0640f..6a5de30 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -81,6 +81,16 @@
 #define HPRE_PREFETCH_DISABLE		BIT(30)
 #define HPRE_SVA_DISABLE_READY		(BIT(4) | BIT(8))
 
+/* clock gate */
+#define HPRE_CLKGATE_CTL		0x301a10
+#define HPRE_PEH_CFG_AUTO_GATE		0x301a2c
+#define HPRE_CLUSTER_DYN_CTL		0x302010
+#define HPRE_CORE_SHB_CFG		0x302088
+#define HPRE_CLKGATE_CTL_EN		BIT(0)
+#define HPRE_PEH_CFG_AUTO_GATE_EN	BIT(0)
+#define HPRE_CLUSTER_DYN_CTL_EN		BIT(0)
+#define HPRE_CORE_GATE_EN		(BIT(30) | BIT(31))
+
 #define HPRE_AM_OOO_SHUTDOWN_ENB	0x301044
 #define HPRE_AM_OOO_SHUTDOWN_ENABLE	BIT(0)
 #define HPRE_WR_MSI_PORT		BIT(2)
@@ -417,12 +427,63 @@ static void hpre_close_sva_prefetch(struct hisi_qm *qm)
 		pci_err(qm->pdev, "failed to close sva prefetch\n");
 }
 
+static void hpre_enable_clock_gate(struct hisi_qm *qm)
+{
+	u32 val;
+
+	if (qm->ver < QM_HW_V3)
+		return;
+
+	val = readl(qm->io_base + HPRE_CLKGATE_CTL);
+	val |= HPRE_CLKGATE_CTL_EN;
+	writel(val, qm->io_base + HPRE_CLKGATE_CTL);
+
+	val = readl(qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
+	val |= HPRE_PEH_CFG_AUTO_GATE_EN;
+	writel(val, qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
+
+	val = readl(qm->io_base + HPRE_CLUSTER_DYN_CTL);
+	val |= HPRE_CLUSTER_DYN_CTL_EN;
+	writel(val, qm->io_base + HPRE_CLUSTER_DYN_CTL);
+
+	val = readl_relaxed(qm->io_base + HPRE_CORE_SHB_CFG);
+	val |= HPRE_CORE_GATE_EN;
+	writel(val, qm->io_base + HPRE_CORE_SHB_CFG);
+}
+
+static void hpre_disable_clock_gate(struct hisi_qm *qm)
+{
+	u32 val;
+
+	if (qm->ver < QM_HW_V3)
+		return;
+
+	val = readl(qm->io_base + HPRE_CLKGATE_CTL);
+	val &= ~HPRE_CLKGATE_CTL_EN;
+	writel(val, qm->io_base + HPRE_CLKGATE_CTL);
+
+	val = readl(qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
+	val &= ~HPRE_PEH_CFG_AUTO_GATE_EN;
+	writel(val, qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
+
+	val = readl(qm->io_base + HPRE_CLUSTER_DYN_CTL);
+	val &= ~HPRE_CLUSTER_DYN_CTL_EN;
+	writel(val, qm->io_base + HPRE_CLUSTER_DYN_CTL);
+
+	val = readl_relaxed(qm->io_base + HPRE_CORE_SHB_CFG);
+	val &= ~HPRE_CORE_GATE_EN;
+	writel(val, qm->io_base + HPRE_CORE_SHB_CFG);
+}
+
 static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
 	u32 val;
 	int ret;
 
+	/* disabel dynamic clock gate before sram init */
+	hpre_disable_clock_gate(qm);
+
 	writel(HPRE_QM_USR_CFG_MASK, qm->io_base + QM_ARUSER_M_CFG_ENABLE);
 	writel(HPRE_QM_USR_CFG_MASK, qm->io_base + QM_AWUSER_M_CFG_ENABLE);
 	writel_relaxed(HPRE_QM_AXI_CFG_MASK, qm->io_base + QM_AXI_M_CFG);
@@ -473,6 +534,8 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	/* Config data buffer pasid needed by Kunpeng 920 */
 	hpre_config_pasid(qm);
 
+	hpre_enable_clock_gate(qm);
+
 	return ret;
 }
 
-- 
2.8.1

