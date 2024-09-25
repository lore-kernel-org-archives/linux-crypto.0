Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935111ACE0B;
	Wed, 25 Sep 2024 11:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727264395; cv=none; b=rE5pytrmhHZ2/vnPIek51rmO1b4wz1G2canRDR7+u5c4DXzhpR86ax6YWMpjpGo+qc5gkGfaHZjlqDPz8NuaJlBskBD0bMOtJufY1uN1RogxO6Ikij6Memyl33FaytVjLtaDoStjxnFIRRydlo6FZ9v+gpDxNBZ9EU9hqx6hVAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727264395; c=relaxed/simple;
	bh=3JDgK7r49dnYjAn5axPhicfcxjl3S3/1owrqiP/nEsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shcGLpitYiqCEAn8lAX5ATaza2daKlcPtitqSeujeb7CYKbeWQ4DDomDposcRBOgoAyN5N13BcOcI1HWT4pwDbKnwNyNUntC2HCkBK3sHjegtnP5dNvubwgrosENgyflFA9bzTZ2Jbl+ztEOA+sOpIOKWMMIKJOtMCvu9aIlfYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8sllaqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8sllaqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184F4C4CEC3;
	Wed, 25 Sep 2024 11:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727264395;
	bh=3JDgK7r49dnYjAn5axPhicfcxjl3S3/1owrqiP/nEsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8sllaqC1vp/t79Nn2P+JbkEtrXqS0Mq5pJq+8ICcvWn6/KXHfz4/drG35gcOOk8l
	 dx/9TJNe2jta5VEpPOHF/xusws07ry9QKn3waJfKPO3pHwLwYE/i5oZymSmbyP7f6O
	 Q3xovijhAC4gHjCMAppQ7W8w8Ep8k8dYiTiLaZAXQIra4Sr3M3a7qOeeUS3PYv6muC
	 7sZOmS7KqhqJnCYEuo377H9FLRfzGrgENoJc/3+v0gD4wEdXwUYXMqlKFwyhqRQPKM
	 dlMmxOXS5R+1Bojf6NAm/Dkvoros6vpWUt3N4et5YWyNO38bijKpen+j3Uj5c69cUb
	 VhvFqtSfPkYuw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	songzhiqi1@huawei.com,
	liulongfang@huawei.com,
	davem@davemloft.net,
	wangzhou1@hisilicon.com,
	shenyang39@huawei.com,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 081/244] crypto: hisilicon/qm - reset device before enabling it
Date: Wed, 25 Sep 2024 07:25:02 -0400
Message-ID: <20240925113641.1297102-81-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925113641.1297102-1-sashal@kernel.org>
References: <20240925113641.1297102-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11
Content-Transfer-Encoding: 8bit

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 5d2d1ee0874c26b8010ddf7f57e2f246e848af38 ]

Before the device is enabled again, the device may still
store the previously processed data. If an error occurs in
the previous task, the device may fail to be enabled again.
Therefore, before enabling device, reset the device to restore
the initial state.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  32 +++---
 drivers/crypto/hisilicon/qm.c             | 114 +++++++++++++++-------
 drivers/crypto/hisilicon/sec2/sec_main.c  |  16 ++-
 drivers/crypto/hisilicon/zip/zip_main.c   |  23 +++--
 4 files changed, 121 insertions(+), 64 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 10aa4da93323f..12d52713b95e3 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -358,6 +358,8 @@ static struct dfx_diff_registers hpre_diff_regs[] = {
 	},
 };
 
+static const struct hisi_qm_err_ini hpre_err_ini;
+
 bool hpre_check_alg_support(struct hisi_qm *qm, u32 alg)
 {
 	u32 cap_val;
@@ -1161,6 +1163,7 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		qm->qp_num = pf_q_num;
 		qm->debug.curr_qm_qp_num = pf_q_num;
 		qm->qm_list = &hpre_devices;
+		qm->err_ini = &hpre_err_ini;
 		if (pf_q_num_flag)
 			set_bit(QM_MODULE_PARAM, &qm->misc_ctl);
 	}
@@ -1350,8 +1353,6 @@ static int hpre_pf_probe_init(struct hpre *hpre)
 
 	hpre_open_sva_prefetch(qm);
 
