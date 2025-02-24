Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39668192B95;
	Mon, 24 Feb 2025 09:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740388597; cv=fail; b=s8njKgZkTjfVCQOz9NEqLDPFnYZeS1So24GOuiS//1iC5tB6GnEbcHvCOy/sfi1HHs3hq7qMo72FkFeuNBoA3PfQW2xqnV17WcUWjKR3VFCtImIaODF2SK2myrZjOYLdfZgqkiodZcou0Pw+gagEMkS4l8F6+RQIZbi5fR/it84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740388597; c=relaxed/simple;
	bh=kHY7oQ0rhbbYTNxuQsrQx8yfPEbuejGrNTwywiKs2Sg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=H0pyMDvq172ywAN5owFDlMqkejRByE3cSu23jOllYHW2oo9yMT+1aZp/msU5nu0F6MYfAsyk7CSL+gvEXjWkORIm/FJkDTrXEub1GYn7wgJ8TdDQlJQ8JIT0Bui4992R86lnwKPIk90JipgupPk2bR+BUzRQK+973nljYRnBMic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X1SQYI/T; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X1SQYI/T"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DfB7/HbHQMXYvMoKyuevFxCnMhNMbMl3qWDy79csh8rsvIbs2+nVwLmtUAmrZ5tWwx0zSfEqBl0s9eqobqnvsoaSTZ0uSgOcNHtR8wFrc3AWvEtWick2KP+d/aj0/QFqD9d1l8C4JbTY47+zBk100ZVjZxQTC5TR7caVga/lOQSU40pP6K4mRofdP0qoqwMFrmr+W02klCiJUaJBQwFf8v3W6jwUnnibAh3IvuZFKQ/ZhwCqFeJzaYi5OJESjwqbaCJsq6/2YwPtxoGJ4rE9Mj/CCWYpbFNCNJxNX4i+ZE1NJgxq+NrlPbCHlG1ZRB15F4fhbnl0CxBLZd1vXZd77g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbwwG8BZ448l5CwTRj8VyG+yRPl80m083RVzXddRSb4=;
 b=tSYYGCOZEwbJVsWDdOrjcFqfgVU/PF46P2z8X8JFjsxpbm+1G1SsfiFEFxTBk6Km1o9Pxxfo1oB15934UQuQ8BcVTDjQg0sZvB7BwFLvTvjrBXKgQFdb7v9736VcmlFoATc2Rp3ImEzPN3rzjwHW1869ouse/TsVSZFnEoKyKQrA4hZQLCgoBoJCJeswmOM1m59IwPj2EkTrlNk6AsDbJJKhoIGzKDKcGffiGsSgbljrovbvzCzVkDu/vOk+nLLoXAGWxfFWgzfgMUvDffvHdc0tzikG8ZQsu6E2+3DhtMxdQXFkjObMX7rxek41+FVdqiWlj1Ge5FpnparJbUjb1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbwwG8BZ448l5CwTRj8VyG+yRPl80m083RVzXddRSb4=;
 b=X1SQYI/TBW4p/kfV3XAlo7Mjg9iWuISyryvwasjQovOcjzFJul+i3cPL2jYBz4k9immL/BfWq+u/JmEM9w2eOVH0Z7hKEfx4oFhCgRikmS4NhiiCRPi+vTZSvwR9CdterzqDuqV+iUXP21bKBlK44CAT2/zfulG38eAu/BqpYDPNxAIv+wSPgEPeZVYqhqlCBCMeQjtjXXdPteUYgtL2x14XjX8+aHFy5m/fGfO6Rch/VWCoBvVsP0TaZ8QVkp7DBR2sxAbBbJf/ApWd31GGbTMsy/Ht23dzT3gM7+cYxE8P5cXSJ4Sw9rrfrzRhvcBQKoh8y4cwDSGpVahx7BQ+nQ==
