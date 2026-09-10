Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011048.outbound.protection.outlook.com [52.101.57.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D3A5427E5;
	Thu, 10 Sep 2026 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059828; cv=fail; b=eMcMcjrvl5h1yGzU2bnl3Fs+W9Bjt0C+m08PDCGXbRWn0GisJFnBt13RoVE/KmJXgRJ05OhCrzR7h/mp0X/8AWxY/ddC3PGvuehwPww7dt6PDBENoauG2PPbJoLBAvG+3PtoWdxomcjLsUQc4GgDSfiiCFAnNhd676RqBw+rgtY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059828; c=relaxed/simple;
	bh=NK5Jw5ZEdhSU6mORn/5tpxzrywaxyi3AoLZi5RCAADY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Prv8A81qwn5apsGpBZth+eD4aB3vgpIbm/LyhP0H5aq52NYvBv8ToXvw6mV1zwnPVqVBllruXk4MEWnueoqKRqYL1FVS1gJhpn5OL7qB5PR7HkUXvV8JZD4Lt36euKKluY49TE3GlzM639oDQZjPFCj/tOTdgpprMWr/RwXo49Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fuUy7U6A; arc=fail smtp.client-ip=52.101.57.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fuUy7U6A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mHIcf/2ewDkR8ZE/jm1pAi2BVG2hZntQZ3D1OL7+TyIlZ8UJhIJze1L3CxK/3uoiTFjTRRM5qbLZpu2jReg840FekI2YVAAiLXwRwQ80GwuZwtJx2YyecNxuV71NmizZ6cbUOUqkwxrChm/USeCwREhNuwnbVhZQFeLSU7oJZyD/XAJ7npcCAqIbqhiCKVL5P79TtOGvp25+45j58cPrnIPzwZbbKRaXOQa7PPugsMmMyT5hiGb5KdhWPIr9keDL5HbOcnTiDGoTRGnsoNYip6icWS7jodniVCmIBqs7108lKwG8+oQpkwE7bPFQOcRhG4vKu+TmD1OJsMQGA5h9kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fv0buWwAo/g+R6dCYWOlcMz+W11muRGyXpUOXytQozw=;
 b=q3gsbJI3Ow7LeiOcUv6VTGZmBzW+yB/Bmu/NsSN2z9nTtT4H8keDsNfUsxz/hRkay0uDKIWfttGx5eAcOvq+IW/aZr9gmdNHq86TWGWEnpMtOesyHWQnODgjZH+Df4aPyZveePraN1kWMk4JbKqdi//iwSdoap7uiUYu3adMrUO09uSd6DgLsTv9Gxl5mZxTAPThp7nhYjiFtR+HYWdKuz6ifLaEoMADPusdx9L2dXH+VM+sUJ7ZRPmf/7Q5bwwR7o0TkLx76J08nOQUKjNCyBBMVjT9D0ilvSmADSAXzGcFefIzjLLs54oXLaIHSdCVtT5GzDz8eH+aGrACHzriHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fv0buWwAo/g+R6dCYWOlcMz+W11muRGyXpUOXytQozw=;
 b=fuUy7U6ATD2zyDpnl23dLbqnnkVDp+fCLPBBNxEAQH3v8rknQZf10vIBUcpIbKrNkmol3Rjq24AIv80/jvrHCr6XuIiyq2ETII0CGkUIvVpaJngMbYnzT9Kw10IyGAYPfzsJ/xPZZxiqua8MwCdPxbEDNppF2dLxuwMp9x5YWkM=
Received: from CH0PR04CA0014.namprd04.prod.outlook.com (2603:10b6:610:76::19)
 by SA1PR12MB9248.namprd12.prod.outlook.com (2603:10b6:806:3a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 17:02:21 +0000
Received: from CH1PEPF0000AD78.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::2) by CH0PR04CA0014.outlook.office365.com
 (2603:10b6:610:76::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:02:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD78.mail.protection.outlook.com (10.167.244.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:02:20 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 12:02:19 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [PATCH 1/7] firmware_loader: Stop pinning modules on registration
Date: Thu, 10 Sep 2026 17:01:56 +0000
Message-ID: <b759cf058122be8190ba30c64345aab912fcd143.1789059392.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD78:EE_|SA1PR12MB9248:EE_
X-MS-Office365-Filtering-Correlation-Id: f5a4433a-d5ee-402f-8e29-08df0f5d46c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|36860700016|82310400026|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	0MlkMzeaFLIhoqGw9lYsFX8EVt+R7/fiaV9R2tqeNNApjSPNPVdLRlJhQNGyV+loRMFUXsU5n+CXh3epX86D4qdJ69wRVoEPcW9IQXzC3wQfb/cyRe4qKMp32OCeuQWJro+gJrqh70/UGfYvM2Qc5U35HXgF7rpfD8W4tCBkM3WAwjDhJqsPIsoF5DQKPqzPMCKM73L3ZUO5mco0UrlzGIR05VWyfUWMfHyZy8NnzNE2JwrJdgCg3ly8o4Iqpg0kqsov04eNuiHqwo7Io4cdhWYU1E4JKWJGli7UGGhTa3NfThw5rNgjjCHLkyCm6lMT2sqrq29adgWBORy+nSlgYoGMv5oZPcS9992Czfui7OMw+Yv5GCZrukWlepUmCQiEqCGMgYN/HkBvUpwW9kRTGKjKlMIHp+sM5Pk4NKacqKPu2dqE+6bsx/6vBfq6kLI25DxQSfMZmWBe6iIqE35AKtpuIL8m8LMNkmgPJ8aptWg05h8VJxq934q/HidcIYJmFyfbMebSdKM62e7itcYhFHqE4P/or3S7MoOWsIUHvlMNbURmdGmkKRJtcp+WkptGkUCz/rTWdjbZXDEIhblyGKDqrUbfWEy/Kb+kBM1LDBqOlsv5YOFAQ7KbvpUTUEHmCxn2sUoECtLbTRsx54YmFA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(36860700016)(82310400026)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GXGwWTb8RczZwxHIkvIJANvuefmUNDm3VvOngLqQ2r03aKq9hqI1d+1A0as7rmj3aFYd/e6vq5iLB9ksX+dJpMOI443AJ+mCuZy3B8hfy6jJgcR2qmePoeyKH8qXuzWbHKXyr4RjvxuNNx4VKzhr2wdzawuoc5AM3pmANcKDvhOyG/BQ0Good+MbA+qkqZNOm1BhUmlggBwxB4erxiVloWpgVazUhPxpvjecsX0jSb/8l4UOVslQf/tay4HsAKjhYGvKduYpYieCZttvUJw+BSBatRR3SLs0FrtmpFxAcjL604TNkOn/AVMEiINTvm2/N9jMwAGqJywXZOFCUkwiIVNK2q7wO+8/1piYCmm7jnJHP3QGW1wyzl3JV1G1IsCU+WWd2NCdJKv3s6mZdo/vioFo48NhAr88Xb3GK2qsut/AT19NcPHRdu7I88LasvLM
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:02:20.3324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a4433a-d5ee-402f-8e29-08df0f5d46c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD78.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9248

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

