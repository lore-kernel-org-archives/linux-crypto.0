Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBA643147;
	Tue, 16 Sep 2025 14:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758034100; cv=none; b=sDEtkk5AGWG7dcohi1DznNrTYjw7PJPjCvL8Q3ZjcB16/j4FyhK7Af7k+7OXA/ZHG5Cz3H3hzJZkeXb2Yhep1YiDMPgZAyZ6TOaWlzycNbpFkiQWuNcfJ0ZEMBtGAreXnTAjI/1W8gg8tJTEv5j3HRKMpIo67VxICHJhzj/5tkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758034100; c=relaxed/simple;
	bh=MDCtgPHdtGJVF2SjsYUJfbq7ZbJBIJMnzdqXX81WdVo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B8l5Ds6tPNc5mmETymn2BRyx8lzXtoSxK3IvkhjpcLEJCi4E3qBt0/hGBg4sCyw3VLcsuLHL9xrtxsVBMb54+tQ3Xzv/9vMMTSfl+Uxovl2Gxs3wiiZ5oy4ke+ttoyEY6Mz8TvCKNXAWhhhgzFEhlikHG72rDcVcFqgVI85ontc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cR4Wd0Qb8z14Ml1;
	Tue, 16 Sep 2025 22:47:57 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1F701180B5A;
	Tue, 16 Sep 2025 22:48:13 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Sep 2025 22:48:12 +0800
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
Subject: [PATCH v2 0/4] uacce: driver fixes for memory leaks and state management
Date: Tue, 16 Sep 2025 22:48:07 +0800
Message-ID: <20250916144811.1799687-1-huangchenghai2@huawei.com>
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
1.Memory leak fix when device registration fails.
2.Fix sysfs file creation conditions.
3.Add error reporting for unsupported mremap operations.
4.Ensuring safe queue release with proper state management.

---
Changes in v2:
- Use cdev_init to allocate cdev memory to ensure that memory leaks
  are avoided.
- Supplement the reason for intercepting the remapping operation.
- Add "cc: stable@vger.kernel.org" to paths with fixed.
- Link to v2: https://lore.kernel.org/all/20250822103904.3776304-1-huangchenghai2@huawei.com/

Chenghai Huang (2):
  uacce: fix isolate sysfs check condition
  uacce: ensure safe queue release with state management

Wenkai Lin (1):
  uacce: fix for cdev memory leak

Yang Shen (1):
  uacce: implement mremap in uacce_vm_ops to return -EPERM

 drivers/misc/uacce/uacce.c | 49 +++++++++++++++++++++++++-------------
 include/linux/uacce.h      |  2 +-
 2 files changed, 33 insertions(+), 18 deletions(-)

-- 
2.33.0

