Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DBE429838;
	Fri, 11 Sep 2026 10:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122592; cv=none; b=b09Gkg4btwEeMS4JhAsJn5pjFJwKWz23gz/WQMbCmVnJAcRe7V8Pw3uFx7Fx+ekjBCcTqGZhyqTQXNQFdjHnNWmP453+UrCHBZASVXfwHyJ7HcvZGctlFm0ZyUOEs6ccnV2TE/3clihrti97OanarE2owRpdP8P7Qo07IDpVzAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122592; c=relaxed/simple;
	bh=oy8V1oY5BuE2EcujppGbwVp6bL3xO2L1dntOy8uHZlE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iy7y8YcHC5ZHwo4HsBp2fioCPwsDbdSmMHZNWGYFKShWC+d8X7mv0r0ZehIjJObJhfDzQNgRe88FZn9+LD7VNn0hhxLeb35mXxCEZm24rczT0apsJ+BoFMNij8CN4SFc+0zo6S2i28pgENI4u3w9RbYPzXkCDzAijfQfxcaV4Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=v04WmE8M; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="v04WmE8M"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qlh1uoHDxvxCILcdR5iou+SpPCfOhn5G3AHfbnPvEZI=;
	b=v04WmE8M+yvVccINenn2qHHnx/86OnVvRUV+Ai19gAvIQjusI3wkrq0R8JMXKfOJTQjM+4Tme
	kfbmgj7iRz1UvjiGNIXSiH2XLbLXyzrWeI+sZqRE7LZZASi8rHfIrEZOze4/bYdaJsDr/BJa+Wd
	tjnNpYPNMEovmzax0llRDjc=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hh9V93s8dzpSvD;
	Fri, 11 Sep 2026 18:18:09 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 533304057F;
	Fri, 11 Sep 2026 18:29:46 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 18:29:45 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 2/4] crypto: hisilicon/sec2 - fix scheduling while atomic in aead soft fallback
Date: Fri, 11 Sep 2026 18:29:40 +0800
Message-ID: <20260911102942.387778-3-huangchenghai2@huawei.com>
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

sec_aead_soft_crypto() allocates the sub-request with GFP_KERNEL, which
may sleep.  This is safe when called directly from sec_aead_crypto()
(process context), but the function is also reachable through the
backlog drain path.

When an AEAD request sits in the backlog queue and qp_send_message()
returns a non-EBUSY error, the backlog is drained in software while
the backlog spinlock is still held. The GFP_KERNEL allocation inside
aead_request_alloc() can then schedule out, triggering scheduling
while atomic.

Fix it by switching the allocation to GFP_ATOMIC so it is safe in both
the process-context path and the spinlock-held backlog drain path.

Fixes: 0a2a464f8631 ("crypto: hisilicon/sec - fix the aead software fallback for engine")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 0a2f7c8b44fc..bbb6826ab256 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -2533,7 +2533,7 @@ static int sec_aead_soft_crypto(struct sec_ctx *ctx,
 	struct aead_request *subreq;
 	int ret;
 
-	subreq = aead_request_alloc(a_ctx->fallback_aead_tfm, GFP_KERNEL);
+	subreq = aead_request_alloc(a_ctx->fallback_aead_tfm, GFP_ATOMIC);
 	if (!subreq)
 		return -ENOMEM;
 
-- 
2.43.0

