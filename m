Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010029.outbound.protection.outlook.com [52.101.56.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718AB285C8B
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522469; cv=fail; b=nusIBl9WArQtH3PMQn68puFzQJ+b5D7Qokkej7jsRkEnkiGocwLIZGJITlGeYssJ1Vdp/M0TXz79wGYRWNhvKOq17t5zJqNy5R810iFGHKgXbQzK8DvOPF6Z0tyW9CZBz7Opbjdgz77PJLlOv6kumWmaxG53hIzccqm5ztctN0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522469; c=relaxed/simple;
	bh=FEKtOiu+RGhoD4OY79E5lbTIkTHiTq6lvhhRmrqGLL0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCuDX8MaeLKHvqWeZvTXpW0vgwxK2DZ112wcVok9X9k9leFlBJt3lFs4t8U6xRTvsMRp4Q62ytN2BhyfmYMP3s2RIxzOGRZb0Lk/xAh5YpHDvZQ+GwA8OZrWvZyvGRwdoJr0iKjnbazKdcGzkR27cn5LDZegPwcAXhjOd6JbPWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RgcjmMT7; arc=fail smtp.client-ip=52.101.56.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RgcjmMT7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YrkNUVu6lGr96PZih3WME/hK/WnFyAxxxSDxw+OCJfL+tM7u3mrYtj3vILB56rTpEcggfZLDIZh+fvDntNiLFvPeJM14JR8CTYyZ8cjQxmIrVk3mhBY7JFRvqxvLYR5HxOpxORBzUon8XJzKlk1CUljAfyuASkgBL7YPLMpX/uB+7vxONBCXJkijOsNhrDOwFE1+c7IgHVyRgDm73LhbkwruEssPbpEP9GlnYV+kBk1DJcYCB5mTwByw06+LZIBTcP3pXtI7Ao61PC7FkGHVf0Jqy6ih9AcaSsk9CRfhVwj/FRIBKyadN+Zj3MO7nu/tWnl8F2bUJxM7uXHpIk42mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yXAYG7jq7pNgpVprsS63nli59Su+juyYTsPg7lNc3gY=;
 b=KmAwTZLSUckYqvwHFHVveLezPXGNshV6BYzQo0JLwP23QQ2bgCN03lh40RfED1aBru+58iN3r7Z+CD0hbYjzWCzNgy3s58GAnnTdsc63yDNAlEME/iHPaBLPkwxOedBQYQnYL5Mxl9rcuvV+FQketFSWuZrQaCYeEUgpRui1wMebDOS/juvNLYwgmPHrGd/DApqQuhK4JmqAj49+04whDBasiMTrk63mA056t9KOF6Hs/3bNpLzrVDb7cvwAzbeE6CrU5KSni1iIiLfvpyAnx1iIiF6ophoipYmzZjERRQyF0tNt5YvTvegjFaGffZ92I9VHyMiyZtSTIp2jv9Vprg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXAYG7jq7pNgpVprsS63nli59Su+juyYTsPg7lNc3gY=;
 b=RgcjmMT7VaMeuE3nzpDaMHvp5C5STJESgew9Z7zxRWi6VZOo0buPw1CPynSuOmD/LOx3ZUoIhIawgoF4UVviDG4+w2Lh2L8RD1OPBwYbNNLY+D7Njga9R3vjIcNTlcMB5QS6O7KQgDFKyXtUKhzeCXDOraegqb+6J4CyzghDyBU=
Received: from BLAPR03CA0121.namprd03.prod.outlook.com (2603:10b6:208:32e::6)
 by DS0PR12MB8480.namprd12.prod.outlook.com (2603:10b6:8:159::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 07:21:03 +0000
Received: from BN3PEPF0000B371.namprd21.prod.outlook.com
 (2603:10b6:208:32e:cafe::67) by BLAPR03CA0121.outlook.office365.com
 (2603:10b6:208:32e::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Tue,
 3 Mar 2026 07:20:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B371.mail.protection.outlook.com (10.167.243.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.0 via Frontend Transport; Tue, 3 Mar 2026 07:21:02 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:48 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 3 Mar 2026 01:20:47 -0600
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 6/6] crypto: zynqmp-sha: Add sha3-384 support for AMD/Xilinx Versal device
Date: Tue, 3 Mar 2026 12:49:53 +0530
Message-ID: <20260303071953.149252-7-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260303071953.149252-1-h.jain@amd.com>
References: <20260303071953.149252-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B371:EE_|DS0PR12MB8480:EE_
X-MS-Office365-Filtering-Correlation-Id: 32756490-d4c4-4920-8a4a-08de78f56cca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013|7142099003;
X-Microsoft-Antispam-Message-Info:
	YM8Jmfb4JGZHydMX1bsWYGbrZijUSGpyeP7p6ljKZf4b2YDVaTXT5vkLOy205t9lqcYE7gkxL1wFvo6OqT4kzxIO1tqtuKtwBsPQKM6L9sIsp30nC/dmsOq9hQgfQkUx9I+zBloCZ9CZ/+v//dm0ugTR/mHF17y6VUtLrrlvoZ6inIEHlXbpiTzxSaf+L8BOq9BRN+tgM1igwBW7FeICADqTX4WulhEIK2PX899pjt1pDbn03PuSF9xtCiFji+zgJhm5gHIocD9Y40t39jeNEH9poZHFHC3Pn1vD3TFCezgrzFV1usvtbW+FptZbdg4iyIcA7MKSYKxijmfPrfMhiqg8Ynz/MYDdXP2NKt/gJU1oHkKwwvXaEd9h/8UlJiK7Sov1rB7Tx+XamGQShVkcwcPy+6Q9MzNLa4T2sPsJYMOSnOT/CewE33sk1M0cOXOdqvezohpbqVwRwE8dgkiEfzXdWgXPNGncI/u8P0tmSxYNAEhFYJdkYf2DTNvesKClXZNS3wy0VR2k+uqcXiU2XfDL7c5g9WaIdCqTGCcF7mZaxd20G0UrQsOy82vuN7zadLthKft0OoiILi4qoC7UwybKfshXAKPJPhexEUgPiMNFhPQxCczqkZVZFfdKO/wVIj5Tg2NUAAtvhJjLD68OYWMbjyZOWFautwAZs5fuYU2zUQ/zsCpl/R/eGMGEDSFRF4tBMg7QFficCSVUoR8TqdF37//BcDBryLkOpGYtAUiycZUoWGlMN7YcSNr3ysTN8QBnkU1f7c8EviAHI++drcAzbdRejyNTu4oumspXhCLepn4xFLPPCH+Kf7mcnwFu3muxG13kZWr7HiP5oBmM4g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LOgfEA4svzdmxW0lzbfc5N5pIipLv202QIWRuXkbS+xTkTF8XvX88a73D++OkG6jWBz8h9qDa3qUOIpMQxcEz/7G6MX4MNZ56mOEqVSYOEW2/r0vzxX8GPgtPVuZx8qVTcZI2jmtNsi11aOxMXA8zOOmS7U51RR2MajUws2bRbYjkhQ6VDBeimzVIt/6RaZ4ClZ1yEdrMefzwO/msQK4Z7WBcl0aadEBZZw4iO3XrS3QSZ1ZAyV+d0YOG2jrNYhR48xKDYzlCpZ8gAvl/AdZj1cPt8EJVLLbVNmOMtuprMD52dCRev7LdRcbIjpgRCgC9HGweu4ppQJqos5ZjiHJQw1ONDc9Y2++AhugMbC/WsN4AQ60jUia3xeAh4y6D3Ln81bpbQ+HVhdPR+jyGHwv25glfURDEzAkSAZbzy0WtjmKPQd4QJPIeMseR9bD4Zwz
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:21:02.0338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32756490-d4c4-4920-8a4a-08de78f56cca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B371.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8480

Adds SHA3 driver support for the Xilinx Versal SoC.
Versal SoC SHA3 engine does not support context export, Accordingly cannot
handle parallel request. For unsupported cases it is using fallback.
For digest, the calculation of SHA3 hash is done by the hardened
SHA3 accelerator in Versal.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-sha.c | 119 ++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 72b405758200..b418c917ab02 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -18,8 +18,17 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
+#define CONTINUE_PACKET		BIT(31)
+#define FIRST_PACKET		BIT(30)
+#define FINAL_PACKET		0
+#define RESET			0
 #define ZYNQMP_DMA_BIT_MASK		32U
+#define VERSAL_DMA_BIT_MASK		64U
 #define ZYNQMP_DMA_ALLOC_FIXED_SIZE	0x1000U
+#define VERSAL_SHA3_INVALID_PARAM		0x08U
+#define VERSAL_SHA3_STATE_MISMATCH_ERROR	0x0AU
+#define VERSAL_SHA3_FINISH_ERROR		0x07U
+#define VERSAL_SHA3_PMC_DMA_UPDATE_ERROR	0x04U
 
 enum zynqmp_sha_op {
 	ZYNQMP_SHA3_INIT = 1,
@@ -209,6 +218,67 @@ static int zynqmp_sha_digest(struct ahash_request *req)
 	return ret;
 }
 
+static int versal_sha_fw_error_decode(int status)
+{
+	switch (status) {
+	case VERSAL_SHA3_INVALID_PARAM:
+		pr_err("ERROR: On invalid parameter\n");
+		return -EINVAL;
+	case VERSAL_SHA3_STATE_MISMATCH_ERROR:
+		pr_err("ERROR: SHA3 state mismatch error\n");
+		return -EINVAL;
+	case VERSAL_SHA3_FINISH_ERROR:
+		pr_err("ERROR: SHA3 finish error\n");
+		return -EIO;
+	case VERSAL_SHA3_PMC_DMA_UPDATE_ERROR:
+		pr_err("ERROR: SHA3 PMC DMA update error\n");
+		return -EIO;
+	default:
+		pr_err("ERROR: Unknown SHA3 FW error code: %u\n", status);
+		return -EIO;
+	}
+}
+
+static int versal_sha_digest(struct ahash_request *req)
+{
+	int update_size, ret, flag = FIRST_PACKET;
+	unsigned int processed = 0;
+	unsigned int remaining_len;
+	unsigned int fw_status = 0;
+
+	remaining_len = req->nbytes;
+	while (remaining_len) {
+		if (remaining_len >= ZYNQMP_DMA_ALLOC_FIXED_SIZE)
+			update_size = ZYNQMP_DMA_ALLOC_FIXED_SIZE;
+		else
+			update_size = remaining_len;
+
+		sg_pcopy_to_buffer(req->src, sg_nents(req->src), ubuf, update_size, processed);
+		flush_icache_range((unsigned long)ubuf,
+				   (unsigned long)ubuf + update_size);
+
+		flag |= CONTINUE_PACKET;
+		ret = versal_pm_sha_hash(update_dma_addr, 0,
+					 update_size | flag, &fw_status);
+		if (ret)
+			return versal_sha_fw_error_decode(fw_status);
+
+		remaining_len -= update_size;
+		processed += update_size;
+		flag = RESET;
+	}
+
+	flag |= FINAL_PACKET;
+	ret = versal_pm_sha_hash(0, final_dma_addr, flag, &fw_status);
+	if (ret)
+		return versal_sha_fw_error_decode(fw_status);
+
+	memcpy(req->result, fbuf, SHA3_384_DIGEST_SIZE);
+	memzero_explicit(fbuf, SHA3_384_DIGEST_SIZE);
+
+	return 0;
+}
+
 static int handle_zynqmp_sha_engine_req(struct crypto_engine *engine, void *req)
 {
 	int err;
@@ -221,6 +291,18 @@ static int handle_zynqmp_sha_engine_req(struct crypto_engine *engine, void *req)
 	return 0;
 }
 
+static int handle_versal_sha_engine_req(struct crypto_engine *engine, void *req)
+{
+	int err;
+
+	err = versal_sha_digest(req);
+	local_bh_disable();
+	crypto_finalize_hash_request(engine, req, err);
+	local_bh_enable();
+
+	return 0;
+}
+
 static struct xilinx_sha_drv_ctx zynqmp_sha3_drv_ctx = {
 	.sha3_384.base = {
 		.init = zynqmp_sha_init,
@@ -252,7 +334,36 @@ static struct xilinx_sha_drv_ctx zynqmp_sha3_drv_ctx = {
 	.dma_addr_size = ZYNQMP_DMA_BIT_MASK,
 };
 
-
+static struct xilinx_sha_drv_ctx versal_sha3_drv_ctx = {
+	.sha3_384.base = {
+		.init = zynqmp_sha_init,
+		.update = zynqmp_sha_update,
+		.final = zynqmp_sha_final,
+		.finup = zynqmp_sha_finup,
+		.digest = sha_digest,
+		.export = zynqmp_sha_export,
+		.import = zynqmp_sha_import,
+		.halg = {
+			.base.cra_init = zynqmp_sha_init_tfm,
+			.base.cra_exit = zynqmp_sha_exit_tfm,
+			.base.cra_name = "sha3-384",
+			.base.cra_driver_name = "versal-sha3-384",
+			.base.cra_priority = 300,
+			.base.cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
+				CRYPTO_ALG_ALLOCATES_MEMORY |
+				CRYPTO_ALG_NEED_FALLBACK,
+			.base.cra_blocksize = SHA3_384_BLOCK_SIZE,
+			.base.cra_ctxsize = sizeof(struct xilinx_sha_tfm_ctx),
+			.base.cra_module = THIS_MODULE,
+			.statesize = sizeof(struct sha3_state),
+			.digestsize = SHA3_384_DIGEST_SIZE,
+		}
+	},
+	.sha3_384.op = {
+		.do_one_request = handle_versal_sha_engine_req,
+	},
+	.dma_addr_size = VERSAL_DMA_BIT_MASK,
+};
 
 static struct xlnx_feature sha_feature_map[] = {
 	{
@@ -260,6 +371,12 @@ static struct xlnx_feature sha_feature_map[] = {
 		.feature_id = PM_SECURE_SHA,
 		.data = &zynqmp_sha3_drv_ctx,
 	},
+	{
+		.family = PM_VERSAL_FAMILY_CODE,
+		.feature_id = XSECURE_API_SHA3_UPDATE,
+		.data = &versal_sha3_drv_ctx,
+	},
+	{ /* sentinel */ }
 };
 
 static int zynqmp_sha_probe(struct platform_device *pdev)
-- 
2.34.1

