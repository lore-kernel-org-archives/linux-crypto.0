Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64EA2EC54D;
	Sat, 13 Sep 2025 10:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757761082; cv=none; b=dMaHN/TFwko4h2iDK5TXpp3AxLQ/7YjvBOGuat2fkUpW4CEA7dKGurhgghc9USayIOyaB1HC9rz7h+2EBK3+5+pSQyJtUvi4tQDC1hl0mpBFTRXecIGzbEXQqYNoITL8mNHxgvIXEDnlcz9JWvtl4vAGCM8KRQIuWH8r6rxSFOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757761082; c=relaxed/simple;
	bh=cBrRkrLOprRgl4NO7olFm1/41uXD8pUTyvxgNXSdZ3s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEgJbnB1syOenR35brLpYahTyVn0TJ11u0j9b5nFtr+HlJLbWSST0cFUExktPibA/CJ4H3peoKxHSXQ4zs4g1dj4AUer31pWTWB5Scch4BIcO+/d03nKUbEvCOkn9iPE1QS0wXC/1BwnZP2S7RS7GGEiZ6J56hq2RXTta3uZ+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cP7Tp1cLqz2VRfD;
	Sat, 13 Sep 2025 18:54:38 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0FCC71A016C;
	Sat, 13 Sep 2025 18:57:58 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:57 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:57 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 4/5] crypto: hisilicon/qm - clear all VF configurations in the hardware
Date: Sat, 13 Sep 2025 18:57:53 +0800
Message-ID: <20250913105754.3862444-5-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250913105754.3862444-1-huangchenghai2@huawei.com>
References: <20250913105754.3862444-1-huangchenghai2@huawei.com>
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

From: Weili Qian <qianweili@huawei.com>

When disabling SR-IOV, clear the configuration of each VF
in the hardware. Do not exit the configuration clearing process
due to the failure of a single VF. Additionally, Clear the VF
configurations before decrementing the PM counter.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 32dd755e1867..1721528d7c68 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3645,19 +3645,19 @@ static int qm_vf_q_assign(struct hisi_qm *qm, u32 num_vfs)
 	return 0;
 }
 
-static int qm_clear_vft_config(struct hisi_qm *qm)
+static void qm_clear_vft_config(struct hisi_qm *qm)
 {
-	int ret;
 	u32 i;
 
-	for (i = 1; i <= qm->vfs_num; i++) {
-		ret = hisi_qm_set_vft(qm, i, 0, 0);
-		if (ret)
-			return ret;
-	}
-	qm->vfs_num = 0;
+	/*
+	 * When disabling SR-IOV, clear the configuration of each VF in the hardware
+	 * sequentially. Failure to clear a single VF should not affect the clearing
+	 * operation of other VFs.
+	 */
+	for (i = 1; i <= qm->vfs_num; i++)
+		(void)hisi_qm_set_vft(qm, i, 0, 0);
 
-	return 0;
+	qm->vfs_num = 0;
 }
 
 static int qm_func_shaper_enable(struct hisi_qm *qm, u32 fun_index, u32 qos)
@@ -3992,13 +3992,13 @@ int hisi_qm_sriov_enable(struct pci_dev *pdev, int max_vfs)
 		goto err_put_sync;
 	}
 
+	qm->vfs_num = num_vfs;
 	ret = pci_enable_sriov(pdev, num_vfs);
 	if (ret) {
 		pci_err(pdev, "Can't enable VF!\n");
 		qm_clear_vft_config(qm);
 		goto err_put_sync;
 	}
-	qm->vfs_num = num_vfs;
 
 	pci_info(pdev, "VF enabled, vfs_num(=%d)!\n", num_vfs);
 
@@ -4033,11 +4033,10 @@ int hisi_qm_sriov_disable(struct pci_dev *pdev, bool is_frozen)
 	}
 
 	pci_disable_sriov(pdev);
-
-	qm->vfs_num = 0;
+	qm_clear_vft_config(qm);
 	qm_pm_put_sync(qm);
 
-	return qm_clear_vft_config(qm);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(hisi_qm_sriov_disable);
 
-- 
2.43.0

