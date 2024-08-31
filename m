Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8A14C99;
	Sat, 31 Aug 2024 11:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725105142; cv=none; b=M8iIdlMA0F3k+YYNNic/MYCN2xWP1csexzoGBMFnoKG6oyN1VvGz5ft3yQ3S3ablc0XUnsEPqhHUQ8tuutSGDTcc4P1OxlF6lr7geITSILnaXDw9u1a9CeJrWjm9Kgh3SByo7gJrFeWxeL8dcHuoqDYdKuSErqCe7JUg6imNAwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725105142; c=relaxed/simple;
	bh=7KJMoXFm1sjE9zdEQDm6xbqnZvCYOVAuYscMOzihT0M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XUlfMXv1tWxaGL0wcXjd3EkzU7nDLndEP5mPGyzclO1OLf0lcaUOw5btRxzBFst17TkCV5K+r97ZuNTVBW62e3ovALbVpw3lTddHJxIF6bm7OhSkH9NJGQXRIdAYlJnqaUvxIBeblv75mTt/xUdJKTtnH7igUOdfklvr63kAw8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wwtf64H1jzyR58;
	Sat, 31 Aug 2024 19:51:42 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 4AA021400DC;
	Sat, 31 Aug 2024 19:52:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 31 Aug 2024 19:52:15 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH 0/3] crypto: hisilicon - fix issues related to device reset
Date: Sat, 31 Aug 2024 19:48:28 +0800
Message-ID: <20240831114831.21987-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)

This set fixes some issues related to device reset:
1. Before enabling the device, reset the device to ensure that
the device is in the initial state.
2. Mask device task timeout error because the current device
timeout threshold is too short.
3. Memory error is injected to close master ooo to prevent the
device write the released memory.

Weili Qian (3):
  crypto: hisilicon/qm - reset device before enabling it
  crypto: hisilicon/hpre - mask cluster timeout error
  crypto: hisilicon/qm - inject error before stopping queue

 drivers/crypto/hisilicon/hpre/hpre_main.c |  54 ++++----
 drivers/crypto/hisilicon/qm.c             | 151 ++++++++++++++--------
 drivers/crypto/hisilicon/sec2/sec_main.c  |  16 +--
 drivers/crypto/hisilicon/zip/zip_main.c   |  23 ++--
 4 files changed, 146 insertions(+), 98 deletions(-)

-- 
2.33.0

