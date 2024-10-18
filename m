Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F67618C938;
	Fri, 18 Oct 2024 10:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729249117; cv=none; b=sPcjH6U0YYAcFL8S8Iws2jOk7UILu3851ICGJZIuwy/mZretjhrERoA7VKHbv1QlcOlienJ4aVPPH8aClTyPjNTbGvO9rfCr3iu37hjgz2bYe4RnlumO4xU6Z+mTWquuApPMNgFoKs2yywgVK7i4Brk1JkQ0lzQwJxoNsbhqh5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729249117; c=relaxed/simple;
	bh=049Q6TzPj6Wp6Q1GYh0+Uq1MCs8j1czyEUWDXbvnLF0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tywjmjVPwj9AzifnGKa6Yjlkon9asV97/arUpoLXicwi6RgcDV46SBGnDf2veK8B6aEhK9qTEZI8N//Ae12UgxvBbJGq1gaewlXYI3eAaGiBBvgE6g0IyB0LeNGpDVq8ivq1gmzPNbjVj1rPJ+lX+dYCPEADWKBhFL4pmAV7zg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XVM9j2HDHz20qY5;
	Fri, 18 Oct 2024 18:57:45 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id A1E7314010D;
	Fri, 18 Oct 2024 18:58:31 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 18 Oct 2024 18:58:31 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<huangchenghai2@huawei.com>
Subject: [PATCH v2 0/2] crypto: hisilicon - fix the authsize and icv problems of aead in sec
Date: Fri, 18 Oct 2024 18:58:28 +0800
Message-ID: <20241018105830.169212-1-huangchenghai2@huawei.com>
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
Changes in v2:
- Restored authsize to the tfm.

---
Wenkai Lin (2):
  crypto: hisilicon/sec2 - fix for aead icv error
  crypto: hisilicon/sec2 - fix for aead invalid authsize

 drivers/crypto/hisilicon/sec2/sec.h        |   2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 176 +++++++++------------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  11 --
 3 files changed, 79 insertions(+), 110 deletions(-)

-- 
2.33.0