-	qm->err_ini = &hpre_err_ini;
-	qm->err_ini->err_info_init(qm);
 	hisi_qm_dev_err_init(qm);
 	ret = hpre_show_last_regs_init(qm);
 	if (ret)
@@ -1380,6 +1381,18 @@ static int hpre_probe_init(struct hpre *hpre)
 	return 0;
 }
 
+static void hpre_probe_uninit(struct hisi_qm *qm)
+{
+	if (qm->fun_type == QM_HW_VF)
+		return;
+
+	hpre_cnt_regs_clear(qm);
+	qm->debug.curr_qm_qp_num = 0;
+	hpre_show_last_regs_uninit(qm);
+	hpre_close_sva_prefetch(qm);
+	hisi_qm_dev_err_uninit(qm);
+}
+
 static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct hisi_qm *qm;
@@ -1405,7 +1418,7 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = hisi_qm_start(qm);
 	if (ret)
-		goto err_with_err_init;
+		goto err_with_probe_init;
 
 	ret = hpre_debugfs_init(qm);
 	if (ret)
@@ -1444,9 +1457,8 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hpre_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
 
-err_with_err_init:
-	hpre_show_last_regs_uninit(qm);
-	hisi_qm_dev_err_uninit(qm);
+err_with_probe_init:
+	hpre_probe_uninit(qm);
 
 err_with_qm_init:
 	hisi_qm_uninit(qm);
@@ -1468,13 +1480,7 @@ static void hpre_remove(struct pci_dev *pdev)
 	hpre_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
 
-	if (qm->fun_type == QM_HW_PF) {
-		hpre_cnt_regs_clear(qm);
-		qm->debug.curr_qm_qp_num = 0;
-		hpre_show_last_regs_uninit(qm);
-		hisi_qm_dev_err_uninit(qm);
-	}
-
+	hpre_probe_uninit(qm);
 	hisi_qm_uninit(qm);
 }
 
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index f614fd228b562..b2b5f15abdf72 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -450,6 +450,7 @@ static struct qm_typical_qos_table shaper_cbs_s[] = {
 };
 
 static void qm_irqs_unregister(struct hisi_qm *qm);
+static int qm_reset_device(struct hisi_qm *qm);
 
 static u32 qm_get_hw_error_status(struct hisi_qm *qm)
 {
@@ -4108,6 +4109,22 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 	return 0;
 }
 
+static int qm_master_ooo_check(struct hisi_qm *qm)
+{
+	u32 val;
+	int ret;
+
+	/* Check the ooo register of the device before resetting the device. */
+	writel(ACC_MASTER_GLOBAL_CTRL_SHUTDOWN, qm->io_base + ACC_MASTER_GLOBAL_CTRL);
+	ret = readl_relaxed_poll_timeout(qm->io_base + ACC_MASTER_TRANS_RETURN,
+					 val, (val == ACC_MASTER_TRANS_RETURN_RW),
+					 POLL_PERIOD, POLL_TIMEOUT);
+	if (ret)
+		pci_warn(qm->pdev, "Bus lock! Please reset system.\n");
+
+	return ret;
+}
+
 static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
 {
 	u32 nfe_enb = 0;
@@ -4130,11 +4147,10 @@ static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
 	}
 }
 
-static int qm_soft_reset(struct hisi_qm *qm)
+static int qm_soft_reset_prepare(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
-	u32 val;
 
 	/* Ensure all doorbells and mailboxes received by QM */
 	ret = qm_check_req_recv(qm);
@@ -4156,29 +4172,23 @@ static int qm_soft_reset(struct hisi_qm *qm)
 	}
 
 	qm_dev_ecc_mbit_handle(qm);
-
-	/* OOO register set and check */
-	writel(ACC_MASTER_GLOBAL_CTRL_SHUTDOWN,
-	       qm->io_base + ACC_MASTER_GLOBAL_CTRL);
-
-	/* If bus lock, reset chip */
-	ret = readl_relaxed_poll_timeout(qm->io_base + ACC_MASTER_TRANS_RETURN,
-					 val,
-					 (val == ACC_MASTER_TRANS_RETURN_RW),
-					 POLL_PERIOD, POLL_TIMEOUT);
-	if (ret) {
-		pci_emerg(pdev, "Bus lock! Please reset system.\n");
+	ret = qm_master_ooo_check(qm);
+	if (ret)
 		return ret;
-	}
 
 	if (qm->err_ini->close_sva_prefetch)
 		qm->err_ini->close_sva_prefetch(qm);
 
 	ret = qm_set_pf_mse(qm, false);
