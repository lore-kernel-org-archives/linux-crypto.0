Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010054.outbound.protection.outlook.com [52.101.61.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2718627E05F;
	Sat, 20 Dec 2025 15:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246366; cv=fail; b=hvSmUWKeLrvH0o35ORP6jiPm2wxxeeRa5weUwtWkfoQs/iqJjRvubEgP5WFJQdD5d6IR9z5L2v2nPRjLZY3peXd35fphrkk0aN2d1yEnheJrATNgrgBxcknGbT1m5W43ludBei/FSCHOtyS2IriEg7aSE+t6JGS6g1YorKa6s0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246366; c=relaxed/simple;
	bh=8Tt0twA/8SNTlbBzkON33xI/MyVRQGIAcysJh7qnhOk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hTs27Q7xs6KP03famli2qTp3kBjh3D8AXOkgPCyHq64DnpszkYKsWH3RslWDK9cpPCQ5duovGj9CuxtBapTlNGUY6AzBS0XVoYpkX9AobvhwFpjaqOxjDGg0MM4EHExSODhbpISRMrfwrvk9O5lKZsr6AnmqSZHMvVzNW1hkyTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dvIWGiPz; arc=fail smtp.client-ip=52.101.61.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dvIWGiPz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h7VIduN5KK7yLQDRPkGlGn63jPWQZ5Zm8TeFGGbpIRbLUvEtK9UkcD99mlPsv7Y9grs0TG9cWRkY9osJbd3yszCSKShPJsiKELdXGGcpt6Td31D309BbqMiMX/lHoeo5x1PZLjjgpveF8lJrRiLRbsCbaP5O0fcRSrBNL0mGJmTeP1gTESHH+TGuqQt56mcHrMeE1+ybbvmREZdTVCOQhC28HuCBQCpyLNFQ8Oj49Ex2tSNjmCP+16OUEv1Ja5YziKpJMLwXglLcw6LrSDXQ5JFL6Tm6hhLkpJEM+lB39Z1pYN2/OhWn/8uIfzbOMgE1SOgLwbuGk3EYsMIMh7SbmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWSzc/mHPZj5DuRwUNdilm65qtiu1HZEvCeMuUq1YUQ=;
 b=oosu0ymfxtpYS9zl4H34u95OMPX76DXAXRoq5/KxXvVhYYdpE584UDH6b4PKt75Z9l5Qt7vlxh8gcwdl/vHKL4aWBjPqrDI3DCeGzv09goL3Oa2jAj8pFiuMF4leZn6tIvCmWpjOFz6IuMslk+xQEkrUNVT06sckK9/taXTlazEZtiaT2emT1XntxXaB+zVyfkpiE8fSw0sivm1PZOtGeRkLlp8Pd03+bCPs8DH0OfL9DZyNz1E2Kkl5WR3DL0u0Y7UzQKu/NyQcpBxLhBxSzGJQ9JWdhzLJdtnPqhXZxFi0GuNiXvckssRMkGDJ5Do/wAeVsOarmAPW7OIAiSAUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mWSzc/mHPZj5DuRwUNdilm65qtiu1HZEvCeMuUq1YUQ=;
 b=dvIWGiPzzZvlTWleCTlKocuh8soa+bsRB3c4YntikXCz7gbVSbsSsP2zO26etPF50avFjIjnVN14GiYJsAn8aouxbL/o6o8M/BHsSKd0bTqLZbaV/stLTnJLg7bILL2Pna+Pemg5mSlJXCfKZ4IHlBhadmVyd4my4EPjrdXTSfc=
Received: from PH5P220CA0008.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::6)
 by CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.10; Sat, 20 Dec
 2025 15:59:19 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:510:34a:cafe::a7) by PH5P220CA0008.outlook.office365.com
 (2603:10b6:510:34a::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.10 via Frontend Transport; Sat,
 20 Dec 2025 15:59:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Sat, 20 Dec 2025 15:59:18 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 09:59:17 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 20 Dec
 2025 07:59:17 -0800
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sat, 20 Dec 2025 07:59:14 -0800
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH v2 00/14] crypto: zynqmp-aes-gcm: Bug fixes and aes-gcm support for Versal
Date: Sat, 20 Dec 2025 21:28:51 +0530
Message-ID: <20251220155905.346790-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|CH2PR12MB4134:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e11b62d-2376-4465-42dd-08de3fe0bb79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?knTRxUvcOnrcbmqX9xcdr+myuRC1XeW0YqUZvEMgFzuYSC/X/E3RMWlwZ7+W?=
 =?us-ascii?Q?3ob7ZcYUpdmNNYfeTrzTJhACiXJ0B42QoEY1CHPpnDggTD+hJJVXl7o+Cl+F?=
 =?us-ascii?Q?cdxyhB7q3hsxKM5IPb8UiGkfvo2E/kkb7D7hM0j3o2yeIplmMUsZTXRRKPo6?=
 =?us-ascii?Q?D5vVKnIM204Na0gSIcCyUkSc8FEU+Fe10K8HMWI8kDFftWzymtkIw82i/Xso?=
 =?us-ascii?Q?o+fqiEnx9bxnpJX9LmIqAjZ2GcS0Et2KeBIXFPmFRsNvInwLPricPaguvzz/?=
 =?us-ascii?Q?h3BlDIfOiLz4v2ce6c5yA4WR3kwKBw1nyst+2JFvUWzNzxeWQF0F6xzK9n+7?=
 =?us-ascii?Q?V9pmNZfNEgKzzr6J6OpLSZKw2qttyoDhZXunlnKKgTSg7vB7/zt7RGrJ7s1B?=
 =?us-ascii?Q?Di6EHkprr+uN0mANyWBH3lH7kM7xTOnr5GRv7gjCNQKLV+v24kY+bWLQccXU?=
 =?us-ascii?Q?3I5ZvFOaBws/REK4xk0EQ+/WrsJhQybQ0tF5h8lGqwiad7IK/O2fX2SWGFbk?=
 =?us-ascii?Q?KMuVxYHLwvfDWa0rhfFhOoJtE5/19/+tJuIAGC4C4oNZX3aspE1zUlY0+nGD?=
 =?us-ascii?Q?OUyUtNy+93XvR7OqfOzCq9uOc17bLQA4ia7Iww27KaUQEltUnne5uGzgN3Hy?=
 =?us-ascii?Q?edwiml24mouds7jyJqYgQlXsaEVPtjB/ZxpgoKS5U3XOqirN+1GbO8DnEtoo?=
 =?us-ascii?Q?Ba/y2TAC5fOKtr+2DnXDth2sGGd/kQXs+Kwnw3sz7nfT5vg/3veLYHnyTm27?=
 =?us-ascii?Q?Ojh34t0rEfs258NE4UdFYDt7TdfEwrGn3KFQjkxVYg1pATiWEomIsUKT9Jbe?=
 =?us-ascii?Q?7xbR+hGbDfGcpLfr/J1lCGlu8nK7sAk+715P6+hYoCuC4Ed8A3U7EuOoK0g+?=
 =?us-ascii?Q?ErCiahnUTePHUflTCJxuaWU+mukf7wgJgEABaJkK0BDXQGV6yFQNj3kruJCW?=
 =?us-ascii?Q?Dyx7xMOewxcIoLPnCYr7k4xSN8tnhdUMVDQet8AbF/w8OJOsz1wLIM3U85Iw?=
 =?us-ascii?Q?3mi9xTY3JN16mMwIxhOijwXfQ7sB5NrTNRQuO0YRp+olQj1TqTLGvURNAiEh?=
 =?us-ascii?Q?qEJXZKQdNyEEO16m3rHCQClJD4gmLyxW8iZ/Useu5EgtwlkX8DeC5351c66X?=
 =?us-ascii?Q?FSzG9e1zpeHCQxtE9XchLQwrYtHMfD3qCjkupOB7GZfhpaKoMDjyxwHYQLbc?=
 =?us-ascii?Q?CWhlvZmkJspkZD4mp1j6wvnALFALzBjlBKfld8XqX6qSTxmO8OHDGBW1tezU?=
 =?us-ascii?Q?fUHddaIisoyl2T1ueFqEPzJ/pejfTVW+nLobN8AQsWHQDq7yXPZvoJnm3BVP?=
 =?us-ascii?Q?ZBChyu6ESERZInSSOfZ1sqSiMDRvCGGJhkmimD15TnRjVDcqjSLanTJntWhE?=
 =?us-ascii?Q?naYMPxzEAY0yWawl66PSEzapZ3Oo0Xnv8jmy/uRGc+qpJNDrJSCjhE4Z0Uth?=
 =?us-ascii?Q?+A3alzwHufsA0YG0m2pyYx1fS4kYU71Ly/nEOSSqjj+bXAwr3i5qB8rSvgsf?=
 =?us-ascii?Q?/g0MOHEdWR3G3+RDKEzifeAZrAKf9tDLtebHEKjJNsVQ/VaX8V7vjgzyMu1N?=
 =?us-ascii?Q?VoGW8KejilraXu33rTGBHF84eR6kZ7Y0D8+N9Li6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2025 15:59:18.2801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e11b62d-2376-4465-42dd-08de3fe0bb79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4134

