Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A33B443C18;
	Fri, 11 Sep 2026 10:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122598; cv=none; b=ijOKNL93h3tvMyNzILq5Cfpr40QN6dij3Y2koeLaNa1DU4LmGttYpvdLBs5RJQ/1JPjK1mhbzYrSXs1Et6ZgtWZSyGiN6Y6Mvu/5scUH9U2H3fN7KY4M5fCY4Cjl2L69xjDwUNHbJfluFNPuYbN+bCbBcBZJGLch9Wa4h6nqYeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122598; c=relaxed/simple;
	bh=WCL7uOgiifywLHFHGRoos098dzPPZCj55DHJwok+QIM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lEjX59ZpamzjkAAoqDpyAEsmRxbuqVz1bv4isMLpesdtSJCo/EZSlZHrVrcn/gC6nzAEiA3B8OZBWbnetMkrelp4Wa3v+uvNQQ2qSQBDa5BdZl5qw7CPwDEki40WqHCQ0tgHrXWhI+EvvIalLoGqHLq+BWOXGbne1/XQ9ouYKxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=FyAl8mkp; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="FyAl8mkp"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=P7dbQrqU/eRsFN4xEwuK1Epg9+fUboCEIZ8/RgquGGI=;
	b=FyAl8mkpi1hcDJ+bLHLahXURkoEwRycZww4ZSWqJbJEN99dLst7TKXP8iG4i10NYVMGHX/JSq
	HMvh1LJqicT0yXDGHmwE+6ttHcVvE9v0hDuNOucHAA3NQqPU4dNDg7giWz+u1ITA2MlgAh4UJSZ
	nftOiGP7CeQhTTNqVmKCKZs=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hh9Vs4cbqzcb3G;
	Fri, 11 Sep 2026 18:18:45 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id E716340579;
	Fri, 11 Sep 2026 18:29:47 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 18:29:46 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 4/4] crypto: hisilicon/qm - fix GFP flag inconsistency in hisi_qm_memory_init
Date: Fri, 11 Sep 2026 18:29:42 +0800
Message-ID: <20260911102942.387778-5-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260911102942.387778-1-huangchenghai2@huawei.com>
References: <20260911102942.387778-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk200001.china.huawei.com (7.152.184.93)

From: Wenkai Lin <linwenkai6@hisilicon.com>

hisi_qm_memory_init() is called from hisi_qm_init() (process context)
but uses GFP_ATOMIC for dma_alloc_coherent().  The equivalent
allocation in qm_alloc_xqc_dma() uses GFP_KERNEL.

GFP_ATOMIC cannot reclaim or compact memory, so it fails more easily
under memory pressure even though sleeping is allowed here.  Switch
to GFP_KERNEL, which is safe in process context and consistent with
qm_alloc_xqc_dma().

Fixes: 5308f6600a39 ("crypto: hisilicon - QM memory management optimization")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 0448c68dbde4..a5593ee3889c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -6067,7 +6067,7 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 			QMC_ALIGN(sizeof(struct qm_sqc) * qm->qp_num) +
 			QMC_ALIGN(sizeof(struct qm_cqc) * qm->qp_num);
 	qm->qdma.va = dma_alloc_coherent(dev, qm->qdma.size, &qm->qdma.dma,
-					 GFP_ATOMIC);
+					 GFP_KERNEL);
 	dev_dbg(dev, "allocate qm dma buf size=%zx)\n", qm->qdma.size);
 	if (!qm->qdma.va) {
 		ret = -ENOMEM;
-- 
2.43.0

