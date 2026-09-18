Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2A6376BD9;
	Fri, 18 Sep 2026 12:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734456; cv=none; b=Crkyth6gwRMJwPe1OJYcIfG5h5xo7zE0oha86jP6lD4lLgo5nD1g7860FJcVMW3QLEamj+f51+JOL4+O5J1TcZjW0+CEApUZ5yyK24H5BRcorNrcgmdG7cmvx5DjIlPbE4lUHpAy4TqQku/lAH1+2JVu69t93S+KMwezSPAKOQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734456; c=relaxed/simple;
	bh=8oQxtXU54VAPeYYR8e8fB9bERuTq9TTxLa2/SL3QoGQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X6Z7490i4sgrbEI84I8PEt0eTzEy/1otCl1bWvp23fhsoDxCcg/zImnIXEtKvvifHZP5N+EGoIxdukewGTCuWRThD0OfY6vpN4dNx1wnIVU+fauIL37JtQ78tWosV6aM8gl0N3KW5uaHqyzLynaSKCWL4HIkjSdvlHBw8pkry3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=JCn7tzIk; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="JCn7tzIk"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8KQLO/3WGiDHJQbt1e7LoBrA6C7xR9CjUl6+/I3E0jQ=;
	b=JCn7tzIk0pTwwiFMeHmNSoIaZ6NtKoxuGcGZ2Qf1IZpdwsCpEvDv2AcPT83mC71bRIzcl5X9C
	sUN9wT3Oex27ZTLuiAHwhS1P5CeqfLytE5VN7eHyKd+tADwrLFqrPbcq6gmP3Hr27kR4V1npU42
	/as8EZIYNb96e/j4A/J5ezE=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hmWnS1qXLz1K96s;
	Fri, 18 Sep 2026 20:16:28 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 68307402AB;
	Fri, 18 Sep 2026 20:27:28 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 18 Sep 2026 20:27:27 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 2/7] crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in ECDH
Date: Fri, 18 Sep 2026 20:27:21 +0800
Message-ID: <20260918122726.3014899-3-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918122726.3014899-1-qianweili@huawei.com>
References: <20260918122726.3014899-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf200011.china.huawei.com (7.202.181.237)

In hpre_ecdh_hw_data_clr_all(), req->dst is always NULL because
hpre_ecdh_dst_data_init() sets hpre_req->dst = NULL before mapping
the user buffer with dma_map_single(). The dma_free_coherent() call
on req->dst is therefore dead code. Remove it.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 7894211b9972..8551d6ccb78d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1407,8 +1407,6 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 	if (unlikely(dma_mapping_error(dev, dma)))
 		return;
 
-	if (req->dst)
-		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
 	if (dst)
 		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
 }
-- 
2.43.0

