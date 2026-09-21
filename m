Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ED8318146;
	Mon, 21 Sep 2026 09:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983732; cv=none; b=GsjCYdMXMwKMm11udr3qI2tnGMcY1a+n3tQhATVEo83FlEEZhj+vZCPRYmD5m0vX4NDYMNpImTT1iR45NmR3Aitxr7QyEHT9e1AIX4n5/wJSkhrA1GHEsvLydEbrIO17QTefQxFypiITTsm5pW9wQJuptaWD5bjhnnGRNnYRkjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983732; c=relaxed/simple;
	bh=pyvJMR+hewQhqUObuhqg95HAFgz0B39hHH6LLVK/otY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sWrpueu/Vetnt7IAv4s9FKlk+FbtY8wYuj0ajpsx4h5YOYoRW8T8VQZny+zOIKTx7qLzKstTvHYvKxm22Pqq6zdXKJKDs1NXt96MK93HN55EVEXyVrTEv/aWPqqJYQPPv9WRiVLSijgHNdFyMuXu2b0f5MubvJ5a/YsZMyYgCQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=WnRLcJrx; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="WnRLcJrx"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HDv+RsLW/SjFIS2Rl1eG6otBGTZ7KXWPvvCxsb4BIvo=;
	b=WnRLcJrxS2IogDu+fTC7wuczw9oa6I2dc+LyMsNUVwt3MSguD0zQkyBWNzaO0mWTFl7+peJd7
	nSk0H+KfOtt72GHa/ykTh/jwz2F0F8JFoVoXER9xQAWCSZB/3JWkeJQG2PLsOho+7wF5nMp3lMl
	fOtZMAC3nK6PDxwPkfN0u5I=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hpHzD6Wy3zmV91;
	Mon, 21 Sep 2026 17:31:04 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id D81F940563;
	Mon, 21 Sep 2026 17:42:06 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 21 Sep 2026 17:42:06 +0800
From: Weili Qian <qianweili@huawei.com>
To: <gregkh@linuxfoundation.org>, <herbert@gondor.apana.org.au>,
	<zhangfei.gao@linaro.org>, <wangzhou1@hisilicon.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<huangchenghai2@huawei.com>, <liulongfang@huawei.com>
Subject: [PATCH v2 0/2] uacce: add device usage sysfs interface
Date: Mon, 21 Sep 2026 17:42:03 +0800
Message-ID: <20260921094205.1426618-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200011.china.huawei.com (7.202.181.237)

Add a read-only dev_usage sysfs attribute so userspace can query device
usage through sysfs. Patch 1 adds the attribute and the get_dev_usage
callback to the UACCE framework; patch 2 implements the callback in the
HiSilicon QM driver.

Changes in v2:
- Switch from qm_pm_get_sync() to hisi_qm_get_dfx_access() so that
  reading dev_usage does not wake a runtime-suspended device.  When
  suspended, 0 is reported for each channel without touching the
  hardware.
- Rename total_bw to max_bw in qm_usage_percent() and add a comment
  describing the channel-usage register layout to clarify the
  per-channel maximum semantics.

Weili Qian (2):
  uacce: add device usage sysfs interface
  crypto: hisilicon/qm - implement uacce get_dev_usage callback

 Documentation/ABI/testing/sysfs-driver-uacce |  9 +++
 drivers/crypto/hisilicon/debugfs.c           | 17 -----
 drivers/crypto/hisilicon/qm.c                | 66 ++++++++++++++++++++
 drivers/crypto/hisilicon/qm_common.h         |  1 +
 drivers/misc/uacce/uacce.c                   | 19 ++++++
 include/linux/uacce.h                        |  5 ++
 6 files changed, 100 insertions(+), 17 deletions(-)

-- 
2.43.0

