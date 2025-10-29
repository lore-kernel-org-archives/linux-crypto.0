Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A92D303C9B;
	Wed, 29 Oct 2025 10:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733384; cv=fail; b=lI2W2mfUkugs4TKirDn2/Jfwe9VNaCGLpSpvUAA5b3H/+MA7tgjZn7jXnh90+oiAi2fcJ9qZcFrzGK7J7iEVlVF1eAGkwH8B/TRiZAQTeIk8d5/ZR43iEs0vG/4GBus3e6MB6R2RjV0AbHxYQ9ONnn5Hki1uRdiVcBy1J9XU9hk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733384; c=relaxed/simple;
	bh=InA1iH7K8r2Ci/hPrAfswC/5FmaKyZR03NhdwEdMQSg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y21beU5gmdgteHR3yY1bEkBLYX6I1DYeNSjXm0siZ3s32D5eSxvTszlGgtWGVXktKxlfh8B+/gNjQhhgcFiKbPAy+O3/Ao/Un3mTUZJ4DcsdVT2kBV67nAwSgip8QbzTArqRDo1jUUIu4NO9frdvlk2Yt7HEkm8rgdV0F6mQKS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dR77Ysxa; arc=fail smtp.client-ip=52.101.61.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dR77Ysxa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y9ntreq71I58KCp1L0gZ3Z64YFUJ+opWGY+yacjsik2kOjjCyz8DyCXqDRMB2luCc6vuvbclEXx7oMQv3gLefd2jwO9lFbt6lvg7MupFEizueoTNiDJR05G7bv1u4f4DXITs1v+qrGbSwbE5MPsENmt6rjnLg13bu38VRYbByNh/2nG4InefZaJGf+WoQXvQjBExpjtxizqFxRLBlP1Op81QjUuMryNDutp/yh31vtIbc5bY4ueVQ4g6v+YoNi+2xnFIdPlbKYmLtUQYhCNox5mCkMpqg+EYVhtsBmeRpxMA4l3yxoekL2aAKwMgpGG1lfYX9SakKBgl/evXrh/fbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdzPFTclVKOXYxNUhD4Tgm5k/ts6pTcO8CO9breQqME=;
 b=SlIR/ommDXCWPLa+zyWZ2iMbdBkKTU9mXQL8EDfZ5sJ2DU9Y6RdlQqa+sa8rkRgccT4K2Nyo8EBd1XwmSF4cOdRV8/Zwcy8oPS3TboEkjhKlkogxiwCRVN2Vd57HZ35jxodITFheSeSvHDS1h5vVSCyK6H14JG3FmL7mWEbo4IYkMGLR7o12NMBwjJ6gwSTGxcxT/UOSudSolQo3E38OutQGadcCqkr3pe73b+E62YebZ3P1X2U/GMuP6/IG1g2Oh56696aiX60EUL0qveeUE64lZZz2xW7S004MOnDZ0oS1p/vbSuBQ727zFqGODN9c5YZDDpoBB9mwMtyPT2vNhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdzPFTclVKOXYxNUhD4Tgm5k/ts6pTcO8CO9breQqME=;
 b=dR77Ysxa/KiXj9TDkfUHRRaGLRyciwXXgdgz/i5l/lLOJFQ4wU9G+QLxbkxeOr76K5j8mvEpgF6vKEMFELFxnVguinao4zWD/YOrXyDAO8auVVQ41bI42PQO04npVYOgkD5mT4r/+MG95t79khj2BCTJ6jkarLJeD8EAv5PJJ2s=
