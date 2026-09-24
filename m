Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF98387590;
	Thu, 24 Sep 2026 11:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249900; cv=none; b=s35XKYauxFtfzySQ4wmVmXw2RTUhzUApWemriu9vUW0j1C/B0/lZ+8CEqOa4bsiCsyoqL62M9teEUJeFJt1ioqgH48ZO2zuajLLbDAW19l7gIKAXcn1gIrmFDgU0nhboJcI6091nIabTV4NYenexq/0cTY01jSpuS/a+QVbpdDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249900; c=relaxed/simple;
	bh=cArwOMRsX9D1spQWCL22iPkCpGBGLK0f+OjAUiVOvns=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uS+jrU5ibLESOKXtgWwMf3jlWEdrRGageq9VGOKZLG2FWMBA6ULEtnW9+StJ+TuvTkd1IPgV12R0lsn2iWrncX3HZFgzDYeUwVN/SzM/kjk6EbMc5/LkzqDld4834YVSxd7WRE8Yn+RP2xlt5xKaQ9WYg8MGATOLfK7hWtHmcaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=d1Kyahw8; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="d1Kyahw8"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kGS4uHMAer8y/uTOn2U71mx+vyJJtnCousScD/utc28=;
	b=d1Kyahw8C7lY0uA0AvbXVm2wbF7N5NAUeMQ6eHrh5nYc68INsTDOSiX4RlZwfjooZYawHMyKa
	v7KBza5R5IU+FBTfp7keCpgi2fE5v/qztiG+XAdnfCfa3Qy61d+qXWyM3/g1kFts7bHoXn1bu0w
	Uq+SzbJXJJqLdqUKM0YOApo=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hrBNc4gZmz1K97G;
	Thu, 24 Sep 2026 19:26:08 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id D839E40588;
	Thu, 24 Sep 2026 19:38:14 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 19:38:14 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 4/4] crypto: hisilicon/qm - fix uacce leak when SVA is not supported
Date: Thu, 24 Sep 2026 19:38:12 +0800
Message-ID: <20260924113812.1110302-5-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924113812.1110302-1-qianweili@huawei.com>
References: <20260924113812.1110302-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200011.china.huawei.com (7.202.181.237)

In qm_alloc_uacce(), when SVA is not supported, the error path calls
qm_remove_uacce(qm). But qm->uacce is not yet assigned and qm->use_sva
is still false, so qm_remove_uacce() returns without releasing the
uacce device, causing a memory leak.

Call uacce_remove(uacce) on the local variable instead.

Fixes: cd0ac51c5760 ("crypto: hisilicon/qm - define the device isolation strategy")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index f310edfc16cf..096f0b40b82a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2968,7 +2968,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 		qm->use_sva = true;
 	} else {
 		/* only consider sva case */
-		qm_remove_uacce(qm);
+		uacce_remove(uacce);
 		return -EINVAL;
 	}
 
-- 
2.43.0

