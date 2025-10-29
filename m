Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012009.outbound.protection.outlook.com [52.101.53.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C05306B0C;
	Wed, 29 Oct 2025 10:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733347; cv=fail; b=Wuy8D/CQGysH6s0lPtkotzvcLafYQoOvQS69JX4Sgv3QoLHtd7AbfCEQ9r15KrYZbLIWqINic4oI9dncrb8ThnZmtNWJcBofbop8QjWCglAEGmS6vVJnEF2HNkbe8qzLDjtXZx64Pu7v1aMYj2LqTH+/bsc7jY5H+lRRQClY2U8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733347; c=relaxed/simple;
	bh=RtlywX7Spo3VplwOaoK4+lB6nk/K8oMYXi5qRlIKkz0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aUI+dX88UIiK1Z8+bwoYOZCqbuB+U5QXGuiuw6FpncKAQTL+NRNyk0BNZU8mtOKlsReNWp54RZx7l0jUZBIlUtz3NXtOdZbp7mpivz62VCrfPL/BlSZoqWsSDEKWpjoxOTtzwkwbAVksmS6qMLTOYsoHaw7IZTsZGg++FCr1k9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NbLF7EFt; arc=fail smtp.client-ip=52.101.53.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NbLF7EFt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jeexzwGHusP/MNqEc+DgPYeksGOS/snPL806hRxehm2jv+uLG+SzWXfXRvFTTvi0Dr+XlBcFbq2sAVkLBCHBloC/vdBtwvQVMWlwwlhQWyc3/33rS2IV+ayFviGyQdSAWn//B4/X/nLjxfXffNel9j4MQVKR+wvCkDPibP50NTUa3nddCk92QHtLeLtKd2wjuieO8PinxJGCSE947xg/+3o5t6+AAbBFU4y3ZoYMnNhLKGfAJCo5C00K8T67QRbQ6elQ6683LQU8Ql64pY+uPAEDlrkgPSBYkZEYLEcNZyNR6X+S4pm6SR558XOcdD6Sc0iUgFuYJodeQ9gwuizZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUMRK8zl+KuFVCo5rGg+8JQJSK5NQArsC55bI/pBxgo=;
 b=aYOetx/m9XiwA1QXRf57JWlypEyfl9AGy6Y3hYVjoc10JIwco3+J/X8wDOyt7gVZw6Klg+YBTVNsw4M7Npk6S2SbaTZ6V3IKFZrwf1mnKnHmFYa5/YORvzDHoIm7fIxlMYkXlyYzXkdABb0kx6r6CeeifeZk4KadS5CxhrdwZD3rte2jb9RScj+gwIR0GLxRvKtdUkCYfiph8fKUttKskQVsFRaxKCiPmv99pzzQUqdkW1BXuXfGGZ6ZbVKvu+xu4uurmA9QM4S1cMEU8oTtozxJirtFmM5QgwlNg55rOQ2RHP9Dd4wVxednPAhZr1MngRBM1wh0cnQ1deUO3iho5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUMRK8zl+KuFVCo5rGg+8JQJSK5NQArsC55bI/pBxgo=;
 b=NbLF7EFtEaz04BCV10Bpm5N0z2sGEGKRVZbcuLGB6HSwzo++xbs18DUwbnChZlpozQrbLFF3ff4oFQClj7pwWgZt1lk5WawgAOWjBavYVCx1qKHTLGKoWlxUq0db31HXd/hdhXVmRRTFCd4Eljul3jFEd1b9EgmbC+6Iqgh37go=
Received: from SA0PR13CA0025.namprd13.prod.outlook.com (2603:10b6:806:130::30)
 by PH8PR12MB6820.namprd12.prod.outlook.com (2603:10b6:510:1cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Wed, 29 Oct
 2025 10:22:21 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:806:130:cafe::91) by SA0PR13CA0025.outlook.office365.com
 (2603:10b6:806:130::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.4 via Frontend Transport; Wed,
 29 Oct 2025 10:22:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:22:20 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:20 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:19 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:22:16 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 02/15] crypto: zynqmp-aes-gcm: cleanup: Remove union from zynqmp_aead_drv_ctx
Date: Wed, 29 Oct 2025 15:51:45 +0530
Message-ID: <20251029102158.3190743-3-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|PH8PR12MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: 98e01b63-0562-42b3-19f5-08de16d50b50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TuKEGpvRy6vmhE1ZhEfDdLm/jQPUt2Xjm037p7VCd3Z82fj7yyr65AL7edLs?=
 =?us-ascii?Q?IMcsdxH7ijpd87AN/k+97gcAGAkg84BcDVlwYUQlj4UStNEeBCox/+O8rec8?=
 =?us-ascii?Q?O8hYQ4njYHm4fzABiFKtYq3ORwGSw+L/Tcj8zZb3ETlftUb9+5Hhjr9lWInJ?=
 =?us-ascii?Q?Ot3OLnTCoun3L9n17hPMG7mzS0FZb2GENEurerl0IP50uHSBFhfl1fusUpwV?=
 =?us-ascii?Q?IT966d1SOxs4TzZcuz7VLCSCwUiHCx+TTzbd0TJganzWaoONtem+A7OEk4WG?=
 =?us-ascii?Q?N3goOmHFPtT/d1Lf/ZfRGXyHA2DDRmtgiv0xWzGJX/LLv0fY23Bj8iWfGB4C?=
 =?us-ascii?Q?EeBRylzF/QjVvuBqP2in9il4HTnBcO6PWrEoBEuQEo4k6O30jEPV8RUOOMzl?=
 =?us-ascii?Q?7awyuo0gFErshIHE1PteaVPYKodmWELHZ3TLBsOY6IJCZMnIQ0Xxv9oy/Dgp?=
 =?us-ascii?Q?fkX+W4mXQE4vIWhQe1Inn8jzL4LZdMkSeCCAd7EcmOKQFjhXXzSxkkyuGouk?=
 =?us-ascii?Q?Q2cq1nfGO6hXg0WIAocG9Xmhr9vq5kPHamJoGI+VXMJdQJcV+cjYqbZH16KY?=
 =?us-ascii?Q?GXIRvy1HtGijSYuJeOu5w1vtQ+8yz623qQJmeqMDVxFCxvJ2Six+mHeG+QRZ?=
 =?us-ascii?Q?ntwvRqRaaH5/gTDkCdb3ooTWAmGXbvpg3DWgvV5taIr0mPSmsJulHTDN9T0w?=
 =?us-ascii?Q?Wsue1twCiqeArD7GF5T0LoYCj0zf907zJx345tAGqG5VNM9Y0iKbfUkUL0Tm?=
 =?us-ascii?Q?A4n6eTgQwZleGmLifFhTAadaFHYIYTTlFumFStaxx23XD+Yrw3TdsjM/GQ9+?=
 =?us-ascii?Q?7zqHA5bJjImp2M715VNfw9pBswpdYDQixxJAWiCDMFRrJyDOeCH1aM2bWNo6?=
 =?us-ascii?Q?g7/7vRsKB3AD9Fui4con1Li/JrUefqsYo6RiazwmAJ6dQNieQohw5Xfb4AvN?=
 =?us-ascii?Q?e/v5Ndl9G3Vvfbaa6bjWMkuMmEIUkQ9x6Wwvr5tO/AmDjqcDbUn6qQrnlUyX?=
 =?us-ascii?Q?vAlULFxKD2HjwzXhbT25HBSyQ4Ae9r3E3Bw8A4S/spfCjBVXV9yj3v7uM0TS?=
 =?us-ascii?Q?EBWmu+m3QBwZSdCUPFgL3O/DDB6OflYGFV9vhlt4rTkBwUgqPcpm+DoE1FAJ?=
 =?us-ascii?Q?gXxLX3d53MIML8YF7EZuHnTSwkIstIi6vu7pdm6mbUrZEwI7UJD8wCCCgPV6?=
 =?us-ascii?Q?wERBqo4tvN0z1zvqV2Cui6jg3Bgo3bjC4fLU5EmqSFGAeIrqnHxDmnK83l4Q?=
 =?us-ascii?Q?UQwJCP4PteHjG7jW09gKjfi93yAYMKWxmg7fUxFHYStu1HJutKtc7vPED+a8?=
 =?us-ascii?Q?6wDt72CYsS7DllFNhaRR8R/kPNHXJB+pgG/sHOEYysLKUj8QSN+0pZbuTDxr?=
 =?us-ascii?Q?ShGrxxUfYsWsDTwBDF8uwV8CuXIBUiMRyLo54mkNVkUg4xuWLKuwhLyxqb2C?=
 =?us-ascii?Q?5UPQc3tbxs5aN/AX4ErmAuM48F+h2Cyfzd4qJLOoAs3u73/E/OSMfTzVdg7q?=
 =?us-ascii?Q?gDf38j7wMesbj7n8RrnazY2/TuGojpmjzDS78ST8fA5xz0dsQN9T3C7yxXxj?=
 =?us-ascii?Q?Q+0j3rQbqPcDvOn0y1qYNXXL3XzagS8eZsUBNBns?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:22:20.6209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e01b63-0562-42b3-19f5-08de16d50b50
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6820

"alg" in zynqmp_aead_drv_ctx is single field union variable.
Remove unnecessary alg union from structure.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 6e72d9229410..3ce1319d1a1a 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -43,9 +43,7 @@ enum zynqmp_aead_keysrc {
 };
 
 struct zynqmp_aead_drv_ctx {
-	union {
-		struct aead_engine_alg aead;
-	} alg;
+	struct aead_engine_alg aead;
 	struct device *dev;
 	struct crypto_engine *engine;
 };
@@ -289,7 +287,7 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 
 	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead.base);
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
 
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
@@ -302,7 +300,7 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 
 	rq_ctx->op = ZYNQMP_AES_DECRYPT;
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead.base);
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
 
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
@@ -315,16 +313,16 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 	struct zynqmp_aead_drv_ctx *drv_ctx;
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead.base);
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
 	tfm_ctx->dev = drv_ctx->dev;
 
