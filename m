Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010011.outbound.protection.outlook.com [52.101.56.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C621DF271;
	Fri, 23 Jan 2026 05:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769146337; cv=fail; b=YTYJvE9WjEfFWIEgqGSJhdgH/ncR1mT8eNfB8B0cTwSOwi1aIyZd7xDFlQKseymggU+wfgGeiGzirmkbdCyEdlGXQPE7crrOFhAO7xf9IAiA7YerxIzFOfu7SfBwwtCAyXvoGjgjtPyqRBCvMscgyCPYRmXfQUk14JyFDSmTe5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769146337; c=relaxed/simple;
	bh=KAa2YpMCYtwsMT8tT+JlEFoeVvwr2yr0huTnLeCOEhs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YUmtM9dIu8vfFphiUtW63/rZ8TaUD9GalHzGQqFojlXgsQOYA182WTOSTxcGevrCSyVntYj8ZIQ1krdnX7/hJnHcHQtQzGHZqzKoKH8NCc5zihCb57PKMtUnmfr3UhJaPoXFVhwVixCevtW7QVL6U3/YkcO9QJJNMySf/aiohdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CiUoaUg+; arc=fail smtp.client-ip=52.101.56.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CiUoaUg+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BBm+TYqEwlX+6laBm3hYKJnUemMFByF9EhF65HlUiqqZpOWKSZf7rzOFXnX4mD3vVvPw712Zqjvr6HkhZRSZznbnugURKOtNqUa/DLSzpe43tqRih/7Bjhg/z4Q0/xfN0JQQ7foCpb6iia5njvIMxkqgajLszGBTds8lU5/qB0q9yfFj2nBAOKBU9btn+dQcmia79SHderZIHmJdEZTC+F90HXm1tF2NYcRNQ7ldpOvbGg3FPjpl7id0fUxSFi5wD+MDyp6NWrpDyI7MOhXGBTPVd8n4WQYZegGYDqLhJUY2/+G2/AFK4G5mM9fWjJQmokOSuMiFuoe5bi7NL4ePGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjpcTTgH2qSbrsIMnCguMCv3ES4wEPy/vkkBR5aPrAs=;
 b=i/LfbybfKlSEI5+YYooJPDpW4hxWy5tKc3Ob6QwMxDxIyXgak8LEwa3YTsoA4/yFoVjdbnV7RuVfeqpQ0TLgRFZ6gcMlkN4KxNzKVtqaC56siYdHppPenjRsRgSJwJ5cwvb3sj9jEPlhJAR4Ky1o7BSkSUbNAuIpxy+OoOP7LshGGWnQz+MpgjFtab4MOq41/2sDdw9hAxYUQjH6QXQwQVPOgbS5Z8tluyhuNagtcwxVwjglD2h35oPcrqLp9a1GncFpHkmCMqoA96hm2JL60c3h2GeM1YHkdNRMzNUbrivGnDQvYBac94EhEafSmPKb95cqvW/31GUc77kskDv97A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjpcTTgH2qSbrsIMnCguMCv3ES4wEPy/vkkBR5aPrAs=;
 b=CiUoaUg+63nf17QfG21f/IjdfDYq0nSLV8o+8jvPZwKHkcX5l8Mt5TenGOH+i61f7EbfZtvEjCgbxTFlAsfyIS4QxqfuplROo38XltVX5qrkte/PoUUTpxIaOeXWbO8pQwKyOP2vES6UXeFrH2xF1xzulSUWKMfCohu5zaI/acU=
Received: from MN2PR11CA0014.namprd11.prod.outlook.com (2603:10b6:208:23b::19)
 by DS0PR12MB8293.namprd12.prod.outlook.com (2603:10b6:8:f3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.11; Fri, 23 Jan 2026 05:32:02 +0000
Received: from BL6PEPF00020E65.namprd04.prod.outlook.com
 (2603:10b6:208:23b:cafe::2f) by MN2PR11CA0014.outlook.office365.com
 (2603:10b6:208:23b::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.11 via Frontend Transport; Fri,
 23 Jan 2026 05:31:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E65.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Fri, 23 Jan 2026 05:32:01 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 23:31:54 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Dan Williams <dan.j.williams@intel.com>, Alexey
 Kardashevskiy <aik@amd.com>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	"Pratik R . Sampat" <prsampat@amd.com>
Subject: [PATCH kernel 2/2] crypto/ccp: Allow multiple streams on the same root bridge
Date: Fri, 23 Jan 2026 16:30:57 +1100
Message-ID: <20260123053057.1350569-3-aik@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260123053057.1350569-1-aik@amd.com>
References: <20260123053057.1350569-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E65:EE_|DS0PR12MB8293:EE_
X-MS-Office365-Filtering-Correlation-Id: 0351c0be-c269-4b82-7c02-08de5a40bc40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PCtuuEo5CURBjAm8TE1ve8raDF6VF8NoYbgS00xqaPAJIBL01bhLuQ5nCE6D?=
 =?us-ascii?Q?cKyBBXVuJa2hKYe0ztXejzmjhe2UWtqG2WebfVGcfBq1gpyFaA6KIBAqtTv4?=
 =?us-ascii?Q?Zx1o5Gxw4y3TizwqSRSS9wGcG4fp2dBu5c5jv//uT8yNu92gU4MSp0OeDdDF?=
 =?us-ascii?Q?1nta3v/XdjzGkGYOQ64CktTsSm1aYHSvWq72FSpcYvcynK5l5wv0hxMIYt7j?=
 =?us-ascii?Q?SfGEOZ2u5bcmtUBcZAW/mh1qRm5PBpy2LcJjdHznP2aDduSbRdUVkn7QN1ms?=
 =?us-ascii?Q?7Y4uam6vuxkTje6wXlGqhyxJoEGIoiwY+iCQv0Ab90bZvwFuXTw/rY4FoSgC?=
 =?us-ascii?Q?J5ytU8fArUr4dxSO9aiJ2ip+PxJSZFz8YTpfGFGsxa1WB8ACkhrMawmCYq7B?=
 =?us-ascii?Q?B/JTrDMuMWafvglnv/aMLcUNclIXGF4hy/S+S227NK5xWfsOzAsdBfi9I+Hn?=
 =?us-ascii?Q?wdgSQ1TNOABSyQTsLVax/ben72nKflSqTAUbgIoikC+GryXAgdKHxSXKjyI7?=
 =?us-ascii?Q?kYyMtkG6HQ2elLzoFh4mDwfywElRlO1ttp5uqRJCL9i5vlJBt1ZE3v6u/UQ6?=
 =?us-ascii?Q?mAZskPZ9IOAaS0UyvU+RYVV5eyV8slL5ZjUrgr77WMt4fD9UDurZWnsyG+9f?=
 =?us-ascii?Q?1+5akw4C4A0FLl/J24qUY5gX/eI7h+g99na3xBWQ0tgHnAVmSlaA0kxTgZOB?=
 =?us-ascii?Q?jWla8zPxLn0/Uuqnws782AIUnKFUDLe5VFfPXz6PnIInQEd7pGJH3I3zTfaB?=
 =?us-ascii?Q?lSEMBCTDOJ0EuWjpHmEE6AJODpbssidyKJj1XIxnfrsAAFvJJ5rSMe3VVkbp?=
 =?us-ascii?Q?sVBb+11d79Z3oCiZUA1XLD1zAFMZUYljqlUue0JI4uKZTllz7GfpafhB7/Wj?=
 =?us-ascii?Q?Xo5KInAyWnwsC8ADjqrvNb6XvfiL0NK1i33vLFd4lH0q62D8H+aZQHV6PigG?=
 =?us-ascii?Q?RyVI3fjgzGU4mNzguyG1CPChrfEF7AZve14M2QScFHTkctS3suBq61+rX0rK?=
 =?us-ascii?Q?rod9/VyI0ReCHMeWk0uMRkS4izWICQLqu6dcZ01O0BynVlbbyc1QJmicfS/L?=
 =?us-ascii?Q?kkPxGMq0CcayB8JMqxavkkkcWPBmIVpBYDrMqAu4re/XRfP2AvOarLVg8OSX?=
 =?us-ascii?Q?o1oUJuBfUgAVZWqKxbewHXTNpWuPb9ZVs9qXxhJ3Md/7c/IHFwpTxekyAjbt?=
 =?us-ascii?Q?EqYZgpFqI7MQ1uHKGPhcyEIqm2GzfinefqSk7zeA7UoOWzsvDWsPC0Ldf+ep?=
 =?us-ascii?Q?97etIq8TT4GBxC/A2LvVnBL8Jg2PsM5YCb3nHsUCgp2bOvOg4GMosJGoh/ym?=
 =?us-ascii?Q?WNy74UmgA7gJ7OcIkEOiHzCKlGdSfBFLr0SKauMYBhf6nYN9iB9+h8o3W4Ye?=
 =?us-ascii?Q?AAW0/WIe2C2qlrcUNTR+7x561j8m75PTIvT6VRjw+IZjylaUgWdhMfVoPOZ/?=
 =?us-ascii?Q?v5rxPwy7Av1wLB9RhJlAle4vzUeS6TSKOnjHV3zH/0HUerc+ky5zllroi94+?=
 =?us-ascii?Q?Xvi4iESn7qhZqrzfrJIZYpMdSD6dTvjmb+t3edKIylIDQerz3V+FVQ9AXQpJ?=
 =?us-ascii?Q?arftACRHHoPEO19aMt98yh9uTqQnrZSXmcsOSnSJM3JQsY+q2cmpYOAtJtwv?=
 =?us-ascii?Q?6RqecW+sXI/R99k9zTOnt8v6JbLn1u9qkr1XzNBbMYfA+/i0pD2xSLbvuLOP?=
 =?us-ascii?Q?EGz2iA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 05:32:01.5493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0351c0be-c269-4b82-7c02-08de5a40bc40
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8293

IDE stream IDs are responsibility of a platform and in some cases TSM
allocates the numbers. AMD SEV TIO though leaves it to the host OS.
Mistakenly stream ID is hard coded to be the same as a traffic class.

Use the host bridge stream index for a newly allocated stream ID.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 7407b77c2ef2..40d02adaf3f6 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -198,8 +198,7 @@ static int stream_alloc(struct pci_dev *pdev, struct pci_ide **ide,
 	if (!ide1)
 		return -EFAULT;
 
-	/* Blindly assign streamid=0 to TC=0, and so on */
-	ide1->stream_id = tc;
+	ide1->stream_id = ide1->host_bridge_stream;
 
 	ide[tc] = ide1;
 
-- 
2.52.0