This series includes bug fixes and adds aes-gcm support for Versal device.
It is based on cryptodev-2.6 tree.

Changes in V2:
- Rebase series to cryptodev-2.6
- Register H/W keys with gcm(paes) 

Harsh Jain (14):
  firmware: zynqmp: Move crypto API's to separate file
  crypto: zynqmp-aes-gcm: cleanup: Remove union from zynqmp_aead_drv_ctx
  firmware: zynqmp: Add helper API to self discovery the device
  dt-bindings: crypto: Mark zynqmp-aes as Deprecated
  crypto: zynqmp-aes-gcm: Update probe to self discover the device
  crypto: zynqmp-aes-gcm: Return linux error code instead of firmware
    error code
  crypto: zynqmp-aes-gcm: Avoid Encrypt request to fallback for authsize
    < 16
  crypto: zynqmp-aes-gcm: Avoid submitting fallback requests to engine
  crypto: zynqmp-aes-gcm: Register H/W key support with paes
  crypto: xilinx: Replace zynqmp prefix with xilinx
  crypto: zynqmp-aes-gcm: Change coherent DMA to streaming DMA API
  firmware: xilinx: Add firmware API's to support aes-gcm in Versal
    device
  crypto: xilinx: cleanup: Remove un-necessary typecast operation
  crypto: xilinx: Add gcm(aes) support for AMD/Xilinx Versal device

 .../bindings/crypto/xlnx,zynqmp-aes.yaml      |    2 +
 .../firmware/xilinx/xlnx,zynqmp-firmware.yaml |    1 +
 drivers/crypto/xilinx/zynqmp-aes-gcm.c        | 1007 +++++++++++++----
 drivers/firmware/xilinx/Makefile              |    2 +-
 drivers/firmware/xilinx/zynqmp-crypto.c       |  239 ++++
 drivers/firmware/xilinx/zynqmp.c              |   49 -
 include/linux/firmware/xlnx-zynqmp-crypto.h   |  119 ++
 include/linux/firmware/xlnx-zynqmp.h          |   14 +-
 8 files changed, 1155 insertions(+), 278 deletions(-)
 create mode 100644 drivers/firmware/xilinx/zynqmp-crypto.c
 create mode 100644 include/linux/firmware/xlnx-zynqmp-crypto.h

-- 
2.49.1

