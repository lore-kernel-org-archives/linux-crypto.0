Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013016.outbound.protection.outlook.com [40.107.201.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B7B2D8391;
	Sat, 20 Dec 2025 16:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246409; cv=fail; b=YJOTqgCAtcivQuTrCuF/3u0GbfB6enrRHVzZze2/jH8STwIvZqLQRux2tPzOe+w/ynRIdsq33JCswzCyVOCDeZl1qoYqbZydBVNeLfI+cMyu45TCEJvq8hiAbmUuDUJF5b9e3ItuZLrVPLf/PJaa2sBscEEqLB3Tf/wCedX/3qA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246409; c=relaxed/simple;
	bh=PccPAP5L5m6pKO2oFm8us3hUxLZwhHnW1OTaGXSNCSo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fqNiPhowzwsX9fG7+stqK5Ju31OHyVPKcyNRMLQ0T8cdmpNQq5c+E91gjkvwetQ6nn/7hLbeBq2+gymM8zlGn/B6v59/rUhNVq127dYwPOEKZHEJj7Sl1DmxrPizd/dfsuZC+CVQoqjAAh/Ti2VhDWmvJi4a1qMkR/ov7vwdPAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5NgnQPfI; arc=fail smtp.client-ip=40.107.201.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5NgnQPfI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RAMbEtitZLs/VpzXfiURHA2+NkpZDxEXy/5s6OCH/9WItz2FZef76l0CTtkHyrG3aC2STDdhuaIlfZaKfhtEOkvAckg6/D4W2JfkJjhyjw05rh1PwABHW0pYDuzn0kOhQjzXIdzqBwPg6LjZ71AOyYNWxztkSeUPcY7T7Lh1/1pewjIQLaOdsG3EJpMr2UQN9g+6VBTp++jdYsJAm1J+bTVbB5SQOicZOwBIj1wvtAz9LDLa7o8KvvgnRFuR3zRogq4moTV+ev+11xa1YYVOphUobHhAq/ulqZKVrg1kZMCUQ9CG3u4ZwleVPZgLV7VjbxTeV4pw7AJSXcghtjbe6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RupdZ5pvXnQsJngiFi+4yGVrGtuuLJuPIbUjjHdOmRI=;
 b=mB7YR/EZBgjpCb+AXc/U0OKr7RJJd+RrGb3sL6ap1hTh4iK9QmwKEf+mU6KYoCiUPQJ5A7xm7f6m5n9T6OXBjOu6BZfmq8fYsDODgi5ikpZqroFEl1sNutx0OXC02XQMpZu1oEjLWvEme7tZ7Tj9MQdGGNPiMJRY6VsAnPlcNUjaw9DgwsN+Bo3bihXqqYgnt5RvFPm4+jDccsmIKi5k0hmeZFZYTGjUTLTxLQYoAsU9zowf/zohYflWXfRGTZziL0RVcAReiYWGvU0U0RgAlgTrYTdoALmDGwHrK1Ljf2MhPDy0GAEzzJfn3csyAzO5f4o6kW3cFuDGi0VV12EdCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RupdZ5pvXnQsJngiFi+4yGVrGtuuLJuPIbUjjHdOmRI=;
 b=5NgnQPfI4QvT4o/I3Ihv6su05D9ZJ3vMiAe5KMPwfOG9q9iNzrDRvs8GG0d4omypaTQrP0hfgWNAi0/PZMddic+JvfJ/2Eu4BI5ltI67qyLL/GhSINKkGlLkFXp3LpnPJQS7kHSJbUsPkAGtTiFW/Fj95l9FGSlnwBfGPe1SvhQ=
Received: from SN1PR12CA0081.namprd12.prod.outlook.com (2603:10b6:802:21::16)
 by IA1PR12MB8555.namprd12.prod.outlook.com (2603:10b6:208:44f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.9; Sat, 20 Dec
 2025 16:00:02 +0000
Received: from SA2PEPF00003F67.namprd04.prod.outlook.com
 (2603:10b6:802:21:cafe::a3) by SN1PR12CA0081.outlook.office365.com
 (2603:10b6:802:21::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.9 via Frontend Transport; Sat,
 20 Dec 2025 16:00:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003F67.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Sat, 20 Dec 2025 16:00:01 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Sat, 20 Dec
 2025 10:00:01 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sat, 20 Dec
 2025 10:00:00 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 07:59:57 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 12/14] firmware: xilinx: Add firmware API's to support aes-gcm in Versal device
Date: Sat, 20 Dec 2025 21:29:03 +0530
Message-ID: <20251220155905.346790-13-h.jain@amd.com>
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
Received-SPF: None (SATLEXMB04.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F67:EE_|IA1PR12MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: 566eed05-fdb4-4e68-57aa-08de3fe0d530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ood0RRo0AI8E4bXCqpizHEU0bqRjE38DvAJJw5hnpo/bJSf75xMp8kg9te1s?=
 =?us-ascii?Q?ezq6oPDVY05BOtCQiC4OqfHygdc9bO7I1BTwUOXsaudkxTh4np4vG0YaUqKO?=
 =?us-ascii?Q?PuWp8Bif2lx5A7w5OXemJ96J07c7CoQ8jmK4avK7NmE+Q2gwYyiOKpUvUxO8?=
 =?us-ascii?Q?bIAYkz300YY2Vd5+hhQs8TJa/3euMG8/BCPhXSDwW7ZqV9pdjlvgMqZcMANY?=
 =?us-ascii?Q?OEXR5E5q2WFLDb8YGWXLq7WCa+vMShy2ZIYs3EHvNyaem5IhNv7UyYlULMsF?=
 =?us-ascii?Q?Y+DCJqTm1rPtaYCqGsldAkaWJtxITDy+uELswrmRtbmo+TOeM30zldAVhY/f?=
 =?us-ascii?Q?q16Y+EDIwd8wex39tKXoUmrBO5I8K64H7DSd0/rf579H7kgrFBNRBCIsznax?=
 =?us-ascii?Q?04gDZYUtE8qntYiHx6GE2CT/H7qD4S2tBv+NaGk+kEuASWymBtDWOb75fWPS?=
 =?us-ascii?Q?BVJijqUlgfLWQF8e7+3yeH4ZVAscQ8ZgNSJDS8xT7ELfItbrz0FrCWCCWQmN?=
 =?us-ascii?Q?ZWXHB7DGJBMOiWKPDTUnu1LwDEkOYMm3HvpNy549fMG1JuR3gE5KwAw1VPII?=
 =?us-ascii?Q?nvhAeH8XTIpMiokvGD9sQOtakVuaAJLt3Hw96pe0AWlGmHqbMHFTKT+JoySK?=
 =?us-ascii?Q?qfizsAfvU8mma7R+zQBHjHDfrTcPgQyelmbZMCu0CQcg3blO0ep579qHJc2f?=
 =?us-ascii?Q?pVoePuvoFWC+vyhPtQHsh1awQlj2u68dYleoq4xiYEvwXtBFL89YmyAcIXdV?=
 =?us-ascii?Q?Ct/emETmPj6iG2NE+56MSHS14z0qydkyug1Da27aEFoxQBbi7k59Z7JyOszB?=
 =?us-ascii?Q?/XTNjhsnMadPdbIBl/OOv17X4i0Hz8o22DrlMQ0uXMk7jcKgKzOtm8ztQ4C3?=
 =?us-ascii?Q?O8AL+Kq3a1/GwQ5kO1I3eZa876cins199ok9vHALasHeZiq/uJVvN5mVNyhD?=
 =?us-ascii?Q?aHY4Oj2fsZP5e9ROP/KmeHbr00JT89HNa4G9Y69hztJHkTxi0cAaXkwf4YGV?=
 =?us-ascii?Q?yNwdViExH8Xr6DzVEA723fxHGQfYAQ4sop+1AKHYcyx0/yDO2JYC/DRqYHT9?=
 =?us-ascii?Q?ZFJXl1xjfPxZielK28xowx+4XnBYL50b6TfK6fwvcYmvf2r8RmTSvLAOh1sW?=
 =?us-ascii?Q?8Bg2cwN5sxSUgGKuCUB2tGhs9OAkbwPg7nLARxVcOs+KADtuFjqjAGF3+Ps9?=
 =?us-ascii?Q?BIdz6I3T/MkTK1KHLqhViu3q4m1+zAblqelzXgGSw2W4qNiwKHI6p9+NQeyj?=
 =?us-ascii?Q?qLjq2FWdA/lkPf7yDJK8XNgF2kVmiAWDGnoaGSw/pS6qJjKVX5a7B/Uy7M2x?=
 =?us-ascii?Q?mUJnm6d9tB1dMmo2CNyrHO2fn5kj+0X9AllHG22S+Vc/DGnj9bHuqlRTgfAM?=
 =?us-ascii?Q?a3IWngv3TErd/hawM3LOKJYQMBt1YQPf+/TQ4VPb4hwBwlN/V/bbDUYWLMkO?=
 =?us-ascii?Q?Y17u4NZslafhM5psopiJ9Fgnf9lpP6daJLldkeV0oZbV8UlqFuFcwdMPSoJG?=
 =?us-ascii?Q?t04eE9y3H08H8UIqx1EE+MgqgX+QSK62dmO2Sf6T9Bs2MzVyKHFh81wCXJB/?=
 =?us-ascii?Q?GEoC0fJ5UgNRN/MZsl6Aa5VlaOOPEPqATkJy3125?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 16:00:01.4402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 566eed05-fdb4-4e68-57aa-08de3fe0d530
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F67.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8555

Add aes-gcm crypto API's for AMD/Xilinx Versal device.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/firmware/xilinx/zynqmp-crypto.c     | 151 +++++++++++++++++++-
 include/linux/firmware/xlnx-zynqmp-crypto.h |  76 +++++++++-
 2 files changed, 224 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/xilinx/zynqmp-crypto.c b/drivers/firmware/xilinx/zynqmp-crypto.c
index 6d17cb8b27b3..4260d6fa2536 100644
--- a/drivers/firmware/xilinx/zynqmp-crypto.c
+++ b/drivers/firmware/xilinx/zynqmp-crypto.c
@@ -60,7 +60,7 @@ EXPORT_SYMBOL_GPL(zynqmp_pm_sha_hash);
 
 /**
  * xlnx_get_crypto_dev_data() - Get crypto dev data of platform
- * @feature_map:       List of available feature map of all platform
+ * @feature_map:	List of available feature map of all platform
  *
  * Return: Returns crypto dev data, either address crypto dev or ERR PTR
  */
@@ -88,3 +88,152 @@ void *xlnx_get_crypto_dev_data(struct xlnx_feature *feature_map)
 	return ERR_PTR(-ENODEV);
 }
 EXPORT_SYMBOL_GPL(xlnx_get_crypto_dev_data);
+
+/**
+ * versal_pm_aes_key_write - Write AES key registers
+ * @keylen:	Size of the input key to be written
+ * @keysrc:	Key Source to be selected to which provided
+ *		key should be updated
+ * @keyaddr:	Address of a buffer which should contain the key
+ *		to be written
+ *
+ * This function provides support to write AES volatile user keys.
+ *
+ * Return: Returns status, either success or error+reason
+ */
+int versal_pm_aes_key_write(const u32 keylen,
+			    const u32 keysrc, const u64 keyaddr)
+{
+	return zynqmp_pm_invoke_fn(XSECURE_API_AES_WRITE_KEY, NULL, 4,
+				   keylen, keysrc,
+				   lower_32_bits(keyaddr),
+				   upper_32_bits(keyaddr));
+}
+EXPORT_SYMBOL_GPL(versal_pm_aes_key_write);
+
+/**
+ * versal_pm_aes_key_zero - Zeroise AES User key registers
+ * @keysrc:	Key Source to be selected to which provided
+ *		key should be updated
+ *
+ * This function provides support to zeroise AES volatile user keys.
+ *
+ * Return: Returns status, either success or error+reason
+ */
+int versal_pm_aes_key_zero(const u32 keysrc)
+{
+	return zynqmp_pm_invoke_fn(XSECURE_API_AES_KEY_ZERO, NULL, 1, keysrc);
+}
+EXPORT_SYMBOL_GPL(versal_pm_aes_key_zero);
+
+/**
+ * versal_pm_aes_op_init - Init AES operation
+ * @hw_req:	AES op init structure address
+ *
+ * This function provides support to init AES operation.
+ *
+ * Return: Returns status, either success or error+reason
+ */
+int versal_pm_aes_op_init(const u64 hw_req)
+{
+	return zynqmp_pm_invoke_fn(XSECURE_API_AES_OP_INIT, NULL, 2,
+				   lower_32_bits(hw_req),
+				   upper_32_bits(hw_req));
+}
+EXPORT_SYMBOL_GPL(versal_pm_aes_op_init);
+
+/**
+ * versal_pm_aes_update_aad - AES update aad
+ * @aad_addr:	AES aad address
+ * @aad_len:	AES aad data length
+ *
+ * This function provides support to update AAD data.
+ *
+ * Return: Returns status, either success or error+reason
+ */
+int versal_pm_aes_update_aad(const u64 aad_addr, const u32 aad_len)
+{
+	return zynqmp_pm_invoke_fn(XSECURE_API_AES_UPDATE_AAD, NULL, 3,
+				   lower_32_bits(aad_addr),
+				   upper_32_bits(aad_addr),
+				   aad_len);
+}
+EXPORT_SYMBOL_GPL(versal_pm_aes_update_aad);
+
+/**
+ * versal_pm_aes_enc_update - Access AES hardware to encrypt the data using
+ * AES-GCM core.
+ * @in_params:	Address of the AesParams structure
+ * @in_addr:	Address of input buffer
+ *
+ * Return:	Returns status, either success or error code.
+ */
+int versal_pm_aes_enc_update(const u64 in_params, const u64 in_addr)
+{
+	return zynqmp_pm_invoke_fn(XSECURE_API_AES_ENCRYPT_UPDATE, NULL, 4,
+				   lower_32_bits(in_params),
+				   upper_32_bits(in_params),
+				   lower_32_bits(in_addr),
+				   upper_32_bits(in_addr));
+}
+EXPORT_SYMBOL_GPL(versal_pm_aes_enc_update);
+
+/**
+ * versal_pm_aes_enc_final - Access AES hardware to store the GCM tag
+ * @gcm_addr:	Address of the gcm tag
+ *
+ * Return:	Returns status, either success or error code.
+ */
+int versal_pm_aes_enc_final(const u64 gcm_addr)
+{
+	return zynqmp_pm_invoke_fn(XSECURE_API_AES_ENCRYPT_FINAL, NULL, 2,
+				   lower_32_bits(gcm_addr),
+				   upper_32_bits(gcm_addr));
+}
+EXPORT_SYMBOL_GPL(versal_pm_aes_enc_final);
+
+/**
+ * versal_pm_aes_dec_update - Access AES hardware to decrypt the data using
+ * AES-GCM core.
+ * @in_params:	Address of the AesParams structure
+ * @in_addr:	Address of input buffer
+ *
+ * Return:	Returns status, either success or error code.
+ */
+int versal_pm_aes_dec_update(const u64 in_params, const u64 in_addr)
+{
+	return zynqmp_pm_invoke_fn(XSECURE_API_AES_DECRYPT_UPDATE, NULL, 4,
+				   lower_32_bits(in_params),
+				   upper_32_bits(in_params),
+				   lower_32_bits(in_addr),
+				   upper_32_bits(in_addr));
+}
+EXPORT_SYMBOL_GPL(versal_pm_aes_dec_update);
+
+/**
+ * versal_pm_aes_dec_final - Access AES hardware to get the GCM tag
+ * @gcm_addr:	Address of the gcm tag
+ *
+ * Return:	Returns status, either success or error code.
+ */
+int versal_pm_aes_dec_final(const u64 gcm_addr)
+{
+	return zynqmp_pm_invoke_fn(XSECURE_API_AES_DECRYPT_FINAL, NULL, 2,
+				   lower_32_bits(gcm_addr),
+				   upper_32_bits(gcm_addr));
+}
+EXPORT_SYMBOL_GPL(versal_pm_aes_dec_final);
+
+/**
+ * versal_pm_aes_init - Init AES block
+ *
+ * This function initialise AES block.
+ *
+ * Return: Returns status, either success or error+reason
+ */
+int versal_pm_aes_init(void)
+{
+	return zynqmp_pm_invoke_fn(XSECURE_API_AES_INIT, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(versal_pm_aes_init);
+
diff --git a/include/linux/firmware/xlnx-zynqmp-crypto.h b/include/linux/firmware/xlnx-zynqmp-crypto.h
index cb08f412e931..56595ab37c43 100644
--- a/include/linux/firmware/xlnx-zynqmp-crypto.h
+++ b/include/linux/firmware/xlnx-zynqmp-crypto.h
@@ -2,8 +2,8 @@
 /*
  * Firmware layer for XilSECURE APIs.
  *
- *  Copyright (C) 2014-2022 Xilinx, Inc.
- *  Copyright (C) 2022-2025 Advanced Micro Devices, Inc.
+ * Copyright (C) 2014-2022 Xilinx, Inc.
+ * Copyright (C) 2022-2025 Advanced Micro Devices, Inc.
  */
 
 #ifndef __FIRMWARE_XLNX_ZYNQMP_CRYPTO_H__
@@ -22,10 +22,32 @@ struct xlnx_feature {
 	void *data;
 };
 
+/* xilSecure API commands module id + api id */
+#define XSECURE_API_AES_INIT		0x509
+#define XSECURE_API_AES_OP_INIT		0x50a
+#define XSECURE_API_AES_UPDATE_AAD	0x50b
+#define XSECURE_API_AES_ENCRYPT_UPDATE	0x50c
+#define XSECURE_API_AES_ENCRYPT_FINAL	0x50d
+#define XSECURE_API_AES_DECRYPT_UPDATE	0x50e
+#define XSECURE_API_AES_DECRYPT_FINAL	0x50f
+#define XSECURE_API_AES_KEY_ZERO	0x510
+#define XSECURE_API_AES_WRITE_KEY	0x511
+
 #if IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)
 int zynqmp_pm_aes_engine(const u64 address, u32 *out);
 int zynqmp_pm_sha_hash(const u64 address, const u32 size, const u32 flags);
 void *xlnx_get_crypto_dev_data(struct xlnx_feature *feature_map);
+int versal_pm_aes_key_write(const u32 keylen,
+			    const u32 keysrc, const u64 keyaddr);
+int versal_pm_aes_key_zero(const u32 keysrc);
+int versal_pm_aes_op_init(const u64 hw_req);
+int versal_pm_aes_update_aad(const u64 aad_addr, const u32 aad_len);
+int versal_pm_aes_enc_update(const u64 in_params, const u64 in_addr);
+int versal_pm_aes_dec_update(const u64 in_params, const u64 in_addr);
+int versal_pm_aes_dec_final(const u64 gcm_addr);
+int versal_pm_aes_enc_final(const u64 gcm_addr);
+int versal_pm_aes_init(void);
+
 #else
 static inline int zynqmp_pm_aes_engine(const u64 address, u32 *out)
 {
@@ -42,6 +64,56 @@ static inline void *xlnx_get_crypto_dev_data(struct xlnx_feature *feature_map)
 {
 	return ERR_PTR(-ENODEV);
 }
+
+static inline int versal_pm_aes_key_write(const u32 keylen,
+					  const u32 keysrc, const u64 keyaddr)
+{
+	return -ENODEV;
+}
+
+static inline int versal_pm_aes_key_zero(const u32 keysrc)
+{
+	return -ENODEV;
+}
+
+static inline int versal_pm_aes_op_init(const u64 hw_req)
+{
+	return -ENODEV;
+}
+
+static inline int versal_pm_aes_update_aad(const u64 aad_addr,
+					   const u32 aad_len)
+{
+	return -ENODEV;
+}
+
+static inline int versal_pm_aes_enc_update(const u64 in_params,
+					   const u64 in_addr)
+{
+	return -ENODEV;
+}
+
+static inline int versal_pm_aes_dec_update(const u64 in_params,
+					   const u64 in_addr)
+{
+	return -ENODEV;
+}
+
+static inline int versal_pm_aes_enc_final(const u64 gcm_addr)
+{
+	return -ENODEV;
+}
+
+static inline int versal_pm_aes_dec_final(const u64 gcm_addr)
+{
+	return -ENODEV;
+}
+
+static inline int versal_pm_aes_init(void)
+{
+	return -ENODEV;
+}
+
 #endif
 
 #endif /* __FIRMWARE_XLNX_ZYNQMP_CRYPTO_H__ */
-- 
2.49.1