Received: from MW4PR03CA0085.namprd03.prod.outlook.com (2603:10b6:303:b6::30)
 by SJ2PR12MB7894.namprd12.prod.outlook.com (2603:10b6:a03:4c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Mon, 24 Feb
 2025 09:16:30 +0000
Received: from SJ1PEPF00002313.namprd03.prod.outlook.com
 (2603:10b6:303:b6:cafe::9a) by MW4PR03CA0085.outlook.office365.com
 (2603:10b6:303:b6::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.17 via Frontend Transport; Mon,
 24 Feb 2025 09:16:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002313.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 09:16:29 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 01:16:21 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 01:16:20 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 01:16:18 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v3 00/10] Tegra Security Engine driver improvements
Date: Mon, 24 Feb 2025 14:46:00 +0530
Message-ID: <20250224091610.49683-1-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002313:EE_|SJ2PR12MB7894:EE_
X-MS-Office365-Filtering-Correlation-Id: c9e88f78-cc2d-4549-67fa-08dd54b3ec77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VNHWbIhvelXI5rv/Ux/CrHYzfL7yNbLxG34DE6uqVVWNwewJk1qij/EqFE6e?=
 =?us-ascii?Q?ta4I5sSg8d0B2oaQi7kUm+vx2YwbUEdIMpp/01916QmmH1Mf3sR0XEdtn1wo?=
 =?us-ascii?Q?9W0l8F9LF7mqS3PjqcxyNzRHL7or0rKr3aI9PZPcCXqKti5745MVP6doc5xh?=
 =?us-ascii?Q?TbCBC9cFdu/9bZGtAex+dAFWLRtFTWkxHR96avXdyugoj1UPCftTvLLBv0mw?=
 =?us-ascii?Q?ZDCWn476CcUjyV+T8WGOV7fanLkZxe8DhqGgpBE/rhnP85Azymm8rWT3xjCd?=
 =?us-ascii?Q?NDKw50BX1czg2Y817u14XvLMFNRBg7XhRpKKGITdEj0lEIY2XGVCQyrfAPW2?=
 =?us-ascii?Q?fprZnYA7tZI3flxG16Kj7OVb4582/MRXacVCa+HoWjPx7gdAn8c4FOWt4Iin?=
 =?us-ascii?Q?zElEBUluRaNI9qzvzpAv2erBIk+LVRzmYphxuJio1J6qmB5v3DFdwugW/tts?=
 =?us-ascii?Q?rZSwwBdB4HKIrptRLYlnwiSDmYYpKhokni8BGJ99dXWyrfb1LLjHHS2HG50G?=
 =?us-ascii?Q?pXpOBOy47D4BqrrsKru65Z5n/5Ox8/Div9S+LUjuyg3PUiAmUTs44iV+2ZmY?=
 =?us-ascii?Q?G/Cx4uNEnUpPVqRpQ69w1RNxsHCqKE1uf0el57l4IExsQKsLUKHb/xUnE7wV?=
 =?us-ascii?Q?kj14T6+JZM69IyOIMAC1mfV7t61aHKT/NniNNppIMX1nEauBvHEqt6JWQE+2?=
 =?us-ascii?Q?iivCb57a+B1TM8ScucirCKBIBCcyG4XV+G/3f8g0FpdeWcVW95t1z7ynMd53?=
 =?us-ascii?Q?+mtovveGW9bjkMZWhjD/0GbqJQEGvS4WzOOJD17zETDuDhYZ0Yw89SUkjDc0?=
 =?us-ascii?Q?1VuX/Gb3Tct+sAEgZZvkYWpKN06R9kHX9l0rdjJZ/iM4jat1lG/zivjUtohF?=
 =?us-ascii?Q?Ugdoe3Xfk9S63sFewB5BFx77L1FPaKjUrx/4nmC8m3VC5xT7SVuod4GaxYTO?=
 =?us-ascii?Q?mKoLQcIOFzThIfeePzHXnHu2tSQkUpzNjPAzhEEngVkPI+dU+I9vV5SVri09?=
 =?us-ascii?Q?LEaTsqAkY9DoxJUPifgMfsKFa9q/ZG5/a4mKM9cchL9HsLNXZCzDtyYxX4M5?=
 =?us-ascii?Q?PdRLxNs38Y+fZpCyNlMUpk8hwtABlsG0pHA9zbULdJ18qW/HlElOeC2OyfN8?=
 =?us-ascii?Q?BnjQHIisYKRpUnfmBllo78TMUSVr2d1K060S85SViQNw/RMf5T7yvryDUBWd?=
 =?us-ascii?Q?DHS739O5KMnPJSP5KChEXtq2CKnrGsO9Mb1D/o9EvRbKHIHA9H2RSAwt5Vpm?=
 =?us-ascii?Q?IfmyxCIRuGr3+5iyuHZIVeKktqCBOM0bVgPi1yxwu2jESXeS7WotC8dUzvli?=
 =?us-ascii?Q?czmSWAEjENwpaFdBK5Svnf3gKZU8+ba7XQkNJ1EN0luPfAd1pWKt5bkhPPLX?=
 =?us-ascii?Q?h4Uu1S0n0KPayWHsHc7yLqnxQCiySLur8U964oQ6SEE7uzaVPnfejqJs17Gv?=
 =?us-ascii?Q?wWVgV99rSIqHXDUrwauRzs2GAs6LRPOx9cpI/i64mnIKR7axebQT9cK2mRVB?=
 =?us-ascii?Q?vPrzTtmrjGXj3o4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 09:16:29.8981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e88f78-cc2d-4549-67fa-08dd54b3ec77
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002313.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7894

With the CRYPTO_TEST now being run asynchronously unveiled some
concurrency issues in the Security Engine driver. These were not
caught during functional or fuzz testing as all the tests were run
synchronously.

This patchset contains the fixes for the concurrency issues and few
other improvements identified during the stress-ng and cryptsetup tests.

---
v2->v3:
 * Fixed testbot warnings.
v1->v2:
 * Added patch to handle the scenario when keyslots are full
 * Added patch to finalize crypto request which was not called in some
   error cases.

v1: https://lore.kernel.org/lkml/20241217161207.72921-1-akhilrajeev@nvidia.com/

Akhil R (10):
  crypto: tegra: Use separate buffer for setkey
  crypto: tegra: Do not use fixed size buffers
  crypto: tegra: finalize crypto req on error
  crypto: tegra: check return value for hash do_one_req
  crypto: tegra: Transfer HASH init function to crypto engine
  crypto: tegra: Fix HASH intermediate result handling
  crypto: tegra: Fix CMAC intermediate result handling
  crypto: tegra: Set IV to NULL explicitly for AES ECB
  crypto: tegra: Reserve keyslots to allocate dynamically
  crypto: tegra: Use HMAC fallback when keyslots are full

 drivers/crypto/tegra/tegra-se-aes.c  | 401 ++++++++++++++++++---------
 drivers/crypto/tegra/tegra-se-hash.c | 287 ++++++++++++-------
 drivers/crypto/tegra/tegra-se-key.c  |  27 +-
 drivers/crypto/tegra/tegra-se-main.c |  16 +-
 drivers/crypto/tegra/tegra-se.h      |  39 ++-
 5 files changed, 523 insertions(+), 247 deletions(-)

-- 
2.43.2

