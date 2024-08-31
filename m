Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFED5170A24;
	Sat, 31 Aug 2024 09:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725097817; cv=none; b=bCtG01eNHT2Ry4eP8bvs6Kcoggu2NAHijSBNvJziYpfjQaiDnCSNPkTchuwfKl3SybR8GY9UsnruInX8i3ntKOa0S6il/T0ZLk6vtWuviuLyJ/2u39K2hVZoe86paYsA9mTh4jtL5KFkJQjSmczWnDYnV7Z3uijWW20GDm1YYhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725097817; c=relaxed/simple;
	bh=hUbjT7qj0ylI5uwOskrsSChPh/FbefLjixfh3uDGogk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qSLJjvYzraqRv9WCx75dCKO1n9IlJ54crRwn70cj3fqA7XFnsvoq0uOXkTBijCBmYYaiO8VWHz7Tru6sCANmSnfarCCCyWqO6Z1EdSecBKTq1m4vh9l8IdgQIaTDxUTuhZPXym5eOSkPtQGVIuXPCJ26n6UqtOFSetN8lqeYqnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wwqww0qmDzyQxg;
	Sat, 31 Aug 2024 17:49:20 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 728A1140137;
	Sat, 31 Aug 2024 17:50:12 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 31 Aug 2024 17:50:11 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <shenyang39@huawei.com>,
	<songzhiqi1@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<taoqi10@huawei.com>, <wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH v2 3/3] crypto: hisilicon/trng - modifying the order of header files
Date: Sat, 31 Aug 2024 17:50:09 +0800
Message-ID: <20240831095009.446780-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240831095009.446780-1-huangchenghai2@huawei.com>
References: <20240831095009.446780-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

