Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012052.outbound.protection.outlook.com [52.101.53.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462FF519E13;
	Fri, 18 Sep 2026 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789749769; cv=fail; b=ta1Ae/AWhVssLjwWYucCPk8FL8Wcaxm720XjnnLEyT/C9roGoGmboN2qMwTqpUL4hcAvgavn6rtZnKEbel8w7qdz+TBMHbqpCjcq3VXxLz1G13t4xXQW8fDVBR41AgEP4tst4W4U3JNFST3/fG1A3D9eHQzw/wvwZif6ehpTCzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789749769; c=relaxed/simple;
	bh=a9bbHkoJbijYsc1hLVYLpa9oG3PzmH0X8LlD9zOqeZs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G59h/nqiZ9nqaPo3M18mumX/BnZ3XQ2Otk4gMHdAevWN9KltWtKykaTVoCRmxVv5TCjj/2qcD0cL25/2odBkDlEP7vP0FTpLd4UesCp3ZvEmlg3I8TNvUvGg+/NoMP8OZvpnHg83zstwaLJAnHPf3mor+5R1A6D0UTIDTF4X1Yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=39uYw+rN; arc=fail smtp.client-ip=52.101.53.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="39uYw+rN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJJVFmbj+b52NIDB8yX4+yoOOfFdCtjRuJrvZ3JvKxl7XDO+3c5wW2/LEGLdBbxex8ZPo2yFl8Ln1lcjcisgw96YGUkIPWziZeLofPzXVxiPZYOWrUJM4w+o3cQPtUvWZg5o2JRFBT5ykWokhh1rFnOByV3UY1ihpWJj/QJeoT+ddflkXzb9fJApngrmwfu8bnKYY28wgURjx1Ue2eGo6wtRd9igOw27RkS/6sP5Mbr2N0PlaJL2c56x7hE4+GSwXu3i9hQFGZZg1w8Qse3/Z1JtN3cg1jYepm57qGwVNypBx/DJDRaU2HtkP38kvg0FGSnzJn7jSxpwEUDbFxXANw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gao897XzuaUVH6SthFszXT6PSZBfUUavfCpUBsweRsU=;
 b=blXssBnZ5sqe2WcsPdxyBQLachKcGv9RgTZ2TfAMIq4hQv/OnEoSNMgPaAKX1R6B+9e4ZIq0MrMXswh7pwptHpvZATD3HJvf7MJmS+vBNBOH1fCtRmqVOty0GSiVRMmDzZT3c+CDM0dy8u9Ry51ksi5/x05Y91AaFrSXEt4sO5mGXDS7tzU0b4I4SLorRGN2dd74MoU0phGXqel53h+OL1M4coSeCY+3dcniii/3KpHR3SiOhMj4x4Rk5wk8U/4s101sSTSN9y/vKrEVcLk214/7NpqyGMhXjeJbLIxTVh4nn99mhrCFzENIKQj/Xjo/v3eFaR/84ffcAkh4SCVHtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gao897XzuaUVH6SthFszXT6PSZBfUUavfCpUBsweRsU=;
 b=39uYw+rNqL7sCK+8/d9izwGj0OcaV9RZDULsfwmotc0z3hadFhHSQ9LOM8dEGkjh/mGGFp7PwJjY8HCbWA3GV8oKOulW5POpQ9Wtt7rc8UjHhJQhTNZ3UMIrBB88yG1HQtpi/xQIyZxnYlMbbPzZk4Rrg/7Iy8mU9eibx5frvXM=
Received: from SJ0PR13CA0127.namprd13.prod.outlook.com (2603:10b6:a03:2c6::12)
 by MW6PR12MB8758.namprd12.prod.outlook.com (2603:10b6:303:23d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.12; Fri, 18 Sep
 2026 16:42:26 +0000
Received: from SJ1PEPF00001CDD.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::39) by SJ0PR13CA0127.outlook.office365.com
 (2603:10b6:a03:2c6::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8 via Frontend Transport; Fri, 18
 Sep 2026 16:42:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDD.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 16:42:26 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 18 Sep
 2026 11:42:23 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v2 6/7] crypto/ccp: Register with fw_uploader and always fail
Date: Fri, 18 Sep 2026 16:41:00 +0000
Message-ID: <7464499e7c352c1ab16c50700f9f68561f84ede5.1789749016.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789749016.git.prsampat@amd.com>
References: <cover.1789749016.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDD:EE_|MW6PR12MB8758:EE_
X-MS-Office365-Filtering-Correlation-Id: 0383d50b-d8c1-4f92-36fd-08df15a3d26c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|1800799024|23010399003|10067099003|3023799007|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	8RaPEAYoOlgya967DdJVCQU9VdURcUeeoloH7HPyoebAzvZETAB0n2+DYOiqS4aa+G42QnoE2XY9kiJ+G57fFKLNGd6PDsv6c1R8ZjYCZUIr2aC/y84rpG4YIBgf1TKDfsr8tim9cE+adHrauxdC+qLgd2acLSE1LbwObKdIoHVzhvPpUnu7NcX9mSm4d6pZiuFEbH54sFqlinSliV2DRqBaM2QoEe2vpbbhZ9ePouptZOl/sAhozl/EjfTd42Iv4EnJpzmKDpbktGoN7a5Gfozv0ub0ZplnY0YLqX+gNLLXx2inx6C+Pjzbp0hx8A6mwJdrUNb5V+bCsQOmvDtpGFdptcPAAklkJLRZaHyDWl5cfVGPW9mCR2040pUxhFR093dADn9mLs5Mm26qsfgHZMBvgJGb51vLcKg6q+HXc0O2nTB1lPZuPfRWODjKLYro/02abduHt33wnWT9wtOoZOKtWEeyX9YhT6gH9wDCHNxR8u7GiqTvMhvk1dCr0wt7FFxGU4c3EnWqzezhQ3i9ONDBBq6IMJfDMzd9N1j1cdSCFmXjf8gopmvPR0MSn43lnZAxXzXg9g5yJ3mWh0ToA50oR9gA3hcNemHEMPJvqVAmnUkiuGhWWUgG+tSHeOFh7YZcRhg8hbPsa8PiVfm9dUJRpSKcIAIx9PYbzBYg+7dwvHusS3hZ/tBEkLwSHQLBXcOUGuBLkD20O2N5dPHoyQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(10067099003)(3023799007)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dFl7T8BAXQz63TAtUVhrvPcl4Q2vejtG1fr1zjJIyvGKg7AnVxBj4Z0eVbAK1ZFxuMFIaKKJqDwI2JZjyVTQz2WUAF/F73+4dM1S5By7H3tnV3b5Svtnljo5N3I+VIHosCbMBZVEeWWpdsqZ+nLMzhXKCq7l2QovHqKFxYb1M4n5wBfjMPYAAu93Ni79W7lUMVc6pR4W61ofIosKiBWFGTPxfrZIMohu+H+iPrdIJHON9oscU94fte0kJj7d17Rl7ZRKCBoogHaLfn+Ry9X+r8o17NDnEQulopLWo21Hy5DDJAOdlxG4aC56sMtbFXshy2u/OoHOhzdDTQ6jsAJNlx6qD9iFvQm8cWpB+8TxGgPxvYFMBokCGI5JU2GNpIgZFpL8TI6Sj/VtkTuQfnoAsv2IzZtI6m5B3tEjtXMcKj9MudCq4O6vQhorN8pUKcow
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 16:42:26.3368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0383d50b-d8c1-4f92-36fd-08df15a3d26c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8758

In preparation for SEV-SNP DOWNLOAD_FIRMWARE_EX live firmware update
support, add an 'sev' firmware loader that always fails with EBUSY.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v1..v2:
Use an atomic to get sev->fwl state to ensure that isn't a race possible
while unregistering the interfaces -  Sashiko
---
 drivers/crypto/ccp/sev-dev.c | 79 ++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/sev-dev.h |  2 +
 2 files changed, 81 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 3704f52bd08d..f3714e8f5ab1 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2208,6 +2208,79 @@ static int sev_update_firmware(struct device *dev)
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
+ * therefore too late. Both teardown paths call this, and a module removal can
+ * run concurrently with a sysfs unbind, so claim the pointer atomically to
+ * keep the unregister to a single caller.
+ */
+static void unregister_sev_fw_uploader(struct sev_device *sev)
+{
+	struct fw_upload *fwl = xchg(&sev->fwl, NULL);
+
+	if (fwl)
+		firmware_upload_unregister(fwl);
+}
+#else	/* CONFIG_FW_UPLOAD */
+static void register_sev_fw_uploader(struct sev_device *sev) { }
+static void unregister_sev_fw_uploader(struct sev_device *sev) { }
+#endif	/* CONFIG_FW_UPLOAD */
+
 static int __sev_snp_shutdown_locked(int *error, bool panic)
 {
 	struct psp_device *psp = psp_master;
@@ -3014,6 +3087,8 @@ void sev_dev_destroy(struct psp_device *psp)
 	if (!sev)
 		return;
 
+	unregister_sev_fw_uploader(sev);
+
 	sev_firmware_shutdown(sev);
 
 	if (sev->misc)
@@ -3077,6 +3152,8 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
+	register_sev_fw_uploader(sev);
+
 	return;
 
 err:
@@ -3092,6 +3169,8 @@ void sev_pci_exit(void)
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

