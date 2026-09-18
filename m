Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010070.outbound.protection.outlook.com [52.101.61.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1AF51AECA;
	Fri, 18 Sep 2026 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789749770; cv=fail; b=WFmhvrpbLnWUmZjpXt3NTq5xqjZ4aG6vvaxlOmN/qYPvtWXQltUYhzjBvdi5XlLl0tqAW7yk6y/n9QvnSroxwl/4X4cFUJRzf90BLp2mOE967QPI3grE4VPprwtMevzGS/o3aMeam8MPeXHhXEtff3mNI4Cq4A4PUzhSC5NnZmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789749770; c=relaxed/simple;
	bh=vXDSKZelxNCKXKbYssSyB4TbWqvFFRO5sr9P11yiqrg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9m5QAk+dmQui3Ia4Zo+5wRRXIRyus1AkEu3A7Wa3rzHGR+q9ps49gUlpouJOKVUrkYRI9UKn2ZBo+vD6FsDhIZTJpo738JyVXhwHRjBVL1wjBLFRF+IV7Ti+Wp5NIO3h3BOvKy4ZZqW+zPNpk2DynN1DHiozWWu5PwVaenAdzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hYIIyXap; arc=fail smtp.client-ip=52.101.61.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hYIIyXap"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJIxJT5fsVEArywImBkR9sHrRn4iiEyeN86l5On2WPR/8GqrnmW+y+9xHjr403lLX/RwuAfSEQ7AjlVvml7gRarA8x2WFzNkeRNfmEylPKaWhabhx3rMHnFz4mTGG+GS3+kNOLNZSi915d1CeJxNALBHipXmOn/uCMQfzbRNWfJwNHoQDxXjYWEbhzedA/MS6+2CC8JDXTbJqCmZRl/NDIY4Q8DNfHgdpiJjRIaUaVvfzf/4V2EiaINji0FBi/I8nrX44+XEkqa6TxflpdPONZZgVW0yVxvAprYOYO2PfTujR7SvMc3P++e2LPN1evni4is/0i2pXYX9QeyluAu32g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFh2VopaElzfTKLt8aBDjde45autjGvJbfnUGE/+gxU=;
 b=td7KeK/FCQnyAEGCZZciYSLeJs6ia+8vn/AhrQGzQSNcrK1M1Cd4RMB4k/orNDFuqJBJYoYLBsktj2cvXe4N8+j27eYNyElqAmmpmvzGqkDliqxw8FjwMPSsA4apGqOAfHTpq204AxSREQnmWi32nab2dtfaPMf6lbtpQZIftWSdTPBqvx4sydUAqNms3wfAlcpApkOZ0IlPdSx3o3sKpoObbFqRFBNrajDWNX1C/0B2O/bBIQVl8LJqTe3fBiaItymluXpQL3DSGoFrjxtT/lyoAvggr1NukEYx/fRsyOIZSn0eeS0ZHbeB6q8cKir7cfKGmgjnJZwIVJFIbav+LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFh2VopaElzfTKLt8aBDjde45autjGvJbfnUGE/+gxU=;
 b=hYIIyXapqaJYGTkvsAvPUjnEtjgEfkxjXs+/T8QGKTj0JBD4CkT5fCdC79M1p8pJZWJKwl9iyy+XgSRSMhWBhGs2eQOXB7MEFdrsQZgLRFIDIQghD/aF9EQQ+JXc0wqPUpaSy63ftIHFzg1ePRXhO1wTrXX+F+ErvEspXY4xNZo=
Received: from CH2PR02CA0009.namprd02.prod.outlook.com (2603:10b6:610:4e::19)
 by PH6PR12MB844058.namprd12.prod.outlook.com (2603:10b6:510:3fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 16:41:40 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:610:4e:cafe::5a) by CH2PR02CA0009.outlook.office365.com
 (2603:10b6:610:4e::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Fri,
 18 Sep 2026 16:41:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 16:41:39 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 18 Sep
 2026 11:41:38 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v2 2/7] firmware_loader: Stop pinning parent device per workqueue invocation
Date: Fri, 18 Sep 2026 16:40:56 +0000
Message-ID: <2b524f6aa24ceabc0a4b1a91d2a86f88beaa24c0.1789749016.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|PH6PR12MB844058:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc9bfb1-5547-4c35-1bc6-08df15a3b6ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|7416014|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GLHxHcKkRQvF8fbTUsAQ0/hdtq5vN0NU0Uv4mIa9LFwCn7ZxiavBZCJq0zTStkfu3rNH7OdgqCbAihHSaWhgFDem2wkUQHCAiOoPPPICmnyCnoTQ7Puu/9B53mxWuYB8zXiy1NwRGsO0WtViu4wdXtjdnABsre+66qBO/wsWmwC0q4ckdQHJTJ44bMxaDYLQNThYzEngqa82RDTfiOJ2IZ/zMZsxkuCH/oChsxvv/Gsx68mE1m4VRCCPkmW6vCq+5sY8agEziDfjNxpEQlJXrTbtwPW6l2PnJYGf4WazcFUx/MP/ietVMOZbeTgMBJvDMBwFJ4nLt5+1mVvOmD6E9GXwU1uCD4ztytwL2SLgeyLgeB2j7+VkRHRb3qrKjZqLgZqPnx3IxnKMVJCprpliCuC26fkZ2gXe4D4dY3N2vKi1jeF+3wIllmy8nRU+uE7o+sJtRG7ytqRz2rMvzB4Et2npGi2/0X32jXYJpt2hKBlXzdnGOnPUBBT85pHgYS3ZPJ0tpyz0tgG5rxiYfWOzLyMZWdwoeYCyJ6E+7kE6A+fpxubPH79XjOICqTUX87MHUKk8g5P2URXeQAk+Yu3ZRoDjcbBb2ePndvrqRlf01Y0vJP5LxFoSYrXKgnyloqHHQm5TnnF178dfMYd1ieaHFLW0XA5vxsNCfHZPOQwFZkZwDzjR0VC4xAxP/VsWtS8VSDgHTD8uwefbgd7SgRVsVQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(7416014)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Ild9RcIG4zWxv/KDZYRMd1xOye1kVdgCNJ8Zk8SM4Qm6AH/WmOEzniIV+7YiJRKej4kmzwwMAUfrLKZXjaZhqEEq296ULSVdTmtm+r1IVAdNDXxUc+yot0DMYdFLeyfwExTCGV2xlyJxLSqnuf2Za+74AdaIH8KWVnmTdrC4j52xl8WGYCM8UI++AzEYv7Y/wwFslhQcBJYlZ8+EEWS3GKAnHQMkVujFyduqdj88gwRazdF3bPtldr36g6WExwp1tN6tkpwxM5nC87J1T2WMWguYo3hhreYMz9KEKgpfaIN0y/HeQrtTG/8nUVDzbX7JurqgA7XtDQLTDpsL2hd+qoqKZjMRHtU3Y+ZAdUBu/8FbF28F4c91Do4/3R3V6EZXp/weOcNKNKNItIN3xK2AogSjn4OqGREJxsMGXq/dNQrdCVe3mSj088PF/ldgUWZX
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 16:41:39.9447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc9bfb1-5547-4c35-1bc6-08df15a3b6ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH6PR12MB844058

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

