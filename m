Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E3925D1FC;
	Thu, 21 Aug 2025 01:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755740301; cv=none; b=kBEn36FRo2cnbC47Sx9leShOxX8EvBoW9+NyxMdI3OGWs+dGdrb7+8TL4eH3SHnLjIN25ySK+o8uxhGGGlfYguaBa1NOXMOefXawumv+r9i4T1z1mKQ4mEL+7PruskLhT5A4LfAxhu1gDmnZuBni6OI5kG2aFHWaPXBp1r1NDs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755740301; c=relaxed/simple;
	bh=SP76kUR2OffvnxNZxJN2KQqKUco78Pwn6aHN6aboaWI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hn2B10Xgo4z72f0Fef2FmzoIh6e0XOkPZDrefIvThDQd5TJh6OQkxG97t/tDJMp1rWButNQt4GiH3CJIRtTa0EjNgQYO9TFrdZT7NlIMT6To5C5U5YYkzK8QxgbpufnCWKXiOaxG4sa/nDAOrG0wFH0/Ok7VtANd9Bs5pMINsVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c6mFd3VVQz27jH3;
	Thu, 21 Aug 2025 09:39:17 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1220F1400CA;
	Thu, 21 Aug 2025 09:38:12 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:38:11 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:38:11 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<yinzhushuai@huawei.com>
Subject: [PATCH v2 4/6] crypto: hisilicon/qm - check whether the input function and PF are on the same device
Date: Thu, 21 Aug 2025 09:38:07 +0800
Message-ID: <20250821013809.4016506-5-huangchenghai2@huawei.com>
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

From: Zhushuai Yin <yinzhushuai@huawei.com>

Function rate limiting is set through physical function driver.
Users configure by providing function information and rate limit values.
Before configuration, it is necessary to check whether the
provided function and PF belong to the same device.

Fixes: 22d7a6c39cab ("crypto: hisilicon/qm - add pci bdf number check")
Signed-off-by: Zhushuai Yin <yinzhushuai@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9bbbfff759a9..408e201a7af2 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3826,6 +3826,10 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 	}
 
 	pdev = container_of(dev, struct pci_dev, dev);
+	if (pci_physfn(pdev) != qm->pdev) {
+		pci_err(qm->pdev, "the pdev input does not match the pf!\n");
+		return -EINVAL;
+	}
 
 	*fun_index = pdev->devfn;
 
-- 
2.33.0

