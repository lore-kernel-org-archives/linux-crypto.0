Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2681F63E8;
	Tue, 17 Dec 2024 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734451967; cv=fail; b=JFnmW7wfwqLR16K1+L6W4Yo/k+upbtHPHbhc/TgI7pMClrHLSU/IrDkOzX/srj0N9H/YU/s8L1pT8GiMeukUm2192fKFX+KhiRBshAsq8FZlQDXNcU4ysKr1ri8zgYfoVfJo95YpwPZh9SzbBO7gM7RQXkONiowXrvkwz+z3vzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734451967; c=relaxed/simple;
	bh=3PlvMZ8R7oVB8iI+iK0tRtu0eNWpRtU9l2TQ3FsBhVU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WLAJTr/x0JgUzsgDgCV2fB6mvrU5CRtqTBdMTZoTaNmUJzTRiRq0hx7svCkW5fh7mbdcCKGsK0t36KdbtqB41joCEay8xX6j6O7YC1F8A+/2xUph4AkzCjv7NYvQi9qWB5w55pPRNBPPJVqVocnXGNLPErF44qHRO60rtjlAcUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CqxvbKy5; arc=fail smtp.client-ip=40.107.102.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CqxvbKy5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hj47r3bH+wbJUnxCGpo1ynBJeOwtVIgOgGHKhzsl6JR6FHahqZo9ODGxDd/EA+iiQBGeW+CwfUT6l4hPhOLfUDMUl1IUXsEgamqhXjz8ib3lYX9AY5mRPOvxjQcRjrM2WEhPHjlZhh+uTNcFhdefFHxiWrX+FiWysWkXy3CWHJAFa242CvQizgYc7ny7KsLokpaJhgea+IaMimFCAoyEFkhtH4kv/nInkF1ajl4c8oDMwu49cgzGEL+MkmR+10yGO2+gQXgdsqXC81TJnwJkojQ84PG6nNviwFnZLOBeXeH38VaS+4PQLOf78OvunYwXmxpi/FeLSU/I7R8H7aUYzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x84DXcfNoq7DpoKanBCWEyajeod8jrXNMC4WggDRHjk=;
 b=NC7K82B3y35P+V2asLBUu2KBLq8bE3RTQrhkvjBnmAt2G4qE7BpDqtvVkc1jAeajl+fonNU1Cl2OMKNMXWlOMgdhuoAhEmt/2kNZCFtNt/eEdULHpvzOvOoEZpt8XsGgU1udY8ohNZLP9E6fXAvycq8UCJ7Lm0QrBao6jqxkKkkyjT/LHE5eM3c8WK+8Gwq9JBcO6loaqQKfAxsk8IaX1cQznsLZLR8wYr7iUyQXd4bk8NZfzsZ1BkcW/LabwYf+yd7JdIGKI0RMCSEvq2mTRUWvm9SFlPG1LFbcvcPk2i/KpwzdmiqY9b7KPkhAyc2jD+CNWTBbbDef/uTGEgIG+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x84DXcfNoq7DpoKanBCWEyajeod8jrXNMC4WggDRHjk=;
 b=CqxvbKy59rDYjc+k0AMG4ozwNqwVG1LLh+v1G0YNp90znG83IDhkgm6QGppFcdput22yzBQzHwn8uW3CdDen/xtepjRAsJnpoxzfphUhklMvGYqrE8LF52q/UEmvN9L5QC6n82dO4nBaUbXw30CUQnBDWUeYHlKYaTGWGx0N9WAoLYOASlipTJpWSFRbMDVNxcU+vxiOOeTSN/knUkIJyYNVteEL9SQiiCN8iOp+3vnMHXAyZQ48nZA7tzH9IeLE4Un7Ta1QL0BZpM3aSRWyRBxP9xvuq7EQw58W6xpZHUB1NZj8Zt39SV7fyi+6pWnpIFXPc83r/MqDvtvkhLf/uw==
