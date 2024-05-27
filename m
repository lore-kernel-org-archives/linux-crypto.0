Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22802D529;
	Mon, 27 May 2024 15:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716823637; cv=fail; b=SdETiM9g5EMwUjujb6W62Sy8fnwQPQPd58gPe1RYZpOIMsKnoK4uynf6FvJ8N0JITk2YIvViMwuQifwaS9M+rpxFtP6+5t7g0irtH1J9cA0BlSmHy9fq2Yi7k4SjpQDhi3ghQoaeM4g1q35xoCBG4/NWaJSh4P+YV0GusUVTuZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716823637; c=relaxed/simple;
	bh=KazZvZaW8z4I/+7LfOFeijHjWdXQCX+2ZN1VVpaVM+0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hk1oX9lLvbZ2wpifSEgGoYQPnkvZnWdl/47VDXf6p0FnNfO8Hzd0dCtQZAIas4JAgoEnRvk8fhX0mpzKK+i7lodG8AzeS3ETmIh0GyPEH5NwwU+D5+VWs3z3edRPh4M9e1JKRYBM4fMC1YrWroNtopvPkUxnU9GMKzAsum9pQIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yYSqdPb+; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yYSqdPb+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaPfiW4AeoqGjVf/W9iw0N4bXyouS3p5pbhbFvQQ4WRobn0ptdMYItZeTFYEfEbLiJztrYIJDdQwib15JM1RekNFaeAkeJkVI4Fe94QI1ozhbg9EagqicqWhnh9ZD8dq1rZylQAvhJuna3Y2SEt+B/Trj2ZPbbdH839hrCxHALB4ewQWBm0c85ne0+1z4jbGe1IZU7g6gzqYhPJorUNf/y7BrTO7yU5lPgXitMGk1byeohJMg9C27rD1WG+L7B4Wi3XPr5G0ab1WcuFD8tgWNVWsHHRqLMZHxqQMRluYXuo3mlIGsH55LZHfphdDCJXqVhRBJncvlofHjn1bIZG8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5brGEfqhFNeGCOUQCafIiqGssVDX4P6mcmwuhsnYAg8=;
 b=NSoc314+AFlQ9EKxhDJdlFQ+6rIu4mhI3ve/kjycwB69ybCmOH8zH5VjMfnY9dRKM1lrw3/L2n3KRV3A3kklpyc5h8TVV863eq9QRcxyrVfSQLvbajNVsNBksU24H03984yQg/5DLeBi/0cWROXzEEVcH+QpFAYMyABtM4ekuE+f8Gjfv3CAG1N/W7W2BBdlX4r/4Ufkyq9CsCzCPU70jnzKpsK5/lnBuDEL9F4E9nZuyOCnq65w7hVqXIH5hcXeMpaJFPxCi2Es4W8U2JEKwZhg1fYKsYbdAOzHNpRjzhcKzdsl+oEU/QFsGXTVym34U7p0Wpbx8qoRmicK724tsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5brGEfqhFNeGCOUQCafIiqGssVDX4P6mcmwuhsnYAg8=;
 b=yYSqdPb+Lkq0dpuNVfTPfsfXqkohfK4R3nk1tmJ/ZgDJ1E6WsTO4ypw4BJzFw02/SZSIh92uY0jEDEJLLE/A1nYcEVZa5aerlzdIVHUGYd1HG827n9WOKIYeM79VTD3VvTU8pEl01qvK5hqZutM1WVIxXMcGnEIqrKPYIckDeEw=
