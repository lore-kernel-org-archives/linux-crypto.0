Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B50A275AF3;
	Sat, 30 Aug 2025 10:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756549685; cv=none; b=DIUVQnUMYErOljEKMbuNGaMGes72KKBQ2BJZOiSYJCkMauGkMcVLhE5SQc+kdQTdyRFGucg43W7la8KTDpvMCGlQYMqNy6mA0B/ox3baKCG61fjDF6viXbM9GxC4GrqdrZwCV3L+kQoeLBzFUK2bpIwS7XEB2VGskSstIlFTliA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756549685; c=relaxed/simple;
	bh=xuIDIwuegktRozY/5uGtgDMtY4MWHUX+r4VT8S6nets=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oj69ozosnWXkrpstlcJJH7Wv4MIF35F0E3s0U9oODwSi+z+U0ARC904WiTIBjjwKHCXrl+jxewQ2rtZ8MgXvomJvzNN0hZWCG7uSHhzERbmrUsHWGMxuQeEKvtbCnB2tifEwWFu0Ys8ShqrqqDutVkuRBmHtMwDTs1+zdauj4Sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cDWV62rrPz1R8xF;
	Sat, 30 Aug 2025 18:25:02 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 03A441A0188;
	Sat, 30 Aug 2025 18:28:00 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Aug 2025 18:27:59 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Aug 2025 18:27:59 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<yinzhushuai@huawei.com>
Subject: [PATCH 2/2] crypto: hisilicon/zip - add hashjoin, gather, and UDMA data move features
Date: Sat, 30 Aug 2025 18:27:57 +0800
Message-ID: <20250830102757.1498691-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250830102757.1498691-1-huangchenghai2@huawei.com>
References: <20250830102757.1498691-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Zhushuai Yin <yinzhushuai@huawei.com>

The new version of the hisilicon zip driver supports the hash join
and gather features, as well as the data move feature (UDMA),
including data copying and memory initialization functions.These
features are registered to the uacce subsystem.

Signed-off-by: Zhushuai Yin <yinzhushuai@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c           | 29 +++++++++++++++++++------
 drivers/crypto/hisilicon/zip/dae_main.c | 11 ++++++++--
 include/linux/hisi_acc_qm.h             |  1 +
 include/uapi/misc/uacce/hisi_qm.h       |  1 +
 4 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 102aff9ea19a..98099117bb38 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2742,6 +2742,27 @@ static void qm_remove_uacce(struct hisi_qm *qm)
 	}
 }
 
+static void qm_uacce_api_ver_init(struct hisi_qm *qm)
+{
+	struct uacce_device *uacce = qm->uacce;
+
+	switch (qm->ver) {
+	case QM_HW_V1:
+		uacce->api_ver = HISI_QM_API_VER_BASE;
+		break;
+	case QM_HW_V2:
+		uacce->api_ver = HISI_QM_API_VER2_BASE;
+		break;
+	case QM_HW_V3:
+	case QM_HW_V4:
+		uacce->api_ver = HISI_QM_API_VER3_BASE;
+		break;
+	default:
+		uacce->api_ver = HISI_QM_API_VER5_BASE;
+		break;
+	}
+}
+
 static int qm_alloc_uacce(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -2775,13 +2796,6 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	uacce->is_vf = pdev->is_virtfn;
 	uacce->priv = qm;
 
-	if (qm->ver == QM_HW_V1)
-		uacce->api_ver = HISI_QM_API_VER_BASE;
-	else if (qm->ver == QM_HW_V2)
-		uacce->api_ver = HISI_QM_API_VER2_BASE;
-	else
-		uacce->api_ver = HISI_QM_API_VER3_BASE;
-
 	if (qm->ver == QM_HW_V1)
 		mmio_page_nr = QM_DOORBELL_PAGE_NR;
 	else if (!test_bit(QM_SUPPORT_DB_ISOLATION, &qm->caps))
@@ -2801,6 +2815,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	uacce->qf_pg_num[UACCE_QFRT_DUS]  = dus_page_nr;
 
 	qm->uacce = uacce;
+	qm_uacce_api_ver_init(qm);
 	INIT_LIST_HEAD(&qm->isolate_data.qm_hw_errs);
 	mutex_init(&qm->isolate_data.isolate_lock);
 
diff --git a/drivers/crypto/hisilicon/zip/dae_main.c b/drivers/crypto/hisilicon/zip/dae_main.c
index 6f22e4c36e49..4c5481c77436 100644
--- a/drivers/crypto/hisilicon/zip/dae_main.c
+++ b/drivers/crypto/hisilicon/zip/dae_main.c
@@ -15,6 +15,7 @@
 #define DAE_REG_RD_TMOUT_US		USEC_PER_SEC
 
 #define DAE_ALG_NAME			"hashagg"
+#define DAE_V5_ALG_NAME			"hashagg\nudma\nhashjoin\ngather"
 
 /* error */
 #define DAE_AXI_CFG_OFFSET		0x331000
@@ -82,6 +83,7 @@ int hisi_dae_set_user_domain(struct hisi_qm *qm)
 
 int hisi_dae_set_alg(struct hisi_qm *qm)
 {
+	const char *alg_name;
 	size_t len;
 
 	if (!dae_is_support(qm))
@@ -90,9 +92,14 @@ int hisi_dae_set_alg(struct hisi_qm *qm)
 	if (!qm->uacce)
 		return 0;
 
+	if (qm->ver >= QM_HW_V5)
+		alg_name = DAE_V5_ALG_NAME;
+	else
+		alg_name = DAE_ALG_NAME;
+
 	len = strlen(qm->uacce->algs);
 	/* A line break may be required */
-	if (len + strlen(DAE_ALG_NAME) + 1 >= QM_DEV_ALG_MAX_LEN) {
+	if (len + strlen(alg_name) + 1 >= QM_DEV_ALG_MAX_LEN) {
 		pci_err(qm->pdev, "algorithm name is too long!\n");
 		return -EINVAL;
 	}
@@ -100,7 +107,7 @@ int hisi_dae_set_alg(struct hisi_qm *qm)
 	if (len)
 		strcat((char *)qm->uacce->algs, "\n");
 
-	strcat((char *)qm->uacce->algs, DAE_ALG_NAME);
+	strcat((char *)qm->uacce->algs, alg_name);
 
 	return 0;
 }
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 0c4c84b8c3be..f2254ddc327c 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -125,6 +125,7 @@ enum qm_hw_ver {
 	QM_HW_V2 = 0x21,
 	QM_HW_V3 = 0x30,
 	QM_HW_V4 = 0x50,
+	QM_HW_V5 = 0x51,
 };
 
 enum qm_fun_type {
diff --git a/include/uapi/misc/uacce/hisi_qm.h b/include/uapi/misc/uacce/hisi_qm.h
index 3e66dbc2f323..10504b48eabf 100644
--- a/include/uapi/misc/uacce/hisi_qm.h
+++ b/include/uapi/misc/uacce/hisi_qm.h
@@ -31,6 +31,7 @@ struct hisi_qp_info {
 #define HISI_QM_API_VER_BASE "hisi_qm_v1"
 #define HISI_QM_API_VER2_BASE "hisi_qm_v2"
 #define HISI_QM_API_VER3_BASE "hisi_qm_v3"
+#define HISI_QM_API_VER5_BASE "hisi_qm_v5"
 
 /* UACCE_CMD_QM_SET_QP_CTX: Set qp algorithm type */
 #define UACCE_CMD_QM_SET_QP_CTX	_IOWR('H', 10, struct hisi_qp_ctx)
-- 
2.33.0

