Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794592333;
	b=qMHPpHJKAUfdyEnE8VuXSIZpzOfTJx2ZKJdcvMqdZC9RFD9WOjy6OBpN9ook/W7AQloa
	 2UNK3BWMs12WCtIdrZizRu34v7tpM882c18AiPUKW3lJzGBNJEOd2kFbMAajczHTSPVrx
	 cOvD63aHJHehiiCTD6cha2t7B+6q5uQWoruV6vIBjNI3K30Kn4d9WcZWGzKkSIkafoVuz
	 Ima3xkDJKGDZZL7/r9iQGyMYYSPUtepqxx4uztT91eK5zvIMcEGW0JK44gN+sKQQx9lWZ
	 kg5Fl3bWGqyTKKOwOyq9D6rthfu5OvXG3Hp96IoiR2BrboxPYiH/CKVmmbwCMIbyM6A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794592333;
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
	bh=4sx9cfZYwP9taSyH29dnEo5VA8gtzFjoBnF2pIOpPcs=;
	b=LyVL5qKoFVVYDIj9dC5aF1m0feMLgn4JjQ3qEfwJ3SqKp8VktL1hXgoeB9WSlgPzzx7B
	 hslxBittsZ3a1XFMH/LoEwPl9ZezMSVdsu67+Kr8USEULr3uFmAdcvnR44oQgnnOdBTjj
	 gr1IXd+5ZJaIVDLBtQ0dTDpJwQcFvYXhgNxW+VThI9OZEL1wewHWSqa7RfAloOBmp8deG
	 LOUpgkGFkGroFzMJbVaK16GClhAjvIwQdqLFOfpsAmTTHakVh9oqLORII329iNuVvjp69
	 w7JfnwsI0L4/OTuWN2VSpLvIGDIO4NEu39rUBXe5YFsxAuB82CAtCtG0fhQTJbpHwJw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5Zocm3sd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.48
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCB2606D86C;
	Fri, 13 Nov 2026 17:52:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFCB2606D86C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5Zocm3sd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W1jL/RhTHNJOtmt3Z1Y0lUptzM5YDPqdJiF1FpD5Tf0k7od+OXp1Mt+YSLum5+E8NMXPhIbZR3d++jFxTV768Tqpq/u5lvqk3O/1Bw6HsRQu1ilsla7+gmxJDTImyohkqP1GEcDF6JVdYDbo1bpZzRXkbV9XTaItTYQNb5UZqnjisgdfJHWQnVh53jPAY1+UgpBaoYmBwW9Ir5ag7fSnApJ37bqtiZq+5n2z7vCUEBqrSyeHHvrUY1dCVnJyb/Ycr3Qkgu5aftyUwtEo51q0ryLh2YdyT9icynvEVXvVb1l9ZaH1pSr4onLen+vjl6TV6ujEtCL/VAcViSIwSyZHoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4sx9cfZYwP9taSyH29dnEo5VA8gtzFjoBnF2pIOpPcs=;
 b=GIbBRLyXd+tgGyGlT1BNbVBlmrUyKUFBp4T5Lshs2J3/nERwufIbJdCtqymaZrQUpG1A9ujrV+nO5M/uHnZKngWwZRCaXUG95YEG8dyv2xoiDNXxS3Y59OcDTRNRZ62vkkpAanRG1IKFi7hre6CZU6FPGwej72i0KXAQ9p7UtggNxUNW9J/SADqutI2kDpVszeK4edcrbptQDO1nX5xjuZyoUGAsD5aEHenp61bVCfGkGQ+Do1j+sxVqRrH4SL5i1VrFGJO7bNXtWnVewKuc77s8eL39ZfkYPYtNZXfEJP0awRnggKTzZawODLK8r6slvu8H9DRjISUoNlxzw0n/8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4sx9cfZYwP9taSyH29dnEo5VA8gtzFjoBnF2pIOpPcs=;
 b=5Zocm3sd2DWIthSHqqxNSXRw8JVChJXcudqsBHkzM6CzrsrrG8ilVYlCfgU8DgOSx2NZHrpTBLsanT19FjuOQZGYdRaX7ycP5deMOTVu0dYPPm54B1MsPpCjCn4cIUeQqu/Ds0bSvjp3FV/Tr0soYLa//SxyorzwpCz+RxyaDHg=
Received: from CH3P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::22)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Fri, 13 Nov
 2026 17:33:19 +0000
