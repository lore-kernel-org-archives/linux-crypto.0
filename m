Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D674113A27D;
	Sat, 14 Sep 2024 11:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726311685; cv=none; b=gfTXdkNl4ZY/lSyIKFymAu3pmWHZ0VZTshSUOpyodqom9YfDj2TuyDkRaE+KN/CnHH2rnSBXfT2a1G55Gr5eyfNVO9ItPyNS7kyRKnojqKEdLjoYukQrq19wprGwo9OXJ6oPaIPT+VrVmvyZZWMOVf9gwHttx70Of2yOeL52m3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726311685; c=relaxed/simple;
	bh=2cdpzxaJak4sk84HBja4AHAxecY3fd/vX4aFAisLU1w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EENgzL/bXmGrJ8FEUGmqvqcb/43bxAPVuEB28YjXhBd4AcJU+0mi3n6zXTx/qfd0MDzIM3CQB57/QtaUeJyJZj9RjMaxxauCayZvH40xyBQ6eQ1j2ZSlzwxJYr1f6toHUNob5iaqgPhiyO9vTzCkcs3EcCyBH9QDuq1b6aC8Zkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4X5Sps3z0Szfc1B;
	Sat, 14 Sep 2024 18:59:01 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 82CF414035F;
	Sat, 14 Sep 2024 19:01:13 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 14 Sep 2024 19:01:13 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH] crypto: hisilicon/hpre - enable all clusters clock gating
Date: Sat, 14 Sep 2024 18:57:16 +0800
Message-ID: <20240914105716.20840-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600009.china.huawei.com (7.193.23.164)

Currently, the driver enables clock gating for only one cluster.
However, the new hardware has three clusters. Therefore, clock
gating needs to be enabled based on the number of clusters on the
current hardware.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 40 +++++++++++++++--------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 6b536ad2ada5..23e8fb9414af 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -593,6 +593,8 @@ static void hpre_close_sva_prefetch(struct hisi_qm *qm)
 
 static void hpre_enable_clock_gate(struct hisi_qm *qm)
 {
+	unsigned long offset;
+	u8 clusters_num, i;
 	u32 val;
 
 	if (qm->ver < QM_HW_V3)
@@ -606,17 +608,23 @@ static void hpre_enable_clock_gate(struct hisi_qm *qm)
 	val |= HPRE_PEH_CFG_AUTO_GATE_EN;
 	writel(val, qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
 
-	val = readl(qm->io_base + HPRE_CLUSTER_DYN_CTL);
-	val |= HPRE_CLUSTER_DYN_CTL_EN;
-	writel(val, qm->io_base + HPRE_CLUSTER_DYN_CTL);
-
-	val = readl_relaxed(qm->io_base + HPRE_CORE_SHB_CFG);
-	val |= HPRE_CORE_GATE_EN;
-	writel(val, qm->io_base + HPRE_CORE_SHB_CFG);
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
+	for (i = 0; i < clusters_num; i++) {
+		offset = (unsigned long)i * HPRE_CLSTR_ADDR_INTRVL;
+		val = readl(qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
+		val |= HPRE_CLUSTER_DYN_CTL_EN;
+		writel(val, qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
+
+		val = readl(qm->io_base + offset + HPRE_CORE_SHB_CFG);
+		val |= HPRE_CORE_GATE_EN;
+		writel(val, qm->io_base + offset + HPRE_CORE_SHB_CFG);
+	}
 }
 
 static void hpre_disable_clock_gate(struct hisi_qm *qm)
 {
+	unsigned long offset;
+	u8 clusters_num, i;
 	u32 val;
 
 	if (qm->ver < QM_HW_V3)
@@ -630,13 +638,17 @@ static void hpre_disable_clock_gate(struct hisi_qm *qm)
 	val &= ~HPRE_PEH_CFG_AUTO_GATE_EN;
 	writel(val, qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
 
-	val = readl(qm->io_base + HPRE_CLUSTER_DYN_CTL);
-	val &= ~HPRE_CLUSTER_DYN_CTL_EN;
-	writel(val, qm->io_base + HPRE_CLUSTER_DYN_CTL);
-
-	val = readl_relaxed(qm->io_base + HPRE_CORE_SHB_CFG);
-	val &= ~HPRE_CORE_GATE_EN;
-	writel(val, qm->io_base + HPRE_CORE_SHB_CFG);
+	clusters_num = qm->cap_tables.dev_cap_table[HPRE_CLUSTER_NUM_CAP_IDX].cap_val;
+	for (i = 0; i < clusters_num; i++) {
+		offset = (unsigned long)i * HPRE_CLSTR_ADDR_INTRVL;
+		val = readl(qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
+		val &= ~HPRE_CLUSTER_DYN_CTL_EN;
+		writel(val, qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
+
+		val = readl(qm->io_base + offset + HPRE_CORE_SHB_CFG);
+		val &= ~HPRE_CORE_GATE_EN;
+		writel(val, qm->io_base + offset + HPRE_CORE_SHB_CFG);
+	}
 }
 
 static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
-- 
2.33.0

