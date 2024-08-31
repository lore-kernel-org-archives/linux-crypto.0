Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905EE17C7C1;
	Sat, 31 Aug 2024 11:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725105143; cv=none; b=D4/b7M1oT7CcvtH504ZBQM6nLimu//ZjJxAds1HvTY9KxJDM0JTuhcUsuMfTORVqVCuKWNFnQZtYGHS007Y0HT2Xzfva9opWfAF1zh7wTHgNfKy29/s0Pu2fpxwpiihJHg00Ca1zxz1bp+T233zAIx2HI/jdMcmxSS4NhrK6S9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725105143; c=relaxed/simple;
	bh=O2FB3Q74UJTbxFVdwTJnIyMlNKqkAWY7pe+sL6bH2Aw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wciap9o6XA584B2IPirWcut3v6whIBKH6bIrt12ZTmwCTzRRkKjtLQj6JXn2fhYSsCUW7EMovubyxU4LpraJro2MB92AxhypTgCSKaJPY8u7E7ff4IW4kGFpz7OOYjPlffIPknlfwBQX+/IAybsPZf4HguCb7oJbUVEmFHwzpMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wwtck4KhPzpV3Y;
	Sat, 31 Aug 2024 19:50:30 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 3ED2B18006C;
	Sat, 31 Aug 2024 19:52:17 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 31 Aug 2024 19:52:16 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH 3/3] crypto: hisilicon/qm - inject error before stopping queue
Date: Sat, 31 Aug 2024 19:48:31 +0800
Message-ID: <20240831114831.21987-4-qianweili@huawei.com>
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

The master ooo cannot be completely closed when the
accelerator core reports memory error. Therefore, the driver
needs to inject the qm error to close the master ooo. Currently,
the qm error is injected after stopping queue, memory may be
released immediately after stopping queue, causing the device to
access the released memory. Therefore, error is injected to close master
ooo before stopping queue to ensure that the device does not access
the released memory.

Fixes: 6c6dd5802c2d ("crypto: hisilicon/qm - add controller reset interface")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 47 ++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b2b5f15abdf7..07983af9e3e2 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4015,6 +4015,28 @@ static int qm_set_vf_mse(struct hisi_qm *qm, bool set)
 	return -ETIMEDOUT;
 }
 
+static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
+{
+	u32 nfe_enb = 0;
+
+	/* Kunpeng930 hardware automatically close master ooo when NFE occurs */
+	if (qm->ver >= QM_HW_V3)
+		return;
+
+	if (!qm->err_status.is_dev_ecc_mbit &&
+	    qm->err_status.is_qm_ecc_mbit &&
+	    qm->err_ini->close_axi_master_ooo) {
+		qm->err_ini->close_axi_master_ooo(qm);
+	} else if (qm->err_status.is_dev_ecc_mbit &&
+		   !qm->err_status.is_qm_ecc_mbit &&
+		   !qm->err_ini->close_axi_master_ooo) {
+		nfe_enb = readl(qm->io_base + QM_RAS_NFE_ENABLE);
+		writel(nfe_enb & QM_RAS_NFE_MBIT_DISABLE,
+		       qm->io_base + QM_RAS_NFE_ENABLE);
+		writel(QM_ECC_MBIT, qm->io_base + QM_ABNORMAL_INT_SET);
+	}
+}
+
 static int qm_vf_reset_prepare(struct hisi_qm *qm,
 			       enum qm_stop_reason stop_reason)
 {
@@ -4079,6 +4101,8 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 		return ret;
 	}
 
+	qm_dev_ecc_mbit_handle(qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	qm_cmd_uninit(qm);
 
@@ -4125,28 +4149,6 @@ static int qm_master_ooo_check(struct hisi_qm *qm)
 	return ret;
 }
 
-static void qm_dev_ecc_mbit_handle(struct hisi_qm *qm)
-{
-	u32 nfe_enb = 0;
-
-	/* Kunpeng930 hardware automatically close master ooo when NFE occurs */
-	if (qm->ver >= QM_HW_V3)
-		return;
-
-	if (!qm->err_status.is_dev_ecc_mbit &&
-	    qm->err_status.is_qm_ecc_mbit &&
-	    qm->err_ini->close_axi_master_ooo) {
-		qm->err_ini->close_axi_master_ooo(qm);
-	} else if (qm->err_status.is_dev_ecc_mbit &&
-		   !qm->err_status.is_qm_ecc_mbit &&
-		   !qm->err_ini->close_axi_master_ooo) {
-		nfe_enb = readl(qm->io_base + QM_RAS_NFE_ENABLE);
-		writel(nfe_enb & QM_RAS_NFE_MBIT_DISABLE,
-		       qm->io_base + QM_RAS_NFE_ENABLE);
-		writel(QM_ECC_MBIT, qm->io_base + QM_ABNORMAL_INT_SET);
-	}
-}
-
 static int qm_soft_reset_prepare(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -4171,7 +4173,6 @@ static int qm_soft_reset_prepare(struct hisi_qm *qm)
 		return ret;
 	}
 
-	qm_dev_ecc_mbit_handle(qm);
 	ret = qm_master_ooo_check(qm);
 	if (ret)
 		return ret;
-- 
2.33.0

