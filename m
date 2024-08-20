Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5711318A6D8;
	Tue, 20 Aug 2024 08:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142532; cv=none; b=o9HbwrsvCnD9LJq/GG45JongCRo5ko+MoQMNO82gEjrDjcq8BfHDdEt7wN95dijUJm7ny0xh//o7PqJ7bv9jhAKO71eS5EF9tGS4FZjqXmN31N68FHwY2ytE3XHaH9wkUkZ26T4TN0y8lAf1grulut9BOSX4RUMYqEs7fbdG/1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142532; c=relaxed/simple;
	bh=GnBE83ogxptNqN3qk1qSXr/i6YdvpjUpIxegeCnb+vc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCtiaSjnvMzCgAFkt0wtfQ3Geb2EO8NDGVap7K6PotU/Q6s+ra6NPfY48EYCuhvViGTWp0WzyuqG8ui3IOp5fg5zBskTbT1IBGFxpXt6XkYdZsi4qajKZAsVAJrGmazwzpckhZVAfraxBd6RyFaSBOqCVE0IYoecIOuSE1j1qz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wp2cl57N4zhXhp;
	Tue, 20 Aug 2024 16:26:47 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id BCEC71800A1;
	Tue, 20 Aug 2024 16:28:47 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Aug
 2024 16:28:47 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<clabbe@baylibre.com>, <linus.walleij@linaro.org>, <atenart@kernel.org>,
	<arno@natisbad.org>, <bbrezillon@kernel.org>, <thomas.lendacky@amd.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-amlogic@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -next 2/6] crypto: sl3516 - Remove unused declaration sl3516_ce_enqueue()
Date: Tue, 20 Aug 2024 16:25:21 +0800
Message-ID: <20240820082525.259337-3-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820082525.259337-1-yuehaibing@huawei.com>
References: <20240820082525.259337-1-yuehaibing@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500002.china.huawei.com (7.185.36.57)

This function is never implemented and used since introduction in
commit 46c5338db7bd ("crypto: sl3516 - Add sl3516 crypto engine")

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/crypto/gemini/sl3516-ce.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce.h b/drivers/crypto/gemini/sl3516-ce.h
index 9e1a7e7f8961..56b844d0cd9c 100644
--- a/drivers/crypto/gemini/sl3516-ce.h
+++ b/drivers/crypto/gemini/sl3516-ce.h
@@ -326,8 +326,6 @@ struct sl3516_ce_alg_template {
 	unsigned long stat_bytes;
 };
 
-int sl3516_ce_enqueue(struct crypto_async_request *areq, u32 type);
-
 int sl3516_ce_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			 unsigned int keylen);
 int sl3516_ce_cipher_init(struct crypto_tfm *tfm);
-- 
2.34.1

