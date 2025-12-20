Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011016.outbound.protection.outlook.com [40.93.194.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38652D594B;
	Sat, 20 Dec 2025 16:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246425; cv=fail; b=YO+DANsibuzU4n/NZuq2P467DlkqHN9Hy+RdZdBQMzD0LM8njvxflZLozvKXuDJS16E7ogCkKtbZ9Iv/0VPTDzy8C8++oB/YPpDGAss5SNmo3T7dqzMUanDHlAt7lL3X3TJUh9byzn8YzCvaoMZTaJJYnydMV9iHkmx84IRsLKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246425; c=relaxed/simple;
	bh=9UbeRKA5PPU00/0HM3bpp6uhmmRNIaq3pCA3WcfRHDg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ug6uyCkL34IsLmCQUIaj6CXLOjQ2ixcmUtK6H/8APFL7QknNQsMINvJjoa3onrdkF3sOmNqiDezs09yR7L8iU7GqewUli0lJcmN0VTuOFfuDyFfvqSN46oVjF1OIK+g4diYJ1cMdpag93X/b0QCOONIROetKfHh/CAYvKC6oFJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iSpx0wVS; arc=fail smtp.client-ip=40.93.194.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iSpx0wVS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TH/9cYdIjkGNBvPrz4t8Ehc0p/U2Q1e9kJrRK1ZFVC6in6B+txzJIfLUT3VpYozdfwwcrcd8WrPZ8GaTmOcwsnFAQdZaJv5OKfDe5ZMhzP21ZYSPKJBsvXyuCprMZbNZKXmqBpmx4UlWnvBN6HgDgTZazfUYoQV5AV8Jp0bvuoNFqXiQe3lAKk1jF85D0x3JhJF/GgYX9c98KgawqjAPVZ6LZcrBhqw6M95Ia35B0aMQ+DGtwq8J12FZBzXRJPICd+eEKPHQI2iApXWB9Eh1p4zYaD3blCS84iR/msVuBs58GaxCaT4vNHdR08hJUjOqosJOBLqYQpOnm04GcHjL4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXqyXp8ANmC0p4fTMjsO3SqiB3wISXA2rFDNFxTEEIU=;
 b=fuPsQuL5AxInciUeQ+Nk7dNczZJEEozGI0YiltiKbLgafVVc/HEFk1bdbN91piWJbAherpKk5JwuFUKt53BnzSgJ1IcnqA9h9EGlPDth3ZbFX4wDEl8XRulJ6hiJeY4tIzGBPxL4T9pT3Pplrs/qGlVM3EQ9gNJv9BOoa4TCl56aT67dKt5wS3scsOt+AuMUuSyIA6bTwymaZ4GAmyWMKsrJOjOt7EWG+MlO5cZ08HIQay4Kd4wqvO3o7flp46ey3Bxzb9QegN+hFeQnwrbDUad1G8ossk4GpHSRGl7SAhQP/ner/wmeEwadrkJVDikNg9U9vlDngCbqWUsWFKWhWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXqyXp8ANmC0p4fTMjsO3SqiB3wISXA2rFDNFxTEEIU=;
 b=iSpx0wVS3nmR9D/LtnwnWpcnKCdkQCE/malYJXJ1BfI8F4qWpkP9YV4Zf5RywWtsEDUb3PTmu2hhFIWFqMMuX2WC4stOpnMt5hMCgDMsadClyPAVWDsKm9h3cDC1vYdos81lNeEtNgn6Snsm6IVazVuLe4lRxlG3iARPEUHa7j4=
Received: from SA1P222CA0121.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::9)
 by MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.10; Sat, 20 Dec
 2025 16:00:17 +0000
Received: from SA2PEPF00003F62.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::1e) by SA1P222CA0121.outlook.office365.com
 (2603:10b6:806:3c5::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.10 via Frontend Transport; Sat,
 20 Dec 2025 16:00:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F62.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Sat, 20 Dec 2025 16:00:15 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 10:00:07 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 08:00:04 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 14/14] crypto: xilinx: Add gcm(aes) support for AMD/Xilinx Versal device
