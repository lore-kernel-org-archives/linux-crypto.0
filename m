Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013028.outbound.protection.outlook.com [40.93.196.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F3C32F77C;
	Wed, 29 Oct 2025 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733421; cv=fail; b=qBu1FxYj9UMXWfEcbqLklyO6iScxq4nXGDk5JogaztNxPp+r2t9NnyHtL8Zs6K03gIWkPK7qG6J6JNyn3mz5jCBq+JEX2He6hmpH4Z7AADMndbio9i5z/xfJDFIYyLxgpNi9Z34SNRLYVsd23KIbkdgUVAMH8RFQnCQZG8lBzAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733421; c=relaxed/simple;
	bh=3QQ5HzaMzybkgsktZNhPJlALXRYDxrmlimjRY4AJ3Ks=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tyM98NubmI36fi6gwybkC3u8rbgQ8AFoOI8x80eOZBeE5i+EMo0GwwkNjza4xQjPkzQ3mJhZodRf3cSDbI6Fouag7N8RoNi5av+9JMidO1vpOOwzXczaCHgQiW1tXuK2HNVkMcHTyWZTCENhULTYv5dp5gfkl/ij4hnggUE6sYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JhrdZryy; arc=fail smtp.client-ip=40.93.196.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JhrdZryy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMUKf6aqIdIypXx/R16lPC2dxoBTdxgil7fGE+flAXYTDXTiYCoLFIobwI4TQTRe/daT2/gBE/IYLo/QIFvBWZnOLN9JjDPv6+m2UK4PwYyQGMCVHRNpIHp2Of/Tb0G6Mqg/evJpapG9odr9JDfxQqtSzl+OgdUXdVqOKAbd4XOQg7YPDg3KnEh1xaGuFkXCYkx6kARz3F/g4G+241639saGpa75t7EabaIXwJ+7FhubAuI/YfkBn0YUYW5U71Vos33t+bjBkhelNHd4MOhGQEyr5xgOA3kRgeF9erx8BIGrfJp3z1ikYf2S/7u3c0nDySgecKLZRo16aITsMcrGpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Trg8SvrhfRdiRN57IVgE2ODRUZlQnXIjIZQYcl5Jns=;
 b=pJRcYAjKdhCKXrwupRHE5t0gbIy7hrLX0G6JtAaK3KD43hfUIrh7zpKznFxqmLH8g7eyBbWQkqo6H4j0KSajB6juH8mWhiCSTAx63hXy3tx1ZtjXDfp0f5W6rRhOom+nCWliliogizb9BO88aI6Sw0Wrg/nsN3LT6mjwbF2GJMrldtlF/YG3ggfe8eO0e+uHggWJoQeEmtHftciV/XXb0+Cos6Xfd9zcF3JQINwBvkMofit7yIExOBByI/sJpcVi7hsOH0ep0VqyiQeoaP6GdzfiMBm2Nb0X+3dQ/S+nvFtCU6+zZpF6Ns/hHOreQOocohpyxyGYQeKpJhPVPQApCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Trg8SvrhfRdiRN57IVgE2ODRUZlQnXIjIZQYcl5Jns=;
 b=JhrdZryykIECXlYXfXWWzM2d5TPdQlrUHXyyk05nKquKQHTWQttnl5ZZ7uPjC3i06ikZ6tU4jGTem5f/vqEQHdLQEWsZCnXeqwVTRITegXF6SN9W7kXyx+bxg2+ruo2e/OA9a/3SaGA3xdWn1EIPRcBw6SldZxkQFlorfQVqp3s=
Received: from BL1PR13CA0084.namprd13.prod.outlook.com (2603:10b6:208:2b8::29)
 by BY5PR12MB4211.namprd12.prod.outlook.com (2603:10b6:a03:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 10:23:30 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:2b8:cafe::57) by BL1PR13CA0084.outlook.office365.com
 (2603:10b6:208:2b8::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.13 via Frontend Transport; Wed,
 29 Oct 2025 10:23:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:23:30 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:23:06 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:23:03 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 15/15] crypto: xilinx: Add gcm(aes) support for AMD/Xilinx Versal device
Date: Wed, 29 Oct 2025 15:51:58 +0530
Message-ID: <20251029102158.3190743-16-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251029102158.3190743-1-h.jain@amd.com>
References: <20251029102158.3190743-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|BY5PR12MB4211:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c8e0b60-11cd-4919-6712-08de16d534b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VcmbWzpT0gVndSO2fcHgnlwjo2afIXTLXOuR6d9PqIEDk2p/YG6J+OssqZUD?=
 =?us-ascii?Q?OArp0yE3s2gd1MOuBNyKDIhs4PNndoW1/t+lu9j9T29ARXa7QN7sAYvkurNJ?=
 =?us-ascii?Q?F7AnB92J11Z4svgPtaP/9CUPY7+42ek/xJ4TLUvUHV2pvLXGj98bQFS0gz9R?=
 =?us-ascii?Q?0Ovn4Qyy7+3Gy7TxpLhSfcEhzXKiSLJsVtwg+/HLAr2CPiYKbtppgT6kkAos?=
 =?us-ascii?Q?jizby/X2wRQjqvDWYJ0gFgkL3HJe5ZFPJewhPU/mUZnmC2ulymHEbfDidxWv?=
 =?us-ascii?Q?vPElC9LXREFYdueNyQN/j0ixXzWgaHHYU+n7PTyZL/8lp5USczUCrAhFYJg+?=
 =?us-ascii?Q?9r3ZtldtoN9tg06EvsSb1HiVAs8CGwW2tfMMPj29zIAVGpD3VdFtIMxTldfG?=
 =?us-ascii?Q?FhooXgRo3j562vGOeJU/biDJ8ZMZq3j14/Uely2YlhCSJbh0kXAUiDSKcWH7?=
 =?us-ascii?Q?ad4qqx5Z22k9Q8I4thZ4xNuO8QztJiZsejlvO6ELgvwsNC2o1IjgAjFyKhBR?=
 =?us-ascii?Q?HPv9Cj4gjAzm2FkAme5KERZpJapMRYjwCRVgFdyPec2LsAL13DmkUAnq81HW?=
 =?us-ascii?Q?U5VkmRuRKEW/FzlB+oKVi76GQzJdouY6sTjmMH8ffiLqiJf5H+KM8OsQVhQy?=
 =?us-ascii?Q?BlGtiHg1pt5AVxvGiAFMlVpykNPe38/ZQOYEXs41fHBWYVqn9JqeKd/01+Dh?=
 =?us-ascii?Q?otj23wbNm1X5/WcviCRpXa1AygUNtQlRswTE2ZKl2se83tf0B8mm2zgqZJa7?=
 =?us-ascii?Q?+vEgcjVV2p7jcr53hTF6tP9kxga99NgBbRTFGO6fsiz5OscCn5t87PU1szjT?=
 =?us-ascii?Q?C5xbiFkfVTcEIjLM+fGn76QWkhIFZc8mkffx2JHIltYkbrwM5rV9TvueLixb?=
 =?us-ascii?Q?oT5FR0v79ooIahAwvlj0xyDdFgyOBxZNb0tjm7nFogMby2afj+hC5aC+T4Tz?=
 =?us-ascii?Q?d4gd5k1tKkDpuCP8cGxN/B9u49xemf5WLOs8FI6eAIS97NDWuViN7W5f/R6H?=
 =?us-ascii?Q?96rlOD4EDBKxX19ff/IBvshG4hxsp1YrArHP9nXDtlXJvIkNiOF5Bl1Tpmqy?=
 =?us-ascii?Q?gSLdN/Zo/8qZ31yrLzyksXJdd/3sMM9tDll9xsEZwFUZ8/M/HROtxcMVhqhO?=
 =?us-ascii?Q?jRDniK3aKpJqrbZatP0Ix2y9bqsnHd0lz7DpRaL0cyJNLIhygn3piSJSZO6+?=
 =?us-ascii?Q?13+zDnmr0Y3pVw7mtEzIRO7sf9TJvBetxb5i9gmL21vaTOa6Zhzhz7l/6uHM?=
 =?us-ascii?Q?ZGmnTSt9E9pCSOv/gTJj/V4SbzMk8KOtMORm59tCba3lYsO1QPYjoakngH0p?=
 =?us-ascii?Q?0EhzzoI1IWDieN3uf/KxR94XskK3j4te3SvjOSwCTRDuGCWJ+FQtMQsVz8PT?=
 =?us-ascii?Q?yxn4B0htjj3WDeTJKCWv6c1upi8tr5TlKINIIMp1iaS1waPNpFCFwAatf7iV?=
 =?us-ascii?Q?JajK23uWMpWCD+ibPx5Oab3Ig+8Zm7Gd3jMZb8FDflWfYsVGFwYgKkOXQpbb?=
 =?us-ascii?Q?S1EKzxvY9beKD1W/bb44LkMhPv2NYTT+TIKzmx+A9jzlnbYNR0XemRfGWm9i?=
 =?us-ascii?Q?MqJXrFciqjms8VYGcuepRB+A9BnyHC9aYIzs646S?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:23:30.0830
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8e0b60-11cd-4919-6712-08de16d534b4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4211

Add gcm(aes) algorithm support for AMD/Xilinx Versal devices.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 380 ++++++++++++++++++++++++-
 1 file changed, 377 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 834852a042dd..da2c59cb74e2 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Xilinx ZynqMP AES Driver.
- * Copyright (c) 2020 Xilinx Inc.
+ * Copyright (C) 2020-2022 Xilinx Inc.
+ * Copyright (C) 2022-2025 Advanced Micro Devices, Inc.
  */
 
 #include <crypto/aes.h>
@@ -19,11 +20,13 @@
 #include <linux/string.h>
 
 #define ZYNQMP_DMA_BIT_MASK	32U
+#define VERSAL_DMA_BIT_MASK		64U
 #define XILINX_AES_AUTH_SIZE		16U
 #define XILINX_AES_BLK_SIZE		1U
 #define ZYNQMP_AES_MIN_INPUT_BLK_SIZE	4U
 #define ZYNQMP_AES_WORD_LEN		4U
 
+#define VERSAL_AES_QWORD_LEN		16U
 #define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR	0x01
 #define ZYNQMP_AES_WRONG_KEY_SRC_ERR	0x13
 #define ZYNQMP_AES_PUF_NOT_PROGRAMMED	0xE300
@@ -44,7 +47,9 @@ struct xilinx_aead_drv_ctx {
 	struct aead_engine_alg aead;
 	struct device *dev;
 	struct crypto_engine *engine;
+	u8 keysrc;
 	u8 dma_bit_mask;
+	int (*aes_aead_cipher)(struct aead_request *areq);
 };
 
 struct xilinx_hwkey_info {
@@ -76,6 +81,54 @@ struct zynqmp_aead_req_ctx {
 	enum xilinx_aead_op op;
 };
 
+enum versal_aead_keysrc {
+	VERSAL_AES_BBRAM_KEY = 0,
+	VERSAL_AES_BBRAM_RED_KEY,
+	VERSAL_AES_BH_KEY,
+	VERSAL_AES_BH_RED_KEY,
+	VERSAL_AES_EFUSE_KEY,
+	VERSAL_AES_EFUSE_RED_KEY,
+	VERSAL_AES_EFUSE_USER_KEY_0,
+	VERSAL_AES_EFUSE_USER_KEY_1,
+	VERSAL_AES_EFUSE_USER_RED_KEY_0,
+	VERSAL_AES_EFUSE_USER_RED_KEY_1,
+	VERSAL_AES_KUP_KEY,
+	VERSAL_AES_PUF_KEY,
+	VERSAL_AES_USER_KEY_0,
+	VERSAL_AES_USER_KEY_1,
+	VERSAL_AES_USER_KEY_2,
+	VERSAL_AES_USER_KEY_3,
+	VERSAL_AES_USER_KEY_4,
+	VERSAL_AES_USER_KEY_5,
+	VERSAL_AES_USER_KEY_6,
+	VERSAL_AES_USER_KEY_7,
+	VERSAL_AES_EXPANDED_KEYS,
+	VERSAL_AES_ALL_KEYS,
+};
+
+enum versal_aead_op {
+	VERSAL_AES_ENCRYPT = 0,
+	VERSAL_AES_DECRYPT
+};
+
+enum versal_aes_keysize {
+	HW_AES_KEY_SIZE_128 = 0,
+	HW_AES_KEY_SIZE_256 = 2,
+};
+
+struct versal_init_ops {
+	u64 iv;
+	u32 op;
+	u32 keysrc;
+	u32 size;
+};
+
+struct versal_in_params {
+	u64 in_data_addr;
+	u32 size;
+	u32 is_last;
+};
+
 static int zynqmp_aes_aead_cipher(struct aead_request *req)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -180,6 +233,141 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	return ret;
 }
 
+static int versal_aes_aead_cipher(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	dma_addr_t dma_addr_data, dma_addr_hw_req, dma_addr_in;
+	u32 total_len = req->assoclen + req->cryptlen;
+	struct device *dev = tfm_ctx->dev;
+	struct versal_init_ops *hwreq;
+	struct versal_in_params *in;
+	u32 gcm_offset, out_len;
+	size_t dmabuf_size;
+	size_t kbuf_size;
+	void *dmabuf;
+	char *kbuf;
+	int ret;
+
+	kbuf_size = total_len + XILINX_AES_AUTH_SIZE;
+	kbuf = kmalloc(kbuf_size, GFP_KERNEL);
+	if (unlikely(!kbuf)) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	dmabuf_size = sizeof(struct versal_init_ops) +
+		      sizeof(struct versal_in_params) +
+		      GCM_AES_IV_SIZE;
+	dmabuf = kmalloc(dmabuf_size, GFP_KERNEL);
+	if (unlikely(!dmabuf)) {
+		ret = -ENOMEM;
+		goto buf1_free;
+	}
+
+	dma_addr_hw_req = dma_map_single(dev, dmabuf, dmabuf_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, dma_addr_hw_req))) {
+		ret = -ENOMEM;
+		goto buf2_free;
+	}
+	scatterwalk_map_and_copy(kbuf, req->src, 0, total_len, 0);
+	dma_addr_data = dma_map_single(dev, kbuf, kbuf_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(dev, dma_addr_data))) {
+		dma_unmap_single(dev, dma_addr_hw_req, dmabuf_size, DMA_BIDIRECTIONAL);
+		ret = -ENOMEM;
+		goto buf2_free;
+	}
+	hwreq = dmabuf;
+	in = dmabuf + sizeof(struct versal_init_ops);
+	memcpy(dmabuf + sizeof(struct versal_init_ops) +
+	       sizeof(struct versal_in_params), req->iv, GCM_AES_IV_SIZE);
+	hwreq->iv = dma_addr_hw_req + sizeof(struct versal_init_ops) +
+		    sizeof(struct versal_in_params);
+	hwreq->keysrc = tfm_ctx->keysrc;
+	dma_addr_in = dma_addr_hw_req + sizeof(struct versal_init_ops);
+	if (rq_ctx->op == XILINX_AES_ENCRYPT) {
+		hwreq->op = VERSAL_AES_ENCRYPT;
+		out_len = total_len + crypto_aead_authsize(aead);
+		in->size = req->cryptlen;
+	} else {
+		hwreq->op = VERSAL_AES_DECRYPT;
+		out_len = total_len - XILINX_AES_AUTH_SIZE;
+		in->size = req->cryptlen - XILINX_AES_AUTH_SIZE;
+	}
+
+	if (tfm_ctx->keylen == AES_KEYSIZE_128)
+		hwreq->size = HW_AES_KEY_SIZE_128;
+	else
+		hwreq->size = HW_AES_KEY_SIZE_256;
+
+	/* Request aes key write for volatile user keys */
+	if (hwreq->keysrc >= VERSAL_AES_USER_KEY_0 && hwreq->keysrc <= VERSAL_AES_USER_KEY_7) {
+		ret = versal_pm_aes_key_write(hwreq->size, hwreq->keysrc,
+					      tfm_ctx->key_dma_addr);
+		if (ret)
+			goto unmap;
+	}
+
+	in->in_data_addr = dma_addr_data + req->assoclen;
+	in->is_last = 1;
+	gcm_offset = req->assoclen + in->size;
+	dma_sync_single_for_device(dev, dma_addr_hw_req, dmabuf_size, DMA_BIDIRECTIONAL);
+	ret = versal_pm_aes_op_init(dma_addr_hw_req);
+	if (ret)
+		goto clearkey;
+
+	if (req->assoclen > 0) {
+		/* Currently GMAC is OFF by default */
+		ret = versal_pm_aes_update_aad(dma_addr_data, req->assoclen);
+		if (ret)
+			goto clearkey;
+	}
+	if (rq_ctx->op == XILINX_AES_ENCRYPT) {
+		ret = versal_pm_aes_enc_update(dma_addr_in,
+					       dma_addr_data + req->assoclen);
+		if (ret)
+			goto clearkey;
+
+		ret = versal_pm_aes_enc_final(dma_addr_data + gcm_offset);
+		if (ret)
+			goto clearkey;
+	} else {
+		ret = versal_pm_aes_dec_update(dma_addr_in,
+					       dma_addr_data + req->assoclen);
+		if (ret)
+			goto clearkey;
+
+		ret = versal_pm_aes_dec_final(dma_addr_data + gcm_offset);
+		if (ret) {
+			ret = -EBADMSG;
+			goto clearkey;
+		}
+	}
+	dma_unmap_single(dev, dma_addr_data, kbuf_size, DMA_BIDIRECTIONAL);
+	dma_unmap_single(dev, dma_addr_hw_req, dmabuf_size, DMA_BIDIRECTIONAL);
+	sg_copy_from_buffer(req->dst, sg_nents(req->dst),
+			    kbuf, out_len);
+	dma_addr_data = 0;
+	dma_addr_hw_req = 0;
+
+clearkey:
+	if (hwreq->keysrc >= VERSAL_AES_USER_KEY_0 && hwreq->keysrc <= VERSAL_AES_USER_KEY_7)
+		versal_pm_aes_key_zero(hwreq->keysrc);
+unmap:
+	if (unlikely(dma_addr_data))
+		dma_unmap_single(dev, dma_addr_data, kbuf_size, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_addr_hw_req))
+		dma_unmap_single(dev, dma_addr_hw_req, dmabuf_size, DMA_BIDIRECTIONAL);
+buf2_free:
+	memzero_explicit(dmabuf, dmabuf_size);
+	kfree(dmabuf);
+buf1_free:
+	memzero_explicit(kbuf, kbuf_size);
+	kfree(kbuf);
+err:
+	return ret;
+}
+
 static int zynqmp_fallback_check(struct xilinx_aead_tfm_ctx *tfm_ctx,
 				 struct aead_request *req)
 {
@@ -205,13 +393,40 @@ static int zynqmp_fallback_check(struct xilinx_aead_tfm_ctx *tfm_ctx,
 	return 0;
 }
 
+static int versal_fallback_check(struct xilinx_aead_tfm_ctx *tfm_ctx,
+				 struct aead_request *req)
+{
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+
+	if (tfm_ctx->authsize != XILINX_AES_AUTH_SIZE && rq_ctx->op == XILINX_AES_DECRYPT)
+		return 1;
+
+	if (tfm_ctx->keylen == AES_KEYSIZE_192)
+		return 1;
+
+	if (req->cryptlen < ZYNQMP_AES_MIN_INPUT_BLK_SIZE ||
+	    req->cryptlen % ZYNQMP_AES_WORD_LEN ||
+	    req->assoclen % VERSAL_AES_QWORD_LEN)
+		return 1;
+
+	if (rq_ctx->op == XILINX_AES_DECRYPT &&
+	    req->cryptlen <= XILINX_AES_AUTH_SIZE)
+		return 1;
+
+	return 0;
+}
+
 static int xilinx_handle_aes_req(struct crypto_engine *engine, void *req)
 {
 	struct aead_request *areq =
 				container_of(req, struct aead_request, base);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct xilinx_aead_drv_ctx *drv_ctx;
 	int err;
 
-	err = zynqmp_aes_aead_cipher(areq);
+	drv_ctx = container_of(alg, struct xilinx_aead_drv_ctx, aead.base);
+	err = drv_ctx->aes_aead_cipher(areq);
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, areq, err);
 	local_bh_enable();
@@ -264,6 +479,50 @@ static int zynqmp_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	return err;
 }
 
