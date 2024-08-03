Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468D12AEEA
	for <linux-crypto@vger.kernel.org>; Sat,  3 Aug 2024 06:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722667775; cv=none; b=Rg42cs1/GL5W286s519u3QmxO4vxVX7VP/1owX+XSpIjNheLXNrQ7QI2+j0b2WKGJqyNkzn95CaUnyuJDdQ1OeLx3HpX8KrllRiKGx1LIvLqyJMtgoQ7Arlo8L0WFZOon21tDqVtzZpk/7iwVtDT76SgjLx+KTWE8vF90Ck0Bfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722667775; c=relaxed/simple;
	bh=CKzhz5VIN2allRlAJY2DUZDEzHoDTkOKHaj+MmAIH9U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rd9y+jzPHG4IVOysA9/AEecPtQFzKzg6nCh4nwFm6Kc0M6z052Vh4B6DJyj5ddF8mOZGdsOG9YfKSIKHWVyIoYEj0RrE2lZYUMTEceNQyZoNhtlBQ2mAWtV2aBLYOJuLfEJEqyI6jRq5HVH9Hrqm3H/2sudsJigJd7995IgrE+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WbYFy6S1Rz1L9dg;
	Sat,  3 Aug 2024 14:49:10 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id E7D701400DC;
	Sat,  3 Aug 2024 14:49:25 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 3 Aug 2024 14:49:25 +0800
From: Gaosheng Cui <cuigaosheng1@huawei.com>
To: <olivia@selenic.com>, <herbert@gondor.apana.org.au>,
	<florian.fainelli@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
	<rjui@broadcom.com>, <sbranden@broadcom.com>, <hadar.gat@arm.com>,
	<cuigaosheng1@huawei.com>, <alex@shruggie.ro>, <aboutphysycs@gmail.com>,
	<wahrenst@gmx.net>, <robh@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <linux-rpi-kernel@lists.infradead.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -next 2/2] hwrng: cctrng - Add missing clk_disable_unprepare in cctrng_resume
Date: Sat, 3 Aug 2024 14:49:23 +0800
Message-ID: <20240803064923.337696-3-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240803064923.337696-1-cuigaosheng1@huawei.com>
References: <20240803064923.337696-1-cuigaosheng1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemd200011.china.huawei.com (7.221.188.251)

Add the missing clk_disable_unprepare() before return in
cctrng_resume().

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/char/hw_random/cctrng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index c0d2f824769f..4c50efc46483 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -622,6 +622,7 @@ static int __maybe_unused cctrng_resume(struct device *dev)
 	/* wait for Cryptocell reset completion */
 	if (!cctrng_wait_for_reset_completion(drvdata)) {
 		dev_err(dev, "Cryptocell reset not completed");
+		clk_disable_unprepare(drvdata->clk);
 		return -EBUSY;
 	}
 
-- 
2.25.1

