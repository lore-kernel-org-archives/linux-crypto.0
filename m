Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E733E63B0;
	Thu, 28 May 2026 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779969429; cv=none; b=q+hq+JM43TGZ8MJASFGXq7aLbOlgJ6GXKpx3dXgw0vpP042Wv6P0dlBzKBtXp/00uNErudNt11pBjPi5t9YSR16Yxi04daWzXAU/9ZHwxROPPRSPgubfgtWd/wX5mta/bNDTba2hSAsxoNTVgZ6AwUw1HUkAAeIckemC+nNY3+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779969429; c=relaxed/simple;
	bh=CTKsOYBm+dZ0jgubaGAgEnesc/r6pPBNE0/yQFcxD04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XYyEkOBLxVQaf4vaMKaI1mkPmrIZpv9SJVXZEfTo2MoH4JTTgeei2Si4OiUdt5SJ7OCw09h6lEyrGGuuIxJdhpkwwumsc0jp+FBQN+nV572lVOZJPQaX+v4Rso5cT3b989vyVb5MgDvawbpOr2UOoCfglvmdeU3avo8lB9uhI/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Be0mZgAR; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Be0mZgAR"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Z9lmzN2hR+Ho9oAHe7qgbHF3jtKXRWlqmP/JtNwt4vQ=;
	b=Be0mZgAR5foNKeK3M4vEInX2On4t+Y6Fs33YhOuqJJXIj1Ujk894xSoZ/htxI11wf3DNHlpxj
	ociIbZC5SsEpTWaAYW7KtVADseqYSrMJrvGaYgzYJLs3mFpxKLNQ+/0TYJrnqTnYREQBuaSI1PE
	kSFJyrBs+laIjWO8Fq1MG4o=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gR4XY2BDPzpSw0;
	Thu, 28 May 2026 19:49:33 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 5761C4048F;
	Thu, 28 May 2026 19:57:01 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 28 May 2026 19:57:00 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH v2 4/5] crypto: hisilicon/sec2 - fix resource leakage issues in non-backlog mode
Date: Thu, 28 May 2026 19:55:30 +0800
Message-ID: <20260528115531.174593-5-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260528115531.174593-1-wuzongyu1@huawei.com>
References: <20260528115531.174593-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: Wenkai Lin <linwenkai6@hisilicon.com>

The problem that resources are not released in non-backlog mode is fixed.
There are three cases:
1. If the device is abnormal, the send function returns EAGAIN and
prints an error log.
2. If the device queue is full, the send function returns ENOSPC and
does not print anything.
3. The task is sent normally, and EINPROGRESS is returned.

In addition, the step of switching to software computing is deleted so that
the caller can correctly handle the actual situation.

Fixes: f0ae287c5045 ("crypto: hisilicon/sec2 - implement full backlog mode for sec")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 62125cf1f849..901abe8761e5 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -345,6 +345,9 @@ static int sec_alg_send_message_retry(struct sec_req *req)
 		ret = qp_send_message(req);
 	} while (ret == -EBUSY && ctr++ < SEC_RETRY_MAX_CNT);
 
+	if (ret == -EBUSY)
+		return -ENOSPC;
+
 	return ret;
 }
 
@@ -1983,14 +1986,11 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 		sec_update_iv(req, ctx->alg_type);
 
 	ret = ctx->req_op->bd_send(ctx, req);
-	if (unlikely((ret != -EBUSY && ret != -EINPROGRESS))) {
+	if (likely(ret == -EINPROGRESS || ret == -EBUSY))
+		return ret;
+	else if (ret != -ENOSPC)
 		dev_err_ratelimited(ctx->dev, "send sec request failed!\n");
-		goto err_send_req;
-	}
 
-	return ret;
-
-err_send_req:
 	/* As failing, restore the IV from user */
 	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && !req->c_req.encrypt) {
 		if (ctx->alg_type == SEC_SKCIPHER)
@@ -2005,12 +2005,6 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 
 err_uninit_req:
 	sec_request_uninit(req);
-	if (ctx->alg_type == SEC_AEAD)
-		ret = sec_aead_soft_crypto(ctx, req->aead_req.aead_req,
-					   req->c_req.encrypt);
-	else
-		ret = sec_skcipher_soft_crypto(ctx, req->c_req.sk_req,
-					       req->c_req.encrypt);
 	return ret;
 }
 
-- 
2.33.0

