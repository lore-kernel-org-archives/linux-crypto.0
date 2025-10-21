Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66372F5492;
	Tue, 21 Oct 2025 13:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761054613; cv=none; b=IhpAPEGEd+xGs2dE5OJVbTpeo1IwdCV6II1i/ooghL0WF+kzAQT+0YFtA29+6U9MDCMb91GLelVWzGenIvXGrwhbZ9TjtQ8D9ieaWSLxq/IiM3YoXPHOBB8XYHmaI6iTHyT5nl7VbSSyAWzLRiP+twLbXMVjEYrqeiH+w+bnR6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761054613; c=relaxed/simple;
	bh=VaYpFyaLOvGJOgM1vGoEzCAZvxW9y3Xe31bRCCfJa60=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sSTO+C+8W+IdZk7bIi4t0VgC3bwJ4C191zF2msTuXrdzRJEhMWv34SKmhuF54JxdJhpvQSpNtfKkTJ8L0UhkezMOx2lZeBTbnqXDherT7gm6XvP8j27ereJ6+qoR3T+6tOgVlu4GRRuVd241QSdPgBJHsf9wwDsW446K+6JB0J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=nepGEfMD; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="nepGEfMD"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EyniE1B+gWYxyFjKYyOEA4mBgWoHm7pSVUPuBcV8c10=;
	b=nepGEfMDnGNP37rJD8TamMPrt1J9kAbrgF/GGUEr8Q1muWCntlOZlEwJFWSWOYkqaGApl/SZ5
	szg3zG7JSDrwBtelKwYl+bC8O7N8kktg8d4WqjFquSBuDuVKM/1/YA60qCU/pX+fhxb97kFYPxw
	WDgdP75t7/x0XqkK/kqBUt0=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4crYZG0Wzyz1K96c;
	Tue, 21 Oct 2025 21:49:42 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 74C76140259;
	Tue, 21 Oct 2025 21:50:05 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Oct 2025 21:50:05 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Oct 2025 21:50:04 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
Subject: [PATCH v3 2/4] uacce: fix isolate sysfs check condition
Date: Tue, 21 Oct 2025 21:50:01 +0800
Message-ID: <20251021135003.786588-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251021135003.786588-1-huangchenghai2@huawei.com>
References: <20251021135003.786588-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)

uacce supports the device isolation feature. If the driver
implements the isolate_err_threshold_read and
isolate_err_threshold_write callback functions, uacce will create
sysfs files now. Users can read and configure the isolation policy
through sysfs. Currently, sysfs files are created as long as either
isolate_err_threshold_read or isolate_err_threshold_write callback
functions are present.

However, accessing a non-existent callback function may cause the
system to crash. Therefore, check whether the function exists
before calling isolate_err_threshold_read or
isolate_err_threshold_write.

Fixes: e3e289fbc0b5 ("uacce: supports device isolation feature")
Cc: stable@vger.kernel.org
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 9b82a6731832..e3433d95640a 100644
--- a/drivers/misc/uacce/uacce.c
+++ b/drivers/misc/uacce/uacce.c
@@ -382,6 +382,9 @@ static ssize_t isolate_strategy_show(struct device *dev, struct device_attribute
 	struct uacce_device *uacce = to_uacce_device(dev);
 	u32 val;
 
+	if (!uacce->ops->isolate_err_threshold_read)
+		return -ENOENT;
+
 	val = uacce->ops->isolate_err_threshold_read(uacce);
 
 	return sysfs_emit(buf, "%u\n", val);
@@ -394,6 +397,9 @@ static ssize_t isolate_strategy_store(struct device *dev, struct device_attribut
 	unsigned long val;
 	int ret;
 
+	if (!uacce->ops->isolate_err_threshold_write)
+		return -ENOENT;
+
 	if (kstrtoul(buf, 0, &val) < 0)
 		return -EINVAL;
 
@@ -440,9 +446,7 @@ static umode_t uacce_dev_is_visible(struct kobject *kobj,
 	    (!uacce->qf_pg_num[UACCE_QFRT_DUS])))
 		return 0;
 
-	if (attr == &dev_attr_isolate_strategy.attr &&
-	    (!uacce->ops->isolate_err_threshold_read &&
-	     !uacce->ops->isolate_err_threshold_write))
+	if (attr == &dev_attr_isolate_strategy.attr)
 		return 0;
 
 	if (attr == &dev_attr_isolate.attr && !uacce->ops->get_isolate_state)
-- 
2.33.0

