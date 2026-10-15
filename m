Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013050.outbound.protection.outlook.com [40.93.196.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714AC39E162;
	Thu, 15 Oct 2026 02:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030477; cv=fail; b=XCYMVt0ROvsmKo1K6a3sMvMhthicjm8oJSeKVZBO9WdAg90BQVgbq1hdqtSbPm79IxmI0/6vBisO8PRuOM3yFme69ciQQTYe8VVG0TcuuLisqLElmyBWwshyGUIc+iXF3eXjMJM4NxXBg0rQfbMvpc0lw+nSdq/V1Hrig9hT5GU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030477; c=relaxed/simple;
	bh=O1mf1yrPJBWB6xBIpbKoo0+xFDr69Cbp6AB88YRPeBk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2xW4BHoxBP/kUsYsUQrLZgviR3HqU++9vuaSnn7QWiHRRAwG/A4iipz6cgjywO3xs81W5yjk1DE9GIegJ48I57PVnkUTg+tgJwuVNbk/QrsUNOKAoPRMZlS0Cy/HAP96XSGtrxAVFzO52t9FmuUdO4cD6ZqpqyPn5DUx+yVFGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QNX5taOi; arc=fail smtp.client-ip=40.93.196.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QNX5taOi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Om17BENJO6hD742NNazraXmcACrhflBs4DKPEMbBzyHtlraR6LshFW9VlD1DMkQtTueDiVUBxy+LJlPIO5tTCFX+YHq35c8GYwLMgrL2TriS+fWEVGjY28cZAj/tWi0a1qgByogU9X9wNAQ6683u9ufAxedDJl9oVXGlYbq82SjAlBTuhgl+7Yz1a3EAw0ktEoS0PS6QsoBtXAZndA8Gz/fG3cRvG3qJ4tjJJF16t264GKpsY0La8jaZzEIKDWW6mEU/SVAtH8eOIkG1T+Q5J7TJGc/Sy/rpa8h2J7P5QElUUKNBhet3aZdb1SKBI05OM48PA/h182nvpvrfw3Jysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GICY8ePvAVis5G72+3y0flDvU5qxOR8nRzcFuIMjb5U=;
 b=YKQHnMnbOJovuDdV9DnWC7WHiZ2O1wYHCq4E/YRngDqaUJ5hKQwV/PDp2jo+ynECA3TbdVzZGeHTAm0lpik1etDp/d7wHIQHNkcd1/sOByNFXitelVpHV3gO9APYqb1HB75daRIKSr16Gmop9vMmo4dGl7vrMPQ66lCIAB1OG3AaJElGYT50E0ZU6YNww936KOc5bGRgTIxR/9BVWx5NYFjwGtCldBZCEbWIy9n6qgY2Fq/VOj3RXHjJ5g9bR72qE9SjxsFgvNC0lnFucH4e7t7CPOYd3XyTCrAIit8z62Wnoh/ZU/XVF5YMr2qzGbOQcChrCYYEiSZcdodnTx0NIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GICY8ePvAVis5G72+3y0flDvU5qxOR8nRzcFuIMjb5U=;
 b=QNX5taOirvuo7e7osXO3S1MdmGrRjjS7VVvTHoXGoAqF+yXdjTmKqnr3aJgXS8Mxa/4Uzt8jY8k+in7MKF4EYoOrWNYJsF8KF7B55cfOBMcbucUTAZ0w8luHeHXGPY+QI/cz5vaS0CWVC8AV8WPb4rJ3jpWG26KNeG9alpazSMA=
Received: from BN9PR03CA0886.namprd03.prod.outlook.com (2603:10b6:408:13c::21)
 by IA4PR12MB203806.namprd12.prod.outlook.com (2603:10b6:207:12b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Thu, 15 Oct
 2026 02:14:32 +0000
Received: from LV8PEPF0000006A.namprd03.prod.outlook.com
 (2603:10b6:408:13c:cafe::28) by BN9PR03CA0886.outlook.office365.com
 (2603:10b6:408:13c::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Thu,
 15 Oct 2026 02:14:31 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 LV8PEPF0000006A.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 02:14:31 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 21:14:24 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v4 1/7] firmware_loader: Stop pinning modules on registration
Date: Thu, 15 Oct 2026 02:14:03 +0000
Message-ID: <e0beb4cb93e07a829f5e63cb3c62059c9c349c29.1792014060.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000006A:EE_|IA4PR12MB203806:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c0fcd91-53c1-4ba7-6109-08df2a620cad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|82310400026|23010399003|36860700016|11063799006|260925022911599003|260925021311599003|56012099006|260925021911599003|261009223027099003|10067099003|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	k1X/533ghcTANmefuLS8UrhHbzlU5hj04kI+XZZFqoV+xDAtyzhmhNAooPqwWLMDZqoeCL6UdhJZc6Fsun67P+evmhOOPgmE4Z8iW7EQAFr/ixKaSjisRZjBYwcqAixJCbsVXd58K9jKwJIT9JQmlmbRKyudC5QWWn9Jlw71cykSTATmgU306oJfV7z3yesInuBkIf5fKZC3+vuaIYR77JXq2sKWT+lc7WhhYJP4i2XS3eoX6z8K9eqddyofJaaKMhMXZDt45ohkgbjInD5m+JodlDmizZWRI4LUXrMjxbKFRCcOYZxw8rWqv/Ql+LtlDbW2Y2fL8xq2n2YHlW9L97zT5POKtkdlKn0hF96MxDYfMiWBRrezwrfejJ/iP6l80Dbn0iHj1BpBgpDPrGVo1U6845jnD1/otKZJqaaF16eONmKrOqVO75sN9Wn21YkClnqg62DddalFfhHA/Kvf09KnYY5/CWrY1UEvW6VHpyw+Gk2oQolktOL9xN3CB2REpyWvjVbXVsO+rQyEI3LbvsMGUVXNoTmUN9FKFhm/rEYIobZUErr6x5P0X2qm/7dUKku3XZMRSHpzbuDbhcK4JawC/C8gYW6btFG85UPI6zBQgWaXWJKbz11paps4CAOhER4tZ9qoQBodhlHXo8/TVA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(82310400026)(23010399003)(36860700016)(11063799006)(260925022911599003)(260925021311599003)(56012099006)(260925021911599003)(261009223027099003)(10067099003)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sLeyA291W8Bqy13HnCfvVPe6CpbU3iiJ0OeVsPIdiHS6E4ViXZO3cs/flrVlRHUUzPNvpNAUAr2QubxdCcR5pv2bUrn4FSOepHFjRhoypmByOG3msSXA6STbBAW636uIqdeF+De+dmf+MRpLt/DgTqZhmUah8gjam5D6oTlBxlfYzGwmFGS01SFgJmaqKOGCvFHn+TjoCSGcmrAFMzXJdtZ5CqhuiSBehrK7llItZl+RrThYYJid71x/aGlOeuQUeAOiD9gp1r1TepGKk3/6RHcsGe1eq9814n0bzV7vlza7nvc9N5coY9nqu9YEAPFdsC3627bVHzFhXgUTSABdZSyksEniHqpw4SxtFyI2HQ8/Oul3AJ55EL+laKyyD/StiUjSIJCwoUnMD6ksHJa1znEq757vVja8o0kOArEbbdGj4VtSArC7qbirhNn0JNl5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:14:31.7300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c0fcd91-53c1-4ba7-6109-08df2a620cad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000006A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB203806

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
v3..v4:
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

