Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010006.outbound.protection.outlook.com [52.101.85.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6E951C356;
	Thu, 10 Sep 2026 17:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059778; cv=fail; b=TPJW1ouh5yCkZS6K2hQSUJzt7/gtxEVFw8ytqZ8sHYhGghHpKKlDnn41uI6vPpJEroqFPR1hEatVz+w4U8zn8DBA8XkyCRAyVrZRPd5Ccf61S4nsmwsCLk7R5UfVyKyovrviKStPiZKQqmK+9wJ3HbCLIbslA7n8fDcl5ZFeSQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059778; c=relaxed/simple;
	bh=ZGtXSeAJZz/yOI1vr+67nkw+LNuTcLgWxze/8OmOf3c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MgJ4oCKn3sOz70ltGPvFBp462ulb50Lzfs78zRxGEfhBVkAFIjD/s6eKVqsaYaCeN0leSn9X4PRr/X0sC+k97U4myk6OV/WTHo6ngEblFHXDoiA0O+XSAkw4MMT8ogbScn4YaZVIKIG7dg8dAAjmdNAy8xZuJm+kiNeU5tGy124=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kUchwPvW; arc=fail smtp.client-ip=52.101.85.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kUchwPvW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5DrDo6GOknUWHmAyGt0TjV80ZX85HqMovnf2wXpxydT/EEeCIZzgx2e0mhD6fq8ROaw7wfCyziYUM2VC6f/Stn0OyaCboA3fHeCogwPocuN8/si313PLVhBQ0edx2U55G+23SVYws/Rxp7sCioAx0kre1pAtk6mNPcGl3xur+T8+UsT1MUJjj16vJafupr6I6JhEv+uk5zb+HTYacTvgtdaGsdKR3W7DGAJqO88XJyanQimlWml7tO/NzU/4ln3ZWvzbXitsZcmQ5IdHG4WA9mTGtjSnndBecISOd1XX4W4/zGUgl7eRQ/tiTXYlu66MqfuKxuLwMU2C9Th1lc4zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/BoV4hqRgwNw7odkh4jDkqTT6DGoZwDLnGcrR92Qn4=;
 b=rPpNG7DpxCHpv+D3uRrdRiJYlC7eaQwq1tpqdatWV6kJFw5Ua0HpPoejipMreFsXyd5IUbCYg9ZwFX5fmHafD6dxW/lL9gRdKLcLh5f6TXLlj/Apg3dNN+5Zia+R7puZsdPGnTLOEiGjjwpXPJkygZLi0GSsHRTcGlsg6R6EX7ZlnE7t4J9/LB1SP37w1Ns9XnlU0VdySk915s9iFP3RJ63+FfGAtWLKEhjyZl1CvCdHD7Ad6dP6qsxBMzn3ONl0USRNg7Zq8ZrE9k3NbRzgYOnfoODp7P7X31lgj3CGpyV8lQMOsIi0WMJVrWj6DmSR0JFuxQLy5BCGmSWtfcg9bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/BoV4hqRgwNw7odkh4jDkqTT6DGoZwDLnGcrR92Qn4=;
 b=kUchwPvWDYYRq6U2PvD9qRVsneMMxs+mMXMYbge7DoDPvOBMe8cSf7eo2OaNg/2mP20k6VdQmm+2atVgOGWxLCh/0qMgJJ5KqWWbKmNm9QKqi1VPMtxNjSTt/HDuZPHp1EiqFgxPJDiLuYJOpAK8hQizgDEacLSHeavj4GPh2h4=
Received: from CH0PR07CA0024.namprd07.prod.outlook.com (2603:10b6:610:32::29)
 by MN0PR12MB6149.namprd12.prod.outlook.com (2603:10b6:208:3c7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 17:02:48 +0000
Received: from CH1PEPF0000AD79.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::61) by CH0PR07CA0024.outlook.office365.com
 (2603:10b6:610:32::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:02:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD79.mail.protection.outlook.com (10.167.244.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:02:47 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 12:02:46 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [PATCH 3/7] treewide: firmware_loader: Drop the unused @module argument
Date: Thu, 10 Sep 2026 17:01:58 +0000
Message-ID: <943a87bf67aa2938da327c3a3e14f972b1933a50.1789059392.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD79:EE_|MN0PR12MB6149:EE_
X-MS-Office365-Filtering-Correlation-Id: dd170de0-974c-4a9d-9d61-08df0f5d56f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|7416014|82310400026|1800799024|376014|23010399003|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fmffVByxccUJQ7TQU8Mt8OCADm5rAjvp0OLH0hcveJHq97tjk1FTOwzEqZoW+9SavNwG4jAnrJo0Af5TPGdDf4aUk3pZ95WN+rv6V1LgYlETVZOV7OtJGFnhk8ypffa2txFGHNtXvevB2MAflPaRCbmy6NDeHAjsm2xYq8zkdCmqNjdyOmqHs223Jr1qISd5B+jiGrLXV8dZkJCr5gOPzgZUqPe+Z3U4uohjQgzMDxmzZjS2mhf1Rl0o3NpvyuXx9vV287NppbLkbkrGIKVre8B2DoPX8gJPLCr24cZM2ggnriMiYPLhDFmLz5kUelQpl6FhtNEQvTOjPYdqobEfsqYrO7F0Kl3CgKsSMhn8QXw4iQASHMPdISKRAaaiqCWHc5bNkczeES2yTT9XmLDwRWiIAQ+eJmVfK3ae22HsWA6Qw3Dtmfk42m1Uk8jvNdUR8K/fTMuq/J3iPKbmKwZgab5r727MTyx5KJ0XLGB6EhwjaMLZ7+fgsRY3upUEJ1hIqJ5xJtUFM/aGF8KOjkfHOErSi/Gof6Na52Fj20LTA1zeUpE58azh79eZ9IgQ2TLNLqZd7F9JhX7EjN2YBFFO8uGePsxUt/cd9PZbTBVoKaXxIt8DNMho8iniw83ga6fYAFFaWtVFvMRrYTape9fGa2jY5HmprwLBDmIQC6rTEHTTi+9fTCuj7ehX6pkUJHn/V/h4CUetudk+Y85NRiXZ+Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(7416014)(82310400026)(1800799024)(376014)(23010399003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NPnFFjPRrDm8MNKUJtVynzzd56j521OyMBs0bw4+oQ2cydn6rWY6RX44lm2bXHAkGs7rwh2BfyeQhXJNHf2sIW8YVGRvxVxB2Ol/vpuyqqe4jc/5WHBhBBz/nHFHpky27XvIjO3bQUb2d9f48wJzmLNIh55FIbIL2LVA4gybbCAEZd26y+1LeLws4DuYu71jVW72edKFczq7ehU0RW5jNfiGZ6Qfv9sSWKN039uGjShUQZ+D/Zk6GbrXdplCXJ69BDJqOaQxQ2rBbofQYQaAg3mxNH3ojZCKfBRK30KGT6xIAM0Wdi+mO7/fDUR3xKEqAbG37c4bBdK6ljAVqdpEazyH1DlZtyN2ahQUMp4+DMejuU4OI3m7CvaePKBSomyc9FzuAd195QnKu6R4oRtepIDk5z/F3gmRBtEPCpRe4RHfBSyqWPAfNV2VrrSqZGtQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:02:47.4924
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd170de0-974c-4a9d-9d61-08df0f5d56f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD79.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6149

From: Dan Williams <djbw@kernel.org>

Now that the firmware loader properly ceases all operations at
firmware_upload_unregister() and no longer takes module references, clean
up the unused parameter.

Cc: Chao Gao <chao.gao@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Russ Weight <russ.weight@linux.dev>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Dan Williams <djbw@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
[chao.gao@intel.com: drop leftover fw_upload_priv->module assignment
 and the unused @module field from struct fw_upload_priv]
[prsampat@amd.com: convert the tdx-host caller added since the original
 posting]
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 Documentation/driver-api/firmware/fw_upload.rst |  2 +-
 drivers/base/firmware_loader/sysfs_upload.c     | 10 ++++------
 drivers/base/firmware_loader/sysfs_upload.h     |  1 -
 drivers/cxl/core/memdev.c                       |  4 ++--
 drivers/firmware/microchip/mpfs-auto-update.c   |  2 +-
 drivers/fpga/intel-m10-bmc-sec-update.c         |  4 ++--
 drivers/greybus/gb-beagleplay.c                 |  2 +-
 drivers/media/i2c/thp7312.c                     |  2 +-
 drivers/net/pse-pd/pd692x0.c                    |  4 ++--
 drivers/virt/coco/tdx-host/tdx-host.c           |  4 ++--
 include/linux/firmware.h                        | 15 +++++++--------
 lib/test_firmware.c                             |  3 +--
 12 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/Documentation/driver-api/firmware/fw_upload.rst b/Documentation/driver-api/firmware/fw_upload.rst
index edf1d0c5e7c3..702b1ed77551 100644
--- a/Documentation/driver-api/firmware/fw_upload.rst
+++ b/Documentation/driver-api/firmware/fw_upload.rst
@@ -57,7 +57,7 @@ function calls firmware_upload_unregister() such as::
 		len = (truncate) ? truncate - fw_name : strlen(fw_name);
 		sec->fw_name = kmemdup_nul(fw_name, len, GFP_KERNEL);
 
-		fwl = firmware_upload_register(THIS_MODULE, sec->dev, sec->fw_name,
+		fwl = firmware_upload_register(sec->dev, sec->fw_name,
 					       &m10bmc_ops, sec);
 		if (IS_ERR(fwl)) {
 			dev_err(sec->dev, "Firmware Upload driver failed to start\n");
diff --git a/drivers/base/firmware_loader/sysfs_upload.c b/drivers/base/firmware_loader/sysfs_upload.c
index 890a242a7c20..920c4b640f96 100644
--- a/drivers/base/firmware_loader/sysfs_upload.c
+++ b/drivers/base/firmware_loader/sysfs_upload.c
@@ -273,7 +273,6 @@ void fw_upload_free(struct fw_sysfs *fw_sysfs)
 
 /**
  * firmware_upload_register() - register for the firmware upload sysfs API
- * @module: kernel module of this device
  * @parent: parent device instantiating firmware upload
  * @name: firmware name to be associated with this device
  * @ops: pointer to structure of firmware upload ops
@@ -285,10 +284,10 @@ void fw_upload_free(struct fw_sysfs *fw_sysfs)
  *	Return: struct fw_upload pointer or ERR_PTR()
  *
  **/
-struct fw_upload *
-firmware_upload_register(struct module *module, struct device *parent,
-			 const char *name, const struct fw_upload_ops *ops,
-			 void *dd_handle)
+struct fw_upload *firmware_upload_register(struct device *parent,
+					   const char *name,
+					   const struct fw_upload_ops *ops,
+					   void *dd_handle)
 {
 	u32 opt_flags = FW_OPT_NOCACHE;
 	struct fw_upload *fw_upload;
@@ -320,7 +319,6 @@ firmware_upload_register(struct module *module, struct device *parent,
 	fw_upload_priv->fw_upload = fw_upload;
 	fw_upload_priv->ops = ops;
 	mutex_init(&fw_upload_priv->lock);
-	fw_upload_priv->module = module;
 	fw_upload_priv->name = name;
 	fw_upload_priv->err_code = 0;
 	fw_upload_priv->progress = FW_UPLOAD_PROG_IDLE;
diff --git a/drivers/base/firmware_loader/sysfs_upload.h b/drivers/base/firmware_loader/sysfs_upload.h
index 31931ff7808a..dc7ccdceb96f 100644
--- a/drivers/base/firmware_loader/sysfs_upload.h
+++ b/drivers/base/firmware_loader/sysfs_upload.h
@@ -26,7 +26,6 @@ enum fw_upload_prog {
 
 struct fw_upload_priv {
 	struct fw_upload *fw_upload;
-	struct module *module;
 	const char *name;
 	const struct fw_upload_ops *ops;
 	struct mutex lock;		  /* protect data structure contents */
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index b3419df586b9..ee7a97b8b2c8 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -1151,8 +1151,8 @@ int devm_cxl_setup_fw_upload(struct device *host, struct cxl_memdev_state *mds)
 	if (!test_bit(CXL_MEM_COMMAND_ID_GET_FW_INFO, cxl_mbox->enabled_cmds))
 		return 0;
 
-	fwl = firmware_upload_register(THIS_MODULE, dev, dev_name(dev),
-				       &cxl_memdev_fw_ops, mds);
+	fwl = firmware_upload_register(dev, dev_name(dev), &cxl_memdev_fw_ops,
+				       mds);
 	if (IS_ERR(fwl))
 		return PTR_ERR(fwl);
 	return devm_add_action_or_reset(host, cxl_remove_fw_upload, fwl);
diff --git a/drivers/firmware/microchip/mpfs-auto-update.c b/drivers/firmware/microchip/mpfs-auto-update.c
index 1211fd8d0463..992088606204 100644
--- a/drivers/firmware/microchip/mpfs-auto-update.c
+++ b/drivers/firmware/microchip/mpfs-auto-update.c
@@ -437,7 +437,7 @@ static int mpfs_auto_update_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret,
 				     "The current bitstream does not support auto-update\n");
 
-	fw_uploader = firmware_upload_register(THIS_MODULE, dev, "mpfs-auto-update",
+	fw_uploader = firmware_upload_register(dev, "mpfs-auto-update",
 					       &mpfs_auto_update_ops, priv);
 	if (IS_ERR(fw_uploader))
 		return dev_err_probe(dev, PTR_ERR(fw_uploader),
diff --git a/drivers/fpga/intel-m10-bmc-sec-update.c b/drivers/fpga/intel-m10-bmc-sec-update.c
index 7d23d914df3f..3d318570faba 100644
--- a/drivers/fpga/intel-m10-bmc-sec-update.c
+++ b/drivers/fpga/intel-m10-bmc-sec-update.c
@@ -712,8 +712,8 @@ static int m10bmc_sec_probe(struct platform_device *pdev)
 		goto fw_name_fail;
 	}
 
-	fwl = firmware_upload_register(THIS_MODULE, sec->dev, sec->fw_name,
-				       &m10bmc_ops, sec);
+	fwl = firmware_upload_register(sec->dev, sec->fw_name, &m10bmc_ops,
+				       sec);
 	if (IS_ERR(fwl)) {
 		dev_err(sec->dev, "Firmware Upload driver failed to start\n");
 		ret = PTR_ERR(fwl);
diff --git a/drivers/greybus/gb-beagleplay.c b/drivers/greybus/gb-beagleplay.c
index 244966d56c9b..a097a3b10552 100644
--- a/drivers/greybus/gb-beagleplay.c
+++ b/drivers/greybus/gb-beagleplay.c
@@ -1172,7 +1172,7 @@ static int gb_fw_init(struct gb_beagleplay *bg)
 		return PTR_ERR(desc);
 	bg->rst_gpio = desc;
 
-	fwl = firmware_upload_register(THIS_MODULE, &bg->sd->dev, "cc1352p7",
+	fwl = firmware_upload_register(&bg->sd->dev, "cc1352p7",
 				       &cc1352_bootloader_ops, bg);
 	if (IS_ERR(fwl))
 		return PTR_ERR(fwl);
diff --git a/drivers/media/i2c/thp7312.c b/drivers/media/i2c/thp7312.c
index 775cfba188d8..ebbe14393c9f 100644
--- a/drivers/media/i2c/thp7312.c
+++ b/drivers/media/i2c/thp7312.c
@@ -1909,7 +1909,7 @@ static int thp7312_register_flash_mode(struct thp7312_device *thp7312)
 		goto error;
 	}
 
-	fwl = firmware_upload_register(THIS_MODULE, dev, "thp7312-firmware",
+	fwl = firmware_upload_register(dev, "thp7312-firmware",
 				       &thp7312_fw_upload_ops, thp7312);
 	if (IS_ERR(fwl)) {
 		ret = PTR_ERR(fwl);
diff --git a/drivers/net/pse-pd/pd692x0.c b/drivers/net/pse-pd/pd692x0.c
index 209de9cec849..5bb91a0f4438 100644
--- a/drivers/net/pse-pd/pd692x0.c
+++ b/drivers/net/pse-pd/pd692x0.c
@@ -1841,8 +1841,8 @@ static int pd692x0_i2c_probe(struct i2c_client *client)
 		return dev_err_probe(dev, ret,
 				     "failed to register PSE controller\n");
 
-	fwl = firmware_upload_register(THIS_MODULE, dev, dev_name(dev),
-				       &pd692x0_fw_ops, priv);
+	fwl = firmware_upload_register(dev, dev_name(dev), &pd692x0_fw_ops,
+				       priv);
 	if (IS_ERR(fwl))
 		return dev_err_probe(dev, PTR_ERR(fwl),
 				     "failed to register to the Firmware Upload API\n");
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index e8ed8dfa526e..f11a545d40cf 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -194,8 +194,8 @@ static int seamldr_init(struct device *dev)
 	if (!supports_runtime_update())
 		return 0;
 
-	tdx_fwl = firmware_upload_register(THIS_MODULE, dev, "tdx_module",
-					   &tdx_fw_ops, NULL);
+	tdx_fwl = firmware_upload_register(dev, "tdx_module", &tdx_fw_ops,
+					   NULL);
 	if (IS_ERR(tdx_fwl))
 		return PTR_ERR(tdx_fwl);
 
diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index 0fa3b027f02f..aa0333095c10 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -197,20 +197,19 @@ static inline int request_partial_firmware_into_buf
 
 #ifdef CONFIG_FW_UPLOAD
 
-struct fw_upload *
-firmware_upload_register(struct module *module, struct device *parent,
-			 const char *name, const struct fw_upload_ops *ops,
-			 void *dd_handle);
+struct fw_upload *firmware_upload_register(struct device *parent,
+					   const char *name,
+					   const struct fw_upload_ops *ops,
+					   void *dd_handle);
 void firmware_upload_unregister(struct fw_upload *fw_upload);
 
 #else
 
 static inline struct fw_upload *
-firmware_upload_register(struct module *module, struct device *parent,
-			 const char *name, const struct fw_upload_ops *ops,
-			 void *dd_handle)
+firmware_upload_register(struct device *parent, const char *name,
+			 const struct fw_upload_ops *ops, void *dd_handle)
 {
-		return ERR_PTR(-EINVAL);
+	return ERR_PTR(-EINVAL);
 }
 
 static inline void firmware_upload_unregister(struct fw_upload *fw_upload)
diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 7459bba65444..a77a99404fd3 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -1322,8 +1322,7 @@ static ssize_t upload_register_store(struct device *dev,
 		goto free_tst;
 	}
 
-	fwl = firmware_upload_register(THIS_MODULE, dev, tst->name,
-				       &upload_test_ops, tst);
+	fwl = firmware_upload_register(dev, tst->name, &upload_test_ops, tst);
 	if (IS_ERR(fwl)) {
 		ret = PTR_ERR(fwl);
 		goto free_buf;
-- 
2.43.0