Date: Sat, 20 Dec 2025 21:29:05 +0530
Message-ID: <20251220155905.346790-15-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251220155905.346790-1-h.jain@amd.com>
References: <20251220155905.346790-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F62:EE_|MW4PR12MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cb5a8f2-f620-4c4c-e5e3-08de3fe0ddce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uBydUUQ8oeM1gS2qbjqyk85gxNzmNxaXEL3zxyMtnTthmnYDH2uXAgRu0Cls?=
 =?us-ascii?Q?L9tjtwr4tc3ous4ARsJgy30YhNZPahM1eo2OTpCBlKZgY1nmv9eS7IpVxofs?=
 =?us-ascii?Q?A0hPh4SSifhcjYc7Je6FxfWFoh0XzTH8yuchUOl9cSDnDK9w7DAJM5TFntWD?=
 =?us-ascii?Q?vHw7t7jrvme02+J6HLGUKCPbEfKk8g7Nv9JaZxg33y9GhVaueGLQgFvUt8CV?=
 =?us-ascii?Q?fdIKmO9pnvz5w8g6nvJjIxwSDKsHTlPoUXoGUoUiO9esp5sYApFpoEgZDV9z?=
 =?us-ascii?Q?WmbW/NymiljUqA7pnqLpUtgMaRT8qOAUlm+zcpHyPNQ8iuFs9CVC+ZimM4W6?=
 =?us-ascii?Q?yDIh/YD2Ha45tYAOWHF4b4FaGjasJu5hcSf5Ef5eRInwIEvbya57XmuxHGt1?=
 =?us-ascii?Q?2S07W9/kgkjcndWQ/co/WzsgpGWwr2nrXrd6f8F6lpDTYqk9JiVbUaTDMx6M?=
 =?us-ascii?Q?8MGEK86usyrUje/NH08wDydeY2YpsDSayaDeZLNmzz+aiUYZGnv+fIerqvtW?=
 =?us-ascii?Q?Q6CBDAEMFh5IdUgyjJgZDzQZX/Gof2gRlhSujAAA7QeG7ZkeR/w4/f8WVdbQ?=
 =?us-ascii?Q?RqFk+iqtc76bfrgINYV7CocnAQ9OV5JOscQRsvNponaUHa8emGyt2KjaFHjq?=
 =?us-ascii?Q?Lmgug0LETmyl7L3mDWDJT890sKmYPAPRViqOBcOtgTX+Gt/f64zeaqYrtBVJ?=
 =?us-ascii?Q?WegTnBL1AzUBvc/9QI5iwQGVE0dZtuENM9WhnCIxhP6EyeLbgasWE/fsCWDu?=
 =?us-ascii?Q?dwuRnrgqvn/J/q4zmElV7LaLDoowY4ukb2DnpOjmOo8K0buD/sxE8cXm9Ge3?=
 =?us-ascii?Q?IdVbfnazc4kHduweGkGMjZXCJiaadPFbv204v1THHMrZDsXawudCvn6D0SFP?=
 =?us-ascii?Q?tJO5WbT187Ve2PwHtu+omsTwtepuLJU4sN0nc+NsSuA/ukHGKDAyaXKpO/Mp?=
 =?us-ascii?Q?DnKqy0UsF2k+n7tG3rLV54q50trnFBxbYqugZ250MHCzo/7F3vsrF2B0/18i?=
 =?us-ascii?Q?4n3wUVOA4pC3WyFUqsf79Y3hBsON/mbIr/Bdaz2e6mNz1PO/I6cgCZ10M54S?=
 =?us-ascii?Q?4mVXMKyveDBYl2XgByrh7IvGwP0yTLh5bJCnOMMYIXrK/rYg44zJaXq/QP+q?=
 =?us-ascii?Q?2ccnCiOFUV2UCSicAxPnZ0FsI0IDfxDzXw7F4mkOamAgu/9vcYxx42PA/wed?=
 =?us-ascii?Q?ojwc0k++CSjhAl0yG7wVOZNxQtYk8pQy2xsB+8Q/p1EN/+oQf2Z2bhNpVLwZ?=
 =?us-ascii?Q?CVj4NOXIZpvhymx4RlR+xLhGZjeBQq0L6eGAtAy4HDRYxOxto9dleQ8ruUqF?=
 =?us-ascii?Q?1YOj6OE5VHBFh2oxhQ8Z3BLCoUiFLoECaQ/RFPDzDX4oA2Ugu0WsN3Zi3cxf?=
 =?us-ascii?Q?ks1zzanvcBCAI0C9wFbgRdqvIwSLHa4cOseG0GOsBLfZZ8fCnP4RJP5UjUcf?=
 =?us-ascii?Q?fmxv4FMSP55aYJh0z02IIghr1fPpa+oYP/0b/1FEdOdO2W4TTOgcu7GONhAT?=
 =?us-ascii?Q?Ulwshn2XSnq6jyG9su8HO3warWphvelL2gVbYVfVfqmFO7ZLSdhWZs0lZ68k?=
 =?us-ascii?Q?bgLsuLromDBZU4P7GHBjWOYHQge74gWIDDKtKQKz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 16:00:15.9384
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb5a8f2-f620-4c4c-e5e3-08de3fe0ddce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7213

