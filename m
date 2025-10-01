Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010068.outbound.protection.outlook.com [52.101.56.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113FA302761;
	Wed,  1 Oct 2025 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759329891; cv=fail; b=mGIxrbgSCDQbQqTDROu+00G7q5IacM3AHhKfGt3cWGIkzwePQWk89l3a/lwcDReh03i/XoVc+Umx/xADLMMbaFZFegKY0nDmR9nDVqR/HhI8nhvVT8ynAQC4QNKhWe/6eRoQPg/ST+Q1M2u88Bnv6JkyVJdGcB4rThUryjxNS+A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759329891; c=relaxed/simple;
	bh=5MwQSCuMtQCGs1Qdsju+0pnBBzYDXy1r0FyEMZFP49c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MqBQrATflP4413gVFRZ0EoikzUvVUPUSj72le33x6l9+gPy/0M32dY5T4nVZvuGStgGtPwi5Hx6pj1zM2okj3ezVaTrFxul0AbqC7VnbonzAM0J+xbb9ooQTX/LX8jr6LfIOKcxSL7Yi79BWg9OklpnKtcUbYpwt1pkOoGHMjf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pB5+vFy+; arc=fail smtp.client-ip=52.101.56.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pB5+vFy+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ClwpIgUiakctVBrWcoOV1Wg+s7Imgwrr06sdXTANQBFaoi4NWyCAUeuNe3ZiUrhzH0YPsVClCxehdqyQQFOsmQrKtc2AP4/62TBKlN52/cI954K1TZyuNkk12biagdt8fPLzQFyjErA9lzxx9zEt5HAgYKw3aur8Ta2QAH3tljsJFVm5FBoWbUzFftY2nyCn+HNEVPjVsc0JX6nWuv1yIcl9I8kLXAJKQBCEJjSHHmy/t8RJnHLmrYEyLI6nSvHp8hRfpS7km4Kv4Ae59ZYhlmSRTrfR0xGVbzgVYhTW0zBC1qHJJSLapjqOKdGfe8Ca3C4xv/6Z1W5guPzrp/zXcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t52gg9TijEzuOXsUMPXK5lYGU4Ypd2S+Qedq+NdBIAM=;
 b=OZwspI2Bo0GLGZKLRyYIryQGl6ClofZOQKZ+32ptk9Qt3a5pdxW/GGea8OXp+PIW+mseu/MBbebXt1yAruwUYGQGzP3P3ltC5BzLz7q6asb3T7s4tUDE/543K3CkRDc74Mjecg0i0nzTZhXcLBEhK+RnOfw7mLFL0vKuBtwcWrjrP9d0hK3ZjdgnROJuVruGnKn7ielOLyIef2y4ciWxP2gWpbd5TJ/rOZOOz1gA7n41O8YCch6yHP1P56AOG99wFatD4nwjkzAOSmSCOJGZrFTD5nfCz6r4ryHHQJOr63IFWEqxuuaoOy3DS8O994uehahD2qTs18xt9I0C+MKbJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t52gg9TijEzuOXsUMPXK5lYGU4Ypd2S+Qedq+NdBIAM=;
 b=pB5+vFy+1CD0JLdpkm+TIdBsLnCiaGLIywoE6TI6yPdaZdBN03+FYVup4EwLAJkH1PNh7SqmB4HwaUqOhbLkAtEqoKUEvxrwfZI4eujK52kCPwsUV9R13mfHb7G4NypQ6bkkE8oDJtpju2xmwbFvzvjDTlSbPvZimvNS2sYMMms=
Received: from SJ0PR03CA0059.namprd03.prod.outlook.com (2603:10b6:a03:33e::34)
 by SA1PR12MB8742.namprd12.prod.outlook.com (2603:10b6:806:373::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 14:44:43 +0000
Received: from SJ1PEPF00001CE1.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::fa) by SJ0PR03CA0059.outlook.office365.com
 (2603:10b6:a03:33e::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.15 via Frontend Transport; Wed,
 1 Oct 2025 14:44:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE1.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Wed, 1 Oct 2025 14:44:42 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 1 Oct
 2025 07:44:41 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <kfatyuip@gmail.com>
CC: <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
	<john.allen@amd.com>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto: ccp/sfs - Use DIV_ROUND_UP for set_memory_uc() size calculation
Date: Wed, 1 Oct 2025 14:44:31 +0000
Message-ID: <20251001144431.247305-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251001075820.185748-1-kfatyuip@gmail.com>
References: <20251001075820.185748-1-kfatyuip@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE1:EE_|SA1PR12MB8742:EE_
X-MS-Office365-Filtering-Correlation-Id: c981e84b-6a84-4b4c-a467-08de00f90ea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+7ZRPKVc9lwWkup/3E5VDECGrBLqMhosFlqdZNsNOyHGODI2Ot4S+sl3id36?=
 =?us-ascii?Q?bzMDyMaiSLhhJb4arRLIWqjyJA6Jki/kDEuy26VNJ0QcazNg++HQ3djLjloK?=
 =?us-ascii?Q?2/+hjdfVRHbU5P+qoReOiWYm1ZyrIhuWEhuIr6YargHJC3Pu8l2APDrRyobV?=
 =?us-ascii?Q?wa95gLHiZTl44SqjAtFs0D3feOH6j2h+KAHEgupCLJ+qMxp8Fq4cmSDXh366?=
 =?us-ascii?Q?ax4H1XIImgHXjigOhm3meYzvBmZjAO3M9r+DRu2sD4Nda+ZNPjH8m+GUISCX?=
 =?us-ascii?Q?FqKubZvGPFqCEGiVFyVZdS0kHOicYH1EJzeR0+5+SxNQ0WJmxcfkjWuS+pqZ?=
 =?us-ascii?Q?/naGizNoKca/xgAJARRLG5MD/zALhmu5SzffWksTmAZSWq+055FEypAPZuMZ?=
 =?us-ascii?Q?v9wV/IbfXmOEZ+0aWHhJdj6GHvyVl6UNZmVQfAIoyxYIYNBr7MfOOOWllan5?=
 =?us-ascii?Q?RHWJqdXzLl5ENSSw63Seq3BvileKO9mkrIHo03BWrIhRg+jVJUs1/9wOJ++L?=
 =?us-ascii?Q?8OOiWeGAmOKMFYL2oXLeCK15yCPv5kLFCO1bEufxHfAUwPB3otVK6eFzozB2?=
 =?us-ascii?Q?qmf3HUgdFOvDtuTJHkxesyZ5rl85/rCsF3ZWSZx1uevcTkJdYZ2P8EgVG1nc?=
 =?us-ascii?Q?QQKhrtpcmQQbSjOu8q7yVr+uPLVk1lVoPnW3OVCLOCKapk7xJW9VlJroBkOK?=
 =?us-ascii?Q?BxJpI/nw5r1fc41M74AselIoHWc4TYxpnuQEc+npC1ZcraAU2mNNbSNLOpmC?=
 =?us-ascii?Q?Lr/xYOlwAuOJAuh9gb/n5ZdC82P1tsltKT+yNFl9ARUj5oPfx8VTLUZBLS65?=
 =?us-ascii?Q?qnbfQleaoONaGR7WyuaQMAOPptRRtFCokOSowjcvbzlfUOofbCENnvMoXmA7?=
 =?us-ascii?Q?Ta002ItuyeR68NJ4QVNtRb0WOTmvtvReUBfhi6JOtlbFWPtVhkfNoTQxO7Ea?=
 =?us-ascii?Q?HAA86ECjcaDCGykevxr5/CuLzvQQIXmjzshwjO0GI/w7olc3lh9TqhPNsjMQ?=
 =?us-ascii?Q?AN+waIN4UwLeU51PRS6OTdOOQYDIzfCPYWjuSCcNjU5YR/k3JS9Awyb2Z4wU?=
 =?us-ascii?Q?UF3VWh8ZYLB4CFVkIl4EzyrgoPBtH36viYamhOfcpqE+lowxNiuYwC2FvSA7?=
 =?us-ascii?Q?2SzhHLmEL1dqwKpeRo4tls15JNlbh0JC9YQmx+f7RJ+wIyzKAqto7SB8hBRx?=
 =?us-ascii?Q?To/fRNgGAjNKMQkpoiiXUsP24etInNOLUdYKqyqeoYqsicelXAzpeAJuS/V5?=
 =?us-ascii?Q?Vdj8GFKUpLJSf2ut7QrxiUYxnvNz4v/zctFa0QRjpFlJoreyVyEBfSBSrtqJ?=
 =?us-ascii?Q?ZUszUTFPswBaSHsZy1VKEY0sjGj4PZzHMeVIbeUIljj85KO9gqKx/hPiJu5B?=
 =?us-ascii?Q?zywO9Nilu2JuQwdr1IyMJGXE9LPyBQ9lJqt4df0WM+8bMnQbnc4H2qRwMbuP?=
 =?us-ascii?Q?lgigSxE3bPWPOC2bZC1Q8bpV2g5trPhV+mHyVI0QqqXxuyhPpCo/bntdqZYJ?=
 =?us-ascii?Q?0wEgdWxNADCvzawPE/AR94XxuPnndSDKx58Q/NXCenWrkYqy51rcr8YY1Gh/?=
 =?us-ascii?Q?mrU0TaRedVOmAqWm62I=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 14:44:42.4379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c981e84b-6a84-4b4c-a467-08de00f90ea4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8742

>From: Kieran Moy <kfatyuip@gmail.com>

>The SFS driver allocates a 2MB command buffer using snp_alloc_hv_fixed_pages(),
>but set_memory_uc() is called with SFS_NUM_PAGES_CMDBUF which assumes 4KB pages.
>This mismatch could lead to incomplete cache attribute updates on the buffer if
>the payload size is not strictly page-aligned.

>Switch to using DIV_ROUND_UP(SFS_MAX_PAYLOAD_SIZE, PAGE_SIZE) to calculate the
>number of pages required for the attribute update. This approach follows kernel
>coding best practices, improves code robustness, and ensures that all buffer
>regions are properly covered regardless of current or future PAGE_SIZE values.

>Using DIV_ROUND_UP is also consistent with Linux kernel style for page counting,
>which avoids hidden bugs in case the payload size ever changes and is not a
>multiple of PAGE_SIZE, or if the kernel is built with a non-default page size.

>Signed-off-by: Kieran Moy <kfatyuip@gmail.com>
>---
> drivers/crypto/ccp/sfs.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)

>diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
>index 2f4beaafe7ec..3397895160c0 100644
>--- a/drivers/crypto/ccp/sfs.c
>+++ b/drivers/crypto/ccp/sfs.c
>@@ -277,7 +277,8 @@ int sfs_dev_init(struct psp_device *psp)
> 	/*
> 	* SFS command buffer must be mapped as non-cacheable.
> 	*/
>-	ret = set_memory_uc((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
>+	ret = set_memory_uc((unsigned long)sfs_dev->command_buf,
>+			   DIV_ROUND_UP(SFS_MAX_PAYLOAD_SIZE, PAGE_SIZE));

I am not sure, i find the maths quite straightforward: 

The command buffer is allocated using snp_alloc_hv_fixed_pages() or alloc_pages() using
an order of 9, which should be allocating 512 pages and returning a 2MB aligned address 
and then set_memory_uc() is (SFS_MAX_PAYLOAD_SIZE / PAGE_SIZE) which computes 512 pages.
Also the payload size here is page-aligned and is a constant.

Thanks,
Ashish

> 	if (ret) {
> 		dev_dbg(dev, "Set memory uc failed\n");
> 		goto cleanup_cmd_buf;
