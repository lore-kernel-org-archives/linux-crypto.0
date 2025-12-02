Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDF32FFDC9;
	Tue,  2 Dec 2025 06:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764655987; cv=none; b=LCy/Gop6ejDRwPo7IUuSOmmx8hCP2kJL5s7/SPMH7Z23eeMIz9gQElCiHzOlFp9Y6Xjle1qmaLXUr5mjQMAqK0RVb/RzsGis8c4D8uEGejy0ExEnhOXtJ+q1/8AOQwjn7khynAb3tYG78anlF1FI3/giD6JqQVn3JmNW3eVMGJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764655987; c=relaxed/simple;
	bh=X3vZvd3SUa9y2+/QSzmbGoF+/KYrBdRFqMn0u6VUnyM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=llYevtAhy+5nx742hrgF/yYgAHryr7cbLpsiQr8k9YvYSybft4qbYWksUvFqDMYSl8yIS4kzOWcj/RkUJVF/IFTsnoXrEXIzlPPbviKsLEOzQf46YMeXvkrCoaaJ8sqwJaDL8GBORu3iYin0PkKJ3vuGPhELzjkQHUAhluujK2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0qvLFw1T; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0qvLFw1T"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dVlVWczNwviCT3QsxlZFwu1Mb0gYzJP4pvZHLd6Vxsk=;
	b=0qvLFw1TJPo25qKkNIOoSQc/fSM5yzFCzVctBRjWLiXMn8+E5qWHrcvpr/Lsv5HxNuTOMK8LL
	oSGkBpK4MDRQ++ZTj5OkpioKmXac5HYZkk/84v5p4VwiLTqn7IuCu8baoRHQXeOaSf+t6+YOjke
	vlENAdzKO07TQO5qTD7nECE=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dL9P8170nzcb1P;
	Tue,  2 Dec 2025 14:10:36 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id EBDDA180B66;
	Tue,  2 Dec 2025 14:13:01 +0800 (CST)
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
Subject: [PATCH v6 0/4] uacce: driver fixes for memory leaks and state management
Date: Tue, 2 Dec 2025 14:12:52 +0800
Message-ID: <20251202061256.4158641-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This patch series addresses several issues in the uacce:
1.Fix cdev handling in the cleanup path.
2.Fix sysfs file creation conditions.
3.Add error reporting for unsupported mremap operations.
4.Ensuring safe queue release with proper state management.

---
Changes in v6:
- In patch 1, if cdev_device_add() fails, it will automatically free the cdev, however,
  we need to set uacce->cdev to NULL to prevent cdev_device_del() from being called.
- Link to v5: https://lore.kernel.org/all/20251111093536.3729-1-huangchenghai2@huawei.com/

Changes in v5:
- There is no memory leak issue when cdev_device_add fails, but it is necessary
  to check a flag to avoid calling cdev_device_del during abnormal exit.
- Link to v4: https://lore.kernel.org/all/20251022021149.1771168-1-huangchenghai2@huawei.com/

Changes in v4:
- Revert the interception of sysfs creation for isolate_strategy.
- Link to v3: https://lore.kernel.org/all/20251021135003.786588-1-huangchenghai2@huawei.com/

Changes in v3:
- Move the checks for the 'isolate_strategy_show' and
  'isolate_strategy_store' functions to their respective call sites.
- Use kobject_put to release the cdev memory instead of modifying
  cdev to be a static structure member.
- Link to v2: https://lore.kernel.org/all/20250916144811.1799687-1-huangchenghai2@huawei.com/

Changes in v2:
- Use cdev_init to allocate cdev memory to ensure that memory leaks
  are avoided.
- Supplement the reason for intercepting the remapping operation.
- Add "cc: stable@vger.kernel.org" to paths with fixed.
- Link to v1: https://lore.kernel.org/all/20250822103904.3776304-1-huangchenghai2@huawei.com/

Chenghai Huang (2):
  uacce: fix isolate sysfs check condition
  uacce: ensure safe queue release with state management

Wenkai Lin (1):
  uacce: fix cdev handling in the cleanup path

Yang Shen (1):
  uacce: implement mremap in uacce_vm_ops to return -EPERM

 drivers/misc/uacce/uacce.c | 48 +++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 8 deletions(-)

-- 
2.33.0

