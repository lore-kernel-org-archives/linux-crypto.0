Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2DB1F17E8;
	Fri, 19 Dec 2025 03:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766115386; cv=none; b=sAHrWPXEmRZJx4T/Q5TBsJug83P0SVICjW+2n137DHO4VxuLb/pJiL0//QO7gezMVCDMly805yPMbyKm2RMLEEY+ugHCYKKTZ71yQvHRFOfSYQ2H2bvY2vC9JKvxcpNZiYEswjjcqSfpwFMH5a7P+SrHGc0iv91pKGEbvjatEdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766115386; c=relaxed/simple;
	bh=zFpXXP7cU6IkB5MCQiEHuRwi8PYp09TwKsz5sIvDpbU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=K6hV+sTslLxDbRhUctKtfYCWZcqcShoRqIeJmoSwatExFxkVxJUonvzp0KlGLlp7WMF2YWgy1hPO9ZEF53eDs4V9pFnIFpOr3jtofGm2Drx/QeesQJuj//PdX+N332GTyCabWSci0iPo4YgB8/oDe/L3SRXX6GawNXEcPQPm6Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=kKkiDc2T; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="kKkiDc2T"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/UTMaJTAr4b4MOP9bjT6A9SSDWe8Bs4J6adAfBsWNGg=;
	b=kKkiDc2Thmebd1Lb1SDQVbGQNJKyxa+NjeHzuQpwQUUqzj1d+8TS6c4YMjsI0oGHSQecnaKu7
	nNsEvkn6oSK1VnCfUARO0jfssRnR3wPQOrxPgWKo/rnS32Iohx1xGL9hEEXPQ/BgD2TZ2hrRIOK
	z+jjP8shoi9BOtNhdwGYtGc=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dXY5m4KKyzKm5C;
	Fri, 19 Dec 2025 11:33:16 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 0AAD0140119;
	Fri, 19 Dec 2025 11:36:21 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 11:36:20 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 11:36:20 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<yuzenghui@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH] crypto: hisilicon/sgl - fix inconsistent map/unmap direction issue
Date: Fri, 19 Dec 2025 11:36:19 +0800
Message-ID: <20251219033619.1871450-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Ensure that the direction for dma_map_sg and dma_unmap_sg is
consistent.

Fixes: 2566de3e06a3 ("crypto: hisilicon - Use fine grained DMA mapping direction")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sgl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 24c7b6ab285b..d41b34405c21 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -260,7 +260,7 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev, struct scatterlist *sgl,
 	return curr_hw_sgl;
 
 err_unmap:
-	dma_unmap_sg(dev, sgl, sg_n, DMA_BIDIRECTIONAL);
+	dma_unmap_sg(dev, sgl, sg_n, dir);
 
 	return ERR_PTR(ret);
 }
-- 
2.33.0

