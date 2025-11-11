Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFF12ED15D;
	Tue, 11 Nov 2025 09:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762853744; cv=none; b=tLT0THDMntl1bAXUtko7ALFej2OMMLHWibxmxop1minURcjYe+m8/kA6WNvz9+frr2KrXVK+c9DCiD0j7caQ+fzmUmhSLUE3DZsbuStJQs+YQ1YnpDmKp6gvN//ryrY2moQoAmpIgA1wmMT4x1Z6uXHnH1fx7viP9e1OVMczcBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762853744; c=relaxed/simple;
	bh=Z4cdmi4kqXnOSwXLCyG4Itbs8FaoacnhcbELdkxwR+Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qwiELMbQwmvTb2a1j1XAlt7NZCau2tZQolx6KAbjdjXtq0OuJTp/SVOS7K6itMNF8gU/nFEtKWu2Ac1b8DTuxOaXlXiSGamJDMELT0d/LeK0MdMD39ecvt4PCQRRpdfP7qJh8KPIpZ2qLfDPoFjFf8S9oM6J1u3lI3IP6nAKR98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=6vRXkGiH; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="6vRXkGiH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0gCgDTkG6bOBOK3D/rcqLaUz6n4lIGyHqyyujkY3roI=;
	b=6vRXkGiHJEykuaL1kGCAdKOhDcf874Elw9SoKoSahBdMLXzsVJoJyMWJcRW9b+sY8MJtnybbg
	rz9x8g0j0wWmWF0ioKyhA/R3MqGWpXsfrkgB3wdkM5vGwRlbwNsxIrxr8/YOnLAfJFr2iFWloCi
	3eyzmDbyq7MnpHKPnH6A/6o=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d5Lvf2VRNznTZF;
	Tue, 11 Nov 2025 17:34:06 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 602FE140158;
	Tue, 11 Nov 2025 17:35:38 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 17:35:38 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 17:35:37 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
Subject: [PATCH v5 1/4] uacce: fix cdev handling in register and remove paths
Date: Tue, 11 Nov 2025 17:35:33 +0800
Message-ID: <20251111093536.3729-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251111093536.3729-1-huangchenghai2@huawei.com>
References: <20251111093536.3729-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Wenkai Lin <linwenkai6@hisilicon.com>

This patch addresses a potential issue in the uacce driver where the
cdev was not properly managed during error handling and cleanup paths.

Changes made:
1. In uacce_register(), store the return value of cdev_device_add()
   and clear the cdev owner as a flag if registration fails.
2. In uacce_remove(), add additional check for cdev owner before
   calling cdev_device_del() to prevent potential issues.

Fixes: 015d239ac014 ("uacce: add uacce driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 42e7d2a2a90c..688050c35d88 100644
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
 
@@ -529,7 +531,11 @@ int uacce_register(struct uacce_device *uacce)
 	uacce->cdev->ops = &uacce_fops;
 	uacce->cdev->owner = THIS_MODULE;
 
-	return cdev_device_add(uacce->cdev, &uacce->dev);
+	ret = cdev_device_add(uacce->cdev, &uacce->dev);
+	if (ret)
+		uacce->cdev->owner = NULL;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(uacce_register);
 
@@ -568,7 +574,7 @@ void uacce_remove(struct uacce_device *uacce)
 		unmap_mapping_range(q->mapping, 0, 0, 1);
 	}
 
-	if (uacce->cdev)
+	if (uacce->cdev && uacce->cdev->owner)
 		cdev_device_del(uacce->cdev, &uacce->dev);
 	xa_erase(&uacce_xa, uacce->dev_id);
 	/*
-- 
2.33.0

