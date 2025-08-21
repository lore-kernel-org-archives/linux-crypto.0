Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7CD2417E0;
	Thu, 21 Aug 2025 01:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755740297; cv=none; b=ojeJGMhHcZtuUrL5o4kiiEVMejKJTvv+rY0Ke9efTCIQWDal0LI8/FvBuOCQ1dOmnV06/jxeUm1rKaHR+Er4XRd4m4+ukDnC3vb/sesLzJoy4vwbQ8zPEzpnNfkDgrlRUO1jZEznxaA+jk/6/SYxl+k8KJJ7jvLOkJUr4NFAMDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755740297; c=relaxed/simple;
	bh=MlHqMVnU07GH6ssx63UQwR8prdxAqb6ytrZHvNp0N2s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MzXr8T2YiERTK9eGHWkqun3yl7Mre3aGCKD8UnioNTVtrvF5nVkJOWRZmppNViVE4BrVoQmaeH6ueoio4EhjHbMJEo3ph3wnYXmmTj8UHjZLlzfI8z3/nhxrbYWk7IUeN+FGAGyAmaSBq0/3APnGuIaAMwI4wWxj9UEFPYpCwR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c6m915pzCz2gLGY;
	Thu, 21 Aug 2025 09:35:17 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3B163140148;
	Thu, 21 Aug 2025 09:38:11 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:38:10 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:38:10 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<yinzhushuai@huawei.com>
Subject: [PATCH v2 2/6] crypto: hisilicon - re-enable address prefetch after device resuming
Date: Thu, 21 Aug 2025 09:38:05 +0800
Message-ID: <20250821013809.4016506-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250821013809.4016506-1-huangchenghai2@huawei.com>
References: <20250821013809.4016506-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)

When the device resumes from a suspended state, it will revert to its
initial state and requires re-enabling. Currently, the address prefetch
function is not re-enabled after device resuming. Move the address prefetch
enable to the initialization process. In this way, the address prefetch
can be enabled when the device resumes by calling the initialization
process.

Fixes: 607c191b371d ("crypto: hisilicon - support runtime PM for accelerator device")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  3 +-
 drivers/crypto/hisilicon/qm.c             |  3 -
 drivers/crypto/hisilicon/sec2/sec_main.c  | 80 +++++++++++------------
 drivers/crypto/hisilicon/zip/zip_main.c   |  5 +-
 4 files changed, 43 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index f5b47e5ff48a..34f84978180f 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -721,6 +721,7 @@ static int hpre_set_user_domain_and_cache(struct hisi_qm *qm)
 
 	/* Config data buffer pasid needed by Kunpeng 920 */
 	hpre_config_pasid(qm);
+	hpre_open_sva_prefetch(qm);
 
 	hpre_enable_clock_gate(qm);
 
@@ -1450,8 +1451,6 @@ static int hpre_pf_probe_init(struct hpre *hpre)
 	if (ret)
 		return ret;
 
-	hpre_open_sva_prefetch(qm);
-
 	hisi_qm_dev_err_init(qm);
 	ret = hpre_show_last_regs_init(qm);
 	if (ret)
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8d45febb98dd..9bbbfff759a9 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4447,9 +4447,6 @@ static void qm_restart_prepare(struct hisi_qm *qm)
 {
 	u32 value;
 
-	if (qm->err_ini->open_sva_prefetch)
-		qm->err_ini->open_sva_prefetch(qm);
-
 	if (qm->ver >= QM_HW_V3)
 		return;
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 72cf48d1f3ab..ddb20f380b54 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -464,6 +464,45 @@ static void sec_set_endian(struct hisi_qm *qm)
 	writel_relaxed(reg, qm->io_base + SEC_CONTROL_REG);
 }
 
