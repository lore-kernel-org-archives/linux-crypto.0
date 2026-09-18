Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012031.outbound.protection.outlook.com [40.107.209.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834AD519E06;
	Fri, 18 Sep 2026 16:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789749711; cv=fail; b=QYb8LDM87ipHctSu2tQwBuqY66tejZcelYhpcywMTJnVKe5dxoC07mAhrqvI1s9+coAp8eDYYu4ikIaM9MJ4RVw+dgm8mHjcFUMrnIVFzxMZ45QT6Vy50vdd3y13O3AcC3E2TYGcwYZzXp2rxXERYlRUv0PhLfPLG2k6jgkvZXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789749711; c=relaxed/simple;
	bh=NK5Jw5ZEdhSU6mORn/5tpxzrywaxyi3AoLZi5RCAADY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ps3GGGXmCjyeyUAvqhhWOXkFXQxRaMPxjPN7zsXUDOwbs3TvqIGApBvWrfrG7MmD0ZxUVYa9wB5aGeXThxjCIelVu+Rtdd9Z1pGYqjcMTaqz8yxmXVwE/ExFcpvk2TTCmxvStczF5ymDzGKkooPT1L3JpxiZV1MGRxBdbDO3gSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Y82jZMo4; arc=fail smtp.client-ip=40.107.209.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Y82jZMo4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IgRoQAWKdLDRnptEM94YOTkzBF0j9Vyny7VzJVhsDoTaGyC6PrZA/j4jQaQXSLAX5RYWYhLDHsM/WM3BlYYKO5dV1Ro0Q3J8HXxP1bhgr7AO3i0qN4iDjw8HZsCmY+R3xUR/RdMWyfhFC+06xlhZNl8n/rQhK5FcAXkxdTF9cUHpDf5U/iut2kRrOlCJsJv365g8FJbPZq2xbWmsaCgeewtJQfW6TbrPLQ4yT5Xuy9u2WzxO6/iXKtNkxWsDIbeKbYy842pDItxO6eNcYaDHpbBzEtVb3t8lzN9n3BtCu8OzHkuy0Gen1jqXjT2aIvweQLW4wIjfJsPjrzq//my6lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fv0buWwAo/g+R6dCYWOlcMz+W11muRGyXpUOXytQozw=;
 b=MWDBgLbXVpoqeLU80IUpiiJZXhRuA2AVr2u7QJDjs1QNrJy9ZR+Gnr7+SndIyvv7a460Lx5bi7Ts9v0Oayau/tK/iYKukBxOBwLawHUrGjDzCcxbV5P32wE8IWdJEU60z+EXqEwRxCPh6ytvxBxRCzuI+1VzHqZd4BSRuwHMH486IdAcs+Ea4JgfcxbkbUo1+EayYO4eTCLc/R9mA0/SotT2ipdsauyZARuv5XTnkp748HdR8m/Lc0lXw+IagGs+xMyg9+/ZfGYUpRZwruPZ96L59ebBEN7wa05cAYW/drEDx/b2GhsVSDOOib6nYybWWqsPL2z4NZizD49P9FczmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fv0buWwAo/g+R6dCYWOlcMz+W11muRGyXpUOXytQozw=;
 b=Y82jZMo4UdNNqj4VAyAbNB/st7OuDupm8blCcWu96yUiRBg+/bE/DIwivErJphmygTWRihLqikAjnpRa8xwWS9Be3cJ5gRivRiOFhFkpcpfxNn3eAhcc2qIk1J9Rc/aunwLbjq4mGTwKlhnXAr8j0ke18rrqnk9JlR+VApPS06w=
Received: from SJ0PR03CA0362.namprd03.prod.outlook.com (2603:10b6:a03:3a1::7)
 by CH2PR12MB9493.namprd12.prod.outlook.com (2603:10b6:610:27c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Fri, 18 Sep
 2026 16:41:29 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::40) by SJ0PR03CA0362.outlook.office365.com
 (2603:10b6:a03:3a1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 16:41:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 16:41:25 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 18 Sep
 2026 11:41:22 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v2 1/7] firmware_loader: Stop pinning modules on registration
Date: Fri, 18 Sep 2026 16:40:55 +0000
Message-ID: <685e3707522394f212d62ff9f1bf64c5e0cb8a23.1789749016.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789749016.git.prsampat@amd.com>
References: <cover.1789749016.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|CH2PR12MB9493:EE_
X-MS-Office365-Filtering-Correlation-Id: 012081ca-812e-45a2-2ad9-08df15a3ae2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|23010399003|7416014|82310400026|56012099006|11063799006|10067099003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	BOFpYC/+Xux21tl1kQWhC0w956oORXn/mCQ+yh/fMmddrq9ZU5n6BTn+pSKqSYp9qZNjpm8y946QZF1mUWM1WF4IG87AwiT07WtleDAbJmIKCAP09lJpDh0iAci8gcvWvdfqmpvwml9denAirQIqzU/s7KKyLRcr7Va3q7N1bfQlTECrPuvFTJXmgz832SndNsN9NFqZXyoJCninhSFRfZ8swNOk0JO6U2H1vbB+6cms1YsFpeqfCCzGa0+SxlYBRgGd8qxgOAWIxleyX+tiOqc9KhCbUOx+o+U0M6GuuR/WdWHfR0ifdtMB2a4syo4lT4gMBdXeqUGzfctMRZqEaP6wtOEABsF7GXLi/IYFWGLGmb092yo+uTd329IM59K7wsYmigwAKkhGULQnijoalRvJ1agXBvH2zkQK+vZxf16BJxMPkNg0R+U5UobPmvaSPBzeffakBaUoG/DGfcmHLqJyP2cJ8J/dYccrR1VoR2jj2NkuiBPMOodHmAUpruWA+4362lB924h2GxMAhMoyjPmnfIcGlpwGAs30K5CouKSNxYKKT9C+DNamsHnSRsnSIvY6DoDPh8xe3MUjL0zllHyfkAlODPRB4nbTYPqp4vxMYII738boGfnlww1Dc2NlGZ1VrShVS3wDP9Fd1jKJpQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(23010399003)(7416014)(82310400026)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Cjp2QA+nIhe7InQymgHa3IJbklnTLzm+J1ur/75aCAwBVrlUVspmB++fVxSTEyyMeDviy4gG7ENG0h8YAWKq4TkRsQNCF6dGIOrpLeKOumQJlQq3V+7PL/FQ6X9HerHmE+0h/9s5BQ9xunrGQK/YmaQFqZ/zkvka3Xuk/k4x1vLTDI5NdqEuqYXw/6bl/b4q+wkA8pxm8UzVodbFakSJ2IQM0j4GvfZ9RMbyMdU7QV50dcXQ/frZ5L8ajPI6++4m9Ez2aRkOYKhkT7InNpAdss8SrQf/rknC94FkRwIzZbC7Lhp3QYV4TKPdSkN7KcTbjrLU2VAZstuLrfmYo0QuAUjzkOXdV6vM3J99GeFau0QTB0qKIxKVBFOpabVJZH8mOxZ5z5n+i4WrEL4kgbIBMaQY+lMMeVSOgh+hrg3ncuFDDgfRS/1rQ4/8EQ7U7qBH
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 16:41:25.4699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 012081ca-812e-45a2-2ad9-08df15a3ae2e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9493

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

