Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A796298CB2;
	Sat, 18 Jul 2026 03:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784343928; cv=none; b=e/+sPoK0rgEo2N7feVxcp5y2UwoAs9mv8lJFvXI+Ydm7ZTm7edIAHUWbFtFUU5o5epYvk3zu1nTVUW9OW4KpdC6R1Sxp+C/LUvf5DxZGBT0op74mGWDm9klJXNOwg75GlqhUXuTGPfWkwSVhhhVmfx073YuDz0NzWL5VtI+ZMOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784343928; c=relaxed/simple;
	bh=6ArKrhRDDezNd9VJBlOb9lsXXbapJuyed07oHb7ITXs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lryl6KnbjLZcpJ4VZvpsyvDlOuLAxrSmxrQ41GI6tJ4DYZsHRpUYvKXuIxcgJcrt3HhF5kOvHAJc4tFAvIR3zHKHUKUJRoaNSY/jGmpOGl801Ge0mNiAv+TPVmdL25O2uKfaQZ9q83pR/gU0S0cVm0V1ol//U34Q4AJDdR0Xa2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=EHF8GAFE; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="EHF8GAFE"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=emvvsj9fAag+teAYRsRI4fFCqIQmEElCOT1npoSd+TM=;
	b=EHF8GAFEdKLE0ZRFLYHRTYh5TAJ9cry1hI+PFXOi3YcvD9Fyq4QWGdjINI7MfFwoIR2z3+kYJ
	qEeXAcznerPWag0biMqZUrlzuAlBnBarzAugRs3TArJiLmIETYKb3Qm1jFfgh6FTQvwO/ob1ZHj
	zhOid/hMsnlpw0OOw382Qzs=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4h2BHk36LfzpStj;
	Sat, 18 Jul 2026 10:56:18 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D69F44056E;
	Sat, 18 Jul 2026 11:05:15 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Jul 2026 11:05:15 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Jul 2026 11:05:15 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 2/2] crypto: hisilicon/sec2 - remove unused sec_ctx.hlf_q_num
Date: Sat, 18 Jul 2026 11:05:13 +0800
Message-ID: <20260718030513.3809002-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260718030513.3809002-1-huangchenghai2@huawei.com>
References: <20260718030513.3809002-1-huangchenghai2@huawei.com>
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

hlf_q_num is set but never read; drop the field and its assignment.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        | 3 ---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index adf95795dffe..c12a39a8a9d4 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -181,9 +181,6 @@ struct sec_ctx {
 	const struct sec_req_op *req_op;
 	struct hisi_qp **qps;
 
-	/* Half queues for encipher, and half for decipher */
-	u32 hlf_q_num;
-
 	/* Current cyclic index to select a queue for encipher */
 	atomic_t enc_qcyclic;
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 5c2b9f710be0..01eb76f616fc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -669,7 +669,6 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	sec = container_of(ctx->qps[0]->qm, struct sec_dev, qm);
 	ctx->sec = sec;
 	ctx->dev = &sec->qm.pdev->dev;
-	ctx->hlf_q_num = sec->ctx_q_num >> 1;
 
 	ctx->pbuf_supported = ctx->sec->iommu_used;
 	if (sec->qm.ver < QM_HW_V3)
-- 
2.43.0

