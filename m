Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ADD20EB;
	Sat,  2 Nov 2024 02:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730516173; cv=none; b=i03+kmDBMvtiZGVJf5OI94oVzHONzsbn5um4V1Z6EutXertSeX7gJxe37A45m4+2jiAeAwvLkQNqbcEBhdXnhB9TFrBAqs5odtI7EZpwYxZ+v8rMt0ip+o0Zgz/ROGm7epQrGk3SW299aUs6i8P6oraDfH61qYQKCaOL6FYWbXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730516173; c=relaxed/simple;
	bh=D5jHm/2iFM4uDlNx58MNahVQZDdbqB2cnP7kCC8bh5w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QN8Clo7r/gQr1HIqMhTxD/iZKB1s3Pz4JCrF8su/P+aRv1ZiN8Wn4Q5RLEWHQvTv8HZ0UxFky9otWh/xtRj7dL+ki2O79+t1UFtMFsk7vMdhVC1Zrzx4H/7WDP6oFVJ8ceiUMc6KHCUjPIY7Fjoe2EDg2SdsB8uPFWbAXb2vXQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XgMjy26xfzdkRl;
	Sat,  2 Nov 2024 10:53:26 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 29000140133;
	Sat,  2 Nov 2024 10:56:01 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Nov 2024 10:56:00 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH v3 0/2] crypto: hisilicon - fix the authsize and icv problems of aead in sec
Date: Sat, 2 Nov 2024 10:55:57 +0800
Message-ID: <20241102025559.2256734-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200024.china.huawei.com (7.221.188.85)

1. Fix for aead invalid authsize.
2. Fix for aead icv error.

---
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

 drivers/crypto/hisilicon/sec2/sec.h        |   1 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 156 ++++++++++-----------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  11 --
 3 files changed, 73 insertions(+), 95 deletions(-)

-- 
2.33.0

