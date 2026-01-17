Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CE7298CBE;
	Sat, 17 Jan 2026 10:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768645099; cv=none; b=UE3WfrtotBq9uafafiFGSN7eFXXjA3MBXr12yo3T3LqyputsuQaAQ3TTjnTDjPj9dYikeJ1oyJGNIax3GX09R9l7T0wwLcbnO61JdxZvGMXIGyFs9yrMAm1eyrTNleY+9JKBuKghPfC7I3lPlO069d25XPW+JBuTyXumiYGCYt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768645099; c=relaxed/simple;
	bh=buR8d6wULOflnasIQHjeyruPQBYHk4nltE8jT767eTk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Nri/f66j3TENAqpw6m56E/ia7LZel5aDMQIvwSeg8Nt12Q4xj1HMayJjzL3aSjND6820VKy0Z/y3mK7SqGUCfr4chMylxZTB3SPPH5LwD6+gjbrx05X07rYVXuWDJuaBLXdeB46vhO8D5WLWMuDPIUpV8aLwSK3xkNLqL5eJlB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=JBRebfRH; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="JBRebfRH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6ESVEiVRYOYj7B6//1NBAA6uLZRXj+hF7J4sWf2MuP0=;
	b=JBRebfRHda9RPx5uW923Uy6b/b/2hwIB9kGlyJ/v+lsNPdJzIM3g4rlbzffFE02aIKIX7/A+X
	iM0EqeAivhQnVhSObCR/mwIVVZB5rQjQ9L9m41VHUu6hV+0JAYLAeeeGu7oyaYR9+uIPhDM1YDB
	y8BSEnwFfvfd32PEqb81Lng=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dtXd55MDCzcZy1;
	Sat, 17 Jan 2026 18:14:17 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C98E84058A;
	Sat, 17 Jan 2026 18:18:07 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 18:18:07 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 18:18:07 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH 0/4] crypto: hisilicon/qm - fix several mailbox issues
Date: Sat, 17 Jan 2026 18:18:02 +0800
Message-ID: <20260117101806.2172918-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)

These patchset fix several issues for mailbox handling in the
hisilicon/qm crypto accelerator driver:
1. Fix the memory barrier order in mailbox operations to ensure data is
up-to-date before hardware access.
2. Remove unnecessary architecture-related code, as the driver is
exclusively used on ARM64.
3. Use 128-bit atomic read to replace the current mailbox operations
in the driver. Since the PF and VFs share the mmio memory of the
mailbox, mailbox mmio memory access needs to be atomic. Because the
stp and ldp instructions do not guarantee atomic access to mmio memory
on all hardware, the current assembly implementation is placed in the
driver.
4. Increase the mailbox wait time for queue and function stop commands
to match the hardware processing timeout.

---
Chenghai Huang (1):
  crypto: hisilicon/qm - move the barrier before writing to the mailbox
    register

Weili Qian (3):
  crypto: hisilicon/qm - remove unnecessary code in qm_mb_write()
  crypto: hisilicon/qm - obtain the mailbox configuration at one time
  crypto: hisilicon/qm - increase wait time for mailbox

 drivers/crypto/hisilicon/qm.c | 177 +++++++++++++++++++++-------------
 include/linux/hisi_acc_qm.h   |   1 +
 2 files changed, 113 insertions(+), 65 deletions(-)

-- 
2.33.0

