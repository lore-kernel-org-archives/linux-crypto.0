Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012035.outbound.protection.outlook.com [52.101.48.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213412C0297;
	Sat, 20 Dec 2025 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246380; cv=fail; b=h/3Z4qDuuFZPuTQGAAuyLk6dtG5c9Ypb9PUBAEMK1PjWjdMhW1CpyAvlXinBlzzWbXEEEtF3HD2JvpBaLpPV1tiKcxWO7yoalgFk5llHZ/nDlVL2K/aAoIPZdUrFFUvKUzpMsI0oIKwt6nE2Fj8BQrvsZrfa+/HLY+yX5PUGMF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246380; c=relaxed/simple;
	bh=VJTkF9Cp/Y0KePsNCOhcC6bNXhjzqYdH4+fGJZ/ftnc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pfUYnOvoNenh8KvPHDa4gCdSAGiu21IhHfiK5qWqbJQcLtkeqQZqkgIA88h1GIkw0NP8HH3WFHZbQFiVzFXh1tITVGDOdg11N7xbQWNDTwU3mHZQ7GnHiQm3Bd8uykhZTzhl66j1Wk7ACnxoji8tG190GSuBMdxnp7DCSbi4I80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vYorhRZi; arc=fail smtp.client-ip=52.101.48.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vYorhRZi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEZYtzTT3+HSrAEVGGwkrUWA1RLeqK7NiIRgwwcpV0aB863XfdWzkEiMGsgROw0yKebkXeyiUZq69+xEKoTUYETnd9/jPahVQ77cppO1dDJIpDKiCFbyRQgZeo2TWEgT3EChOeGjQany7X+M9Mr0Sl8uBA5EBVblcofkhG81ML//LhaOJTnmPeCPxGRizuwueNWZxpTkF4ZRb/GzWgYnQib/lzrRc0u5IqtGP+5ZZd7X9L5KiNAsSkfFdbgSu5DhuX0onHyeT8Hvi4TsNPIgVcIujGGnuRPP/XbpHMjeetk3f+37xuRQHHBddBuAPzAlA6C5a8hbmnb+ZgrJ0MhgYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSGMAmRKX+TVoKxri6llQq8l7QLjdPa6WW2JOzwouCY=;
 b=S4cwDTbOGTnSYxM1KVuyxSZlzbZKECWLN46sYj5WmVNpkmYsqOJNW36EgDvOJjp1UmIAwqNWJuDcLn3JM+yo9zbQJ5H5ZwzFLsN0OT9ArCN9gFaU7q0R/K+bp6zsBQuj9I+i402JyerRxHV7aihnTSPnsYkZFsKcWSwQX3uGy35kk+yM3iry0yJA6DXmPx0fQyFMU1z2tc+eapZ15LrPlW3yYG+XOmq1Qz1Nyt/b0qEQg8XXR00PoyWHcn2qTEJiSUA50ki4p7NmndKPCClAOH35C08lx8kFkWue7TIg/pQdNG5uvJnXYjMB2zpyl6NC4tRqBK/RhoiUPJ2IOGxnXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSGMAmRKX+TVoKxri6llQq8l7QLjdPa6WW2JOzwouCY=;
 b=vYorhRZiDykeH9VsZrAp5g9S8JlX/RFIgO3hT1jTlHlvmPhwB9+pNmKwILlTpWzTkf8SfYjwiPQRAfOQRzZkWLF2dWRNYLZWFvve3pyqO4TQ531+3k8FpSqs/swMdQXmI5IbZ4iz9VFrwm/ccEmSkCgxjKAu75pAOoY9jnsOX1g=
Received: from SA9P221CA0008.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::13)
 by SJ2PR12MB9210.namprd12.prod.outlook.com (2603:10b6:a03:561::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.10; Sat, 20 Dec
 2025 15:59:30 +0000
Received: from SA2PEPF00003F64.namprd04.prod.outlook.com
 (2603:10b6:806:25:cafe::7b) by SA9P221CA0008.outlook.office365.com
 (2603:10b6:806:25::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Sat,
 20 Dec 2025 15:59:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F64.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Sat, 20 Dec 2025 15:59:29 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:28 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:28 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 07:59:25 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 03/14] firmware: zynqmp: Add helper API to self discovery the device
Date: Sat, 20 Dec 2025 21:28:54 +0530
Message-ID: <20251220155905.346790-4-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F64:EE_|SJ2PR12MB9210:EE_
X-MS-Office365-Filtering-Correlation-Id: a1739c37-e9de-4ef8-85be-08de3fe0c1e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HSE+WscVxbB8oAt1KUsLn5EqU/Lv7PV7MOST5oJlB7nx3r+ELiF1htspsxLL?=
 =?us-ascii?Q?vv177JNLPeq0lrGlo++D0q99326IpDU24mqo4WzRv4pmu/iTHNeZc6igaGNO?=
 =?us-ascii?Q?V9YaTdlZKFJ2pJOyJvyViIKT9LqJXU53mLm76C2oariNnOkmRFJTo80IkIpp?=
 =?us-ascii?Q?9nCjspWvFD1yA4W4MkqfHZVAArHbHh7owZQjU2S+U3VYPWbb9PwgxVChLm3m?=
 =?us-ascii?Q?dx+4Co/F2bAnXKwARjmFpvvh+cTybPqr1+VHbL+4W9iibqLO7Rp44LGmPAoq?=
 =?us-ascii?Q?tO6WJNqRyp7SzZOfvRSh2CWpqA5utnWXGp95ZssdVU7s36bcjFmXYe9s0T14?=
 =?us-ascii?Q?exNnmZd6k/Gk1yJjevNtBSN43dchnEYffxz/0EclI6aIIOd4tKYqfRYzneUQ?=
 =?us-ascii?Q?HcisjKszZi78Zvvlv8rGSdn5VYY1XU5ds027jCY/mRQmHK1MS/Dz0SwL3bV2?=
 =?us-ascii?Q?Xv3qhMgfsgg5QbH7lOpDyEBOq2In0GHNktwO1srbCY8/GTgWzXwajL8cZmAn?=
 =?us-ascii?Q?MZ/LVI+q+/EX33bUjSyOIGHrmMyDtw0FVUyr5712VaewIhyfzB1ZHSW6OtOD?=
 =?us-ascii?Q?BAJUE10YhO3gu++F2PX1CkVQbUKMk/xbGU/wTmC9m1mU6LejOUIRV8IlCC6S?=
 =?us-ascii?Q?1aXjECmtKeE4+JGHroF2R9WvUS+mjc2W14nr9AYFy3uPEgLEl48KZ391XvT7?=
 =?us-ascii?Q?hpFf2cvTf0KeP1bYETIO5WjRZjQG4cDJvUnsumXxR5vIgTVzLG9TTP47uI6+?=
 =?us-ascii?Q?/3Am1qNXuu+ymrJRo4AwT+OEwfd3YcSB5LViOU/U53rSvVBJO09LvabpwE6m?=
 =?us-ascii?Q?yvwGd+v72ANIvhFZ9blq+eJ45hLZ0NLtEkskoy/fmRPYFYjqGeDr5SmDyWSU?=
 =?us-ascii?Q?jM0vwKKMFNzfE5WEkWBT7LxuiJdgRRnAdVOdJM7Pb8oP6ijXl1ePtdk9jdC4?=
 =?us-ascii?Q?5UJBxFMdTHcPnSYKnAVd6bQoof8tvjVJJhe/dhyphOcdww3iEVkPLWT68DFD?=
 =?us-ascii?Q?rB36fQgnPkLr8u0qfqCItWrKIcDMVHD3lTV5BYPi9EydWxWXyUwAT6Lu7Z+A?=
 =?us-ascii?Q?1WbTKBAscts9zlSjMI1fGXf/r+6Htc0mR5r7/QRxp7uppq8QNhLUgQMyHsIk?=
 =?us-ascii?Q?rPJK/8B/1QoV4jTE2wGtGAgv/26/ILP/sWdMXabBfyBfTb1Y6kLSg7mahfQI?=
 =?us-ascii?Q?5Oo3T53fVf8RkSj8H7BIrDHUmfbhvgXCPpBa7wxQAopOE5+MSoPQlTQrk4ho?=
 =?us-ascii?Q?rBtwYwNDqTQg1HVfOOgigDAYj5xcq9Pjn4piTN2WBz6cL0N8S/ZiUm5T+LG8?=
 =?us-ascii?Q?Sdi113jHXaBSeQ3fTH5uCGx67HxEIImQ9Af4kcfVfvs6j102niAFgahKCpQb?=
 =?us-ascii?Q?viFn9FGu7LBpcVNs6AjzFUhSknhRzTHyvW6QY0DqHErwWqg5sGZQV6J/rxHG?=
 =?us-ascii?Q?O5xuJhNGa3AUmZznWcTAjZxkwuz97DSPOhaFSOGDE7R9LMaN3C4EhrDrE0FA?=
 =?us-ascii?Q?HHHD3qhEQG//hU9voGOTKFhhzbb9ehorVw4EHxzuJt50HoYcFOpvTnMiBLVb?=
 =?us-ascii?Q?YdosF3quvI7k/UhD2r2UJBvtBR/FL9gWAi6fC1qM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 15:59:29.0941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1739c37-e9de-4ef8-85be-08de3fe0c1e7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9210

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

