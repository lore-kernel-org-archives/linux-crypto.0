Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEE72550BA;
	Mon, 12 May 2025 18:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073855; cv=fail; b=H54qr6Ye3OUVUNZbwdq4AksvkFDtasArF8kFOl8oqspbKIlLIJhIpy67sUf0eMT1yY/ft5CeMQBhjWg2toszMwVxAoA9j58MbXbtd1fDzTB1sn05G4LCM6UmctSuMAdcLMqji5p+lQSfyxttkrOfVdPh6cFDO2f/RMeU/kgzVCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073855; c=relaxed/simple;
	bh=5HEmO7LmGpaPBBPW3cBqm10LFWjBJfYV7BV/jbZfeuw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sm4GLtAAJrZe4g5IiYcly/SsgXb1eHqi3GaaPYjAc08Uia5+dGnCSat4aRAxaMW9VJ4jQKX8oOzf2nbIHnB/0LEHo0XuBclStgO6eeYeIJiMprY6GT/cVc08vjCJIPSbzwc3T6fuHwWFDfUD9YT22g19MvY2Ej+dKuVDQO1hNWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1+MEtRsr; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1+MEtRsr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBZ2wT4X2Wn9FTYtlGop6bItEO2r1XPreENR14zzQbd5cm5sBMEVQBJkvvu5R9gExiz1Qsz9NSTakQGqgyL8P54Wp0eAi5QqKO8dfIXmfGtl3ETAURWjWH9Wy94QL5/01bSakrLVvWex4JgjACFjK8BuYqL2Fv3lVcZ/E6/cODa0lbiWXGfUniFYOP3KxyGch2IkFiiBB3MrzIkuoRUXP7Fq6W5SrJ+fTCRf47VUZ2be72wF3ONVKk7pzHBplYkj+nD/7+0BuKOfmDH281eXDzxwygO71UP0Jcy1lLpgB2shTyNrFBBJDMD0BC8cTD/pX8s8CotXX7y38wJ8DqEagw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0tKJsAmTyX3BjTWoM0nQTYbfOpo/5JpO+yuVVA90/Q=;
 b=ou3p8oFvw2l+Aywc6AKhqhePT65a9tl6Y59YGIDJiRsYh1nzQ7sxi54Gfj1DucAXKK0oxjVfkgqHsgg4jK9H3q5f1jL+hfueogESU59N/pfOxzDuWpvXYJQ498oeKXQ/YOnWL2c7/WibswhhVuuBStA/THVDbK6JxIcCnaZU1zAFpFhNpPyGW6NWUH3IDC4QWDdF/Z2cAOMqyca9bBi5KyBKGydEb1KDD8MRwPRTK4/YXml5Glz3OpkvuymbzkwBnlG+dDkTnlst/e9yGHN4p0cbunNF2nIH0Dm5RAJDvCrY5oEFStp0z61iT3Kt041ZXHKEEllR5WsTgtIf2jwLKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0tKJsAmTyX3BjTWoM0nQTYbfOpo/5JpO+yuVVA90/Q=;
 b=1+MEtRsrx0t1Z/uM2OsWD0Os4byZF26UKRDVgaUuUmgo362eow+e+82iQ63ZpGJa969ztOsOtlIPYBmMzPHgH3p8yuxB4I2UeauLrBPvRmTXKET+T2lHnb60Zhylv9b+NwuxMA9/k4hrOcuFTmvao777ELAP/WNaW52xEQMfDaM=
