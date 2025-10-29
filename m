Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010031.outbound.protection.outlook.com [52.101.193.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05A92FF67D;
	Wed, 29 Oct 2025 10:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733382; cv=fail; b=eoPSI3+UcBApS5MAqcy3XKbiBlm/LKW4HzdtKmHcEvgGQG2DLbhtA5Fo038npwVMhMvwrgA2yVpkTgZY4T4/bjg7qmuAJNoHc4+/OabbkvPEZbRcDfcbYI1GyqCT/eTdryXGtVFkE+LcV718S6Fm247AQGOtLgs1Dm/HmnBRFy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733382; c=relaxed/simple;
	bh=VJTkF9Cp/Y0KePsNCOhcC6bNXhjzqYdH4+fGJZ/ftnc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m2frI6WX7H4FZPhfINLiksfHIqZZYHCuoyriaSXs/1znsyvxp4BMUz/JKgJx2dBH2qj29QTSmU4SPlrT6wtbfgtuj+tey+2Q1yluRf4/6zAclo/0KJ1lIkbq5ovFH4zyG3elZWwU1tfiQ6YLhkP4UmOu2RfYTqA/cCK30yig+aQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wRrzCAgH; arc=fail smtp.client-ip=52.101.193.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wRrzCAgH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZqSt0feNOkOCwOa4M13o0RDSnfSm+KhmxQOlwNZdlCrxcMpTEQ38YbHdrYLeG2MUO82GZgxrP3RIk2EGjGh6QjxFqriiLWiCoc4r/gtteMgkxmNB/NCHKiqfX9Tp+8D58rlr0qAXhl5p/8caNl5pPwNxPUGOAK2aAO2QtQxnNi+8jN6XibRl0boPXwhi35Hp6oSS31uqm3eDtnFituU3DN1kPSNli4nUx+UgngLnbXJOyZzcFYLc0f32LcZCW06xOveZsvpgH4r6zHxK3CSaCzPpIMf3bwxoqHyV9Cc1BEkUphJZzTwprSgqD4Df8A5t3A1gbkag3p225/YGB6nzcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSGMAmRKX+TVoKxri6llQq8l7QLjdPa6WW2JOzwouCY=;
 b=FlCg/0U2VPIF9q/8PKwzlFvQ/+A003OSbMjfreWOFLSW73JjJwHlubumUQBjpHVXJAIGihKkV3pJeL4rq6ElmbUbuxddJlJuPrTCPZriz/CZpzqWx0g34jLrIyvXvk4Ef9NH9UlX7ZV0V4sUlogAwBDI+YBW1pl54qRv/769YBfDj4JvcDCPev4wAIT3fA1cnfG2gyIoYdjUbc04Rgd05bNxI116BwcPYZ1mtRr0Yy0hGccKqF9Nr1GlF2zO7l5CWXmfIVAsmJt++R8F8AMbOSMJ3zoaqtMdR+b1kDhyckiMHA2lA1r9POq0fHMELLXbvwuC+K6z5k8EKnFYKzA/TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSGMAmRKX+TVoKxri6llQq8l7QLjdPa6WW2JOzwouCY=;
 b=wRrzCAgHnVKWiYzMAVqea1gYBYaiciLtFfCyGzcrqnVP7fKQQE/3x3pHsyGp06oLY2ISBEaKa5wXRVg+o6/wXh5qkXILEpZFgXpjRVoo822VUj6/5ic8SMIJxIZWEKJhJ+bnT2hUF/782QWHrAqfJGWRyhoyO1/Bkfzp+NjXX4M=
Received: from BL1PR13CA0086.namprd13.prod.outlook.com (2603:10b6:208:2b8::31)
 by SJ2PR12MB8978.namprd12.prod.outlook.com (2603:10b6:a03:545::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 10:22:57 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:2b8:cafe::92) by BL1PR13CA0086.outlook.office365.com
 (2603:10b6:208:2b8::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.13 via Frontend Transport; Wed,
 29 Oct 2025 10:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:22:55 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:23 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:23 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:22:20 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 03/15] firmware: zynqmp: Add helper API to self discovery the device
Date: Wed, 29 Oct 2025 15:51:46 +0530
Message-ID: <20251029102158.3190743-4-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|SJ2PR12MB8978:EE_
X-MS-Office365-Filtering-Correlation-Id: fff06f28-1c5f-438d-17e5-08de16d52010
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x1t+JDC+rGZF20ZdjC6lQ5mcId39d2q2qiKVOA6VM9cKp+ZE6KrJblW5cbkY?=
 =?us-ascii?Q?n29VGS8pf+twQ+1Z5HSsE/fXfIjEFpEQv3h4fNfEo65XtalurxupPbAGE8Z/?=
 =?us-ascii?Q?kvoT4Qs++J4kIZz/rzLk3w2J4RBLJh+JKlNIzoxcxaDwZhe0gm+Gi6fynwiy?=
 =?us-ascii?Q?HFLn/5Wfbu5bfz11LhXxeR7pPLhLKaYag+2PYCWDQV8c/5cranad9emvmt9p?=
 =?us-ascii?Q?jm1ocjA966zFdfD9rdPqwUnNbfYVDeIW5PgdZYugO4xpluhW7fMDXyoruecw?=
 =?us-ascii?Q?4Qg9hhrL1Yn/JExOHHiRCKL7u0swVyh5ZnCJCVkL1+KSJ4/c+lRIOCnAFJaQ?=
 =?us-ascii?Q?cx8tN7CUXt5FqjNx97+gQ7j0QN8KiOP8lyKjQwB4Ejb6DpI7owk0qXCtHcNt?=
 =?us-ascii?Q?1L3zZMaP8tRhCT07yasoVcgNdJPbWtig/I9cgR1SEBltvnvVQAtc8E0IBtuP?=
 =?us-ascii?Q?/F4GUpvaV991TZXjODgotDVITKev+nadUehwH5r1sRY5lQAvSOkXzPgbVXng?=
 =?us-ascii?Q?oaH71PccYekvWqdVH6YXC0QOIONHoOXF3YRRJKtHjlHaIOef9V/v74SV0S9B?=
 =?us-ascii?Q?ueOnY5D+iKKg/wYry7GzzUMeIBOlFMzm1yx0FPxrev3jIvxtoqDIbk+YQiv+?=
 =?us-ascii?Q?17dJMUR8wU7QjiKpm1WvjmraWkOvM8t7ihfo22vj8OrGOdF4hCKlg91jsBxF?=
 =?us-ascii?Q?5vWzY3A2vnnnfQ8UVclfSK4K0M1qxrXR+4TFLtqDeT9x1H4/E6aO4Ak4tp5c?=
 =?us-ascii?Q?N8eaaUpPZvU64D9f2knDVlB0szLfOptrdblprIg0926WdupYcMd4JomdKq+9?=
 =?us-ascii?Q?fml2ax+Bpq088ePg1YmLEA7SZmLfr68DRWTr2OWqBpQANWryCo7fifc4gOC0?=
 =?us-ascii?Q?imSSsYb7D8tvC2irM8cFViwG3uDEA4fT/ANiZxIrvkTcW9sOezTQmW0i+b70?=
 =?us-ascii?Q?iF+r+jNUYBBm1s7ENBqpQXr94xpWKutiaKx4nerdq4VoWbBsDYV1cOYahXun?=
 =?us-ascii?Q?QJMAR+KMpGCEhlIPUv2n7i+OLOd/MYln9vtEMzzJrguVRYJ9k9jLigUJC9JT?=
 =?us-ascii?Q?o7FLROCwTtmDG3fR6U1m9R2ny5xIjCYAgY1e6b61UXia2eenl/2eNe1xjFAt?=
 =?us-ascii?Q?0oymBN97ZXp5uOA20ZuJlefhvIhB5U+7a5p53HRsH2/1ziAMXgxfXI6JkoxR?=
 =?us-ascii?Q?7/Ngu94MdHXJxbvv1rOCDjlrTYBTTGIg3aXR51dLi/RaEqEtS2D2s0vF5DT4?=
 =?us-ascii?Q?ZSuZJ0sMcmO5lZkLkk9N9Cht0rtg83k8iQ6JKxY2rhKLMMmm0SVEQCQsZsa7?=
 =?us-ascii?Q?ZDkey3KIiQZ+QZZCk7nYicijiaAPkt3A9eQDd3CB2/UYKmCnFgQ4XEkW8J/a?=
 =?us-ascii?Q?Cbl/ngm3BS39UTvAjy9cl2+bXnu2tLNnKKN7wvD7N92oeaNMNG1aQJj52tFb?=
 =?us-ascii?Q?Yxl4ShJxGYH/Dr3i6UhqCDSV+tGAeG2Zdslmgfqu5n9YhCfITJ9sdS4mTqr2?=
 =?us-ascii?Q?fx+g3rsilKaJ9zIvHklT6Dd6IknZuTVB3GC4M0lZrTzWBFR7A7gjRQhBzyiC?=
 =?us-ascii?Q?eK9h+Yqp2bcRfBSYXh9Cl9Ewgpm1tcjRV9UVvFF4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:22:55.4524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fff06f28-1c5f-438d-17e5-08de16d52010
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8978

Add API to get SoC version and family info.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/firmware/xilinx/zynqmp-crypto.c     | 31 +++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp-crypto.h | 19 +++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/firmware/xilinx/zynqmp-crypto.c b/drivers/firmware/xilinx/zynqmp-crypto.c
index ea9cac6a1052..6d17cb8b27b3 100644
--- a/drivers/firmware/xilinx/zynqmp-crypto.c
+++ b/drivers/firmware/xilinx/zynqmp-crypto.c
@@ -57,3 +57,34 @@ int zynqmp_pm_sha_hash(const u64 address, const u32 size, const u32 flags)
 	return zynqmp_pm_invoke_fn(PM_SECURE_SHA, NULL, 4, upper_addr, lower_addr, size, flags);
 }
 EXPORT_SYMBOL_GPL(zynqmp_pm_sha_hash);
