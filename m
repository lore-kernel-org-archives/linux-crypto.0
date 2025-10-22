Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B778D2222B4;
	Wed, 22 Oct 2025 02:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761099151; cv=none; b=MsUZACElxLa8hOtmA3eiQT0zlNZmJ5mDhTZhzmOLtEdnO/s8194nNM/7oeIC2YTy9wAxoS/NFzg04Il4cj2BeXcDWRBFbGMWcwO+Or8bmlUHKaYldC8LI5f+RiN2DVnDJj2+SPq5ClSMsD/yw44Ye4Nlg3FDe1LllL6ny8cc5ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761099151; c=relaxed/simple;
	bh=hWOCC4M64E0HCR/i6BczLCQ0ErSkLekK7uU4+1bkmLY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jEAdvJAxd9xBYsjyVGgszyvNzoklBnOVTykdCAWBOLbjpLROsn1/SJXDC0ycMSdzk8X5L8UAvCW2GxXyIwObFCa2mEZZ8EQlEeae/9hz9yrTbrfRsTHjgfElCJuOgWCkBBtQr3L4dKW3vthZD84EvghOyhvsqKHAWj6SZ9tLgbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=nIXvyfJw; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="nIXvyfJw"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=INfemayc9W6N5hQfUFOB1hQsvy36xI//nAITyW85/tg=;
	b=nIXvyfJw02GH8R1cDzyx8SVSmIptk34q6zANKqwuyXbBIGripLSf/Uz8c8xpcf+AmbJ8e7tDt
	qXCcsBiIKSay/6lOKXJN/pLOT1tNlnKfqR9yleYWb00GZ6WMCQlq/CDgCMKqUNN+f2GRvk5SXAP
	rQaAkRllh3eyU10Fhxue+Co=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4crt2N4j0DznTW3;
	Wed, 22 Oct 2025 10:11:40 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 01D391A0194;
	Wed, 22 Oct 2025 10:12:22 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 10:11:51 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 10:11:50 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
Subject: [PATCH v4 1/4] uacce: fix for cdev memory leak
Date: Wed, 22 Oct 2025 10:11:46 +0800
Message-ID: <20251022021149.1771168-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251022021149.1771168-1-huangchenghai2@huawei.com>
References: <20251022021149.1771168-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Wenkai Lin <linwenkai6@hisilicon.com>

In uacce_register(), if cdev_device_add() fails, we should properly
decrease the reference count of the cdev kobject and set uacce->cdev
to NULL to avoid potential use-after-free or double free issues.

This change adds proper error handling after cdev_device_add() fails,
ensuring that kobject_put() is called and uacce->cdev is cleared.

Fixes: 015d239ac014 ("uacce: add uacce driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 42e7d2a2a90c..9b82a6731832 100644
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
+		kobject_put(&uacce->cdev->kobj);
+		uacce->cdev = NULL;
+		return ret;
+	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(uacce_register);
 
-- 
2.33.0

