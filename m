Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792602376;
	b=Ky4Hs0c3V4CTx+rfRnzPkICd5HGljidzBYoU78CWS5uFYLcEldBYO75lINq5Zj4+pbXs
	 ybKHokctMjGfSx5S3A502jGnGG3RcWQNjwBbAM1gmWA4dxnj7wHx69aa5O/2d+p2G8nK0
	 DnkX7TdS7C9hZIumSu39a4HM8jLrL/gBNg9P0erBDRGkwjNuxKK1gbyzNhwzyHIGGBTQq
	 409S/C1qn4xnn5UgZimxYoWLHSSfopVJXEUD/KjQ39erKzpWVJ3VCEaw055JfdKcYFwaj
	 QwnzPxUHl034zqV7ifx73EMY0sFWpczk02hp+7uPRZMdeZQfqKsCDnGtmvGbxig25LA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602376;
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
	bh=4iDEO3ccnICAlLsBKW+9bx0XbQrYxwjq5Rn5eGZUmdo=;
	b=A2W6/6BHEpzfR5QLtzIpkA3/HU9oL4odb8C4CGfFQJzc8WMTgLTNngbgQ7x034OpHVIo
	 fsN9oFUBOHKjFqbQUJvFH6o1vkZLTaeC5JKZLd0fY2JYbVXJnrrhKTT0D5ZCevRqcsEx/
	 QLgmPOeP1c0GJwYszBQ4LajuRAvM5pTl/ny1TJpdFaIqRJzqEGspw1qzLJbOkOM/Y+tYM
	 HQjo+uGFHunxrXVj41Z4qnP5fKMtrH3phrMMjT+yYekMGoL1ESFqyisS5mcdkyu4Ji+03
	 ek+t+YheKec3Em6ElZ3T8CZHfYrCEV3Pq+ShxkNs/fy9xvycifAynsNIX1Lrr666aXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=nKACMy7l;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.70
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C994606A319;
	Wed, 21 Oct 2026 17:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C994606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=nKACMy7l
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v+E9CpteB7TMA5kzRXspucr6OiTP3nL53nWXhevaRKvmzOa32e1jWkKUEOwI+61dasXKQHX2Oj3Wk2MNNupUeNBhy4KlvFJEmYuluEDZULiy8Fefls9DYDczOM8x2pNPmuILsTY/NQs+2cXlHJIByzlzWPUkzKhgcbkSGrpEcZaW+WiNb9hPVfpdClu6GH2nZODO6iRFfv5DR7vaXHPeJVH2AxlWAxcNmxH8l5ScKdQi8SqmUJjSRdE+cQInhODDbB44XNIeXemgh+5m1EqlT131So4KMR2WcEMkesHphvNkD0KiQrzdzZWHbCJitiHtm5riLccl0yX/pA8cpwO/RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iDEO3ccnICAlLsBKW+9bx0XbQrYxwjq5Rn5eGZUmdo=;
 b=smOra4WIOm72lkINExByuxSjoVlpG1vFs+iwCWX1a63uTOPSoPBB3fMdGTYuIaZ4H72kTHAJOdfH74zstrBiXGPauyQr/7mqqRXtIvHNbI5svnKPPd/vWKp+31Je4MI6PHfhqW8aAe0MVitQQU5LmQGal7DewbdA+Rcu96/qT+xX5nFXX9deixZYQ39yLVvBga3fGMprj1Tp2ThEWObSunf1LVnZk1LkVuiiplLt8U5pWwLlmuJhocOIfO1QeG2RIBXmkva9Xv4ih6JMbzozQUsA43Gj2vGdZE5lK/tCt284R64JrGFEiLb/hmVOVTyVFF2+YdTwfAqSlebPD2ZPrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iDEO3ccnICAlLsBKW+9bx0XbQrYxwjq5Rn5eGZUmdo=;
 b=nKACMy7l/aGsXv8fwCFjA+yntODqSk5xbirxnH+L/LUKVRTAkxcPxfn5Q+RS/8AfTX0WIcsNKCY4BnbF4OqO1o1OnvAhFTqzj5rEqP5x0iHHyMy9D2qRDNcyOWDMFEsOHSuGdKjnZ43axWmMON8rtpnQ7sP2G7rab+aTlUEa7bo=
