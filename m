Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989C22EA47D;
	Sat, 13 Sep 2025 10:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757761082; cv=none; b=X08m5uDMVJ0E6FblZN0eD7XgFVODV/doX4ydDiUiIFSacdfvnMf4U+zmJD5nMQoTWti7PL4Ew3FKo6rW1HeA4tth8hjDM2XAvqnJMrlYggpuFPY1uo02lCrWpoKSxU6vPGd95F8lyl/aGjxblQAlmQ8nqPdrzJMPDGSjHrv8Yp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757761082; c=relaxed/simple;
	bh=/t+x6+nfK5NZuggiTOOvq6EBmSgsph2n2/6y4WZ+i7o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NUFaY0Ra6xNXMW60K8qUOC+SlSqmub2780P5yTW+7tfijBl4OazRL/sPL4d1927OI59ViAkdzWxTijO/cEqxmunr2JuUn6EHdAtz6MskrSy5/khXRIv59wFG7V1bQ9Kzho00xiHzPSDo5/jVPIG5hw9BlF0QSaCTfdGaSCl58f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cP7YK4Wysz14Mnn;
	Sat, 13 Sep 2025 18:57:41 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 42E0218006C;
	Sat, 13 Sep 2025 18:57:56 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:56 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:55 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 0/5] crypto: hisilicon/qm - fix several minor issues
Date: Sat, 13 Sep 2025 18:57:49 +0800
Message-ID: <20250913105754.3862444-1-huangchenghai2@huawei.com>
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

These patches fix several minor issues:
1. Address the issue of device accessing invalid addresses
caused by the concurrency between device reset and business operations.
2.Clear all VF configurations when disabling SR-IOV.
3.Set the address to NULL after freeing the memory of
qm->debug.qm_diff_regs.

Chenghai Huang (1):
  crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs

Weili Qian (4):
  crypto: hisilicon/qm - invalidate queues in use
  crypto: hisilicon/qm - mask axi error before memory init
  crypto: hisilicon - enable error reporting again
  crypto: hisilicon/qm - clear all VF configurations in the hardware

 drivers/crypto/hisilicon/debugfs.c        |   1 +
 drivers/crypto/hisilicon/hpre/hpre_main.c | 111 ++++++++++++-----
 drivers/crypto/hisilicon/qm.c             | 144 +++++++++++++++-------
 drivers/crypto/hisilicon/sec2/sec_main.c  | 101 ++++++++++-----
 drivers/crypto/hisilicon/zip/dae_main.c   |   8 ++
 drivers/crypto/hisilicon/zip/zip_main.c   | 113 ++++++++++++-----
 include/linux/hisi_acc_qm.h               |  21 ++--
 7 files changed, 351 insertions(+), 148 deletions(-)

-- 
2.43.0

