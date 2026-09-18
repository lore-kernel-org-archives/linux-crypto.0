Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056BE41A4E7;
	Fri, 18 Sep 2026 12:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734457; cv=none; b=IUjMAkaqwZbAcjpkhrUh/o2dZBcwflaDhWM+glB8hwkDmARjK4HlJyyCykcmIyZ3+QZ0xWia96LuDwcH741WbT1U0jlBQ7Jk1Oz97zvN4aeelPW3hA+ypTqDUJj+WHyvqJu/yvvXRyP314skmAmr17ALK6KxzmgBldFtwRp/UtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734457; c=relaxed/simple;
	bh=EW7V11/lMMSW3K8uKw2nnVN9ED/jd6XZ3ulvpPDzj/M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvD/UiSUZ8UHbSQFH71XHmE+yerhnb8mtVfQ+R51woR+NaQhxSQ+rUnz/ay8j5x7HClaLmWB2iRhrW+kIulk/3/2GD/utJ4zlqIFq+TOtte+T8PAXTNYg1dufkfwic/MlIytyhWY/2h9jda29SMXncUcVpDMGYqIxfnp29fkYjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=t87tOstc; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="t87tOstc"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Zhld7CbpOTpaqLQdi9ubdIS0fNQVsZiiVJDx/3SQYRE=;
	b=t87tOstc+fUnGCICoS7wIWO4WJfrK/sq+GTbdp59DreLH7U8r5GAISj8LXK7mhCMuP01f9Enl
	1B73ANwjbwLlkBhTN5vl6ErEPQg4lWu/7KeKe1AmnRbNMIRhtq2Zq5/7u8n9P11UzDA700noAWK
	BizxLL7iWmDLbyGghbeA0do=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hmWnP6YZpzKmT6;
	Fri, 18 Sep 2026 20:16:25 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 91B2D4057C;
	Fri, 18 Sep 2026 20:27:29 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 18 Sep 2026 20:27:29 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 6/7] crypto: hisilicon/hpre - extract clusters num into inline function
Date: Fri, 18 Sep 2026 20:27:25 +0800
Message-ID: <20260918122726.3014899-7-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918122726.3014899-1-qianweili@huawei.com>
References: <20260918122726.3014899-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf200011.china.huawei.com (7.202.181.237)

Seven functions in hpre_main.c open-code the same cluster number
extraction from HPRE_CORE_INFO. Extract into hpre_get_clusters_num().

