Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65582EC54F;
	Sat, 13 Sep 2025 10:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757761082; cv=none; b=CvOnYM4ZeC41nbX7t78XXm54OwH7Aegy8Qvxhk6vmrcS00mvegMYEzVyPoAERudhoiT7/uw0KmtF1FnxptE30d/W09+vAJDUqFO/5J3grhKWLqgIgf47a7ZuqATCfosrL/7npLQGdYDh0EcFvGacDGOvb1Pd3mjhzhh0OhOjCd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757761082; c=relaxed/simple;
	bh=tEoULR4TQVGBD33ZC7ngTEi1MtuRNy9fMIZTkALJd3w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8/7ky5zNjgHOQ21wqI76VtFWL+tU3iYrL+gEOlcTRatPPRzlmAFLCbqibQLev4gSrvRIALQZgU4Sf5E6J/r+lSZrLkc/q0ZskTIRFNRUSdeja+skZ23yjNTjUeMu/jtlOaaCHEquo75pVS5+kw2yGFtoTP+77QGv51IKjrTSQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cP7Tp50KSz2VRgc;
	Sat, 13 Sep 2025 18:54:38 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 84037180042;
	Sat, 13 Sep 2025 18:57:58 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:58 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:57 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 5/5] crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs
Date: Sat, 13 Sep 2025 18:57:54 +0800
Message-ID: <20250913105754.3862444-6-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250913105754.3862444-1-huangchenghai2@huawei.com>
References: <20250913105754.3862444-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

When the initialization of qm->debug.acc_diff_reg fails,
the probe process does not exit. However, after qm->debug.qm_diff_regs is
freed, it is not set to NULL. This can lead to a double free when the
remove process attempts to free it again. Therefore, qm->debug.qm_diff_regs
should be set to NULL after it is freed.

Fixes: 8be091338971 ("crypto: hisilicon/debugfs - Fix debugfs uninit process issue")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index 45e130b901eb..17eb236e9ee4 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -888,6 +888,7 @@ static int qm_diff_regs_init(struct hisi_qm *qm,
 		dfx_regs_uninit(qm, qm->debug.qm_diff_regs, ARRAY_SIZE(qm_diff_regs));
 		ret = PTR_ERR(qm->debug.acc_diff_regs);
 		qm->debug.acc_diff_regs = NULL;
+		qm->debug.qm_diff_regs = NULL;
 		return ret;
 	}
 
-- 
2.43.0

