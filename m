Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012014.outbound.protection.outlook.com [52.101.43.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90556396560
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335804; cv=fail; b=gVoLugYPv8ycZAusdSs63D+Be1DhHAArNJcejotoCBOLl8xA5sGJ7uN+S76Yb/tBF3OENyHBceba4DbwB/ZKrXS9wmI8S7Kov97IjoUl+RNBIClXaiexGdUY9OeQzNWoZV066Ox57zrLCZBGx0FUg3p/IAuymATY+Uc5AJPC4b0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335804; c=relaxed/simple;
	bh=BJGvLt5UDDpGEpwz6fZ/nkxZnZoKrncTj7LpAACIWnU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bn/6Ya/2jvJ8xB3MYkJIZ8veQYsah8Id6nyZB6BSCIIlgqFVI6YVMNFs+lpbOTnr33baOxr8AA7BcaXiZ5HXIqHrL+bg5HlBN2PKaN/RSOa51WKQ3WtVW+KPMaYupJozrlzDN9Cmu2bwYiTH4zgL/3s2dFmXao1fMqGLLnyGVSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P+xSoUsy; arc=fail smtp.client-ip=52.101.43.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P+xSoUsy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9sNaJ7l+8fRw1tzKMW/zlWBkxXdPdRxiGNBjVKQjXd0+4pRu0X7tti1MN6rQN+93Z9jF0xEIypxDu/rzOu83S34zpXoD1pBMz6/7cmWwh9DMzpddvZ61bSEuymE44Z2RHICTTa/8NYUcUYPcQKdbNuyA2h5lQRAlWMDAapMIeIHjq09TFfwi1t9VDh8de9lXknHDPcmi2xVNtA4icnDWp5if2fPYvlaOZgCIxQUpbTigGEnj+HH+xnlwnPsysePqFhLXxX4gCEYQmNGUQ6/Kt3Lif6yEDoL80ebzavGm+MzDtlVI/AgDTn8wBkQAbBrFW1XVEFBbVg6/f/ggFVjQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nmdv5ItHrXkboD8cAUBO4q6DnTkgpA8dGgC5yBJeh8o=;
 b=oz5e3XSErHPNhUi6fS5mxLhIF6Ayg2lv1nbkEKF/Y6KVmQecGM1E04dkWBU7Racid1Qg1EqVVYsIFD1xr609d74kd8TzNOlqYRhM4BNxeC/i++dd6AqqjStu8zHtmezkhkK3FEQfzgOeffrvCutzkTZ5liFxXfKgK8N+17H0IS8Z3YP30/MRtnt1YlzQMaSxEBuvzQQXeHDBNR+KKONwupKKtUuC5DfAGtazmc7jirYqxuMFoMNAL6zuswNLQ37EaM7UMsxbGzi/z+UVRtmKDwQv/Yhn5arBuhZNuW4X6noePBDwz9eS7An76qamU4odQHjGYbUIw6OhQ5UnPnpAvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nmdv5ItHrXkboD8cAUBO4q6DnTkgpA8dGgC5yBJeh8o=;
 b=P+xSoUsyxiTbhxNZ1lnTn2Vt2/XdLoVHTWrlWwalhmMPvKWNb69yDWRhELjMe/rFTSawoSi0BMMqrydT/xziVCibZpEuRDnQQygebPRlLsmZae+OEtghLVCOXCCEok2qB1lliRRqTLaLMVOpr5u+PIHF/eOQAiSmOhTGQRBif/U=
Received: from CH2PR08CA0007.namprd08.prod.outlook.com (2603:10b6:610:5a::17)
 by SJ1PR12MB6124.namprd12.prod.outlook.com (2603:10b6:a03:459::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Mon, 6 Jul 2026
 11:03:19 +0000
Received: from CH3PEPF00000011.namprd21.prod.outlook.com
 (2603:10b6:610:5a:cafe::65) by CH2PR08CA0007.outlook.office365.com
 (2603:10b6:610:5a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Mon, 6
 Jul 2026 11:03:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF00000011.mail.protection.outlook.com (10.167.244.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.0 via Frontend Transport; Mon, 6 Jul 2026 11:03:18 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 6 Jul
 2026 06:03:18 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 6 Jul
 2026 06:03:17 -0500
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Mon, 6 Jul 2026 06:03:15 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 2/3] firmware: xilinx: Update AES PM-APIs to capture PLM error codes
Date: Mon, 6 Jul 2026 16:32:53 +0530
Message-ID: <20260706110254.2427551-3-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260706110254.2427551-1-h.jain@amd.com>
References: <20260706110254.2427551-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000011:EE_|SJ1PR12MB6124:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dc48ce8-96e4-4eb8-8c63-08dedb4e2f70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|6133799003|5023799004|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	b7WhY44Vg+n7+x0bR6q8xazjcNVarNG98zdM5IY5uyXrJRq0VIafU+OueTOZqFWX2w9ho+U2KJXnDvJCswCYqTaV0Bq2hYfd/tSLNOx8MGRbZ8ZJ74qOwrQgFI1zSKJpY4eANtyrrujXiRBvDCuDDrf57piIaG1cx4Wz99hRvXY9i2E5iEBOaXdfG3zHMhjw5sk0fsoG+JktX8Auhdm6e6RYwoiRtgqXbvvzEfxPJwn9wTZ8uzdpi4Xpl9dPyJs8gJ6X0OcHChm+mn7DQ0Yw/D+K5s8QNYPj/BwGmNr1V4wC/qHPft93i8JWNqi8A9oU1qNg17m/Nmf6dI+THM6u/2328xA6t2ERQbaCq0kYatg4LFP/0nsU8UQ5/jg12xFF6e1MEZIyoCrUXivIs64su6fzmbNTeoqWLsfBq9qNOvmk5mZAc0ZjqdLwggXQ3Fr0/2IgTEzC9yGpG4S0a/fD0U7sjzBAnECAwXpCKGimkWwVoNfkV4930q3PmGdYmLhmM2aQts/9EG4BrCi0/Hat/2H8r6zm6wXJSI+m/Gfe4FLaX9F+TtiWjY9U6qOVgS2gTyoTaxrpzH7O5l6bf4s6JyblVdHWYbwNnss4WGbEDEwQFbVDbYiJLn5QGZ50OEnO59Ubd8pFlJGEcSkvPtrZFjuRuRwl1uLvEuaIJs2hJVGH5eLttYejUW0UHAUHAD6L7ZYthGL9STRFsaIqwpA+FA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(6133799003)(5023799004)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PM75LLNsMENVU4dY8pcv2Atnx/mzrcBIoS+9BgvZbeGLnobOYDWNmA48gUg93muvQFf50Ges9JRdXAcmFO+f5+rcA8l7PlDeoux13BghiACvkmJh4OtIiQgh5MHX5dewSnj+JlGvc3Sspu17VCEclUeOX7us6owZmKxlkueMY+UgBE0cP6B5RRUT0vZMZeuCDlTTsSLETuTSfB+hb0cN8crkkelhu6mardZ01ZHUmwTLqzoLs6IOaygLUbt2XK/3/dYinoXWdBVaj1Q+hVt522oVtV+WoL9RNIQQhAFbMPm6JvFSuHhCbjnB68gXZVkEr3D2fzTxQ+6P3HrMB46DW/G+4MF08ItRSiy8UGJ1C67IW5ce34JIM4yYOZQLnFv3fgxCxLJK2JV495o8G2Y1IZ2NQdyjWz3HO9U11NjmhVpGGrZyK4aBpdJBZ55KytWl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 11:03:18.2734
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc48ce8-96e4-4eb8-8c63-08dedb4e2f70
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000011.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6124

GCM engine in PLM has algorithm specific error code which currently not
handled in firmware code.
Update AES PM-API functions to convert engine error to Linux
error codes.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/firmware/xilinx/zynqmp-crypto.c | 111 +++++++++++++++++++-----
 1 file changed, 87 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/xilinx/zynqmp-crypto.c b/drivers/firmware/xilinx/zynqmp-crypto.c
index 9ffa14d83377..5aba5a2fee7a 100644
--- a/drivers/firmware/xilinx/zynqmp-crypto.c
+++ b/drivers/firmware/xilinx/zynqmp-crypto.c
@@ -9,6 +9,39 @@
 #include <linux/firmware/xlnx-zynqmp.h>
 #include <linux/module.h>
 
+#define VERSAL_AES_GCM_TAG_MISMATCH		0x40
+#define VERSAL_AES_INVALID_PARAM		0x51
+#define VERSAL_AES_ZERO_PUF_KEY_NOT_ALLOWED	0x5b
+#define VERSAL_AES_UNALIGNED_SIZE_ERROR		0x5c
+
+static int versal_aes_status_to_errno(u32 status)
+{
+	switch (status) {
+	case VERSAL_AES_INVALID_PARAM:
+		pr_err("Xilinx AES: invalid parameter\n");
+		return -EINVAL;
+	case VERSAL_AES_GCM_TAG_MISMATCH:
+		return -EBADMSG;
+	case VERSAL_AES_UNALIGNED_SIZE_ERROR:
+		pr_err("Xilinx AES: unaligned size error\n");
+		return -EINVAL;
+	case VERSAL_AES_ZERO_PUF_KEY_NOT_ALLOWED:
+		pr_err("Xilinx AES: zero PUF key not allowed\n");
+		return -EINVAL;
+	default:
+		pr_err("Xilinx AES: unknown firmware error code: %u\n", status);
+		return -EINVAL;
+	}
+}
+
+static int versal_aes_ret_status(int ret, u32 fw_status)
+{
+	if (ret && fw_status)
+		return versal_aes_status_to_errno(fw_status);
+
+	return ret;
+}
+
 /**
  * zynqmp_pm_aes_engine - Access AES hardware to encrypt/decrypt the data using
  * AES-GCM core.
@@ -136,9 +169,14 @@ EXPORT_SYMBOL_GPL(versal_pm_aes_key_zero);
  */
 int versal_pm_aes_op_init(const u64 hw_req)
 {
-	return zynqmp_pm_invoke_fn(XSECURE_API_AES_OP_INIT, NULL, 2,
-				   lower_32_bits(hw_req),
-				   upper_32_bits(hw_req));
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	ret = zynqmp_pm_invoke_fn(XSECURE_API_AES_OP_INIT, ret_payload, 2,
+				  lower_32_bits(hw_req),
+				  upper_32_bits(hw_req));
+
+	return versal_aes_ret_status(ret, ret_payload[0]);
 }
 EXPORT_SYMBOL_GPL(versal_pm_aes_op_init);
 
@@ -149,14 +187,19 @@ EXPORT_SYMBOL_GPL(versal_pm_aes_op_init);
  *
  * This function provides support to update AAD data.
  *
- * Return: Returns status, either success or error+reason
+ * Return: Returns status, either success or error code.
  */
 int versal_pm_aes_update_aad(const u64 aad_addr, const u32 aad_len)
 {
-	return zynqmp_pm_invoke_fn(XSECURE_API_AES_UPDATE_AAD, NULL, 3,
-				   lower_32_bits(aad_addr),
-				   upper_32_bits(aad_addr),
-				   aad_len);
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	ret = zynqmp_pm_invoke_fn(XSECURE_API_AES_UPDATE_AAD, ret_payload, 3,
+				  lower_32_bits(aad_addr),
+				  upper_32_bits(aad_addr),
+				  aad_len);
+
+	return versal_aes_ret_status(ret, ret_payload[0]);
 }
 EXPORT_SYMBOL_GPL(versal_pm_aes_update_aad);
 
@@ -170,11 +213,16 @@ EXPORT_SYMBOL_GPL(versal_pm_aes_update_aad);
  */
 int versal_pm_aes_enc_update(const u64 in_params, const u64 in_addr)
 {
-	return zynqmp_pm_invoke_fn(XSECURE_API_AES_ENCRYPT_UPDATE, NULL, 4,
-				   lower_32_bits(in_params),
-				   upper_32_bits(in_params),
-				   lower_32_bits(in_addr),
-				   upper_32_bits(in_addr));
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	ret = zynqmp_pm_invoke_fn(XSECURE_API_AES_ENCRYPT_UPDATE, ret_payload, 4,
+				  lower_32_bits(in_params),
+				  upper_32_bits(in_params),
+				  lower_32_bits(in_addr),
+				  upper_32_bits(in_addr));
+
+	return versal_aes_ret_status(ret, ret_payload[0]);
 }
 EXPORT_SYMBOL_GPL(versal_pm_aes_enc_update);
 
@@ -186,9 +234,14 @@ EXPORT_SYMBOL_GPL(versal_pm_aes_enc_update);
  */
 int versal_pm_aes_enc_final(const u64 gcm_addr)
 {
-	return zynqmp_pm_invoke_fn(XSECURE_API_AES_ENCRYPT_FINAL, NULL, 2,
-				   lower_32_bits(gcm_addr),
-				   upper_32_bits(gcm_addr));
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	ret = zynqmp_pm_invoke_fn(XSECURE_API_AES_ENCRYPT_FINAL, ret_payload, 2,
+				  lower_32_bits(gcm_addr),
+				  upper_32_bits(gcm_addr));
+
+	return versal_aes_ret_status(ret, ret_payload[0]);
 }
 EXPORT_SYMBOL_GPL(versal_pm_aes_enc_final);
 
@@ -202,11 +255,16 @@ EXPORT_SYMBOL_GPL(versal_pm_aes_enc_final);
  */
 int versal_pm_aes_dec_update(const u64 in_params, const u64 in_addr)
 {
-	return zynqmp_pm_invoke_fn(XSECURE_API_AES_DECRYPT_UPDATE, NULL, 4,
-				   lower_32_bits(in_params),
-				   upper_32_bits(in_params),
-				   lower_32_bits(in_addr),
-				   upper_32_bits(in_addr));
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	ret = zynqmp_pm_invoke_fn(XSECURE_API_AES_DECRYPT_UPDATE, ret_payload, 4,
+				  lower_32_bits(in_params),
+				  upper_32_bits(in_params),
+				  lower_32_bits(in_addr),
+				  upper_32_bits(in_addr));
+
+	return versal_aes_ret_status(ret, ret_payload[0]);
 }
 EXPORT_SYMBOL_GPL(versal_pm_aes_dec_update);
 
@@ -218,9 +276,14 @@ EXPORT_SYMBOL_GPL(versal_pm_aes_dec_update);
  */
 int versal_pm_aes_dec_final(const u64 gcm_addr)
 {
-	return zynqmp_pm_invoke_fn(XSECURE_API_AES_DECRYPT_FINAL, NULL, 2,
-				   lower_32_bits(gcm_addr),
-				   upper_32_bits(gcm_addr));
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	ret = zynqmp_pm_invoke_fn(XSECURE_API_AES_DECRYPT_FINAL, ret_payload, 2,
+				  lower_32_bits(gcm_addr),
+				  upper_32_bits(gcm_addr));
+
+	return versal_aes_ret_status(ret, ret_payload[0]);
 }
 EXPORT_SYMBOL_GPL(versal_pm_aes_dec_final);
 
-- 
2.34.1

