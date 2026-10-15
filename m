Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372AC33D509;
	Thu, 15 Oct 2026 02:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030493; cv=fail; b=Yi6bRfAQdCpOsPorsM6M/AuFl9OCAsudwhnMeflRujRi+RdMvrUUwHuGueFvN8Iag6+5COIKXZj3uIgvMuXV4XnUAbtYBLDUMpUpbQH/i/eAAdBTip8whBO6Iz8/Mjz0fBYXNEIwEcGNeuzXe/qiK1Mp5D/u/ZE/Yo7uN8OUdCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030493; c=relaxed/simple;
	bh=iIymfc7KSaK9Hy8OmbCWqD8KgdqzorSlbtfpqdKveeU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mw0bkIPnJ1okMZgLsJbTVqMCzJVmRiOVv1/MhfZtIYXBr7EIFP/I5YPH+jejiDVArwHu/Lf1ujh0Fn5QTbcdeqYgrhF1ny4LyfL3m0dZL3okyaqof19qtpwsVr4Dqv/i6pUsQx9zSSNIeReChMiEHAWhS5FR1HOdGi21dUpXSRA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sQX3/pcC; arc=fail smtp.client-ip=40.93.198.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sQX3/pcC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pSMtMqmvY33UFF7hwKxqqRqHwWuRsqw9jIqdxvnl8KnyQojnzmMHPokXcMbA7EI+NexSFnt4QhpQrWYuLk8SjX40fHhg2WYZw5OnMdoGqfedxHIXoAtNxVJ83M/ekFlLt4BNsP3tAydCC6ZfRgFauDZfSFU7Icx4MTXz56hRaRlxmWJw8mgOVVR4mXpWY5S3n951yhn0ZEgkm5BHjPo3Hh430ykugl1oCsM0/7D6/L8QlHlI5qZRz8Mxq+O9ENcfy4X+giy4vUqXJnkYnzpSkBi6QvxXbOyPhEvxiIzTn3sCrwQlFJhhSSFouChicsks2crg+dbjEr2keelVgcqUOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcI5FkgcEQn9Pk0wEbF3hvziTGte8gxjXDhvxlt6hMk=;
 b=o0sW0lu6ei3PQikCfykMaRAEGY/8n3z2GvsHsaub9GEfrRrbMeGHy3D999QTPtVrqdWQwyDqaDMQ8Gf8kS6LgjtU5HjK3UTU33yKVYPMOpR8y62yJa88YqQz3hbViZgrMzc+0FfY9meLEg/79bclPDLJvQ+t3XLOsmGVgc5jwgV/saxsUBKV88EPLgrpPToKbyOjCni7vntxKxpEAqA77nLYqu7CYWRvdFknESR8n+WdUW7f5ASZAPYi3Gpd5mJTEK3nMUGNmBsb0+Hsk6RDxv2/DSanTALnf3UBpIj6j9CzsnqFhrZV5IZe+inMp2AigWRWN87Z5c+3KJxHqCpCMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcI5FkgcEQn9Pk0wEbF3hvziTGte8gxjXDhvxlt6hMk=;
 b=sQX3/pcCkdVpzdRDIWfZeH6Lrher7X9/X1B7I8jSWrWhfrAGibCxnN1Q8KlzICqQWWsZly4dSPW5nKKcEI8s35JHySsyEVZS5st3MOEaJb0YJJe0aFvlwwDda+7eQUcf4OIHMGcVvnVRTSr9GOM0AOLaZqHAjgHuThkNbEqkD5I=
