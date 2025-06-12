Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6656BFC0;
	Thu, 12 Jun 2025 05:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706059; cv=fail; b=NbaOyT+1U/6GsvtkG0gOoGyWwgqck16P7VykSoS5YS4xWxySXo7GGp4li6C73RpHVWCqZ4f1hSm2Ko7uIqPutiopDPgymW2sgw6l4/theaHYh8brTCz5JyvRUXWL+TkaXc3MuCPRagltVfzQH0D46+JbcFsRe0LiljzAC8kLFZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706059; c=relaxed/simple;
	bh=YIPGgyHyTwIK2h+hCppxJV9lwRjzn8efNzn8+JysgSc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C1dReMBLMJ+EKKdRCCt5joRwffRS8GxJO9Qz19/Tb+OTW6S3FYsRxHLhsolstq9foWmCZKr3T0RfinqxNj6bbX8DCLbKJsAa5eTmUvETas2HSrWOeNx7T+BM6HqmidqAPWjlaVABcvurO4BbkqKGAVX9lTyRKjygecmCsIA9bi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HY6hk2ZP; arc=fail smtp.client-ip=40.107.220.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HY6hk2ZP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VNTeyXLER8utPJ19Bo25WYTCXAG4FjDJCUc12A/oYnAz3yPocn+EDiQ2sKxt45obnKGEfqkA1juUpJja8xrg6Df5UMaESIIBAwBBfgphru18pkn67gMnEAA6R8JFfoEUwULmCfI31l9IyUKZkf4jSe0bDO5WvJq8n2EclI7XOnyXqCzK5CsZG6DZ9B4vfXbn+PYqsjT6Ra4/r/eouYIXbMrjDdrOybDLYhc+Z8eQNHiAokXr0hSle541n618N1al9ksYcqB2t9xveid65kwBneb/2ZKS9Prg0gsUFtiO3DF97RdNqYXK+JW5i1eEDQcJQCqXsMqsMoj4glrg1fTRoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIRkSAAEbRvDo0RfJjF0ioyTHgcTNz7SSFCbl7u4X6w=;
 b=kbfjzR9LFzCul2HJlOu11N8eceybQNWYbM4PoNEJRN/E3zrSDOsUNnEBvOZzj8fNHzF220OhFi7FdRrakr0T9EshWEolk88OWT0asnYziRsXNYbWV7DLYV82iHPkdt6TY5DKW3Qa/m8iZ5NcmN5ad32JDjKAPVnR6oBTycJv2oAioPBh/8FjkfFRQEAn0sDu51o1mV67imuUounW5AfQAqYZ8B5aoe78c+IfpEGrLSykOIvMFU7SrVY8iS81xjoJOaPkBnLMeIRrsN20FnY0xCC0Ud48PP2Ur3G5nL2GFbo9uCT4UfVOeAxD9jky6dnpE8Y4VxQUGNSjUPkawkqxGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIRkSAAEbRvDo0RfJjF0ioyTHgcTNz7SSFCbl7u4X6w=;
 b=HY6hk2ZPMIy95/QDxINWWC/X+sBdDDwmYNA9W7B6Vk6jdhSceu6pwImUEJZwlpIe2CDd7mHa4LDe7JHm4LHdoE9UTvHuDXGp6ZbG/3B2j0ItNiQuhtHJyiWEv3coaeEdSeoVgbNcbobeua45nf0Hh0CH6WECDd78479cYHv8miI=
Received: from BY5PR17CA0012.namprd17.prod.outlook.com (2603:10b6:a03:1b8::25)
 by PH8PR12MB7208.namprd12.prod.outlook.com (2603:10b6:510:224::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.37; Thu, 12 Jun
 2025 05:27:32 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::53) by BY5PR17CA0012.outlook.office365.com
 (2603:10b6:a03:1b8::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.40 via Frontend Transport; Thu,
 12 Jun 2025 05:27:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Thu, 12 Jun 2025 05:27:31 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 00:27:30 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Thu, 12 Jun 2025 00:27:28 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v3 0/3] Add Versal TRNG driver