Received: from BL1PR13CA0086.namprd13.prod.outlook.com (2603:10b6:208:2b8::31)
 by SJ0PR12MB6925.namprd12.prod.outlook.com (2603:10b6:a03:483::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 10:22:58 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:2b8:cafe::98) by BL1PR13CA0086.outlook.office365.com
 (2603:10b6:208:2b8::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.13 via Frontend Transport; Wed,
 29 Oct 2025 10:22:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:22:57 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:34 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 29 Oct
 2025 05:22:34 -0500
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:22:31 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 06/15] crypto: zynqmp-aes-gcm: Return linux error code instead of firmware error code
Date: Wed, 29 Oct 2025 15:51:49 +0530
Message-ID: <20251029102158.3190743-7-h.jain@amd.com>
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
Received-SPF: None (SATLEXMB05.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|SJ0PR12MB6925:EE_
X-MS-Office365-Filtering-Correlation-Id: d6ec825b-0b49-4c61-6af1-08de16d52159
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iGYp0TcuMXVcYHHrMETjYs2dXXS4ApWvWyMPOd+Y7BevPEAnrq7g8xXCvO8X?=
 =?us-ascii?Q?Zvk3wQVAHNDtLMNB3qFLpQpA0MHu5OBrn/AYwwwymuVm0p3FOpIsKnMqoY+/?=
 =?us-ascii?Q?I5qiUI475pcDJ6rlVsUhSZHngWche9vfhusNvouwIKLt7t0gr9c1m4jM/WtK?=
 =?us-ascii?Q?4suG2vcUd0isErvCB317p01vsKj1kB9M7e9znICg+HUXYgbtiUqQEZ1i/TeA?=
 =?us-ascii?Q?aEaDRjF6i82kl1jKSAN5fgYIzsDMLkWC8F6NkLw7znWjN16uzrnMyIFd9Rje?=
 =?us-ascii?Q?D3PFnN3AgXSKchE75KZGa8JWaDvNaYsXH2672UH7RaBUoaJZUoTvNQE4cz4C?=
 =?us-ascii?Q?keQpBc3YPFVAnFb9T6ChSGhIsdqoX7JJVrHsaTBJPxAN4YGivvbac2/eTxqy?=
 =?us-ascii?Q?aWfAByQ75cWI4Sa9BgfU2uDz2GTi/Iaqde1goaCGmq7nN7Uu0t6hlpMBlgeL?=
 =?us-ascii?Q?yNPdLfs8yCvHZ0nJYVvnd1a82GK3dhFI9LkGaPE1ULtIdRVcYIei6ogGc8mA?=
 =?us-ascii?Q?ymQUlW7E4QZSoGnX3WTs4we4e2M8sCaMkSMImhDHhp70qW+cD3fPZV9RWlFr?=
 =?us-ascii?Q?2BY2DTwFSyY8TlroqMJstOABdZ3Rh6tgak0Pigg9jJ0BeLLAQN1L3A29LBRf?=
 =?us-ascii?Q?j+FhbWDjuvixHzjBJsFJ22+jE6jMS7hfq56CsL/63dsfngqzu9KyhpXFltR/?=
 =?us-ascii?Q?m3dtxP3e02i7agu7WWEQrAffUXJiS09xHFEw9i2QrOc2+8QcTA1fGnEpFrvd?=
 =?us-ascii?Q?xFgUHwhGl2xbeq2dKlWlQLoNzYgf0HbYHUIkzJRCTvT7xSUcLXuGHDaerL9d?=
 =?us-ascii?Q?6gu64Ft5Bf9k9DC31tjkJ4qsFJcCAha+o6MnFZ9Djf+qHBA0XLHR9n7iYV4d?=
 =?us-ascii?Q?FGShpO8yUfhrVVzcy4jlr8x7eeLaHd/bPJDIMjtKDjb8HQ5i+Elhsd3dvAaW?=
 =?us-ascii?Q?GNACtlhMwLdnZ3WLlZwdRuThvkeKaGt2LD/auAgftBUX+XLYJNIp8rqFeeXO?=
 =?us-ascii?Q?aTFZYR2QjfmQL7nytDuBCuvRLOcQTy7fvhKH1Y/dmTS2XCGgq1bJfAwlfZbh?=
 =?us-ascii?Q?l2LwPxRy0KKbUWUkO3GZobrHqQGbl0d0LgTY3jI6PLiP0GFG5nLVdUwmqqNh?=
 =?us-ascii?Q?iLpfx8GNGpf/YrDBeAstsCr2WRD4dU3+vMek8LS+V+ZEm8ujfmyGzxusBac6?=
 =?us-ascii?Q?R6CGSuymXrFuOTPTDu0XkpXn7HhkQ2Y65skneAS6VB/5G7r8ExyBxxprDirB?=
 =?us-ascii?Q?CRzItXYazj3ZN5sLlT1eToEPjPvZp/MNA14RxJYFgHypiBT6Pyi9l9pA1opR?=
 =?us-ascii?Q?x5QYO0UW4mB/B6LOlvZSE1Bf6W0vbuDfPZifWCmgfLgx4zfrze+UFnegpr1U?=
 =?us-ascii?Q?fWzZ0mZ/0wDRX1tcDDEcWwsd0cjJT/nRsYVY3JbTL3TbkcclSQ+50Q43UX7Y?=
 =?us-ascii?Q?xJd80eV9V017uFZlONQCkEL4xGxP1u6jwewHAEPFFxXO1PBeuGsIuBmI42u2?=
 =?us-ascii?Q?FSb3dwmEnmtQ9KWJIfJL3JpZqdkxO8+X5iz2A2A6+GVdQJ3bIH7e0e+5mQKM?=
 =?us-ascii?Q?ZXt7snahyeIm8KEebXRYc+IcDYe9oz2L2NNLTRok?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:22:57.6112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ec825b-0b49-4c61-6af1-08de16d52159
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6925

Convert FW error code to linux error code and remove dmesg error print for
authentication tag mismatch failure.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 04473ed9f08d..e64316d9cabf 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -85,7 +85,6 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 	int ret;
 	size_t dma_size;
 	char *kbuf;
-	int err;
 
 	if (tfm_ctx->keysrc == ZYNQMP_AES_KUP_KEY)
 		dma_size = req->cryptlen + ZYNQMP_AES_KEY_SIZE
@@ -132,23 +131,23 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 
 	if (ret) {
 		dev_err(dev, "ERROR: AES PM API failed\n");
-		err = ret;
 	} else if (status) {
 		switch (status) {
 		case ZYNQMP_AES_GCM_TAG_MISMATCH_ERR:
-			dev_err(dev, "ERROR: Gcm Tag mismatch\n");
+			ret = -EBADMSG;
 			break;
 		case ZYNQMP_AES_WRONG_KEY_SRC_ERR:
+			ret = -EINVAL;
 			dev_err(dev, "ERROR: Wrong KeySrc, enable secure mode\n");
 			break;
 		case ZYNQMP_AES_PUF_NOT_PROGRAMMED:
+			ret = -EINVAL;
 			dev_err(dev, "ERROR: PUF is not registered\n");
 			break;
 		default:
-			dev_err(dev, "ERROR: Unknown error\n");
+			ret = -EINVAL;
 			break;
 		}
-		err = -status;
 	} else {
 		if (hwreq->op == ZYNQMP_AES_ENCRYPT)
 			data_size = data_size + ZYNQMP_AES_AUTH_SIZE;
@@ -157,7 +156,7 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 
 		sg_copy_from_buffer(req->dst, sg_nents(req->dst),
 				    kbuf, data_size);
-		err = 0;
+		ret = 0;
 	}
 
 	if (kbuf) {
@@ -169,7 +168,8 @@ static int zynqmp_aes_aead_cipher(struct aead_request *req)
 		dma_free_coherent(dev, sizeof(struct zynqmp_aead_hw_req),
 				  hwreq, dma_addr_hw_req);
 	}
-	return err;
+
+	return ret;
 }
 
 static int zynqmp_fallback_check(struct zynqmp_aead_tfm_ctx *tfm_ctx,
-- 
2.49.1

