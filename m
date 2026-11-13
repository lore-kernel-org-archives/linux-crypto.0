Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794595628;
	b=2tfWJWLR00yexDnucF4DJCrG3G6K54gpAKkBbZdtsPBQsdPycv5m7CP7GR/giK2pKNFW
	 LjWAL05ck7NoEKvH34e4sAnppBoN/qEQ3JrQ6KfO440n2yxshRXtTgtDWydguzL+5vloO
	 iOCWPXRzN+5FVULUOYBCsebVxkn1fnf99yakzdSc8kkIGCNzaTDIBjn0gXQX3MD9SB0Wn
	 dXK3/Vuqkcm2yfyYGTUJ2Tj3YK4AdzTCLOBoRwjPalUw3f1gMFbTt8sxdmRDpvcfL4RNS
	 vGq+sf3hZREDnvHOv7ko73Pn4yFHPck7PUkEflPS5EXLHkQaNR2Qjf2L5Qed91Enb3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794595628;
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
	bh=SxpfgybzjMReROkk+NQGaLgonOL/4zdwa/2ySoTnmO8=;
	b=NCeh324phRt3JCgFD4k5/zfmOydZ15zSc+jslhrIMPcEWDlv/A+rbRuOafqTxyobXfWN
	 c4xyFjJK13h0O8Cd0EhFXxCnV6USkuWIlH2wijlkouVeY8zxog+UaWsFikj3+AHveXXuD
	 Wa7ol0a4Cfgaq1GxoVyNAiwLQvznp9SFtolruRzVeUbAf6onTogSwVTmIUSnTLxVAoiVi
	 Lcq1KFLWbMy69tNF/4wXdyPwoRqcDrrV8J6Z26biNLx3Z94GwVR3oRfxzPeqY2NYVHvka
	 P9vaHdD58yggFWBGlNikdkfj2tUtHKa86U60/eXGjPDvCq/3Mj/y8pOw/SIB4srowjw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ivUxA7Lj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.70
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011070.outbound.protection.outlook.com [52.101.57.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A564606A331;
	Fri, 13 Nov 2026 18:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A564606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ivUxA7Lj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wprOkIsPnpQyuq+MpujBaDvHL3qzF/gEXmGEX9FXWYiF0I9kyglQkxkAoL7kk+hK/JXE2GSTjmpkX1d1PEm+v6qzfnwPTzOcg6YOOoE6PAGt0YSfb2mXrSJvVVE+D2YBCJE9oPYOimuZpgcYkeAlkJ285RsujM2LjM9eNZMhaiJOixXiBMy/1h3m9zCsdJIfL1hIfrjs/ae7g4SNLoFUSSr6EdjP+XTdc+Qa8Ijdj0xLkH+0I67CsParoqpqBt+fLOOwraLrWyfucR4la2YWhXOELP92j9mrKNU4snWxmA4L4Msq0UhV9awVA6fEx4y8eMLvjEkW+QDcbV+HpKkcOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxpfgybzjMReROkk+NQGaLgonOL/4zdwa/2ySoTnmO8=;
 b=CoB734igU3sqYsjcc+MebEXv2kwz0AZTId+SWLLPiTxyU5AI+3SAqXYfmoSydahxerOgmYhFgZjpot9rIawVJZTS6Xt3cHA9uVWofQMRgWoqxmXgCJMINxYdPo9NedNxwtIEBycs+Bgt4TKuZAQ9QjjS6n+bzcEGh7LRoCJlG0g0o6GDpA/8hvANFNcFiuhjOEjPEALXk/bDEzScLYA/658F3cZg/JeKb09HDxLZnXiKyvlwQTqmMEQB2m3FVaQAnvYzVkhTrLEQ4z+icXPvX38jfqpOIkR1/jhMoAENT0pZoAjE+n+zwvNehm8A1LheRgLAsf4sMwO71zD7UlnxKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxpfgybzjMReROkk+NQGaLgonOL/4zdwa/2ySoTnmO8=;
 b=ivUxA7LjD9eE1EYQ13AbxlJ0Wl5OXl5jzxiI29P0aHGLC7MqEl6f8kEStepGoqJawvXaIrOaCNsrtGx0GO7EpJzjPVVpVCS59hZ7d68gAAxl5KpNcWjmlMX+rfWbeiBDz/D5qxh7h4e0Ohn/eshvN5n008A6hIA5cTrOtGBKdsM=
Received: from YT1PR01CA0142.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::21)
 by SN7PR12MB7203.namprd12.prod.outlook.com (2603:10b6:806:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 17:32:41 +0000
Received: from BL2PEPF000352D5.namprd02.prod.outlook.com
 (2603:10b6:b01:2f:cafe::6c) by YT1PR01CA0142.outlook.office365.com
 (2603:10b6:b01:2f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Fri, 13
 Nov 2026 17:32:40 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL2PEPF000352D5.mail.protection.outlook.com (10.167.254.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 17:32:40 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 11:32:39 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v6 3/7] treewide: firmware_loader: Drop the unused @module argument
Date: Fri, 13 Nov 2026 17:31:56 +0000
Message-ID: <065d47510737775c9ce94279e83cb217e181ac7b.1794531772.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D5:EE_|SN7PR12MB7203:EE_
X-MS-Office365-Filtering-Correlation-Id: f33bbf54-e1f9-4339-36c3-08df41ac1df9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|30052699003|7416014|23010399003|36860700016|18002099003|22082099003|11063799006|261026121527099003|56012099006|10067099003|261102123227099003|261028144727099003|261022075727099003|261022105027099003|261021121427099003|261021123027099003|261009223027099003|261009221227099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	dRkCLlfh4d8Ip5QPvYTRqHOJ2t7cmNkDR/JMim4za4gOO4SYWFYpeZBwR+T0ToVWmva5BIraX2d2uN5Wd9c+HOihnhxReLsysXu6R9wb8S40gWyAGr4FGle1S6zPF1+OoW5t/3ZO5AWex3PwIRe+zSJ0hAHcCPXMbf7ywksHxXzOunSFtDXrN64/vFlSYQRGJsy/TATPi1fjPCGwag5ZZbjUiQAROvB6y/RZ8EfR3Kn9LK5mDgjeBG+33zB1tyuUEsDEjnssZ2bQnHM/0svqba3coQ3Ct/54NNp3Zq2g2HnSLc1WQmG5wDP1b0/otaZrzoA9XZcfXBkixcSoNy7ftf13PyCg0c/1uhtGbssuZocop5Q9/VGXewHl2IckKHwufi2Xg7Jo/TZLvkUdyoNkl3IwxVWjKjvCq1wHlmy2xxiwCf/n2FxDWzP+QGqgzOlbcc1i9nglaeyKSSVFCZPtEEz4kkV59X3qX2MEwGy6dT00iLi/reJatPhRSB11sZKPX5Cshw0hrLUaZG6OUpS08cnFHvnqdeyCEjlx/d1yqUYKL1GCc+8ALaajH8Vxx3MVBGXPW4+jB9PGU1PPsCkLKNkBYE1MoRCr1zwWykMA9yWPOQ1UfcJGE+JVM67YAYllAlGjdLEd/+BL7FXZRlelw9tJKxFFAtTeAh8UqDuM0b0lqnlZ+8LFuYShR8twfbE/yGJR4LLnMdOVwJEHEvMPYw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(30052699003)(7416014)(23010399003)(36860700016)(18002099003)(22082099003)(11063799006)(261026121527099003)(56012099006)(10067099003)(261102123227099003)(261028144727099003)(261022075727099003)(261022105027099003)(261021121427099003)(261021123027099003)(261009223027099003)(261009221227099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nuFB+21TY0hUNhr7cK4KHzUH3+oK6ma+FeEJZT0F2TV4VxUQTg6Hpz3RFxd4QNEMHGJ+6tqZRslXZija9YX3oeXYIWJDAlkoAYBGe/M7D39vjvOMMT62WYszgnx6Q5F7e1povBgo7c+VyGeN6Q4tTsd868GZoFyg+koFtdlS6x55ikD0jB/L7PZC4aAZv3U6kdjaB1mFuZQ/xVogzKnVIkKEi4Yi+rWqjNCxMSAVGwgH+NuYCTFjaO6cg5oaIVxw2TjmX7aXti9CIdws85rs+7LKMb1/i+ldyj1mGn+zBJXrdZNQxdwPJCLYYY7zYFEWmNsh8Wi3nCSGEv9uozMsggSvPVk2ZlILajWHUqLI25W7y8rSWQpjYjO05ZTmhai/kf1Wf3tlvv/YzEKYHclfJTBVFL00v53mgxThnZPD6zYQdW9hGyvPd0Rj7qrSd6fc
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 17:32:40.2511
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f33bbf54-e1f9-4339-36c3-08df41ac1df9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7203

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
[prsampat@amd.com: convert the tdx-host and ad9910 callers added since
 the original posting]
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v5..v6:
* Convert firmware_upload_register caller for ad9910

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
 drivers/iio/frequency/ad9910.c                  |  2 +-
 drivers/media/i2c/thp7312.c                     |  2 +-
 drivers/net/pse-pd/pd692x0.c                    |  4 ++--
 drivers/virt/coco/tdx-host/tdx-host.c           |  4 ++--
 include/linux/firmware.h                        | 15 +++++++--------
 lib/test_firmware.c                             |  3 +--
 13 files changed, 25 insertions(+), 30 deletions(-)

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
index 787988e92965..ccfe239ec83f 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -1193,8 +1193,8 @@ int devm_cxl_setup_fw_upload(struct device *host, struct cxl_memdev_state *mds)
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
index b97d34bd2354..f8c3df18a478 100644
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
diff --git a/drivers/iio/frequency/ad9910.c b/drivers/iio/frequency/ad9910.c
index 04a4e184b873..4a5c9e0dbaef 100644
--- a/drivers/iio/frequency/ad9910.c
+++ b/drivers/iio/frequency/ad9910.c
@@ -2300,7 +2300,7 @@ static int ad9910_probe(struct spi_device *spi)
 
 	snprintf(st->ram_fwu_name, sizeof(st->ram_fwu_name), "%s:ram",
 		 dev_name(&indio_dev->dev));
-	st->ram_fwu = firmware_upload_register(THIS_MODULE, dev, st->ram_fwu_name,
+	st->ram_fwu = firmware_upload_register(dev, st->ram_fwu_name,
 					       &ad9910_ram_fwu_ops, st);
 	if (IS_ERR(st->ram_fwu))
 		return dev_err_probe(dev, PTR_ERR(st->ram_fwu),
diff --git a/drivers/media/i2c/thp7312.c b/drivers/media/i2c/thp7312.c
index f1c7f149c06c..f52806fa00c5 100644
--- a/drivers/media/i2c/thp7312.c
+++ b/drivers/media/i2c/thp7312.c
@@ -1910,7 +1910,7 @@ static int thp7312_register_flash_mode(struct thp7312_device *thp7312)
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

