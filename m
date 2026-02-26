Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012038.outbound.protection.outlook.com [40.107.200.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D083128AF;
	Thu, 26 Feb 2026 13:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772111490; cv=fail; b=G4/m+gBBP4owe4TdeeVgx6rMZU3GAYE75h2Pwkl0XaV7cOj0HxVHVfvbDs72cyZDrVx1qhZu9Vb564JmZiznnUQrL0NqSSmuTMFtcZ2kVrazalzQQZM41v1X+boEJ6MLn9qZZ8EBwR8u4t0h6V6xIOAydUeWm5HGRedx6gBP0Qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772111490; c=relaxed/simple;
	bh=aJfZwVvxEE8P6qePdq454Ig8KZpjT6OJ7/RW+13IhF8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J3HTcBO+6Wb/7Oe/NcL++GyzscpxeTyhFnoagskQeFp8QtnEqQGi9F4Sq4AjyeDSzchC0CQXWkkykXzlN/32nGVU4xz8DcQ6uosWIxyjd2v4yVyY5sVdEsl+cs3NgEbrN1Mn3o8uKGRtVwe6CkdYJMRzsN/taWGupCe1YVTnM8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Ji1234l9; arc=fail smtp.client-ip=40.107.200.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Ji1234l9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JYNldA22732DPT+iwFgrx1MzmI6a4cP1ZiymX5wR5fbOi1af5OLfBlEVXQBavgOsHg56Jglw1nJm4hZr5v+J8EF8dhtI4CofBkdV55ggXX8vYqoKFfZuBlk5gwNrqdeGip2/wa97mOCadshWEWjy6rW4ONivqmNsb5RY56Q5b0VTR/jmYFvJDPyAuJO0J9KGvOdC+Lj9srvySRnUr45nZxL+/qx4DYqesn5Dpfjbt9ckHEHB5KoL82m0xvRMQuPaZWP63djegG5N5qhd4hNBV5Snlfwa2ppiiLhyLzHZwMRfHd+tPfJt0W5rJffe6c7huXEvV56kWc7meTaIPqNqSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdb3+K7MCF8pbOUDtc1fsHuNVq1QrP2VEO223wQehVc=;
 b=sxtx8Ui1mDHSskLEseDHaizV0dz0kclaBzcEO6po+A7AM0riDwVKRU2CAJauKXgF9SM6g+Ei6wVHgFo4mbuVcr5QLqYZ+LtWNZpBy7vo0pLI/k6yl22P9pvwakZ/xFg/y4yVjI0HuEmOo24wCuQTrYNQ27rPBrh9lry1KcVExHIXi6jJ98qkn2Qp3P5ITXiRiF/vD0QqSjNOQhKrG3GHoB9VuK5VfkFEDHJUsiG+1wtypN77PT2PYhMACa2Kpqf0581PcOGTcBoKBN8/KVufWKq3+BXJZpyqiBuXP0srxZhfNt0C7HeiMUnpiN3oGpPNLm9ptbIPcjvt7L5DrQs3Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdb3+K7MCF8pbOUDtc1fsHuNVq1QrP2VEO223wQehVc=;
 b=Ji1234l9r9cuH68HxKVdZ971OPxiwq54ULXV+oT5pR8SiAkEk5Pl5nJS8zjo+mi+xAfeMCrUmBoeVt68zROWZp6137rFawwFBGbumEHIR0yZQ33c6CgnlBpsnqBSQZcgYUCHwa4NYXCjkVE4B2kFVnc6+taT24l62blQwa0KSL0=
Received: from BY3PR05CA0034.namprd05.prod.outlook.com (2603:10b6:a03:39b::9)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 13:11:23 +0000
Received: from SJ1PEPF000023D7.namprd21.prod.outlook.com
 (2603:10b6:a03:39b:cafe::fb) by BY3PR05CA0034.outlook.office365.com
 (2603:10b6:a03:39b::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.15 via Frontend Transport; Thu,
 26 Feb 2026 13:11:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SJ1PEPF000023D7.mail.protection.outlook.com (10.167.244.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.0 via Frontend Transport; Thu, 26 Feb 2026 13:11:21 +0000
Received: from DFLE209.ent.ti.com (10.64.6.67) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:11:20 -0600
Received: from DFLE206.ent.ti.com (10.64.6.64) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 26 Feb
 2026 07:11:20 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 26 Feb 2026 07:11:20 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 61QDBJci2405027;
	Thu, 26 Feb 2026 07:11:19 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Kamlesh Gurudasani <kamlesh@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>, Kavitha Malarvizhi
	<k-malarvizhi@ti.com>, Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v3 1/3] crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
Date: Thu, 26 Feb 2026 18:41:01 +0530
Message-ID: <20260226131103.3560884-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260226131103.3560884-1-t-pratham@ti.com>
References: <20260226131103.3560884-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D7:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c24fe3f-1bd5-461f-0c29-08de75388949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|34020700016|376014|36860700013|1800799024|82310400026|7142099003;
X-Microsoft-Antispam-Message-Info:
	ZHA2q77JFgvJa/SgDZAOSefRcu+fl8hLme+kzek8dC/yGcmpxvjg8vgkJljLDYXChR89Kzv5uOEYBY8of1yr1nbHvnrrHPTS2FfbYfU1xtd6c0fZEdj0+MB7FVRmUo8JdOI4rdMjXmpI/37LPxJghal98iTrRk5flvHPBHKom1S188OKq4t2z3Uy7QuLLnMwU6RbNd2ScJqjBrGOgJq6ZeoHAwH8Q/MWJqcpfPextcyfkjA0TUV6GoLsbFj85xadpPGfElGA1Om+QS39S0vuhYtEcN6KAUJN7TG/gXxuIW+rp457d1ob4MR3gwrPVetR5JaC8uiJS42v9bLhJpi8jD/83A8rX3k7GBfq5yXudyrhu6pxFTOMXEA1a8nTABBVSns2HSkjWW/t3gUMb9tBFINONIKs/ffEVls0QO4X8Us9vIZL/2tjcjTs7LeuIEhbnJf5DaBc/j/DEuTOAlCD+KWr2jYqSRJX86jyB/CQyFqOpN9XaHgYrZM273wGImnPcCqbTXtRULCRomesaq09YBdNlUJGwBuu3tkcyIXvDVDdYnK32QDAckbL54/ZPjjgx294mnlWTkBhje5NGUU/7cLpAtxOs5ZoiLTb8Y51US4I1K4vY7hmwixOzyT4CI/HPya/1norXf4Ufm+7lJK9S17AXMgF/AMZA7iWnayk5JwWQe5jzAiQPrtdBsmAXUQALf5L6lBf6NqPCv1alb5VeusmOS7Y8PW33chEaqpCiG6PMMwRTbhCZmRDsPFQjmPBeRlBy/iplXB0DPURmXDqog==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(34020700016)(376014)(36860700013)(1800799024)(82310400026)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1HTn6CKWCa9zPqHuFbzekmUbzq3oEqy+W+bj3LKTcPPAj5D3U5zrVpfwXzp1h/j0IUH0E5tvkdkIwjgw2JpEYod4cr7cxhQNPurbz8oANDFrDnxNpr23/dXHALyp8xGpR6+0nRjbusyXSHSI01w6ZDrYLkj8YGPnufkldG23cD3fjHeBWSdEP50sZMQpBrQRjyCI/UuJS303D07QCTDy3hR/lbJBlx7ZiwrZpXCO7lPF4ENWmPul3x3s/uAw6vfqrGLGV8dqhbV49n73eEYYvLqYqFtsrUpSQYVjAa7CpLBETWEfPGLJ+lz6Oj60O9mHEKPFOBB7LdB9RLg3v9c1OhjVSz8fitDhJ+NkWwNIblkbDfW/tlbW1OLaDKLuXeBLAOEVQEmtN4NNjM0EGlf8SBHZdz/lt5JxRVyewcKvd9rgHEHxrsJWx8oonjCaZ0a9
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 13:11:21.3335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c24fe3f-1bd5-461f-0c29-08de75388949
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105

Add support for SHA224, SHA256, SHA384, SHA512 algorithms in the Hashing
Engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   2 +
 drivers/crypto/ti/Makefile        |   2 +-
 drivers/crypto/ti/dthev2-aes.c    |   6 +-
 drivers/crypto/ti/dthev2-common.c |  43 ++-
 drivers/crypto/ti/dthev2-common.h |  47 ++-
 drivers/crypto/ti/dthev2-hash.c   | 591 ++++++++++++++++++++++++++++++
 6 files changed, 677 insertions(+), 14 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 1a3a571ac8cef..90af2c7cb1c55 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -10,6 +10,8 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_XTS
 	select CRYPTO_GCM
 	select CRYPTO_CCM
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/Makefile b/drivers/crypto/ti/Makefile
index b883078f203d7..a90bc97a52321 100644
--- a/drivers/crypto/ti/Makefile
+++ b/drivers/crypto/ti/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_CRYPTO_DEV_TI_DTHEV2) += dthev2.o
-dthev2-objs := dthev2-common.o dthev2-aes.o
+dthev2-objs := dthev2-common.o dthev2-aes.o dthev2-hash.o
diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index d00ccefd0a493..60cac24409c5c 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -512,7 +512,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	}
 
 	local_bh_disable();
