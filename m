Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2613AF676;
	Thu, 24 Sep 2026 11:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249900; cv=none; b=IRSvguaID9VcjmAR4oA+ngg7cpIcQuBDbvyXBKGQhd1EUp3D0SxRjd0RUnSfONPx4h5LyMa6Non/h47b0yKJl+J3lIZP05tlDbyiXd2kCHlZa0AwzOmNP8Pw6Xtb1DrM8PitmJvH0eheZL+sqlDQRH6Q9rVxZPkAs90YNgTDq/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249900; c=relaxed/simple;
	bh=2NruCBdLSiLMYRtOZ7Z8ixKPyzTctezlt8OCwIYZhLs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OEOtTUEOi3Gm5/4+q2bT83Zpq6BAn0lXuHMcglDgOb72Zwudi0QBkcCuhTb5bhw1a5sUvKDr39Fcnp+rqqVPpx+Q9x+35un77adlZDpxWt//jdbPuP6Zgv30ivw7Irj4k9ohZasvy2UTwbixLRafOmrGJNPxzeVSJC36wIN0m7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=4OR+pURy; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="4OR+pURy"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Hhip5diLg9l9vQeukaU5OvVWbxT9GoP0EQgST9wfSm8=;
	b=4OR+pURyTYYPhc7zxIb4uaNVOAGDelWs0qByWGvXlFrWVvk6CP5VFxSSm9TO3q7XSGCU6Tobo
	YLDSa5t2E/j2/Yz2VqB6eZ7sad1MBWkOUHXvX7dsZnNkmBgKPsEYtIaEgf0YPPuBNfw7RBSb5H/
	yBbr4ZsUJ/64yolCJlEx7UY=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hrBPk4cNxzKm5t;
	Thu, 24 Sep 2026 19:27:06 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 0472940563;
	Thu, 24 Sep 2026 19:38:14 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 19:38:13 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon/qm - clear runtime PM flag for non-power-manageable device
Date: Thu, 24 Sep 2026 19:38:09 +0800
Message-ID: <20260924113812.1110302-2-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924113812.1110302-1-qianweili@huawei.com>
References: <20260924113812.1110302-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200011.china.huawei.com (7.202.181.237)

ACPI_COMPANION() may return NULL on firmware without ACPI support.
Passing it directly to acpi_device_power_manageable() causes a NULL
pointer dereference.

Store the companion in a local variable and check it before use.
When the device is not power manageable, clear QM_SUPPORT_RPM so the
driver skips the suspend/resume path.

Fixes: 3e1d2c52b2045 ("crypto: hisilicon - check _PS0 and _PR0 method")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c01966a4a33f..4f555912f5fc 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3158,6 +3158,7 @@ static int hisi_qp_memory_init(struct hisi_qm *qm, size_t dma_size, int id,
 static void hisi_qm_pre_init(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
+	struct acpi_device *adev;
 
 	if (qm->ver == QM_HW_V1)
 		qm->ops = &qm_hw_ops_v1;
@@ -3173,9 +3174,16 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 	mutex_init(&qm->ifc_lock);
 	init_rwsem(&qm->qps_lock);
 	qm->qp_in_used = 0;
+	/*
+	 * If the device is not power manageable, clear the flag to
+	 * avoid entering the suspend and resume process later.
+	 */
 	if (test_bit(QM_SUPPORT_RPM, &qm->caps)) {
-		if (!acpi_device_power_manageable(ACPI_COMPANION(&pdev->dev)))
-			dev_info(&pdev->dev, "_PS0 and _PR0 are not defined");
+		adev = ACPI_COMPANION(&pdev->dev);
+		if (!adev || !acpi_device_power_manageable(adev)) {
+			dev_warn(&pdev->dev, "device does not support runtime power gating\n");
+			clear_bit(QM_SUPPORT_RPM, &qm->caps);
+		}
 	}
 }
 
-- 
2.43.0