Received: from CH2PR05CA0006.namprd05.prod.outlook.com (2603:10b6:610::19) by
 SA3PR12MB9177.namprd12.prod.outlook.com (2603:10b6:806:39d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.29; Mon, 27 May 2024 15:27:12 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::36) by CH2PR05CA0006.outlook.office365.com
 (2603:10b6:610::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.16 via Frontend
 Transport; Mon, 27 May 2024 15:27:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 27 May 2024 15:27:10 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 27 May
 2024 10:27:09 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>, "Yazen
 Ghannam" <yazen.ghannam@amd.com>
Subject: [PATCH 1/5] crypto: ccp: Represent capabilities register as a union
Date: Mon, 27 May 2024 10:26:45 -0500
Message-ID: <20240527152649.3722-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240527152649.3722-1-mario.limonciello@amd.com>
References: <20240527152649.3722-1-mario.limonciello@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|SA3PR12MB9177:EE_
X-MS-Office365-Filtering-Correlation-Id: 80e22b0f-89b9-47d3-bbf0-08dc7e617a5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j3hGeWoJJTV4BMoq/iU56ZO4yF2V0LJN3i+sJwreFu84gNhSrMx+C4Ruaron?=
 =?us-ascii?Q?3JmLW3j8vrVTRGlWGKJASGnmSA4te6RuBAqAUmIhoB6a3r/IzkKULJSEkLjF?=
 =?us-ascii?Q?NJxIczE3oLufetzENrrbMuJah7fUBC1LBr5sBjrw7Kq4gNR25y6btxC+vDkU?=
 =?us-ascii?Q?NhGkMczfjdD9qxnt6i518LTYQ5Lu/30aJFEowNuWPWVfBhRfGjnCptpIu7ZT?=
 =?us-ascii?Q?Jo5JtMN/Z6JcON7VlDxmM/LpYYYwwsG1jA1seUJhHhqgpqrFTD66GY0cGGwV?=
 =?us-ascii?Q?q72HeEBj+Tpux3M/wmRNsL9AvMeoGVAYAYla5Wwz/gxnGij57Z2p8Ea4jO6+?=
 =?us-ascii?Q?q2KBVzIE30OB+8O2UnQJ3bAZQbjE1S2M8MJHEwLOvijbm0SdsRRNs16ACBQJ?=
 =?us-ascii?Q?x1txjzPfvtXOS/jho6scpg+CE9KWmkeU6nlIoq6ptlDn8ACNGpsWFIOyGQKJ?=
 =?us-ascii?Q?cAlKXBM3DUnRICUyACq0R4/9qD6t6P9iMs/kz85kSZJdtDlWoPbffi/uuCe6?=
 =?us-ascii?Q?3LQL05czHbssBXFqo1GaZbdDzvgm5EajXWlT049hGcKDvNWtXCraToWJMhY4?=
 =?us-ascii?Q?LMXND4G1aKn7SYYB/z22T6aeJXYmwsHPOIyriSzCRIWpxi9AM8VCu0DYubQc?=
 =?us-ascii?Q?HCKTR+pq6lsTUYt/mZhFhYUNgGMNg/ye3+JyjzasXDigklBh5qj8rzpDPEkG?=
 =?us-ascii?Q?LcrvJww+j33ixc6fjjjxU4/jrC2UD1bNBhwj5QQ3imYpNsgsix7Da/NeEszI?=
 =?us-ascii?Q?Xub1QPO7NLYXcZZDnUcEmo2t3fWXBgT2SbK8jKLzPwy41aw25SQsHd1Hs8mP?=
 =?us-ascii?Q?6G7EqpJZRCcJrdt8cn23+YdKLNSj3obWudDWqr7bZaLOvUMV+ODtSUmbIpr2?=
 =?us-ascii?Q?DavKM5YTzsLhJUHKvrY52YbuTHgi4e72m8XWEhEeplHbMC1OmCwapGYa/Uri?=
 =?us-ascii?Q?JL7UIEHkupvVdivvXXPnjMFRm3S+2vtIgcEAUe6hGRKxS1zFjuzYbhNvcm7k?=
 =?us-ascii?Q?jMOqpUTg21VDrOIWaZEdWOIhu4Fz3OeBu81BPFOfgu0+EWSLb2sYACYRLtvl?=
 =?us-ascii?Q?TeCst2jIZWQ7aJXSDxTHitjFD8u9dTmUXFE0HA8w2KBir+vxlUwOdY8fFUbL?=
 =?us-ascii?Q?1pCnIMg+NolQu8PKCca+PtGcRmrrWGf0iLwiuuCeWxKNvhLximhJlP88a3ao?=
 =?us-ascii?Q?FwhWwXx5w7/TzD/wVoT8RqV49lhOqZteK9oxqvhEWUZ+hSCvkmlqEsVmJ52r?=
 =?us-ascii?Q?yoZvgegnmrmDwSRY1O6JdNZ9mIAKpvMImd0BZFBsHem0uQjkStNOmMBogAVh?=
 =?us-ascii?Q?bp1peA4k0p54mSoUqLlfZxJBN1yGLtmuVk+l5JRWzx2pzYey/X7PeJYB0D7S?=
 =?us-ascii?Q?cTyUYDWcqQED1YOgueOq+ALftdnb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 15:27:10.9099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e22b0f-89b9-47d3-bbf0-08dc7e617a5e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9177

Making the capabilities register a union makes it easier to refer
to the members instead of always doing bit shifts.

No intended functional changes.

Suggested-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
 drivers/crypto/ccp/dbc.c     |  2 +-
 drivers/crypto/ccp/psp-dev.c | 11 ++++-----
 drivers/crypto/ccp/psp-dev.h | 44 ++++++++++++++++++++----------------
 drivers/crypto/ccp/sp-dev.h  |  1 -
 drivers/crypto/ccp/sp-pci.c  | 26 ++++++++++-----------
 5 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
index d373caab52f8..5b105a23f699 100644
--- a/drivers/crypto/ccp/dbc.c
+++ b/drivers/crypto/ccp/dbc.c
@@ -223,7 +223,7 @@ int dbc_dev_init(struct psp_device *psp)
 	dbc_dev->dev = dev;
 	dbc_dev->psp = psp;
 
-	if (PSP_CAPABILITY(psp, DBC_THRU_EXT)) {
+	if (psp->capability.dbc_thru_ext) {
 		dbc_dev->use_ext = true;
 		dbc_dev->payload_size = &dbc_dev->mbox->ext_req.header.payload_size;
 		dbc_dev->result = &dbc_dev->mbox->ext_req.header.status;
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 56bf832c2947..7d9d2042be35 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -154,11 +154,10 @@ static unsigned int psp_get_capability(struct psp_device *psp)
 		dev_notice(psp->dev, "psp: unable to access the device: you might be running a broken BIOS.\n");
 		return -ENODEV;
 	}
-	psp->capability = val;
+	psp->capability.raw = val;
 
 	/* Detect TSME and/or SME status */
-	if (PSP_CAPABILITY(psp, PSP_SECURITY_REPORTING) &&
-	    psp->capability & (PSP_SECURITY_TSME_STATUS << PSP_CAPABILITY_PSP_SECURITY_OFFSET)) {
+	if (psp->capability.security_reporting && psp->capability.tsme_status) {
 		if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
 			dev_notice(psp->dev, "psp: Both TSME and SME are active, SME is unnecessary when TSME is active.\n");
 		else
@@ -171,7 +170,7 @@ static unsigned int psp_get_capability(struct psp_device *psp)
 static int psp_check_sev_support(struct psp_device *psp)
 {
 	/* Check if device supports SEV feature */
-	if (!PSP_CAPABILITY(psp, SEV)) {
+	if (!psp->capability.sev) {
 		dev_dbg(psp->dev, "psp does not support SEV\n");
 		return -ENODEV;
 	}
@@ -182,7 +181,7 @@ static int psp_check_sev_support(struct psp_device *psp)
 static int psp_check_tee_support(struct psp_device *psp)
 {
 	/* Check if device supports TEE feature */
-	if (!PSP_CAPABILITY(psp, TEE)) {
+	if (!psp->capability.tee) {
 		dev_dbg(psp->dev, "psp does not support TEE\n");
 		return -ENODEV;
 	}
@@ -214,7 +213,7 @@ static int psp_init(struct psp_device *psp)
 
 	/* dbc must come after platform access as it tests the feature */
 	if (PSP_FEATURE(psp, DBC) ||
-	    PSP_CAPABILITY(psp, DBC_THRU_EXT)) {
+	    psp->capability.dbc_thru_ext) {
 		ret = dbc_dev_init(psp);
 		if (ret)
 			return ret;
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index ae582ba63729..02a7c94c02df 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -26,6 +26,29 @@ extern struct psp_device *psp_master;
 
 typedef void (*psp_irq_handler_t)(int, void *, unsigned int);
 
+union psp_cap_register {
+	unsigned int raw;
+	struct {
+		unsigned int sev			:1,
+			     tee			:1,
+			     dbc_thru_ext		:1,
+			     rsvd1			:4,
+			     security_reporting		:1,
+			     fused_part			:1,
+			     rsvd2			:1,
+			     debug_lock_on		:1,
+			     rsvd3			:2,
+			     tsme_status		:1,
+			     rsvd4			:1,
+			     anti_rollback_status	:1,
+			     rpmc_production_enabled	:1,
+			     rpmc_spirom_available	:1,
+			     hsp_tpm_available		:1,
+			     rom_armor_enforced		:1,
+			     rsvd5			:12;
+	};
+};
+
 struct psp_device {
 	struct list_head entry;
 
@@ -46,7 +69,7 @@ struct psp_device {
 	void *platform_access_data;
 	void *dbc_data;
 
-	unsigned int capability;
+	union psp_cap_register capability;
 };
 
 void psp_set_sev_irq_handler(struct psp_device *psp, psp_irq_handler_t handler,
@@ -55,26 +78,7 @@ void psp_clear_sev_irq_handler(struct psp_device *psp);
 
 struct psp_device *psp_get_master_device(void);
 
-#define PSP_CAPABILITY_SEV			BIT(0)
-#define PSP_CAPABILITY_TEE			BIT(1)
-#define PSP_CAPABILITY_DBC_THRU_EXT		BIT(2)
-#define PSP_CAPABILITY_PSP_SECURITY_REPORTING	BIT(7)
-
 #define PSP_CAPABILITY_PSP_SECURITY_OFFSET	8
-/*
- * The PSP doesn't directly store these bits in the capability register
- * but instead copies them from the results of query command.
- *
- * The offsets from the query command are below, and shifted when used.
- */
-#define PSP_SECURITY_FUSED_PART			BIT(0)
-#define PSP_SECURITY_DEBUG_LOCK_ON		BIT(2)
-#define PSP_SECURITY_TSME_STATUS		BIT(5)
-#define PSP_SECURITY_ANTI_ROLLBACK_STATUS	BIT(7)
-#define PSP_SECURITY_RPMC_PRODUCTION_ENABLED	BIT(8)
-#define PSP_SECURITY_RPMC_SPIROM_AVAILABLE	BIT(9)
-#define PSP_SECURITY_HSP_TPM_AVAILABLE		BIT(10)
-#define PSP_SECURITY_ROM_ARMOR_ENFORCED		BIT(11)
 
 /**
  * enum psp_cmd - PSP mailbox commands
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index 03d5b9e04084..c4e125efe6c7 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -30,7 +30,6 @@
 
 #define PLATFORM_FEATURE_DBC		0x1
 
-#define PSP_CAPABILITY(psp, cap) (psp->capability & PSP_CAPABILITY_##cap)
 #define PSP_FEATURE(psp, feat)	(psp->vdata && psp->vdata->platform_features & PLATFORM_FEATURE_##feat)
 
 /* Structure to hold CCP device data */
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 300dda14182b..b57392292af1 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -39,31 +39,30 @@ struct sp_pci {
 };
 static struct sp_device *sp_dev_master;
 
-#define security_attribute_show(name, def)					\
+#define security_attribute_show(name)						\
 static ssize_t name##_show(struct device *d, struct device_attribute *attr,	\
 			   char *buf)						\
 {										\
 	struct sp_device *sp = dev_get_drvdata(d);				\
 	struct psp_device *psp = sp->psp_data;					\
-	int bit = PSP_SECURITY_##def << PSP_CAPABILITY_PSP_SECURITY_OFFSET;	\
-	return sysfs_emit(buf, "%d\n", (psp->capability & bit) > 0);		\
+	return sysfs_emit(buf, "%d\n", psp->capability.name);			\
 }
 
-security_attribute_show(fused_part, FUSED_PART)
+security_attribute_show(fused_part)
 static DEVICE_ATTR_RO(fused_part);
-security_attribute_show(debug_lock_on, DEBUG_LOCK_ON)
+security_attribute_show(debug_lock_on)
 static DEVICE_ATTR_RO(debug_lock_on);
-security_attribute_show(tsme_status, TSME_STATUS)
+security_attribute_show(tsme_status)
 static DEVICE_ATTR_RO(tsme_status);
-security_attribute_show(anti_rollback_status, ANTI_ROLLBACK_STATUS)
+security_attribute_show(anti_rollback_status)
 static DEVICE_ATTR_RO(anti_rollback_status);
-security_attribute_show(rpmc_production_enabled, RPMC_PRODUCTION_ENABLED)
+security_attribute_show(rpmc_production_enabled)
 static DEVICE_ATTR_RO(rpmc_production_enabled);
-security_attribute_show(rpmc_spirom_available, RPMC_SPIROM_AVAILABLE)
+security_attribute_show(rpmc_spirom_available)
 static DEVICE_ATTR_RO(rpmc_spirom_available);
-security_attribute_show(hsp_tpm_available, HSP_TPM_AVAILABLE)
+security_attribute_show(hsp_tpm_available)
 static DEVICE_ATTR_RO(hsp_tpm_available);
-security_attribute_show(rom_armor_enforced, ROM_ARMOR_ENFORCED)
+security_attribute_show(rom_armor_enforced)
 static DEVICE_ATTR_RO(rom_armor_enforced);
 
 static struct attribute *psp_security_attrs[] = {
@@ -84,7 +83,7 @@ static umode_t psp_security_is_visible(struct kobject *kobj, struct attribute *a
 	struct sp_device *sp = dev_get_drvdata(dev);
 	struct psp_device *psp = sp->psp_data;
 
-	if (psp && PSP_CAPABILITY(psp, PSP_SECURITY_REPORTING))
+	if (psp && psp->capability.security_reporting)
 		return 0444;
 
 	return 0;
@@ -134,8 +133,7 @@ static umode_t psp_firmware_is_visible(struct kobject *kobj, struct attribute *a
 	    psp->vdata->bootloader_info_reg)
 		val = ioread32(psp->io_regs + psp->vdata->bootloader_info_reg);
 
-	if (attr == &dev_attr_tee_version.attr &&
-	    PSP_CAPABILITY(psp, TEE) &&
+	if (attr == &dev_attr_tee_version.attr && psp->capability.tee &&
 	    psp->vdata->tee->info_reg)
 		val = ioread32(psp->io_regs + psp->vdata->tee->info_reg);
 
-- 
2.43.0