-	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
+	crypto_finalize_skcipher_request(engine, req, ret);
 	local_bh_enable();
 	return 0;
 }
@@ -547,7 +547,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 		return 0;
 	}
 
-	engine = dev_data->engine;
+	engine = dev_data->aes_engine;
 	return crypto_transfer_skcipher_request_to_engine(engine, req);
 }
 
@@ -1167,7 +1167,7 @@ static int dthe_aead_crypt(struct aead_request *req)
 	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr))
 		return dthe_aead_do_fallback(req);
 
-	engine = dev_data->engine;
+	engine = dev_data->aes_engine;
 	return crypto_transfer_aead_request_to_engine(engine, req);
 }
 
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index a2ad79bec105a..88d0ccd5d0227 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -96,6 +96,11 @@ static int dthe_dma_init(struct dthe_data *dev_data)
 		goto err_dma_sha_tx;
 	}
 
+	/*
+	 * Do AES Rx and Tx channel config here because it is invariant of AES mode
+	 * SHA Tx channel config is done before DMA transfer depending on hashing algorithm
+	 */
+
 	memzero_explicit(&cfg, sizeof(cfg));
 
 	cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
@@ -130,11 +135,21 @@ static int dthe_dma_init(struct dthe_data *dev_data)
 
 static int dthe_register_algs(void)
 {
-	return dthe_register_aes_algs();
+	int ret = 0;
+
+	ret = dthe_register_hash_algs();
+	if (ret)
+		return ret;
+	ret = dthe_register_aes_algs();
+	if (ret)
+		dthe_unregister_hash_algs();
+
+	return ret;
 }
 
 static void dthe_unregister_algs(void)
 {
+	dthe_unregister_hash_algs();
 	dthe_unregister_aes_algs();
 }
 
