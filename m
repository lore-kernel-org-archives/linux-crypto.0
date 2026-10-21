Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792602411;
	b=HMazwoKjSD22K2xbPkj67nbteX+OX7KHvPyx+bhWdwBVQxC/fR961cxcVUuk9XPO/t1t
	 cGaibwNfuQz38j7MIgH84Oe6pxsdmYBXAWhHrpiby7ysdB686ZefVzxCPdjHXtZqM2Ur9
	 XT+24Xgx9tEwI9XpMmUILjXevjO9MGsEXofISwmb1dXLnMTGEH3OP79OyBLUcT7kN/KGn
	 qp9YeYOFPxufUt9Ci9T6jSCFguXaaQ7ymy3ZJls5v0jAsuofkTIyaIIlbcrL0VQUqLKv9
	 hfNkrw9XxSprRri6BDTPjhOY2yXf00KJvthpzXJ3Rgi3CO74zQ3yS+4gd3S5CIVgNHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602411;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=tFE4bDQTTqQ+Z3f3jICS66iN+hPVEJtpY9I2BJPD7hc=;
	b=3cUGDSG4aGYiHaxhWRNCSORUvoxuts+UknRCIRx6bEez+YO3hT3fvXBUh34OHhnYMZSW
	 nBmlq3zSR8wVtwQjlrUyQ3Vw+fQoLFhs0pMXYQv3NEdIgfVbRxRiBnAqT+4kbeGyuScSq
	 kiwh9Nv/1FcX1OjSbfJsj5EPSSo5xCBcW3swLopSBdGoEIihP/Agc0kIT7BSD+0VxTCJs
	 TsYdjgFOHVjxT7fNlVkwkY3yfYfW0IYRK7EbZC115OQJlOzXfIPdQsfAGnWKbmk2f2AH+
	 IWOy898lQ7sa6Si3oiU6p6A6cxq9oCnhZkBCaFZhS0nOKXZteL9Sbkx7Q6j+byrKEMQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=x9kASdO0;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.193.48
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010048.outbound.protection.outlook.com [52.101.193.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D044606A319;
	Wed, 21 Oct 2026 17:06:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D044606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=x9kASdO0
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tYuVeGPYvuUjyPF6vBm/LNMvaS5Hv4Mw4jowXXr6+11kVM2FK5dYkGP/DsIenCDvc1Cr9x08Lrah+PcXhhCYlzw55rZAKp3PvZq9Z+dEJisNFM0vLHSQbyl9qjD6svrBSUoJpjK08tjqftbRyU1YVk44RVS3SLI7Ym6RfaLD3CZGdRhRGic1bv9MgmDbS10CnzNX3GLBItMZawSDQYFcHTBHsMjeaC2dOrzP1Qb3RrLzPYO0h8C967YOL+POt4SlQxHlihwTXpK7otHyosZeilfB7FsHj2VmSuRsERFP9RpCrR7isfDF3Dn680yJ0SF2enn3IPsvHmQyiQu0HbIdBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFE4bDQTTqQ+Z3f3jICS66iN+hPVEJtpY9I2BJPD7hc=;
 b=zKwYdYmSpFxx1DIc1qyKA0ZymWTNDvlDIU7sE0oaP6vkwrpMC6cENIiwcnaTyBpvyjLiYjqmMJarbw9OyL/BzVWdjD/ProYrJoBfxrRTlehvtu/vnXk5Bkabh8eMJm058ftPAtMfkvYsReqruqW0uSWHn5Yr/yfh5R1Kin+XqWwyiBbj9WSODgPtMiaCfGkwIxck4/24kZeV851e5K00pg7aGiEfgXvb9AuCvm42yJ5wHbG/FIfp4XtSKD5bbRgbqB8i4eWBICA7pTkDDoPUhNNCZS6ERIj1nlT+zv9DmiMsaLEkV5jy+iSk6LxLuRqbwM/njHqof7mEOtT3sL8GJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFE4bDQTTqQ+Z3f3jICS66iN+hPVEJtpY9I2BJPD7hc=;
 b=x9kASdO08kvJU7xZxtmTa/dJOX+6HJBDlFqcC5aRuIbsLAcEv1U6O3subo7hmjpmqM33Xled6XL8WICJ3WBM47CjRd/5/7ciFBK0vNfnJz0RrUP8fRdHVzcNlvBF45NGVxOvYh+zxzCLH0jTIPtm/oDVhM4d3qZgaxVzglCHoE0=
Received: from DS1PR04CA0017.namprd04.prod.outlook.com (2603:10b6:8:243::19)
 by DS0PR12MB8413.namprd12.prod.outlook.com (2603:10b6:8:f9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15; Wed, 21 Oct 2026 17:06:45 +0000
Received: from CH01EPF000BE94B.namprd02.prod.outlook.com
 (2603:10b6:8:243:cafe::9b) by DS1PR04CA0017.outlook.office365.com
 (2603:10b6:8:243::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.16 via Frontend Transport; Wed,
 21 Oct 2026 17:06:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94B.mail.protection.outlook.com (10.167.244.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 17:06:44 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 12:06:39 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v5 6/7] crypto: ccp - Register with fw_uploader and always fail
Date: Wed, 21 Oct 2026 17:05:02 +0000
Message-ID: <8e0791954339529b617657b16a61567d251bcdb0.1792599491.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792599491.git.prsampat@amd.com>
References: <cover.1792599491.git.prsampat@amd.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94B:EE_|DS0PR12MB8413:EE_
X-MS-Office365-Filtering-Correlation-Id: d897fa24-8379-4e6a-9c06-08df2f95af6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|23010399003|36860700016|56012099006|261009223327099003|261009220027099003|11063799006|261009221227099003|261009221727099003|261009223027099003|10067099003|22082099003|18002099003|261021121427099003|261021135927099002;
X-Microsoft-Antispam-Message-Info:
	8LNB1Cet/wnDfivrfN1tLe1jNX1eRp2GF6qsWdsiijSYqm78FoB91abi3TTl/+hmIyUvn0CM6Uzo6AIBRYrGtc7xet3xFuSMYM6gRn2OXMT3OZlxJG+Ghzu/aXQ4ryKhmrZC0KqvDkHWydzbO/Yvj5SaC+t2m998dNVmBVVJkLsV0A1L3VJiNjwSfNgZNdyk1PXjygfeQNw8O8hY6z5xi/bFDiAF5hYeGxm6wHh+mZi8Jw33efgpDd9aI/XYF8agzhulQMeoK4IU01esA/OsTNgo6BkuljUVznee2eZ/nMDbdPH3YeaEt2MdrjEe8m3i2OeImRCV13emp3yT5l3VorNyEs/a4EV8O5njlHf38UkbEOh8vobhuSYhReNfPsIrc5y6QOklPAPKPkscleLjYg5iFjkTh0irRewmkO5hlNUFgg/Iz60+8rjs7hcVOrOkJStQiTZal/ZHXh8RQ7ufcxnTxqRiAn6orxX4FQWUWlndqmQ61KLtcXaiWhTp6pJjuRyUynkHU39hRboPbdK2YyvZOx4EB6rtFSO20kIdMqpgdmU+XC71H5ERNgwbTli35rdShGfxoVsD6oejENjtpgYq/Y3SROELovXh4n3vFhQPSZojUgHIEpsF019zQaT0fnUxzBG3yFTGj1hcxOg2TKQe2BX0LN09ZkMNP/F1XVrWN4tZCLJw8dS/LLJguxFhD4pfaSrCGOuX5QF5NOAzCw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(23010399003)(36860700016)(56012099006)(261009223327099003)(261009220027099003)(11063799006)(261009221227099003)(261009221727099003)(261009223027099003)(10067099003)(22082099003)(18002099003)(261021121427099003)(261021135927099002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zhKZbYTGQb8z74ZmEaO+Mr3r7k51YBSG3G/AIoo42LXjhN22dVDhtKypyjqdoMcHjvGVdmNFX70JvWQTnt0KB1/PNwIprVKtjgYGSYinRrdEdDgt8htA/XBfXifUR2zQ94PB7WZczy1Kq7Cf8pQKRRmUbuXnJrHGWFWko57QsPsLAZPMMVgGv1D4cfrrl4ntG1UdcEsC6iLNmMv2Z/Wap3h/2FhJR1DfR0cvBDaX3VFAQnHWkwoANVLEd0q1Ov0ht8ZYTzMgoYPZIaMqelLJhiktLafP3S9+NkH40pc4l9PpuJY7xczErbpYfFEKAdqjjvbrSjKaVZrY94OJTa4woA4lyXEb7dmZgvTBok8ccvinOSIKE9tbvj4g367SiENnLqIg9BOFSmvjLlXOWxiJICKTUGN71tb5tX6gkor9UGcwaZiTs7tPqMu1PWfKmst8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 17:06:44.9238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d897fa24-8379-4e6a-9c06-08df2f95af6e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8413

In preparation for SEV-SNP DOWNLOAD_FIRMWARE_EX live firmware update
support, add an 'sev' firmware loader that always fails with EBUSY.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v4..v5:
No change
---
 drivers/crypto/ccp/Kconfig   |  2 +
 drivers/crypto/ccp/sev-dev.c | 72 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  2 +
 3 files changed, 76 insertions(+)

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index f16a0f611317..8544533a962a 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -40,6 +40,8 @@ config CRYPTO_DEV_SP_PSP
 	default y
 	depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
 	select PCI_TSM if PCI
+	select FW_LOADER
+	select FW_UPLOAD
 	help
 	 Provide support for the AMD Platform Security Processor (PSP).
 	 The PSP is a dedicated processor that provides support for key
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 76698a7a1a3c..e24c04956535 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2212,6 +2212,72 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
+static enum fw_upload_err sev_fw_upload_prepare(struct fw_upload *fw_upload,
+						const u8 *data, u32 size)
+{
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
+					      const u8 *data, u32 offset,
+					      u32 size, u32 *written)
+{
+	return FW_UPLOAD_ERR_BUSY;
+}
+
+static enum fw_upload_err sev_fw_upload_poll_complete(struct fw_upload *fw_upload)
+{
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static void sev_fw_upload_cancel(struct fw_upload *fw_upload)
+{
+	/* intentional no-op */
+}
+
+static const struct fw_upload_ops sev_fw_upload_ops = {
+	.prepare = sev_fw_upload_prepare,
+	.write = sev_fw_upload_write,
+	.poll_complete = sev_fw_upload_poll_complete,
+	.cancel = sev_fw_upload_cancel,
+};
+
+/* Serializes registration and unregistration of sev->fwl */
+static DEFINE_MUTEX(sev_fwl_lock);
+
+static void register_sev_fw_uploader(struct sev_device *sev)
+{
+	struct fw_upload *fwl;
+
+	guard(mutex)(&sev_fwl_lock);
+
+	/*
+	 * The interface only drives DLFW_EX, which is an SNP command, so do not
+	 * advertise it where SNP is unavailable or the interface already exists
+	 */
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP) || sev->fwl)
+		return;
+
+	fwl = firmware_upload_register(sev->dev, "sev", &sev_fw_upload_ops, sev);
+	if (IS_ERR(fwl)) {
+		dev_err(sev->dev, "SEV firmware upload registration failure: %ld\n", PTR_ERR(fwl));
+		return;
+	}
+
+	sev->fwl = fwl;
+}
+
+static void unregister_sev_fw_uploader(struct sev_device *sev)
+{
+	guard(mutex)(&sev_fwl_lock);
+
+	if (!sev->fwl)
+		return;
+
+	firmware_upload_unregister(sev->fwl);
+	sev->fwl = NULL;
+}
+
 static int __sev_snp_shutdown_locked(int *error, bool panic)
 {
 	struct psp_device *psp = psp_master;
@@ -3018,6 +3084,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	unregister_sev_fw_uploader(sev);
+
 	sev_firmware_shutdown(sev);
 
 	if (sev->misc)
@@ -3081,6 +3149,8 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
+	register_sev_fw_uploader(sev);
+
 	return;
 
 err:
@@ -3096,6 +3166,8 @@ void sev_pci_exit(void)
 	if (!sev)
 		return;
 
+	unregister_sev_fw_uploader(sev);
+
 	sev_firmware_shutdown(sev);
 }
 
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index d5e596606def..7ec692e2147e 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -69,6 +69,8 @@ struct sev_device {
 
 	struct tsm_dev *tsmdev;
 	struct sev_tio_status *tio_status;
+
+	struct fw_upload *fwl;
 };
 
 int sev_dev_init(struct psp_device *psp);
-- 
2.43.0

