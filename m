Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE5E4A1C;
	Sat,  1 Jun 2024 02:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717210317; cv=none; b=iwZ+jt+0zTXGjhzFGyFKRExRGZmuiRQzl8je2uEW7ptty1iik6MJnnu7/RwzdFG4COIP3ZEfgMVn/1Gf9qwM4mn4B3MAPxU1YCANXI8k/19+rYKM6TLLja754LOv1L27225v67srH9AHBarrUOBbIAeEiXRz66X7Uv4AmckLUe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717210317; c=relaxed/simple;
	bh=qCChGc9Hj6vxoCjDQSh/2Af2MaIZpzsXnpIbeACkxhc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jl/xDPIkuOObQBplGN6nrRNLcr/+kF/wF6jyOCPntw4Iok4r3gn7zGwnxaoRdsT0lgN65I3DVkEUdFXhRNGPph7dn/YW7m0hz0qaB/B8tQQ7OMCH7OhY7x6aGRmMPn38WLz7keGbwdiaNuIziBoyjH8jzIwvFXpsOZQGKePOd5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Vrktm6Zx1zwQW7;
	Sat,  1 Jun 2024 10:48:00 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id D6A4918006C;
	Sat,  1 Jun 2024 10:51:51 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 1 Jun 2024 10:51:51 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<shenyang39@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH V3 1/2] crypto: hisilicon/qm - adjust the internal processing sequence of the vf enable and disable
Date: Sat, 1 Jun 2024 10:51:49 +0800
Message-ID: <20240601025150.1660826-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240601025150.1660826-1-huangchenghai2@huawei.com>
References: <20240601025150.1660826-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500025.china.huawei.com (7.221.188.170)

When the vf is enabled, the value of vfs_num must be assigned
after the VF configuration is complete. Otherwise, the device
may be accessed before the virtual configuration is complete,
causing an error.

When the vf is disabled, clear vfs_num and execute
qm_pm_put_sync before hisi_qm_sriov_disable is return.
Otherwise, if qm_clear_vft_config fails, users may access the
device when the PCI virtualization is disabled, resulting in an
error.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 3dac8d8e8568..f614fd228b56 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3793,14 +3793,13 @@ int hisi_qm_sriov_enable(struct pci_dev *pdev, int max_vfs)
 		goto err_put_sync;
 	}
 
-	qm->vfs_num = num_vfs;
-
 	ret = pci_enable_sriov(pdev, num_vfs);
 	if (ret) {
 		pci_err(pdev, "Can't enable VF!\n");
 		qm_clear_vft_config(qm);
 		goto err_put_sync;
 	}
+	qm->vfs_num = num_vfs;
 
 	pci_info(pdev, "VF enabled, vfs_num(=%d)!\n", num_vfs);
 
@@ -3822,7 +3821,6 @@ EXPORT_SYMBOL_GPL(hisi_qm_sriov_enable);
 int hisi_qm_sriov_disable(struct pci_dev *pdev, bool is_frozen)
 {
 	struct hisi_qm *qm = pci_get_drvdata(pdev);
-	int ret;
 
 	if (pci_vfs_assigned(pdev)) {
 		pci_err(pdev, "Failed to disable VFs as VFs are assigned!\n");
@@ -3837,13 +3835,10 @@ int hisi_qm_sriov_disable(struct pci_dev *pdev, bool is_frozen)
 
 	pci_disable_sriov(pdev);
 
-	ret = qm_clear_vft_config(qm);
-	if (ret)
-		return ret;
-
+	qm->vfs_num = 0;
 	qm_pm_put_sync(qm);
 
-	return 0;
+	return qm_clear_vft_config(qm);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_sriov_disable);
 
-- 
2.33.0