Received: from MN2PR22CA0018.namprd22.prod.outlook.com (2603:10b6:208:238::23)
 by MN0PR12MB6002.namprd12.prod.outlook.com (2603:10b6:208:37e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 16:12:39 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:208:238:cafe::99) by MN2PR22CA0018.outlook.office365.com
 (2603:10b6:208:238::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Tue,
 17 Dec 2024 16:12:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 16:12:38 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:12:21 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Dec
 2024 08:12:20 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Dec 2024 08:12:18 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <akhilrajeev@nvidia.com>
Subject: [PATCH 0/7] Tegra Security Engine driver improvements
Date: Tue, 17 Dec 2024 21:42:00 +0530
Message-ID: <20241217161207.72921-1-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|MN0PR12MB6002:EE_
X-MS-Office365-Filtering-Correlation-Id: ab17f4c3-e612-46d8-9ba0-08dd1eb5a070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uvJCtM3oxpH4/BOtT/l2qNzVsDeXmdD6en+YWsiqGclOfBudoeNm9vl0e486?=
 =?us-ascii?Q?FRLNoEFWy86TSgI0rNfcii+mwovpRplOZm+JDZ9hLqpqsiAY564Og5Qxv/d+?=
 =?us-ascii?Q?i1F6N5HbvwPrTSsziH2Jh7Yk88oAvF5PbkVtUpRM3boeDQ3ZQjNq4dZMinPy?=
 =?us-ascii?Q?3xsMO9tr4FDpjqu5aBkm5pVwF4DsB3E1IQmxTrSoNGxqeyLz+gnpU9emhgu1?=
 =?us-ascii?Q?YIbEii4GcPaS4wyxMNYO3AaAls9G+nz98gzdL34vP3eY4eOyTbPLSvkF8oSr?=
 =?us-ascii?Q?/cdbeRv5J6x5HH685etbPaMG5TxWgAiXe6Hbp3hUJLrNxee0NamwQWIkVlEC?=
 =?us-ascii?Q?y1Gadgfsyf9SK0b3/f1LUPgtTPEV3B+DwjXZM20C2qkVFAim3Ldb8h8O+7I+?=
 =?us-ascii?Q?HJ+Qqt9o2fS9HMxz1I2/FBvDNI1kRC3FlSxd6eIOcJaTJsizAZSjlW2MOs6z?=
 =?us-ascii?Q?rarhI0Ucm7AZp6fy5FF2JQE/MR63SPzbN9Voz4bcwurl9Ryq7J7GO4qz5VqW?=
 =?us-ascii?Q?e8JDKHz04XDz3vhNUD3B1haMkR6nzU06C9pknBViZAaselBLYaAvC0vjNP3x?=
 =?us-ascii?Q?UESpZrgGMAxcFpw+bEjiXF6X1F+10+RqjFfdaqzMV1uCmtPFpbS51Q3SYh5W?=
 =?us-ascii?Q?2k09snA4H0OsxBvDAx+avc4ReP6KgfLYS4Wnaegz/iF+mi/cPILkw8ySXPFD?=
 =?us-ascii?Q?we/CW13YD7qwIpe8Cz1eaiRHSBpyn5SH5hmZWOJDR8yp8MzOMJ1/2vJA1thY?=
 =?us-ascii?Q?eeoJ9jxdgpt3a3MOymvGVmF13Our7UOyiMoOv9izw0KSmG5vTCihikXDhOXQ?=
 =?us-ascii?Q?7M5nW4H02WZzPXYzwr/pQUZ4lN2KCXcJ2fKhwmJJZOYDKLJpeLbRX3K0Uf2D?=
 =?us-ascii?Q?mCu5R3TeCh0YDF8lWGzew7yyBgSbLfrWgwfsk8yc5OZTKyHj4csoG/n7F01v?=
 =?us-ascii?Q?UZ6yClDLJdSfD64NFrEyaIvz4qcJc9oH2QS1VhunrMAvfjvBBt2QXX0XmTJS?=
 =?us-ascii?Q?5oGc6ZRstraPRW9K/xb1Sk0yhqEIjTnuQMMzsm7JRkCNdkCsEWnyOKnF4CZd?=
 =?us-ascii?Q?cFW+n+H1wgWqfiZSz7ZtTs9kAEXA9sSXfE0aT81kNzwjib+794tsdpKJaVcS?=
 =?us-ascii?Q?MXc7kEMSikQochqGi7FMfrF5AkAk+BKByDMNBWWbGI3d1NuMgf3wblXykZO5?=
 =?us-ascii?Q?Hg/K4B1Oq7nCDAq73r+1/C3Mc/fj62vJrC+cCs2to0EDrbRY5o3LtqXcFsix?=
 =?us-ascii?Q?ixPpIpcUv+Lne4H6plwqSyBLGYNlA2GHbQyot/6zz2VYCK240INbWFci5K3E?=
 =?us-ascii?Q?OTr5BF14/2+Uk+pbEUpg4RRijzzSUdJdQbtMlVKXMKFREv+78WfazbJW+VL6?=
 =?us-ascii?Q?pRDho0cJ9X0Oc73XGNaoW68CVn32PrcNOZ5x6St2jsnl5SNsUan2F5IUFHIx?=
 =?us-ascii?Q?x4hJGM1Q5Y849elQ6DdlFiCcjI2i5E0cjS1fdVgg52Ip8siD+91Auw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 16:12:38.4095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab17f4c3-e612-46d8-9ba0-08dd1eb5a070
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6002

With the CRYPTO_TEST now being run asynchronously unveiled some
concurrency issues in the the Security Engine driver. These were not
caught during functional or fuzz testing as all the tests were run
synchronously.
This patchset contains the fixes for the concurrency issues and few
other improvements identified during the stress-ng and cryptsetup tests.

Akhil R (7):
  crypto: tegra: Use separate buffer for setkey
  crypto: tegra: Do not use fixed size buffers
  crypto: tegra: check retrun value for hash do_one_req
  crypto: tegra: Transfer HASH init function to crypto engine
  crypto: tegra: Fix HASH intermediate result handling
  crypto: tegra: Fix CMAC intermediate result handling
  crypto: tegra: Set IV to NULL explicitly for AES ECB

 drivers/crypto/tegra/tegra-se-aes.c  | 247 +++++++++++++-----------
 drivers/crypto/tegra/tegra-se-hash.c | 279 +++++++++++++++++----------
 drivers/crypto/tegra/tegra-se-key.c  |  10 +-
 drivers/crypto/tegra/tegra-se-main.c |  16 +-
 drivers/crypto/tegra/tegra-se.h      |  11 +-
 5 files changed, 346 insertions(+), 217 deletions(-)

-- 
2.43.2

