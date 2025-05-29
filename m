Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C169921638D;
	Thu, 29 May 2025 11:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518296; cv=fail; b=Wdf/YA4q2xBybOCUJAjisC6NmZafwalLFNA+mNKTtAEQwCnluMilOuCPqjUCwDQeFe/EJQE24M/Rq76W/xKLBRzwuEJywfizU/4HeMRQQpuFlF+2DvLLgjw6YFQTtyc4+F1bb+DqbP6kZrw4VFjM9NBvJLf0NwL8NbOt7LnVsSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518296; c=relaxed/simple;
	bh=wIy54j77IPp5H2wUO1EGrTFgKPNAjUiiC9jf3U7JL3A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tDIf+ziZ1Fn2cQ/4vNu+R6P9/tRb19SdW3V3bou6+iTZBnjg9QQnS3kQwRpOyIfcrxCErrKJ8ecHMItEbfCVMKONEZzVUwxjopHWuk4fuApixMDPKCex3/sb7NrYCpQOV52djiJSGj8tHpvDCc3Im+XeaW+AIYzrbcY5NiqoAvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rkHKqVgY; arc=fail smtp.client-ip=40.107.101.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rkHKqVgY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vVyb8sXXcvU5ToxupxFqkZRvVpVoZs5NKt9dRyy/9DRJoiUGpmrou88YUKLtHyzac2ozzxHtIKF0FAfJAF0d3IqfpdDRw/uTz/5D73rQNMD1xcADwu7GJVL/vA2iu6hamplAOIKesMGIZLAOCAbkroIUpGKDjWUgwNpfRIZM9BJswXBpOcDmAeoUroESTPXpfQk4dgw85fgbSWm2Lbzm7pc+ib4P89+vdBAwwDW8+rgrxeVaXUVc/lZvpBxqsSf0yByYkP3/SF7WK6q/m4JDQB8PphohBr7UeFSd3ZC1jwrS6iEcvfciVv6bZP3ccEe+j8Mnm4doftmFf59/S+7cDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=us694yGtd6bJ+RhDKYd9z9l/XfMhZXJ2FECepWYD1k4=;
 b=PXUheX8e1AuSa+SkBztlo0OVzu1HjNklHDI7DVcWikAUTefx0M7J8J/gQjPz+1gej0HWlvjg3ys+6DOZaQsPS0fuEdeS5bjbI6EojFy4x6yywuUkorYxqyWdPuhNhqM8wrhMHywa+CD0mGYI7H7e4DNUBZNKbo0DDX4YBPYpjl4UqOYoUh8ImnAU7mdvfdjznl83WVIniBfV9f+pUY7G5HJiuUZxoFIL3HLd8MkrPQB1o0+Bq0DXY2tW8M3jdB+MViKUdKgYTvhO7M2Z49gfANjP6aaBZg+PIgTbhwH4O9IKzPz/McmYfzgY5TTXCGqjjfqH8dzPbbn+1LG5LxMnSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us694yGtd6bJ+RhDKYd9z9l/XfMhZXJ2FECepWYD1k4=;
 b=rkHKqVgY29U1ds9L1BCbDIhJRQ23BRH2EpfUxuzRs8ElPBhELfgU6TTukdtgJcupVVQNP2OyOMqchIjvezG7LbLhk+0jntyQywwhaqlZ6rWMS2ki1Bzwpi/UgwqRs9HV5hZH+cmHbk38yDfieR9aMF6+kh2cjfmtu3BC1gNpJaY=
