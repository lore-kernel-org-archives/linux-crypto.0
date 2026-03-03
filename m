Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011023.outbound.protection.outlook.com [52.101.62.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC4F386456
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522451; cv=fail; b=biVtCiUBEA6eJ4WAGLLhZ/NbenBktWzlm3n7qJlKeVeAUwAZO1Tq/thw3hcgPP8lA1Hc0GJCv08DG/yziuudWbm7FBHVZl4Oo6m9ygr4O4gSmAt5QGSo6TqHO6S1hx8PgzdhP1Ik2uivGYMKoE6Qbsfj6RORliXVCQ5ShrTvBjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522451; c=relaxed/simple;
	bh=//uPcmwBkNFMMOBBZ/B22ty8urB8aL50QA2Ew/s9Yvs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DhNHV+e1yY0iIskI5aEMN+2fOMAG7zRstGzvElaUF83WJjnL6nV8DijFN55i+z4H2USy1BZsPlOAhmGv8ctiLzaasNuaweGRIRdslf+jhX/E7Fzuk/0tF8iKwtEBSgs5qE8hCTT5Hj+uR9MOX2kto6q24m1RaVzuV4IVkUVgWNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jhp3MtnH; arc=fail smtp.client-ip=52.101.62.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jhp3MtnH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cqmlz3IsFczHmNIPclKVJJsSbCMXvupjoT4xFwoRgHuJqLuZ5DKyVXV1mswN689finAenoINASdOKuYDFxdHqsiCGWDMvc2AG5w522tLPfHbq8+ghznqorNnol3PT0Au54fqP/gK+bRte6Kk6h9b0x329gkXR1XW8yFt+f2Wni+ASS1dLKjLziq0BDTGCNalsSwio4tNOSmiogKynkYCUBxgPTnA0W6xrQMP3+HsTmozMb7KIpReaIfqxPF9gGAvMFIWmYYRFmhUCWG1IvOpW63L+BEy0FijHNXPvkX+X2Q8lj+c57V1DeClSnzw/66NqwsAJdpueL7ArOMTbEHFYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5ZqO3Fo4lkTF/Aso1KKFfUKhYJrSWaQTt3+tm+Yxm4=;
 b=dlynfkkzhk1AqLV6q5e9qj+j3Myhh+VGN++0rxqJqUf8lh/Se+jtIcsP1GWDHS/o1GH1F6KfO22sjA9HQyJTsonlQs0PL+2u6GsfMbpWgxwCJ/K5S711WFSX5ZtGG4j6IknbYVQ3nKD2NuA3yPigFf2He+702CkbhHIJAliG1ptVIN4qAkMU6PtJOcmyjG0c45h4rd9OHbLXB2wqULEN5M0/1GFDc7TVCKVBGu6tDYCMNSF7NYsi6XifgvQzANm8bRSBd+xzM/3WOF60oBTrfGvutW+YA8PFTdOwjWoTuZHo1O21VidS1Xi6jdsJOpwGO9wxMcxIWy0XPbfafo68ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5ZqO3Fo4lkTF/Aso1KKFfUKhYJrSWaQTt3+tm+Yxm4=;
 b=jhp3MtnHBh4UcwrZJA2rk4qgPkrG37esot62JUdXiEZli+5sjlFIW7GjyR1UkDJhTPKSa8Gl7g4IiDf/4Nw7JkbYW9+VFHNBuY+YVmeu/KPmUOBVP6VrU4gUcAysPon2FIfv9DAHxbooTFaB4IzkNjLAyky/Wo/65VEVBBeE7VA=
Received: from BYAPR08CA0033.namprd08.prod.outlook.com (2603:10b6:a03:100::46)
 by SJ5PPF1C7838BF6.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Tue, 3 Mar
 2026 07:20:46 +0000
Received: from MWH0EPF000C6185.namprd02.prod.outlook.com
 (2603:10b6:a03:100:cafe::21) by BYAPR08CA0033.outlook.office365.com
 (2603:10b6:a03:100::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.20 via Frontend Transport; Tue,
 3 Mar 2026 07:20:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000C6185.mail.protection.outlook.com (10.167.249.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 07:20:45 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:44 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 3 Mar 2026 01:20:42 -0600
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 4/6] firmware: xilinx: Add firmware API's to support sha3-384 in Versal device
Date: Tue, 3 Mar 2026 12:49:51 +0530
Message-ID: <20260303071953.149252-5-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6185:EE_|SJ5PPF1C7838BF6:EE_
X-MS-Office365-Filtering-Correlation-Id: 29a7336b-235e-45b2-cc8f-08de78f5633d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|7142099003;
X-Microsoft-Antispam-Message-Info:
	7Fqa1gIwZ+E1ROcir8uIAiDlGnW4dIWPyrJ3CBmFKrdxolBS3fCdu+iG4QyU5b0RcFGohN7HYoA4nBJL+gr3fg3ILp8wtSYEAaHmk/SX70smTKa85kVdtqstqSvonJNvZiMEmVKI6KXCYkG839IerNvsm1y/5eDBz+ooQ21vd8jvhhA0xWiOioWKn+O3EAIyD5ljTUw2JCgZlBz8hKj59QTGM8IlKS1Uw8tYhnKqx8yiod3t6G+iCl4azzsMIE5EGTTNM26aUV/R3KFrh551Yfc6+irfQ7YcHGOhPgDTP0MVcpE8pEEL12nPjLOVFae6W22Y9zofKoy3L/834DN9EBiUxSTlUgbNvKNzM2hCHMlHWDlQAIkgr6SwSK9U2gt3v4SCIDFcmONo5e9Ksyyplsl3Gfni26eII3xDY+ClLlwrjykeKDxGXZ+VhACsfam7E2vgVO25a3Dfsn/+AVRhq5COXDrNrg6FFwEeixcq3wZb+NKws8gQ1GEFgbgaoXue2ijoTx6RnxE9PZa2Rg0AQawxjpC5L6cwp02u0oQcGpgdIbOQn6PpaIHFot6k0Sb4OFp9Cfey1U+0C9+aPDHXXGEh5q4Dy43xWfMurW6K8odJCtjunzBfTV+xQW74F9dNP75d6pjo1hN1jKr7KTkmiF0S37qpG1unnn/DAKZr7lIIazXv9CI20orY2jAIyB0gNJ4nfdh20py7Gjv2ONmoDXtvQLFmdm7STAaLhJ6sZ0LFAaN0wq2vD4xu+VHN2pxn41SY5lPMb1PG41gN6toI94idMI64DyVOufOh3Qve8NwhSBW8BzfuzGVB5VK1ywyYEE3rcedhjNpWJj3k0OZbtg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(7142099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	m+lvzUGxP0QVfiptpDoq8D/ioWCfRoPXSvjBErq4S39nG8wRciP+1+JDYO22N7Oig9b+xRU+mOoKfT3+BkPJIwKLg73t1XOq2DQYPo1y0ZTioxPtvEKgjx2J83siGoimdxRWuNLQTEo3iZ8sxgHdexpZG11ERS+HfAkfy1cFvVlBtZSUiJgoXzvLT1Hh5N2X+TcwyVi3J5VGE6ft5ReRVr00b8ggSYL5vyka72f+CM6iJ+W+VvJkxOPlAvyeIoJjgghr3FnsuuZg1NYf1VS7BO84iYY2i1N1YhwihPUoPpJzGdZImQ9lspjO+ZqaV81InA/u+f1Z6dUVYR9smakKtPYj8zC427IVo/pdE8HxY67SEX47RsNn0zpU4dC/nPPQK0tqv1G/zBn9L+rjTQKUxDWuRHNTD6b3QcnnoZ/4kkQVewO1hjZA5KbwV104V1ec
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:20:45.9161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29a7336b-235e-45b2-cc8f-08de78f5633d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6185.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1C7838BF6

From: Mounika Botcha <mounika.botcha@amd.com>

Add sha3-384 crypto API's for AMD/Xilinx Versal device.

Signed-off-by: Mounika Botcha <mounika.botcha@amd.com>
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/firmware/xilinx/zynqmp-crypto.c     | 24 +++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp-crypto.h |  8 +++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp-crypto.c b/drivers/firmware/xilinx/zynqmp-crypto.c
index f06f1e2f67b8..caa3ee8c6e2a 100644
--- a/drivers/firmware/xilinx/zynqmp-crypto.c
+++ b/drivers/firmware/xilinx/zynqmp-crypto.c
@@ -236,3 +236,27 @@ int versal_pm_aes_init(void)
 	return zynqmp_pm_invoke_fn(XSECURE_API_AES_INIT, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(versal_pm_aes_init);
+
+/**
+ * versal_pm_sha_hash - Access the SHA engine to calculate the hash
+ * @src:	Address of the data
+ * @dst:	Address of the output buffer
+ * @size:	Size of the data.
+ * @out_status:	Returned output value
+ *
+ * Return:	Returns status, either success or error code.
+ */
+int versal_pm_sha_hash(const u64 src, const u64 dst, const u32 size, u32 *out_status)
+{
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	if (!out_status)
+		return -EINVAL;
+	ret = zynqmp_pm_invoke_fn(XSECURE_API_SHA3_UPDATE, ret_payload, 5,
+				  lower_32_bits(src), upper_32_bits(src),
+				  size, lower_32_bits(dst), upper_32_bits(dst));
+	*out_status = ret_payload[0];
+	return ret;
+}
+EXPORT_SYMBOL_GPL(versal_pm_sha_hash);
diff --git a/include/linux/firmware/xlnx-zynqmp-crypto.h b/include/linux/firmware/xlnx-zynqmp-crypto.h
index 56595ab37c43..c93b77a2c084 100644
--- a/include/linux/firmware/xlnx-zynqmp-crypto.h
+++ b/include/linux/firmware/xlnx-zynqmp-crypto.h
@@ -33,6 +33,8 @@ struct xlnx_feature {
 #define XSECURE_API_AES_KEY_ZERO	0x510
 #define XSECURE_API_AES_WRITE_KEY	0x511
 
+#define XSECURE_API_SHA3_UPDATE		0x504
+
 #if IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
 int zynqmp_pm_aes_engine(const u64 address, u32 *out);
 int zynqmp_pm_sha_hash(const u64 address, const u32 size, const u32 flags);
@@ -47,6 +49,7 @@ int versal_pm_aes_dec_update(const u64 in_params, const u64 in_addr);
 int versal_pm_aes_dec_final(const u64 gcm_addr);
 int versal_pm_aes_enc_final(const u64 gcm_addr);
 int versal_pm_aes_init(void);
+int versal_pm_sha_hash(const u64 src, const u64 dst, const u32 size, u32 *out_status);
 
 #else
 static inline int zynqmp_pm_aes_engine(const u64 address, u32 *out)
@@ -114,6 +117,11 @@ static inline int versal_pm_aes_init(void)
 	return -ENODEV;
 }
 
+static inline int versal_pm_sha_hash(const u64 src, const u64 dst, const u32 size, u32 *out_status)
+{
+	return -ENODEV;
+}
+
 #endif
 
 #endif /* __FIRMWARE_XLNX_ZYNQMP_CRYPTO_H__ */
-- 
2.34.1

