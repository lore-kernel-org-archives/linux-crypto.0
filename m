Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E4C2C3244;
	Mon, 18 May 2026 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114691; cv=none; b=qPGmscedv4GqfnyP5fgzO8LfEgidC1GsavD7479YD0f7XFQTCSaQNMBXYif9RNp7071YhL6yXnnXUhhCsrUgZ7qo6lpxk55VnG1FSkyaDl+erBlsDBOCLTFvJL2Nl7gvkLP0K4rpxGA/DoF+HZOaL9/ufHIS8Y8QxUE/Jp8nOZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114691; c=relaxed/simple;
	bh=rNQZz1Pk3AFcWq7hWC8RyDtq/M93duNNUUiZQ17ZkrI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKtxpg5y/D0jdd9pz59aqfPI2tTYfghoFTuCpmDSS6Vq3kWX4Z6hlBpMz8CY1OfJbKXZhIC/J5+V41sHHL72kPuh3xCNIeOuHpV+jeqUy/7Sid3y0FWbekmh6T28xGmKjZXPyhUtft9hA1u/IUCHLn7JTPUcPzbjdB28oa/wFUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=MSNhITbF; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="MSNhITbF"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Haii3oyNo3W/HLHEmJWCWcR06NTtGEdS6MRylW8BA6E=;
	b=MSNhITbFwYYJBKoBOB+2nzbIU2d1O/N/Vb5GEOJ32xn0R03QSLimYfW2r2hOGDOq4Vf2psFRB
	uEmYKKFNrxhDqwLo/BHp2VWX5se/Lg+gEjszaO0GVdzZgELPWK663qxTmfrd0aPhDMzF4RPqa/9
	t8g2b62CsTY8eqH+cVIDTwQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gK0RC5sb7zcb14;
	Mon, 18 May 2026 22:23:51 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 987994048F;
	Mon, 18 May 2026 22:31:22 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 18 May 2026 22:31:22 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 5/6] crypto: hisilicon - mask all error type when removing driver
Date: Mon, 18 May 2026 22:29:55 +0800
Message-ID: <20260518142956.3593934-6-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260518142956.3593934-1-wuzongyu1@huawei.com>
References: <20260518142956.3593934-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: Weili Qian <qianweili@huawei.com>

Each bit in the error interrupt register corresponds to a specific
error type. A bit value of 0 enables the interrupt, and a bit value
of 1 disables the interrupt. Currently, when disabling interrupts,
it incorrectly enables the interrupt types that were not enabled.
Therefore, when disabling interrupts, all bits should be directly
written to 1.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  9 +++----
 drivers/crypto/hisilicon/qm.c             | 30 ++++++-----------------
 drivers/crypto/hisilicon/sec2/sec_main.c  |  3 ++-
 drivers/crypto/hisilicon/zip/zip_main.c   | 10 +++-----
 4 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index a484381f522a..b6903fce6071 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -55,6 +55,8 @@
 #define HPRE_RAS_FE_ENB			0x301418
 #define HPRE_OOO_SHUTDOWN_SEL		0x301a3c
 #define HPRE_HAC_RAS_FE_ENABLE		0
+#define HPRE_RAS_MASK_ALL		GENMASK(31, 0)
+#define HPRE_RAS_CLEAR_ALL		GENMASK(31, 0)
 
 #define HPRE_CORE_ENB		(HPRE_CLSTR_BASE + HPRE_CORE_EN_OFFSET)
 #define HPRE_CORE_INI_CFG	(HPRE_CLSTR_BASE + HPRE_CORE_INI_CFG_OFFSET)
@@ -820,11 +822,8 @@ static void hpre_master_ooo_ctrl(struct hisi_qm *qm, bool enable)
 
 static void hpre_hw_error_disable(struct hisi_qm *qm)
 {
-	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
-	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
-
 	/* disable hpre hw error interrupts */
-	writel(err_mask, qm->io_base + HPRE_INT_MASK);
+	writel(HPRE_RAS_MASK_ALL, qm->io_base + HPRE_INT_MASK);
 	/* disable HPRE block master OOO when nfe occurs on Kunpeng930 */
 	hpre_master_ooo_ctrl(qm, false);
 }
