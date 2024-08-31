Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569E617ADE8;
	Sat, 31 Aug 2024 11:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725105142; cv=none; b=cbDL7E8zD/3Ok1hG9jlJgFhI+mheFlwop9+Z1iUS0z7uI/2s75nGY9AcqntFigh4I75okr2I/D9RaGjgIhcR6P5vtc/S7hW+ZGVzBmeo809DMxbihDvMqeoOUy7BO5UODDHAPnBP+rVhtWPvFSIusf6EujlC6T1bIIeRwwN2QCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725105142; c=relaxed/simple;
	bh=Tow+EbFztFHXitwiR46uvbwVhVmFbyZC5mMTZ2JuFDc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gsdcqxXjD6k51ri6oBzzQ5hM7Wh7/wb8NAYLjjZFCpE18a9OzZSbsVn8HvxBSZ/bOsdu4nNJPdBQowTyrbZDW+U1HHQHzM/CjDugZ/FOo0djuf+wTdVlkRaVWUdfQRYxbpAwEo0V45JkruDEAfB552wYNxtJGJCMwoHECjKyJK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Wwtdm5b5Rz18N3l;
	Sat, 31 Aug 2024 19:51:24 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id ED7FD180100;
	Sat, 31 Aug 2024 19:52:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 31 Aug 2024 19:52:16 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH 2/3] crypto: hisilicon/hpre - mask cluster timeout error
Date: Sat, 31 Aug 2024 19:48:30 +0800
Message-ID: <20240831114831.21987-3-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240831114831.21987-1-qianweili@huawei.com>
References: <20240831114831.21987-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)

The timeout threshold of the hpre cluster is 16ms. When the CPU
and device share virtual address, page fault processing time may
exceed the threshold.

In the current test, there is a high probability that the
cluster times out. However, the cluster is waiting for the
completion of memory access, which is not an error, the device
does not need to be reset. If an error occurs in the cluster,
qm also reports the error. Therefore, the cluster timeout
error of hpre can be masked.

Fixes: d90fab0deb8e ("crypto: hisilicon/qm - get error type from hardware registers")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 12d52713b95e..6b536ad2ada5 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -13,9 +13,7 @@
 #include <linux/uacce.h>
 #include "hpre.h"
 
-#define HPRE_QM_ABNML_INT_MASK		0x100004
 #define HPRE_CTRL_CNT_CLR_CE_BIT	BIT(0)
-#define HPRE_COMM_CNT_CLR_CE		0x0
 #define HPRE_CTRL_CNT_CLR_CE		0x301000
 #define HPRE_FSM_MAX_CNT		0x301008
 #define HPRE_VFG_AXQOS			0x30100c
@@ -42,7 +40,6 @@
 #define HPRE_HAC_INT_SET		0x301500
 #define HPRE_RNG_TIMEOUT_NUM		0x301A34
 #define HPRE_CORE_INT_ENABLE		0
-#define HPRE_CORE_INT_DISABLE		GENMASK(21, 0)
 #define HPRE_RDCHN_INI_ST		0x301a00
 #define HPRE_CLSTR_BASE			0x302000
 #define HPRE_CORE_EN_OFFSET		0x04
@@ -66,7 +63,6 @@
 #define HPRE_CLSTR_ADDR_INTRVL		0x1000
 #define HPRE_CLUSTER_INQURY		0x100
 #define HPRE_CLSTR_ADDR_INQRY_RSLT	0x104
-#define HPRE_TIMEOUT_ABNML_BIT		6
 #define HPRE_PASID_EN_BIT		9
 #define HPRE_REG_RD_INTVRL_US		10
 #define HPRE_REG_RD_TMOUT_US		1000
