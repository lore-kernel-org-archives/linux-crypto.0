Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106AD340A7F;
	Fri, 11 Sep 2026 10:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122591; cv=none; b=GsbTESLi5AmaSLEW0f4hDY6FyMasyCT5liVjNiQss69j9Xzm21zqm8BdApGqsjBENXFpXwdSfsK/TIntvfIu3HTp0yySH8nou1NomguN2fpk21F10/Ung7ULu9kMkL7hi41eODmYjWJyYRVC9h4zIBO8EQgGCmvx0XfXLCtEK/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122591; c=relaxed/simple;
	bh=IrKWIJ7QMNC5hE6Fm3l0kETZfyC10H9hmqoDCwbKpQo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y1gKPCIvhQO2GY03fMC5VAiQuyooBsJIix+tDV1JGbhO7PngQVgYi0i4o65PT1/3Gh5HqYY7ibRW19pDR2GlADUc9v+LpXb20PzHCC5/9QMIm3uBWdVbAhBGVE6nj2E5XwpfsUZviuzx4FS+vykxrLOXUKNX4NlnHMg47Ff2CGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=M7XkN2OI; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="M7XkN2OI"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mB3uXMOP0bJMj505X9gNfPZ7qfnx0MMTWbOtcjOZDJA=;
	b=M7XkN2OIYLEeMAaNj394Z1UhR7g86SFkIEjYmOKXsIpaIBqzhDRn24jv2gjW6sgYbkW/GwXiP
	zDopKVaDYzRUNFNT4P4EQH1GenmOh2y1a+mMOBzWO4nnSTe/sSXN5jdY4H/3OPOONOuNz77RwSg
	iH2hzwTNC/u679LSdmyDQbg=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hh9W01qRJzRhQs;
	Fri, 11 Sep 2026 18:18:52 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 821A840537;
	Fri, 11 Sep 2026 18:29:45 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 11 Sep 2026 18:29:44 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 1/4] crypto: hisilicon/qm - fix devm_kcalloc argument order
Date: Fri, 11 Sep 2026 18:29:39 +0800
Message-ID: <20260911102942.387778-2-huangchenghai2@huawei.com>
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

The n and size arguments of devm_kcalloc in qm_pre_store_caps() are
swapped. Fix the order to match the kcalloc(n, size, flags) convention.

Fixes: 7c234e138c67 ("crypto: hisilicon/qm - replace devm_kzalloc with devm_kcalloc")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c01966a4a33f..e915cacef5c0 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5732,7 +5732,7 @@ static int qm_pre_store_caps(struct hisi_qm *qm)
 	size_t i, size;
 
 	size = ARRAY_SIZE(qm_cap_query_info);
-	qm_cap = devm_kcalloc(&pdev->dev, sizeof(*qm_cap), size, GFP_KERNEL);
+	qm_cap = devm_kcalloc(&pdev->dev, size, sizeof(*qm_cap), GFP_KERNEL);
 	if (!qm_cap)
 		return -ENOMEM;
 
-- 
2.43.0