Received: from BL2PEPF000352D6.namprd02.prod.outlook.com
 (2603:10b6:610:1e8:cafe::4) by CH3P220CA0017.outlook.office365.com
 (2603:10b6:610:1e8::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Fri,
 13 Nov 2026 17:33:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL2PEPF000352D6.mail.protection.outlook.com (10.167.254.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 17:33:18 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 11:33:17 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v6 6/7] crypto: ccp - Register with fw_uploader and always fail
Date: Fri, 13 Nov 2026 17:31:59 +0000
Message-ID: <8032cf71faef4425973d2376dc57b389764a8c21.1794531772.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1794531772.git.prsampat@amd.com>
References: <cover.1794531772.git.prsampat@amd.com>
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
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D6:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: 4addcac2-6f1a-41bf-46dc-08df41ac350b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700016|376014|23010399003|261026140227099003|261022105027099003|56012099006|10067099003|11063799006|261021135927099003|261009223327099003|261026121527099003|261102123227099003|261021121427099003|261028144727099003|261009223027099003|261009220027099003|261009221227099003|18002099003|261009221727099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gn0wR0FFKL1okCLrSTGfj0p4EWBGZ5wQm+jN4+l6vYT8YQAxWkWJgKon46SJLPNnwkUnYD+tsRqreUhn5lIHJySnkl9NatNJ4feQ0j/K7deh1+GYr/jDQeSqgoyffHOpD7XzsefkjoVk1i1iGzMhwsSE9aF9r5MU0gr/XZ/u99lifZ2qbHHyGvQUvSnmvZu+lsULEBuFhKVqJ89kYlR5vDu+bTs/SJPfQ7XmKNjw5NtCgOSIOYoqY7DBKX5bH9gn6rQtTzvJ29IHNSyxAXmTj1rn39RCf5vTi0KoxVaTb+6dmku9PMnpKITg21lPW8DtWTzIopNrFCl6PfqR7Ys2joZ8nbSnwL8jSq3RqQsDhtX6bGvDDu+vmknKgpLcn4wK70Uf7OoJ+vesXWlYQRzFVQc9mgr2DdgSk+P3oEYO03x6EWtKBJwD+fknpu52BpnoFX2zTaj4gm2uSxv8JB9FNCWz5l2KWAz7TM+1GR0s5MW67MUsqQGnEte+7O4iPr7oWvUajsV5tqqXde360nJ4cGya5I2hc+DRfePzRWw52CPf4q4K2AgT/mTPMtmGLa5Y/P66d90fYUh1HI9fAGJcDXXJc8UCufSSj2vSkPuCbvrlwyxDE4UgdSb3ulSh/7zlyr1NTJ4DdmiISimrPO728JlL5eCRyBuRu62Mz/Te2SQvSjbkjc+S2VESKXpqOwRNb1lWARLVpQsLgh5aq/qKyA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700016)(376014)(23010399003)(261026140227099003)(261022105027099003)(56012099006)(10067099003)(11063799006)(261021135927099003)(261009223327099003)(261026121527099003)(261102123227099003)(261021121427099003)(261028144727099003)(261009223027099003)(261009220027099003)(261009221227099003)(18002099003)(261009221727099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Tj3tkCD3QrJKwSQLdLZXaM+jlfduqLqumMrQw22YqJ/sGCR1bkOO+RcWUsDi1T75Tei4cSJziwDZXZGdig2PSujMFbd3BlXu37Bg1hD3bNOn+QcMuxdAnSR9Ky4gkgs8eHwvqbDA6xsxQ02eit40E1dqjaJ4pKU3yxD+0Vd1J8qqqN1yCqZUGClizpctQAewB3drT7eIgJ7EhleR9V2bKjx2ZQUI4c9VssySsrVycNp39wxhW4x9wdH3Yj/b2DkRs/JBh3ZlKIiw1xbFGQ9IVFTttdHlgiQ5mQp2eQ0E6Ricv7ejli9a21mt9jqnfxtnIbTGg72JW23QpE7nRcfHrOttf8mdrQyZHesWhqcgfw3D5jaH5ijB8c0rtOInkjetmpEj/OWT2LRpFdbnDRlyDpivYw/LCEh8+p5ZGEG6AQcsoSCsSjh0Q8cqu0jemuRI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 17:33:18.9569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4addcac2-6f1a-41bf-46dc-08df41ac350b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790

In preparation for SEV-SNP DOWNLOAD_FIRMWARE_EX live firmware update
support, add an 'sev' firmware loader that always fails with EBUSY.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v5..v6:
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
index d8a4da1a29d1..c5d9fe7e23d7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2253,6 +2253,72 @@ static int sev_update_firmware(struct device *dev)
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
@@ -3092,6 +3158,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	unregister_sev_fw_uploader(sev);
+
 	sev_firmware_shutdown(sev);
 
 	if (sev->misc)
@@ -3155,6 +3223,8 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
+	register_sev_fw_uploader(sev);
+
 	return;
 
 err:
@@ -3170,6 +3240,8 @@ void sev_pci_exit(void)
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

