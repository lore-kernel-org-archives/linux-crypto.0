Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A40823D1;
	Thu, 31 Oct 2024 03:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730345234; cv=none; b=ON70laLn2UAfyHG76GH4ensfc9piRkYE9J+o2HYPag+cDhyx+o+6MEnc9AisA2mT9vD5AYDStvW/ea7Zjm3rd18sWAycg4v0JHIVoiV7IR6TuQdWTSFovSn0oeIQmCfxPcuzrkWY41WH8Ma+kU+gNkxr0TptVrgjl1Kc+IlAfJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730345234; c=relaxed/simple;
	bh=ZV7KQ8m3LGjoHPUG65Ym7ZDnQQ53CamnRZGx/Mo6dME=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gULKRiu3y7hDJhjXCLQtRFmHztkdrzyiFe4tmZgXt62aL3KV6G2FWvAQ1FSqCMKJZC/xpA6VhY6Ybqkfkb/7dKFuncgH3tLIjWn8lKK1FLjBILDcxww28iDyFXZcdZANjRSCw5derEtZVcuEHi2bAaPtm5dUxPrbrnFprRgUXx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Xf8Yp1sSPz1ynsk;
	Thu, 31 Oct 2024 11:27:10 +0800 (CST)
Received: from kwepemf500004.china.huawei.com (unknown [7.202.181.242])
	by mail.maildlp.com (Postfix) with ESMTPS id 674FC140159;
	Thu, 31 Oct 2024 11:27:01 +0800 (CST)
Received: from lihuafei.huawei.com (10.90.53.74) by
 kwepemf500004.china.huawei.com (7.202.181.242) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 31 Oct 2024 11:27:00 +0800
From: Li Huafei <lihuafei1@huawei.com>
To: <pliem@maxlinear.com>, <atenart@kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lihuafei1@huawei.com>
Subject: [PATCH] crypto: inside-secure - Fix the return value of safexcel_xcbcmac_cra_init()
Date: Thu, 31 Oct 2024 19:27:55 +0800
Message-ID: <20241031112755.2949815-1-lihuafei1@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemf500004.china.huawei.com (7.202.181.242)

The commit 320406cb60b6 ("crypto: inside-secure - Replace generic aes
with libaes") replaced crypto_alloc_cipher() with kmalloc(), but did not
modify the handling of the return value. When kmalloc() returns NULL,
PTR_ERR_OR_ZERO(NULL) returns 0, but in fact, the memory allocation has
failed, and -ENOMEM should be returned.

Fixes: 320406cb60b6 ("crypto: inside-secure - Replace generic aes with libaes")
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index e17577b785c3..f44c08f5f5ec 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -2093,7 +2093,7 @@ static int safexcel_xcbcmac_cra_init(struct crypto_tfm *tfm)
 
 	safexcel_ahash_cra_init(tfm);
 	ctx->aes = kmalloc(sizeof(*ctx->aes), GFP_KERNEL);
-	return PTR_ERR_OR_ZERO(ctx->aes);
+	return ctx->aes == NULL ? -ENOMEM : 0;
 }
 
 static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
-- 
2.25.1