Date: Thu, 12 Jun 2025 10:55:39 +0530
Message-ID: <20250612052542.2591773-1-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB04.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|PH8PR12MB7208:EE_
X-MS-Office365-Filtering-Correlation-Id: aec6c27f-20e0-4a43-f614-08dda971d4ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nrzYPCXYKqIpBrjPbNdkTbQPQrv9tt4mrtsVNhJamGE92gNTIkOsgjKUlxje?=
 =?us-ascii?Q?tS7+31KBnuxGcnRwJKPnR/f0O7dnB7My/e7NLFutw2dTop+X86xIzOECn5nG?=
 =?us-ascii?Q?kVgFrRjaZwJIt+u2S8vl/3ryCuTCvabaDJcG1/fXThGpIsAt7fnlI/Tiw7yE?=
 =?us-ascii?Q?O9nLPTllMViZ7yKB6i14TAtwzdEtZhCAIzoQCnpcS+qgpW3pgegMKPySjRIj?=
 =?us-ascii?Q?kJstcNREePLEL2QeM9a5ISr0dYUPFxdJ3uycHbFvSKbWTcY89LcWXfDCY//K?=
 =?us-ascii?Q?PQfqIxvKLPpwNu6puzMa9LYvulo4K6ZS/abP+a8+OEFjMtRmi0vve7zMEmH8?=
 =?us-ascii?Q?6kEA9Q/M2tWKzNBHQzz/AuCSxO6K2E2P2e7+ByZe9EnhKrKQDcBehjQmCKvU?=
 =?us-ascii?Q?90MmomzCXADQwUmOaBSjwa0yFB01nkpgRcvR4g1TcypIEapz3Z38Tn9LA/7Y?=
 =?us-ascii?Q?YFKGR1udux6vo9Yih12iI2xJyeZXLYUxr+jeeALgkdsnOI2A8Ds/pytrHOzP?=
 =?us-ascii?Q?jg+YVaKS16Y+Zzn/UzoIwG2OY6TIc/viAN3XiynIiE0+Ycc9qR4+zRJ5Fi9+?=
 =?us-ascii?Q?sEI5EQMTCsXF+3nf+qF5I55rxcW99T62LMZpxG/DsOyMprSWLA+2lzOjSbud?=
 =?us-ascii?Q?MoGNKz/RaYzB+4LHkdMMwHmotEW9SIhnhYh0gY4xJTZl6aVRw0qGN59KETxo?=
 =?us-ascii?Q?dAzi+NS2zZy/sdTcWEcLIc7sSK4XMO5QxuomXW6QLyzLsSYU1vkKsP6U/qP/?=
 =?us-ascii?Q?S16Ln8uv/6cy1I4e10YC0OiYLgbDzTcs1DJtI0OnCcBlP0XHeW1ovAYDTA78?=
 =?us-ascii?Q?Kg/2q92FRXcALDfukNCzjSOz6UyKUYEVyw74+I554yfY6EslZC5f1o/0+4bS?=
 =?us-ascii?Q?IPZ6xbrIUieE1RzL+tSjJZDHrsVucFPsZUG/w8aqmH9PAYkUgItjwd9tQawU?=
 =?us-ascii?Q?wyaAM3LD8py3h4Q8zrGEHbR/p8b6+SbQauw2ZSzqw2q1AyZpwZ6/CIgNfvJh?=
 =?us-ascii?Q?chy/Tc4n/hv3V2RspmMUCrz99bdaQkIcx48N72gtVXUH3DpDKBv4VuHtQ5EL?=
 =?us-ascii?Q?9kSftnF/LBUHoxaGVAVMdjXrREB8HK3P+FAWMN3DLNkBSeabQyrtKWBDeIQ3?=
 =?us-ascii?Q?5xF8kTTJXXxYVO8V95dWdCxuHPV9LyY6FE+DYYhoq6UEd7MXVkoOyZ3PzoCO?=
 =?us-ascii?Q?Vnujy8kHnFRyxl+FIg3gIbDRYz18uIiyV5sQln49wP46pIneC9uPPHM00TKU?=
 =?us-ascii?Q?3EQsSuA/K2zFQComILw3CZJt9mYGh+2xBhWZKfMHxw27Uc18QascnxAM8ydK?=
 =?us-ascii?Q?+vTodNlwSqFSNRYeCHbzU+cWvzDiyW8eGspllGldpA5KtRJFhI6u2mbet7lr?=
 =?us-ascii?Q?byX2bV70XDrHATElRvxn/OXeOX3ImMJXGW8DjYBpKsHDvDt/T6nAC/+4yt7H?=
 =?us-ascii?Q?APJhpyGD3GMUhC3H45F3GWDfzP6VyZ51FVT3il18URj7o6LR/dxyEAanfTGm?=
 =?us-ascii?Q?tHisREA+K6JbhwR3Cj0/skwM6WL/nJ7Ko6Ac?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 05:27:31.9415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aec6c27f-20e0-4a43-f614-08dda971d4ac
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7208

Versal TRNG module consist of array of Ring Oscillators as entropy source
and a deterministic CTR_DRBG random bit generator (DRBG). Add driver to
registers entropy source to hwrng and CTR_DRBG generator to crypto subsystem.
Derivation Function (DF) defined in NIST SP-800-90A for CTR_DRBG is not
supported in current TRNG IP. For DF processing, Update drbg module to
export CTR_DRBG derivation function.

Changes in v3
- Fix yaml warning introduced in v2.
- Squash fix patches

Changes in v2
- Fixed signoff chain
- Added 3 patch to fix Kernel test robot bugs

Harsh Jain (2):
  crypto: xilinx: Add TRNG driver for Versal
  crypto: drbg: Export CTR DRBG DF functions

Mounika Botcha (1):
  dt-bindings: crypto: Add node for True Random Number Generator

 .../bindings/crypto/xlnx,versal-trng.yaml     |  36 ++
 MAINTAINERS                                   |   6 +
 crypto/drbg.c                                 | 108 +++--
 drivers/crypto/Kconfig                        |  14 +
 drivers/crypto/xilinx/Makefile                |   1 +
 drivers/crypto/xilinx/xilinx-trng.c           | 434 ++++++++++++++++++
 include/crypto/drbg.h                         |  15 +
 7 files changed, 563 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c

-- 
2.34.1

