Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796F418A952;
	Tue, 20 Aug 2024 08:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142534; cv=none; b=RmLQuU6m0fxjbMkrl+U41/QXtp0MPXJ5gQKyb6qX7CoUdmge5i1bkYZ9NQC5yURGoSAYxvNPq7W9abhg5qZlijcy7DAJ3XxtYRzTzl1Jbzv1J3TQIW7g5Mrm9YOEO9ZvbMIL44L5HT2JKwvwoA0oObbN7dUWT2bs/t1kDQYe1Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142534; c=relaxed/simple;
	bh=nrZZkpD8nwrB94I0EhpSnSVF4/Bo7frwfEnSpZvY5/0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CSHrDBnYpvoYa+rljsAvfDS13iEfOKdmhSpmkHl1YE7WD1rXzX3ugVKWKABYwhcN+oheRvVbRYYMuJbicLIv9TdM90PyeNjALDufhXV4KJL8Blk11538oT10ZP1pGlhxvSq4QSk4zjb6Ns3z3hK5ZqkXDiPkY52XVu/eGs0yM38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wp2dN3bDjzpTSv;
	Tue, 20 Aug 2024 16:27:20 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 37764180106;
	Tue, 20 Aug 2024 16:28:50 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Aug
 2024 16:28:49 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<clabbe@baylibre.com>, <linus.walleij@linaro.org>, <atenart@kernel.org>,
	<arno@natisbad.org>, <bbrezillon@kernel.org>, <thomas.lendacky@amd.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-amlogic@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -next 6/6] crypto: crypto4xx - Remove unused declaration crypto4xx_free_ctx()
Date: Tue, 20 Aug 2024 16:25:25 +0800
Message-ID: <20240820082525.259337-7-yuehaibing@huawei.com>
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
commit 049359d65527 ("crypto: amcc - Add crypt4xx driver").

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/crypto/amcc/crypto4xx_core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 96355d463b04..3adcc5e65694 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -149,7 +149,6 @@ struct crypto4xx_alg {
 
 int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size);
 void crypto4xx_free_sa(struct crypto4xx_ctx *ctx);
-void crypto4xx_free_ctx(struct crypto4xx_ctx *ctx);
 int crypto4xx_build_pd(struct crypto_async_request *req,
 		       struct crypto4xx_ctx *ctx,
 		       struct scatterlist *src,
-- 
2.34.1