@@ -203,9 +199,9 @@ static const struct hisi_qm_cap_info hpre_basic_info[] = {
 	{HPRE_QM_RESET_MASK_CAP, 0x3128, 0, GENMASK(31, 0), 0x0, 0xC37, 0x6C37},
 	{HPRE_QM_OOO_SHUTDOWN_MASK_CAP, 0x3128, 0, GENMASK(31, 0), 0x0, 0x4, 0x6C37},
 	{HPRE_QM_CE_MASK_CAP, 0x312C, 0, GENMASK(31, 0), 0x0, 0x8, 0x8},
-	{HPRE_NFE_MASK_CAP, 0x3130, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0x1FFFFFE},
-	{HPRE_RESET_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0xBFFFFE},
-	{HPRE_OOO_SHUTDOWN_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x22, 0xBFFFFE},
+	{HPRE_NFE_MASK_CAP, 0x3130, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0x1FFFC3E},
+	{HPRE_RESET_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x3FFFFE, 0xBFFC3E},
+	{HPRE_OOO_SHUTDOWN_MASK_CAP, 0x3134, 0, GENMASK(31, 0), 0x0, 0x22, 0xBFFC3E},
 	{HPRE_CE_MASK_CAP, 0x3138, 0, GENMASK(31, 0), 0x0, 0x1, 0x1},
 	{HPRE_CLUSTER_NUM_CAP, 0x313c, 20, GENMASK(3, 0), 0x0,  0x4, 0x1},
 	{HPRE_CORE_TYPE_NUM_CAP, 0x313c, 16, GENMASK(3, 0), 0x0, 0x2, 0x2},
@@ -656,11 +652,6 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 	writel(HPRE_QM_USR_CFG_MASK, qm->io_base + QM_AWUSER_M_CFG_ENABLE);
 	writel_relaxed(HPRE_QM_AXI_CFG_MASK, qm->io_base + QM_AXI_M_CFG);
 
-	/* HPRE need more time, we close this interrupt */
-	val = readl_relaxed(qm->io_base + HPRE_QM_ABNML_INT_MASK);
-	val |= BIT(HPRE_TIMEOUT_ABNML_BIT);
-	writel_relaxed(val, qm->io_base + HPRE_QM_ABNML_INT_MASK);
-
 	if (qm->ver >= QM_HW_V3)
 		writel(HPRE_RSA_ENB | HPRE_ECC_ENB,
 			qm->io_base + HPRE_TYPES_ENB);
@@ -669,9 +660,7 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 
 	writel(HPRE_QM_VFG_AX_MASK, qm->io_base + HPRE_VFG_AXCACHE);
 	writel(0x0, qm->io_base + HPRE_BD_ENDIAN);
-	writel(0x0, qm->io_base + HPRE_INT_MASK);
 	writel(0x0, qm->io_base + HPRE_POISON_BYPASS);
-	writel(0x0, qm->io_base + HPRE_COMM_CNT_CLR_CE);
 	writel(0x0, qm->io_base + HPRE_ECC_BYPASS);
 
 	writel(HPRE_BD_USR_MASK, qm->io_base + HPRE_BD_ARUSR_CFG);
@@ -761,7 +750,7 @@ static void hpre_hw_error_disable(struct hisi_qm *qm)
 
 static void hpre_hw_error_enable(struct hisi_qm *qm)
 {
-	u32 ce, nfe;
+	u32 ce, nfe, err_en;
 
 	ce = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_CE_MASK_CAP, qm->cap_ver);
 	nfe = hisi_qm_get_hw_info(qm, hpre_basic_info, HPRE_NFE_MASK_CAP, qm->cap_ver);
@@ -778,7 +767,8 @@ static void hpre_hw_error_enable(struct hisi_qm *qm)
 	hpre_master_ooo_ctrl(qm, true);
 
 	/* enable hpre hw error interrupts */
-	writel(HPRE_CORE_INT_ENABLE, qm->io_base + HPRE_INT_MASK);
+	err_en = ce | nfe | HPRE_HAC_RAS_FE_ENABLE;
+	writel(~err_en, qm->io_base + HPRE_INT_MASK);
 }
 
 static inline struct hisi_qm *hpre_file_to_qm(struct hpre_debugfs_file *file)
-- 
2.33.0