Received: from BN0PR03CA0007.namprd03.prod.outlook.com (2603:10b6:408:e6::12)
 by BN3PR12MB9570.namprd12.prod.outlook.com (2603:10b6:408:2ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.31; Thu, 29 May
 2025 11:31:32 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:408:e6:cafe::36) by BN0PR03CA0007.outlook.office365.com
 (2603:10b6:408:e6::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.18 via Frontend Transport; Thu,
 29 May 2025 11:31:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8769.18 via Frontend Transport; Thu, 29 May 2025 11:31:30 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 29 May
 2025 06:31:30 -0500
Received: from xhdharshah40.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Thu, 29 May 2025 06:31:27 -0500
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<mohan.dhanawade@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 0/3] Add Versal TRNG driver
Date: Thu, 29 May 2025 17:01:13 +0530
Message-ID: <20250529113116.669667-1-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB03.amd.com: h.jain@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|BN3PR12MB9570:EE_
X-MS-Office365-Filtering-Correlation-Id: 6154845f-0ccb-4ca2-7a34-08dd9ea45bca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oyWBGSsaK11ty3roAAY0zXStxuQrPW8gWpXlQ0FrrHe1gsNzFKEissHPbPID?=
 =?us-ascii?Q?s3+uxWGODj0z91j59eZNElVmBjt4Eqjf8ztCvwl/3MgLrH8RQodxcXiUGZJV?=
 =?us-ascii?Q?bjGOuYaC8yheRJhxMfqlQMMLZDZCvKW8O1LJ2L4sDlA8D2Xi5xMfYaCOnuyI?=
 =?us-ascii?Q?GstM34M9lV3VxzIWd98BJAYtFeTNeVaqwUhiTEuPMGwWbzjIxV01NcCxMWSR?=
 =?us-ascii?Q?CGvq7/dPK291Ykt/YByxgevf9Pvm439supvhFVC1TiZxymgGVMEeIyqpjZTx?=
 =?us-ascii?Q?oucPLjYI/1VvatMW+tUel74HFOX1ydiA3kWSWLhnBD8itlrjidDjnuboFR4B?=
 =?us-ascii?Q?+J9rUq2fU/ep8IUEaB+AuGCU2yLt92dhmVrNSOexmv2vnK585ENPJ/tMn5gI?=
 =?us-ascii?Q?+ueVZcNLyGFcmFw+vzMsV0IeDzouKGZopKEr5MU4rNtvRvkkonLjHDtBbTkb?=
 =?us-ascii?Q?6JZHD3wi3zCASnc6nS+CxOKkvku3Yi1sZGZ12eFqZxvt+5EOl1w5Pwf1llI2?=
 =?us-ascii?Q?XXPbQBbDFrqyJrP4+Bs7hKPQF+NUVlj5cUB646F8OisL+hYoy/s1S7fsXZ9/?=
 =?us-ascii?Q?96FcUlwA7E0+RIYt4HlcONAjPrEIiHqSkp9k/rDzcZWVPPp402r+Otep0ic0?=
 =?us-ascii?Q?6pBCKFWVsjCAynvHWqFmNA6ejfKx1E5Nnv4AYlMrbje15C8T7DIl3udkdCsi?=
 =?us-ascii?Q?F6T2+0G3zMTCiHN6m61N/9aqk9qyn7d40XGUiSshsW75vNOgVYMMuBneZT85?=
 =?us-ascii?Q?JFPatOxFcLvIX8KsKgT1UtwZa+IrSNdJc5lktwfXvbM2iCcT0D7JJP5yh465?=
 =?us-ascii?Q?DL2l8GgkZVEmHAeiFIMURKYI3h2QXTwiqwbqrj9d18aTdKwBr2ivfdJezP2m?=
 =?us-ascii?Q?gmNeASuzFmJ0NSJqb6eG12bfvmLXfkdEZqz3rrIYqhZ/yKG4Ha7Mgl8UHbvQ?=
 =?us-ascii?Q?i6MnEwvBDU5+k7JwI5OiaD9abdgh30nd2Engwbtd0iKBBm0hiZm5eM/VKLxf?=
 =?us-ascii?Q?AULAs1FWk+tu+t4Rgu8V0ydt60r6AsrxebIGBdoPunS3dzFbDvjmYMRKOTsU?=
 =?us-ascii?Q?4sesBr8a8R7uHFNIfDUDi+wklinPIQgUlwnOG7Cnhea1X7kR0/dbtBqN8Jof?=
 =?us-ascii?Q?5JIkiEdZWEwz1BxFXw2oe0YSxychrLx3lZFzKuBAfLq7qB4LbZ44l7kMm81D?=
 =?us-ascii?Q?7a0WRE/1f8OYEd5s8//gwIMp58EvGM4w/fYiS/G4vKYG9IbemalAFQoDNAmN?=
 =?us-ascii?Q?FpL0tb5nGSgSATJB2mcGIgtIUe8V5+l8vN3RLwKJrP9eWY9ejOiDA5g3XsQC?=
 =?us-ascii?Q?7q9nLYdX/FTVMdfJMWVd1o+f7kX8g2qrQv10yHPevYPofonJAjpSJK7C6oJj?=
 =?us-ascii?Q?/WAGeQ4etcRuDQ+lWofhxx6Xa2Qn3FyMURxzEvNR4D8idy6X0eMyG7Fq5RzE?=
 =?us-ascii?Q?940et1EbNARS074oc8VodJY1m6K6H4Nc4eQgm7EV/FD9U7T9Ybbwxb5KuThL?=
 =?us-ascii?Q?MyVWhQ4082Y6VaIfU2wq4oFFQAwWxK2qKz5G?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2025 11:31:30.7871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6154845f-0ccb-4ca2-7a34-08dd9ea45bca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR12MB9570

Versal TRNG module consist of array of Ring Oscillators as entropy source
and a deterministic CTR_DRBG random bit generator (DRBG). Add driver to
registers entropy source to hwrng and CTR_DRBG generator to crypto subsystem.
Derivation Function (DF) defined in NIST SP-800-90A for CTR_DRBG is not
supported in current TRNG IP. For DF processing, Update drbg module to
export CTR_DRBG derivation function.

Harsh Jain (3):
  dt-bindings: crypto: Add node for True Random Number Generator
  crypto: xilinx: Add TRNG driver for Versal
  crypto: drbg: Export CTR DRBG DF functions

 .../bindings/crypto/xlnx,versal-trng.yaml     |  36 ++
 MAINTAINERS                                   |   6 +
 crypto/drbg.c                                 | 108 +++--
 drivers/crypto/Kconfig                        |  13 +
 drivers/crypto/xilinx/Makefile                |   1 +
 drivers/crypto/xilinx/xilinx-trng.c           | 434 ++++++++++++++++++
 include/crypto/drbg.h                         |  15 +
 7 files changed, 562 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/xlnx,versal-trng.yaml
 create mode 100644 drivers/crypto/xilinx/xilinx-trng.c

-- 
2.34.1

