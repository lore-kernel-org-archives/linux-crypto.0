Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EA72C11D1;
	Tue, 16 Sep 2025 14:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758034104; cv=none; b=coucXooNGebrpJq8+khJX3uahqOA0jzCUIzNqiL+U3GbzQ15APP0VQ6rR0Kgq3iCJbe80dVvEmJzTEv/R+ce8fxl3cNGnrt6IH8sUNXfeuYAM0ePdC/31l+/xH2qd7gQ2PHYW+2DHpl66ZpxDgkR0gYL4vxCT2GO+1RWbWQFkAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758034104; c=relaxed/simple;
	bh=rtkIifI4CZFXQgWdW+YG4CepKxWjk2qQHcliol8lIfE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BMRqaQUMUzPoz5q0FXtNlEnNnmbdP+/vjd2vJrIXN1fNEMjUs7eE0xXwrN5SWDFHGERQ3956jd1uPvo6e+CJkTqZvLMfaezyQg27FJmMwZ95N8fgp2BbizibYg9ooBiK98QqOqObaOjcf7Gi7YBSrCXkKuYB+2cm/zsnGI1/8tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cR4S20WZqz24jBn;
	Tue, 16 Sep 2025 22:44:50 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 7ED5818005F;
	Tue, 16 Sep 2025 22:48:13 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Sep 2025 22:48:13 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Sep 2025 22:48:12 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <shenyang39@huawei.com>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH v2 1/4] uacce: fix for cdev memory leak
Date: Tue, 16 Sep 2025 22:48:08 +0800
Message-ID: <20250916144811.1799687-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250916144811.1799687-1-huangchenghai2@huawei.com>
References: <20250916144811.1799687-1-huangchenghai2@huawei.com>
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

If cdev_device_add failed, it is hard to determine
whether cdev_del has been executed, which lead to a
memory leak issue, so we use cdev_init to avoid it.

Fixes: 015d239ac014 ("uacce: add uacce driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 13 ++++---------
 include/linux/uacce.h      |  2 +-
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 42e7d2a2a90c..12370469f646 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -522,14 +522,10 @@ int uacce_register(struct uacce_device *uacce)
 	if (!uacce)
 		return -ENODEV;
 
-	uacce->cdev = cdev_alloc();
-	if (!uacce->cdev)
-		return -ENOMEM;
-
-	uacce->cdev->ops = &uacce_fops;
-	uacce->cdev->owner = THIS_MODULE;
+	cdev_init(&uacce->cdev, &uacce_fops);
+	uacce->cdev.owner = THIS_MODULE;
 
-	return cdev_device_add(uacce->cdev, &uacce->dev);
+	return cdev_device_add(&uacce->cdev, &uacce->dev);
 }
 EXPORT_SYMBOL_GPL(uacce_register);
 
@@ -568,8 +564,7 @@ void uacce_remove(struct uacce_device *uacce)
 		unmap_mapping_range(q->mapping, 0, 0, 1);
 	}
 
-	if (uacce->cdev)
-		cdev_device_del(uacce->cdev, &uacce->dev);
+	cdev_device_del(&uacce->cdev, &uacce->dev);
 	xa_erase(&uacce_xa, uacce->dev_id);
 	/*
 	 * uacce exists as long as there are open fds, but ops will be freed
diff --git a/include/linux/uacce.h b/include/linux/uacce.h
index e290c0269944..98b896192a44 100644
--- a/include/linux/uacce.h
+++ b/include/linux/uacce.h
@@ -126,7 +126,7 @@ struct uacce_device {
 	bool is_vf;
 	u32 flags;
 	u32 dev_id;
-	struct cdev *cdev;
+	struct cdev cdev;
 	struct device dev;
 	struct mutex mutex;
 	void *priv;
-- 
2.33.0