-	if (ret) {
+	if (ret)
 		pci_err(pdev, "Fails to disable pf MSE bit.\n");
-		return ret;
-	}
+
+	return ret;
+}
+
+static int qm_reset_device(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
 
 	/* The reset related sub-control registers are not in PCI BAR */
 	if (ACPI_HANDLE(&pdev->dev)) {
@@ -4197,12 +4207,23 @@ static int qm_soft_reset(struct hisi_qm *qm)
 			pci_err(pdev, "Reset step %llu failed!\n", value);
 			return -EIO;
 		}
-	} else {
-		pci_err(pdev, "No reset method!\n");
-		return -EINVAL;
+
+		return 0;
 	}
 
-	return 0;
+	pci_err(pdev, "No reset method!\n");
+	return -EINVAL;
+}
+
+static int qm_soft_reset(struct hisi_qm *qm)
+{
+	int ret;
+
+	ret = qm_soft_reset_prepare(qm);
+	if (ret)
+		return ret;
+
+	return qm_reset_device(qm);
 }
 
 static int qm_vf_reset_done(struct hisi_qm *qm)
@@ -5155,6 +5176,35 @@ static int qm_get_pci_res(struct hisi_qm *qm)
 	return ret;
 }
 
+static int qm_clear_device(struct hisi_qm *qm)
+{
+	acpi_handle handle = ACPI_HANDLE(&qm->pdev->dev);
+	int ret;
+
+	if (qm->fun_type == QM_HW_VF)
+		return 0;
+
+	/* Device does not support reset, return */
+	if (!qm->err_ini->err_info_init)
+		return 0;
+	qm->err_ini->err_info_init(qm);
+
+	if (!handle)
+		return 0;
+
+	/* No reset method, return */
+	if (!acpi_has_method(handle, qm->err_info.acpi_rst))
+		return 0;
+
+	ret = qm_master_ooo_check(qm);
+	if (ret) {
+		writel(0x0, qm->io_base + ACC_MASTER_GLOBAL_CTRL);
+		return ret;
+	}
+
+	return qm_reset_device(qm);
+}
+
 static int hisi_qm_pci_init(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -5184,8 +5234,14 @@ static int hisi_qm_pci_init(struct hisi_qm *qm)
 		goto err_get_pci_res;
 	}
 
+	ret = qm_clear_device(qm);
+	if (ret)
+		goto err_free_vectors;
+
 	return 0;
 
+err_free_vectors:
+	pci_free_irq_vectors(pdev);
 err_get_pci_res:
 	qm_put_pci_res(qm);
 err_disable_pcidev:
