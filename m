Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCED0190664;
	Thu, 24 Jul 2025 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753391774; cv=fail; b=E95mObUmwzEKXglAQkEW6H4EHeewHR8uYCG5jUIMMSWBJOmcC1bB1QE6JNAzcRy4MpRNblb5B7tB4nG55MXN/TRoMOxCfJIspr8m5RoMdQHDlmSgftjURept6A0rKyiamZ2rbcsFYTXFnHGDSskAzeacKgVlAqHGFR4/8108rhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753391774; c=relaxed/simple;
	bh=qQqCfBlKjOD+VfvfESERHRzAPgRbtHXGLqr4ArsFSWA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aO2P5ryeKr8o2inaI+Dw0R9579fnXeojrYKjk/mhB+sN3/roWsBJMpLIcxcm0BjTnU4APBwftQv/h/5zljZtwxJbi5WeXTRK7jKNiC24griMO87dpB5/fnC+CyjftL2b7+qakcFTl58ruc+GqKg+UQ+2sPTuP3pzF52pZ9+V29k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IDGUNQ1d; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IDGUNQ1d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oF1RexBSUvckOOE2BDRJi+Czn0RU0NqQOz+EBPy6fnHdvLOlqTO9tf4K5/T2dCJcc4rI5MpAqHsT1mghje6n9XBLlExeeK8ZEr7BFAX5o8xLrrKc8SpKMjEG1Q6M3haCZdUvL+9vMLKIckNBWqfiTzvJCkM3PPhD52kWh5D+vA5tLokmGzALwYv04VAnQrkAJLY+LS9PtTHur2UnQ+Qr7hdQS96dSNRsDDr/Q7F+bfZN7NRhKt6o6b1KOHrWypSXCzu/3hxb7euORA+++NSt2Fe9hIdeCjRq/B3sA28wSm9wh0vkgjnB5OQF0OzeJoDfmjGfEqWomwZ6hN/MOQDwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1+HSXzbr9+udKeEfDdkmsDikpYyqxL7HFBmd4B2+k8=;
 b=Vy/go8bR/3p1o1J75HeCLi1D6AoG0cLeB2euOu35wy4zCM5r+o8+4PWhepLCO4x8I8GU8LT7aAtFv/1U+2VTc8TMsi1I2Sm8wRfJdzCNPyzmk3dPDkoNDyrgLcOmE71SOW1uPY9eBW4o98d1IiQ4XsBR9dFuSW9BqIKNbP40HRYr7h7yCncDX3aupYBmB/fcr3/L3kK+m4sLojxRFZtmquMlfqUsnDF/IEAz/KBb0ph3jEGJB1njU1lMZYScuaH1/sbFvGYcJvQxmCxjAYdjYkW7Oar66HqV05mqc4Yc4u9ZmUC8+rd6thxHNZZKpOmQmqfosg59o7/eerBCWJdZxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1+HSXzbr9+udKeEfDdkmsDikpYyqxL7HFBmd4B2+k8=;
 b=IDGUNQ1d9NZULcpzVibCH2abaRJNnxtKSUudg71K0yE9xOkhM/ZllS2c7jw5LXEYexDo3ap4T0oS1tytzW6u/8H9GxhgNQ0cKyGpZ9BKgpcaH3L7eUkcRdJzHmbefTEE7F/4BEs1D2uB9uzkt4vA8/ZY7I4nRe36JML56vBmWmw=
