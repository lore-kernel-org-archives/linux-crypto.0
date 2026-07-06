Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011066.outbound.protection.outlook.com [40.107.208.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAD938E126
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 11:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783335809; cv=fail; b=XE6VMJ+TnmmQV6qSGqDAF+WMsnUT3LKA3AdMtRT9KSX3zaSeUY2v9zbwgrpTB4kUMAZ9JfgcWUh5Np+WE0DWvWLIuV+Y3NYsi/8E6buL1C5xpWmfi4mwLGQiRjkhpL7c07PcWb+TKIvaqOWS3cBS3FdQC7HfSCaNYWzlUg/YTyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783335809; c=relaxed/simple;
	bh=eV7UmSUNIR459Vy23mO/+vO4hTFAH6psze6rLkidRfM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+5PMCiXOmP8cUI05KCe8XejYB7MbH+Lg+xDNr0Bn8of8TGJFLEv2yfw9yro7J7kNNUXZb8nuRlW15b/xdjUbe5/j3ivRLP959r0f/ETAD5Uq3zqri/t+5YsGA9qjpRnscSwcyIdEY/cncsZzbKtFUTkC9e6QjX6F/yWGmIzycA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2zQPiUTU; arc=fail smtp.client-ip=40.107.208.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2zQPiUTU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KujXB7M3ObVzzEOoqXzSt0eyZKMVwmFPK8Qo5xqt4IvsRagN9xn6AV35iicUomzxrtd6pZ8sNzdrUmVO6Hq3VrErtApIUgz/Pkj+GL1iH9nBG0+5DVW0XWBu6N7hX9e0tj/VSg5m80M//xeozEbmpJJQJeFsj6MZ41r8LVp4fJbBIc2aOaTc+nPMs1hhN1diVc+TkCJvL2i0L3lmCsiafjYEvATQDksVRJ5a0rOj1IKt/k1PlpRLfsnGN7oyCC7FgsxGk9ZW/bJTNmZro+NdFx+G9eopeBwnz8u3xVT/HVC+jrOP/OF7F3Psa8VbV2nSl3Vv6qkxd9JyP9HHsFidyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7hN2tyszfYtEwGjZgCdCZX9kOacMkCu7WOFsFE8o0Q=;
 b=KR7tv4/zOING8sRFnQOe1UcBhcsrLlgJ6gQ5brT/NAjDWv4coo4HDdzb/8uSFCrEiuFAelm30JEdqaVMWJ/K0IMmSa70QedHOP6Nnvhc+iTC9+271wlhDX21K+FCzro6P6KgAd3S3i1IPyKCQh0ggbu4a5kiLJZXdgiSbVZ+95+fFhln7ZMdTnmhfphUZomY9CR7TMiOv9M56o5ElsyADLJn2QzDirRvAADnKAfx11/w1tC7Jcg48efXdMs1sF/3MoHrh1yXe2lSuYfwALVTPw0cggMpoWGGZ/BNaWXrh3vTKQNxRKQuSvtSU4oETjvhT5CdqQH3GUTfkoD8iSDSIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7hN2tyszfYtEwGjZgCdCZX9kOacMkCu7WOFsFE8o0Q=;
 b=2zQPiUTULYpej1wMqJRuhV3UT5EaJhRdfatBSQHHAaIlQFGPX2GhOeigGt/rN1qDKJrw93AXg3CGuE7XPLmQhUZM8Q6xlJjcuww/WWCZd2dD5hCwNIL3VlLeVmKFldOiA2RyX7W886B6khKo9Ko39T7T9gXnf3TQzd0FFnl+F+A=
Received: from BN9P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::18)
 by MN0PR12MB5740.namprd12.prod.outlook.com (2603:10b6:208:373::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Mon, 6 Jul 2026
 11:03:22 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:408:13e:cafe::aa) by BN9P220CA0013.outlook.office365.com
 (2603:10b6:408:13e::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.19 via Frontend Transport; Mon, 6
 Jul 2026 11:03:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Mon, 6 Jul 2026 11:03:21 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 6 Jul
 2026 06:03:20 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 6 Jul
 2026 06:03:20 -0500
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Mon, 6 Jul 2026 06:03:18 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 3/3] crypto: xilinx: zynqmp-aes-gcm: Send firmware decoded code instead of EBADMSG
Date: Mon, 6 Jul 2026 16:32:54 +0530
Message-ID: <20260706110254.2427551-4-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260706110254.2427551-1-h.jain@amd.com>
References: <20260706110254.2427551-1-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|MN0PR12MB5740:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f9e1a36-1b50-4c9c-cb58-08dedb4e3155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|1800799024|18002099003|56012099006|11063799006|22082099003;
X-Microsoft-Antispam-Message-Info:
	dxHO9wLp9LRvZV/bQgMSm3kbimMNZ2dXyXh6hjmFMnUkwwToVvrIn2mqBINQmghGvM5m5Y/5KlwkH+TZtS/v5L2M0MF2kCVIW4rHct3XIgRKhfVVd+G8G7gIT3J26bJHH6bB/o6eYq4UBOv44CpzQaG1vXD6MJ2f4EOr7Z97hPpa/Dk77Huj/a5QkqY3z9HlyqFYTBfC2GycWwOPFjSg4qc/tQmmzhgJESSvFWECrdG+3j37W9GNBBOBynPfzYZ1bOcil23aFdQuzdYn88mbjx+5J7EKDz36yy95WWuhgNNxQUMqDZ7LHkWoENqLaohQNVBXeYrlhVzOfG/F+RpWcOBGWoTITan/L0Yid/aUFVEo/heXJ1XyCaO9GzYh4IZTfCDpdFDNtXsns14sYbhAuZgplW6OWa/jupw9v7tLJpM9rMj3PYDaIl9yhMkkw6tnpI/XMwZ9OHzlSNfEwVRvwmysV2bsYQk6t02duDD4sUYbcqUlGmGWM8OWtiaCrvEsEEkOFbV5PEZVVG0W4W5zA97hTXZQbkBygMjv0mBOKV9yx+/dNbRtgvaqVOXLrJolI/eez9mxogmW0u5XjvIZFfQYOyALIler2+nmWA8CNkPs01WAYy8DxNoOFPbwjsrszhyv2xaYIN0VoNoE4EQQfDzrKboA5CayJw8gF283yZjjCYDJilT4cELuSzICt1YhXwJYGw1qLAmmDcOh7zUxtw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(1800799024)(18002099003)(56012099006)(11063799006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vTgPJB7eE6Voe2raPc211zhCqDdbd2mCcjDvjbEKn3MbwqA6cWoH7aqluzNuWbdhqYdoxibB+c4U7aSfQ1xkQJCRujN9OGdN9ChjNv6IMIuqlToEdv15FWRKDX5FbS8rNrLryt789Ss+M7drR6LSWgOy7bxinrc+PIu7AAAZ9Lx/uwT9DDZKCrsQ+GY2Qd9b4olwNhBCv0YKKODiJWtmeJBOtLRxEimalpqwFDhffsbOUO+howpeXGwL/iRho2MntZ7lHU69cozhqXXEO5O95iR2ezDu8STQytqfUVR7Ef4DM8/s6710jbo5Me2vcIoUKo/8oM2WgoL0o0KQXVHHRUjKjkM4b5ea6jaLZDpkGNlQKOi8p/zFNVcFcbSlWJ+qMhnLIGv4j6G7sL7MXqAfy0lStYaHDAOzj1Rm98tnJzVjgbXNSkzWcEU4bDOQkzXG
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 11:03:21.4400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f9e1a36-1b50-4c9c-cb58-08dedb4e3155
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5740

Currently Failure in GCM AES decrypt is converted to -EBADMSG ignoring
actual firmware error code.
Update driver to send firmware reported error code.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 2421bf30556d..7fcdd56f9046 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -344,10 +344,8 @@ static int versal_aes_aead_cipher(struct aead_request *req)
 			goto clearkey;
 
 		ret = versal_pm_aes_dec_final(dma_addr_data + gcm_offset);
-		if (ret) {
-			ret = -EBADMSG;
+		if (ret)
 			goto clearkey;
-		}
 	}
 	dma_unmap_single(dev, dma_addr_data, kbuf_size, DMA_BIDIRECTIONAL);
 	dma_unmap_single(dev, dma_addr_hw_req, dmabuf_size, DMA_BIDIRECTIONAL);
-- 
2.34.1

