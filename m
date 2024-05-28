Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1413917BB2C;
	Tue, 28 May 2024 21:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716930466; cv=fail; b=Z0TW1zmIBRo01Jgf5Cj9H/ASSli0AqV2WWkcISfTfbEA9fI4JeirZC8gbrSVJpSxJPIxPM/P0TT88YMHRFiPhTjgwo4FAn5qhayexn9JRD+lErlFfaugSQbuiPhCSN5m8khaDSs4CogvJSh4HD5fuFrncEGTSA764TDVr/KH8B4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716930466; c=relaxed/simple;
	bh=F7TmE8xiCfKcBMxVvi+3Gt+dEjvi/++HXwgjwprumfo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OVwONKhXY23VnbpzQx1jAJqepJzBKffkjQi5XDitX4pzMYDTnQQejAH83M21I2NSKOrWMGyefTT4MlWJts/+eG4a6SLbX92Fg4ePiMmDT9XaSFlaJd9a7A1nf76F99P//HEU2jjWbf6nd3c3+QT6hnN8Nq3IiYsaKAPM03Vj6yE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mliqyj9K; arc=fail smtp.client-ip=40.107.223.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mliqyj9K"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlI+SHUKNiyQIjpEKnrXiIOeZppMSr4kDFygeQEGjMZFnnovAnxtLYUkHNCOUzmLgTg8AZZGa5wi2bu7awJGgH+D1jxQbHqV1A+dVSdVufHcKynvRx/0+cBnDECxJH0BhO420TYvtO9u7Ioe4Vks2CbCn11N9Zywc4CpXGW8/hDGGyUTapSWnmm42vUlUzpFNVa2Pfi6p9HSjO2D0CU8qCz6S+4JIXxMM4cxCGJmzntnu8BQhO3ovJoVSpuicfcu1EHjeUijJagOUJ8E5wnv7tKbL6DnZ/fVq2cTaARg4WODGLoXnPiHd8v74xYfeBSpzEBR2Ufz5PrSnwSgOA8eSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFwB+4oOAEKNYEVcarAe9qZ/8ftwCBOwj1aNgWNasbU=;
 b=jPipRwuyI79ojH3EngjHiY+1DxP8dmrf4zHNVj25JkMTvHqJqtvMaFGO4D0vxv9tPdZ9QohhBgIHfg4ketOjpAzm4vYGdNtDh8U9pGVvscQx6VNyRKTtEIm8vkyNfU1f88rQF18DAIT1C8RkSuyUJSL5Hr9urxCETYbOyNxUP+HOPUGZKdPGFCVgv0CyjZtVW5gpQHVjoq1tk2w1TCyXlPZJ4urXy9FEWHYYB6fIbtertbu9Nq2EW9G0F8g3d2ROkg6FXlC4oNpCh4V/6q9RFrMrtSk78HsyZSiXjxRth17WyIzFgHMJLzo6bqky6QswKF2MGmV4znnEjw7nYlobZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFwB+4oOAEKNYEVcarAe9qZ/8ftwCBOwj1aNgWNasbU=;
 b=mliqyj9KjNOe411Row1Y4AwGHJtW1VO2A4r5+NNUKN8Itu7yexo+lq+n2VOgJFRevSvS4Nu7mLUkn3AayAsAFxQlp1F6nL6PI/EMosABy3M2ihqNIUxzu2bANkegJsKq7G67xp2ayvaOAOh0GFgiMrd2JD8QdVexGJNvrBtZtO8=
