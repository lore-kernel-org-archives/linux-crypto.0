Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010061.outbound.protection.outlook.com [52.101.85.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD483EBF05
	for <linux-crypto@vger.kernel.org>; Tue, 27 Jan 2026 07:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769497342; cv=fail; b=DR2SaZpGiN77ljRBbRbWw2qLmPhM3dIGn3VTpo0/Q8XOvadZi2jZ9mty118rsE4O7BMfsSR/aYNwk187Q6Ku+VUbkp7hMLuQ+oSHKeVMXSNTdPWnNvRplSlWSumTEgwNhyjCcB/7tuT70sm+UhZGVaFyYFCPR8SSutJPgHTKnHY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769497342; c=relaxed/simple;
	bh=B2ilX146xZUYgGdhJSSiXYZiny1gSsoleSxEKw2VqBM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Shk/4Vc38jdO6jN6VK0YS8EwqYe6eAmN90igciFMrbOtQoUBvSy9tBTdwDmK5NCnDgePAW3IrhtMqKFd7ZudSFXHHA/jolrJqLEg1pKvIBQZ7yWJf9lNuNBaFZkjIpwHOLXx3/uG65M2XhWUyfMaPwA2SuD3AKwQw0NeRW04xx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NR53SVuS; arc=fail smtp.client-ip=52.101.85.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NR53SVuS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aZq+goOigZd/5YnyOzPVKrvoJW7Ki36wM+QVrjxdMqSiSANXOFU+Edeh9LVKQ89WN+V8TbDEpuZ0V/rETUDtbpz2aZPeow7S20yoMc6taE+Je6yn2SJFEanlC+Iew3gdfP5aruEhoYwr0SxydoeU9duOb2fbJz8T529AptTsM5O1Y/Tc8Cwxr22FWjLosRIZfaQjC8pOzrgMlX9JWzcQ5AYY02KkUC3mln72icK9AUToGYwWHFNRBINkqcFFew6c6AkfHWXZpgxmdYu+jsE/C3GPRwfujCBSrPK72EJDShVxtMl8bo1AhKWuPVh3oODqvsWdHehevr6bNApWlg2VwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4eAMpEHDJNSQNdEI7YBNwr+fNBoKogrwkLhQ65LrRc=;
 b=XRzu7A0Phv7VlEaupzXp2cJmtx/cw87npqMpmKiD8iprKHjPSvnb0dzXVQJyLR9xEMzLysrOiLbkE5akG7W7qCjOA1A0tQZb94UI0mQHfTMV4yfF4En/7oyDlY2Wrf1Dad859t6HluB0HT6+OI/3MclWP9Z0KkTnxG3i6CcJ0cX+c7ScvA35vUcc6zTNF+yXKMFIN932nQaSR0qkqjwEzH5BQ8GFfetKu5g9FGttVBkaR2+4XLvpY78fjcP8aiRz0p5nMJQorcIDB9UvGqpFCTdFevE/1bFMznb5I6q//JdnRjWLPA192Ij7GB/16XRCE6bWwFivoxR7XmPuhFKHyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4eAMpEHDJNSQNdEI7YBNwr+fNBoKogrwkLhQ65LrRc=;
 b=NR53SVuSDEsPlxHy4YDEwu96KttFAixdm1iGQYROO/fE9IdRC3/KwwNh5HLEqyt6Pigj63hn/44Yyem8L6fZni71u67pY5XXe4GD/5h3oZc/EzVXe6xVy6vo6i9EuWaW9LT53gYTvQnw6pY2+z0JOyVCOe8BnIlW4WsFgaf0TsI=
Received: from BY3PR05CA0001.namprd05.prod.outlook.com (2603:10b6:a03:254::6)
 by LV8PR12MB9689.namprd12.prod.outlook.com (2603:10b6:408:296::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 07:02:17 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:a03:254:cafe::8e) by BY3PR05CA0001.outlook.office365.com
 (2603:10b6:a03:254::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Tue,
 27 Jan 2026 07:02:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 07:02:16 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 27 Jan
 2026 01:02:15 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 26 Jan 2026 23:02:14 -0800
From: Harsh Jain <h.jain@amd.com>
To: <michal.simek@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>
CC: Harsh Jain <h.jain@amd.com>, kernel test robot <lkp@intel.com>
Subject: [LINUX PATCH] crypto: xilinx: Fix inconsistant indentation
Date: Tue, 27 Jan 2026 12:31:55 +0530
Message-ID: <20260127070155.199790-1-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|LV8PR12MB9689:EE_
X-MS-Office365-Filtering-Correlation-Id: 20aa9003-f857-48ee-3ab6-08de5d720149
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W8rtHJTFYfTD0LnPjhoRIw0bfCc1FTZbTCzf4mVjMq0bKFFcF3w+K97N7Tex?=
 =?us-ascii?Q?YFtx3rpPzdxbqMKepOjFun7CIUaZeXxzQAbKqnUz3lKcJP0ODPxblfJn8Ldf?=
 =?us-ascii?Q?tBuDkCNXC7Bq9Vga6BkNUHZD8S3wR6cKoVxx2WAg/rj4cMcsJS/WfLdjxYAQ?=
 =?us-ascii?Q?mzjOR5Ss2veCZFQqIEJfawnAqEyD9bfqaMp3AYSRvfPmNVZj9umGpCO7Jz4O?=
 =?us-ascii?Q?b3wiLCwU45YOCZWOuU7dNgiaCLk1cLntPB/NHS85a1z+dlCcndgVV8VrOV9T?=
 =?us-ascii?Q?HhgU8HS3h8Y0AWowROj+/cMhtIekLG9cHf+22vNDwECCf3+2QC/ojF6tRs8m?=
 =?us-ascii?Q?EH/nNwv0aIfRWpcoahFNlgV/0qEUYhhr7blcFgpRm4IF2YxL+DnCEGO25eue?=
 =?us-ascii?Q?SsUp8/i4Lw4ywHdZq6kRSgFh5qJuNj562myqqKuxQjm4NT3SPI8Hx+trScpn?=
 =?us-ascii?Q?Li0yOGuF87T1hFzpIezMrCw0EINvvzN28hYKKjfdoEY1M4p/khYz52Wx3hE9?=
 =?us-ascii?Q?L7sP8lhJLq8TbYHlD/2TamV7Im6MTUbeMGxD6+v8/mvig6XHOJleT/hfN6HP?=
 =?us-ascii?Q?OtnfbjlLtsyNGP2SHzp/7BCjAKn7RwZNPI7zUxi3+7uaQB5P7sQXLPOXd1qF?=
 =?us-ascii?Q?mvlJ/mgvFU0qJNWM59BW+ChQI8/NyKPKeGXbsyHa13HVoJA+VI12r/3bnBnn?=
 =?us-ascii?Q?+BX4byC29z1jZUstPVkT2bBrLscie52WHWk2lLx5QHfkZJ224gJ1GMJgnLSq?=
 =?us-ascii?Q?Re338nSxXtudxB5SXC3eUoMB9Tj9ex6tuwvUGwwQ1CAvhxrpeYPUqHwUh+rK?=
 =?us-ascii?Q?NMRd6B8RanElRgV4n4eZuc+7Sqj7esPOtO22JZrUIo0yAzciPzOEFjaxIjp3?=
 =?us-ascii?Q?VH+h2rbCxmDH7YEJWxHNfywwmYp/+pQ2o4qeowp3sb2XV3PwdFz4/UKc/ycF?=
 =?us-ascii?Q?NtIAU2Tj5SNIH9mjke3FqmbXvxljJP2lLPOq1jvWNU3CUjuqO5NkWyKi6Dnx?=
 =?us-ascii?Q?/gQFkdk4Dv5RZeByCWELPQApQ68C6mFQiMCptCE1DIFSd/3pKskHQsrN/tm1?=
 =?us-ascii?Q?YSlTXrmzSImyVXgD+DjY61Tpk7qzFu+55a+7v0ZE4BUVjOnXnY6xqmFdfoiy?=
 =?us-ascii?Q?+neO5w+8FbaSfcbvxj7G3lKHJtukOaoQfXxz40hHtDHpPk4A5d9nnUIRATLB?=
 =?us-ascii?Q?yYWPX/wyXZ0h1cWcQOuajDL6LM0ZKYG31JlkZw83xMDsjQQdUb7lO01mrSZ9?=
 =?us-ascii?Q?otVbr0lHVLQbxEnDlROGe4t44+4cuhYafi8W4gQ3dS2JUJj4vNE7mPkwMyea?=
 =?us-ascii?Q?dCY+gmw9yjblKkPDMNXcNnci/BQPfANg/+1UZhplkz6EjWrlsLZ0ZEKHNGlU?=
 =?us-ascii?Q?vLqdMId4QfKiW0RYNfjqlyCOHQiMtYIhkP0a5JLgcgYY7JS9aKGl9CXX+J0E?=
 =?us-ascii?Q?ovtOcaEsOJM6usSQBtC35NDhwPIrfLbXUaHv1cKX9qvrTqGh4jGrwe+BiZfN?=
 =?us-ascii?Q?K3/E1P9KRK8N2EEfZuxJUjVzGGpnoktr1QIoKNuI1Gw8X5x9BlCyAzGJlW2j?=
 =?us-ascii?Q?XnRGXe9Jdi19oE+BQamvAiOlKSbKbcCvuj4dZKL1m0zxyNQvHPwWv8/5ivbD?=
 =?us-ascii?Q?6siOSmow2Uw8Bf+ln714wusKRFmLBve2csWNnckqyVOBVuhK0FCMxkIGqgmc?=
 =?us-ascii?Q?P0JRwg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 07:02:16.1652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20aa9003-f857-48ee-3ab6-08de5d720149
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9689

Fix smatch inconsistant code warning.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601251908.baMDVVgW-lkp@intel.com/
Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 53c9cb2224bd..2421bf30556d 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -984,7 +984,7 @@ static void xilinx_aes_aead_remove(struct platform_device *pdev)
 	for (int i = 0; aead_dev->aead_algs[i].dma_bit_mask; i++)
 		crypto_engine_unregister_aead(&aead_dev->aead_algs[i].aead);
 
-	 aead_dev = NULL;
+	aead_dev = NULL;
 }
 
 static struct platform_driver xilinx_aes_driver = {
-- 
2.49.1

