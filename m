Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7272F618C;
	Fri, 22 Aug 2025 10:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755859151; cv=none; b=ewZZb9E/PpQl3uhPjZXbF/pIdkfI6P4ARFZ1SXMbuTHRV7BTeRMJHyUZbHWywoXjoJAx2479Bnt6UFHKYcZksTaJTCKodwnPtybyNDujPC0YzFVyuJZYAu3hF+5xmIwgKDSJWbLR8+Re43EmSqEUblKYUs2rD0SlKKmJO9uy8xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755859151; c=relaxed/simple;
	bh=GnK95vZF7a4CQYiNAcMKdQH4omH9tGqgBncXs86DROk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2gXfG3++APzsYh9lpNND6I5EuRZV6BLGAgXNoDHM8xeI627ITNIGJDZef2jTWTd9zmKOuqHSgu/c1YgnzdPXcBZYSZQVc98eaMaJj6oKI+Nh4zXX2IyFCIm/j7KIerk1i8I2UwiyXkcuL7PL2DVbEDcUMbmCpW7RRCMvBGaPbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c7c6h15T6z1R921;
	Fri, 22 Aug 2025 18:36:12 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2BB52140109;
	Fri, 22 Aug 2025 18:39:06 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 18:39:05 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 18:39:05 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<linux-crypto@vger.kernel.org>, <fanghao11@huawei.com>,
	<shenyang39@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<liulongfang@huawei.com>
Subject: [PATCH 1/4] uacce: fix for cdev memory leak
Date: Fri, 22 Aug 2025 18:39:01 +0800
Message-ID: <20250822103904.3776304-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250822103904.3776304-1-huangchenghai2@huawei.com>
References: <20250822103904.3776304-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Wenkai Lin <linwenkai6@hisilicon.com>

If adding uacce cdev to the system fails, it could be due to two
reasons: either the device's devt exists when the failure occurs,
or the device_add operation fails. In the latter case, cdev_del
will be executed, but in the former case, it will not, leading to a
resource leak. Therefore, it is necessary to perform the cdev_del
action during abnormal exit.

Fixes: 015d239ac014 ("uacce: add uacce driver")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 42e7d2a2a90c..3604f722ed60 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -519,6 +519,8 @@ EXPORT_SYMBOL_GPL(uacce_alloc);
  */
 int uacce_register(struct uacce_device *uacce)
 {
+	int ret;
+
 	if (!uacce)
 		return -ENODEV;
 
@@ -529,7 +531,14 @@ int uacce_register(struct uacce_device *uacce)
 	uacce->cdev->ops = &uacce_fops;
 	uacce->cdev->owner = THIS_MODULE;
 
-	return cdev_device_add(uacce->cdev, &uacce->dev);
+	ret = cdev_device_add(uacce->cdev, &uacce->dev);
+	if (ret) {
+		cdev_del(uacce->cdev);
+		uacce->cdev = NULL;
+		return ret;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(uacce_register);
 
-- 
2.33.0