@@ -163,15 +178,26 @@ static int dthe_probe(struct platform_device *pdev)
 	if (ret)
 		goto probe_dma_err;
 
-	dev_data->engine = crypto_engine_alloc_init(dev, 1);
-	if (!dev_data->engine) {
+	dev_data->aes_engine = crypto_engine_alloc_init(dev, 1);
+	if (!dev_data->aes_engine) {
 		ret = -ENOMEM;
 		goto probe_engine_err;
 	}
+	dev_data->hash_engine = crypto_engine_alloc_init(dev, 1);
+	if (!dev_data->hash_engine) {
+		ret = -ENOMEM;
+		goto probe_hash_engine_err;
+	}
+
+	ret = crypto_engine_start(dev_data->aes_engine);
+	if (ret) {
+		dev_err(dev, "Failed to start crypto engine for AES\n");
+		goto probe_engine_start_err;
+	}
 
-	ret = crypto_engine_start(dev_data->engine);
+	ret = crypto_engine_start(dev_data->hash_engine);
 	if (ret) {
-		dev_err(dev, "Failed to start crypto engine\n");
+		dev_err(dev, "Failed to start crypto engine for hash\n");
 		goto probe_engine_start_err;
 	}
 
@@ -184,7 +210,9 @@ static int dthe_probe(struct platform_device *pdev)
 	return 0;
 
 probe_engine_start_err:
-	crypto_engine_exit(dev_data->engine);
+	crypto_engine_exit(dev_data->hash_engine);
+probe_hash_engine_err:
+	crypto_engine_exit(dev_data->aes_engine);
 probe_engine_err:
 	dma_release_channel(dev_data->dma_aes_rx);
 	dma_release_channel(dev_data->dma_aes_tx);
@@ -207,7 +235,8 @@ static void dthe_remove(struct platform_device *pdev)
 
 	dthe_unregister_algs();
 
-	crypto_engine_exit(dev_data->engine);
+	crypto_engine_exit(dev_data->aes_engine);
+	crypto_engine_exit(dev_data->hash_engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
 	dma_release_channel(dev_data->dma_aes_tx);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index d4a3b9c18bbc1..bfe7f2de4415c 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -17,6 +17,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/sha2.h>
 
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
@@ -33,6 +34,16 @@
  */
 #define DTHE_MAX_KEYSIZE	(AES_MAX_KEY_SIZE * 2)
 
+enum dthe_hash_alg_sel {
+	DTHE_HASH_MD5		= 0,
+	DTHE_HASH_SHA1		= BIT(1),
+	DTHE_HASH_SHA224	= BIT(2),
+	DTHE_HASH_SHA256	= BIT(1) | BIT(2),
+	DTHE_HASH_SHA384	= BIT(0),
+	DTHE_HASH_SHA512	= BIT(0) | BIT(1),
+	DTHE_HASH_ERR		= BIT(0) | BIT(1) | BIT(2),
+};
+
 enum dthe_aes_mode {
 	DTHE_AES_ECB = 0,
 	DTHE_AES_CBC,
@@ -49,7 +60,8 @@ enum dthe_aes_mode {
  * @dev: Device pointer
  * @regs: Base address of the register space
  * @list: list node for dev
- * @engine: Crypto engine instance
+ * @aes_engine: Crypto engine instance for AES Engine
+ * @hash_engine: Crypto engine instance for Hashing Engine
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
@@ -58,7 +70,8 @@ struct dthe_data {
 	struct device *dev;
 	void __iomem *regs;
 	struct list_head list;
-	struct crypto_engine *engine;
+	struct crypto_engine *aes_engine;
+	struct crypto_engine *hash_engine;
 
 	struct dma_chan *dma_aes_rx;
 	struct dma_chan *dma_aes_tx;
@@ -83,6 +96,8 @@ struct dthe_list {
  * @authsize: Authentication size for modes with authentication
  * @key: AES key
  * @aes_mode: AES mode
+ * @hash_mode: Hashing Engine mode
+ * @phash_size: partial hash size of the hash algorithm selected
  * @aead_fb: Fallback crypto aead handle
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
@@ -91,7 +106,11 @@ struct dthe_tfm_ctx {
 	unsigned int keylen;
 	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
-	enum dthe_aes_mode aes_mode;
+	union {
+		enum dthe_aes_mode aes_mode;
+		enum dthe_hash_alg_sel hash_mode;
+	};
+	unsigned int phash_size;
 	union {
 		struct crypto_sync_aead *aead_fb;
 		struct crypto_sync_skcipher *skcipher_fb;
@@ -110,6 +129,25 @@ struct dthe_aes_req_ctx {
 	struct completion aes_compl;
 };
 
+/**
+ * struct dthe_hash_req_ctx - Hashing engine ctx struct
+ * @phash: buffer to store a partial hash from a previous operation
+ * @digestcnt: stores the digest count from a previous operation; currently hardware only provides
+ *             a single 32-bit value even for SHA384/512
+ * @phash_available: flag indicating if a partial hash from a previous operation is available
+ * @flags: flags for internal use
+ * @padding: padding buffer for handling unaligned data
+ * @hash_compl: Completion variable for use in manual completion in case of DMA callback failure
+ */
+struct dthe_hash_req_ctx {
+	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];
+	u64 digestcnt[2];
+	u8 phash_available;
+	u8 flags;
+	u8 padding[SHA512_BLOCK_SIZE];
+	struct completion hash_compl;
+};
+
 /* Struct definitions end */
 
 struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
@@ -131,4 +169,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
 
+int dthe_register_hash_algs(void);
+void dthe_unregister_hash_algs(void);
+
 #endif
diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-hash.c
new file mode 100644
index 0000000000000..b1394262bf630
--- /dev/null
+++ b/drivers/crypto/ti/dthev2-hash.c
@@ -0,0 +1,591 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * K3 DTHE V2 crypto accelerator driver
+ *
+ * Copyright (C) Texas Instruments 2025 - https://www.ti.com
+ * Author: T Pratham <t-pratham@ti.com>
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha2.h>
+
+#include "dthev2-common.h"
+
+#include <linux/delay.h>
+#include <linux/dmaengine.h>
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/scatterlist.h>
+
+/* Registers */
+
+#define DTHE_P_HASH_BASE		0x5000
+#define DTHE_P_HASH512_IDIGEST_A	0x0240
+#define DTHE_P_HASH512_DIGEST_COUNT	0x0280
+#define DTHE_P_HASH512_MODE		0x0284
+#define DTHE_P_HASH512_LENGTH		0x0288
+#define DTHE_P_HASH512_DATA_IN_START	0x0080
+#define DTHE_P_HASH512_DATA_IN_END	0x00FC
+
+#define DTHE_P_HASH_SYSCONFIG		0x0110
+#define DTHE_P_HASH_IRQSTATUS		0x0118
+#define DTHE_P_HASH_IRQENABLE		0x011C
+
+/* Register write values and macros */
+#define DTHE_HASH_SYSCONFIG_INT_EN		BIT(2)
+#define DTHE_HASH_SYSCONFIG_DMA_EN		BIT(3)
+#define DTHE_HASH_IRQENABLE_EN_ALL		GENMASK(3, 0)
+#define DTHE_HASH_IRQSTATUS_OP_READY		BIT(0)
+#define DTHE_HASH_IRQSTATUS_IP_READY		BIT(1)
+#define DTHE_HASH_IRQSTATUS_PH_READY		BIT(2)
+#define DTHE_HASH_IRQSTATUS_CTX_READY		BIT(3)
+
+#define DTHE_HASH_MODE_USE_ALG_CONST		BIT(3)
+#define DTHE_HASH_MODE_CLOSE_HASH		BIT(4)
+
+enum dthe_hash_op {
+	DTHE_HASH_OP_UPDATE = 0,
+	DTHE_HASH_OP_FINUP,
+};
+
+static void dthe_hash_write_zero_message(enum dthe_hash_alg_sel mode, void *dst)
+{
+	switch (mode) {
+	case DTHE_HASH_SHA512:
+		memcpy(dst, sha512_zero_message_hash, SHA512_DIGEST_SIZE);
+		break;
+	case DTHE_HASH_SHA384:
+		memcpy(dst, sha384_zero_message_hash, SHA384_DIGEST_SIZE);
+		break;
+	case DTHE_HASH_SHA256:
+		memcpy(dst, sha256_zero_message_hash, SHA256_DIGEST_SIZE);
+		break;
+	case DTHE_HASH_SHA224:
+		memcpy(dst, sha224_zero_message_hash, SHA224_DIGEST_SIZE);
+		break;
+	default:
+		break;
+	}
+}
+
+static enum dthe_hash_alg_sel dthe_hash_get_hash_mode(struct crypto_ahash *tfm)
+{
+	unsigned int ds = crypto_ahash_digestsize(tfm);
+	enum dthe_hash_alg_sel hash_mode;
+
+	/*
+	 * Currently, all hash algorithms supported by DTHEv2 have unique digest sizes.
+	 * So we can do this. Otherwise, we would have to get the algorithm from the
+	 * alg_name and do a strcmp.
+	 */
+	switch (ds) {
+	case SHA512_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_SHA512;
+		break;
+	case SHA384_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_SHA384;
+		break;
+	case SHA256_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_SHA256;
+		break;
+	case SHA224_DIGEST_SIZE:
+		hash_mode = DTHE_HASH_SHA224;
+		break;
+	default:
+		hash_mode = DTHE_HASH_ERR;
+		break;
+	}
+
+	return hash_mode;
+}
+
+static unsigned int dthe_hash_get_phash_size(struct dthe_tfm_ctx *ctx)
+{
+	unsigned int phash_size = 0;
+
+	switch (ctx->hash_mode) {
+	case DTHE_HASH_SHA512:
+	case DTHE_HASH_SHA384:
+		phash_size = SHA512_DIGEST_SIZE;
+		break;
+	case DTHE_HASH_SHA256:
+	case DTHE_HASH_SHA224:
+		phash_size = SHA256_DIGEST_SIZE;
+		break;
+	default:
+		break;
+	}
+
+	return phash_size;
+}
+
+static int dthe_hash_init_tfm(struct crypto_ahash *tfm)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+
+	if (!dev_data)
+		return -ENODEV;
+
+	ctx->dev_data = dev_data;
+
+	ctx->hash_mode = dthe_hash_get_hash_mode(tfm);
+	if (ctx->hash_mode == DTHE_HASH_ERR)
+		return -EINVAL;
+
+	ctx->phash_size = dthe_hash_get_phash_size(ctx);
+
+	return 0;
+}
+
+static int dthe_hash_config_dma_chan(struct dma_chan *chan, struct crypto_ahash *tfm)
+{
+	struct dma_slave_config cfg;
+	int bs = crypto_ahash_blocksize(tfm);
+
+	memzero_explicit(&cfg, sizeof(cfg));
+
+	cfg.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	cfg.dst_maxburst = bs / 4;
+
+	return dmaengine_slave_config(chan, &cfg);
+}
+
+static void dthe_hash_dma_in_callback(void *data)
+{
+	struct ahash_request *req = (struct ahash_request *)data;
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+
+	complete(&rctx->hash_compl);
+}
+
+static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *src,
+			       int src_nents, size_t len)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct device *tx_dev;
+	struct dma_async_tx_descriptor *desc_out;
+	int mapped_nents;
+	enum dma_data_direction src_dir = DMA_TO_DEVICE;
+	u32 hash_mode;
+	int ds = crypto_ahash_digestsize(tfm);
+	int ret = 0;
+	u32 *dst;
+	u32 dst_len;
+	void __iomem *sha_base_reg = dev_data->regs + DTHE_P_HASH_BASE;
+
+	u32 hash_sysconfig_val = DTHE_HASH_SYSCONFIG_INT_EN | DTHE_HASH_SYSCONFIG_DMA_EN;
+	u32 hash_irqenable_val = DTHE_HASH_IRQENABLE_EN_ALL;
+
+	writel_relaxed(hash_sysconfig_val, sha_base_reg + DTHE_P_HASH_SYSCONFIG);
+	writel_relaxed(hash_irqenable_val, sha_base_reg + DTHE_P_HASH_IRQENABLE);
+
+	/* Config SHA DMA channel as per SHA mode */
+	ret = dthe_hash_config_dma_chan(dev_data->dma_sha_tx, tfm);
+	if (ret) {
+		dev_err(dev_data->dev, "Can't configure sha_tx dmaengine slave: %d\n", ret);
+		goto hash_err;
+	}
+
+	tx_dev = dmaengine_get_dma_device(dev_data->dma_sha_tx);
+	if (!tx_dev) {
+		ret = -ENODEV;
+		goto hash_err;
+	}
+
+	mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
+	if (mapped_nents == 0) {
+		ret = -EINVAL;
+		goto hash_err;
+	}
+
+	desc_out = dmaengine_prep_slave_sg(dev_data->dma_sha_tx, src, mapped_nents,
+					   DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	if (!desc_out) {
+		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
+		ret = -EINVAL;
+		goto hash_prep_err;
+	}
+
+	desc_out->callback = dthe_hash_dma_in_callback;
+	desc_out->callback_param = req;
+
+	init_completion(&rctx->hash_compl);
+
+	hash_mode = ctx->hash_mode;
+
+	if (rctx->flags == DTHE_HASH_OP_FINUP)
+		hash_mode |= DTHE_HASH_MODE_CLOSE_HASH;
+
+	if (rctx->phash_available) {
+		for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
+			writel_relaxed(rctx->phash[i],
+				       sha_base_reg +
+				       DTHE_P_HASH512_IDIGEST_A +
+				       (DTHE_REG_SIZE * i));
+
+		writel_relaxed(rctx->digestcnt[0],
+			       sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	} else {
+		hash_mode |= DTHE_HASH_MODE_USE_ALG_CONST;
+	}
+
+	writel_relaxed(hash_mode, sha_base_reg + DTHE_P_HASH512_MODE);
+	writel_relaxed(len, sha_base_reg + DTHE_P_HASH512_LENGTH);
+
+	dmaengine_submit(desc_out);
+
+	dma_async_issue_pending(dev_data->dma_sha_tx);
+
+	ret = wait_for_completion_timeout(&rctx->hash_compl,
+					  msecs_to_jiffies(DTHE_DMA_TIMEOUT_MS));
+	if (!ret) {
+		dmaengine_terminate_sync(dev_data->dma_sha_tx);
+		ret = -ETIMEDOUT;
+	} else {
+		ret = 0;
+	}
+
+	if (rctx->flags == DTHE_HASH_OP_UPDATE) {
+		/* If coming from update, we need to read the phash and store it for future */
+		dst = rctx->phash;
+		dst_len = ctx->phash_size / sizeof(u32);
+	} else {
+		/* If coming from finup or final, we need to read the final digest */
+		dst = (u32 *)req->result;
+		dst_len = ds / sizeof(u32);
+	}
+
+	for (int i = 0; i < dst_len; ++i)
+		dst[i] = readl_relaxed(sha_base_reg +
+				       DTHE_P_HASH512_IDIGEST_A +
+				       (DTHE_REG_SIZE * i));
+
+	rctx->digestcnt[0] = readl_relaxed(sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	rctx->phash_available = 1;
+
+hash_prep_err:
+	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+hash_err:
+	return ret;
+}
+
+static int dthe_hash_run(struct crypto_engine *engine, void *areq)
+{
+	struct ahash_request *req = container_of(areq, struct ahash_request, base);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+
+	struct scatterlist *src, *sg;
+	int src_nents = 0;
+	unsigned int bs = crypto_ahash_blocksize(tfm);
+	unsigned int tot_len = req->nbytes;
+	unsigned int len_to_process;
+	unsigned int len_to_buffer;
+	unsigned int pad_len = 0;
+	u8 *pad_buf = rctx->padding;
+	int ret = 0;
+
+	if (rctx->flags == DTHE_HASH_OP_UPDATE) {
+		len_to_process = tot_len - (tot_len % bs);
+		len_to_buffer = tot_len % bs;
+
+		if (len_to_process == 0) {
+			ret = len_to_buffer;
+			goto hash_buf_all;
+		}
+	} else {
+		len_to_process = tot_len;
+		len_to_buffer = 0;
+	}
+
+	src_nents = sg_nents_for_len(req->src, len_to_process);
+
+	/*
+	 * Certain DMA restrictions forced us to send data in multiples of BLOCK_SIZE
+	 * bytes. So, add a padding 0s at the end of src scatterlist if data is not a
+	 * multiple of block_size bytes (Can only happen in final or finup). The extra
+	 * data is ignored by the DTHE hardware.
+	 */
+	if (len_to_process % bs) {
+		pad_len = bs - (len_to_process % bs);
+		src_nents++;
+	}
+
+	src = kcalloc(src_nents, sizeof(*src), GFP_KERNEL);
+	if (!src) {
+		ret = -ENOMEM;
+		goto hash_buf_all;
+	}
+
+	sg_init_table(src, src_nents);
+	sg = dthe_copy_sg(src, req->src, len_to_process);
+	if (pad_len > 0) {
+		memset(pad_buf, 0, pad_len);
+		sg_set_buf(sg, pad_buf, pad_len);
+	}
+
+	ret = dthe_hash_dma_start(req, src, src_nents, len_to_process);
+	if (!ret)
+		ret = len_to_buffer;
+
+	kfree(src);
+
+hash_buf_all:
+	local_bh_disable();
+	crypto_finalize_hash_request(engine, req, ret);
+	local_bh_enable();
+	return 0;
+}
+
+static int dthe_hash_init(struct ahash_request *req)
+{
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+
+	rctx->phash_available = 0;
+	rctx->digestcnt[0] = 0;
+	rctx->digestcnt[1] = 0;
+
+	return 0;
+}
+
+static int dthe_hash_update(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct crypto_engine *engine = dev_data->hash_engine;
+
+	if (req->nbytes == 0)
+		return 0;
+
+	rctx->flags = DTHE_HASH_OP_UPDATE;
+
+	return crypto_transfer_hash_request_to_engine(engine, req);
+}
+
+static int dthe_hash_final(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct crypto_engine *engine = dev_data->hash_engine;
+
+	/**
+	 * We are always buffering data in update, except when nbytes = 0.
+	 * So, either we get the buffered data here (nbytes > 0) or
+	 * it is the case that we got zero message to begin with
+	 */
+	if (req->nbytes > 0) {
+		rctx->flags = DTHE_HASH_OP_FINUP;
+
+		return crypto_transfer_hash_request_to_engine(engine, req);
+	}
+
+	dthe_hash_write_zero_message(ctx->hash_mode, req->result);
+
+	return 0;
+}
+
+static int dthe_hash_finup(struct ahash_request *req)
+{
+	/* With AHASH_ALG_BLOCK_ONLY, final becomes same as finup. */
+	return dthe_hash_final(req);
+}
+
+static int dthe_hash_digest(struct ahash_request *req)
+{
+	dthe_hash_init(req);
+	return dthe_hash_finup(req);
+}
+
+static int dthe_hash_export(struct ahash_request *req, void *out)
+{
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	union {
+		u8 *u8;
+		u64 *u64;
+	} p = { .u8 = out };
+
+	memcpy(out, rctx->phash, ctx->phash_size);
+	p.u8 += ctx->phash_size;
+	put_unaligned(rctx->digestcnt[0], p.u64++);
+	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
+		put_unaligned(rctx->digestcnt[1], p.u64++);
+
+	return 0;
+}
+
+static int dthe_hash_import(struct ahash_request *req, const void *in)
+{
+	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	union {
+		const u8 *u8;
+		const u64 *u64;
+	} p = { .u8 = in };
+
+	memcpy(rctx->phash, in, ctx->phash_size);
+	p.u8 += ctx->phash_size;
+	rctx->digestcnt[0] = get_unaligned(p.u64++);
+	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
+		rctx->digestcnt[1] = get_unaligned(p.u64++);
+	rctx->phash_available = ((rctx->digestcnt[0]) ? 1 : 0);
+
+	return 0;
+}
+
+static struct ahash_engine_alg hash_algs[] = {
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = SHA512_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "sha512",
+				.cra_driver_name = "sha512-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA512_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = SHA384_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "sha384",
+				.cra_driver_name = "sha384-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA384_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = SHA256_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "sha256",
+				.cra_driver_name = "sha256-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA256_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.halg	= {
+			.digestsize = SHA224_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "sha224",
+				.cra_driver_name = "sha224-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_OPTIONAL_KEY |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_FINAL_NONZERO |
+						   CRYPTO_AHASH_ALG_FINUP_MAX |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA224_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+};
+
+int dthe_register_hash_algs(void)
+{
+	return crypto_engine_register_ahashes(hash_algs, ARRAY_SIZE(hash_algs));
+}
+
+void dthe_unregister_hash_algs(void)
+{
+	crypto_engine_unregister_ahashes(hash_algs, ARRAY_SIZE(hash_algs));
+}
-- 
2.34.1

