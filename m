Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3094178396;
	Sun, 29 Sep 2024 11:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727609206; cv=none; b=FeO7tyrK4fl7MBCQz56JrI8/LdJiD3tbxECmixVFMljUZ7yIrlMkfn1zahkoovmbPGron0QeoqgQYBy0JdXzSu9nCLNm7Om41quEx9VfU7FcEIbQsSU5ZFl1O2au3lPBxpR4U+yKc4NeyXyAFrr37vKm9RJjrPOV6TpDD87wotw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727609206; c=relaxed/simple;
	bh=gzB1TJ9KFu0E9cmROvm3uprSTBlcw88C5GhTIdaTT3k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=V3NnksjNhsuEfT6NuGoZtXGZ+hNmEZHKzjCBZ9IKNC7T4h7ANR7qnRYnBhpXs150P05KgfU/rpVTNMwQrSARysx1T/361G6pdcKEj68zcWIhrGCA4FUawuGmdZBbrZ8++6DZSwz6GpFnFcgvbdl26Z0uwfA/GXfNOs5p0A3lhfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4XGhjk2R7Dz1ymZy;
	Sun, 29 Sep 2024 19:26:34 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id D8646140109;
	Sun, 29 Sep 2024 19:26:31 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 29 Sep 2024 19:26:31 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<huangchenghai2@huawei.com>
Subject: [PATCH 0/2] crypto: hisilicon - fix the authsize and icv problems of aead in sec
Date: Sun, 29 Sep 2024 19:26:28 +0800
Message-ID: <20240929112630.863282-1-huangchenghai2@huawei.com>
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
 kwepemd200024.china.huawei.com (7.221.188.85)

1. Fix for aead invalid authsize.
2. Fix for aead icv error.

Chenghai Huang (2):
  crypto: hisilicon/sec2 - fix for aead icv error
  crypto: hisilicon/sec2 - fix for aead invalid authsize

 drivers/crypto/hisilicon/sec2/sec.h        |   2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 169 +++++++++------------
 drivers/crypto/hisilicon/sec2/sec_crypto.h |  11 --
 3 files changed, 71 insertions(+), 111 deletions(-)

-- 
2.33.0