Received: from MN2PR16CA0015.namprd16.prod.outlook.com (2603:10b6:208:134::28)
 by BL3PR12MB6545.namprd12.prod.outlook.com (2603:10b6:208:38c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 21:07:36 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:134:cafe::6) by MN2PR16CA0015.outlook.office365.com
 (2603:10b6:208:134::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30 via Frontend
 Transport; Tue, 28 May 2024 21:07:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Tue, 28 May 2024 21:07:34 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 28 May
 2024 16:07:33 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>, "Yazen
 Ghannam" <yazen.ghannam@amd.com>
Subject: [PATCH v2 1/5] crypto: ccp: Represent capabilities register as a union
Date: Tue, 28 May 2024 16:07:08 -0500
Message-ID: <20240528210712.1268-2-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240528210712.1268-1-mario.limonciello@amd.com>
References: <20240528210712.1268-1-mario.limonciello@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|BL3PR12MB6545:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c24ba64-2a55-477e-8a0f-08dc7f5a322b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|82310400017|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IkDPG7+ZMQq39A62eXrOyLazJZzl+6PjdGoW3fkFqPIYAmB642YQJkpPA9CR?=
 =?us-ascii?Q?8bVk0hNNMllxkjwfAx8HETyDdfeEOXoGt0B2uvzt73vF6NfLdhGmzlNw9j5j?=
 =?us-ascii?Q?UyaEfZFqNt72cn1szYQ0D1EUImF5pYUMhhfRfKLTjK2X57kqh0klZ6bmSWx5?=
 =?us-ascii?Q?efj+xUF3YV08K0Nttcf/5xF93tCeK8K5xAjmAUhnjpM/xFKhbsNzYIHFFVyI?=
 =?us-ascii?Q?w28/qNMWyIFEag4PEG3r9fnA3iMvH29JKita6f0XK670IY7WXkwO74zemPq/?=
 =?us-ascii?Q?9pYe8zMG2AQ65ebdVIVedZOFF+4MpDRk15RXW03qshPWVLunQdfmE/Hc77vD?=
 =?us-ascii?Q?0DD6bZwyNF58rqy1NE9RX5LM0cmUT88gmiILbTjhZNMQ69HY5b2Gkb/p3ViZ?=
 =?us-ascii?Q?Zb9opJeNQ9ljJJYH8pn9oBu0DARcHKeVHA7N6gTkWVwuBTTsaQOGdutoNnvP?=
 =?us-ascii?Q?6nFnCe4MxV57ac5MwOZDgwnJmxl0UjeOjFBcFLHRhxzI7ZaO86NFWlfnbHsb?=
 =?us-ascii?Q?6DWnt9VCwR/H2kI1bN0LLHY1CIKc2ctJRHXGBUumqUsEg+4AuMDbZnBcrqfY?=
 =?us-ascii?Q?cvJOMeoE6zuDMcv/DCI/AZDJPcmAMNijwB6JuXn5s5D1zFZndgnAhP1GeKgx?=
 =?us-ascii?Q?EneRE4f96GZL+vrEGdB/2Q5y6WLavN/hsKQRpCurekWHbeXooU9B3G7EYbL8?=
 =?us-ascii?Q?kxQTsIeBdqN6LVqf1mse/fZg7Dnjai+21g8qFwhh9t+/hLCQbxFEHjaDTKF1?=
 =?us-ascii?Q?xjdn3YXVzu8vVqeM0RBJaGjJK6ybRH3VXVUjtF+ZHaZSdbKQusTmabUj6xcR?=
 =?us-ascii?Q?rZbrZg/9RYg4zQ6qJDPaFQi8zv8sGrczYGcPuqi+z6VI98TaYp6JSLcKWDso?=
 =?us-ascii?Q?i6kkllRFIWUgT2SWoaO22nanwkiCw2MFi8fLUawRs++88W4Ybj/9ICdmgLVJ?=
 =?us-ascii?Q?uWn2OcB5FlsrXYV6pyFXUZCJDGkAdC7k8HNo+am0uxBMzNHkIFDPF+TOIEzl?=
 =?us-ascii?Q?MWCew1M+0CYdlYUJt/TwKfTQ/YtEtRSRobVOctjilVwKolenrle1Co0xGmZw?=
 =?us-ascii?Q?vtPK6BppRjvtMTYqRl+gnrlAKKPBEABko5lXn+v778pOfDTELxuQuFDx78vr?=
 =?us-ascii?Q?S8ly76LuQQ1pedFQRfRHifHMsfcf8ijIqhqmVIelZ2oMHWdHQNP7QWWQCYq3?=
 =?us-ascii?Q?2Wv5sMuYVgmTD4NOHmaylchGH4yVZm3PN1LIWbHqBvM6EHd0MiQlTeG9++8x?=
 =?us-ascii?Q?/u1X/yoBjo/tKOr4h3BInR8tiYYDiTDI6GJUicJiX30Dmm1xiDbEdigk74iX?=
 =?us-ascii?Q?gbbGzKDMDUqA3sjACCBBIVj5Pv/9ozXtjhWN40XKzeTxXYqjIZSD9Jvu0H6x?=
 =?us-ascii?Q?sesVDt72UdueuDXWnyhGqLgfB/f3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400017)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 21:07:34.4953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c24ba64-2a55-477e-8a0f-08dc7f5a322b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6545

Making the capabilities register a union makes it easier to refer
to the members instead of always doing bit shifts.

No intended functional changes.

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Suggested-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
---
v1->v2:
 * Add tag
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

