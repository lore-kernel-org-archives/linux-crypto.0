Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7483E260A52;
	Tue, 11 Feb 2025 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739294277; cv=fail; b=o4S+4MPgnH7pJ86UW/1NQvo5RuK4o0CY2ur306FPZ+898JYod/47IriPtpDi+LlJknIjJlYMgQTOJopc6w6Yvg8TOv9yIOFblcagtXrrKLYUcirVg6n6dJQFE1IS4tm1NRltv6lBxBFBsdYNEeqJbnaJ3r1ey9ZH440h1B/UCYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739294277; c=relaxed/simple;
	bh=Nfvsn4O0uNlx4qOPWKwCyduO0YVopYVwJQ1GcQvQcSI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NnDNEUnrdMN94aYX8hbh9xAX6SlbpQIH+TrFSvW9zRdBBmEaHKTNnOaQxuIVH7T8KFwu6bl2H6sJuu0EwouHc74Shd4ikevOGLfun+565xNHqwMkGbmQGI8JFGgrlHs9mpMp1sqxkTFHkmmuGhygTYGVyl0WBPSZKr390WbzqyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aun563zN; arc=fail smtp.client-ip=40.107.92.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aun563zN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsyxDBl2MskNI9O5OZcqO7eDp1/M9J4APpuMNYdEv68qWVPozz8DEepvtLCZGgNeARHCKvqDIDD46/UcLLchnjNYVoumd9EN6yOI9Ny4yxM3nO2TCCA8FGaphHnqM1FbEOQFt9lVkPp+RhId71HpMysikXGCvQafjHKdoPOYKIVrESI1pcCCt5df5VxUMBiUgSbD8bF8UbXHCDYRV/19rKaFRH2UixqF1kCs4YzLneB7QgEbM8DSL9IkikkbjvjlVO5om0uWPpKB4mktFM+3EQnphb106+zAw6JAoqYEoFr9/bYj4HRpuGpSbmdZX/cZ+/T/yLXPg8WV+3xuO3o7bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFJ57cpcIFe6VrArxeRPgI6dzH2Ih/MbnsGHfgY+Ja8=;
 b=C/nOspy0eeagqz+29FWWiyGYTQ3TzJ4TQtm+3yy4r5d1+Y+/OWsNX1piQti3pNMmBHyOMuwbYyHlHu4WSBIabjizC6SU0f8czN+H6qwLwuQVCqHi1x4WFrEWzwN3S6mInpRjSSgvXWcV8GVL4tLXOq+9s9sTEPqktyMmXQ60Mk7SNr6VEBHQY8xRZLIOiBEMETwtJjgINgfCiq8XpyDgXoGIoj3yyIqXl5ivakLwf/QLJPQNiWtD1zeeJI+Wt5Vw6SY7pjW3e9nS5riivjPPwM/3BV2YkpENhRhyqm6pDGhobglV8pxPhJ8s3j5UBwv8fIvQXg14rBUhrXCY0VmRkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=gondor.apana.org.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFJ57cpcIFe6VrArxeRPgI6dzH2Ih/MbnsGHfgY+Ja8=;
 b=aun563zNnykOVeq3g9BUp8ZT/XE78+kRBgeOKEQQKdFXpa/nybyQ5Gs9RX6BBiel8QvzKZMLBC63JHzsf7/3xKLKvxEn2A9tuyjK5xOyj9Ivmr4aGkdQyJdBoq3pYm1ftynzNG4+n4LIWf6hJNz24OcOuTazmvj+giG2NLs2lZ4xjkFYcuGxAn2ek4fq9/V+9Hsh34rmxKvSlHGU8uvAThEYLoZ6DtaS+25l3hFDSq1G2TCdkgqGhEZKODg6HIkcDe2beHtwTCM4c9M2pzX3+sPlfto44YdczC5eXHR+Hd8gISpmuCdBi6TthjOGTZjT0ECqUMbkT/c+6bqvyX3dcA==
