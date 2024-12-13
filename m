Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1251AFB36;
	Fri, 13 Dec 2024 09:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081227; cv=none; b=t9XVB5GaRaENpe5k/hP7Q6dtVfEcPdJucOxo4CRdmgvQx7nBuphcsFSDZdoUcLvrnG8tGhI4hBByyOfAup2Ewi57Ixb8BjcxXxIhTGX9qtnczVXhC0WbHC/mcUsynxLO0MXBTtsoPNZmn40uJGCBDQeANbp1Iz6KiXKRhx+fS0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081227; c=relaxed/simple;
	bh=7mVEfkgiqnJv1689WtGlDPSr95lZgYyE7DSx34hHkqM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qrGg3ZUYmGwPzgUJB3Y7saogK3qtImfeJmWJgeJD1+x4L/dargobrJcVGAYrvUttNrt9LcM3sIFkLScdGUB5O/de9/iPMU4PJtyh5ZSZ3YHvMB51gV1MVcKkwVVhTtuxuxjlYRnCpecmJ9He2eC2gG5kecb2FBiH8211Ndf0ui0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Y8k843Sp4z11MR8;
	Fri, 13 Dec 2024 17:10:28 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id DFBC21800CE;
	Fri, 13 Dec 2024 17:13:36 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 13 Dec 2024 17:13:36 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v5 0/2] crypto: hisilicon - fix the authsize and icv problems of aead in sec
Date: Fri, 13 Dec 2024 17:13:33 +0800
Message-ID: <20241213091335.4190437-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemd200024.china.huawei.com (7.221.188.85)

1. Fix for aead invalid authsize.
2. Fix for aead icv error.

---
Changes in v5:
- Delete the 'fallback' that is not used.
- Link to v4: https://lore.kernel.org/all/20241115102139.3793659-1-huangchenghai2@huawei.com/

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

 drivers/crypto/hisilicon/sec2/sec.h        |   3 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 161 ++++++++++-----------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  11 --
 3 files changed, 76 insertions(+), 99 deletions(-)

-- 
2.33.0

