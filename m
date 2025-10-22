Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F57A2144C9;
	Wed, 22 Oct 2025 02:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761099147; cv=none; b=rKoQ7QN1vWAwL4jC6Zlp69wRHzPMGVkiNBgyVJF7YKxQZliTw3dsCdnU6MfiJPpp6I8xh6cr0VZ2IAgaalQLELFxq6OaOTxHXeQdpC8+/NPKPAId5pHKpAa09N1+Z3aAlYGZlRDij6Dh0+6PN5qqUEcVtF7ICedhvRxSYXQSgvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761099147; c=relaxed/simple;
	bh=TWR8GXQJPy6unRKPZeUwgJvmGAL1681lypMPVlljwUA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MJxWh6o+z/xTSdj2nHxtwXxtkqn3wM0TjXkARyphXLrsC/agxG6cNbeTt2s72iGYx0t7GbAqTZl2SlmoGGqvj+v6O1xkFMmYWWi9LVX6YuYsJ39018BSOG2BO7ltHH4HEJZfz9ODz+hXZzqJQZiTCMoqW4oPxatBkMA/ENXmgLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=xC79Cvy0; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="xC79Cvy0"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8Ox2547AENmU7zFSWTojZNnWpSl1s+guzkBUOYPiR6I=;
	b=xC79Cvy0LHHLwbVJq74DnWJVsGSzGJqnyh3bDlFKk4eVreeGJLIn8qK79AgsirDZHoD6pD/ac
	OCXQKRhyTC1MjPFpOsId2M9lNRykDOH6eziRnoR7G0MyKH6yyR1EIyvawD/tR0kytOLajJ1cLiT
	braeb9Arx82/ZwF0j+dWMvo=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4crt2j4lxKzKmgn;
	Wed, 22 Oct 2025 10:11:57 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F03801A0188;
	Wed, 22 Oct 2025 10:12:21 +0800 (CST)
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
Subject: [PATCH v4 0/4] uacce: driver fixes for memory leaks and state management
Date: Wed, 22 Oct 2025 10:11:45 +0800
Message-ID: <20251022021149.1771168-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This patch series addresses several issues in the uacce:
1.Memory leak fix when device registration fails.
2.Fix sysfs file creation conditions.
3.Add error reporting for unsupported mremap operations.
4.Ensuring safe queue release with proper state management.

---
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
  uacce: fix for cdev memory leak

Yang Shen (1):
  uacce: implement mremap in uacce_vm_ops to return -EPERM

 drivers/misc/uacce/uacce.c | 51 ++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 8 deletions(-)

-- 
2.33.0

