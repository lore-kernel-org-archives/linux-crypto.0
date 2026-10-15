Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012033.outbound.protection.outlook.com [40.107.200.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DA63B8921;
	Thu, 15 Oct 2026 02:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030512; cv=fail; b=hN9v//1c9+bh5oISlJ/99P4t1bp9z0nV4mxmPcCTd/RAWAUvGB6sXWsfZOewN7W7X6QGuDg0CdAlhF3YncPA1J9qFvEg5o4gA1QtWMJht+qN/YX071NNeZpUokgsupCJV9S2CLB4mGoNEi1owUbNj7HlNFdbC9NKdhMQdcpMfcg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030512; c=relaxed/simple;
	bh=iEYeuBsVv/B/bJtQzTRSdW9aiucsB6dpxXgw2XJtpro=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2CnZLmK+BZIPdW+h3DVP3LbRXsw1VlIE42e8ubhIiZkHcWrbFcC5G8J/w3Kz0ilvbRqikLYl1AtQKbiaozEGXWjX9yW9LbKdz/oeprt5Sh8ODQH6rwS0xZMIFSHBGuz5H4LpWriBoXO16DLMn7JA4woLB7YR2xfArM98/oU1Vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y8JIUqcW; arc=fail smtp.client-ip=40.107.200.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y8JIUqcW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hkEeAK0u1RbBEoAtsLLpTIE9z2k0RfNZzBSyog87gfBvkSxiDtheM8/4GPVj2TiTYjmyhGdFXdHWW0fGuGzbY0iT37WDKfVhvdPlNcnoPveq7BtHN+xyQYn5fE66RFQCmY1Qp9YirFbg7vu+g8wW0ocv/9Q9E/Sz5MASAiKjnjaJH7WLKL8rbh25j9/EgzeTa7azT6GOdAfhKWb3kgae6ebMnhtBrZMBQHXOQWtwReBjhpkoskY+63sEI+J8f4hswgnJSlCyU1isGqC6lZU3JRhOd6dh0GpgG4Z2hyCNvPGm0TF+u0B5+R2gwOrHVUYO2p5Z2Tox2Zag8ihVHuKI6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYwA+Cy6n5h3FsVGJHEYh3nmA3T5IQwARu5rf+XPgHk=;
 b=lWDU3DVDeib+zrT5h5k5juciVLv5s7t4AvFxIXpUxC1IiFwd1FdSeKmRlxapedy3YdP7JMeeVVOP2tedRvYkrmRg+tvVvR/fi0Kvokc7PkZE3lAx8rWk8PHcP5m7WGqjm4uMmEVOYrReQVkUsqRxg0iO6wxEfe+0Gbhsbj1jXpyjEw7M9dfBeTrq3k1gMCW4YUpJCO1LAyUYVDKm8jdcmB5Wwi7MsWMRLw68BfS49XGBtpWVK6USaUTcAbmjnN6f4J7N+VjglzmL2NrNcPYEdg2alHFg6ugOF7aRIU8Ov+mabRRq5SkzmgKSVrkH3yB+eTmLKWaFbIVCKYn3QpNhWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYwA+Cy6n5h3FsVGJHEYh3nmA3T5IQwARu5rf+XPgHk=;
 b=y8JIUqcWb9L8+Mn1+CEDKrWfJI7fQVlf9sUDhgjos7HWWjUv7Oq6Ykz1z3DpzdQmrIupbH2jh6nMzchTMQrAyqlkkJtFEcrE2gWWC3UqvuF2m0pGvATsSLJl5G7zO7VwnTj+dmm5Ua7Xx4UdQhclNe0tv335Bxt5tShMF2a4mKE=
Received: from BN9PR03CA0888.namprd03.prod.outlook.com (2603:10b6:408:13c::23)
 by LV1PR12MB123218.namprd12.prod.outlook.com (2603:10b6:408:516::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 02:15:04 +0000
Received: from LV8PEPF00000065.namprd03.prod.outlook.com
 (2603:10b6:408:13c:cafe::73) by BN9PR03CA0888.outlook.office365.com
 (2603:10b6:408:13c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Thu, 15
 Oct 2026 02:15:04 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 LV8PEPF00000065.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 02:15:04 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 21:14:57 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v4 3/7] treewide: firmware_loader: Drop the unused @module argument
Date: Thu, 15 Oct 2026 02:14:05 +0000
Message-ID: <0d1f99f4dc0f7d3f9364bb3416fbf15c2002da17.1792014060.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000065:EE_|LV1PR12MB123218:EE_
X-MS-Office365-Filtering-Correlation-Id: f8eded9d-c7da-4db7-3448-08df2a62203a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|376014|36860700016|1800799024|30052699003|7416014|10067099003|18002099003|22082099003|11063799006|261009223027099003|261009221227099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	wUxbA0AXNdWmMDRwArMZe+9I0YgukjReN5aUn9IIQuj+/0UaoYfVJs4xj+MHslIxC/NtUMI1lEycxeZcKOTJpkShvOIfhPNZX5XyYVypqE3l7xtkiBnwi98rpowz3HrPXKhmbm9beJWQiTWWuWaQLnqU3HaoAaVnAen8VhzoQ33HFdmSnfKxAcZU8LwsfPVX8QWYFc9XRX0XxNmkHAKJV+7lNBTXXRzx7fQiWerDE/kXAcF2O6b8ayX6xn2C1Bw03moI87EBJuKV5HwY1zfwBc50xJXXJdMwZBLQlbsM9iJcdLWiEYkj60kvEXF9eGGTh8kbL0DZRs++hkByD0UcS+WrCgP4EbUQwVIjNGvBsh54+j1I2BlTmiTCVTuL/3AC9U5GDO/H0WhbENKafOSQerx1uCXjzJ/tnKzyKxzRuNvUP7Hxrhkrw92g45dfuKh7ZoWbyKF/ZZr0oBSxeoF7bcyCBw+vXQQQwdkFLho/cCI2YzxiW1NwhoT+N7Zn+TCvwhERUzAmWa6xCMRyafv0401YSxaZXPDoImfdKKdZ8rUtqwboSpdSS/cQ8iBJ6vxv/iKUaAjYxCD7EwTKE9rbc7Un0ilrGqSOrPHmIhqKpN8brXuSLMJpVubgp0FbrQ2GnX+8ajQe5FtS6fuHWTPieGJucrfDP5VQ3L6tIe0hM9OWEMsHzufV72ghHiz0SAS9Owje5yKjJNah0NMR5Y9L2g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(376014)(36860700016)(1800799024)(30052699003)(7416014)(10067099003)(18002099003)(22082099003)(11063799006)(261009223027099003)(261009221227099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EWVJO/Ieb2uIXbJFDAq0Bpts83fxcIs1EXbhq9dib8cFC+krStnL9iqWN46npYy04Q8g1DCy/5Q/ffXPmWGzQkQK5jIpzjAqtFAL/FatrFtVbR/ggizkV/79yvshtF4IqawNOearIHsoel7aCE+MsTNIJ0Wsnn+nMcjaB/2Pp68XwKHUgPZchwfIUJcJjMo0Y0RPFzyJzMU1mkZZGROLwcRmelQT1OCTL8vJ9Uf8vIwJ8/A/W5ipPNQtxpUhBgqoWP3TbGKsn3IAT+K6zfHLUewBIYhcBFnefzNMwRgqfkgoffn1uV5Mpt+ba8FRPGE4icrlKqvqAdKrepEbM/pHJhkyhAz6hcI45oLUIqy8FDBEcrMUoKo5ooBYnZokUWOPaqI/NEf0LjZBgxv3QX/w6BpxXKp2FzYrdFULvpl6BUqpcP8GEHx71LRpnjIFVKTJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:15:04.5345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8eded9d-c7da-4db7-3448-08df2a62203a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000065.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB123218

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
v3..v4:
No change
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

