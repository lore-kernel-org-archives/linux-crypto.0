Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43A63D64;
	Sat, 18 Jan 2025 00:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737161128; cv=none; b=arsHI/Xiwy/4NZKyUZ83S7owbnEwIfM+VRD6BvzLAoy9Ib4ftL6z+RMriALjqcEu4MKSGM7x9FrxBx4q5EsgSZHiQetWmip8YpQamMBSzbZ6XEzFICp23QguhT90vcvWS7x3Y3F1p1jGfoA69y4E/1kJ19uxyO4GsEFZfZVN+cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737161128; c=relaxed/simple;
	bh=eLcWBqXqCORw1g8FrHHld+xe7RtU0YnZo73O87SolDY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gugqKeD3WhiE1wJaZMtb1Bbs6vZPegylNcuakARkA57tr/3B4NJtGEIOJ1jEkz6waiZu6lsjgHikUy6wwAly+MuxWgbZbvTIEeOy4sjyjSeL3qyCh1FEpjVUyufG56KP4rG7NZ9r52cJDifiUiFacbcbuEkyWh0b0v3JLlDecl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4YZd8v61fwz1V50G;
	Sat, 18 Jan 2025 08:42:07 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 0935D14013B;
	Sat, 18 Jan 2025 08:45:22 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 18 Jan 2025 08:45:21 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<lizhi206@huawei.com>, <fanghao11@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<huangchenghai2@huawei.com>
Subject: [PATCH] crypto: hisilicon/hpre - adapt ECDH for high-performance cores
Date: Sat, 18 Jan 2025 08:45:20 +0800
Message-ID: <20250118004520.3826095-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200024.china.huawei.com (7.221.188.85)

From: lizhi <lizhi206@huawei.com>

Only the ECDH with NIST P-256 meets requirements.
The algorithm will be scheduled first for high-performance cores.
The key step is to config resv1 field of BD.

Signed-off-by: lizhi <lizhi206@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 2a2910261210..61b5e1c5d019 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -39,6 +39,8 @@ struct hpre_ctx;
 #define HPRE_DFX_SEC_TO_US	1000000
 #define HPRE_DFX_US_TO_NS	1000
 
+#define HPRE_ENABLE_HPCORE_SHIFT	7
+
 /* due to nist p521  */
 #define HPRE_ECC_MAX_KSZ	66
 
@@ -131,6 +133,8 @@ struct hpre_ctx {
 	};
 	/* for ecc algorithms */
 	unsigned int curve_id;
+	/* for high performance core */
+	u8 enable_hpcore;
 };
 
 struct hpre_asym_request {
@@ -1619,6 +1623,8 @@ static int hpre_ecdh_compute_value(struct kpp_request *req)
 	}
 
 	msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_ECC_MUL);
+	msg->resv1 = ctx->enable_hpcore << HPRE_ENABLE_HPCORE_SHIFT;
+
 	ret = hpre_send(ctx, msg);
 	if (likely(!ret))
 		return -EINPROGRESS;
@@ -1653,6 +1659,7 @@ static int hpre_ecdh_nist_p256_init_tfm(struct crypto_kpp *tfm)
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
+	ctx->enable_hpcore = 1;
 
 	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
 
-- 
2.33.0

