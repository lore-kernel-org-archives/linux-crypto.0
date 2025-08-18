Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6326227A451;
	Mon, 18 Aug 2025 06:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755500241; cv=none; b=HilymzRnkJ8GCDpynulobXhpoTfwajLkU47E8LrmjpLHhwiqUefzriMif3QJeiE3mpuuycL1kZswROE81fQzs2eKdDiQ1x7POkZziozxLFNTWiInqfStTTDzPxi6AswXUrX/IA9fp9rv9S2b61LuYUYgqxpbDihCdSWzfTL26fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755500241; c=relaxed/simple;
	bh=Tr0RGh1nfjUFgZAJ5ggwEnWRfFONvVof5/QyxRM5kqQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YBnd6IwKeVAMTiDhPf/oX/iyjZVf29zM//MwZy9w9BQI198DbCBAF3QRn2e8F7gvYtZtnVYthzXiQtYZy8NgAC6GrStlqHovzfJkM429Y1lODK68FCOrpsFkmtGwmL5E7YxUXuX3CgWZB/uDzkzWGyXSRngoQACklTwBpNP/K6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c53Lw2PLrz2CgCl;
	Mon, 18 Aug 2025 14:52:56 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 2928E1402CC;
	Mon, 18 Aug 2025 14:57:18 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 18 Aug 2025 14:57:15 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 18 Aug 2025 14:57:15 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>, <taoqi10@huawei.com>
Subject: [PATCH v2 0/3] crypto: hisilicon - add fallback function for hisilicon accelerater driver
Date: Mon, 18 Aug 2025 14:57:11 +0800
Message-ID: <20250818065714.1916898-1-huangchenghai2@huawei.com>
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

Support fallback for zip/sec2/hpre when device is busy.

V1: https://lore.kernel.org/all/20250809070829.47204-1-huangchenghai2@huawei.com/
Updates:
- Remove unnecessary callback completions.
- Add CRYPTO_ALG_NEED_FALLBACK to hisi_zip's cra_flags.

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
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  52 +++-
 5 files changed, 360 insertions(+), 73 deletions(-)

-- 
2.33.0

