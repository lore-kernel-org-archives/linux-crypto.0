Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2074.outbound.protection.outlook.com [40.107.212.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C066E79E1;
	Mon, 27 May 2024 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716823635; cv=fail; b=VX+cg6xn7gOv/0EU5ublcDTUGN5h/AOmhJxLyQpl9CavSz96DbrUTjhUZ+HmPfL/lEn5cAAsefRzCOnBgTMU8isGrBlLhubmnvqvV1nK+81A13w4HnbNSgTlSJlBDZm1bfYspQY2OVgmF5YfnUUK7pEqsMpW7o2UpDsxFyF8MgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716823635; c=relaxed/simple;
	bh=APQOxSHd1wyB2H3amYyZdq+93SYWQAp2oKzHBJFqbl8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Vtei00BAp4qJk/cbmupQJYhw+1TVMswK5xj3zRaczWIukj6kERBeY0sOObWeQP+McARPDGc6Z8GqORCawUJ5V8Vp88UCiJi6/PzO+QZeV4z3Q5tvvwi1DZpJDkkNBMVpzFy+GrVrEGQmsbsdbJCgXk3E+EapU+CcuQqzfKOTsKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z4VjhF2U; arc=fail smtp.client-ip=40.107.212.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z4VjhF2U"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+mOwGgAiURthEkA//WlotxlVkr/BXGuWWVwtQJTvVg/yYKD/gT3KMPSJsImRcLgWK+y1joEOizuIaIKPBnzVYrpdhyNX5NdgIEEvolAhF8b8SVNGQTlfTGIcOe+8crZYQQ51JlVBNnnIkoJLOhf23SJtMLY7Ai458MYBzF5BMm4JSPU8S1RPDB99r7/K/e2Lo9wLyzCJsla2fA8MoVAD0OAlsrInsHJP3xWZN0JB0SVsO3qk4CZ9dVSHpVGd6zJT9yYLh+tPLKNTfJySkNeshfzJNLVMWbGXBkYkGOe6hVNHAyiC5CbQdFHqBDFACuDhdJVjGeH8GcM9PHZWG472A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBPvehI7bTMsWP6XttHcGMd/kMgAZhonQ8m0020X7sU=;
 b=N9479TVKJ01leQnWIg7FrE/vV/5e6cPLpXKpMvyAICE1ijcDZ425rOBBiQazzYWlkC6FrbLQyTxrk6uFtRMEk2tdwdIPwhmpA2LUgOS9VI3TMrxoH7ss4Hkym+A92IGBRrZBuwQgY+UdAgBupBmbT3AhB2BVRzAUWmtTXxaZ/0i3Yi4zGGhHtDWAgFKUeQuqDW3UmuSCWXsCOVlFuZOCAs+IXq192UPnM0g2glCRp5QiTjfo4LmcNC14dwLAovjTZfQS83IDQj3UhXpF7MwWGiNGTrjzKl47wnupsQFAsqp0dbqtaT6cf+AyL01s2C0qLCp85zDMjss27ATO+CDZWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBPvehI7bTMsWP6XttHcGMd/kMgAZhonQ8m0020X7sU=;
 b=Z4VjhF2UWF9X5zScBngU8e26XAzQLtWTOcXQA6nwqIiAIrq7rLvUYmCB7naJYhUHj7KKOly9YZm8QgP4FlBsqaFk0Bx9nFpvSF5P288Dh3+suG+IS6zKtkNHWxDNwQ5T/kFM9oOauF+WgQzd9Z49dAx3GRCKSw955zCmI9MXFDY=
Received: from CH2PR05CA0028.namprd05.prod.outlook.com (2603:10b6:610::41) by
 IA1PR12MB6140.namprd12.prod.outlook.com (2603:10b6:208:3e8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Mon, 27 May
 2024 15:27:10 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:0:cafe::f) by CH2PR05CA0028.outlook.office365.com
 (2603:10b6:610::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.16 via Frontend
 Transport; Mon, 27 May 2024 15:27:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 27 May 2024 15:27:09 +0000
Received: from AUS-P9-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 27 May
 2024 10:27:08 -0500
From: Mario Limonciello <mario.limonciello@amd.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Mario Limonciello <mario.limonciello@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP)
 DRIVER - DB..." <linux-crypto@vger.kernel.org>, Richard Hughes
	<hughsient@gmail.com>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] Enable PSP security attributes on more SoCs