@@ -835,7 +834,7 @@ static void hpre_hw_error_enable(struct hisi_qm *qm)
 	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
 
 	/* clear HPRE hw error source if having */
-	writel(err_mask, qm->io_base + HPRE_HAC_SOURCE_INT);
+	writel(HPRE_RAS_CLEAR_ALL, qm->io_base + HPRE_HAC_SOURCE_INT);
 
 	/* configure error type */
 	writel(dev_err->ce, qm->io_base + HPRE_RAS_CE_ENB);
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 90b447b934c6..bfee16503c38 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -128,7 +128,6 @@
 
 #define QM_ABNORMAL_INT_SOURCE		0x100000
 #define QM_ABNORMAL_INT_MASK		0x100004
-#define QM_ABNORMAL_INT_MASK_VALUE	0x7fff
 #define QM_ABNORMAL_INT_STATUS		0x100008
 #define QM_ABNORMAL_INT_SET		0x10000c
 #define QM_ABNORMAL_INF00		0x100010
@@ -153,6 +152,8 @@
 #define QM_DB_TIMEOUT			BIT(10)
 #define QM_OF_FIFO_OF			BIT(11)
 #define QM_RAS_AXI_ERROR		(BIT(0) | BIT(1) | BIT(12))
+#define QM_RAS_MASK_ALL			GENMASK(31, 0)
+#define QM_RAS_CLEAR_ALL		GENMASK(31, 0)
 
 #define QM_RESET_WAIT_TIMEOUT		400
 #define QM_PEH_VENDOR_ID		0x1000d8
@@ -1504,7 +1505,7 @@ static int qm_get_vft_v2(struct hisi_qm *qm, u32 *base, u32 *number)
 
 static void qm_hw_error_init_v1(struct hisi_qm *qm)
 {
-	writel(QM_ABNORMAL_INT_MASK_VALUE, qm->io_base + QM_ABNORMAL_INT_MASK);
+	writel(QM_RAS_MASK_ALL, qm->io_base + QM_ABNORMAL_INT_MASK);
 }
 
 static void qm_hw_error_cfg(struct hisi_qm *qm)
@@ -1513,7 +1514,7 @@ static void qm_hw_error_cfg(struct hisi_qm *qm)
 
 	qm->error_mask = qm_err->nfe | qm_err->ce | qm_err->fe;
 	/* clear QM hw residual error source */
-	writel(qm->error_mask, qm->io_base + QM_ABNORMAL_INT_SOURCE);
+	writel(QM_RAS_CLEAR_ALL, qm->io_base + QM_ABNORMAL_INT_SOURCE);
 	if (qm->ver >= QM_HW_V5)
 		writeq(QM_FUNC_RAS_CLEAR_ALL, qm->io_base + QM_FUNC_AXI_ERR_ST0);
 
