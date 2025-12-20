Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012004.outbound.protection.outlook.com [40.93.195.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0C82BEFEB;
	Sat, 20 Dec 2025 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246368; cv=fail; b=H/ASLOp2ZJmm4Roo2+dICgaK65r75IfSPkq8gzhuTlTzDT4Qufsv3aP9qJkiEcHHSaWCAgbSS409Wz+r7duuIB8m+yHdEL2a8YkmnSr4wVaQ6e92oZ/gNK6MDONSS4C48oSpltbQ2hMxsXgQ0RvB689IRcy3RL6QjY5wBIZsX2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246368; c=relaxed/simple;
	bh=8G0ZI6qlT1zOJEMH2AYgqNWerhWB5/ULDZeHmS3u7p4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dMxxolECky+GBwnE+MnWJHguN+8VXvJDkUcD+mbHcU7znxItM19hvnMCo3e816o9W7soweKUvSQp0NEUAYILihbBWtO40I8ak1XJc4pa+6DeUr2EKeqREsQF2lUA1J6e9g7y9Px2Xy+0LWsu0Za/iQJVJrs4FDPPRHzO25esSDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MAlJfblG; arc=fail smtp.client-ip=40.93.195.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MAlJfblG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D9Hc3uqCThS5EDgcmFpi+URXuHyvkjaCw2KR/0w+WNaIMkTIX90s3qk6R6A42b43LeriY9a/Yf+pX3gz7aOkrD7Wr1BwigZZ/Otx3vFJz+CDZ6p3xoR2QgRjyViQ1kgnni5fIHBkQItQJeE+3aqfdm0Ev1nVL5AgU5JbOTYU7n9dr02HQP7Ke1j3cAhS1+ytiK3LDf+bSf74nHy6FSNdbyen/NxTbsNvrSRp0rK3C8Z3JFgykLvJaJrodzzU35F9I4Vwsdccyd03IW/6iOjsp/wrv/tIjCDLzcQVOpQco7MAg2sdCKQpcSajM9rr13i5GCUnaoK8pNyVSmI0OWEzFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDf3+YrhuaH11ecdncpLhjNVVUkZnRp+UyPB+75BHpY=;
 b=rPGmkbAxNnGm73zuPA2+ZIGGIh75TQAayyAYB6Zuk/V65Dj4nGD/Xhu92yiBXY0hMUfUWlS8oGaGIznp2g6vODnFGgIl82QFgRAz9E8P2TgxYZxRd3wuqRT4vg2tXYV9jSu8dRCNdPtV9fgQpFERUs/BK0jRZ/JTN1Ojc0uIXkxJoJP7Intzfj9dlSjgDFOZEcXq6CHnGji3oXZsk1t9h+kQaqx12tG23BLEqSZofroK4VhBhx09wSDnn92aU64LcEKI30G1uZFitlbdCHRGKWZ4GhuBMUastV1LfSvc+NM9E7UV/WkTVnaSDJlRYa5+AjyjZ3UBo4ivSkU8WXtLQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDf3+YrhuaH11ecdncpLhjNVVUkZnRp+UyPB+75BHpY=;
 b=MAlJfblGj8U09BZfGWWcinpINVISYzjZ9q62Crh1Np8Xzr+dDxMSOhM+jRBGg58xNAM5Vsfgxek2s88XGzMERmfLsHLK2Qr8IPpSwyvU6Z5+uXazGvWEgQ30HwEOGEWoCXEiDu2VZgze+0u7CKufRCmcN4ZInk+wYo9uJ7HbxzE=
Received: from SA0PR13CA0002.namprd13.prod.outlook.com (2603:10b6:806:130::7)
 by CH8PR12MB9768.namprd12.prod.outlook.com (2603:10b6:610:260::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.10; Sat, 20 Dec
 2025 15:59:23 +0000
Received: from SA2PEPF00003F61.namprd04.prod.outlook.com
 (2603:10b6:806:130:cafe::ec) by SA0PR13CA0002.outlook.office365.com
 (2603:10b6:806:130::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9456.5 via Frontend Transport; Sat,
 20 Dec 2025 15:59:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F61.mail.protection.outlook.com (10.167.248.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Sat, 20 Dec 2025 15:59:21 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:21 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:21 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 07:59:18 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 01/14] firmware: zynqmp: Move crypto API's to separate file
Date: Sat, 20 Dec 2025 21:28:52 +0530
Message-ID: <20251220155905.346790-2-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F61:EE_|CH8PR12MB9768:EE_
X-MS-Office365-Filtering-Correlation-Id: 1caf6406-2a18-4f3f-30a8-08de3fe0bd9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v+2/njAc8Oo+fG0TYIrse2hOs7i0ArWSMzhMGs4OwlOT/S/eoAui6idn22k8?=
 =?us-ascii?Q?DlLG7wKRA/xMxbGXJxJTKJVnfm7/c/Z0bvfRPPjUJHfNymoD3pl4TAb5nyjP?=
 =?us-ascii?Q?vQVM5olsDzcr2woYUqjE+4dKDAqZEhKqI7Ilm9TxKKbacDXDKaHBoLySiXi7?=
 =?us-ascii?Q?ywC90CpR6u4YLHLzzgzxPrvu8I+tKIlnWyZwsmRVR+Cq94t7zm+nF8KmbVWB?=
 =?us-ascii?Q?72vLwvXfprJTvbbYJA8so2y5hxEbUHU9hz0rzJih/n9UAFUJedPwh42I0KNU?=
 =?us-ascii?Q?yNgdA/I3/nHoqWbkX+R3+CrZTAIOaoNgzY6D6hvkB6O7ZhQaUtmJLiNo4Ant?=
 =?us-ascii?Q?FxCnOR4ojL4e1ljPeYHcNovsSJowSbCak6Lj+feyVT0d2KBBdW6fgG3qg3Rs?=
 =?us-ascii?Q?J40atFQV4i2wEKrRNIuTW7VRcEBvi9zqJwzQeCMPgW35yTnPHpAw+xIT1D0t?=
 =?us-ascii?Q?G289Plim2fZ2p+W/MWSr6EVowsw6e6XR+g3Sr0UL03HKVOfmxp+RRXW1Z5p6?=
 =?us-ascii?Q?F7F3LnReyEjJslhl7oejMFD9fryrbG5vM9sspd1OGgDWS+bL7O11iSV+icCh?=
 =?us-ascii?Q?oa46aLdT0uRdh5t3H9Jk0ZIFyeeWO1V//nOtKtCu/l9Z2BOdK/GbCJ+qBZG+?=
 =?us-ascii?Q?6OWKdJjS4gzZxHI/W6d7+SxMSqcqusiMS5NmVzbdZYgHrSYlrtElgbz18GqL?=
 =?us-ascii?Q?lzg6Ewq0ZKC0U1GvWbAq5Sb/sxl1X/mH5ldsKe4zT9GNMvRlWBulLFnmcvR8?=
 =?us-ascii?Q?v2ieGuu9IXsc4o3eVlvTKKfQR98yjYHnNk7eiodA9MvVVSFm7kwWmwL0VTIC?=
 =?us-ascii?Q?9WEP++vdASHulUjDctKJTRPQy8BegLMhX5XWDztV0lXjwImfdRluqx5fsV7O?=
 =?us-ascii?Q?2B5nIf9L7etTmlyicycZ1Gfg/tO1+8yTqj22dONwGtbA3Mg5F73QlmkWQUJY?=
 =?us-ascii?Q?vfkVd4GUlibZ0w+CIqCOGCzCtuOqH4ljgISyqNDedHc/t68fCJzkvvIQIiJH?=
 =?us-ascii?Q?wOerT7U5BPqb0eUKB7rw82PwWZMvwPifGKNDndE0+HT+PrbgjxNvoJ+GXIc6?=
 =?us-ascii?Q?XAw9Oue1jzbfbHFipNeP/Uo60Eu+KRUD4tDb+jrQox92eylTDA3vDNdTlOG5?=
 =?us-ascii?Q?Ml1rFhkpsPpGj/pJ9JkFmnweWHsxYqwEVAc9gRM5KSg0Zq53S9V7fDZ/HDmV?=
 =?us-ascii?Q?Ef9BQqRSaCbCB0ZoT70eMYVnpGk5K62+BwZb/1px6xtBJxLY61aTQj95MbjO?=
 =?us-ascii?Q?27kma5BC0ybCL33RWOKa66bZ8L1/EjWosqZnud7ssP5/bU6tvfrZSbGHHuyo?=
 =?us-ascii?Q?SY19ZLlRu68TZhPb78Y+gPGoit78HVgrH7zA1KW+voccNkTLNUAFdg6Zs3AK?=
 =?us-ascii?Q?VWg+xwOzZ5vcI+hse/+PAsvkcPEe/V9l06yNzG9Wdj1ka8Glv+vLN71JuAmg?=
 =?us-ascii?Q?fDbbWxEEsTOB9MNurzBzDW2yVRWbax9A7KEY1vMhsxwAXWQ32rhG3zAkTs/x?=
 =?us-ascii?Q?JfLv7HkEFDAu7pVh52he7Ww0UExAGqlbkKgSBwE1Sgvmf0koRAlpUZLgOv5P?=
 =?us-ascii?Q?UuXyhNNpOxccWq/NvNw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 15:59:21.8905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1caf6406-2a18-4f3f-30a8-08de3fe0bd9c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9768

For better maintainability move crypto related API's to
new zynqmp-crypto.c file.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/firmware/xilinx/Makefile            |  2 +-
 drivers/firmware/xilinx/zynqmp-crypto.c     | 59 +++++++++++++++++++++
 drivers/firmware/xilinx/zynqmp.c            | 49 -----------------
 include/linux/firmware/xlnx-zynqmp-crypto.h | 28 ++++++++++
 include/linux/firmware/xlnx-zynqmp.h        | 14 +----
 5 files changed, 89 insertions(+), 63 deletions(-)
 create mode 100644 drivers/firmware/xilinx/zynqmp-crypto.c
 create mode 100644 include/linux/firmware/xlnx-zynqmp-crypto.h

diff --git a/drivers/firmware/xilinx/Makefile b/drivers/firmware/xilinx/Makefile
index 70f8f02f14a3..8db0e66b6b7e 100644
--- a/drivers/firmware/xilinx/Makefile
+++ b/drivers/firmware/xilinx/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for Xilinx firmwares
 
-obj-$(CONFIG_ZYNQMP_FIRMWARE) += zynqmp.o zynqmp-ufs.o
+obj-$(CONFIG_ZYNQMP_FIRMWARE) += zynqmp.o zynqmp-ufs.o zynqmp-crypto.o
 obj-$(CONFIG_ZYNQMP_FIRMWARE_DEBUG) += zynqmp-debug.o
diff --git a/drivers/firmware/xilinx/zynqmp-crypto.c b/drivers/firmware/xilinx/zynqmp-crypto.c
new file mode 100644
index 000000000000..ea9cac6a1052
--- /dev/null
+++ b/drivers/firmware/xilinx/zynqmp-crypto.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Firmware layer for XilSecure APIs.
+ *
+ * Copyright (C) 2014-2022 Xilinx, Inc.
+ * Copyright (C) 2022-2025 Advanced Micro Devices, Inc.
+ */
+
+#include <linux/firmware/xlnx-zynqmp.h>
+#include <linux/module.h>
+
+/**
+ * zynqmp_pm_aes_engine - Access AES hardware to encrypt/decrypt the data using
+ * AES-GCM core.
+ * @address:	Address of the AesParams structure.
+ * @out:	Returned output value
+ *
+ * Return:	Returns status, either success or error code.
+ */
+int zynqmp_pm_aes_engine(const u64 address, u32 *out)
+{
+	u32 ret_payload[PAYLOAD_ARG_CNT];
+	int ret;
+
+	if (!out)
+		return -EINVAL;
+
+	ret = zynqmp_pm_invoke_fn(PM_SECURE_AES, ret_payload, 2, upper_32_bits(address),
+				  lower_32_bits(address));
+	*out = ret_payload[1];
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_aes_engine);
+
+/**
+ * zynqmp_pm_sha_hash - Access the SHA engine to calculate the hash
+ * @address:	Address of the data/ Address of output buffer where
+ *		hash should be stored.
+ * @size:	Size of the data.
+ * @flags:
+ *		BIT(0) - for initializing csudma driver and SHA3(Here address
+ *		and size inputs can be NULL).
+ *		BIT(1) - to call Sha3_Update API which can be called multiple
+ *		times when data is not contiguous.
+ *		BIT(2) - to get final hash of the whole updated data.
+ *		Hash will be overwritten at provided address with
+ *		48 bytes.
+ *
+ * Return:	Returns status, either success or error code.
+ */
+int zynqmp_pm_sha_hash(const u64 address, const u32 size, const u32 flags)
+{
+	u32 lower_addr = lower_32_bits(address);
+	u32 upper_addr = upper_32_bits(address);
+
+	return zynqmp_pm_invoke_fn(PM_SECURE_SHA, NULL, 4, upper_addr, lower_addr, size, flags);
+}
+EXPORT_SYMBOL_GPL(zynqmp_pm_sha_hash);
diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index ad811f40e059..f15db1a818dc 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -1521,30 +1521,6 @@ int zynqmp_pm_load_pdi(const u32 src, const u64 address)
 }
 EXPORT_SYMBOL_GPL(zynqmp_pm_load_pdi);
 
-/**
- * zynqmp_pm_aes_engine - Access AES hardware to encrypt/decrypt the data using
- * AES-GCM core.
- * @address:	Address of the AesParams structure.
- * @out:	Returned output value
- *
- * Return:	Returns status, either success or error code.
- */
-int zynqmp_pm_aes_engine(const u64 address, u32 *out)
-{
-	u32 ret_payload[PAYLOAD_ARG_CNT];
-	int ret;
-
-	if (!out)
-		return -EINVAL;
-
-	ret = zynqmp_pm_invoke_fn(PM_SECURE_AES, ret_payload, 2, upper_32_bits(address),
-				  lower_32_bits(address));
-	*out = ret_payload[1];
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(zynqmp_pm_aes_engine);
-
 /**
  * zynqmp_pm_efuse_access - Provides access to efuse memory.
  * @address:	Address of the efuse params structure
@@ -1569,31 +1545,6 @@ int zynqmp_pm_efuse_access(const u64 address, u32 *out)
 }
 EXPORT_SYMBOL_GPL(zynqmp_pm_efuse_access);
 
-/**
- * zynqmp_pm_sha_hash - Access the SHA engine to calculate the hash
- * @address:	Address of the data/ Address of output buffer where
- *		hash should be stored.
- * @size:	Size of the data.
- * @flags:
- *	BIT(0) - for initializing csudma driver and SHA3(Here address
- *		 and size inputs can be NULL).
- *	BIT(1) - to call Sha3_Update API which can be called multiple
- *		 times when data is not contiguous.
- *	BIT(2) - to get final hash of the whole updated data.
- *		 Hash will be overwritten at provided address with
- *		 48 bytes.
- *
- * Return:	Returns status, either success or error code.
- */
-int zynqmp_pm_sha_hash(const u64 address, const u32 size, const u32 flags)
-{
-	u32 lower_addr = lower_32_bits(address);
-	u32 upper_addr = upper_32_bits(address);
-
-	return zynqmp_pm_invoke_fn(PM_SECURE_SHA, NULL, 4, upper_addr, lower_addr, size, flags);
-}
-EXPORT_SYMBOL_GPL(zynqmp_pm_sha_hash);
-
 /**
  * zynqmp_pm_register_notifier() - PM API for register a subsystem
  *                                to be notified about specific
diff --git a/include/linux/firmware/xlnx-zynqmp-crypto.h b/include/linux/firmware/xlnx-zynqmp-crypto.h
new file mode 100644
index 000000000000..f9eb523ba6a0
--- /dev/null
+++ b/include/linux/firmware/xlnx-zynqmp-crypto.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Firmware layer for XilSECURE APIs.
+ *
+ *  Copyright (C) 2014-2022 Xilinx, Inc.
+ *  Copyright (C) 2022-2025 Advanced Micro Devices, Inc.
+ */
+
+#ifndef __FIRMWARE_XLNX_ZYNQMP_CRYPTO_H__
+#define __FIRMWARE_XLNX_ZYNQMP_CRYPTO_H__
+
+#if IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
+int zynqmp_pm_aes_engine(const u64 address, u32 *out);
+int zynqmp_pm_sha_hash(const u64 address, const u32 size, const u32 flags);
+#else
+static inline int zynqmp_pm_aes_engine(const u64 address, u32 *out)
+{
+	return -ENODEV;
+}
+
+static inline int zynqmp_pm_sha_hash(const u64 address, const u32 size,
+				     const u32 flags)
+{
+	return -ENODEV;
+}
+#endif
+
+#endif /* __FIRMWARE_XLNX_ZYNQMP_CRYPTO_H__ */
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 15fdbd089bbf..d70dcd462b44 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -17,6 +17,7 @@
 
 #include <linux/err.h>
 #include <linux/firmware/xlnx-zynqmp-ufs.h>
+#include <linux/firmware/xlnx-zynqmp-crypto.h>
 
 #define ZYNQMP_PM_VERSION_MAJOR	1
 #define ZYNQMP_PM_VERSION_MINOR	0
@@ -589,9 +590,7 @@ int zynqmp_pm_release_node(const u32 node);
 int zynqmp_pm_set_requirement(const u32 node, const u32 capabilities,
 			      const u32 qos,
 			      const enum zynqmp_pm_request_ack ack);
-int zynqmp_pm_aes_engine(const u64 address, u32 *out);
 int zynqmp_pm_efuse_access(const u64 address, u32 *out);
-int zynqmp_pm_sha_hash(const u64 address, const u32 size, const u32 flags);
 int zynqmp_pm_fpga_load(const u64 address, const u32 size, const u32 flags);
 int zynqmp_pm_fpga_get_status(u32 *value);
 int zynqmp_pm_fpga_get_config_status(u32 *value);
@@ -772,22 +771,11 @@ static inline int zynqmp_pm_set_requirement(const u32 node,
 	return -ENODEV;
 }
 
-static inline int zynqmp_pm_aes_engine(const u64 address, u32 *out)
-{
-	return -ENODEV;
-}
-
 static inline int zynqmp_pm_efuse_access(const u64 address, u32 *out)
 {
 	return -ENODEV;
 }
 
-static inline int zynqmp_pm_sha_hash(const u64 address, const u32 size,
-				     const u32 flags)
-{
-	return -ENODEV;
-}
-
 static inline int zynqmp_pm_fpga_load(const u64 address, const u32 size,
 				      const u32 flags)
 {
-- 
2.49.1

