Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC5A2C11D1;
	Tue, 16 Sep 2025 14:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758034100; cv=none; b=tKq02GNEQ8tVHIJklO8h2rmHQZzdp5zmeFUfiWtTu6JxjjKezVEBSWsz9vPIWU3ErIayhrwdWeA5wF1XuHEJtWUqFuWctTF5+srWIxK9bw22w+BSCkaiQQn+vrJm1K1b4cfZ3Ygnd5pT3R9GVcEbJGYbYiKfDFxsRwBov1FKipE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758034100; c=relaxed/simple;
	bh=XFs81zs95XIBVvri2eZ/XJYmLVRQG8ik0skygWDFaAA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gA5z8WIpuUdud5Yri80eyYopfBDVikv7IU6NSi5ZgLCnOPT9lRgxgz52GYUx0mcPqUOW82Ol4e3rX7xOeYbPruuKXT9bsLiTikAkyDp2g6wOEzOQGxK26SXu52/tWXWyUNTpI7fOCuM0qIi/uWV4cRqh1O4klqvoswh2ig3m/Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cR4R93tNRz13NhQ;
	Tue, 16 Sep 2025 22:44:05 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1A450180485;
	Tue, 16 Sep 2025 22:48:14 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Sep 2025 22:48:13 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Sep 2025 22:48:13 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <shenyang39@huawei.com>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH v2 2/4] uacce: fix isolate sysfs check condition
Date: Tue, 16 Sep 2025 22:48:09 +0800
Message-ID: <20250916144811.1799687-3-huangchenghai2@huawei.com>
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

The uacce supports device isolation feature. If the driver
implements the isolate_err_threshold_read and
isolate_err_threshold_write callbacks, the uacce will create sysfs
files. Users can read and configure isolation policies through
sysfs. Currently, if either isolate_err_threshold_read or
isolate_err_threshold_write callback exists, sysfs files are
created.

However, accessing a non-existent callback may cause a system panic.
Therefore, sysfs files are only created when both
isolate_err_threshold_read and isolate_err_threshold_write are
present.

Fixes: e3e289fbc0b5 ("uacce: supports device isolation feature")
Cc: stable@vger.kernel.org
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 12370469f646..770a931ef68d 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -441,7 +441,7 @@ static umode_t uacce_dev_is_visible(struct kobject *kobj,
 		return 0;
 
 	if (attr == &dev_attr_isolate_strategy.attr &&
-	    (!uacce->ops->isolate_err_threshold_read &&
+	    (!uacce->ops->isolate_err_threshold_read ||
 	     !uacce->ops->isolate_err_threshold_write))
 		return 0;
 
-- 
2.33.0

