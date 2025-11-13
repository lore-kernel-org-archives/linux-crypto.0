Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010064.outbound.protection.outlook.com [52.101.85.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C2526E6EB;
	Thu, 13 Nov 2025 14:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042898; cv=fail; b=Qv2NoXQQKPuOYgT4+Gp0nV41p2aymjaB0WYJpYFJQGr6oCPQ4TDvqD41B7WI+ADoJEYyKQPOUe/Cd4O9wT4+xXBwdLacBnZWSQUaH2j75rCao6/Kc7xRNyOGkjgoFFrrPtM/rY8ayv8+brrQ7pH9/D9f8Tz2QMT4lCejCR1m8pM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042898; c=relaxed/simple;
	bh=yuwLAnzaql00aWrHVzaS4g4i+9VFn7x9RN5Sw1cPf1Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Iuo+Zh2yJpQeNcDbvdHCwunFRalqvDypEwbaQxve6Ze+9ChhURfvhOua/CIUaFtmfncYN0roJSDXAoRCV1OMh3LWxPZjjZHNzwX3haFZt5f+0dASh721rddRJ3Om1c7jy0snJYqMvtGG+dVhcmtb8o2CXtTFaJhHG/Nt1ajG3QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=qYVw/Q4E; arc=fail smtp.client-ip=52.101.85.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="qYVw/Q4E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=muZeXdAPQCjXMu0KdNfuGCdXFnBYmj+KGlY7d5kFTHFKS/shulUOG7orhcfs/mdpWzzDTDtgNkBMIUW0I/SI8Sn3451V2w6NLV/VH4C4BMPhUrQb/g6U4bvsV8nDHcfJ7D2DMMvpXMcY6zstkXxcMmeBD9S2bVKXSSbORjMIAHjTMxnOqzbcbH3ZgDRLM0J18HD4obj79g9BlPi4oF/M0xZHGBhpMqVGOuKpTqcD+RS9JVtqmmE41Q2DpRZabWw2MM2IuYtNdSCfzuBgttYJnNTidzIBV+MeTmlfIMKagKFYeX+FehqgJd0QNzM1gv+9xZ93D+dqYOJ3n9ACy+rUNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xtt6sDC43pOvA87OkKbQmb2XXHqBmC/TW2rqThGAozk=;
 b=ZNRbcKO5KsPX66HqyyNLUdBaXdJpW8DgD+tU93X4hizXhqUjNHshBWl/6txiRZClnguRF7oJfVxMiee3pDNoWZubiZUVogtNX4y4Zh2WuFrmd8CgqQhnJ7W/xv1rvG6005eJoQ3sZowiAYAFNFIHjrbPbvXMoUUKL1S9z9ym7MfDTgcFg+BETk8h2LIILoh6wojdegJy5s0Dj70899XuLvTDnIrk+WQAAiJWuq4yJT3H1sg7dKuoGEmcdYEDgLfpKd4YPrCXg7He5GhDbqRA8uNwRJ/ulwKqVkharuguVI6AV5/mR+lqgVU3m3tHsGZ+pw5ORsyZUUXUGuAjdMZkCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtt6sDC43pOvA87OkKbQmb2XXHqBmC/TW2rqThGAozk=;
 b=qYVw/Q4EH/q3rXfg2IuWo+btqygzAC0+fkvWOgO9aG0tyxbUM+kVfw1N2Xhb9WTQ9LEjvV8dBuB8gjY18GiNYmVWx3NKJ0bg1WHT5RinrkIjX7yHEV0HJ/QO+OJhcDR+GmWDplSfaQEiqipFh9npmubMGqkh034upQ6gzM6LZYU=
Received: from CH5P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::11)
 by SJ0PR10MB4574.namprd10.prod.outlook.com (2603:10b6:a03:2dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 14:08:12 +0000
Received: from CH2PEPF0000009E.namprd02.prod.outlook.com
 (2603:10b6:610:1ee:cafe::76) by CH5P222CA0023.outlook.office365.com
 (2603:10b6:610:1ee::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.17 via Frontend Transport; Thu,
 13 Nov 2025 14:08:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 CH2PEPF0000009E.mail.protection.outlook.com (10.167.244.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 14:08:11 +0000
Received: from DLEE208.ent.ti.com (157.170.170.97) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 13 Nov
 2025 08:08:07 -0600
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 13 Nov
 2025 08:08:07 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 13 Nov 2025 08:08:07 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.69.191])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 5ADE86Qc385822;
	Thu, 13 Nov 2025 08:08:06 -0600
From: T Pratham <t-pratham@ti.com>
To: <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Manorit
 Chawdhry" <m-chawdhry@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>
Subject: [BUG 0/2] crypto: ahash - Bugs introduced due to CRYPTO_AHASH_ALG_BLOCK_ONLY
Date: Thu, 13 Nov 2025 19:30:11 +0530
Message-ID: <20251113140634.1559529-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009E:EE_|SJ0PR10MB4574:EE_
X-MS-Office365-Filtering-Correlation-Id: 11646c33-9771-4e84-2511-08de22be1451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TFPqBssm2M9aGWybZ4fAGOLhVgiekR2wzEJbK8payNpe6VrDOOpU8dmipOLy?=
 =?us-ascii?Q?2H0gwha5hksfYVjUso9qel9073IVpIHNXWPO5Ja/I+II+4NubT2pAIFLrEnj?=
 =?us-ascii?Q?f2WwbRxbMgMA8aresjZT0e9WdN4azdofqyiM+Bi7a0O8PpTGQut5wqW5QdiT?=
 =?us-ascii?Q?ZbSLFdnjjui5++IRtmAMONYCo/XK2yjMPsNF7lzfdtQlChfvwsS60UZLXqhY?=
 =?us-ascii?Q?x5QK7sTcuNXjdpXy/hqdhpaZ5ZWGpzfVgz5uOnsX/w2tPTcUtBWWOz2yfeNh?=
 =?us-ascii?Q?VvI6kD6yZowttDB5mngMIxDbGqLZ8xx1MFXKPAH6Aw8WUXCj9r4NIGamp7Gu?=
 =?us-ascii?Q?fyBEkapwSTOEmHv7Rqe0OT8oo7dmkjyEjWIK10Oz+NGFVroY+5xEfh/pY2cg?=
 =?us-ascii?Q?DtPKl79ZF9SGF5j6R7i6n6AU/b4GdByYkq9y8zd4tQyKs4q4sestIGVyEIda?=
 =?us-ascii?Q?/9KfaQvjhDjBFeTNt0yZW8vM7jWWfYhoTGSMAkuaEKkMDbsdVPEIGknQDRnz?=
 =?us-ascii?Q?TGN3KXxLvnWUd7gRK5Rj4aRHyV83lGbkffij8+Rp9CUFTnmTJe3xR0UGy3YJ?=
 =?us-ascii?Q?SDo5Abulgic75n3WkWeuCijvRLtHwlUgAPzj8AYHjLJi8NO150Vq1R23+odL?=
 =?us-ascii?Q?SEKv6R1Wu9cBcvDxhJsMtTcMN7eRf/6oLuFggW6U2vzHTsX5kIa4+xa32m/Y?=
 =?us-ascii?Q?wyj1NPKxbADSWNOb//rv7TqzHZnjatfR2V/P2D+MSkLxG+W5obnSs/79rrVt?=
 =?us-ascii?Q?hDSk3l6/NTt0fsTSa6hY+nSUbVCSNY6d7NwtYK8XQTmaiDzzFy2yR/QZfpYT?=
 =?us-ascii?Q?khdncmQmMJbdbMOhbWNp5erPLfE1EUwZoTKqCo1NG1aH7b19HgOMy5k+u4ax?=
 =?us-ascii?Q?nTxoxCDulgscoNg/+4ss2LsLiE8lQunn/KPlvd6xRK8HgyK6Y89sDhojmDLD?=
 =?us-ascii?Q?ebQ3uHD4I5kQEi1bOGoij03WREz0HnwFamAxjeeS1vRKSTipfDJJJf7tt85m?=
 =?us-ascii?Q?DigUt0zQyxyf1jDjIhEWFZSfbv60HUbq/nZtlVQh3/Q2wtp+8mNvgVK+TxzM?=
 =?us-ascii?Q?Rz7R9L0SJ81y8ljqBXTjPd5WukMo4qjquM+nHD20q021Y/CiuMjL66VkUh/1?=
 =?us-ascii?Q?MIctEZW7RWhDpSW1yYEFnZiI0pjTWn4BfAOw3jT/pVtFONuU2a04RR0fSys7?=
 =?us-ascii?Q?fEJ45IfZFsGjtfiGo89TXUi4QOmqd4txp934ovVk0XQCXpfFZ4mAQ1OjXYuW?=
 =?us-ascii?Q?tICtWhIXfZi+s1U4awheVgYtYMPdYYB8OLRgstLu9FJDWsXWfJ6dlHKI1/s3?=
 =?us-ascii?Q?l7Klwvxz6RCcVJM7JTOb8V3sWFAGX7c7+jSDk/0WZlHqe6mkVFSOenSAwpxu?=
 =?us-ascii?Q?34KQufQ6O932FMR+O6xpsUhH9tcxqHKfH/chblfioa5FbxAsFrrIny7+L9L2?=
 =?us-ascii?Q?jjJaYU0urWKoBVQO1ib3JG9se53N52eI0EVW7G9bEPPA+3nW7b9sp8WePEJL?=
 =?us-ascii?Q?IAaxLfOzFbE0ZiEVtbM6pEYvL7vCC+jh/KM/huybgvlNUHpqEdWeAW/4DsHN?=
 =?us-ascii?Q?JSjsoqtTzkwesSszU10=3D?=
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 14:08:11.2254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11646c33-9771-4e84-2511-08de22be1451
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4574

Hi,

Commit 9d7a0ab1c7536 ("crypto: ahash - Handle partial blocks in API")
introduced partial block handling for ahashes in the crypto API layer itself.
This enables ahash algorithms to return a positive integer from the update
function to indicate the number of bytes in the input which are not processed
and should be buffered for next update/finup/final call to process.

I've discovered 2 bugs introduced due to the above commit:

[Bug 1/2]: import/export fails for algs using CRYPTO_AHASH_ALG_BLOCK_ONLY
[BUG 2/2]: testmgr false failures with CRYPTO_AHASH_ALG_BLOCK_ONLY

These are detailed in the following messages.
-- 
Regards
T Pratham <t-pratham@ti.com>
