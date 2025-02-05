Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D942135C6;
	Wed,  5 Feb 2025 03:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727796; cv=none; b=baUeuANaUAVbZwIzdxPs7/xJ1rNidiq0PzKZRkPc4cJhZsMcSc6/KKzWaNg4ZrukvZS5wh6IQmTM77nAmQvlQ/RYP/ZeOk0gTGQsLPpcg1jE+KAabJIpKsMQQ8QAlCj/qkzJJUSqD7kHIRxmhQMoP1bJlkoaSxRyaAmG6abPKKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727796; c=relaxed/simple;
	bh=DqTvswz0WCue98EzuV1YYpsi/NFRaFqyTBU+XDM7aLY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LJAtc8HjONgfuo1tehZrLphbV/T4ESIwuZ7dZBYjAMEap9rSqDMqWVyZn9hIFY8tFVNuGukXTrIFXxEvXgjOojYBaQjXHvQXpxDbvxDbW9hZZjYDQaCkFv3M3hzvQdVUgGiTNFFgWDLuwb3tWO/8/YtLkZhAwz2MjwO9ww2G+Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YnmWw0qHLz1W55W;
	Wed,  5 Feb 2025 11:52:12 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id B001D18010B;
	Wed,  5 Feb 2025 11:56:29 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Feb 2025 11:56:29 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 0/3] crypto: hisilicon/sec2 - fix the specification problems for the sec
Date: Wed, 5 Feb 2025 11:56:25 +0800
Message-ID: <20250205035628.845962-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200024.china.huawei.com (7.221.188.85)

From: Wenkai Lin <linwenkai6@hisilicon.com>

1. Supports the case that the auth key length is 0.
2. Check if the aead authsize alignment is 4-byte aligned for cbc mode.
3. Fix for the specifications not supported by the sec hardware and
   use the software api to do the caculation.

Wenkai Lin (3):
  crypto: hisilicon/sec2 - fix for aead auth key length
  crypto: hisilicon/sec2 - fix for aead authsize alignment
  crypto: hisilicon/sec2 - fix for sec spec check

 drivers/crypto/hisilicon/sec2/sec.h        |   1 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 125 ++++++++-------------
 2 files changed, 47 insertions(+), 79 deletions(-)

-- 
2.33.0