+
+/**
+ * xlnx_get_crypto_dev_data() - Get crypto dev data of platform
+ * @feature_map:       List of available feature map of all platform
+ *
+ * Return: Returns crypto dev data, either address crypto dev or ERR PTR
+ */
+void *xlnx_get_crypto_dev_data(struct xlnx_feature *feature_map)
+{
+	struct xlnx_feature *feature;
+	u32 pm_family_code;
+	int ret;
+
+	/* Get the Family code and sub family code of platform */
+	ret = zynqmp_pm_get_family_info(&pm_family_code);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	feature = feature_map;
+	for (; feature->family; feature++) {
+		if (feature->family == pm_family_code) {
+			ret = zynqmp_pm_feature(feature->feature_id);
+			if (ret < 0)
+				return ERR_PTR(ret);
+
+			return feature->data;
+		}
+	}
+	return ERR_PTR(-ENODEV);
+}
+EXPORT_SYMBOL_GPL(xlnx_get_crypto_dev_data);
diff --git a/include/linux/firmware/xlnx-zynqmp-crypto.h b/include/linux/firmware/xlnx-zynqmp-crypto.h
index f9eb523ba6a0..cb08f412e931 100644
--- a/include/linux/firmware/xlnx-zynqmp-crypto.h
+++ b/include/linux/firmware/xlnx-zynqmp-crypto.h
@@ -9,9 +9,23 @@
 #ifndef __FIRMWARE_XLNX_ZYNQMP_CRYPTO_H__
 #define __FIRMWARE_XLNX_ZYNQMP_CRYPTO_H__
 
+/**
+ * struct xlnx_feature - Feature data
+ * @family:	Family code of platform
+ * @subfamily:	Subfamily code of platform
+ * @feature_id:	Feature id of module
+ * @data:	Collection of all supported platform data
+ */
+struct xlnx_feature {
+	u32 family;
+	u32 feature_id;
+	void *data;
+};
+
 #if IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
 int zynqmp_pm_aes_engine(const u64 address, u32 *out);
 int zynqmp_pm_sha_hash(const u64 address, const u32 size, const u32 flags);
+void *xlnx_get_crypto_dev_data(struct xlnx_feature *feature_map);
 #else
 static inline int zynqmp_pm_aes_engine(const u64 address, u32 *out)
 {
@@ -23,6 +37,11 @@ static inline int zynqmp_pm_sha_hash(const u64 address, const u32 size,
 {
 	return -ENODEV;
 }
+
+static inline void *xlnx_get_crypto_dev_data(struct xlnx_feature *feature_map)
+{
+	return ERR_PTR(-ENODEV);
+}
 #endif
 
 #endif /* __FIRMWARE_XLNX_ZYNQMP_CRYPTO_H__ */
-- 
2.49.1

