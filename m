Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A153009E3;
	Tue,  2 Dec 2025 06:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764655991; cv=none; b=ORjD2pb1RD9KGxLfpZzUq4mD3gSgv8k2Xj8kAy9oq6gsGhVt8RP8gwywR8qYLAxMFdXcfk2lxi0QKvynL6SBgx54nksa+RUj2GDWnEFKpkxFP9aOBcEKgG6fkT1wa/3OQsoNunJSUQVhQkyiP89IXLR1yHP/Gb/LJvvnoeUSMl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764655991; c=relaxed/simple;
	bh=oUvMlSGPUklubX7pMUj2K6ocNCj4Fmrys3oZaGVyZCk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NxJ0tkCwib2mT8sxRB0W4PiJOYQJpgn7Tdats/jn/DN0D/Y88+iBEkHkvrQm6+tDSBghaZOyBEsq752TJ4q4hAjTDJB/6OMw+YhaEr8RwmY9dG0CKhl5ANgK3stv+DluvXguC3Y273gd3XerEe0V3E0OCkUqB/ZmlZsdwBARzd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gJx9SrP1; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gJx9SrP1"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Z7G9BQ0ydyqiKjKK1XkGiJiClH35zTRc/fZlSb5dsLg=;
	b=gJx9SrP17sqywA88CW1kzCAg3wzlNDtsAIKSTFaEUBDHZWNKNYyfHIrQvuhRIK6XFUgsucoQL
	5Wt7dDF8a6zES8x+MbcRdfypw6VqXChIAwNgqdxwUHmLH+cDs4xaqjm+HseYk9xBuLvfth2eerJ
	Vbn3zjzlcetWtnrKUe0XYZM=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dL9PJ3y3MzpSwb;
	Tue,  2 Dec 2025 14:10:44 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 0037C180BD2;
	Tue,  2 Dec 2025 14:13:02 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Dec 2025 14:12:58 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Dec 2025 14:12:57 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
Subject: [PATCH v6 1/4] uacce: fix cdev handling in the cleanup path
Date: Tue, 2 Dec 2025 14:12:53 +0800
Message-ID: <20251202061256.4158641-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251202061256.4158641-1-huangchenghai2@huawei.com>
References: <20251202061256.4158641-1-huangchenghai2@huawei.com>
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

When cdev_device_add fails, it internally releases the cdev memory,
and if cdev_device_del is then executed, it will cause a hang error.
To fix it, we check the return value of cdev_device_add() and clear
uacce->cdev to avoid calling cdev_device_del in the uacce_remove.

Fixes: 015d239ac014 ("uacce: add uacce driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 42e7d2a2a90c..43d215fb8c73 100644
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
+		uacce->cdev = NULL;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(uacce_register);
 
-- 
2.33.0