Received: from DM6PR03CA0039.namprd03.prod.outlook.com (2603:10b6:5:100::16)
 by PH0PR12MB5605.namprd12.prod.outlook.com (2603:10b6:510:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.16; Tue, 11 Feb
 2025 17:17:47 +0000
Received: from DS1PEPF00017093.namprd03.prod.outlook.com
 (2603:10b6:5:100:cafe::67) by DM6PR03CA0039.outlook.office365.com
 (2603:10b6:5:100::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.31 via Frontend Transport; Tue,
 11 Feb 2025 17:17:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017093.mail.protection.outlook.com (10.167.17.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.10 via Frontend Transport; Tue, 11 Feb 2025 17:17:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 11 Feb
 2025 09:17:31 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 11 Feb
 2025 09:17:31 -0800
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Tue, 11 Feb 2025 09:17:28 -0800
From: Akhil R <akhilrajeev@nvidia.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
	<linux-crypto@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2 00/10] Tegra Security Engine driver improvements
Date: Tue, 11 Feb 2025 22:47:03 +0530
Message-ID: <20250211171713.65770-1-akhilrajeev@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017093:EE_|PH0PR12MB5605:EE_
X-MS-Office365-Filtering-Correlation-Id: 46f104e7-f3e9-4bd5-f43a-08dd4ac00092
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EfoI6e7rBRra6gzhuzsh6C2tbOR4gmiUjaA0VOk2lNVl/W53DaGwAFGIpXcs?=
 =?us-ascii?Q?XOf1jQjgFyYQQC3k0NGUMXn7Tl8J0J8gMQW+hRw04VscGfjBvmQwjLHnFN/5?=
 =?us-ascii?Q?Da04PLGhsglNdoFfVcyW7oWt1aNgnqpQhrFoLodSweeD9RwjjQJTpoYaxnH0?=
 =?us-ascii?Q?on6YayP/Uq0dz7op+lPMT7+hjh4+fYQC1CBRBNq9TGk5qW0OU++WX+lP9S9j?=
 =?us-ascii?Q?PfV2Iysx0Efd/24lcoMEr7H9+u1v5nbAy/HWOsSudqZL8Og3ItA0CkFvICvE?=
 =?us-ascii?Q?FEsOABrXZKy6g2dzg4//8NmswQxYNbAt6PZZPnWQiblFK/8XfmopvGR3KGZP?=
 =?us-ascii?Q?FOv9AxURsvCaTfdvd4Cc4bYRQ7cAqhHj7YdOJd4XnHJiwvET9wpCqf4a2JgE?=
 =?us-ascii?Q?eB+gm4zpsOX9LC8GH1tEhUB18vdQ7U0J+435ToYMiUxEwF2/iP76EJC0S/yF?=
 =?us-ascii?Q?Xrup1CCFNLOEoxOZrRPbhT3jJy8YAVPmEk5Aw6aJMnwBFvewp8mm5wLidSX+?=
 =?us-ascii?Q?vlvuSzRIMXHudl1IY8R4mwk6ooDQEQrKLKRaAqSL/QuuGgJFmf99AouhBT7c?=
 =?us-ascii?Q?bJIO5lyQ7ts0AmW/L0EJrrSqD9ScKV75XPKskIvl1N5kgRDMHQsnFfjqRKxh?=
 =?us-ascii?Q?zgBkPIKpAEhYDB6VDw/rADQJNCH/buvoU9oLl4wqAgMGR0kAJPnrWIPJDFBn?=
 =?us-ascii?Q?iKugaJ7D1RYnDiSwv4sUttkDLVpGAGv/CbWtW0zw2DmdeFDuqZ7hBN9Ap75c?=
 =?us-ascii?Q?myqn/RkmKRCXW8VNB7m64YZUdtC6zn5xLDkimOOoRz0Fg3v983W5lMtjzbmc?=
 =?us-ascii?Q?EtjM6zuQmpiWiLFrcUhZFBTcxwuI1lTwLeMCInHlpLcc3l/PfFTFmV9aSxWI?=
 =?us-ascii?Q?7sXBZASYysU7N1IwjeZpV0g/mBzxYrYnPsx4npRINbhBzc0xU5F2TqzKerFr?=
 =?us-ascii?Q?hhW4iQ3enyNkrW3oRk9Bm98tHqRmlVB2+bGFudWU0+D1ctKldL58Kg7yLOkf?=
 =?us-ascii?Q?qRy2X0+7qddDMrIFVirexBwGZTF4GXrsE7G2SgdMy0g2quloabcskcBf7WDN?=
 =?us-ascii?Q?68/NVuARKT7HCcrrimiVxUQ6YfmeaemV3GdLHx/DJ1cvkNE7USXUIHzZuuo7?=
 =?us-ascii?Q?44+HTQ1N9K2hF8aVUFgrBYCEhQGmFD0m/gvddYKv5Z86xT3ojOTQCZIEa/1l?=
 =?us-ascii?Q?nesBgqkpZh36rNGdMR8cq3OJpPMtqDYm0cES7hXrZbb7VrfQwwktMEvCAagO?=
 =?us-ascii?Q?2REGWfJS6ZPzuGeFGHnUuL8vxMQzJpA5eCi/kDI1OJVVCY5o4wO0Hrfvkr8k?=
 =?us-ascii?Q?4PUSdJCSumc6Be9XsxFw5s5yLsQosa8/g8x5CiktrdUilC2wlg8d05Y8L0de?=
 =?us-ascii?Q?288dS0kc3Gtvw1o3TkBZHKUoUQZR+SDcaM1JbB+aR1A+NJmVUL1T88IYg88d?=
 =?us-ascii?Q?2wQ4i3oPbBPNxZ92RTuSAd3zqZwC2/PVY+nhEDmt6IF6tFnqC1NZzC6lxAFG?=
 =?us-ascii?Q?klOuZH2lzHFjJns=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 17:17:45.8723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46f104e7-f3e9-4bd5-f43a-08dd4ac00092
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017093.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5605

With the CRYPTO_TEST now being run asynchronously unveiled some
concurrency issues in the Security Engine driver. These were not
caught during functional or fuzz testing as all the tests were run
synchronously.

This patchset contains the fixes for the concurrency issues and few
other improvements identified during the stress-ng and cryptsetup tests.

---

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

 drivers/crypto/tegra/tegra-se-aes.c  | 400 ++++++++++++++++++---------
 drivers/crypto/tegra/tegra-se-hash.c | 285 ++++++++++++-------
 drivers/crypto/tegra/tegra-se-key.c  |  27 +-
 drivers/crypto/tegra/tegra-se-main.c |  16 +-
 drivers/crypto/tegra/tegra-se.h      |  39 ++-
 5 files changed, 522 insertions(+), 245 deletions(-)

-- 
2.43.2

