Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129C4298CCD;
	Fri, 18 Jul 2025 10:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752833108; cv=none; b=ndZGWZZ+5OoE2oyJkrzXwaKlUWQIe280KOr+M6sQXyKemx/PjAbyzI29BfwzLnMSI1RypVxiBzhrMimVwF+KrtXAm7fK8RsNYV+cto0vPGZJsnEqc8iP3zwQx9KxEZ3UXEAV9T3rKujw7/4HE48t2qcvukzpW6h8QOyst8fpuIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752833108; c=relaxed/simple;
	bh=opzYsw8eEUMPf16qMwu4Z0WFNE3lxSAKi7KF8TfEpTk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nZtHpeq/ObsRo68FpmBN2Id8cxW00HAOXNo1E1UDTsPoY93UExBmCQhNqEyZwxMWpCbBeGmARz7WgjN5jt6cM85IEnqLYb+6q5ipLo/AXtVOoOo81TOHK2P+vsHcKLElBCS1TqsRIbsFgn/04JwmmKQZ93QxOtbELpYsqABLMFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bk5071GdnzdbyK;
	Fri, 18 Jul 2025 18:00:55 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 548F8180B54;
	Fri, 18 Jul 2025 18:05:03 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 18 Jul 2025 18:05:03 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 18 Jul 2025 18:05:02 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>, <songzhiqi1@huawei.com>
Subject: [PATCH] crypto: hisilicon/hpre - fix dma unmap sequence
Date: Fri, 18 Jul 2025 18:05:01 +0800
Message-ID: <20250718100501.3281345-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

From: Zhiqi Song <songzhiqi1@huawei.com>

Perform DMA unmapping operations before processing data.
Otherwise, there may be unsynchronized data accessed by
the CPU when the SWIOTLB is enabled.

Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 61b5e1c5d019..1550c3818383 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1491,11 +1491,13 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
 	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
 		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
 
+	/* Do unmap before data processing */
+	hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);
+
 	p = sg_virt(areq->dst);
 	memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
 	memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);
 
-	hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);
 	kpp_request_complete(areq, ret);
 
 	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
@@ -1808,9 +1810,11 @@ static void hpre_curve25519_cb(struct hpre_ctx *ctx, void *resp)
 	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
 		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
 
+	/* Do unmap before data processing */
+	hpre_curve25519_hw_data_clr_all(ctx, req, areq->dst, areq->src);
+
 	hpre_key_to_big_end(sg_virt(areq->dst), CURVE25519_KEY_SIZE);
 
-	hpre_curve25519_hw_data_clr_all(ctx, req, areq->dst, areq->src);
 	kpp_request_complete(areq, ret);
 
 	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
-- 
2.33.0

