Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E1F15FD16;
	Sun, 29 Sep 2024 11:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727609223; cv=none; b=sjs+WNCbXTOnqlLhOUDzK9aAjIEaS77gmSp9VcuPh3cmtqyGi9jZtm3K8oiHE+NgyV0MhK2CjmHiFsfLSYlHMN0/uQH6ivr7J9Iv6Qr+TKLWBo/8wEgyI9ojUcqtQwNCvLK8Fy7Wb76iWKF61hhUB4HcfLOCGN/MUNmo3/MP2sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727609223; c=relaxed/simple;
	bh=2Z67kmiPpPiX4NPICSN6yxyqvDTL5rZxLnvaFETOx74=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=boZslonJ13pEcggGIz7Ge7i9U8v5QXML/FMoga0m3v25EBeQ7wE22doq88++O97Dj09B7ersBC4p6g88Eh+LHUSdZbjw+S4nVi1hD2IIfGkZsKrDpJoOAg06FjXYvI+De37FMD+nJPfxSiYxyWwpiDB0LaQPYf7uiRJEBeKOX+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XGhdh1wHpz1HKJV;
	Sun, 29 Sep 2024 19:23:04 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 278241A0188;
	Sun, 29 Sep 2024 19:26:59 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 29 Sep 2024 19:26:58 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<huangchenghai2@huawei.com>
Subject: [PATCH] crypto: hisilicon/qm - fix the coding specifications issue
Date: Sun, 29 Sep 2024 19:26:57 +0800
Message-ID: <20240929112657.863594-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd200024.china.huawei.com (7.221.188.85)

Ensure that the inline function contains no more than 10 lines.
move q_num_set() from hisi_acc_qm.h to qm.c.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  2 +-
 drivers/crypto/hisilicon/qm.c             | 31 +++++++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_main.c  |  2 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |  2 +-
 include/linux/hisi_acc_qm.h               | 33 ++---------------------
 5 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 6b536ad2ada5..365690e48d4d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -415,7 +415,7 @@ static int pf_q_num_set(const char *val, const struct kernel_param *kp)
 {
 	pf_q_num_flag = true;
 
-	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_HPRE_PF);
+	return hisi_qm_q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_HPRE_PF);
 }
 
 static const struct kernel_param_ops hpre_pf_q_num_ops = {
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 07983af9e3e2..f7e8237e3a93 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -451,6 +451,37 @@ static struct qm_typical_qos_table shaper_cbs_s[] = {
 
 static void qm_irqs_unregister(struct hisi_qm *qm);
 static int qm_reset_device(struct hisi_qm *qm);
+int hisi_qm_q_num_set(const char *val, const struct kernel_param *kp,
+		      unsigned int device)
+{
+	struct pci_dev *pdev;
+	u32 n, q_num;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+
+	pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI, device, NULL);
+	if (!pdev) {
+		q_num = min_t(u32, QM_QNUM_V1, QM_QNUM_V2);
+		pr_info("No device found currently, suppose queue number is %u\n",
+			q_num);
+	} else {
+		if (pdev->revision == QM_HW_V1)
+			q_num = QM_QNUM_V1;
+		else
+			q_num = QM_QNUM_V2;
+
+		pci_dev_put(pdev);
+	}
+
+	ret = kstrtou32(val, 10, &n);
+	if (ret || n < QM_MIN_QNUM || n > q_num)
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_q_num_set);
 
 static u32 qm_get_hw_error_status(struct hisi_qm *qm)
 {
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index c35533d8930b..3abd12017250 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -322,7 +322,7 @@ static int sec_pf_q_num_set(const char *val, const struct kernel_param *kp)
 {
 	pf_q_num_flag = true;
 
-	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_SEC_PF);
+	return hisi_qm_q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_SEC_PF);
 }
 
 static const struct kernel_param_ops sec_pf_q_num_ops = {
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index d07e47b48be0..f547e6732bf5 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -402,7 +402,7 @@ static int pf_q_num_set(const char *val, const struct kernel_param *kp)
 {
 	pf_q_num_flag = true;
 
-	return q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_ZIP_PF);
+	return hisi_qm_q_num_set(val, kp, PCI_DEVICE_ID_HUAWEI_ZIP_PF);
 }
 
 static const struct kernel_param_ops pf_q_num_ops = {
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 9d7754ad5e9b..389e95754776 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -436,37 +436,6 @@ struct hisi_qp {
 	struct uacce_queue *uacce_q;
 };
 
-static inline int q_num_set(const char *val, const struct kernel_param *kp,
-			    unsigned int device)
-{
-	struct pci_dev *pdev;
-	u32 n, q_num;
-	int ret;
-
-	if (!val)
-		return -EINVAL;
-
-	pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI, device, NULL);
-	if (!pdev) {
-		q_num = min_t(u32, QM_QNUM_V1, QM_QNUM_V2);
-		pr_info("No device found currently, suppose queue number is %u\n",
-			q_num);
-	} else {
-		if (pdev->revision == QM_HW_V1)
-			q_num = QM_QNUM_V1;
-		else
-			q_num = QM_QNUM_V2;
-
-		pci_dev_put(pdev);
-	}
-
-	ret = kstrtou32(val, 10, &n);
-	if (ret || n < QM_MIN_QNUM || n > q_num)
-		return -EINVAL;
-
-	return param_set_int(val, kp);
-}
-
 static inline int vfs_num_set(const char *val, const struct kernel_param *kp)
 {
 	u32 n;
@@ -526,6 +495,8 @@ static inline void hisi_qm_del_list(struct hisi_qm *qm, struct hisi_qm_list *qm_
 	mutex_unlock(&qm_list->lock);
 }
 
+int hisi_qm_q_num_set(const char *val, const struct kernel_param *kp,
+		      unsigned int device);
 int hisi_qm_init(struct hisi_qm *qm);
 void hisi_qm_uninit(struct hisi_qm *qm);
 int hisi_qm_start(struct hisi_qm *qm);
-- 
2.33.0