+static int versal_aes_aead_setkey(struct crypto_aead *aead, const u8 *key,
+				  unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_hwkey_info hwkey;
+	unsigned char keysrc;
+	int err;
+
+	if (keylen == sizeof(struct xilinx_hwkey_info)) {
+		memcpy(&hwkey, key, sizeof(struct xilinx_hwkey_info));
+		if (hwkey.magic != XILINX_KEY_MAGIC)
+			return -EINVAL;
+
+		keysrc = hwkey.type;
+		if ((keysrc >= VERSAL_AES_EFUSE_USER_KEY_0 &&
+		     keysrc  <= VERSAL_AES_USER_KEY_7) &&
+		     keysrc != VERSAL_AES_KUP_KEY) {
+			tfm_ctx->keysrc = keysrc;
+			tfm_ctx->keylen = sizeof(struct xilinx_hwkey_info);
+			return 0;
+		}
+		return -EINVAL;
+	}
+	if (tfm_ctx->keysrc < VERSAL_AES_USER_KEY_0 || tfm_ctx->keysrc > VERSAL_AES_USER_KEY_7)
+		return -EINVAL;
+	if (keylen == AES_KEYSIZE_256 || keylen == AES_KEYSIZE_128) {
+		tfm_ctx->keylen = keylen;
+		memcpy(tfm_ctx->key, key, keylen);
+		dma_sync_single_for_device(tfm_ctx->dev, tfm_ctx->key_dma_addr,
+					   AES_KEYSIZE_256,
+					   DMA_TO_DEVICE);
+	}
+
+	tfm_ctx->fbk_cipher->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	tfm_ctx->fbk_cipher->base.crt_flags |= (aead->base.crt_flags &
+						CRYPTO_TFM_REQ_MASK);
+	err = crypto_aead_setkey(tfm_ctx->fbk_cipher, key, keylen);
+	if (!err)
+		tfm_ctx->keylen = keylen;
+
+	return err;
+}
+
 static int xilinx_aes_aead_setauthsize(struct crypto_aead *aead,
 				       unsigned int authsize)
 {
@@ -309,6 +568,43 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
 
+static int versal_aes_aead_encrypt(struct aead_request *req)
+{
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct aead_request *subreq = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct xilinx_aead_drv_ctx *drv_ctx;
+	int err;
+
+	drv_ctx = container_of(alg, struct xilinx_aead_drv_ctx, aead.base);
+	rq_ctx->op = XILINX_AES_ENCRYPT;
+	if (tfm_ctx->keysrc >= VERSAL_AES_USER_KEY_0 &&
+	    tfm_ctx->keysrc <= VERSAL_AES_USER_KEY_7 &&
+	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
+		return -EINVAL;
+	err = versal_fallback_check(tfm_ctx, req);
+	if (err && (tfm_ctx->keysrc < VERSAL_AES_USER_KEY_0 ||
+		    tfm_ctx->keysrc > VERSAL_AES_USER_KEY_7))
+		return -EOPNOTSUPP;
+	if (err) {
+		aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
+		aead_request_set_callback(subreq, req->base.flags,
+					  NULL, NULL);
+		aead_request_set_crypt(subreq, req->src, req->dst,
+				       req->cryptlen, req->iv);
+		aead_request_set_ad(subreq, req->assoclen);
+		if (rq_ctx->op == XILINX_AES_ENCRYPT)
+			err = crypto_aead_encrypt(subreq);
+		else
+			err = crypto_aead_decrypt(subreq);
+		return err;
+	}
+
+	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
+}
+
 static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 {
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
@@ -342,6 +638,45 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
 
+static int versal_aes_aead_decrypt(struct aead_request *req)
+{
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct aead_request *subreq = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct xilinx_aead_drv_ctx *drv_ctx;
+	int err;
+
+	drv_ctx = container_of(alg, struct xilinx_aead_drv_ctx, aead.base);
+	rq_ctx->op = XILINX_AES_DECRYPT;
+	if (tfm_ctx->keysrc >= VERSAL_AES_USER_KEY_0 &&
+	    tfm_ctx->keysrc <= VERSAL_AES_USER_KEY_7 &&
+	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
+		return -EINVAL;
+
+	err = versal_fallback_check(tfm_ctx, req);
+	if (err &&
+	    (tfm_ctx->keysrc < VERSAL_AES_USER_KEY_0 ||
+	    tfm_ctx->keysrc > VERSAL_AES_USER_KEY_7))
+		return -EOPNOTSUPP;
+	if (err) {
+		aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
+		aead_request_set_callback(subreq, req->base.flags,
+					  NULL, NULL);
+		aead_request_set_crypt(subreq, req->src, req->dst,
+				       req->cryptlen, req->iv);
+		aead_request_set_ad(subreq, req->assoclen);
+		if (rq_ctx->op == XILINX_AES_ENCRYPT)
+			err = crypto_aead_encrypt(subreq);
+		else
+			err = crypto_aead_decrypt(subreq);
+		return err;
+	}
+
+	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
+}
+
 static int xilinx_aes_aead_init(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
@@ -352,7 +687,7 @@ static int xilinx_aes_aead_init(struct crypto_aead *aead)
 	drv_ctx = container_of(alg, struct xilinx_aead_drv_ctx, aead.base);
 	tfm_ctx->dev = drv_ctx->dev;
 	tfm_ctx->keylen = 0;
-	tfm_ctx->keysrc = ZYNQMP_AES_KUP_KEY;
+	tfm_ctx->keysrc = drv_ctx->keysrc;
 
 	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->aead.base.base.cra_name,
 						0,
@@ -399,6 +734,8 @@ static void xilinx_aes_aead_exit(struct crypto_aead *aead)
 }
 
 static struct xilinx_aead_drv_ctx zynqmp_aes_drv_ctx = {
+	.aes_aead_cipher = zynqmp_aes_aead_cipher,
+	.keysrc = ZYNQMP_AES_KUP_KEY,
 	.aead.base = {
 		.setkey		= zynqmp_aes_aead_setkey,
 		.setauthsize	= xilinx_aes_aead_setauthsize,
@@ -428,12 +765,49 @@ static struct xilinx_aead_drv_ctx zynqmp_aes_drv_ctx = {
 	.dma_bit_mask = ZYNQMP_DMA_BIT_MASK,
 };
 
+static struct xilinx_aead_drv_ctx versal_aes_drv_ctx = {
+	.aes_aead_cipher	= versal_aes_aead_cipher,
+	.keysrc = VERSAL_AES_USER_KEY_0,
+	.aead.base = {
+		.setkey		= versal_aes_aead_setkey,
+		.setauthsize	= xilinx_aes_aead_setauthsize,
+		.encrypt	= versal_aes_aead_encrypt,
+		.decrypt	= versal_aes_aead_decrypt,
+		.init		= xilinx_aes_aead_init,
+		.exit		= xilinx_aes_aead_exit,
+		.ivsize		= GCM_AES_IV_SIZE,
+		.maxauthsize	= XILINX_AES_AUTH_SIZE,
+		.base = {
+		.cra_name		= "gcm(aes)",
+		.cra_driver_name	= "versal-aes-gcm",
+		.cra_priority		= 300,
+		.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+					  CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY |
+					  CRYPTO_ALG_KERN_DRIVER_ONLY |
+					  CRYPTO_ALG_NEED_FALLBACK,
+		.cra_blocksize		= XILINX_AES_BLK_SIZE,
+		.cra_ctxsize		= sizeof(struct xilinx_aead_tfm_ctx),
+		.cra_module		= THIS_MODULE,
+		}
+	},
+	.aead.op = {
+		.do_one_request = xilinx_handle_aes_req,
+	},
+	.dma_bit_mask = VERSAL_DMA_BIT_MASK,
+};
+
 static struct xlnx_feature aes_feature_map[] = {
 	{
 		.family = PM_ZYNQMP_FAMILY_CODE,
 		.feature_id = PM_SECURE_AES,
 		.data = &zynqmp_aes_drv_ctx,
 	},
+	{
+		.family = PM_VERSAL_FAMILY_CODE,
+		.feature_id = XSECURE_API_AES_OP_INIT,
+		.data = &versal_aes_drv_ctx,
+	},
 	{ /* sentinel */ }
 };
 
-- 
2.49.1

