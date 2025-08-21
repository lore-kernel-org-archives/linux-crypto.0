Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4153F9D2;
	Thu, 21 Aug 2025 01:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755740296; cv=none; b=tktCbTcuVXYZO5+dUj15eeS91/IGR6KUhh5PD0PjH7lWO2JvKf0MF4sIshjX/3QdL4tC9qnZw1pQf5FqMqkEcysw6dHMNN0PYh5sF26dxg8cVg7bhgR2Pn6syOKyD+vskcU2/DY8d6GP11tEx4bKfsgmmmMEzAeQRqkl7n4tkSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755740296; c=relaxed/simple;
	bh=X+6m0fdAlK5xXqdO1PcJWvRFqN/6WNIyGz4KKYOs37E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Mv3IoswWwEMAnxdWZze854fVs1GM3p/LCzaR80h0m+a84uzodW94l/jmssWiHsa/PdDf9sVdfDF7tGtO1V0L7EsBTA/ihT/ONvNRX0zAlYzlewRHj7qSJLzeNRBLKa9mmC/wK2whnu65kiwmOiTbe1fnuoKrYvMF7By6CJ9Rwzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c6mCC4GmFztTNq;
	Thu, 21 Aug 2025 09:37:11 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 692331401F4;
	Thu, 21 Aug 2025 09:38:10 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:38:10 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:38:09 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<yinzhushuai@huawei.com>
Subject: [PATCH v2 0/6] crypto: hisilicon - enhancements and fixes for device reset and configuration
Date: Thu, 21 Aug 2025 09:38:03 +0800
Message-ID: <20250821013809.4016506-1-huangchenghai2@huawei.com>
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

1.Cleanup performance mode configuration function, this register
which do not require read-back verification.
2.The configuration of each modules need to be restored after
device reset.
3.Add a check for the sva status before resetting.
4.Check if the input parameters match the device PF.
5.Register reserved interrupt for virtual function to avoid
Warnings with GICv4 and VF passthrough.
6.Repair a hardware register, otherwise the stream mode LZ77
algorithm will be affected.

V1: https://lore.kernel.org/all/20250816102834.828655-1-huangchenghai2@huawei.com/
Updates:
- Move hisi_zip_open_sva_prefetch() to hpre_set_user_domain_and_cache().
- Swap the order of patch1 and patch2.

Chenghai Huang (3):
  crypto: hisilicon/zip - remove unnecessary validation for
    high-performance mode configurations
  crypto: hisilicon - re-enable address prefetch after device resuming
  crypto: hisilicon/zip - enable literal length in stream mode
    compression

Weili Qian (2):
  crypto: hisilicon - check the sva module status while enabling or
    disabling address prefetch
  crypto: hisilicon/qm - request reserved interrupt for virtual function

Zhushuai Yin (1):
  crypto: hisilicon/qm - check whether the input function and PF are on
    the same device

 drivers/crypto/hisilicon/hpre/hpre_main.c |  66 +++++++++---
 drivers/crypto/hisilicon/qm.c             |  45 ++++++--
 drivers/crypto/hisilicon/sec2/sec_main.c  | 126 +++++++++++++++-------
 drivers/crypto/hisilicon/zip/zip_main.c   | 112 ++++++++++++++-----
 4 files changed, 260 insertions(+), 89 deletions(-)

-- 
2.33.0

