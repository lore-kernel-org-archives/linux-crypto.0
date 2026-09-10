Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010065.outbound.protection.outlook.com [52.101.85.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C345C53445B;
	Thu, 10 Sep 2026 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059820; cv=fail; b=DfpxpV+cLMCM4kZ7z7AFzDMPJsunQs+3NZQIppdcc6Us69DpJkzyrxlNemxuRhvcEzRjQotXiqcWfco2XpmZVmDJpG2s3mekRwjrNgZXMly/w363X+KINsWplKnPZVnAYrRtnrcvPwsMQoavynuB+7M90sCADIfM0ShYAt90LS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059820; c=relaxed/simple;
	bh=PcM3WgkbFHqYQX9RGfuOxoXJe/706jLCMUh6MMN/rvA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hd0YoIevrWk1J6qkgQZUMdBnmU9nNMG9OlYiTGehyX5WhPCPkGiLaJDQU7zKXQWfdRdSg1PtvHJCFkc7HP4oseWJeNPIL+gNz6k+ZatX5sp2SCULpEFvS0pLzNNXXT5YOZQQD4XvDSjioqfhOeZwnCneF01eefRh+dzkVlXT8PE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mUM5xgkr; arc=fail smtp.client-ip=52.101.85.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mUM5xgkr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sdIyLNblrRTYSErj7IYj+YHNr/Yg7+Ce8zC/A1Wy+ErjFT6TDqHxIgmp+BvUU9XHJ8MXckFsIDMP3XeRRyyJ6Sw9uPKT8s68Ogcctzce2oNLrrQ7Qs7zJ4JLDH/5NrsrROft7F+9utU2pcNirJdnT01j6meo91KCqVPj9ndroQOFFKGUyMjXUcCaVgnat7DuIN5IoL16koPcqtk/Pc6fOFmvzilDnwSYi4SAQMC6z8hezDIE266STapRi+rhTpR0/tOeA7l1NoVdVd3znDYKYJkojv6NNd1YGlF52FhQw8o84Wwu3RTyPnXYft7so22dRqyodg0j0okYNzPr8QXIrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SC5SKc0KO/zUhaPvCXpQJcWhV0TrvBBfoNeqB7YaK0w=;
 b=vEEHU7Xt9SHp1dPrFOUgNKoPSQZGz029KGLkpD2IYi3Abss4Ufy7BgYVeFuQiHx41xNztP+EtgMTT9cAjIvSry3nOsl0etmIpNi20U9UzNVZwbF2Bl6/FTYX0gfvVijcYqTFE0NBLEAHp6MrmhM7MgCI4DMZO+YVlK4T6cgYbggiYOGLEojbCRhUdlb7LPwpXc8D4kuPxi8UUEhw8YyTpp/f3Q7eY09X32v1z0GyMwdXN3UXC2/EiatX0YqFMzGPtW+iM4X8j5Z0zBN3MFi7cJGJNM0TQ4Abc+FGt9J2ej85OrZTRVGrxBEogLCeqCWmyoDg/JyyLpdsZQK3Dd/d7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SC5SKc0KO/zUhaPvCXpQJcWhV0TrvBBfoNeqB7YaK0w=;
 b=mUM5xgkrY0ux+HNuMj1K5SmoMl9phu0UVaEWM4eB2Jo8IyGsOLeQbBBw8b6fRhKTma1Z+hi+wQVJU8bgjyxcorLo2WlfHVso1RsVykkzaK40zuo3/3/wnClwhedI599g3dvHW9SuwMwo054K37VpW5Wy5QytWRI3cEeE5yBvmlI=
Received: from SJ0PR13CA0193.namprd13.prod.outlook.com (2603:10b6:a03:2c3::18)
 by LV5PR12MB9754.namprd12.prod.outlook.com (2603:10b6:408:305::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 17:03:21 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::12) by SJ0PR13CA0193.outlook.office365.com
 (2603:10b6:a03:2c3::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.6 via Frontend Transport; Thu, 10
 Sep 2026 17:03:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:03:20 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 12:03:20 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [PATCH 6/7] crypto/ccp: Register with fw_uploader and always fail
Date: Thu, 10 Sep 2026 17:02:01 +0000
Message-ID: <310800f74eace37ffe561b76d40640161be425fb.1789059392.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789059391.git.prsampat@amd.com>
References: <cover.1789059391.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|LV5PR12MB9754:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b906c8b-49d4-475e-87bd-08df0f5d6ac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|1800799024|36860700016|3023799007|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mEf4iv9K9sW2ijzcJbDh2QCEIELTCgZJ5PB/SY6BKAWRvcilklvfdGWOmMAlxeMc0PubIfrseegW3He/1Y1Ftmlj181WfuSAYKl6oplKWfbYSiQjsqzoyG0dFSrvelzaUDmgOmeRYRcrSRlnr3lX4hL3PMmPRsW7j/Wy03gphg24Ip/AUHdKR9AuBSiVLBfOuqZXcMT3Q2Vh25EIIhnWwAQN/ZB3VgYqze1I6awEjQh4+LTdE4JL20zbnX238BxyJAUELYHyP1G3xOp4Xkj2JtA+g5sVm00slMqtdxkd/LiUQ5blYYJxR5f1e7uAR29gKcIP14rPUamYMols7x1TrJU9P6LccH9xvDthCkwYkYk7TuFRTxcq8BYi969NnGvrX51GEe5AIVPjbtDfqu5+i9DLlFbPrU+h597qpwGkRTm6nJWA9cE5p/QKORXKRemGhMkJfahaugTQtOErMI8Fodpud97XB00VMXPHl0dDSs9zUdXksn2EU/1Z19yG0Au2UbJYTiyWKnj9seJhnWknox/ej2znYDikpeWkqh1HWtRPJABQle6CWREnWaKV5pbYOGKndYqq/U5VuFYmpUpRzyibiYB7u6wEUwAhPiMX9d6zZfc0Pz/yGzVPSGrXNrwwuYkTCZW/P7AwTBo1jCG4HA9OWZSNtLi1sW61aHsfdMMvBGIii8v5m05Ozhl3ZVqPJkeKSFEb/Gfb7JhrD1iIaQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(1800799024)(36860700016)(3023799007)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wuN4EVx/gB5OHRT9H8TmQTd4dvIYjQ6iopVRdB2p2PCEHX/Se9WDwcoeu5RYkYw9wtZwihAOOvJxxsRrE2UF1R96qXa3IcopsJ52QpcScQYSAKRO/dshPhCyK287hhP17f+/nR+GKQgnIbqMFN+DW83DGxNRgEh+4+3bYgjbvWW4RxuJ6NqwJn0BWTr0l5JvZsaT8Q9wuEpWmMPP8LrEbLJlexXw7/eEQTFsRCfTwlFXxfXBQG8kzOECYkbkUNhM20QWTGXrUkuE0h9QCLGNyOfQCpVGt6GxiLbGrstwUtmJTYrIYYzzR+ytfBYDSDjAWrFi6xrEOafo3wBIdNx/hF3g4Lcbbe84Azfxv+4MFND/Ep94r4Sps7qldwgVXKX5LIXVU8YaP0CsVHmSU73q3/V+Rl0mmHFoWm5FSayEEJmLo2fbGgQKu1zrAlYT0plH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:03:20.6905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b906c8b-49d4-475e-87bd-08df0f5d6ac4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9754

In preparation for SEV-SNP DOWNLOAD_FIRMWARE_EX live firmware update
support, add an 'sev' firmware loader that always fails with EBUSY.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 81 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  2 +
 2 files changed, 83 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e891d6d1c6f0..397a797d9312 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2239,6 +2239,81 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
+#ifdef CONFIG_FW_UPLOAD
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
+static void register_sev_fw_uploader(struct sev_device *sev)
+{
+	struct fw_upload *fwl;
+
+	/*
+	 * SNP firmware update is a platform-wide operation; only the master
+	 * PSP issues firmware commands. Register a single global interface.
+	 */
+	if (sev->psp != psp_master || sev->fwl)
+		return;
+
+	fwl = firmware_upload_register(sev->dev, "sev", &sev_fw_upload_ops,
+				       sev);
+	if (IS_ERR(fwl)) {
+		dev_err(sev->dev, "SEV firmware upload registration failure: %ld\n",
+			PTR_ERR(fwl));
+		return;
+	}
+
+	sev->fwl = fwl;
+}
+
+/*
+ * The upload ops issue PSP commands, so the interface has to be gone before
+ * the SEV firmware is shut down and the PSP interrupt handler is cleared.
+ * devm teardown on sev->dev runs after the driver's remove callback and is
+ * therefore too late. Both teardown paths call this, so it has to tolerate
+ * being called twice.
+ */
+static void unregister_sev_fw_uploader(struct sev_device *sev)
+{
+	struct fw_upload *fwl = sev->fwl;
+
+	if (!fwl)
+		return;
+
+	sev->fwl = NULL;
+	firmware_upload_unregister(fwl);
+}
+#else	/* CONFIG_FW_UPLOAD */
+static void register_sev_fw_uploader(struct sev_device *sev) { }
+static void unregister_sev_fw_uploader(struct sev_device *sev) { }
+#endif	/* CONFIG_FW_UPLOAD */
+
 static int __sev_snp_shutdown_locked(int *error, bool panic)
 {
 	struct psp_device *psp = psp_master;
@@ -3045,6 +3120,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	unregister_sev_fw_uploader(sev);
+
 	sev_firmware_shutdown(sev);
 
 	if (sev->misc)
@@ -3108,6 +3185,8 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
+	register_sev_fw_uploader(sev);
+
 	return;
 
 err:
@@ -3123,6 +3202,8 @@ void sev_pci_exit(void)
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