-	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->alg.aead.base.base.cra_name,
+	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->aead.base.base.cra_name,
 						0,
 						CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(tfm_ctx->fbk_cipher)) {
 		pr_err("%s() Error: failed to allocate fallback for %s\n",
-		       __func__, drv_ctx->alg.aead.base.base.cra_name);
+		       __func__, drv_ctx->aead.base.base.cra_name);
 		return PTR_ERR(tfm_ctx->fbk_cipher);
 	}
 
@@ -349,7 +347,7 @@ static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
 }
 
 static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
-	.alg.aead.base = {
+	.aead.base = {
 		.setkey		= zynqmp_aes_aead_setkey,
 		.setauthsize	= zynqmp_aes_aead_setauthsize,
 		.encrypt	= zynqmp_aes_aead_encrypt,
@@ -372,7 +370,7 @@ static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
 		.cra_module		= THIS_MODULE,
 		}
 	},
-	.alg.aead.op = {
+	.aead.op = {
 		.do_one_request = zynqmp_handle_aes_req,
 	},
 };
@@ -407,7 +405,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 		goto err_engine;
 	}
 
-	err = crypto_engine_register_aead(&aes_drv_ctx.alg.aead);
+	err = crypto_engine_register_aead(&aes_drv_ctx.aead);
 	if (err < 0) {
 		dev_err(dev, "Failed to register AEAD alg.\n");
 		goto err_aead;
@@ -415,7 +413,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 	return 0;
 
 err_aead:
-	crypto_engine_unregister_aead(&aes_drv_ctx.alg.aead);
+	crypto_engine_unregister_aead(&aes_drv_ctx.aead);
 
 err_engine:
 	if (aes_drv_ctx.engine)
@@ -427,7 +425,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 static void zynqmp_aes_aead_remove(struct platform_device *pdev)
 {
 	crypto_engine_exit(aes_drv_ctx.engine);
-	crypto_engine_unregister_aead(&aes_drv_ctx.alg.aead);
+	crypto_engine_unregister_aead(&aes_drv_ctx.aead);
 }
 
 static const struct of_device_id zynqmp_aes_dt_ids[] = {
-- 
2.49.1

