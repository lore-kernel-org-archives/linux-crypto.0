Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A56143872;
	Mon,  6 May 2024 11:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714996801; cv=none; b=k383vdO6aDn28SAWILfqlBO5T37BGUEghifzNFSWd3CR5irHQt9xodhd2+9lgKeKG5Iagq7gk2/4UP2DVlj6UluztmcMZ4/aDLP7GViK2VtmTb8zEdZXLMcBHTvBR/Gb2/48MMU3mUg6ST1SVFhNRci1X4j6C5XAd5PRSu3b3TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714996801; c=relaxed/simple;
	bh=4Um6I+BnDnROEkbW93ufQ1m1ObGVmSwFLC9xctMT0Bs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dUu9yhzR4rS0y4KoEJDYoaqOT7cWNkLWj9DN2idCiv72fUiOK03Tlcpyo/+6SiLIr5nM8jx2Heo/tUKlzes4cfCekIbdwK6BehprliN91N7+lpxl4yGmeywAy9rhqhIm8yVK7KKszOcGCMASN8cqV5WBGxskasjTDLTAnK1ni90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VY0HC71KWzcp1S;
	Mon,  6 May 2024 19:56:07 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id B5515180080;
	Mon,  6 May 2024 19:59:55 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 19:59:55 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<shenyang39@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH 2/2] crypto: hisilicon/zip - optimize the address offset of the reg query function
Date: Mon, 6 May 2024 19:59:53 +0800
Message-ID: <20240506115953.2282155-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240506115953.2282155-1-huangchenghai2@huawei.com>
References: <20240506115953.2282155-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500025.china.huawei.com (7.221.188.170)

Currently, the reg is queried based on the fixed address offset
array. When the number of accelerator cores changes, the system
can not flexibly respond to the change.

Therefore, the reg to be queried is calculated based on the
comp or decomp core base address.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 48 +++++++++++--------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 399b681ee423..63d6b88dd592 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -37,7 +37,7 @@
 #define HZIP_QM_IDEL_STATUS		0x3040e4
 
 #define HZIP_CORE_DFX_BASE		0x301000
-#define HZIP_CLOCK_GATED_CONTL		0X301004
+#define HZIP_CORE_DFX_DECOMP_BASE	0x304000
 #define HZIP_CORE_DFX_COMP_0		0x302000
 #define HZIP_CORE_DFX_COMP_1		0x303000
 #define HZIP_CORE_DFX_DECOMP_0		0x304000
@@ -48,6 +48,7 @@
 #define HZIP_CORE_DFX_DECOMP_5		0x309000
 #define HZIP_CORE_REGS_BASE_LEN		0xB0
 #define HZIP_CORE_REGS_DFX_LEN		0x28
+#define HZIP_CORE_ADDR_INTRVL		0x1000
 
 #define HZIP_CORE_INT_SOURCE		0x3010A0
 #define HZIP_CORE_INT_MASK_REG		0x3010A4
@@ -269,28 +270,6 @@ static const u32 zip_pre_store_caps[] = {
 	ZIP_DEV_ALG_BITMAP,
 };
 
