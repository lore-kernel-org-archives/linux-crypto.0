Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8953385BB;
	Tue, 21 Oct 2025 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761054614; cv=none; b=GuF5G2dfa4qzM1M0g5lbYGwIWNQ+j5NBH0UEXBn5bHct+lALlwWzOndVIup6ESi4eCpyAiMlAaNGZjigjn7YlwiK5vo/byWwmNiX17fKKhrANJB1FKPfClP+OijFarQJApjz4XbdrL3ECkb+D8JZYcBmHKw4crxwQkmOBso5ykI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761054614; c=relaxed/simple;
	bh=S25G2AZzcgMcGlIiX0c+8ROaue2MIMhb9CwLPOFSdN4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SOBRVvYtob0NQSSdARKNncJkDcLvoxYWAsomTho3QEdzxU8yP71GHFOpyZZpKLD4GUQpzxPGGd3VntHYNLYnoRQA6nPLgF4GcQ/QYUzE3nrwVSTRvhsDyoV7RXIRV4zbbFm/iSJ/Y2XREVDxAedGTXQLDhcTvycYzIrEZPM9fKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=3u+gyWWJ; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="3u+gyWWJ"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=afOO440E+h5xHJ+e1TzERB4wQNYDt+r2P7A9Bix2Pck=;
	b=3u+gyWWJMgMaTiyHlNmjXxSGPnavB/WBNxw29ieA2bnx28EtyDSIDHRUWqaWCh5yx9kMuMwe8
	XR8xJtMUy+pZDmlZGmOzC0xJtjdd6ibGLx8xq9LkVcKuAkNgRDmTokNZXm2FBxYpylJ0ySJnmbV
	w4lpV1D3roQK6MuvqKzafug=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4crYYM1DfYzcZyT;
	Tue, 21 Oct 2025 21:48:55 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id C4CED18007F;
	Tue, 21 Oct 2025 21:50:04 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Oct 2025 21:50:04 +0800
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
Subject: [PATCH v3 0/4] uacce: driver fixes for memory leaks and state management
Date: Tue, 21 Oct 2025 21:49:59 +0800
Message-ID: <20251021135003.786588-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

This patch series addresses several issues in the uacce:
1.Memory leak fix when device registration fails.
2.Fix sysfs file creation conditions.
3.Add error reporting for unsupported mremap operations.
4.Ensuring safe queue release with proper state management.

---
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

 drivers/misc/uacce/uacce.c | 55 ++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 11 deletions(-)

-- 
2.33.0

