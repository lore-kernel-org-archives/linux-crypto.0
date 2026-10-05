Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010002.outbound.protection.outlook.com [52.101.46.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4214CC62E;
	Mon,  5 Oct 2026 16:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791216999; cv=fail; b=ggMo7j5O+oRW7X08L/hfHgiLKWubI2av0Mjf+EEmm0cVP3rUSUbGsIbVdx6aaO5H2XGN/yOcV5zRQvYbIDZYUQgEu9o3PcOT5j0mjToFCBiAIFhhJUFO4Ku6MDFZgKLTfcKU3H2mrHWuyANSKdI2TXNQBilwNlE7z6nXlaQSsWs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791216999; c=relaxed/simple;
	bh=ZGtXSeAJZz/yOI1vr+67nkw+LNuTcLgWxze/8OmOf3c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gFQDwubkhM8fufrXsyRkHRb4pxRcRMsXQdGkAFUbQ3wgd3FoR3ntM2dB2gYF2L2eaktE8+VkSh3xGFeUPrZSSgYyBh6M+mCxZFPLjO+e+dC4Lr5OpUk5Mn6aHLfXHx8R09aogUt7PG4fa922oUp8ny0bkvGTYE9w2DBCK7h+q+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y6hdgJmi; arc=fail smtp.client-ip=52.101.46.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y6hdgJmi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GoA2fexG6S1UUhPFGI3lgq1xXhfC5DLYBx4A7cq8ivJ1jUdceXNiIwAT3ziTFoDo2tsWkrml+Df/f420AfITW+Y8+x39/p3Cbf2R4ngHuOJj71WbHENcBzov9hGBYj7h71muK4C05VZve1mx0g7xioIJpmBP9V5JWkYk651abTKvzd3GTt3RUqaUPmhDTGe9Ptj3xBfnmHHvFIqiuq2NfR7kuuzsEZ9IhaquEKSe3p3r/Q60zSz91511N6ZxcTnAAevLP5Vr8w18VGkdA4O9YAkrcIqBnof1mWYphL5S+H3Nyo0rV/DcY0qTUVwX2IpTf8JGBQfORww/z3ejxquU8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/BoV4hqRgwNw7odkh4jDkqTT6DGoZwDLnGcrR92Qn4=;
 b=vm8j+w3hafNbxN0r/GTDoQnABBqk7FhVPDsDp/IYIP3aRXfDKLKShcoFoYn1KxuXD5pe8ubIClLhP+hqYLA2pOfbnPFngJwUSHN7URPbv6bvZyzy+CLiQakKHNMM6GVxrrBinmppr4V3M7EyEclsV8FulXcTThYSvir9T5tw+oVZ1xG2SZzOfy1nSSTzKd3S9E0lK2QE3MS/K/S6pvASnnD3T0JE5oZYUZ+ciIEFmy4nfCZDZM7GNF1ABAsXt1AKkqf1W89EpO5lmIxpaqTmAb07AyyTdERLes9ppCbloAQXUbCKJ3S9KGKScd0bWNG2NVZ+bB6jqfm5SuUMTr5biQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/BoV4hqRgwNw7odkh4jDkqTT6DGoZwDLnGcrR92Qn4=;
 b=y6hdgJmiScbhagf7ikDmj5FVX4abJSdvtzYNpjMt+7gd2+32fzR2pRoqqWzBiaULaHjm4E/35e85YiLw2r08o1XUXSeBcOvGpl5yy3yP2Cics8+5p/j1TVhVLj3Clg7H+hw7L/2nKrs5Flr5OVBiQlG+zSy2JiLJi3GJ7sJ1xr0=
Received: from CH2PR19CA0010.namprd19.prod.outlook.com (2603:10b6:610:4d::20)
 by SA1PR12MB8945.namprd12.prod.outlook.com (2603:10b6:806:375::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 16:16:31 +0000
Received: from BN2PEPF00004FC1.namprd04.prod.outlook.com
 (2603:10b6:610:4d:cafe::74) by CH2PR19CA0010.outlook.office365.com
 (2603:10b6:610:4d::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 16:16:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FC1.mail.protection.outlook.com (10.167.243.187) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 5 Oct 2026 16:16:31 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 11:16:29 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v3 3/7] treewide: firmware_loader: Drop the unused @module argument
Date: Mon, 5 Oct 2026 16:15:37 +0000
Message-ID: <47426dca2cf1fa63495deb21337f16a33157387d.1791212077.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791212077.git.prsampat@amd.com>
References: <cover.1791212077.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FC1:EE_|SA1PR12MB8945:EE_
X-MS-Office365-Filtering-Correlation-Id: 75168ad4-90b5-4158-6f94-08df22fc0462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|7416014|82310400026|376014|23010399003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	r9kn3L2srBoVUXkf1E4fsMpNYRPTTMGEd1EB1pPTGIvrJwtTHuVN3dq4lol6OwQGNoRYET70ZMYPQAhnnso9EHWqAGf4001BPPWtx3PFrN1T3NwqRIddsYtmT40vL4zK03UZ4AKBk/TP86+JE7NfOYx6PN1EYj2YpWzJGKuz7o/aV5Bvl7MCkg+gQ3q7Hl+Nptg9mNgY/55dt9t3HoomVRPLtdkt0MdtiwVzmvCyDDfTtXsiJZ0tutx6zxEZeII1ZA9AtwlwI8M1SML6GcObuONwJgwLQt07j5k8lbR3Q2Eg0hL6R7PL3YqzeTV7zdStNJSy/mLIt7nozDUIbcGK+c7mvTqq/QiftvVS4BqihvDPw1uksRajroKesRCYlu3lvkGHztOyYS852O1jNUqXosK7Hb5ydozMuSS9+JSeGIQ1XcHuqd19jMpKHufk1EEJBwiJmTz2Dcneo8fCSVuGNf7FR0pmP9LajPrTLy3YuwpE2TVoebZnP7epFeFW4as/krOJDY6vAJkMtiZEe0JpernaReJxKj9KDRDPvhxxBhLKsjuYU6aNXt8eT1hP5OINYC2LifZCYUaly6wOsPlTGP4bQpHu+dYJGZxgKsJBTbPqG6gVhv7jlSTo+1BUS84UL9lLYrmWFfH7uIRMD8D/PzJSaultvJ3XtFrHawaxTULrFg6hOA0LzXp1VwUnQHg1DwV6Xo2wHu0k8rZivx0thQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(7416014)(82310400026)(376014)(23010399003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fYzGkHg/eE+fq4td0vNVtyHQxNCOK1V3NTyVqudUOSnxzfp2jHUYoo7cJ3lYBiTV9LNWLM6O3MBeSb6aluwVrXlJ2AOvEhOZH0VnMWS+/RHI1ysJGEl6LDanGKrE224oQEbNABKh+Ft1bJ0nFU4hX9V1VD5gZa/+VQHQpemaCOG2V9SHs0SfRwvVczZNQLMk2/uM398PhPwEslLI1kCSAWf1+J9iWUQsT66xaQN/ndvujbMmo94SH0TOZ0rTbTwnflSOyVlj6HQ/LtZgDOozlwngRN3WcuKc3xkyy798nitz/1G7aYUxCxxmSmuEzm4QyfK1O2lvX4BpDONfHz3Be+4naEowMQSV21rB+PlTH014pLD2B5kME/ZRZgj8q641IqouKPeIEplRJJCt7TTbqoVuj7WTjvjeEY8fWTd87V+GrrD4FpKLDg7Ba1a2DqjF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 16:16:31.0129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75168ad4-90b5-4158-6f94-08df22fc0462
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FC1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8945

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

