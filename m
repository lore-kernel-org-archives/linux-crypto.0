Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F678275870;
	Sat, 30 Aug 2025 10:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756549684; cv=none; b=W5bscJgJKpgIoeXCUt5m5PyS8OnKQ52KTGvse2l9PmlBp5YdkE45g8U+ow9k/c+kKzk+nGR7xQZMcuWA8s3z+tzcSNYJCKz46Odsm9eUyVRb0pSZsn/SMCQpDVAa0cQ+qw43x0JFFsKdJjsgAz4K7CZ3ec+QG1rnBPEwUC/4rJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756549684; c=relaxed/simple;
	bh=uTQUh+ZJXs5CPzoboZT2wrE6qECu+62k1Hv2dWcjNYc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rxQZzA7TNcaQBpX1o4BGVxlOC3KpQzpwRW0sYvPdZbisY40v1kl+EpuadpukY1hA6jjRst0od9IbWpCCd5U4VrQljjSoNvFY7k8h1kYCajIbrHMYltgBLboyqDIG6VIR2pRojX4iAMVkyH/mmrGcLvhgGyvshDXUTvKNqcqGr7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cDWV20tj6z24hxG;
	Sat, 30 Aug 2025 18:24:58 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8EDA11401F2;
	Sat, 30 Aug 2025 18:27:59 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Aug 2025 18:27:59 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Aug 2025 18:27:58 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>,
	<yinzhushuai@huawei.com>
Subject: [PATCH 1/2] crypto: hisilicon/zip - add lz4 and lz77_only to algorithm sysfs
Date: Sat, 30 Aug 2025 18:27:56 +0800
Message-ID: <20250830102757.1498691-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250830102757.1498691-1-huangchenghai2@huawei.com>
References: <20250830102757.1498691-1-huangchenghai2@huawei.com>
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

The current hisilicon zip supports the new algorithms lz77_only and
lz4. To enable user space to recognize the new algorithm support,
add lz77_only and lz4 to the sysfs. Users can now use the new
algorithms through uacce.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index fcb72d5cf592..62cd090e13af 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -80,6 +80,7 @@
 #define HZIP_ALG_GZIP_BIT		GENMASK(3, 2)
 #define HZIP_ALG_DEFLATE_BIT		GENMASK(5, 4)
 #define HZIP_ALG_LZ77_BIT		GENMASK(7, 6)
+#define HZIP_ALG_LZ4_BIT		GENMASK(9, 8)
 
 #define HZIP_BUF_SIZE			22
 #define HZIP_SQE_MASK_OFFSET		64
@@ -150,6 +151,12 @@ static const struct qm_dev_alg zip_dev_algs[] = { {
 	}, {
 		.alg_msk = HZIP_ALG_LZ77_BIT,
 		.alg = "lz77_zstd\n",
+	}, {
+		.alg_msk = HZIP_ALG_LZ77_BIT,
+		.alg = "lz77_only\n",
+	}, {
+		.alg_msk = HZIP_ALG_LZ4_BIT,
+		.alg = "lz4\n",
 	},
 };
 
-- 
2.33.0

