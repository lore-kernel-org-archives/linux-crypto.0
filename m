Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2D718C348;
	Fri, 30 Aug 2024 10:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725013046; cv=none; b=TNe0n9FUFHFEKwmd21oeNCULOSGEPZQhLBkhwJscVoNEdh9iAJHwaS/XODenk5HywgpF/Xf6+PrYfgmDY8rsyFtlKFCvGD1NYs1G9b8GDf+AK3Ot90IBqWyeTV0HeGOoPox2Fc9/cq8RiI2IfXtLXTDBG2uQfeBYvKuRosQ9qZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725013046; c=relaxed/simple;
	bh=hUbjT7qj0ylI5uwOskrsSChPh/FbefLjixfh3uDGogk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rrqfjjY7IpCH7xvJjOC6oi66nG9rPNuigS0UrGKebik8QYVkigLx3Q1AX8q1EbXbBULKKScnJsDlX2a1ImQBh9ez+xxHC6x7MHOP3IEqSvI9mxA2KVvARTXqSbd292yJS6rRgPdcaLZftsoiZyrPMwDFZyw5/CoTkmeIyw0Chq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WwDbS1Gyqz1j7q0;
	Fri, 30 Aug 2024 18:17:08 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id D4E221400D7;
	Fri, 30 Aug 2024 18:17:21 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 30 Aug 2024 18:17:21 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <shenyang39@huawei.com>,
	<songzhiqi1@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<taoqi10@huawei.com>, <wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 3/3] crypto: hisilicon/trng - modifying the order of header files
Date: Fri, 30 Aug 2024 18:17:18 +0800
Message-ID: <20240830101718.3193159-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240830101718.3193159-1-huangchenghai2@huawei.com>
References: <20240830101718.3193159-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemd200024.china.huawei.com (7.221.188.85)

Header files is included Order-ref: standard library headers,
OS library headers, and project-specific headers. This patch
modifies the order of header files according to suggestions.

In addition, use %u to print unsigned int variables to prevent
overflow.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/trng/trng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index 451b167bcc73..66c551ecdee8 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 HiSilicon Limited. */
 
+#include <crypto/internal/rng.h>
 #include <linux/acpi.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
@@ -13,7 +14,6 @@
 #include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/random.h>
-#include <crypto/internal/rng.h>
 
 #define HISI_TRNG_REG		0x00F0
 #define HISI_TRNG_BYTES		4
@@ -121,7 +121,7 @@ static int hisi_trng_generate(struct crypto_rng *tfm, const u8 *src,
 	u32 i;
 
 	if (dlen > SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES || dlen == 0) {
-		pr_err("dlen(%d) exceeds limit(%d)!\n", dlen,
+		pr_err("dlen(%u) exceeds limit(%d)!\n", dlen,
 			SW_DRBG_BLOCKS_NUM * SW_DRBG_BYTES);
 		return -EINVAL;
 	}
-- 
2.33.0

