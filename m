Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.4
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792602342;
	b=xOyqomjoMEJKkqHaViC3NACPZkoIPNCqTN07Zvz36wd8i30CE5f/zF7TWz19Pmyk6Zms
	 YROfWUMRoUvFenxEYhzU2mFaDUXGB+Dy/gpQkCJWmCNQH/8b+rPpOCGPRUSgUv/ENo3aJ
	 i5FzDnWcU0yb6CVSe2oLOUD7EMfdSMLHzxdkX0Eat618Ltd5+LBbUqYErsXtpUMrmAseI
	 mNE12JzF/PY6gLJoPfsvgPPu0yiGbuF7JQavuPjuHG1v96tyME4VndJWH7a3EOmyEGiCq
	 6bmSAMbQmHJHC3Ag6MyY9yppIpNdoKUOjgkA5Bx6Oe+s4M1YoW28suNl7klXw7Et7hg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602342;
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
	bh=TaJQy10qUkn5UXnUt+PE8npwWd12HoCLZl/LyY5c5tM=;
	b=jyTilLAbrGUx1xMHh6wyimykTE13zo4kygGCORcdXi87kf9atmadPi+YI90fNBI29GvG
	 mvK/UVtohcZK90uKb/E3dNO+czIrZjA8uDMtNHEN7Jn6g9mE1PPYlADJF0V8WmaSfno2x
	 oCUEEQb/UTZ2utdAa6+Py21rh8sL8RcM214s5muokXdZcPqC8SQPatZCQc8j7TxYY5UMk
	 Evj6qTUokBqjZfQh+/TVhnPIy27davnvG+TppNM762wirfaOUAeONse8nQmhgPDYety3v
	 KLYk/VyWfITs2XuuazErMmvJxYnVkq5P3gm099zcJQYPDU/At3ZTFAnjUBcyOZoQisg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=qzldUy8Q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.4
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010004.outbound.protection.outlook.com [40.93.198.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B40606A319;
	Wed, 21 Oct 2026 17:05:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09B40606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=qzldUy8Q
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qKkud/4Xka/1SVLhO26OuuWSCvvkWmmgITUUzIZSQKDnCTclZi8L14MTIyYpGO4THzbTvX1A0c65eSGdp7Brm0U5R6CeqNOcxTya2KVhKE1sOM89tLn3STzaitQ5WAjXVhCTlgrQqEnQY5Tu7rvzJpDvFTuTL55i1qqcJDyaa6N3KPSpm413yG70CKuGToyov8jYy08/8Cb4OjPY7zEMfBuv6Hn+QPg70H1ucSDtDhdXkLwV2RtoDeGDVBYbnGFNgk+W69WypncPZgjjFHdvCxDhW+kIsgzSj2ShVzDXF+PYqsbc01BWpTlpJEdN5yiBdrdY7DwurbpH4qUkcuElHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TaJQy10qUkn5UXnUt+PE8npwWd12HoCLZl/LyY5c5tM=;
 b=BKU+WQh3m52f5Tz/G4nT5tWJLlzRJnSzT1LunB1xh27mm8fxgnexZFXmzQCwcbcNrLilo92kZIxkM37m+WgvpXz82n7p1Jf5a18UZ4jO7QsT3+xe6AVsHGjfETHXMVH+mfMqrStQjf2JJvulM5ntcf0OdogNaHgMo8RX6ncbFA0+Gg7CtouneKYMgE/5fojzdoMMBrx0fCM09W5n8SQrOloy344Ntq78r4nzFVooutdem8vpydfk+0Z9vOc3j8giTExJ3WpB/lJjuS6Pd06kODA+eCf/7aQeIYlfdAJMDd4AzjbMTIhq9PoblV2NAZ7Sm51vWRc2mIlpCB+YKsLwkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TaJQy10qUkn5UXnUt+PE8npwWd12HoCLZl/LyY5c5tM=;
 b=qzldUy8QdQ992vZX6JYpaYeOxtegiYshLqp1RNqI8N9L2ZkYPmcRsh9aKiC//AMoh/urY6Ju3eX0Too2H1V5hRUw+OTiZ//4d23CYDXP/LiT2F8w4ouEu+Yiv9SDDPSrisB4sZyW2qfjcmzEPP3gG4iBF3Kc9iFDe6K+B4Xv2Gk=
Received: from CH0PR04CA0096.namprd04.prod.outlook.com (2603:10b6:610:75::11)
 by IA0PR12MB8748.namprd12.prod.outlook.com (2603:10b6:208:482::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 17:05:36 +0000
Received: from CH01EPF000BE94F.namprd02.prod.outlook.com
 (2603:10b6:610:75:cafe::d) by CH0PR04CA0096.outlook.office365.com
 (2603:10b6:610:75::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.15 via Frontend Transport; Wed,
 21 Oct 2026 17:05:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94F.mail.protection.outlook.com (10.167.244.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 17:05:36 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 12:05:30 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v5 1/7] firmware_loader: Stop pinning modules on registration
Date: Wed, 21 Oct 2026 17:04:57 +0000
Message-ID: <6247f59b5ac0bd04bbd68ae48f910046d4edeef2.1792599491.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94F:EE_|IA0PR12MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: c8c13758-e2de-4ad8-06d1-08df2f958667
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|7416014|376014|1800799024|36860700016|18002099003|10067099003|261021121427099003|22082099003|261021123027099003|260925021911599003|260925022911599003|260925021311599003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	W+vv0bJYo7W6Y2iBenfNahpIwyAcn4Snol5UtE+AG49QmTfxjWZVA30ekImb+PrGdGwNTh0ZsMTggOF/pFa8F8VId1aiCCk2zeEPXMrMSGQ9I42Qp654YR6dcr4lcpabDKjodgCPRt6nTCFMXBjsHGoSIOXwmxtGRlEZQfA0XX7PUCk/lnqbbMeAqkoBsW0ZGcVz/frwbF9VIINh8t9mDxe7MlsDLgSyGk3xyFiWu37lmakZPq5VNfQMiFolNQ8MQMCy8jQDvz4EVzqttnal/OpFw0CU2e06HvBpcEGkAALm3dhiUORjzDqv3mWZ87uHe02mxkEzoygqM590ftnATQ00lG6+zO01aSKHquxTk9bCvWcTRnaD1rVhWB/SOuMceMGSs3nRuLRCKkOv6g5mJglDa7ACPNJCph7I0CjDH925DzFCen65hf1bV/Opk8O9L3OZSbafhKH8KA0gcBiouY8XxbbVTjtz5Qcghp/FBwvzIrHcKI/36K/Y4BLJO/7ZCN/QRLNQ1yI/C6ZjkYUMK4/qLPit6aYbI385EoeVmiXOL69aYzu2aq82PKNkCHU+8Yc/fHxTGWYzg16Sf8Scfpv4GvZhdkr8qmdm3zVIoiwk5YSIzLAWoa3Dfx/RtUUqzP+1FQyfvKwmdlc7KSpDqQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(7416014)(376014)(1800799024)(36860700016)(18002099003)(10067099003)(261021121427099003)(22082099003)(261021123027099003)(260925021911599003)(260925022911599003)(260925021311599003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JtaCiuObSuZLR3MnJwn7hBBKuphzarFtEOuYpriloExgiR/6IZlAwU6zuOzJ7EAmUJTG0ViVPgTXWYZYgk6otXaq60KScnlem8VS1wqEKr6HmKxJ1w2JdsbdHbA+CX6MlMZdOXoj3mR05FBuhIZ+n3wEJJVtXHhf3Dey05gaaYIvvg9pgFVv2pY8x0oubGydMUqJP0EmZznLXtg1oEmIKzCzgUSleFFMnC7x2wOwJEmNwkJ64PUWpqbrZ7lkxatgmy1zXyd3VK2ECZmlKT2u7WWI2p8nEfTFJNQW12bzmpEIOy5+8kr53eKjNzxlCfJmPWaJ4NsekzzngfwtR+34Z5p+OVnr1gxUb9K4cA0tlanCD5C7Ex3NUYeuW6bbQLJEfH0y+geCqQ2bLQQKeXAH7+v6uOYNbHr3yiSqUc1bvuI6EhicsyEUCEao4KOTJCwD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 17:05:36.0866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c13758-e2de-4ad8-06d1-08df2f958667
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8748

From: Dan Williams <djbw@kernel.org>

The module reference counting can result in callers pinning themselves in a
circular loop. The module reference counting is unnecessary.
firmware_upload_unregister() must be able to guarantee that all ops are
idle at return.

All ops are either called from sysfs or the workqueue, so unregister sysfs
to stop submissions, cancel any started transfers, flush cancelled
transfers, and then release the device.

This also solves a theoretical race of new submissions starting between
flush_work() and device_unregister(). The module reference was not
protecting against that race.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Russ Weight <russ.weight@linux.dev>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Reported-by: Chao Gao <chao.gao@intel.com>
Tested-by: Chao Gao <chao.gao@intel.com>
Closes: https://sashiko.dev/#/patchset/20260326084448.29947-1-chao.gao%40intel.com?patch=10705
Fixes: 97730bbb242c ("firmware_loader: Add firmware-upload support")
Signed-off-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v4..v5:
No change
---
 drivers/base/firmware_loader/sysfs_upload.c | 31 ++++++++++-----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/base/firmware_loader/sysfs_upload.c b/drivers/base/firmware_loader/sysfs_upload.c
index efc33294212f..6f2123538682 100644
--- a/drivers/base/firmware_loader/sysfs_upload.c
+++ b/drivers/base/firmware_loader/sysfs_upload.c
@@ -312,14 +312,9 @@ firmware_upload_register(struct module *module, struct device *parent,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (!try_module_get(module))
-		return ERR_PTR(-EFAULT);
-
 	fw_upload = kzalloc_obj(*fw_upload);
-	if (!fw_upload) {
-		ret = -ENOMEM;
-		goto exit_module_put;
-	}
+	if (!fw_upload)
+		return ERR_PTR(-ENOMEM);
 
 	fw_upload_priv = kzalloc_obj(*fw_upload_priv);
 	if (!fw_upload_priv) {
@@ -361,7 +356,7 @@ firmware_upload_register(struct module *module, struct device *parent,
 	if (ret) {
 		dev_err(fw_dev, "%s: device_register failed\n", __func__);
 		put_device(fw_dev);
-		goto exit_module_put;
+		return ERR_PTR(ret);
 	}
 
 	return fw_upload;
@@ -372,9 +367,6 @@ firmware_upload_register(struct module *module, struct device *parent,
 free_fw_upload:
 	kfree(fw_upload);
 
-exit_module_put:
-	module_put(module);
-
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(firmware_upload_register);
@@ -386,23 +378,28 @@ EXPORT_SYMBOL_GPL(firmware_upload_register);
 void firmware_upload_unregister(struct fw_upload *fw_upload)
 {
 	struct fw_sysfs *fw_sysfs = fw_upload->priv;
+	struct device *parent = fw_sysfs->dev.parent;
 	struct fw_upload_priv *fw_upload_priv = fw_sysfs->fw_upload_priv;
-	struct module *module = fw_upload_priv->module;
+
+	/* hold a parent reference while child is unregistered */
+	get_device(parent);
+
+	/* shutdown the sysfs interface to block new requests */
+	device_del(&fw_sysfs->dev);
 
 	mutex_lock(&fw_upload_priv->lock);
 	if (fw_upload_priv->progress == FW_UPLOAD_PROG_IDLE) {
 		mutex_unlock(&fw_upload_priv->lock);
-		goto unregister;
+		goto release;
 	}
 
 	fw_upload_priv->ops->cancel(fw_upload);
 	mutex_unlock(&fw_upload_priv->lock);
 
+release:
 	/* Ensure lower-level device-driver is finished */
 	flush_work(&fw_upload_priv->work);
-
-unregister:
-	device_unregister(&fw_sysfs->dev);
-	module_put(module);
+	put_device(&fw_sysfs->dev);
+	put_device(parent);
 }
 EXPORT_SYMBOL_GPL(firmware_upload_unregister);
-- 
2.43.0