-enum {
-	HZIP_COMP_CORE0,
-	HZIP_COMP_CORE1,
-	HZIP_DECOMP_CORE0,
-	HZIP_DECOMP_CORE1,
-	HZIP_DECOMP_CORE2,
-	HZIP_DECOMP_CORE3,
-	HZIP_DECOMP_CORE4,
-	HZIP_DECOMP_CORE5,
-};
-
-static const u64 core_offsets[] = {
-	[HZIP_COMP_CORE0]   = 0x302000,
-	[HZIP_COMP_CORE1]   = 0x303000,
-	[HZIP_DECOMP_CORE0] = 0x304000,
-	[HZIP_DECOMP_CORE1] = 0x305000,
-	[HZIP_DECOMP_CORE2] = 0x306000,
-	[HZIP_DECOMP_CORE3] = 0x307000,
-	[HZIP_DECOMP_CORE4] = 0x308000,
-	[HZIP_DECOMP_CORE5] = 0x309000,
-};
-
 static const struct debugfs_reg32 hzip_dfx_regs[] = {
 	{"HZIP_GET_BD_NUM                ",  0x00},
 	{"HZIP_GET_RIGHT_BD              ",  0x04},
@@ -807,6 +786,18 @@ static int hisi_zip_regs_show(struct seq_file *s, void *unused)
 
 DEFINE_SHOW_ATTRIBUTE(hisi_zip_regs);
 
+static void __iomem *get_zip_core_addr(struct hisi_qm *qm, int core_num)
+{
+	u32 zip_comp_core_num = qm->cap_tables.dev_cap_table[ZIP_CLUSTER_COMP_NUM_CAP_IDX].cap_val;
+
+	if (core_num < zip_comp_core_num)
+		return qm->io_base + HZIP_CORE_DFX_BASE +
+			(core_num + 1) * HZIP_CORE_ADDR_INTRVL;
+
+	qm->io_base + HZIP_CORE_DFX_DECOMP_BASE +
+		(core_num - zip_comp_core_num) * HZIP_CORE_ADDR_INTRVL;
+}
+
 static int hisi_zip_core_debug_init(struct hisi_qm *qm)
 {
 	u32 zip_core_num, zip_comp_core_num, i;
@@ -831,7 +822,7 @@ static int hisi_zip_core_debug_init(struct hisi_qm *qm)
 
 		regset->regs = hzip_dfx_regs;
 		regset->nregs = ARRAY_SIZE(hzip_dfx_regs);
-		regset->base = qm->io_base + core_offsets[i];
+		regset->base = get_zip_core_addr(qm, i);
 		regset->dev = dev;
 
 		tmp_d = debugfs_create_dir(buf, qm->debug.debug_root);
@@ -920,13 +911,14 @@ static int hisi_zip_debugfs_init(struct hisi_qm *qm)
 /* hisi_zip_debug_regs_clear() - clear the zip debug regs */
 static void hisi_zip_debug_regs_clear(struct hisi_qm *qm)
 {
+	u32 zip_core_num = qm->cap_tables.dev_cap_table[ZIP_CORE_NUM_CAP_IDX].cap_val;
 	size_t i, j;
 
 	/* enable register read_clear bit */
 	writel(HZIP_RD_CNT_CLR_CE_EN, qm->io_base + HZIP_SOFT_CTRL_CNT_CLR_CE);
-	for (i = 0; i < ARRAY_SIZE(core_offsets); i++)
+	for (i = 0; i < zip_core_num; i++)
 		for (j = 0; j < ARRAY_SIZE(hzip_dfx_regs); j++)
-			readl(qm->io_base + core_offsets[i] +
+			readl(get_zip_core_addr(qm, i) +
 			      hzip_dfx_regs[j].offset);
 
 	/* disable register read_clear bit */
@@ -968,7 +960,7 @@ static int hisi_zip_show_last_regs_init(struct hisi_qm *qm)
 	}
 
 	for (i = 0; i < zip_core_num; i++) {
-		io_base = qm->io_base + core_offsets[i];
+		io_base = get_zip_core_addr(qm, i);
 		for (j = 0; j < core_dfx_regs_num; j++) {
 			idx = com_dfx_regs_num + i * core_dfx_regs_num + j;
 			debug->last_words[idx] = readl_relaxed(
@@ -1019,7 +1011,7 @@ static void hisi_zip_show_last_dfx_regs(struct hisi_qm *qm)
 		else
 			scnprintf(buf, sizeof(buf), "Decomp_core-%u",
 				  i - zip_comp_core_num);
-		base = qm->io_base + core_offsets[i];
+		base = get_zip_core_addr(qm, i);
 
 		pci_info(qm->pdev, "==>%s:\n", buf);
 		/* dump last word for dfx regs during control resetting */
-- 
2.33.0