@@ -5486,7 +5542,6 @@ static int qm_prepare_for_suspend(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
 	int ret;
-	u32 val;
 
 	ret = qm->ops->set_msi(qm, false);
 	if (ret) {
@@ -5494,18 +5549,9 @@ static int qm_prepare_for_suspend(struct hisi_qm *qm)
 		return ret;
 	}
 
-	/* shutdown OOO register */
-	writel(ACC_MASTER_GLOBAL_CTRL_SHUTDOWN,
-	       qm->io_base + ACC_MASTER_GLOBAL_CTRL);
-
-	ret = readl_relaxed_poll_timeout(qm->io_base + ACC_MASTER_TRANS_RETURN,
-					 val,
-					 (val == ACC_MASTER_TRANS_RETURN_RW),
-					 POLL_PERIOD, POLL_TIMEOUT);
-	if (ret) {
-		pci_emerg(pdev, "Bus lock! Please reset system.\n");
+	ret = qm_master_ooo_check(qm);
+	if (ret)
 		return ret;
-	}
 
 	ret = qm_set_pf_mse(qm, false);
 	if (ret)
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 75aad04ffe5eb..c35533d8930b2 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1065,9 +1065,6 @@ static int sec_pf_probe_init(struct sec_dev *sec)
 	struct hisi_qm *qm = &sec->qm;
 	int ret;
 
-	qm->err_ini = &sec_err_ini;
-	qm->err_ini->err_info_init(qm);
-
 	ret = sec_set_user_domain_and_cache(qm);
 	if (ret)
 		return ret;
@@ -1122,6 +1119,7 @@ static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		qm->qp_num = pf_q_num;
 		qm->debug.curr_qm_qp_num = pf_q_num;
 		qm->qm_list = &sec_devices;
+		qm->err_ini = &sec_err_ini;
 		if (pf_q_num_flag)
 			set_bit(QM_MODULE_PARAM, &qm->misc_ctl);
 	} else if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V1) {
@@ -1186,6 +1184,12 @@ static int sec_probe_init(struct sec_dev *sec)
 
 static void sec_probe_uninit(struct hisi_qm *qm)
 {
+	if (qm->fun_type == QM_HW_VF)
+		return;
+
+	sec_debug_regs_clear(qm);
+	sec_show_last_regs_uninit(qm);
+	sec_close_sva_prefetch(qm);
 	hisi_qm_dev_err_uninit(qm);
 }
 
@@ -1274,7 +1278,6 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sec_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
 err_probe_uninit:
-	sec_show_last_regs_uninit(qm);
 	sec_probe_uninit(qm);
 err_qm_uninit:
 	sec_qm_uninit(qm);
@@ -1296,11 +1299,6 @@ static void sec_remove(struct pci_dev *pdev)
 	sec_debugfs_exit(qm);
 
 	(void)hisi_qm_stop(qm, QM_NORMAL);
-
-	if (qm->fun_type == QM_HW_PF)
-		sec_debug_regs_clear(qm);
-	sec_show_last_regs_uninit(qm);
-
 	sec_probe_uninit(qm);
 
 	sec_qm_uninit(qm);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 7c2d803886fde..d07e47b48be06 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -1141,8 +1141,6 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 
 	hisi_zip->ctrl = ctrl;
 	ctrl->hisi_zip = hisi_zip;
-	qm->err_ini = &hisi_zip_err_ini;
-	qm->err_ini->err_info_init(qm);
 
 	ret = hisi_zip_set_user_domain_and_cache(qm);
 	if (ret)
@@ -1203,6 +1201,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		qm->qp_num = pf_q_num;
 		qm->debug.curr_qm_qp_num = pf_q_num;
 		qm->qm_list = &zip_devices;
+		qm->err_ini = &hisi_zip_err_ini;
 		if (pf_q_num_flag)
 			set_bit(QM_MODULE_PARAM, &qm->misc_ctl);
 	} else if (qm->fun_type == QM_HW_VF && qm->ver == QM_HW_V1) {
@@ -1269,6 +1268,16 @@ static int hisi_zip_probe_init(struct hisi_zip *hisi_zip)
 	return 0;
 }
 
+static void hisi_zip_probe_uninit(struct hisi_qm *qm)
+{
+	if (qm->fun_type == QM_HW_VF)
+		return;
+
+	hisi_zip_show_last_regs_uninit(qm);
+	hisi_zip_close_sva_prefetch(qm);
+	hisi_qm_dev_err_uninit(qm);
+}
+
 static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct hisi_zip *hisi_zip;
@@ -1295,7 +1304,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = hisi_qm_start(qm);
 	if (ret)
-		goto err_dev_err_uninit;
+		goto err_probe_uninit;
 
 	ret = hisi_zip_debugfs_init(qm);
 	if (ret)
@@ -1334,9 +1343,8 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hisi_zip_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
 
-err_dev_err_uninit:
-	hisi_zip_show_last_regs_uninit(qm);
-	hisi_qm_dev_err_uninit(qm);
+err_probe_uninit:
+	hisi_zip_probe_uninit(qm);
 
 err_qm_uninit:
 	hisi_zip_qm_uninit(qm);
@@ -1358,8 +1366,7 @@ static void hisi_zip_remove(struct pci_dev *pdev)
 
 	hisi_zip_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
-	hisi_zip_show_last_regs_uninit(qm);
-	hisi_qm_dev_err_uninit(qm);
+	hisi_zip_probe_uninit(qm);
 	hisi_zip_qm_uninit(qm);
 }
 
-- 
2.43.0

