Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C043415B88;
	Thu, 24 Sep 2026 11:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249900; cv=none; b=ZeytNnKlnyEuGeR4ZgVfOUn82fPBmipt33I6i5v24z1ZE0iWb7RfXMBU1GxjhcmOrZ2E1FN6zOX48OksAtXcBZ5nVYAIxG6ixBHs0dlYZ5ZxyliKy+j7HKPFTTI16kmLj79alTNc1NucIQjjYlo5mxZlJLIXrJ4V8lEqzhctKsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249900; c=relaxed/simple;
	bh=N8ap0xr/zmehy0mMQ7ts3+iF442hdkDZdK2WO6aVITQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nOhEz9iCZWs1YK6nzznKcor3/KxDki06BK1/Hl/gn6QCb9K/c0wAB0QYjBca1lb6QgLRmB1WxJwkjP7Ea6I1IaPQCgyyWFdPI5ttceoHIqFgL0wltquMVMshReEqY1icYbB864KtvY0tvccE9Cl7kLPZPHDTCLeef11u+IXV18E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=b59uugO/; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="b59uugO/"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lZ9l64oKWaafqOM3qt6hfhpO2gt1l1j4oVbYFzP4PP8=;
	b=b59uugO/0YT/3PcHaTESXp0xO/rbpuwK2gUhPkegzbKcnDJjDhPCqNCensIiM5ofK4+uSep5u
	3RAf/h/QlxSZ86GFldnFDjDT6ntrLetbT0mCF9CPvgm3t1Z8imZGxc9njFM7UMeIqrjCcSTSyk/
	34BgXwX6MBvAdoiXb8ZkKYA=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hrBNc0NG5z1K97G;
	Thu, 24 Sep 2026 19:26:08 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 43DA24056C;
	Thu, 24 Sep 2026 19:38:14 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 19:38:13 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon/qm - return error for abnormal device capability version
Date: Thu, 24 Sep 2026 19:38:10 +0800
Message-ID: <20260924113812.1110302-3-qianweili@huawei.com>
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

When the device is abnormal, QM_FUNC_CAPS_REG returns 0xffffffff and
cap_ver becomes 0xff, but the driver continues with an invalid version.

Read the register unconditionally and return -EIO when cap_ver equals
QM_CAPBILITY_VERSION, indicating an abnormal device.

Fixes: 82f00b24f532 ("crypto: hisilicon/qm - get hardware features from hardware registers")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 4f555912f5fc..bde44401ddb6 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5770,9 +5770,19 @@ static int qm_get_hw_caps(struct hisi_qm *qm)
 	if (val)
 		set_bit(QM_SUPPORT_DB_ISOLATION, &qm->caps);
 
-	if (qm->ver >= QM_HW_V3) {
-		val = readl(qm->io_base + QM_FUNC_CAPS_REG);
-		qm->cap_ver = val & QM_CAPBILITY_VERSION;
+	/*
+	 * Read capability version from hardware register unconditionally.
+	 * For V1/V2 hardware, this register is not implemented and returns 0
+	 * in normal condition, but returns 0xffffffff when the device is
+	 * abnormal, same as V3+ abnormal devices.
+	 * When cap_ver equals QM_CAPBILITY_VERSION (0xff), the device is
+	 * abnormal and probe should fail early.
+	 */
+	val = readl(qm->io_base + QM_FUNC_CAPS_REG);
+	qm->cap_ver = val & QM_CAPBILITY_VERSION;
+	if (qm->cap_ver == QM_CAPBILITY_VERSION) {
+		dev_err(&qm->pdev->dev, "abnormal device detected\n");
+		return -EIO;
 	}
 
 	/* Get PF/VF common capbility */
-- 
2.43.0

