Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E067C2F39B1;
	Tue, 11 Nov 2025 09:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762853747; cv=none; b=YYR72KoVVRF1sdCYqfvzFUp/6pAh9/mt/Bv0TMQd7/kkSV0h3yHInk+AlzZQ2knetWLDELqa8c0mn67X9j22biRYjdGiOX9E/r5u7PLMR+EqAdNqTkeYIZm6a5FUowrw1fjnT31C18pNbFY0J2Ilk+09bselRme9TQ+ja7CQn2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762853747; c=relaxed/simple;
	bh=K7mxGMzPYZS5mFQRUgVfD8xDxGUX3YVR8aGbiFcUAO0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=K1wqdH0LOKafUj39i1XfgWWUXJiozg0TJ/RlX/lME3O6U7y2IokfkKNhcAdmcHnBsArD681HIBvomCYYzg3WM7Yq8VSGOp7hXtQ7HMw00aNGH68yinxKqe8CzncB27cmefLciI86Jh/pMPk1WT9xsz+0+VczxuWM6UKwu/nB6ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=AbdAn3Hc; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="AbdAn3Hc"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Gr3o3tVvalWBpPWoYGfZ83VkNwYRGvBFoRGSAfjG5gE=;
	b=AbdAn3HcGKg/UD2269yrvR+HWQ3GJpr4eRRF9sAqvFw/u9L1ka0ofgastZ2wfrmXDTJSOuUg0
	hmlVcLuepwEPXkMpRgU5lxpuDpT0jE3IbpinvywaK+EK51uwD1/foQpm8N5WzuNbPp+1/Y4olqe
	2Yi9ap9Oz1Gsd3wbmhSbGAY=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d5LvW3Qv2zLlWH;
	Tue, 11 Nov 2025 17:33:59 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0AA5B1A0188;
	Tue, 11 Nov 2025 17:35:38 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 17:35:37 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 17:35:37 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <gregkh@linuxfoundation.org>, <zhangfei.gao@linaro.org>,
	<wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <shenyang39@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>
Subject: [PATCH v5 0/4] uacce: driver fixes for memory leaks and state management
Date: Tue, 11 Nov 2025 17:35:32 +0800
Message-ID: <20251111093536.3729-1-huangchenghai2@huawei.com>
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
1.Fix cdev handling in register and remove paths.
2.Fix sysfs file creation conditions.
3.Add error reporting for unsupported mremap operations.
4.Ensuring safe queue release with proper state management.

---
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

---
Chenghai Huang (2):
  uacce: fix isolate sysfs check condition
  uacce: ensure safe queue release with state management

Wenkai Lin (1):
  uacce: fix cdev handling in register and remove paths

Yang Shen (1):
  uacce: implement mremap in uacce_vm_ops to return -EPERM

 drivers/misc/uacce/uacce.c | 50 +++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 9 deletions(-)

-- 
2.33.0

