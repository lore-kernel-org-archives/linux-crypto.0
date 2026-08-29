Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCC835C69E;
	Sat, 29 Aug 2026 09:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787996973; cv=none; b=JdMIEaxH3FoVGcrSpSoqnzaAztL2zNlGsd0YX6UXqi5wYlaq1JzQKQD/E8GwetQdUIPFXCNZZoD7RhnhBZ5zpQVoTs7GGx6p0EjQlw/eS7JMRt6TqTlSFVoF/c3gh1teEphNdq1MedwolZ552p1uQUAgqFXhs29y2fuWPAyej64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787996973; c=relaxed/simple;
	bh=mf0nw60dGKb8Wlo2I5kUlLo5yPxvNu0fpugcs+pgkxE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dbhh4jynUmB7U+9bT9ppgClmVt6P9j+A8nbmWHATwOs1Xuwu0RhO8Ix0ggHPWeAKx6WtEE9nkJASpxbtGq5/XCHvb1EZiswt0NGArGOniSLFgVGdp0g4Y27NBqUM1uLOvKWuZIxk8PZKcUN5a+f8VS0ioUwKj1xSs6O2fGFvG/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=L5ckq+ED; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="L5ckq+ED"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=w2lwvObpes5WXP7OnRLwWjlTCcoX59peKlzhnmLYZMw=;
	b=L5ckq+EDi5v6x++7Xt33v1DJelVC4Nxc8Ulziodsw5bx1Rg5zOtsIoV83GXOj/NKfrpPChR9r
	rX7u9XYhyJ2Hp6d4Rbb1RaqbIN7jH2I685gqh1AujPFoyLeFjDX46qY3XcmXB84xlD005FOjslx
	8YClPp1KHgVFWw5d+QlnBEs=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hX9DZ2S2GzmV91;
	Sat, 29 Aug 2026 17:38:38 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 0514C40586;
	Sat, 29 Aug 2026 17:49:26 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 17:49:25 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<lizhi206@huawei.com>
Subject: [PATCH] crypto: hisilicon/zip - enable auto clock gating for DAE
Date: Sat, 29 Aug 2026 17:49:24 +0800
Message-ID: <20260829094924.2191402-1-huangchenghai2@huawei.com>
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
 whupemk200001.china.huawei.com (7.152.184.93)

From: lizhi <lizhi206@huawei.com>

Enable auto clock gating for the DAE module. The clock gating
is enabled after DAE initialization is completed, so the device
can reduce power consumption when idle.

Signed-off-by: lizhi <lizhi206@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/zip/dae_main.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/dae_main.c b/drivers/crypto/hisilicon/zip/dae_main.c
index 68aebd02fc84..57ea836a265e 100644
--- a/drivers/crypto/hisilicon/zip/dae_main.c
+++ b/drivers/crypto/hisilicon/zip/dae_main.c
@@ -39,6 +39,8 @@
 #define DAE_AM_RETURN_MASK		0x3
 #define DAE_AXI_CFG_OFFSET		0x331000
 #define DAE_AXI_SHUTDOWN_EN_MASK	(BIT(0) | BIT(5))
+#define DAE_AUTO_CG_EN_OFFSET		0x331070
+#define DAE_AUTO_CG_EN_MASK		(~(BIT_ULL(4) | BIT_ULL(18) | BIT_ULL(19)))
 
 struct hisi_dae_hw_error {
 	u32 int_msk;
@@ -61,6 +63,17 @@ static inline bool dae_is_support(struct hisi_qm *qm)
 	return false;
 }
 
+static void hisi_dae_set_clock_gating(struct hisi_qm *qm, bool enable)
+{
+	if (qm->ver < QM_HW_V5)
+		return;
+
+	if (enable)
+		writeq(DAE_AUTO_CG_EN_MASK, qm->io_base + DAE_AUTO_CG_EN_OFFSET);
+	else
+		writeq(0, qm->io_base + DAE_AUTO_CG_EN_OFFSET);
+}
+
 int hisi_dae_set_user_domain(struct hisi_qm *qm)
 {
 	u32 val;
@@ -69,16 +82,22 @@ int hisi_dae_set_user_domain(struct hisi_qm *qm)
 	if (!dae_is_support(qm))
 		return 0;
 
+	hisi_dae_set_clock_gating(qm, false);
+
 	val = readl(qm->io_base + DAE_MEM_START_OFFSET);
 	val |= DAE_MEM_START_MASK;
 	writel(val, qm->io_base + DAE_MEM_START_OFFSET);
 	ret = readl_relaxed_poll_timeout(qm->io_base + DAE_MEM_DONE_OFFSET, val,
 					 val & DAE_MEM_DONE_MASK,
 					 DAE_REG_RD_INTVRL_US, DAE_REG_RD_TMOUT_US);
-	if (ret)
+	if (ret) {
 		pci_err(qm->pdev, "failed to init dae memory!\n");
+		return ret;
+	}
 
-	return ret;
+	hisi_dae_set_clock_gating(qm, true);
+
+	return 0;
 }
 
 int hisi_dae_set_alg(struct hisi_qm *qm)
-- 
2.43.0

