Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA326291C31;
	Sat, 16 Aug 2025 10:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755340122; cv=none; b=lpIIoxc2GCcTBED9Ikk29bZpTFoJPae2+LpHbteT8h6MSjcpK6s46jbJJJtVKP9tocWLbuip9YhW43215PEd1pSk+Ite09aKWo8rqyShyJb17tSIRVT56pwkVErrVTYA9vczhWzZmXmMsHdd5mkH00frDTrAq9zqgY9Atii4Hpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755340122; c=relaxed/simple;
	bh=emW0AhD/c73rvr2IEFS2mlIV2W0TqsvsRB4AVZMkk8U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=q6gCUNDWC2cPKELCz3VKChyrddXuJPPBJVVihANUtB5AJnx8a2dptZNQIuHL1u0pBMhgYzJaTL9Ag8hQYuKxwwohUfTfw8GDQXGLjRAW2YQMi+klfROb+DqQTDVZD7oOBGrWGrK5JYKnipMdTXQ0kG83sFT6DOlLciK5qAmAKKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4c3wFw3mT2z2dMJF;
	Sat, 16 Aug 2025 18:29:40 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E657D140278;
	Sat, 16 Aug 2025 18:28:35 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:28:35 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:28:35 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<huangchenghai2@huawei.com>
Subject: [PATCH 0/6] crypto: hisilicon - enhancements and fixes for device reset and configuration
Date: Sat, 16 Aug 2025 18:28:28 +0800
Message-ID: <20250816102834.828655-1-huangchenghai2@huawei.com>
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

1.The configuration of each modules need to be restored after
device reset.
2.Cleanup performance mode configuration function, this register
which do not require read-back verification.
3.Add a check for the sva status before resetting.
4.Check if the input parameters match the device PF.
5.Register reserved interrupt for virtual function to avoid
Warnings with GICv4 and VF passthrough.
6.Repair a hardware register, otherwise the stream mode LZ77
algorithm will be affected.

Chenghai Huang (3):
  crypto: hisilicon - re-enable address prefetch after device resuming
  crypto: hisilicon/zip - remove unnecessary validation for
    high-performance mode configurations
  crypto: hisilicon/zip - enable literal length in stream mode
    compression

Weili Qian (2):
  crypto: hisilicon - check the sva module status while enabling or
    disabling address prefetch
  crypto: hisilicon/qm - request reserved interrupt for virtual function

Zhushuai Yin (1):
  crypto: hisilicon/qm - check whether the input function and PF are on
    the same device

 drivers/crypto/hisilicon/hpre/hpre_main.c | 127 ++++++++++++++--------
 drivers/crypto/hisilicon/qm.c             |  45 ++++++--
 drivers/crypto/hisilicon/sec2/sec_main.c  | 126 ++++++++++++++-------
 drivers/crypto/hisilicon/zip/zip_main.c   | 114 ++++++++++++++-----
 4 files changed, 293 insertions(+), 119 deletions(-)

-- 
2.33.0

