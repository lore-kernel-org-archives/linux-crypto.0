Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7744275863;
	Sat, 30 Aug 2025 10:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756549684; cv=none; b=JDZyKoGGOOpCWqaswWWvTW8jEbN8XXXrMH2n80+Y0IrI2CPVHeZjeQoSIkNMqV9L+2wrqTxolVvOujR2/J1kq1nMQsafNtWnpZg2vQpCSX4C0DOWrUTXJbxNtCGVR8q4AV1cSjrFyBxPqrCBLmg4Ttnhl2XMsQ2tjDGwJ0lYpys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756549684; c=relaxed/simple;
	bh=Em4HeptOKUE2aFgPEd6e7G+CwpOeARyxzJvRvt6MEsY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qCc2FHYSgsO3hwAUmDfnesJOKfZdPIx/UGN6sp8QEri0gMoidW5yHeiCmnwJ6aAmNsL6PKvVVWpCnsUFSBLrf+PEBKV27deM6rs9Yq5tURpW329d64nE7aC2WBXt50X4+vvUwIcdl8HeUrgmPLdaOzaFNKmjxskOaJmcW+M7j7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cDWXQ08mGztTMN;
	Sat, 30 Aug 2025 18:27:02 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C266180486;
	Sat, 30 Aug 2025 18:27:59 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Aug 2025 18:27:58 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Aug 2025 18:27:58 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<yinzhushuai@huawei.com>
Subject: [PATCH 0/2] crypto: hisilicon - add two new features and two new zip sysfs
Date: Sat, 30 Aug 2025 18:27:55 +0800
Message-ID: <20250830102757.1498691-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

1.The zip device has added two new features: hash join and gather.
2.Add lz4 and lz77_only to the sysfs for user to recognize.

Chenghai Huang (1):
  crypto: hisilicon/zip - add lz4 and lz77_only to algorithm sysfs

Zhushuai Yin (1):
  crypto: hisilicon/zip - add hashjoin, gather, and UDMA data move
    features

 drivers/crypto/hisilicon/qm.c           | 29 +++++++++++++++++++------
 drivers/crypto/hisilicon/zip/dae_main.c | 11 ++++++++--
 drivers/crypto/hisilicon/zip/zip_main.c |  7 ++++++
 include/linux/hisi_acc_qm.h             |  1 +
 include/uapi/misc/uacce/hisi_qm.h       |  1 +
 5 files changed, 40 insertions(+), 9 deletions(-)

-- 
2.33.0

