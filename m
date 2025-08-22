Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAA92F6171;
	Fri, 22 Aug 2025 10:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755859151; cv=none; b=m1GhqArN36BqE/MrUfVC3RuimMTXPE+U8nAwR7AcAhRtxS6p09gQCnfZD2qq7q6Bz5DBSMu8RU/HA0/HI2Pg9TxLhjjm/RDsvR/rKXd6nc+MoH76G5MaHkRqHlijQD4cHIT4h/kIX7g316WlvXbqMYohiqTO+MnR/AO34jkDnow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755859151; c=relaxed/simple;
	bh=IiJu0dAgX0GTEfaCVdzfvEOkWBNEAnnQwElMQNlxcfE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WthnmCW6b6GHDsjocYYawYq4u2RTDtTT0X1aRUG+QWg08lob+8/CC4/amosNs0O/uPPa7p+aULN7qwzJleYaUX5T4e6AKcHoXJYHUKAog/FFeH53katguvHmYM+9XAlhYqsoTQrQamT//AW3m6d+HIyK/Sc9qybhM3gLue1w4yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c7c4y59nKzdcWF;
	Fri, 22 Aug 2025 18:34:42 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 9D23A1400CD;
	Fri, 22 Aug 2025 18:39:06 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 18:39:06 +0800
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
Subject: [PATCH 2/4] uacce: fix isolate sysfs check condition
Date: Fri, 22 Aug 2025 18:39:02 +0800
Message-ID: <20250822103904.3776304-3-huangchenghai2@huawei.com>
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
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/misc/uacce/uacce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/uacce/uacce.c b/drivers/misc/uacce/uacce.c
index 3604f722ed60..6a38809ca819 100644
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