@@ -1526,43 +1527,28 @@ static void qm_hw_error_cfg(struct hisi_qm *qm)
 
 static void qm_hw_error_init_v2(struct hisi_qm *qm)
 {
-	u32 irq_unmask;
-
 	qm_hw_error_cfg(qm);
 
-	irq_unmask = ~qm->error_mask;
-	irq_unmask &= readl(qm->io_base + QM_ABNORMAL_INT_MASK);
-	writel(irq_unmask, qm->io_base + QM_ABNORMAL_INT_MASK);
+	writel(~qm->error_mask, qm->io_base + QM_ABNORMAL_INT_MASK);
 }
 
 static void qm_hw_error_uninit_v2(struct hisi_qm *qm)
 {
-	u32 irq_mask = qm->error_mask;
-
-	irq_mask |= readl(qm->io_base + QM_ABNORMAL_INT_MASK);
-	writel(irq_mask, qm->io_base + QM_ABNORMAL_INT_MASK);
+	writel(QM_RAS_MASK_ALL, qm->io_base + QM_ABNORMAL_INT_MASK);
 }
 
 static void qm_hw_error_init_v3(struct hisi_qm *qm)
 {
-	u32 irq_unmask;
-
 	qm_hw_error_cfg(qm);
 
 	/* enable close master ooo when hardware error happened */
 	writel(qm->err_info.qm_err.shutdown_mask, qm->io_base + QM_OOO_SHUTDOWN_SEL);
-
-	irq_unmask = ~qm->error_mask;
-	irq_unmask &= readl(qm->io_base + QM_ABNORMAL_INT_MASK);
-	writel(irq_unmask, qm->io_base + QM_ABNORMAL_INT_MASK);
+	writel(~qm->error_mask, qm->io_base + QM_ABNORMAL_INT_MASK);
 }
 
 static void qm_hw_error_uninit_v3(struct hisi_qm *qm)
 {
-	u32 irq_mask = qm->error_mask;
-
-	irq_mask |= readl(qm->io_base + QM_ABNORMAL_INT_MASK);
-	writel(irq_mask, qm->io_base + QM_ABNORMAL_INT_MASK);
+	writel(QM_RAS_MASK_ALL, qm->io_base + QM_ABNORMAL_INT_MASK);
 
 	/* disable close master ooo when hardware error happened */
 	writel(0x0, qm->io_base + QM_OOO_SHUTDOWN_SEL);
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index e8bea1e496f7..752565200c16 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -48,6 +48,7 @@
 #define SEC_OOO_SHUTDOWN_SEL		0x301014
 #define SEC_RAS_DISABLE		0x0
 #define SEC_AXI_ERROR_MASK		(BIT(0) | BIT(1))
+#define SEC_RAS_CLEAR_ALL		GENMASK(31, 0)
 
 #define SEC_MEM_START_INIT_REG	0x301100
 #define SEC_MEM_INIT_DONE_REG		0x301104
@@ -752,7 +753,7 @@ static void sec_hw_error_enable(struct hisi_qm *qm)
 	}
 
 	/* clear SEC hw error source if having */
-	writel(err_mask, qm->io_base + SEC_CORE_INT_SOURCE);
+	writel(SEC_RAS_CLEAR_ALL, qm->io_base + SEC_CORE_INT_SOURCE);
 
 	/* enable RAS int */
 	writel(dev_err->ce, qm->io_base + SEC_RAS_CE_REG);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 5135b3028cb2..706a73656977 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -64,7 +64,8 @@
 #define HZIP_OOO_SHUTDOWN_SEL		0x30120C
 #define HZIP_SRAM_ECC_ERR_NUM_SHIFT	16
 #define HZIP_SRAM_ECC_ERR_ADDR_SHIFT	24
-#define HZIP_CORE_INT_MASK_ALL		GENMASK(12, 0)
+#define HZIP_CORE_INT_MASK_ALL		GENMASK(31, 0)
+#define HZIP_CORE_RAS_CLEAR_ALL		GENMASK(31, 0)
 #define HZIP_AXI_ERROR_MASK		(BIT(2) | BIT(3))
 #define HZIP_SQE_SIZE			128
 #define HZIP_PF_DEF_Q_NUM		64
@@ -696,7 +697,7 @@ static void hisi_zip_hw_error_enable(struct hisi_qm *qm)
 	}
 
 	/* clear ZIP hw error source if having */
-	writel(err_mask, qm->io_base + HZIP_CORE_INT_SOURCE);
+	writel(HZIP_CORE_RAS_CLEAR_ALL, qm->io_base + HZIP_CORE_INT_SOURCE);
 
 	/* configure error type */
 	writel(dev_err->ce, qm->io_base + HZIP_CORE_INT_RAS_CE_ENB);
@@ -713,11 +714,8 @@ static void hisi_zip_hw_error_enable(struct hisi_qm *qm)
 
 static void hisi_zip_hw_error_disable(struct hisi_qm *qm)
 {
-	struct hisi_qm_err_mask *dev_err = &qm->err_info.dev_err;
-	u32 err_mask = dev_err->ce | dev_err->nfe | dev_err->fe;
-
 	/* disable ZIP hw error interrupts */
-	writel(err_mask, qm->io_base + HZIP_CORE_INT_MASK_REG);
+	writel(HZIP_CORE_INT_MASK_ALL, qm->io_base + HZIP_CORE_INT_MASK_REG);
 
 	hisi_zip_master_ooo_ctrl(qm, false);
 
-- 
2.33.0

