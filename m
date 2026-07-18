Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE0D28A3FA;
	Sat, 18 Jul 2026 03:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784343927; cv=none; b=aUw/iyvFJHiLQj1ABxVJSuhl3x1vB+fwsierxTVZY3MQfy4IBXMhWnOPXkq16DWpzYl350FlgzkhAIlv6m8r2SjCsap00aWfYhdrS5foMT9DOmXE6nh26afAcVwAiy0hdS07VB78PYFoLijysci03rCVjzdzUrGwhRyMn9YVCVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784343927; c=relaxed/simple;
	bh=6Jq88kYCzfa8HoBGAlmMLwke0iv7KqxQCjqvnsZgcrY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rBOTcll81WERu9Phe0/qkM7js2p0l8fJo4AWPh8VdJroCTEP/yzD+0lZpvYaomVJ72671m1R8+PhiISJzxydSKJsR4AVdsPVwm25pUlrmpzAHvQNM6XVUIfjW8D047fNipcGnrnW7RX8InyefaVYgh3X3ZTtAsHakOkOi8zISgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ifwWHkir; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ifwWHkir"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oJKUls6lIQh0LbqONQNxqWfthODauJ6soyaj68DmCok=;
	b=ifwWHkiru4y5yRxh9P9RgAirz474NmUWL7esxwB+PLLNFuXbnW6e6i2vRiE3I3rZd6HuKBAkg
	wzbJ2Oop3Mm9HFuyuoh7erbh6ZcSeyeKwAIXix5WSL7d+MR34PUHyfwKUVOvlYhTTLLleX1wlB1
	Xd6BDREUDRZ7LNT/aTm+kwo=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h2BHG1GhBzcZyH;
	Sat, 18 Jul 2026 10:55:54 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 2BC2A4057D;
	Sat, 18 Jul 2026 11:05:15 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Jul 2026 11:05:14 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Jul 2026 11:05:14 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 0/2] crypto: hisilicon/sec2 - fix uninitialized type_supported and drop unused hlf_q_num
Date: Sat, 18 Jul 2026 11:05:11 +0800
Message-ID: <20260718030513.3809002-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
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

This series fixes a use-before-init bug in the hisilicon/sec2 driver
and removes an unused field exposed in the same path.

The first patch sets ctx->type_supported in sec_ctx_base_init(), before
the sec_create_qp_ctx() loop consumes it; otherwise the value read to
select the callback is uninitialized on the first queue. The alg init
paths then just select req_op from it.

The second patch drops sec_ctx.hlf_q_num, which is assigned but never
read.

Chenghai Huang (2):
  crypto: hisilicon/sec2 - fix uninitialized type_supported in
    sec_create_qp_ctx
  crypto: hisilicon/sec2 - remove unused sec_ctx.hlf_q_num

 drivers/crypto/hisilicon/sec2/sec.h        |  3 ---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 25 +++++++++++-----------
 2 files changed, 12 insertions(+), 16 deletions(-)

-- 
2.43.0

