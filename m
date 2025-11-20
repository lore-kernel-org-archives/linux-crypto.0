Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB669372AD8;
	Thu, 20 Nov 2025 13:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763644893; cv=none; b=m3+A6c0d+M+ZDx5uLVBC+Xyx/Kk0BDhPWfTTfxlcomDn38ds6mVJzR//Ch0nL50H07ZTRBbFrWpj85rU9AWYBaS++4Vn+ITZB+2dVQJLJCfT6gF8dUg8/oIoPMQ1kHaBLM3vce23InElTRkah3LaclCRVk/DMqHl8DBfwLpdP/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763644893; c=relaxed/simple;
	bh=EGAJmfNABAJZ/aTR5JJfUbbsyzvWxPMbC/KsM//JTVA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VOn8TtVZClmTPUGaPJxlB8VbcVlixX3WbI/SaWXwy5zXTLU5199gBhQG+dlF4C06g4DZpTel6Z4/RsqsH969wq18iT1KT0X3aU0iYE/pJhPhDo7VmivLBTdKHCWppy2V1OqHTLor6qhMmE0LFKKRYgj1eJXJ8M1TVyOBsgyKANw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=y+htPCVH; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="y+htPCVH"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KU5q0xHZlC5umw1PzPbWqyaghdMkTa7ujFvADo3xQnw=;
	b=y+htPCVHQtoNC20P9eBuFqh4bLNt3jXOyadOL10/Xb6BKLw/3yjggAevlEMOdGtQpy+oQB/zk
	vM5bo3TMLfFfqqS8Ux+nTJgNyJTCOMlQF29JFinbcck/aVawUEutMdb5nmMuHiFFayjYIPHlPKk
	J2O4nElRQpiLMj8gl+t+98U=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dBzV70rFfz12LDg;
	Thu, 20 Nov 2025 21:19:59 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1908318046F;
	Thu, 20 Nov 2025 21:21:26 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Nov 2025 21:21:25 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Nov 2025 21:21:25 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon/qm - fix incorrect judgment in qm_get_complete_eqe_num()
Date: Thu, 20 Nov 2025 21:21:24 +0800
Message-ID: <20251120132124.1779549-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)

In qm_get_complete_eqe_num(), the function entry has already
checked whether the interrupt is valid, so the interrupt event
can be processed directly. Currently, the interrupt valid bit is
being checked again redundantly, and no interrupt processing is
performed. Therefore, the loop condition should be modified to
directly process the interrupt event, and use do while instead of
the current while loop, because the condition is always satisfied
on the first iteration.

Fixes: f5a332980a68 ("crypto: hisilicon/qm - add the save operation of eqe and aeqe")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8533384e3eaa..56bbb46f1877 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -991,7 +991,7 @@ static void qm_get_complete_eqe_num(struct hisi_qm *qm)
 		return;
 	poll_data = &qm->poll_data[cqn];
 
-	while (QM_EQE_PHASE(dw0) != qm->status.eqc_phase) {
+	do {
 		poll_data->qp_finish_id[eqe_num] = dw0 & QM_EQE_CQN_MASK;
 		eqe_num++;
 
@@ -1004,11 +1004,10 @@ static void qm_get_complete_eqe_num(struct hisi_qm *qm)
 			qm->status.eq_head++;
 		}
 
-		if (eqe_num == (eq_depth >> 1) - 1)
-			break;
-
 		dw0 = le32_to_cpu(eqe->dw0);
-	}
+		if (QM_EQE_PHASE(dw0) != qm->status.eqc_phase)
+			break;
+	} while (eqe_num < (eq_depth >> 1) - 1);
 
 	poll_data->eqe_num = eqe_num;
 	queue_work(qm->wq, &poll_data->work);
-- 
2.33.0

