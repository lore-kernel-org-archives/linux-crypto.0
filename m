Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871172AF1D;
	Sat, 17 Jan 2026 10:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768645095; cv=none; b=CsbD5v1cuKbFG4FJ7Xshp5LIb+OxVQwayOXfO8GlJYV9p8xUDfLUCEG/Lw5e29TkMTyFTQVsMKFwXrhFhyYxs1kvVC12k8fn158pCayhpzPQzoaHNLO7o13BrHPUMkTYzC7ctJwL42FmExt8+00IVhtjYOmrQWUZHLh9CgIRaGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768645095; c=relaxed/simple;
	bh=BJVbyWOA+j0i2Rk7nSVAaqdwldI7WS4lQR6iKpnGcVk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ap/dMez2z7F1LKy8w6UK0cY6RHDNy+syXsFIj6e8PZALrx6f17ds56WrewITSZXCt6JPd7rDUnfDdTOPyEbGJx+0UwmI+kMNFVUh+wsoU7PVZ3gO3QKDlCRCAZuc5A4k/NFD5Kr40oV4KChlpgwgCAmxXnHJS1sVXSR/4vXS1Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=4xHhsV/9; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="4xHhsV/9"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MsIWqJASqMqIr/uzMIQ8zwSd5DhPTPgNnwliRnUhuw4=;
	b=4xHhsV/9Mjo+CjrwwRKce4KLLdp4ytBFmq6zWNsIhf8XgMOKsLgeE0yd2T4B8/0PAcc9SDkaX
	Z7AFeQ6o6je8oGKtWqEfLxDPo92vLDrRZzChk4Dgc5Xi3kF8Ze671PeOvAbxoYXlPsJyRNuvqqa
	gCfkHW78//oUzBDSIuYN4sk=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dtXcv6Y2gz12LFm;
	Sat, 17 Jan 2026 18:14:07 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 94F0240569;
	Sat, 17 Jan 2026 18:18:08 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 18:18:08 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 18:18:07 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH 2/4] crypto: hisilicon/qm - remove unnecessary code in qm_mb_write()
Date: Sat, 17 Jan 2026 18:18:04 +0800
Message-ID: <20260117101806.2172918-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260117101806.2172918-1-huangchenghai2@huawei.com>
References: <20260117101806.2172918-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Weili Qian <qianweili@huawei.com>

Since the HiSilicon accelerator is used only on the
ARM64 architectures, the implementations for other
architectures are not needed, so remove the unnecessary code.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 49c1c78ff600..2bb94e8c6a07 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -596,19 +596,9 @@ EXPORT_SYMBOL_GPL(hisi_qm_wait_mb_ready);
 /* 128 bit should be written to hardware at one time to trigger a mailbox */
 static void qm_mb_write(struct hisi_qm *qm, const void *src)
 {
-	void __iomem *fun_base = qm->io_base + QM_MB_CMD_SEND_BASE;
-
-#if IS_ENABLED(CONFIG_ARM64)
-	unsigned long tmp0 = 0, tmp1 = 0;
-#endif
-
-	if (!IS_ENABLED(CONFIG_ARM64)) {
-		memcpy_toio(fun_base, src, 16);
-		dma_wmb();
-		return;
-	}
-
 #if IS_ENABLED(CONFIG_ARM64)
+	void __iomem *fun_base = qm->io_base + QM_MB_CMD_SEND_BASE;
+	unsigned long tmp0, tmp1;
 	/*
 	 * The dmb oshst instruction ensures that the data in the
 	 * mailbox is written before it is sent to the hardware.
-- 
2.33.0

