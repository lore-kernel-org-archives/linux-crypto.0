Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD303D3CE5;
	Thu, 15 Oct 2026 02:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030557; cv=fail; b=DkArp4gOIxQa4fJd/gOtC4topREjwibfBxhn109FJeFceHUuP2QJ8lxDtVrNCWXxGr+51WByjNWpAWD/VDhYbz4eYEvIkipuHtK/Ga/TwtT16xJKsnSVX7TeV1nYZS/oqgMYC5pw0sa8MUY5veT7QZCtBkQLr5QY4Bl0cbzUpbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030557; c=relaxed/simple;
	bh=EFHPXoE+bWG70L0FRtHEr59Am7MRoi2b39oGx5oWIxE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tNr6qtzzEN8kglcpKmPPmt2kUf5+6P3NFC1HcX+YV5/viKC7Uc6hVFpDiBspzKR8LdUXN2oBSPHhtpOtVHwIMgzr7Pex/Ojl2SOY+fe3nRmUhDPW3JR7ILPboRS+EnwVzD5MxH2YANByHmJ/0Nb+GjVVsnd9O7me9mUsRZGYOvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LMKa+W1E; arc=fail smtp.client-ip=52.101.48.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LMKa+W1E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1RlGbMb7S2heqMuvFx43PWwemPXUdxb40ylea0AVaaaPNWZYb1P9jHrBLdEcnHA/8J74kOGzQ57qz3vgJCYfXNBnUFnfBVuGt3bjhvGM6EiCbXKVGS4YMDdoNU4X8PZgFANBm/VaU6DhJml1rHRhdi4ARv+SZsofkxO8Hpo8+3YGK4Iifm4vC/3ChTnfbr9hU+khQrjRrE+vjon6DX4hUheIK92GNjW1U87kzgU5nQgQOB+Xoygswv1Q0nlVFYf7G0bnbdEWfw5uaESX89NDcCNWI2864VlPoSb+uRGMTykpfL0cRXVdX6VS/uoMWg10t8GvyfHg4iCu6mevKRHug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NRsa9uQSub/gKlJYTRqrhqG8c/Vo8Dm7NSedPJQiYs=;
 b=bu5BzsuzaGylmLC3QBL5Y77CvuuVqJ5kdJednvI5mTawNrcYtsSlTnnq1u1CPV66Bj+DPZ0WUVoGxqfehvm/MnuTFoEFoWqLCGlnj/gCyYGk5FPk0ZSnBjT4Sy0VpZxEFyq5yNV2VHHx49PLX+KHFX1IplVxVrN50eBVGqiSOFe8wrKd7U3um63p7bLCwmRLeAAUIIQiIzpRWUGD+NLI4yAlQc8Xx1BvenL9DtdXAIuk5eVA3yQRzpsUgC7Y/7CkZG2SpoRVrpkJXMpgIbbdWowa2jR83DsNZGso8pWVWjLT1rPKPLhBT2wq5v9ZE8cTfOs7UCCTY1Gz60RocwWkyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NRsa9uQSub/gKlJYTRqrhqG8c/Vo8Dm7NSedPJQiYs=;
 b=LMKa+W1E7rIwgTIKhy3e+FcK6ZACCKZFuNSnl7okgWrUJUU3ROVom3BLQ2YJ0TcXFKUYAwaUmqUE32PzqLwOHOrAZvRunJIgdspNLjG7ast9obxx7ctrmwre+M02O5rKqtzBk1LqvUOvQfUX7tAly6WQia5aDCAsaUyctQsUObc=