Date: Mon, 27 May 2024 10:26:44 -0500
Message-ID: <20240527152649.3722-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|IA1PR12MB6140:EE_
X-MS-Office365-Filtering-Correlation-Id: 516c5155-100a-4532-3d27-08dc7e61797c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lZyLu1Ft8e03jZiihhmMHdDvmTdrYeDIdBAVJwbuOVk4zQ6q2i+7zD+nyrAf?=
 =?us-ascii?Q?yCSWok+UpInp1KI/chdf8OAJkau9M52CchGtlshzhzCHGrjZqJxsmdSHBoMs?=
 =?us-ascii?Q?QIk3QGZ+cSd0MErDdap+23S/PeBP3AjB9RXhWYV7qhyJ6MPof+J53ENEKA1U?=
 =?us-ascii?Q?iGZvgQwhjnQdsdILa7WTT8nJTVQBDa8j9pZfsN2PZ1XPp51zOZT4mlA17GKw?=
 =?us-ascii?Q?oJcVFXkiBSuXCaLo+XecuwP5kkrwV5IibqKLBdZYjubf87sOIWL8tdmx7GOF?=
 =?us-ascii?Q?M/eYJHU/7silJreDJCFV5KCaDQ03Z3x7LdtmkdDKxa2zL7RkdBRicx+7ES25?=
 =?us-ascii?Q?RGQwhEUTnU3ysSS+eNC0mxZBhbDw0TE5aekFmPEBYfDQLZ4W7XimyIwuAqEd?=
 =?us-ascii?Q?1ANnoUW22YNo5bHSw+Z/4gmDU6lmWsLUizlKDDdPwdmFbwbBjFWk/T6b6E+x?=
 =?us-ascii?Q?w3zR6Uz4WNrH1y6tkA9BIcO7S1ZsI7vvn4+qryJGNvYjtun2EagrxE0abOKy?=
 =?us-ascii?Q?kCF86PwiBEJyS7CKRAn1EJYmlctmuAKmJpxlyxfs2I/vLJVhZiK9IMncRTpn?=
 =?us-ascii?Q?ZbxbDWT27qSvOxi+piosC/fZL+/A1jsQnHEoy0q5Szmcp3RypIA2Tqwpy/UK?=
 =?us-ascii?Q?QXW8EVrjjJufftYnfl5BXqNBR7O1M5vqsY/5vS/TfAH/Nszd2wR+VdLYrs6K?=
 =?us-ascii?Q?lt8CuBQrzEiGee8UjKnLIkIlYPK7YDaXHMpm9JRyc+IUjWFZLJv701QcKo7T?=
 =?us-ascii?Q?Rv6f0uZAfux3oEfHYrBJ9XsQiLH4dYgpLazykngYY7/ufoWsLJcZizHH978I?=
 =?us-ascii?Q?B/8wXIOvxB+G7iWBQqlhqwyrlgb8KjKSmHy2eXxsJTYyYxFthRGbTE+lagzw?=
 =?us-ascii?Q?qH56QK9inAv8kuHXDGEIuY3/HcgSJrM7LM4Jo7T5DGHj7hQTrutrC0dWezev?=
 =?us-ascii?Q?FgmrqsKKzfZ8KNTfGtYWeeWY0XcucsXw0Bg7+ShW8u5u6PGpAvGbtKTldE4y?=
 =?us-ascii?Q?t6/c+8YTujH3MKDTsjcXUhwx4tJIS2ROnRldXCQO6LNMLZ27qRrLeZq22A8k?=
 =?us-ascii?Q?ldRCdLfzVoT/hENgcHDGgVw2m6re/JLcRfMg2DWAMNZU5rzjLfMGEic0oUC5?=
 =?us-ascii?Q?zaNldR97Z/sYVxJmF8ejn7lr9Y+qbST1Ycu9yg9IOQ2oec44lpt3UVuisF0k?=
 =?us-ascii?Q?iw5rFQpIf/1DkBLMbSRxfVGHL1pWj//BprK03NLtdAx3v5j86VCKdPKLJbIg?=
 =?us-ascii?Q?uJMCreNb0W1U+HlPafsM1Wk5Mp8GL18X5g4urCY6ZkbMRwBH4zHu+8B6+XCR?=
 =?us-ascii?Q?xmGiP92O3L20RceRfNoDxAEySW/Ag+FZLMnWRXAodnxuUBZeesxrDfUuttaD?=
 =?us-ascii?Q?huCaIA/hn/n80gDirecLHLPL2dY4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 15:27:09.4255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 516c5155-100a-4532-3d27-08dc7e61797c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6140

On some older SoCs the PSP doesn't export security attributes in the
capabilities register.  On these SoCs it is however possible to get
the information by a platform access command.

Restructure the driver to move all security attribute handling to
a central location and then add support for calling the platform
access command on those processors.

Mario Limonciello (5):
  crypto: ccp: Represent capabilities register as a union
  crypto: ccp: Move security attributes to their own file
  crypto: ccp: align psp_platform_access_msg
  crypto: ccp: Add support for getting security attributes on some older
    systems
  crypto: ccp: Move message about TSME being enabled later in init

 MAINTAINERS                         |   6 ++
 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/dbc.c            |   2 +-
 drivers/crypto/ccp/hsti.c           | 138 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/hsti.h           |  17 ++++
 drivers/crypto/ccp/psp-dev.c        |  23 ++---
 drivers/crypto/ccp/psp-dev.h        |  46 +++++-----
 drivers/crypto/ccp/sp-dev.h         |   2 +-
 drivers/crypto/ccp/sp-pci.c         |  65 ++-----------
 include/linux/psp-platform-access.h |   5 +-
 10 files changed, 208 insertions(+), 99 deletions(-)
 create mode 100644 drivers/crypto/ccp/hsti.c
 create mode 100644 drivers/crypto/ccp/hsti.h

-- 
2.43.0

