Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3632318C005;
	Tue, 20 Aug 2024 08:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142539; cv=none; b=aRgeka7dMo6Mu0Cyddi4vJDBKgV52S5aWU9cPT7Mr6kvYeHBsiod1b8z5bt4ek9apS/rIcyOXY6NuV3yLcSREAMZoI8FGnQ/a/+Y9a9Q9c33E40h0igbRDaEqmz4b/CfmmoBNhuywH2tKdeRaP3Byrg7a1/GFc8f7EPMJRvT9cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142539; c=relaxed/simple;
	bh=l+gQcqS6r4WVGxU0tveksfUMjqzCz0MUkCahkMJEluo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0dqJVJmrmOWFEUEBN/BugicvIvEgrvLAxnG4ng6MygQdp2Q8k8far1jn3SCtntNz45L3v681Qk5CUa6GXE85kGHE/FAXdeJ3RcVESzIc6LuAurINgZCAepyUnl7I/YlTUvxVLq9OTHOcNnVsL1PqWgOVU9mUWoQHFs19wsbFd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Wp2fM5Z4fzyQFW;
	Tue, 20 Aug 2024 16:28:11 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 92893140137;
	Tue, 20 Aug 2024 16:28:49 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Aug
 2024 16:28:48 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<clabbe@baylibre.com>, <linus.walleij@linaro.org>, <atenart@kernel.org>,
	<arno@natisbad.org>, <bbrezillon@kernel.org>, <thomas.lendacky@amd.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-amlogic@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -next 5/6] crypto: amlogic - Remove unused declaration meson_enqueue()
Date: Tue, 20 Aug 2024 16:25:24 +0800
Message-ID: <20240820082525.259337-6-yuehaibing@huawei.com>
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
commit 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for
amlogic GXL").

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/crypto/amlogic/amlogic-gxl.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 1013a666c932..d68094ffb70a 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -150,8 +150,6 @@ struct meson_alg_template {
 #endif
 };
 
-int meson_enqueue(struct crypto_async_request *areq, u32 type);
-
 int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		     unsigned int keylen);
 int meson_cipher_init(struct crypto_tfm *tfm);
-- 
2.34.1