Add gcm(aes) algorithm support for AMD/Xilinx Versal devices.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 430 ++++++++++++++++++++++++-
 1 file changed, 421 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 80b0ace7b5ca..53c9cb2224bd 100644
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
@@ -49,6 +52,7 @@ struct xilinx_aead_dev {
 struct xilinx_aead_alg {
 	struct xilinx_aead_dev *aead_dev;
 	struct aead_engine_alg aead;
+	int (*aes_aead_cipher)(struct aead_request *areq);
 	u8 dma_bit_mask;
 };
 
@@ -83,6 +87,54 @@ struct xilinx_aead_req_ctx {
 
 static struct xilinx_aead_dev *aead_dev;
 
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
@@ -187,6 +239,141 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	return ret;
 }
 
+static int versal_aes_aead_cipher(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
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
@@ -212,13 +399,40 @@ static int zynqmp_fallback_check(struct xilinx_aead_tfm_ctx *tfm_ctx,
 	return 0;
 }
 
+static int versal_fallback_check(struct xilinx_aead_tfm_ctx *tfm_ctx,
+				 struct aead_request *req)
+{
+	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
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
+	struct xilinx_aead_alg *drv_ctx;
 	int err;
 
-	err = zynqmp_aes_aead_cipher(areq);
+	drv_ctx = container_of(alg, struct xilinx_aead_alg, aead.base);
+	err = drv_ctx->aes_aead_cipher(areq);
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, areq, err);
 	local_bh_enable();
@@ -278,6 +492,84 @@ static int zynqmp_paes_aead_setkey(struct crypto_aead *aead, const u8 *key,
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
+	tfm_ctx->keysrc = VERSAL_AES_USER_KEY_0;
+	if (keylen == sizeof(struct xilinx_hwkey_info)) {
+		memcpy(&hwkey, key, sizeof(struct xilinx_hwkey_info));
+		if (hwkey.magic != XILINX_KEY_MAGIC)
+			return -EINVAL;
+
+		keysrc = hwkey.type;
+		if (keysrc >= VERSAL_AES_USER_KEY_1 &&
+		    keysrc  <= VERSAL_AES_USER_KEY_7) {
+			tfm_ctx->keysrc = keysrc;
+			tfm_ctx->keylen = sizeof(struct xilinx_hwkey_info);
+			return 0;
+		}
+		return -EINVAL;
+	}
+
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
+static int versal_paes_aead_setkey(struct crypto_aead *aead, const u8 *key,
+				   unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_tfm_ctx(tfm);
+	struct xilinx_hwkey_info hwkey;
+	unsigned char keysrc;
+	int err = 0;
+
+	if (keylen != sizeof(struct xilinx_hwkey_info))
+		return -EINVAL;
+
+	memcpy(&hwkey, key, sizeof(struct xilinx_hwkey_info));
+	if (hwkey.magic != XILINX_KEY_MAGIC)
+		return -EINVAL;
+
+	keysrc = hwkey.type;
+
+	switch (keysrc) {
+	case VERSAL_AES_EFUSE_USER_KEY_0:
+	case VERSAL_AES_EFUSE_USER_KEY_1:
+	case VERSAL_AES_EFUSE_USER_RED_KEY_0:
+	case VERSAL_AES_EFUSE_USER_RED_KEY_1:
+	case VERSAL_AES_PUF_KEY:
+		tfm_ctx->keysrc = keysrc;
+		tfm_ctx->keylen = sizeof(struct xilinx_hwkey_info);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
+
 static int xilinx_aes_aead_setauthsize(struct crypto_aead *aead,
 				       unsigned int authsize)
 {
@@ -328,6 +620,31 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	return crypto_transfer_aead_request_to_engine(drv_ctx->aead_dev->engine, req);
 }
 
+static int versal_aes_aead_encrypt(struct aead_request *req)
+{
+	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct xilinx_aead_alg *drv_ctx;
+	int err;
+
+	drv_ctx = container_of(alg, struct xilinx_aead_alg, aead.base);
+	rq_ctx->op = XILINX_AES_ENCRYPT;
+	if (tfm_ctx->keysrc >= VERSAL_AES_USER_KEY_0 &&
+	    tfm_ctx->keysrc <= VERSAL_AES_USER_KEY_7 &&
+	    tfm_ctx->keylen == sizeof(struct xilinx_hwkey_info))
+		return -EINVAL;
+	err = versal_fallback_check(tfm_ctx, req);
+	if (err && (tfm_ctx->keysrc < VERSAL_AES_USER_KEY_0 ||
+		    tfm_ctx->keysrc > VERSAL_AES_USER_KEY_7))
+		return -EOPNOTSUPP;
+	if (err)
+		return xilinx_aes_fallback_crypt(req, true);
+
+	return crypto_transfer_aead_request_to_engine(drv_ctx->aead_dev->engine, req);
+}
+
 static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 {
 	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
@@ -368,6 +685,33 @@ static int xilinx_paes_aead_init(struct crypto_aead *aead)
 	return 0;
 }
 
+static int versal_aes_aead_decrypt(struct aead_request *req)
+{
+	struct xilinx_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct xilinx_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct xilinx_aead_alg *drv_ctx;
+	int err;
+
+	drv_ctx = container_of(alg, struct xilinx_aead_alg, aead.base);
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
+	if (err)
+		return xilinx_aes_fallback_crypt(req, false);
+
+	return crypto_transfer_aead_request_to_engine(drv_ctx->aead_dev->engine, req);
+}
+
 static int xilinx_aes_aead_init(struct crypto_aead *aead)
 {
 	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
@@ -384,8 +728,8 @@ static int xilinx_aes_aead_init(struct crypto_aead *aead)
 						CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(tfm_ctx->fbk_cipher)) {
-		pr_err("%s() Error: failed to allocate fallback for %s\n",
-		       __func__, drv_ctx->aead.base.base.cra_name);
+		dev_err(tfm_ctx->dev, "failed to allocate fallback for %s\n",
+			drv_ctx->aead.base.base.cra_name);
 		return PTR_ERR(tfm_ctx->fbk_cipher);
 	}
 	tfm_ctx->key = kmalloc(AES_KEYSIZE_256, GFP_KERNEL);
@@ -433,6 +777,7 @@ static void xilinx_aes_aead_exit(struct crypto_aead *aead)
 
 static struct xilinx_aead_alg zynqmp_aes_algs[] = {
 	{
+		.aes_aead_cipher = zynqmp_aes_aead_cipher,
 		.aead.base = {
 			.setkey		= zynqmp_aes_aead_setkey,
 			.setauthsize	= xilinx_aes_aead_setauthsize,
@@ -462,6 +807,7 @@ static struct xilinx_aead_alg zynqmp_aes_algs[] = {
 		.dma_bit_mask = ZYNQMP_DMA_BIT_MASK,
 	},
 	{
+		.aes_aead_cipher = zynqmp_aes_aead_cipher,
 		.aead.base = {
 			.setkey		= zynqmp_paes_aead_setkey,
 			.setauthsize	= xilinx_aes_aead_setauthsize,
@@ -492,12 +838,80 @@ static struct xilinx_aead_alg zynqmp_aes_algs[] = {
 	{ /* sentinel */ }
 };
 
+static struct xilinx_aead_alg versal_aes_algs[] = {
+	{
+		.aes_aead_cipher = versal_aes_aead_cipher,
+		.aead.base = {
+			.setkey		= versal_aes_aead_setkey,
+			.setauthsize	= xilinx_aes_aead_setauthsize,
+			.encrypt	= versal_aes_aead_encrypt,
+			.decrypt	= versal_aes_aead_decrypt,
+			.init		= xilinx_aes_aead_init,
+			.exit		= xilinx_aes_aead_exit,
+			.ivsize		= GCM_AES_IV_SIZE,
+			.maxauthsize	= XILINX_AES_AUTH_SIZE,
+			.base = {
+			.cra_name		= "gcm(aes)",
+			.cra_driver_name	= "versal-aes-gcm",
+			.cra_priority		= 300,
+			.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
+			.cra_blocksize		= XILINX_AES_BLK_SIZE,
+			.cra_ctxsize		= sizeof(struct xilinx_aead_tfm_ctx),
+			.cra_module		= THIS_MODULE,
+			}
+		},
+		.aead.op = {
+			.do_one_request = xilinx_handle_aes_req,
+		},
+		.dma_bit_mask = VERSAL_DMA_BIT_MASK,
+	},
+	{
+		.aes_aead_cipher = versal_aes_aead_cipher,
+		.aead.base = {
+			.setkey		= versal_paes_aead_setkey,
+			.setauthsize	= xilinx_aes_aead_setauthsize,
+			.encrypt	= versal_aes_aead_encrypt,
+			.decrypt	= versal_aes_aead_decrypt,
+			.init		= xilinx_paes_aead_init,
+			.exit		= xilinx_paes_aead_exit,
+			.ivsize		= GCM_AES_IV_SIZE,
+			.maxauthsize	= XILINX_AES_AUTH_SIZE,
+			.base = {
+			.cra_name		= "gcm(paes)",
+			.cra_driver_name	= "versal-paes-gcm",
+			.cra_priority		= 300,
+			.cra_flags		= CRYPTO_ALG_TYPE_AEAD |
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_ALLOCATES_MEMORY |
+						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize		= XILINX_AES_BLK_SIZE,
+			.cra_ctxsize		= sizeof(struct xilinx_aead_tfm_ctx),
+			.cra_module		= THIS_MODULE,
+			}
+		},
+		.aead.op = {
+			.do_one_request = xilinx_handle_aes_req,
+		},
+		.dma_bit_mask = VERSAL_DMA_BIT_MASK,
+	},
+	{ /* sentinel */ }
+};
+
 static struct xlnx_feature aes_feature_map[] = {
 	{
 		.family = PM_ZYNQMP_FAMILY_CODE,
 		.feature_id = PM_SECURE_AES,
 		.data = zynqmp_aes_algs,
 	},
+	{
+		.family = PM_VERSAL_FAMILY_CODE,
+		.feature_id = XSECURE_API_AES_OP_INIT,
+		.data = versal_aes_algs,
+	},
 	{ /* sentinel */ }
 };
 
@@ -534,14 +948,13 @@ static int xilinx_aes_aead_probe(struct platform_device *pdev)
 	aead_dev->engine = crypto_engine_alloc_init(dev, 1);
 	if (!aead_dev->engine) {
 		dev_err(dev, "Cannot alloc AES engine\n");
-		err = -ENOMEM;
-		goto err_engine;
+		return -ENOMEM;
 	}
 
 	err = crypto_engine_start(aead_dev->engine);
 	if (err) {
 		dev_err(dev, "Cannot start AES engine\n");
-		goto err_engine;
+		goto err_engine_start;
 	}
 
 	for (i = 0; aead_dev->aead_algs[i].dma_bit_mask; i++) {
@@ -552,14 +965,13 @@ static int xilinx_aes_aead_probe(struct platform_device *pdev)
 			goto err_alg_register;
 		}
 	}
-	return 0;
 
 	return 0;
 
 err_alg_register:
 	while (i > 0)
 		crypto_engine_unregister_aead(&aead_dev->aead_algs[--i].aead);
-err_engine:
+err_engine_start:
 	crypto_engine_exit(aead_dev->engine);
 
 	return err;
-- 
2.49.1

