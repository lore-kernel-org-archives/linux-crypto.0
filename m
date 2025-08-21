Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F528243951;
	Thu, 21 Aug 2025 01:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755740303; cv=none; b=mhHPlsNFt5oydovSDyvY02v/lQdV3pu3i+URKWYAydw3glh4cISxQ9C6I6nlNQVOBotsWQQ+a0wF8YChHc7EVqCYQ7YseLyg2t3aD/AR9IR+pmgfU8tQS/ddcNAtVf/4DRFXNUtCbojEVq0rbi0xKK/HTYk74tXXvBOI4s6CQls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755740303; c=relaxed/simple;
	bh=5wQd8yREeAwrK/mxsFVDN4Qlgb2K6NTve3B5HaAawE0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ij5tLs3b1bU5EpKOoevHr1wIAtob3AblkoGqcLNgugxOG2HPiZzIzpSZTb49ecs4v8K5ETFLCe83IfWhxp5/vL7hvGhH7VamDXlk6uXXGgHNY05k1P7B2Hcwnz0mCOvA4pl8PIZ7r94x9PieGmvXejB8VT0sm2MUmewo65wkT+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c6m9B1ctrz2gLC1;
	Thu, 21 Aug 2025 09:35:26 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 9FBA31800CF;
	Thu, 21 Aug 2025 09:38:19 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:38:12 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 21 Aug 2025 09:38:12 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<yinzhushuai@huawei.com>
Subject: [PATCH v2 6/6] crypto: hisilicon/zip - enable literal length in stream mode compression
Date: Thu, 21 Aug 2025 09:38:09 +0800
Message-ID: <20250821013809.4016506-7-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250821013809.4016506-1-huangchenghai2@huawei.com>
References: <20250821013809.4016506-1-huangchenghai2@huawei.com>
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

In stream mode, the hardware needs to combine the length of the
previous literal to calculate the length of the current literal.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 341c4564e21a..8c64f145173f 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -117,6 +117,9 @@
 /* zip comp high performance */
 #define HZIP_HIGH_PERF_OFFSET		0x301208
 
+#define HZIP_LIT_LEN_EN_OFFSET		0x301204
+#define HZIP_LIT_LEN_EN_EN		BIT(4)
+
 enum {
 	HZIP_HIGH_COMP_RATE,
 	HZIP_HIGH_COMP_PERF,
@@ -454,6 +457,20 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
 	return false;
 }
 
+static void hisi_zip_literal_set(struct hisi_qm *qm)
+{
+	u32 val;
+
+	if (qm->ver < QM_HW_V3)
+		return;
+
+	val = readl_relaxed(qm->io_base + HZIP_LIT_LEN_EN_OFFSET);
+	val &= ~HZIP_LIT_LEN_EN_EN;
+
+	/* enable literal length in stream mode compression */
+	writel(val, qm->io_base + HZIP_LIT_LEN_EN_OFFSET);
+}
+
 static void hisi_zip_set_high_perf(struct hisi_qm *qm)
 {
 	u32 val;
@@ -617,6 +634,7 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), base + QM_CACHE_CTL);
 
 	hisi_zip_set_high_perf(qm);
+	hisi_zip_literal_set(qm);
 	hisi_zip_enable_clock_gate(qm);
 
 	ret = hisi_dae_set_user_domain(qm);
-- 
2.33.0

