Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FA618A6D4;
	Tue, 20 Aug 2024 08:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142532; cv=none; b=CiRT58xCOT8KeYTCLqCBDfweRbbFwts9FvSaXiDAV15sb+9MaupysSTIhhBmH3Kl62yWr7EdweumjwortWn5sASy2+9wm7Aaqffwmc2snf6mGxIrUTguQPz1XHcufikH1niVGWSQXDfUmbl58RnoxmB9gnXcUbJcSf08KcWjERM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142532; c=relaxed/simple;
	bh=4QNP3843NBR9NxsKvc5dE9E8/RarI0Ca3O06VMtyTBo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WDxSr/29tDGwC+qUFUHwuNGZhicNyqwB0PtDgJowdmERTnXuoZi0+Zx/R7kyJ89iOQJKzJeW0oSitRN3UEDSK4HU0IrmveqIbYRazHHULA5Cdrx+x5bXWGK6TRI9CsxUB2j4w9OyELGPpX2U7GfabRj9QquCRC5DjFUQ1IOUjqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Wp2cm6nrJzhXrg;
	Tue, 20 Aug 2024 16:26:48 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id F3E24180064;
	Tue, 20 Aug 2024 16:28:48 +0800 (CST)
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
Subject: [PATCH -next 4/6] crypto: ccp - Remove unused declaration sp_get_master()
Date: Tue, 20 Aug 2024 16:25:23 +0800
Message-ID: <20240820082525.259337-5-yuehaibing@huawei.com>
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
commit 720419f01832 ("crypto: ccp - Introduce the AMD Secure Processor
device").

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/crypto/ccp/sp-dev.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 0895de823674..6f9d7063257d 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -138,7 +138,6 @@ struct sp_device *sp_alloc_struct(struct device *dev);
 
 int sp_init(struct sp_device *sp);
 void sp_destroy(struct sp_device *sp);
-struct sp_device *sp_get_master(void);
 
 int sp_suspend(struct sp_device *sp);
 int sp_resume(struct sp_device *sp);
-- 
2.34.1