Received: from DS7P220CA0027.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:223::19) by
 LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.19; Wed, 21 Oct 2026 17:06:05 +0000
Received: from CH01EPF000BE94B.namprd02.prod.outlook.com
 (2603:10b6:8:223:cafe::5d) by DS7P220CA0027.outlook.office365.com
 (2603:10b6:8:223::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.15 via Frontend Transport; Wed,
 21 Oct 2026 17:06:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94B.mail.protection.outlook.com (10.167.244.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 17:06:05 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 12:06:04 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v5 3/7] treewide: firmware_loader: Drop the unused @module argument
Date: Wed, 21 Oct 2026 17:04:59 +0000
Message-ID: <755fac2174e85a5973b9b3d6b57d96b85b4b342b.1792599491.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94B:EE_|LV2PR12MB5727:EE_
X-MS-Office365-Filtering-Correlation-Id: fd751010-de9e-4359-44cc-08df2f9597b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|376014|7416014|30052699003|1800799024|23010399003|22082099003|18002099003|10067099003|261021123027099003|11063799006|261009223027099003|261009221227099003|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Qq5UabWBZWfPa2PdO1Pw/ld8jLMghNw0grDRtXJ1vUrOVMTJkMpEX02Go9IykDv+0uQvuVpIOkFbm6n4JMuof1+kzc3O1Jofclcgcu5pbjuzGGgAo5Zgu0zB30bwAmbxkFp3m8tjVyWwXCgsY9c2CEwfUJbqN+gZbH9FQSm5JyqPguN7p7hbCvdd+ZrjpShrxHm/txFw1b8F4xmUwC3AM41c+VJLir9M7HXNfLktDT32EcLRM7Gs3LEe0FJxjJpvlh6PrM64vKARsPNpVoyrqGCNEkzeflzTUd/XoAyHRE1kgfa3R/hyNKu4nofvCG60NFnhUNhxq7Ecw/kp0YABZESKPZhan/TSmowGi83+o83ppeULyE2dbm7u4OZFX0oA/ejD3J58lPkdybOnBlUTMzvlehmo05o+vgGfUP9FoZNlP47RRE7qbr41ZA6GfvMFyjqDEeM82FclWQkfuGTyv4dbw7LGF1DB1yhIiv/3PYQIc5IfaycvNCUcgMqX7kFMvmWQUP+tawus4/C+bdYGQL5r3E6YeL22sn0SPW3Ju71wtAXOz3KUie8z6OGchhp4i1J2sFb33ZYL8rDR8tAxlqa2jE/fBbBAduTcOEqf1XKPlQwUnX9CUeG9c/ztZf82Y9kW8zwh2w4a2xiUF9GZEAlRdWEQAvdSLhs9W53o7AlJRlLeOoNMbADqzldQNS61LzQcFH6nJXFGnLhJQQ5O3Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(376014)(7416014)(30052699003)(1800799024)(23010399003)(22082099003)(18002099003)(10067099003)(261021123027099003)(11063799006)(261009223027099003)(261009221227099003)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	bQi51zyV/kTnp16jh8OpyIpuilcXESdlzsk9ZGkN+ma60Dii4+AFdhsQqOTyTcSxZXVoNi0dctCX0gYMRFtTKNxZ1Pmp3CPdoPCVXL8wc5KVEep6rfG4b1vAQWLu8EVce/iPqz7Sh0pHcgvarbQvpCtvUT1JTX0RyA6cJ6+kP+qMzHT2thcoHUaGRd6W31QK0mszgfGmGD7rD7v8iAvkvpWLTxIJFOEZhPw0Prv98v5dzYZQhZjL3th+Ogc3aJTCjSkrs33dyVoJEkveYCJ17SKa8DGQ+di/YbX7QGc+DSwAp94oYrq6tef2RT9ezZHvcWZdE6W8EZsZXGnjZzfOCN1yPWDhN0KIjWivBH+p/glc0xXZCHrP9i1fq+qU8/0/FgjIhafzzBuUna+Mu5PGEtQ6GBsFNUJkWwrPtZ4vqYlVEjyOrPNjGcSX/BZAHoLA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 17:06:05.1271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fd751010-de9e-4359-44cc-08df2f9597b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5727

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
v4..v5:
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

