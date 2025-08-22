Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3690D1A9F83;
	Fri, 22 Aug 2025 10:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755859151; cv=none; b=ZMHD9UnECov/oiWAeORAkqlfmzL73Ziy9zK2GmdzzmBy+BqYuQoU2CpcGGxj9gx3f4SvkltU6UuA6I2ubNRP43div7AtAF5zphK14oCiahk3J6n05PM9BJ5Fk4fW5OALWtMuaAZdbs6UsMq7tZ3ZTttibUy8A1liFQDYPvLwOOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755859151; c=relaxed/simple;
	bh=+NJqf0Q8P/pHxeIS0vqxlKtC+6GwQCGvMwRKsskqgFQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Hn5VKRaxubaj9l/tCcUCOATM8HQw9hqegxqzk6gVVl64yb9HZmfcccn8b9bhclmjqyFiiJzdk+rM7ooC0p36fRNOQUgrt3/cg0GKZHOXSbGaRnuExLB/stqFhCYUM6ZTmV8CMHKGSLPkAikhSZQcU7xjTKtfY6yT3p2nc6yeJ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c7c6g51w1z1R920;
	Fri, 22 Aug 2025 18:36:11 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id AFB1E1800CE;
	Fri, 22 Aug 2025 18:39:05 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 18:39:05 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 22 Aug 2025 18:39:04 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<linux-crypto@vger.kernel.org>, <fanghao11@huawei.com>,
	<shenyang39@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<liulongfang@huawei.com>
Subject: [PATCH 0/4] uacce: driver fixes for memory leaks and state management
Date: Fri, 22 Aug 2025 18:39:00 +0800
Message-ID: <20250822103904.3776304-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This patch series addresses several issues in the uacce:
1.Memory leak fix when device registration fails.
2.Fix sysfs file creation conditions.
3.Add error reporting for unsupported mremap operations.
4.Ensuring safe queue release with proper state management.

Chenghai Huang (2):
  uacce: fix isolate sysfs check condition
  uacce: ensure safe queue release with state management

Wenkai Lin (1):
  uacce: fix for cdev memory leak

Yang Shen (1):
  uacce: implement mremap in uacce_vm_ops to return -EPERM

 drivers/misc/uacce/uacce.c | 47 ++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 9 deletions(-)

-- 
2.33.0