Received: from SN6PR16CA0043.namprd16.prod.outlook.com (2603:10b6:805:ca::20)
 by PH7PR12MB6881.namprd12.prod.outlook.com (2603:10b6:510:1b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.25; Mon, 12 May
 2025 18:17:31 +0000
Received: from SA2PEPF00003AE5.namprd02.prod.outlook.com
 (2603:10b6:805:ca:cafe::54) by SN6PR16CA0043.outlook.office365.com
 (2603:10b6:805:ca::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.31 via Frontend Transport; Mon,
 12 May 2025 18:17:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AE5.mail.protection.outlook.com (10.167.248.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Mon, 12 May 2025 18:17:30 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 12 May
 2025 13:17:30 -0500
From: John Allen <john.allen@amd.com>
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
	<thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>, <mario.limonciello@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH] crypto: ccp - Add support for PCI device 0x17D8
Date: Mon, 12 May 2025 18:17:05 +0000
Message-ID: <20250512181705.2428-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE5:EE_|PH7PR12MB6881:EE_
X-MS-Office365-Filtering-Correlation-Id: 6558c813-0cda-471c-3fb5-08dd9181428a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YOCQwwxRI+YHxgszWjjxkvgoaE5zUW/I8yL2N8JYw9un+jC4yOxqm70WAeqi?=
 =?us-ascii?Q?NNzWWVLnciiUF4esR5DWkltdgpb6oGqNPZ9SysDw5jaLV/GqS3F4ScJZ4DP2?=
 =?us-ascii?Q?LYvPGOxFn70DlbrVXFwqzrdLDkYzaVyzg5QZpJJzRK5TnALl7BTgwHzVh4iu?=
 =?us-ascii?Q?23xfdnFCF/T8vh6OuBuaAhVSzszQQTP1sY6xcKG763e8jX0WZlaXyuuKiwCw?=
 =?us-ascii?Q?9sZB34vy0waMEQEnpE8DKxHIrCvcCEayD3yns1gFS+HDUnRUX68hSLMAaFXg?=
 =?us-ascii?Q?YRXka2m9jAmOMpw3g5tMCNsEWlxMi5hJtvcKlB0IldPVBaD/YAAEAK6C87V1?=
 =?us-ascii?Q?nrBxut/yXNoEflAg0PWPLKxN9GZe9OzJxF21BQGwGQ+/RZj7MKpEfXjA92JO?=
 =?us-ascii?Q?bEt3E9KY8t8diqhCmzFaAG4AD26+k0B3ttkzlNh2YpYlYM6hy7KXdeVKOUnB?=
 =?us-ascii?Q?uNVdr1A8375tnJWRNK0wCYNhGS/Nf5l2D/RrwxuKjyKo78qrpdufPDgf7Ezo?=
 =?us-ascii?Q?SjwYSgjqT7rcY8qFZn8FEANOqBR1VxTJJfeoZYbN19LKI7l+dDw8FQdGgZVP?=
 =?us-ascii?Q?rQVFd9//+StfBn4Euxp9SSdk7EAz+hulQMQxHUK8BuiYSjv93muqdbe2OoG8?=
 =?us-ascii?Q?NOdcgpfJV2ubaelvowJVacq2EjmKu4+gEo8ahqS9CznfoaSXJoOv/FZ7RGxz?=
 =?us-ascii?Q?+LpLzHaF8EuUAmR4d3QmpZQ5JdejJzfyq/EgXRebNdNutxshUHuc7nSD9p31?=
 =?us-ascii?Q?hN33e4kQgjoP9CTgf08kMtW0KsLloc1YyW4KGbKKjPV9anELoNIFl6HbaivC?=
 =?us-ascii?Q?Pda3dRJqZnx93wqeFKAgDEdYfQ/piP/zmvorCwH/kJGAqQxHBGkxT25SXwK0?=
 =?us-ascii?Q?QdjkztK7WMWYKDDyRCm3unM2YL/GjOhgSgvvUMVWVqMB3ku70QH0vqVdwXKR?=
 =?us-ascii?Q?XW6BHFhHBhwqsQZStRm9cSnjMcqaMAa2FCDAO35HlRR5aojXEFAMJgzgrNJy?=
 =?us-ascii?Q?p4LNAzf+QWZPaKa0s6IGUgRCWFhvon8GXkoMrJ9bcFiZ9VgHRxnd8WS+m16L?=
 =?us-ascii?Q?Nm0zKwNqOa9kfG51DjCWIT0Rs2jrayf/ARpbsWQD3SmzwuTiEeyUMOgwN85Q?=
 =?us-ascii?Q?Zfqnik9JXtmBY5AtTsMsexpb4hHFoUS8mhUuXwzPo74WxrK/oFhzFu5AK61K?=
 =?us-ascii?Q?sfXxHKvfKlbNRR0yWfRONnhDpYa05bd5bIBfGd6O/YHEf4gfMKpM70kilisw?=
 =?us-ascii?Q?gRGlCv4O9irwmMpWqhMoulCl828SF+JfTIf+HfJgHChGDdoU3sfzVBuQq9iK?=
 =?us-ascii?Q?WoAF44ml1hedW7esuOVCUWBzr+H63qqlRBa5gEe4J35pQp66UCmlW4Y4RuVu?=
 =?us-ascii?Q?S/5gV6HYg3vN6dQZvhq93Fh7DSuAyzRQLQsYjVl2nkN3PgJKf0f2Hhf+LTdf?=
 =?us-ascii?Q?Iw/HLOOp5BlgNAryATHZAwj1LYerbUcxMvHRinlfj01bCfLKUgApe33VMHHK?=
 =?us-ascii?Q?m48CD3KAakcnz0cSMPmBMulEUMg9jpSGDtfH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 18:17:30.8853
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6558c813-0cda-471c-3fb5-08dd9181428a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6881

Add a new CCP/PSP PCI device ID.

Signed-off-by: John Allen <john.allen@amd.com>
---
 drivers/crypto/ccp/sp-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 2ebc878da160..54ab3279f521 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -535,6 +535,7 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
 	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
+	{ PCI_VDEVICE(AMD, 0x17D8), (kernel_ulong_t)&dev_vdata[8] },
 	/* Last entry must be zero */
 	{ 0, }
 };
-- 
2.34.1

