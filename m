Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012071.outbound.protection.outlook.com [40.93.195.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4C02FFFA2;
	Wed, 29 Oct 2025 10:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733383; cv=fail; b=ECC50zb9QVnxY5rTW7D6FGuxgKdvHzGeUqcaNW7MRBV4gM/tMis9Xyr+IcFSH+YPeGmg3WR7Z00LKkEC26jqSrf68zqwkbWdVzImPdaFhG88sSq4vcF6eesx2bpPA52URKCJIFgIKhRf4oyM0MFoY+AKuZy8LhF+VOYRKn1Ot18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733383; c=relaxed/simple;
	bh=PccPAP5L5m6pKO2oFm8us3hUxLZwhHnW1OTaGXSNCSo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3q4zP7C1D6SbgOFhqtMqpymNhSOb34ixB3KKsENcPPONC60CVVNUnRn8Qw+oUByfW0BDiWYlTfRo4DhHR0YAkCbGTdOK/X1IPjrn2exbmxQa+EZd31jxLKiTn7vqddSVikwjlwl7niLCDp7+dLwezRLjz3BmK6ZEFWuUv7nguk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xVyw8Z2R; arc=fail smtp.client-ip=40.93.195.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xVyw8Z2R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TadgGa2o2yWqwb7d36ngGtUjdBKpySeztO2lEb+zEyAGXDjCoyI/I0xKNeoxFQT4KLHYof341zGAIeHXcH/MYypiv5XOwHPm/U5yFtfk9lmsqBkU0aWUpZxgWQWK/EriGprJxSjv8pgFWMJdDFmtl/woJ8keybIlJVHPMaOvYdqw5CEm+T8D28ySWMv0j+lwaUzKnmQYRkWybCkfe346vpxRnmhNJ6MoWkjNyMtOzhwARR3onkbqmh1riXh/Fmca+jpkVYpWGttHBNlxyAD7ylhAvsgoHR3LiVGUF14qI2OrrQGUIlLBuoChjKQ9CCyPjyhhIneIlEuVyEu0S213Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RupdZ5pvXnQsJngiFi+4yGVrGtuuLJuPIbUjjHdOmRI=;
 b=N0tH8DbO6Pkpkck3w3nSOrhqWB0N/FtrAahlaC6I63FJnzdPvuzVKsoVvR8F8ui2sBrg1qwAmEtSbVLONeEUv5VjeH9TZ+wyXGsFSCHMyQEScXHCGFr4WpTN75DbU8nyiQ1BsYAn01gEU88rH7rgplyqS7b0hoFjpa6wdWo7ymESDS1cM3ChocOiyO0ywyI0cPCR1CKR9MvPoCoiTWue4nMnLI+xjOt2Ffv0vAn2sb1XOSp1nGGDaVsC2ISY8doRld73OLHMh0GJolsgh/+0ChTCQlrG6e802MjHSAcExHWJTFHOvR+/SakgyVEudOkFPuu+628YwPPZPXVKnP2PxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RupdZ5pvXnQsJngiFi+4yGVrGtuuLJuPIbUjjHdOmRI=;
 b=xVyw8Z2R0pUO7k/B6JlTV+pmPn3qcD6baHY36MZ6LvkfTzYfB2HJnf4Dn3Xy5uWq7Q3D62XXeY0vWOeBk2RpGKBEWtqDmwrHc3D/KelViXfasygE+9dW4+53ur+48vQUdGRq9ynEEzF4SCd8nX7nJBwicD/XtgUknxqU/08WfLc=
Received: from MW4PR02CA0028.namprd02.prod.outlook.com (2603:10b6:303:16d::7)
 by DM6PR12MB4156.namprd12.prod.outlook.com (2603:10b6:5:218::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 10:22:54 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:303:16d:cafe::b5) by MW4PR02CA0028.outlook.office365.com
 (2603:10b6:303:16d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.12 via Frontend Transport; Wed,
 29 Oct 2025 10:22:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:22:53 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:52 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:52 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:22:49 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 11/15] firmware: xilinx: Add firmware API's to support aes-gcm in Versal device
Date: Wed, 29 Oct 2025 15:51:54 +0530
Message-ID: <20251029102158.3190743-12-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|DM6PR12MB4156:EE_
X-MS-Office365-Filtering-Correlation-Id: 996a49c7-72a3-4e43-a243-08de16d51f00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QQf21XJJ92LQDbj7tAEplWx0EsH/fOub4fRGrN6Dkjx04eCESDzGl3QaGDQn?=
 =?us-ascii?Q?kv+BEgWR0FR38xqP/rj+LnAeah5dtWakv86kl+dG7wV+E8wKyCk44pWit/Nd?=
 =?us-ascii?Q?8qoHlDy2t3fdPlO0oZzyXDvJWZu0PkuVPkW0I+6F5ty2yFSpuQEqbsIm2aEz?=
 =?us-ascii?Q?+XKWAefvF9Pbuh4Z79v8rbxO4vE6MOKAYO8xU1bW4js9es1GiQrf1geBvhpb?=
 =?us-ascii?Q?S6IW+BN+Mgfg7O/OHOgQs/T00lyPpwPGAfTLnRdh1zKN1fKulND9zPLI0+w2?=
 =?us-ascii?Q?N4dQ475s2o6Bn59BbvrVvIRmYTQ5MGGfXQwHY8DILm8Ux2sRpMjjqHL36Uct?=
 =?us-ascii?Q?lUrIWb5mPNxhE3q3ivWIVnaUgYe266CWqn2xdIZsd54Vg9S/EuK42gJQORk+?=
 =?us-ascii?Q?Vut6hDjNogEZ6uV87ovKPsJa8i6B5kCLkhYHax+vrj6mSD/g7Y0kxAn136VV?=
 =?us-ascii?Q?3bH0t9HsnX+jB7lyDk1FvmwWrtg7eeo89THNapH0ZccyeUEUZY0XJ+tGmCgZ?=
 =?us-ascii?Q?00OFcYz3ClW4UZ1W678BoRG5raNnX3fFCyJN10zynsqWIsDH7kPo5E+pDtXl?=
 =?us-ascii?Q?htXOsWJ9BkdAXt+bG9j1xayCutAjHdu4UZmcKaOcWZanH4ayWNbQM0znSppV?=
 =?us-ascii?Q?HEPo7+Gl7Hm4T1RGJjbNZIWDbu4c+ZzQ04eaKCoS7I6iGGy18maLL7pFml6r?=
 =?us-ascii?Q?15flZoMtYPATROCIqWtJ9eI/f0LVQxJ5Cp5k8M5u25h4KZHKlgCBqWDNtJrI?=
 =?us-ascii?Q?8MIGLRIFVfx482fn2oRvDTOgmX+Z1iSt/11Iz6UXnFw6XscqqhEdA1yjP4Mp?=
 =?us-ascii?Q?4tZlhQoC1TAn1/z+MiSD9BzN+SfpSYiFq6k1c7jOWe2axR8dYt6mDwxRJQjR?=
 =?us-ascii?Q?g3D9rVy40qxEWz8no0u79U1Bo9AzS/YqRKALA/WPv4BIdkFbN/Z7vCd85NJJ?=
 =?us-ascii?Q?+vTZTZrNKCeF4RYvr28H47yZMJfOQ/+0JjXHFQJZi9LnqeZ3/oLsvhghta+I?=
 =?us-ascii?Q?5BQJQF5dQl8X+NbSYL08+DmdaDHGUSjPEPkoFSzYqatg6ItSVRuKtXwFAy6l?=
 =?us-ascii?Q?xO1NfQAse4s/EB3tAF+9txD4xQXkeUCMQQigvHha/6+cEkX7hpPMED/H/GEf?=
 =?us-ascii?Q?IvHncAjLOSKv8IM/I7yPTtTcGCdfwprNs3UNT3FMC1x/8BVVmftMiMmXQjrB?=
 =?us-ascii?Q?IYUizvvFZZydseo1romBLbePdN/C0Lgboir3Sb25r14v0lGOgMk08Gv5wUw0?=
 =?us-ascii?Q?hljydlzPJ+3PZp0/0E5+l+xboh0MPUWpJaIu/d39dWze86xekp8ce9rwHxCG?=
 =?us-ascii?Q?1DH01gqOePfCjxvU+DSV34h86P1RdOGCjUqYxDQsIU+7R/BzE6+BhxzjVMp7?=
 =?us-ascii?Q?22csy5lizCCvLn7iCoViiUsH9tm/MgO3gdIXQC4zrubdJ/xHSBYeTZgRUSHL?=
 =?us-ascii?Q?8T3jRH+zZpeYjyWkWy4WykqlnkK4P8UtNp45Z9PLxfd3RMKJ7VikG4bfZzIh?=
 =?us-ascii?Q?lX1wXWqUiNLiuusNLT2OEk2+lpzVfip4FdcNpQaPYmA7W7NH3TSi2S0HSvEa?=
 =?us-ascii?Q?1zM9IIGxE4O1VF465xML89fAgM2AMSIeGnOKr0uq?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:22:53.5817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 996a49c7-72a3-4e43-a243-08de16d51f00
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4156

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

