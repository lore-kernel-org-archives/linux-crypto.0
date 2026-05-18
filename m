Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6336B29346F;
	Mon, 18 May 2026 14:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779114690; cv=none; b=Kj5VOifDeHpTVIiF7KXejR67Hk2+qcIsYFfJsi8lVLmjcSGIv8p9IbIiL4b0x1GuYW5JEL7e7Owrjd6r7Ppwav/h0YIJL5C3jAv39CHVP7J9z3Ry6BucOct3CtB5XmNjFxRJrpAhDfhZBoOV5cRK+CLuOF64q6E4Hql/CkMWqtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779114690; c=relaxed/simple;
	bh=P1KizKWOh9W62NEjkB0oVH2CxZYhrJZ3mD1z+mmmN60=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FL4IcujZG051jKUVKybRRnMgbEKYjjudoBOoBtuubf4pkI1ZAnBA89oq+DJ06bZG8jmvd9VcT0wLCJ/FpqaxmMXlMYrND9fT72gRlsMK1F75PsxqDEBnpCPrV6SybnUUgrRJuyGFmfYdok9RDK/6JJbFw0t7Vpk7c5WSpXCfWZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=EYc7nGqp; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="EYc7nGqp"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VwuZcbTBreBFXA7nGawBVYiHTFCUEz2fzEhGJCPIuLo=;
	b=EYc7nGqp2Sl/vKn/Bsou3l4u4fwwWWq5OiWha+QBG5f7zR5XN6GJlJSDizv46cJhQFQ1NPV64
	oc+oh2f3DCNTZeJvBps1dx7t9kLJMxgq0/clkOwJLWrhGloYg3B756i2QD+Kdu6oVa3XRwTCoc6
	mFPFnKi1N+SuL4TwhzH8hQs=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gK0RB65p1zcb14;
	Mon, 18 May 2026 22:23:50 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 9F07240561;
	Mon, 18 May 2026 22:31:21 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 18 May 2026 22:31:21 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 2/6] crypto: hisilicon/qm - place the interrupt status interface after the PM usage counter
Date: Mon, 18 May 2026 22:29:52 +0800
Message-ID: <20260518142956.3593934-3-wuzongyu1@huawei.com>
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

From: Zhushuai Yin <yinzhushuai@huawei.com>

To avoid accessing memory of a suspended device, and since the counter
interface used by PM involves sleep operations, the counter interface
cannot be placed in the interrupt top half. Therefore, the interface for
acquiring the interrupt status in the RAS reset flow that resides in the
interrupt context needs to be moved to the bottom half for processing.

Signed-off-by: Zhushuai Yin <yinzhushuai@huawei.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 34 ++++++++++++++++++----------------
 include/linux/hisi_acc_qm.h   |  1 -
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9cf52873a891..71af462daf5b 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1195,6 +1195,11 @@ static irqreturn_t qm_aeq_thread(int irq, void *data)
 
 	atomic64_inc(&qm->debug.dfx.aeq_irq_cnt);
 
+	if (qm_pm_get_sync(qm)) {
+		dev_err(&qm->pdev->dev, "failed to get runtime PM for aeq handle\n");
+		return IRQ_HANDLED;
+	}
+
 	while (QM_AEQE_PHASE(dw0) == qm->status.aeqc_phase) {
 		type = (dw0 >> QM_AEQE_TYPE_SHIFT) & QM_AEQE_TYPE_MASK;
 		qp_id = dw0 & QM_AEQE_CQN_MASK;
@@ -1230,6 +1235,8 @@ static irqreturn_t qm_aeq_thread(int irq, void *data)
 
 	qm_db(qm, 0, QM_DOORBELL_CMD_AEQ, qm->status.aeq_head, 0);
 
+	qm_pm_put_sync(qm);
+
 	return IRQ_HANDLED;
 }
 
@@ -3043,9 +3050,9 @@ void hisi_qm_wait_task_finish(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
 		msleep(WAIT_PERIOD);
 	}
 
-	while (test_bit(QM_RST_SCHED, &qm->misc_ctl) ||
-	       test_bit(QM_RESETTING, &qm->misc_ctl))
-		msleep(WAIT_PERIOD);
+	/* Cancel possible RAS reset process during the uninstallation procedure. */
+	if (qm->fun_type == QM_HW_PF)
+		cancel_work_sync(&qm->rst_work);
 
 	if (test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps))
 		flush_work(&qm->cmd_process);
@@ -4595,8 +4602,6 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 	if (ret)
 		pci_err(pdev, "failed to stop by vfs in soft reset!\n");
 
-	clear_bit(QM_RST_SCHED, &qm->misc_ctl);
-
 	return 0;
 }
 
@@ -4914,7 +4919,6 @@ static int qm_controller_reset(struct hisi_qm *qm)
 	if (ret) {
 		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_TX_OFFSET);
 		hisi_qm_set_hw_reset(qm, QM_RESET_STOP_RX_OFFSET);
-		clear_bit(QM_RST_SCHED, &qm->misc_ctl);
 		return ret;
 	}
 
@@ -5087,14 +5091,13 @@ static irqreturn_t qm_rsvd_irq(int irq, void *data)
 static irqreturn_t qm_abnormal_irq(int irq, void *data)
 {
 	struct hisi_qm *qm = data;
-	enum acc_err_result ret;
 
 	atomic64_inc(&qm->debug.dfx.abnormal_irq_cnt);
-	ret = qm_process_dev_error(qm);
-	if (ret == ACC_ERR_NEED_RESET &&
-	    !test_bit(QM_DRIVER_REMOVING, &qm->misc_ctl) &&
-	    !test_and_set_bit(QM_RST_SCHED, &qm->misc_ctl))
+
+	if (!test_bit(QM_DRIVER_REMOVING, &qm->misc_ctl))
 		schedule_work(&qm->rst_work);
+	else
+		pci_warn(qm->pdev, "Driver is down, need to reload driver!\n");
 
 	return IRQ_HANDLED;
 }
@@ -5123,14 +5126,13 @@ static void hisi_qm_controller_reset(struct work_struct *rst_work)
 
 	ret = qm_pm_get_sync(qm);
 	if (ret) {
-		clear_bit(QM_RST_SCHED, &qm->misc_ctl);
+		dev_err(&qm->pdev->dev, "failed to get runtime PM for controller\n");
 		return;
 	}
 
-	/* reset pcie device controller */
-	ret = qm_controller_reset(qm);
-	if (ret)
-		dev_err(&qm->pdev->dev, "controller reset failed (%d)\n", ret);
+	ret = qm_process_dev_error(qm);
+	if (ret == ACC_ERR_NEED_RESET)
+		(void)qm_controller_reset(qm);
 
 	qm_pm_put_sync(qm);
 }
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index ddecdc2531a2..98ff6bcfdebe 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -158,7 +158,6 @@ enum qm_vf_state {
 
 enum qm_misc_ctl_bits {
 	QM_DRIVER_REMOVING = 0x0,
-	QM_RST_SCHED,
 	QM_RESETTING,
 	QM_MODULE_PARAM,
 };
-- 
2.33.0