Received: from BN9PR03CA0880.namprd03.prod.outlook.com (2603:10b6:408:13c::15)
 by SA3PR12MB9180.namprd12.prod.outlook.com (2603:10b6:806:39b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 02:14:48 +0000
Received: from LV8PEPF00000065.namprd03.prod.outlook.com
 (2603:10b6:408:13c:cafe::69) by BN9PR03CA0880.outlook.office365.com
 (2603:10b6:408:13c::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Thu, 15
 Oct 2026 02:14:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 LV8PEPF00000065.mail.protection.outlook.com (10.167.248.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 02:14:47 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 21:14:41 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v4 2/7] firmware_loader: Stop pinning parent device per workqueue invocation
Date: Thu, 15 Oct 2026 02:14:04 +0000
Message-ID: <ba698cf0c918438acb5da3f8a630710346fa9e99.1792014060.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000065:EE_|SA3PR12MB9180:EE_
X-MS-Office365-Filtering-Correlation-Id: b7ca9e86-627e-4ab2-8ba2-08df2a621644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|1800799024|376014|7416014|10067099003|18002099003|22082099003|260925022911599003|260925021911599003|260925021311599003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	iHMy5gYAZwFRMqCM6R8vkUm+mAssLe7HNGVJLywHfmlvaUxtsdTIPnVVm+73z7gPC7tp5yd8X5htJOFhV6dqG6yAiIGV/1FEYJvYVECoAFvPjYyg8+8NHAuLOGGV1TOFctJ64pc2/TrNXJhHzErJnM1FLJSLye70MK0exE17GkfOgyfEwHZMrnQOxHcgLRM4esjQOAdZUKWHXCe3P4QjSatNt3K+3iScUGYMT7Z8hRy8el9wdnBno5UeEova6FYxohG4SD/J44NFvYz7l+FUMN12PGiASy4TQYvgPS9H3huH/2Wd4+ridBG1nyW5aac/1k/48DKB2Ih5fX5xwWcmxpFW8GLCflJOFICglE5K5FP7Hu4e3jkL8TsXPmlBBS3tSfar0nZElpAsc7oSxOzByjOF/DWOhaIQzSWWKLmrr1ct+0fikV3JR5tV2Ts9+aJM3G1JSDNi4a0DwDwG+2n7kykYweqV9U/CkxReaWoh4WN8pX4veh4uK68B+ySAC4iJAWAzXyqyCAovRAqkPVyW4YwmDeJ0gvwLPeLG1P5RO8qS3xxNXpPnW9CAIoeTOFOVUqksbxlLSNZ0X6GlDJavRA/w6xpjMAXxnqcD4BBPaq5+Qm4KyTJyeIU+5ToLiRcw1JSD/2ICblQ79nSaGcnCzGKWgye1sNP1dRV74Qwsz5e3MGVb554fNPDKhrMv1YpWD94/xRmJ4QweaCIRp7CqGQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(1800799024)(376014)(7416014)(10067099003)(18002099003)(22082099003)(260925022911599003)(260925021911599003)(260925021311599003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7YDNKVqpcvlRlAuF7Fo5SeO6qxsa9QNqc0pijX8C3ks8m2sAJV9GJ/Gvkqx0g58pgCloQaTJsNO9tkXF1VQECTIkh+3i+ra9RRuSRIvwKMHB2khjzdJ2qHKGlR5MpTdh1H+gXPQzrJ+gtbEGKKrwYNZJTZQBbC4t+XqJT4d1R3B58ZFEjQw23ztZzG927bz9MihaS47FlboAwLsbtdbHsuVTiwAdV8tqVVwNA7gYc5oh4sADYPhRAJgGd6wdZlxPu2EBOgloTtSMCKmI71fU43HbtXaFsMXCIbMBwGkwLkBcOKQnVQpM8y+W7BZpOwHl62T+KQrBt7tjRjxz40JYX4oaR47plcIIDX39L35nmWl65OHK8qmDqrrzfpRnan6qhV2OCg1gJQDGxZoYIKWC7qbMiWg+pEuZWK/no8hcUagKaHTnqLEUimDy3FIXJyal
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:14:47.8225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ca9e86-627e-4ab2-8ba2-08df2a621644
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000065.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9180

From: Dan Williams <djbw@kernel.org>

The device core pins parent devices while children are registered. As long
as all usage of the parent device by the firmware_loader ends at
firmware_upload_unregister(), no per queue_work() reference is needed.

Now that firmware_upload_unregister() holds its own parent device reference
over the child device_del() and flush_work() events, the per queue_work()
reference can be deleted.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Russ Weight <russ.weight@linux.dev>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Chao Gao <chao.gao@intel.com>
Signed-off-by: Dan Williams <djbw@kernel.org>
[chao.gao@intel.com: drop unused fw_dev in fw_upload_start()]
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v3..v4:
No change
---
 drivers/base/firmware_loader/sysfs_upload.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/base/firmware_loader/sysfs_upload.c b/drivers/base/firmware_loader/sysfs_upload.c
index 6f2123538682..890a242a7c20 100644
--- a/drivers/base/firmware_loader/sysfs_upload.c
+++ b/drivers/base/firmware_loader/sysfs_upload.c
@@ -176,7 +176,7 @@ static void fw_upload_main(struct work_struct *work)
 	ret = fwlp->ops->prepare(fwl, fwlp->data, fwlp->remaining_size);
 	if (ret != FW_UPLOAD_ERR_NONE) {
 		fw_upload_set_error(fwlp, ret);
-		goto putdev_exit;
+		goto out;
 	}
 
 	fw_upload_update_progress(fwlp, FW_UPLOAD_PROG_TRANSFERRING);
@@ -205,9 +205,7 @@ static void fw_upload_main(struct work_struct *work)
 	if (fwlp->ops->cleanup)
 		fwlp->ops->cleanup(fwl);
 
-putdev_exit:
-	put_device(fw_dev->parent);
-
+out:
 	/*
 	 * Note: fwlp->remaining_size is left unmodified here to provide
 	 * additional information on errors. It will be reinitialized when
@@ -228,7 +226,6 @@ static void fw_upload_main(struct work_struct *work)
 int fw_upload_start(struct fw_sysfs *fw_sysfs)
 {
 	struct fw_priv *fw_priv = fw_sysfs->fw_priv;
-	struct device *fw_dev = &fw_sysfs->dev;
 	struct fw_upload_priv *fwlp;
 
 	if (!fw_sysfs->fw_upload_priv)
@@ -249,8 +246,6 @@ int fw_upload_start(struct fw_sysfs *fw_sysfs)
 		return -EBUSY;
 	}
 
-	get_device(fw_dev->parent); /* released in fw_upload_main */
-
 	fwlp->progress = FW_UPLOAD_PROG_RECEIVING;
 	fwlp->err_code = 0;
 	fwlp->remaining_size = fw_priv->size;
-- 
2.43.0

