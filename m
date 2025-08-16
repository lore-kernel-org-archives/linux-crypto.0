Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A87829AAE9;
	Sat, 16 Aug 2025 10:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755340128; cv=none; b=RCIzZkmiGdOwjSwN7bjIPdQYIzlfLwZ45sGyoITRtUkCtyRILk9uWuCVnRbFT+b1GeNP43v43Om6UtFHFBIltCgkM7lYXJIq90EPmXnvVtGexhTHaNBDW5WnTU2NMgholAqqejHYMPuAZf67HRmkwkf5iOswnqaTrJ1x28Z9TZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755340128; c=relaxed/simple;
	bh=iet8VwawGdlQRfJJ547ueqq2885aUgJKQpR6XXTFVEs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jXBcHHS/z0jTkdjB2LlPYSoyiCS1Nes+mjW/alTurNw/LxIRkxOoSXK+AdvXY2rzVwoVB+CrF9FFa0rlxdXwcCbgZoxZ/VREPGsIAbCltWA8uylbm7oU11r91a5LKM4bqrsXZTHzJwM2ndkR17R+XUccfOhswViwSydwJDdRAWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c3wDh3v3szvX5D;
	Sat, 16 Aug 2025 18:28:36 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8CCBE18048B;
	Sat, 16 Aug 2025 18:28:38 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:28:38 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:28:37 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<huangchenghai2@huawei.com>
Subject: [PATCH 6/6] crypto: hisilicon/zip - enable literal length in stream mode compression
Date: Sat, 16 Aug 2025 18:28:34 +0800
Message-ID: <20250816102834.828655-7-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250816102834.828655-1-huangchenghai2@huawei.com>
References: <20250816102834.828655-1-huangchenghai2@huawei.com>
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

In stream mode, the hardware needs to combine the length of the
previous literal to calculate the length of the current literal.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 7d55cd08cd1e..c75db858bb76 100644
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
@@ -616,6 +633,8 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	       CQC_CACHE_WB_ENABLE | FIELD_PREP(SQC_CACHE_WB_THRD, 1) |
 	       FIELD_PREP(CQC_CACHE_WB_THRD, 1), base + QM_CACHE_CTL);
 
+	hisi_zip_literal_set(qm);
+
 	hisi_zip_set_high_perf(qm);
 
 	hisi_zip_enable_clock_gate(qm);
-- 
2.33.0