hpre_pre_store_cap_reg() uses a local hpre_cap[] array rather than
qm->cap_tables.dev_cap_table[] and is therefore not converted.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 43 ++++++++---------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index b6903fce6071..e1a567383de5 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -381,6 +381,14 @@ static const char *hpre_channel_name[HPRE_MAX_CHANNEL_NUM] = {
 
 static const struct hisi_qm_err_ini hpre_err_ini;
 
+static inline u8 hpre_get_clusters_num(struct hisi_qm *qm)
+{
+	u32 cap = qm->cap_tables.dev_cap_table[HPRE_CORE_INFO].cap_val;
+
+	return (cap >> hpre_basic_info[HPRE_CLUSTER_NUM_CAP].shift) &
+		hpre_basic_info[HPRE_CLUSTER_NUM_CAP].mask;
+}
+
 bool hpre_check_alg_support(struct hisi_qm *qm, u32 alg)
 {
 	u32 cap_val;
@@ -557,15 +565,12 @@ static int hpre_set_cluster(struct hisi_qm *qm)
 	struct device *dev = &qm->pdev->dev;
 	u32 cluster_core_mask;
 	unsigned long offset;
-	u32 hpre_core_info;
 	u8 clusters_num;
 	u32 val = 0;
 	int ret, i;
 
 	cluster_core_mask = qm->cap_tables.dev_cap_table[HPRE_CORE_EN].cap_val;
-	hpre_core_info = qm->cap_tables.dev_cap_table[HPRE_CORE_INFO].cap_val;
-	clusters_num = (hpre_core_info >> hpre_basic_info[HPRE_CLUSTER_NUM_CAP].shift) &
-			hpre_basic_info[HPRE_CLUSTER_NUM_CAP].mask;
+	clusters_num = hpre_get_clusters_num(qm);
 	for (i = 0; i < clusters_num; i++) {
 		offset = i * HPRE_CLSTR_ADDR_INTRVL;
 
@@ -659,7 +664,6 @@ static void hpre_enable_clock_gate(struct hisi_qm *qm)
 {
 	unsigned long offset;
 	u8 clusters_num, i;
-	u32 hpre_core_info;
 	u32 val;
 
 	if (qm->ver < QM_HW_V3)
@@ -673,9 +677,7 @@ static void hpre_enable_clock_gate(struct hisi_qm *qm)
 	val |= HPRE_PEH_CFG_AUTO_GATE_EN;
 	writel(val, qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
 
-	hpre_core_info = qm->cap_tables.dev_cap_table[HPRE_CORE_INFO].cap_val;
-	clusters_num = (hpre_core_info >> hpre_basic_info[HPRE_CLUSTER_NUM_CAP].shift) &
-			hpre_basic_info[HPRE_CLUSTER_NUM_CAP].mask;
+	clusters_num = hpre_get_clusters_num(qm);
 	for (i = 0; i < clusters_num; i++) {
 		offset = (unsigned long)i * HPRE_CLSTR_ADDR_INTRVL;
 		val = readl(qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
@@ -692,7 +694,6 @@ static void hpre_disable_clock_gate(struct hisi_qm *qm)
 {
 	unsigned long offset;
 	u8 clusters_num, i;
-	u32 hpre_core_info;
 	u32 val;
 
 	if (qm->ver < QM_HW_V3)
@@ -706,9 +707,7 @@ static void hpre_disable_clock_gate(struct hisi_qm *qm)
 	val &= ~HPRE_PEH_CFG_AUTO_GATE_EN;
 	writel(val, qm->io_base + HPRE_PEH_CFG_AUTO_GATE);
 
-	hpre_core_info = qm->cap_tables.dev_cap_table[HPRE_CORE_INFO].cap_val;
-	clusters_num = (hpre_core_info >> hpre_basic_info[HPRE_CLUSTER_NUM_CAP].shift) &
-			hpre_basic_info[HPRE_CLUSTER_NUM_CAP].mask;
+	clusters_num = hpre_get_clusters_num(qm);
 	for (i = 0; i < clusters_num; i++) {
 		offset = (unsigned long)i * HPRE_CLSTR_ADDR_INTRVL;
 		val = readl(qm->io_base + offset + HPRE_CLUSTER_DYN_CTL);
@@ -782,14 +781,11 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 static void hpre_cnt_regs_clear(struct hisi_qm *qm)
 {
 	unsigned long offset;
-	u32 hpre_core_info;
 	u8 clusters_num;
 	int i;
 
 	/* clear clusterX/cluster_ctrl */
-	hpre_core_info = qm->cap_tables.dev_cap_table[HPRE_CORE_INFO].cap_val;
-	clusters_num = (hpre_core_info >> hpre_basic_info[HPRE_CLUSTER_NUM_CAP].shift) &
-			hpre_basic_info[HPRE_CLUSTER_NUM_CAP].mask;
+	clusters_num = hpre_get_clusters_num(qm);
 	for (i = 0; i < clusters_num; i++) {
 		offset = HPRE_CLSTR_BASE + i * HPRE_CLSTR_ADDR_INTRVL;
 		writel(0x0, qm->io_base + offset + HPRE_CLUSTER_INQURY);
@@ -1072,13 +1068,10 @@ static int hpre_cluster_debugfs_init(struct hisi_qm *qm)
 	char buf[HPRE_DBGFS_VAL_MAX_LEN];
 	struct debugfs_regset32 *regset;
 	struct dentry *tmp_d;
-	u32 hpre_core_info;
 	u8 clusters_num;
 	int i, ret;
 
-	hpre_core_info = qm->cap_tables.dev_cap_table[HPRE_CORE_INFO].cap_val;
-	clusters_num = (hpre_core_info >> hpre_basic_info[HPRE_CLUSTER_NUM_CAP].shift) &
-			hpre_basic_info[HPRE_CLUSTER_NUM_CAP].mask;
+	clusters_num = hpre_get_clusters_num(qm);
 	for (i = 0; i < clusters_num; i++) {
 		ret = snprintf(buf, HPRE_DBGFS_VAL_MAX_LEN, "cluster%d", i);
 		if (ret >= HPRE_DBGFS_VAL_MAX_LEN)
@@ -1308,13 +1301,10 @@ static int hpre_show_last_regs_init(struct hisi_qm *qm)
 	int com_dfx_regs_num = ARRAY_SIZE(hpre_com_dfx_regs);
 	struct qm_debug *debug = &qm->debug;
 	void __iomem *io_base;
-	u32 hpre_core_info;
 	u8 clusters_num;
 	int i, j, idx;
 
-	hpre_core_info = qm->cap_tables.dev_cap_table[HPRE_CORE_INFO].cap_val;
-	clusters_num = (hpre_core_info >> hpre_basic_info[HPRE_CLUSTER_NUM_CAP].shift) &
-			hpre_basic_info[HPRE_CLUSTER_NUM_CAP].mask;
+	clusters_num = hpre_get_clusters_num(qm);
 	debug->last_words = kcalloc(cluster_dfx_regs_num * clusters_num +
 			com_dfx_regs_num, sizeof(unsigned int), GFP_KERNEL);
 	if (!debug->last_words)
@@ -1354,7 +1344,6 @@ static void hpre_show_last_dfx_regs(struct hisi_qm *qm)
 	struct qm_debug *debug = &qm->debug;
 	struct pci_dev *pdev = qm->pdev;
 	void __iomem *io_base;
-	u32 hpre_core_info;
 	u8 clusters_num;
 	int i, j, idx;
 	u32 val;
@@ -1370,9 +1359,7 @@ static void hpre_show_last_dfx_regs(struct hisi_qm *qm)
 			  hpre_com_dfx_regs[i].name, debug->last_words[i], val);
 	}
 
-	hpre_core_info = qm->cap_tables.dev_cap_table[HPRE_CORE_INFO].cap_val;
-	clusters_num = (hpre_core_info >> hpre_basic_info[HPRE_CLUSTER_NUM_CAP].shift) &
-			hpre_basic_info[HPRE_CLUSTER_NUM_CAP].mask;
+	clusters_num = hpre_get_clusters_num(qm);
 	for (i = 0; i < clusters_num; i++) {
 		io_base = qm->io_base + hpre_cluster_offsets[i];
 		for (j = 0; j <  cluster_dfx_regs_num; j++) {
-- 
2.43.0