+static void sec_close_sva_prefetch(struct hisi_qm *qm)
+{
+	u32 val;
+	int ret;
+
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
+		return;
+
+	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
+	val |= SEC_PREFETCH_DISABLE;
+	writel(val, qm->io_base + SEC_PREFETCH_CFG);
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_SVA_TRANS,
+					 val, !(val & SEC_SVA_DISABLE_READY),
+					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
+	if (ret)
+		pci_err(qm->pdev, "failed to close sva prefetch\n");
+}
+
+static void sec_open_sva_prefetch(struct hisi_qm *qm)
+{
+	u32 val;
+	int ret;
+
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
+		return;
+
+	/* Enable prefetch */
+	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
+	val &= SEC_PREFETCH_ENABLE;
+	writel(val, qm->io_base + SEC_PREFETCH_CFG);
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_PREFETCH_CFG,
+					 val, !(val & SEC_PREFETCH_DISABLE),
+					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
+	if (ret)
+		pci_err(qm->pdev, "failed to open sva prefetch\n");
+}
+
 static void sec_engine_sva_config(struct hisi_qm *qm)
 {
 	u32 reg;
@@ -497,45 +536,7 @@ static void sec_engine_sva_config(struct hisi_qm *qm)
 		writel_relaxed(reg, qm->io_base +
 				SEC_INTERFACE_USER_CTRL1_REG);
 	}
-}
-
-static void sec_open_sva_prefetch(struct hisi_qm *qm)
-{
-	u32 val;
-	int ret;
-
-	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
-		return;
-
-	/* Enable prefetch */
-	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
-	val &= SEC_PREFETCH_ENABLE;
-	writel(val, qm->io_base + SEC_PREFETCH_CFG);
-
-	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_PREFETCH_CFG,
-					 val, !(val & SEC_PREFETCH_DISABLE),
-					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
-	if (ret)
-		pci_err(qm->pdev, "failed to open sva prefetch\n");
-}
-
-static void sec_close_sva_prefetch(struct hisi_qm *qm)
-{
-	u32 val;
-	int ret;
-
-	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
-		return;
-
-	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
-	val |= SEC_PREFETCH_DISABLE;
-	writel(val, qm->io_base + SEC_PREFETCH_CFG);
-
-	ret = readl_relaxed_poll_timeout(qm->io_base + SEC_SVA_TRANS,
-					 val, !(val & SEC_SVA_DISABLE_READY),
-					 SEC_DELAY_10_US, SEC_POLL_TIMEOUT_US);
-	if (ret)
-		pci_err(qm->pdev, "failed to close sva prefetch\n");
+	sec_open_sva_prefetch(qm);
 }
 
 static void sec_enable_clock_gate(struct hisi_qm *qm)
@@ -1152,7 +1153,6 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 	if (ret)
 		return ret;
 
-	sec_open_sva_prefetch(qm);
 	hisi_qm_dev_err_init(qm);
 	sec_debug_regs_clear(qm);
 	ret = sec_show_last_regs_init(qm);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index fb7b19927dd3..480fa590664a 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -557,6 +557,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 		writel(AXUSER_BASE, base + HZIP_DATA_WUSER_32_63);
 		writel(AXUSER_BASE, base + HZIP_SGL_RUSER_32_63);
 	}
+	hisi_zip_open_sva_prefetch(qm);
 
 	/* let's open all compression/decompression cores */
 
@@ -572,6 +573,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	       CQC_CACHE_WB_ENABLE | FIELD_PREP(SQC_CACHE_WB_THRD, 1) |
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), base + QM_CACHE_CTL);
 
+	hisi_zip_set_high_perf(qm);
 	hisi_zip_enable_clock_gate(qm);
 
 	return hisi_dae_set_user_domain(qm);
@@ -1243,9 +1245,6 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	if (ret)
 		return ret;
 
-	hisi_zip_set_high_perf(qm);
-
-	hisi_zip_open_sva_prefetch(qm);
 	hisi_qm_dev_err_init(qm);
 	hisi_zip_debug_regs_clear(qm);
 
-- 
2.33.0

