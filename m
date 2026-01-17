Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966792FD69D;
	Sat, 17 Jan 2026 10:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768645099; cv=none; b=pxopMBPfocgV1HcVyo/Mla/B4YAYJuGsKMGtmsf4ZaESsI/FOam+6annvZFoBMRZYnz6eJciTuijGstwhQMg33pY9eDhZUaLQ7EYi5IL+0/YZPV3/KK/Ixs9GXkJAwbupeqcODMZRhFkQxW/d2DSWnsp+WO+Dowq15+B6N3D6h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768645099; c=relaxed/simple;
	bh=CjY4Xtz6sxrD7XMVBv1z2sA/eG+BwJjKAgN66jAEEnw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNjvNGW6wncRngDsk/lOk3mlPK+QEB3iij7H1Qo8XsFPkd7Peey4I/alJb7PuIOnMysD8nFc7EFDeo7nEs/WJZDeFDYCB3cEF0PsHlzEuPIgg8x+pzkB0QMx0gV714EGOT9jv8wlyHbcfxSteKLvAockqxptVwqJEcnXHIFovcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=HwN3pU93; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="HwN3pU93"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QQ77zNzJ28/hhg5JXu4D2DvZ7Ug9oghseuWjWMWInxw=;
	b=HwN3pU93uqHlri0bFASI7BPliv6+ghX8CviM1VnJI9xtJs+cf/oQaWbkJYLt0rHnPEA1K2J66
	HfN83Dn0kT7twgzZ6qzOF6zMy0UNjU4sec3uIwiC1HRWBy1x+mFfTHOUBRcaFfh+bSnmK4mjm53
	bPSXfcFpUDRLCSNSLHDx90I=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dtXdc4Ny5z1prLJ;
	Sat, 17 Jan 2026 18:14:44 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id F2FAC404AD;
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
Subject: [PATCH 1/4] crypto: hisilicon/qm - move the barrier before writing to the mailbox register
Date: Sat, 17 Jan 2026 18:18:03 +0800
Message-ID: <20260117101806.2172918-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260117101806.2172918-1-huangchenghai2@huawei.com>
References: <20260117101806.2172918-1-huangchenghai2@huawei.com>
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

Before sending the data via the mailbox to the hardware, to ensure
that the data accessed by the hardware is the most up-to-date,
a write barrier should be added before writing to the mailbox register.
The current memory barrier is placed after writing to the register,
the barrier order should be modified to be before writing to the register.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 700fc1b8318e..49c1c78ff600 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -609,9 +609,13 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 	}
 
 #if IS_ENABLED(CONFIG_ARM64)
+	/*
+	 * The dmb oshst instruction ensures that the data in the
+	 * mailbox is written before it is sent to the hardware.
+	 */
 	asm volatile("ldp %0, %1, %3\n"
-		     "stp %0, %1, %2\n"
 		     "dmb oshst\n"
+		     "stp %0, %1, %2\n"
 		     : "=&r" (tmp0),
 		       "=&r" (tmp1),
 		       "+Q" (*((char __iomem *)fun_base))
-- 
2.33.0

