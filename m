Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012034.outbound.protection.outlook.com [40.107.209.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8234CC62E;
	Mon,  5 Oct 2026 16:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791216977; cv=fail; b=tmErRirmoYoKhXOwQ5dOb+kIDdwshaRwZbFOtbYfu0g2hIcRRowCJb04gx++L+PKgxKc93wzC5JbECcr9cqyUCLrAN9ZB//7BBFx6eiri5PRrqdUUWhwmQeXOSkrDT7aWB1r8OZ/KhSIXsIMKPRifD54M/VE1wBAP7Trr3+3ys4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791216977; c=relaxed/simple;
	bh=NK5Jw5ZEdhSU6mORn/5tpxzrywaxyi3AoLZi5RCAADY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oAauS62KgoMy7oMgiGffaXynHwfWeSofarT38ZSkHpW2hQ7+wg0MJDNpRtUrn7a7CfDdkUrJa+O3hEapSgtZOEoMty5Azu8uwG8AySM9H2SekjYva91Bzq5CvOOC7LCRzCJ4xChUSQSwFFWUKuH7PmEbP+6yIPt3lGKvHOaShPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4BIed/Hn; arc=fail smtp.client-ip=40.107.209.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4BIed/Hn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RI4a/m21GDr5SObfJ3y52ceEo1ObK+aLYzhuZ5SaNIxGyb4/4yGkRqnX/7i2ChX+K/fTIHdOVUUz/HDdlCakPZJJjnMu/VpUk0U8EshVkQ/mWu/jYV0Lqq5a5A15wHv7QBU5gr0iSRybquCDfrC7V3/VYtBBF+nTTJfsJDKecL5a4Omd8ex4koM604Wwgip9rTINcK+1gl2mLmunn6STatWWGoqmomDOwrmIeHnA8v0pVJD3E1+zHKV35cQWBZhx+EzUzlZ/Ii7NRMhsWuCnWTkUGERY31U9sySB5C7CLa4AEllEN7UnwE5/WK07gFlDa37wwz9jCHx5hW/v0NtjwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fv0buWwAo/g+R6dCYWOlcMz+W11muRGyXpUOXytQozw=;
 b=Ongb2GDAX/hMHFvGyWBSG9eT+oMIutfG4WjhnzqW3xrCs2oVvVgSoKgFC+AfBaCc+qplrtkDDqhNMD5uA9jAiLAhg4VPwqLS2HoVOa19Qd2ZnBxBx+dWpojnvWo/JfpPJAAz2qsPFwahFqJAF9xagKpCAFiVXDe3l66OOOGW/fKAoQe9K09p6WnP+11cgbH3qCMIdboxG6OyFRRjRoJdstfi2F3Hok8KCD4oxGNKYDI5UthakLVJ7FTp4sM8TkUv4L+lTlp5PTPzIfeG0uKiYBPNS+p7BgvOCOTAPv8F7E4wjORtkyivXU6DzVMJJXYLZTdQOneROGl8JqdWKeVPTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fv0buWwAo/g+R6dCYWOlcMz+W11muRGyXpUOXytQozw=;
 b=4BIed/Hn7fp/6xSVHgSZ+WA/DkS2Cz8UGjzHngHdMbgK+gtcb8nSr+WI0r6I88gwVcyFWQJ40zhlanSg5tbwLfnwASerQSP1xZOXQbf3UKNmF58jJE84oY5OpYRN2hPLwL/79V29x7LWScVHv7NoRxEpF50tYCqbAYVMIjh9Gwo=
Received: from BN9PR03CA0229.namprd03.prod.outlook.com (2603:10b6:408:f8::24)
 by CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Mon, 5 Oct
 2026 16:16:07 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::d) by BN9PR03CA0229.outlook.office365.com
 (2603:10b6:408:f8::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 16:16:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 5 Oct 2026 16:16:07 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 11:16:02 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v3 1/7] firmware_loader: Stop pinning modules on registration
Date: Mon, 5 Oct 2026 16:15:35 +0000
Message-ID: <719e29b53c1130843e44f765449e373402680a6e.1791212077.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|CY5PR12MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: f25f7d2d-beef-4b80-70c7-08df22fbf662
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|82310400026|36860700016|260925021311599003|11063799006|18002099003|260925021911599003|10067099003|260925022911599003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	fl6MpBR2T4ejilyjq30DxmPUdsYLXcVu+IB/r908d54saQZVpx2hR8r/gmBL+4CsY3X6wzOxKzFyngn+sfSYj1jjfLQbhD/EJgcvm6eJuUwYNgLHrXaooLWLP5WeF1fqi7ZihObLgY52TGiAVSH3y20K/tFkjgeJCtRW6g4tW5vUE9w7760OQGjjKwgaW9LJHJMjWNvQp22O4ka04nU6mEcbMRjOTWNgdrSRk5JkhWFuZYAsrTLSGUNQeFoB+pFPbMM1sIjBSK0W4MFBzMbapEJfxhN/DuQJkhioC0ARFDc6z5siWcpDWrcl2Cuu7Rh0yhLbtozzF9oJ1DtHrBh9VgFktZy/M4qPnkPJkPjySftu9Zmq/+BG/jAP1qGB7v6e0iQtKZWv5qqqFtvo0GfPztPMsYfUT1LHdynV96fvnDJ2eA7NjJSVZhItL+sdgUJfSsMNA9e1CCytsOPUIRIQgrpO8W/xg3SHAQwZA/UPzjtKnDRdXhW6xJXyy8oMqsbOMTfU96NdIbp2krK6Exf7sbO87o+X0Seejdnf0p0zjBXn5+SDgut9dC2avNR7MnjGQS0otLatFtVjAoQzqSTuu96pggPWK+MwyNMZgOv2wg8GQpa+kDMISBOw6PaqbtCuG9wEdfXnWwP84KkfQDWTJA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(82310400026)(36860700016)(260925021311599003)(11063799006)(18002099003)(260925021911599003)(10067099003)(260925022911599003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WECDCtbI9ctLheHMjmWU7CThXj2TbtlplHQnUwqmo1cueqJABbcrtcz4Lr7boEaBNM57kYTVuR5jMz2CaA1Ozc8JnmaGinpgC43i/Qnj/oxlCaeUSURt7OFz9mnmGi6fq+OoImppBb3MOYD0rJsplj1BQ9fT6Ha+whMoRlHHwr8LbBfEhjwwnA+lxSfXytLW9qBPcFE5Z/5YXOb0F1iuPhCW8+X5mCH0eMKZbAybS8C5GttBDCAzpRGNsti4F2f4SfA1Le2DKbZWnD9UgOD41ufenarVmPrfq3X9OTcpZGKJOTq8U7hpTsHUfEd+5wcLQUdsGz2nHDN8XTvmZ4vM9oL4x6A8WsV382i7yvuKy+ayr6lX0Gd1mja5NksDzwIOJki/CxHTt6K/BqKJNsr9Vtk+5weCpq680N0eZS4KagOV/nqw7PXABbSCmIzsG13W
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 16:16:07.5247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f25f7d2d-beef-4b80-70c7-08df22fbf662
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6179

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

