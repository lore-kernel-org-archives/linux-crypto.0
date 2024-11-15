Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E54F18C937;
	Fri, 15 Nov 2024 11:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731670043; cv=none; b=okPaKzFJmkZcuUoVJZB7tgm39PH2fejCv7MqNf/ef94EZpx/DuA9fss9zNefdOhseI21udg6kNyrmJ7pTxsKw8LAWWECOjCqLz9B/EJAF2o1raLe0JsG8OUlr0ZmOEeaFPiNS4K8LQvglfa1k4aITlL4NhglpUjXaEt1Y+EWZ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731670043; c=relaxed/simple;
	bh=vGYSc05+pu++/7wqsnIBVxY2/FfPU2NE9rH3I8yb5qQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y8farH3veLkp+kNhcEJ7GXcAoszN173VVGBgIPMp91lVegfQaApIagw6bX/nUu3k3qOsTSDhpWTxXShCdl6SIGwOMM2nYwG5OSr1zhNBnwwZRKsIXUVqAAEeu2GVEct84zzObQ1Tk87eWICLUbKQ8ngDdiaHsMiStd22tBiebCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XqZRx6QJyz1V3mf;
	Fri, 15 Nov 2024 19:24:45 +0800 (CST)
Received: from kwepemk500010.china.huawei.com (unknown [7.202.194.95])
	by mail.maildlp.com (Postfix) with ESMTPS id A1D741800CF;
	Fri, 15 Nov 2024 19:27:17 +0800 (CST)
Received: from ubuntu.huawei.com (10.69.192.56) by
 kwepemk500010.china.huawei.com (7.202.194.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 Nov 2024 19:27:17 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH 0/2] crypto: hisilicon - add data aggregation feature
Date: Fri, 15 Nov 2024 19:26:49 +0800
Message-ID: <20241115112651.54299-1-qianweili@huawei.com>
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
 kwepemk500010.china.huawei.com (7.202.194.95)

The zip device supports the data aggregation feature. This patchset
enables the hardware data aggregation feature, and registers it to uacce
subsystem to support submit operations in user space. In addition,
error detection and reporting of the data aggregation feature are enabled.

Weili Qian (2):
  crypto: hisilicon/zip - add data aggregation feature
  crypto: hisilicon/zip - support new error report

 drivers/crypto/hisilicon/hpre/hpre_main.c |  12 +
 drivers/crypto/hisilicon/qm.c             |  58 +++--
 drivers/crypto/hisilicon/sec2/sec_main.c  |  12 +
 drivers/crypto/hisilicon/zip/Makefile     |   2 +-
 drivers/crypto/hisilicon/zip/dae_main.c   | 262 ++++++++++++++++++++++
 drivers/crypto/hisilicon/zip/zip.h        |   8 +
 drivers/crypto/hisilicon/zip/zip_main.c   |  51 ++++-
 include/linux/hisi_acc_qm.h               |   5 +
 8 files changed, 385 insertions(+), 25 deletions(-)
 create mode 100644 drivers/crypto/hisilicon/zip/dae_main.c

-- 
2.33.0

