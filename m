Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD8C1B4F3E;
	Fri, 15 Nov 2024 10:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731666112; cv=none; b=OMgNio1vadjr4OQIlvbAO/XgGzFMoau1SvQAQxENaB11xMiqM4ysjD9ErL8KhsqJFO5gR500ZhkE3k76/dAAEGewti+inkduIRH+YmbsB+Ogz+LgcLd9Ks8gLk1vm41rKTVLuLCiv+jnMM0VGpAZpoLqsfJLDfcRTbkja7YF3yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731666112; c=relaxed/simple;
	bh=ZPo1iQJH2fBwIipzc94ENG/TZjR32QFuSkgAZ8SHyzI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=En/MsfEoEH8PWXr22wzdefpXQOBfg2AeCoOrhfL6wSo9SHVUKx5bhau272udgISwIcn04/j8YDI7MBVU4hfuLZf7iFJocTcnJyPSWIDR1areIVToQ0dzrztWk24oTB7WhRndiVWHa2i5FA2UuSVgt3cY9d/gKJ9yLiUX0zZx8IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XqY0F5Stcz1V3tG;
	Fri, 15 Nov 2024 18:19:09 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 73FC61800A7;
	Fri, 15 Nov 2024 18:21:41 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 Nov 2024 18:21:40 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>
Subject: [PATCH v4 0/2] crypto: hisilicon - fix the authsize and icv problems of aead in sec
Date: Fri, 15 Nov 2024 18:21:37 +0800
Message-ID: <20241115102139.3793659-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200024.china.huawei.com (7.221.188.85)

1. Fix for aead invalid authsize.
2. Fix for aead icv error.

---
Changes in v4:
- Add a switching flag (fallback) for soft-calculation in req.
- Link to v3: https://lore.kernel.org/all/20241102025559.2256734-1-huangchenghai2@huawei.com/

Changes in v3:
- Call crypto_aead_authsize to obtain authsize instead of
actx->authsize.
- Link to v2: https://lore.kernel.org/all/20241018105830.169212-1-huangchenghai2@huawei.com/

Changes in v2:
- Restored authsize to the tfm.
- Link to v1: https://lore.kernel.org/all/20240929112630.863282-1-huangchenghai2@huawei.com/

---
Wenkai Lin (2):
  crypto: hisilicon/sec2 - fix for aead icv error
  crypto: hisilicon/sec2 - fix for aead invalid authsize

 drivers/crypto/hisilicon/sec2/sec.h        |   2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 161 ++++++++++-----------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  11 --
 3 files changed, 77 insertions(+), 97 deletions(-)

-- 
2.33.0

