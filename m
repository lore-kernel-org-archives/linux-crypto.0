Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEBE1EB5DB;
	Sat,  9 Aug 2025 07:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754723322; cv=none; b=ZBwe5HhfHJJ+FhUAEpzEmTkfhaQ/Vy+rLShAWo1EpU/5rX3bRxQ+vhZfzC1X/Y9xM9vN1okjh5dlG87d2Ge5h8Zeyig+h289XqY+MlB87g7625YdeNNPRx2enf/Dkfak0wnuv5h+/Xd7Wafix8hjndAtLiagn1sS/kbEuFTuebk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754723322; c=relaxed/simple;
	bh=/iGZNc4JaBz+NzeKaGq79zYuxyxc8DT2jplr91rxXhE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ayR8SPMyPFRVs7XFjHyANjPTRrTp1YoIGWKx32VA7bmCwKyY5apnXpicIP5HixMWYlf/bvmqGCmU0CA5fgImelVnAMMR4CyUIXoyGM78ToQfm0VZkgEuIGF3Uj+hUrRD9JaUqcqHDGp1DVOQgWhVCyn4mm3MiXBlde1/LX6XpcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bzX1K4qprz14M3Q;
	Sat,  9 Aug 2025 15:03:33 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 3CFCB180492;
	Sat,  9 Aug 2025 15:08:31 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 9 Aug 2025 15:08:31 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 9 Aug 2025 15:08:30 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <taoqi10@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH 0/3] crypto: hisilicon - add fallback function for hisilicon accelerater driver
Date: Sat, 9 Aug 2025 15:08:26 +0800
Message-ID: <20250809070829.47204-1-huangchenghai2@huawei.com>
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

Support fallback for zip/sec2/hpre when device is busy.

Chenghai Huang (1):
  crypto: hisilicon/zip - support fallback for zip

Qi Tao (1):
  crypto: hisilicon/sec2 - support skcipher/aead fallback for hardware
    queue unavailable

Weili Qian (1):
  crypto: hisilicon/hpre - support the hpre algorithm fallback

 drivers/crypto/hisilicon/Kconfig            |   1 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 314 +++++++++++++++++---
 drivers/crypto/hisilicon/qm.c               |   4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  62 +++-
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  54 +++-
 5 files changed, 363 insertions(+), 72 deletions(-)

-- 
2.33.0

