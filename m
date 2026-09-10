Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE93A531AE2;
	Thu, 10 Sep 2026 17:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059771; cv=fail; b=AM4i9zSLnF/C6tv+dkEkZqrP8mQ71hR20Y15lzGfmUPN00kDzy1o60TRyKidE3GV1R2CucZk2s/EmPAWtQOW2HWsBOOkvZY/2eZZ7PMr/Rl108giKhgcet6wVn+6iUvl3H3xOPOUxxMUVlDNeyW48nGAz7UXKrMXxih8Glf7Wh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059771; c=relaxed/simple;
	bh=vXDSKZelxNCKXKbYssSyB4TbWqvFFRO5sr9P11yiqrg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TlI5EUW1hsdLRYoMOCPqHMOjnX2Rx8hxMihNXbiX9zxGhvBZLubPB2A1TQZR8ZdzRod4DQMCSUV6+NgRHxrICWtebFAKj6lQYbF9+Z0k2awO5xOh12mPSIaIDNDUZfenZBrbSmlPKX/VfyY0Gnnb1FJ6uQoNrMZRlIJJRBBVRHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=maAMbPyv; arc=fail smtp.client-ip=52.101.61.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="maAMbPyv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ns7LjPnM5LUVjEOgnxg+B8P41adcERdoUY5lZVciYKvVeqO8jBdWT6W4OsmxO67RlbRLaG2ml4zllS3pt7YEZwaKMbBR32etXqPow7tHa8feP8KR5UhSnNINibkbJLaTILospENitvgl1Bljqw3XedBhtdWTK7lYDFAZRdR3W3hwgXUE5l3gsaEw2vFi0EcU5iUHSfUDcb2sxw648GLPUj7O4fY1PV2n/O0Wxujj5EaJwoqQUK8JQkzJObVtFBnTN13ubN1dabAwVE/1F2P84Iku7cWDdFikgLM2Eq+gZW0t6r1959QjYEEfOxtke3JEQWOJGoyZg7VQVHXhn9tigA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFh2VopaElzfTKLt8aBDjde45autjGvJbfnUGE/+gxU=;
 b=mzryIWeYWBPN4TEjZ6EFimSkM3T9wii9ASvow7q9U1P3nuklTgtzmQPIBGn52jZvp4uNZS4zIkR9LehopCP6+zIhRddMqK/eZi0PDtzLR24+4mtY/5vGNbJg6iFf5HJST7KoFlVrkmOGdkcvQqfZqA5sZqyD5ANF7bXO5iujrV3rw+wKN/REbFQ3nUK9tLZuLrLrL5voQwaY2LyBgEe/h44u7GQBE3C3mlzmFeOPoMpkSKq5Mv5oesZ+4TIXMzjODNN38cufQ7Pq2Xw/TkQOfue5TodJVEGoUjsyLWPCUKGjgJALXEbak/kjypWGLOjfEKnoPrizmifWS5oVNMQw5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFh2VopaElzfTKLt8aBDjde45autjGvJbfnUGE/+gxU=;
 b=maAMbPyvhkULL4cwH4VouO1Xx2MYvkUaMZkcYxe/WNtbjdyeVAbJ2vdNvbive1/tTYVFA6M6+oWjNp4fjOvha2ZrplwfSfxBBlPRCmufggijDFiO7dt4EXYiOGkaov9JUPpUMveWAJLY6UJ9PMUB0QQ87pLBXCmVHW4NRaaXAvY=
Received: from CH0PR03CA0077.namprd03.prod.outlook.com (2603:10b6:610:cc::22)
 by CY3PR12MB9631.namprd12.prod.outlook.com (2603:10b6:930:ff::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 17:02:31 +0000
Received: from CH1PEPF0000AD7A.namprd04.prod.outlook.com
 (2603:10b6:610:cc:cafe::9a) by CH0PR03CA0077.outlook.office365.com
 (2603:10b6:610:cc::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:02:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD7A.mail.protection.outlook.com (10.167.244.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:02:31 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 12:02:30 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [PATCH 2/7] firmware_loader: Stop pinning parent device per workqueue invocation
Date: Thu, 10 Sep 2026 17:01:57 +0000
Message-ID: <91ec37f4f318065d91ed03f92f521f02288aa59e.1789059392.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7A:EE_|CY3PR12MB9631:EE_
X-MS-Office365-Filtering-Correlation-Id: d21df671-2cef-4e34-698d-08df0f5d4d5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|7416014|82310400026|23010399003|1800799024|10067099003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	tTe6aiNcv05BOjhqSeIz3xGr1dInhVzB1u2PUQd3aDQrrgKVEu6zROVp8xXU18czOp4BYxZ4CvNuXBTp2dHb5pRhC1eGOASxfDY6yzP4nJVhXKc38XISnH5uflYQcz7hWN9ix95NEwM4A7u7CBL6odI2AwG+rpFBD14bu2i4J1EqUDe/9xWlotlyjde5MAISlv/jzaj3HOj1ei2JU0LVwtUzwuJeMFuoCjVC0p2+o0gl/Ux7OKpd1z9HKQv5wMjsK7QG9ENbH2tQ/+SYYhrhPVHoKLnDS5ijjqvL1ovQP8qnSQIKC1aBfZCvCsofGwYJe+6yqA9sKO7JRNyvDk4wYDrqAu/OnlWpnYcHQJ8wbzTvjibnWKCmX/n34fkl9rFwRCzlQ1CvSP5uqvGPNqfgBAvvoyw/7hELKulUwfl4SpdL0OIRDXgeqWGwObUAjEmb69WqHP2A8dNKQ2/Uts21GtDH9fAnpGiaVeirREeq4EkJNYLHzrZFJ6yprijc9JPPChaC/LelAcVAgCRVGB5OUNIipeIEllyGT05UD+PFzvNNKhLMyhZqsynZGImaIyIbMFT/BhCcXOgeG32Jr3Vbg8aiddt/uI4EofGX65nh6txCehIoBXoNRXxCe2LY6zxlnbEqA7v7pYX1jn7GeTl0pZC5uFFJ5SH7eNtPTIRbWWM3ZVRA+mJ4KuSe1dSkSDwFrdHHf94GB+l6K0AjIVDSAg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(7416014)(82310400026)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7UuOECnHlBIGUrSsCUni9cpHP/lNWX2rV4OgXuKDCGQhfb6iDjNpg86XvwsKMklVYzaMlcSpfEjflLH1VlXYDq7r/pUruMNxU2GXHw4QcY8zmcJTFupgM9n3P+hoiBc84UfNrEBVdyk6UPPhKYl32PzrGLYkKzKM38vtUAlqbV85pA8Pyio4QKc1Dmv29RlLEmLjUvGXTjYiaX0ZF2XLrXSkbMzSoRMgcBOyxsl/3Cntgsguzr3NX/9495XCJ6aL2d8RD1N2QFI6i/cx7V9h1fpw8vOakmAlEMB4jTqHZ4IxXlz3ypUv1Or/gC06fr5NOD23TMkzjXN96+PrVxgg62S6ct17Y8xGmn2lHqYw7R3d9s0j9LMhgOEY9rtpENT08+l++oWHTD+jH/BVCcYLn2yBfytcsnkiYqEwHP2YqELNf/44E/J0a+VPol6+6gs2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:02:31.3904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d21df671-2cef-4e34-698d-08df0f5d4d5d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9631

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

