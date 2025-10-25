Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5E12EA744;
	Sat, 25 Oct 2025 10:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761387186; cv=none; b=LiCh/imlu3BKytawd2YWOVpHkiW7a27BdHviDMvDprkgDUzTJ3lv2PoqdMAfvWKIulBumMDFFEUxrvmcPROhHu5N4ZWO6bQdLJOvijQwekcXgOqHWmH3vrMX8b5CHCFDM0YmL/uQJTPj6yBmBrGtgMMg8CiX2UsvhVTqmg+zBLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761387186; c=relaxed/simple;
	bh=Dvn1o72U62CdSqo9ZyxTIhHzvNSKMh9CoVY2VL8+UtY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WKXo8UKxhw4ZduWTOn+xu6LaQTBHn+bA5KiXc89WkKEpjC/7VguamTvoT6voyhTsynHbZCJwDrwEwGaDmFcvkG7AKXU6EXPvZmNjPJ0t3thMV5tOv0qNZsO31MExcS1Z7xazfJqSKl5Uokbe9f6x8rOkrjtbk9bLSFnj+wyVGDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=6d5utqZi; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="6d5utqZi"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=04ySr9M3DOvDpWiPMzdKjL50HWC8oyWtjt0IA3JB2DM=;
	b=6d5utqZiVXI2ng7YvwRqMHqanJNv5EAJxNiiiuZIgd2UQdqyOO/uTABdDwhYmMLy8jC2Ef86n
	w4WYKDYmpd1bVZ3j47aOJvzKCZsGWh7y2M7iAZFY4KR5lbjle867OFjb1ctV8niUO/fDUDXGW/E
	oT4RLTj+ejp3JOJKp3Pn14w=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4ctwYt72WJzLlZ1;
	Sat, 25 Oct 2025 18:12:34 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 6CC2E1A0188;
	Sat, 25 Oct 2025 18:13:01 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:13:01 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:13:00 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <fanghao11@huawei.com>, <nieweiqiang@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon/sgl - remove unnecessary checks for curr_hw_sgl error
Date: Sat, 25 Oct 2025 18:12:57 +0800
Message-ID: <20251025101258.2793179-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251025101258.2793179-1-huangchenghai2@huawei.com>
References: <20251025101258.2793179-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: nieweiqiang <nieweiqiang@huawei.com>

Before calling acc_get_sgl(), the mem_block has already been
created. acc_get_sgl() will not return NULL or any other error.
so the return value check can be removed.

Signed-off-by: nieweiqiang <nieweiqiang@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sgl.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 7a9ef2a9972a..24c7b6ab285b 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -245,11 +245,6 @@ hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev, struct scatterlist *sgl,
 	}
 
 	curr_hw_sgl = acc_get_sgl(pool, index, &curr_sgl_dma);
-	if (IS_ERR(curr_hw_sgl)) {
-		dev_err(dev, "Get SGL error!\n");
-		ret = -ENOMEM;
-		goto err_unmap;
-	}
 	curr_hw_sgl->entry_length_in_sgl = cpu_to_le16(pool->sge_nr);
 	curr_hw_sge = curr_hw_sgl->sge_entries;
 
-- 
2.33.0