Received: from SJ0PR13CA0162.namprd13.prod.outlook.com (2603:10b6:a03:2c7::17)
 by CH3PR12MB8851.namprd12.prod.outlook.com (2603:10b6:610:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 21:16:10 +0000
Received: from SJ1PEPF000026C6.namprd04.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::1) by SJ0PR13CA0162.outlook.office365.com
 (2603:10b6:a03:2c7::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.6 via Frontend Transport; Thu,
 24 Jul 2025 21:16:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000026C6.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8964.20 via Frontend Transport; Thu, 24 Jul 2025 21:16:09 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Jul
 2025 16:14:19 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <michael.roth@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver
Date: Thu, 24 Jul 2025 21:13:48 +0000
Message-ID: <cover.1753389962.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C6:EE_|CH3PR12MB8851:EE_
X-MS-Office365-Filtering-Correlation-Id: a5335f28-290f-40fe-0804-08ddcaf74f74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U2efmc4KO2tpUEE9Z+gqNLDo9iCq4AEbfweCMfiDJsf55J6df8dVfBhEtCRY?=
 =?us-ascii?Q?MBsoiF8Gaw74gmpoeWHNWzHgRrQURIQvW/D0XRx/33aw2DoUrCdEjxWHXs3i?=
 =?us-ascii?Q?PnaJNbTkpNpydxUGe8tL/Y9KrgMNlUUumIQskDT0vJKkTQuDlqm/vc34Vv/J?=
 =?us-ascii?Q?LsiHLuYpjDdyls9lR6HgdsYSdWfEG7qUMd5f+/cWahiob/GXxyZzv1BaV4ID?=
 =?us-ascii?Q?PmJmbTUUGinqY5lZoMTdVbxnNOOobKJSj6pvzX9xJzLzeQxUoU705qATc/Vi?=
 =?us-ascii?Q?OwrDLFracB7nrA94O2crDhQe+vUeZCgPNNgnwHX52GWn/30EuDv56wb0MFlQ?=
 =?us-ascii?Q?jKl4AuyC0LqtT0SAusK8I/7/uzMeZDfBI1ApGGI97GvNdLMBzfHHmu/n0gly?=
 =?us-ascii?Q?1MZCkFw4+XKCrT6tSQcA782DGNVYfFH4u1L/uKSCeHysCukUist7vdpDO1Xa?=
 =?us-ascii?Q?gRKlvtBPHs/axCDU0wGxo4Vr/BK7Lrst14P/s5YkAhiWg8K2soB4EVUSR9MC?=
 =?us-ascii?Q?P9WDUYjWVlUOKLNs/swv065sI+hQCmi0j1p1/IgNsz8xmm3zVsfqLG3t3udC?=
 =?us-ascii?Q?fMdrnnQYPZgLuOLle94HpbWCB25HaSxo7ISRpSUadJmbB35V5fSfjgAunG/E?=
 =?us-ascii?Q?JaKzqBL2Alvf9RO/AqQyD52TzbZvvDSo34acBL3GpQm7garXCNyQRrx0wufi?=
 =?us-ascii?Q?Q7kAVLgtUluIj4QESjZgFXyUT7UWfJCYfLp1/TFHghBBwxdGnedRHTk3+AOf?=
 =?us-ascii?Q?9pvZwVfWLn4JI6eW3jNofQjam0Cn3i/5069f0HjyuiHgY5c/RfaWuxBrgwoF?=
 =?us-ascii?Q?t1Gy20z33VBk0YKoQIjod8PStw1+LDtp9xKGbo+JTvsTvb29ziQ2+LlxIv1Y?=
 =?us-ascii?Q?PyYuZHoog8QMavOS1ZHAwuYbj5tkx9kdMmeDawF5FLTMEXn/dIqbGxTLT+zO?=
 =?us-ascii?Q?IQ4/uqfz/+g60xstMqkeXesfZl1iS2Lx+/FO/XIsj6GcKjaZ+YYogQPUfIjS?=
 =?us-ascii?Q?qq4Cn1llSFK4w6X1UE+pl9tncNg/hJirqWwHqxHDaJhQT3EvM62f1TjumQn/?=
 =?us-ascii?Q?pCmnhGmJGvuuzRNqqjdagBmNftaRZ5SgKoLGNLikXCoMGFEcvuWC83xqBhJG?=
 =?us-ascii?Q?HfbfcOgv2xxX/DDcSyUfHUupIPygs6H+njIR9K/0b2s0YeER7TsrniCUObJI?=
 =?us-ascii?Q?LQ33DMlV37vJMgRWppAfcxtNmD3/cD22Mw7QvrAzIQ5DiSTJNxpRB9Zmz4Yb?=
 =?us-ascii?Q?hZ23xykWgGDdUF2vygmST9NJUf75CkGhOGwMEVNW8TVLZeb1oFBJrFh03ZY8?=
 =?us-ascii?Q?mxjfnErp3QyCs9ZoTWbHoREVcJRt0LYAqogPBe4QKRpDc2d8MSsEVBhhmXUX?=
 =?us-ascii?Q?i3YuqqPOVHW7QvoQsQpuGhguZ7PDlYgFbf82I0eUmRfrY67y7hsSqFsDOYKt?=
 =?us-ascii?Q?H4GHNNx9TW0VOABbk4MrJWdhRGKVdSk8rVbwjliZFWvd4S3YfEicxG94edSH?=
 =?us-ascii?Q?YaRxaYkg/Y7kg68AX7SmjyiVime7/H7K/Ox0zejaiYxEN7vQkImaqkGxFA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 21:16:09.3871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5335f28-290f-40fe-0804-08ddcaf74f74
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8851

From: Ashish Kalra <ashish.kalra@amd.com>

AMD Seamless Firmware Servicing (SFS) is a secure method to allow
non-persistent updates to running firmware and settings without
requiring BIOS reflash and/or system reset.

SFS does not address anything that runs on the x86 processors and
it can be used to update ASP firmware, modules, register settings
and update firmware for other microprocessors like TMPM, etc.

SFS driver support adds ioctl support to communicate the SFS
commands to the ASP/PSP by using the TEE mailbox interface.

The Seamless Firmware Servicing (SFS) driver is added as a
PSP sub-device.

Includes a pre-patch for the SEV driver to add new API interface
to extend the hypervisor fixed pages list passed to SNP_INIT_EX
to allow other PSP sub-devices such as the SFS driver to add 
their HV_Fixed pages to this list.

For detailed information, please look at the SFS specifications:
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf

Ashish Kalra (2):
  crypto: ccp - Add new API for extending HV_Fixed Pages
  crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver

 drivers/crypto/ccp/Makefile         |   3 +-
 drivers/crypto/ccp/psp-dev.c        |  20 ++
 drivers/crypto/ccp/psp-dev.h        |   8 +-
 drivers/crypto/ccp/sev-dev.c        |  88 ++++++++
 drivers/crypto/ccp/sev-dev.h        |   3 +
 drivers/crypto/ccp/sfs.c            | 316 ++++++++++++++++++++++++++++
 drivers/crypto/ccp/sfs.h            |  53 +++++
 include/linux/psp-platform-access.h |   2 +
 include/uapi/linux/psp-sfs.h        |  87 ++++++++
 9 files changed, 578 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/ccp/sfs.c
 create mode 100644 drivers/crypto/ccp/sfs.h
 create mode 100644 include/uapi/linux/psp-sfs.h

-- 
2.34.1

