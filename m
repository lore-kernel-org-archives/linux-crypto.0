Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7F72E54A2;
	Sat, 21 Mar 2026 07:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774076444; cv=none; b=XIxhwGMTWhyDa1MoexdJQ7dPuR/cmTeXei5bc54UkOsiMlheiH5GScKNMj+aGeaipHax16OkMLBBFogZZpIR0k0ihm50K6Pxn4Qi7poFu7zJJnjwhGgyc2XFeJCHeAU4SlLznvmmvzDnLULVGCbqtggfctYlBBazaRrNcv1xRew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774076444; c=relaxed/simple;
	bh=Hw/9wNhMIczfJ9HmMrPBR6G1rbXsM14mDMwtamhP+NE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KFrLdJVssMT3tnI3QkOk6qiatAKL+s/kgKTBjm8BstupS73gr5zWmWEogM4B/J9YyrPsP8BjLmLPxlx8t3VQimLl3YpTnOMcQAjNMxCo+HAWUQn9Sk0mlOZ5LErb57xe1QCuWEMBlTXMKCF7MU5oUxAxkmtcSEsbsOdC9WSYzUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Ml42oneU; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Ml42oneU"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ccjKJ5DSx0AZxwVSNJgOMAlQhUPKyRXRleTS5xa369g=;
	b=Ml42oneU5mmHXDSVdF4piBTMWZwrBiZLKMyvnOuOpvPnQHr1TZ9X9EWYLGNw/EIvze4lIqNms
	476EpGBtv6PNZQZlPyYA6nES2KHe6cDy5mBbRwFu8HMsG9Al2KEh4Erqi4c4KL2PeKmeYu+OP+r
	VJm31cLuBN6izld70VzTceA=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fd9DH1b4szpStX;
	Sat, 21 Mar 2026 14:55:11 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id EB55540561;
	Sat, 21 Mar 2026 15:00:39 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 21 Mar 2026 15:00:39 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 21 Mar 2026 15:00:39 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon/sec2 - prevent req used-after-free for sec
Date: Sat, 21 Mar 2026 15:00:38 +0800
Message-ID: <20260321070038.2023844-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Wenkai Lin <linwenkai6@hisilicon.com>

During packet transmission, if the system is under heavy load,
the hardware might complete processing the packet and free the
request memory (req) before the transmission function finishes.
If the software subsequently accesses this req, a use-after-free
error will occur. The qp_ctx memory exists throughout the packet
sending process, so replace the req with the qp_ctx.

Fixes: f0ae287c5045 ("crypto: hisilicon/sec2 - implement full backlog mode for sec")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 15174216d8c4..2471a4dd0b50 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -230,7 +230,7 @@ static int qp_send_message(struct sec_req *req)
 
 	spin_unlock_bh(&qp_ctx->req_lock);
 
-	atomic64_inc(&req->ctx->sec->debug.dfx.send_cnt);
+	atomic64_inc(&qp_ctx->ctx->sec->debug.dfx.send_cnt);
 	return -EINPROGRESS;
 }
 
-- 
2.33.0