Received: from BN9PR03CA0877.namprd03.prod.outlook.com (2603:10b6:408:13c::12)
 by SA1PR12MB6773.namprd12.prod.outlook.com (2603:10b6:806:258::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Thu, 15 Oct
 2026 02:15:47 +0000
Received: from LV8PEPF00000068.namprd03.prod.outlook.com
 (2603:10b6:408:13c:cafe::a0) by BN9PR03CA0877.outlook.office365.com
 (2603:10b6:408:13c::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Thu, 15
 Oct 2026 02:15:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 LV8PEPF00000068.mail.protection.outlook.com (10.167.248.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 02:15:47 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 21:15:40 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v4 6/7] crypto/ccp: Register with fw_uploader and always fail
Date: Thu, 15 Oct 2026 02:14:08 +0000
Message-ID: <58f95e2c88afe4a360b25f291b790d3866beec18.1792014060.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792014060.git.prsampat@amd.com>
References: <cover.1792014060.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF00000068:EE_|SA1PR12MB6773:EE_
X-MS-Office365-Filtering-Correlation-Id: b5961e83-5fb2-47cb-d29c-08df2a6239ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|1800799024|23010399003|82310400026|261009223327099003|56012099006|11063799006|261009223027099003|261009221727099003|261009220027099003|261009221227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	dWA54oX8Gp7/Au9hP8DOZukXhk1Us81TTDGEB7q9Kkk/7pE2K2XgO2wNhFKhQ7MN9VqJ4iQo54c+xR/6ACm9SX/z4nOF0lTbtPJoPkz1PDxHyJYZvv9aT+gR9v/ulcDR9ZSm1jto/gYTDN7IvtVxX/QTX11VKwfmQsQdb03AZ5Adwy6spFA8pGNfQKey2C7uKm8FjK+nrphkIqO6XnU9nixh6KwbYN0Ty5s7/jaQXWnD/9Ie+DJBMD4MycqfGSZcwqe1PBUGs084tFd02jwnLRR+3YdZZuvlG1EAY6Mc75a+TVs5yaDZ7gSLDq3wxhZcVKatiBnfRK2x29G6ZFm25L6n2rDm3PBhrU9wPmw2JFnVDoSKYvqaJlyPm7KQzT9RwrtBOHjN4us9SW1l+u0vSZRPLNLoklB7U0T39yivxQaeBLc5tkngpqZBre0zk4si0ewNwiDczviRuSe5Qserqxt8EyiMRnv3R7wTehrY+OYfl2zl6t+/Rl2twZvrTj5HXfuN8Iq9EA6uwi4cnlVizzefO/NzQZ0go+8xFLyZnuduE2dbI46VShIrzbvniHGbIej6lvb9EOIqAo+e9lnyFUpr1ytS/DVKqgyjyUbqUzXDtP7R9aEvH9ZAOxJTJAxJkn5C4kijV/s0GwkCFxUMRWFdFLya85z+8Sz0mi23AsgbcvWON0qJ86bC+7b55NXt7gJcLAv3LQa5pILch4wPhA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(1800799024)(23010399003)(82310400026)(261009223327099003)(56012099006)(11063799006)(261009223027099003)(261009221727099003)(261009220027099003)(261009221227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	In7qyM4Fklr01Fs6SAERrRG2JiNzO4Fi46LrrVVU/W7RnAXVoiF+sx3DbFvCY7BQNpDJt+z0dyfB4huPP9amCcPvxMrp5vvHQCocypv6z5jhh6HoaUsu0uwLUz9L+dBjDaf/7N6kYuLokx/QdQkx+Kt3XDL/4puU+X3cxZmhzrmWog8KO59cXws2BRnTjNnwONg9bdgGp+6hJoxnpJE6tQwf/Q3VdddlPJaIJ6mXnQ9XrEYko2IiP25Z4+ea4iKZSdsSEw6G7hfo2TShAnrFnv3cBkpnGWgx+T9WL5HZaPOOiwl/gk9UYEQM7VBvWp8f3xfDCJuafF7OKEdY7xyQqXwb2n8nfjLcR5jzhvwjSeJBLDhvnkuxEo4uGgxI4UtBRKQcUsuNmTzKpLkgVvXIXNRro6rFKHtxXg+0sUb0/lbA1bVJWGsAY1q2MwfpOA5S
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:15:47.2198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5961e83-5fb2-47cb-d29c-08df2a6239ab
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000068.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6773

In preparation for SEV-SNP DOWNLOAD_FIRMWARE_EX live firmware update
support, add an 'sev' firmware loader that always fails with EBUSY.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v3..v4:
* Collected Reviewed-by tags
* Cleanups for multiline error reporting - Tom
* Add FW_UPLOAD and FW_LOADER to CRYPTO_DEV_SP_PSP config- Shantanu
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

