Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F1F12D75A;
	Mon,  3 Jun 2024 15:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717427559; cv=fail; b=gXw4Lbe/6Me8qpcQig5AXQKRrizAEza/L7loPyo0FmnB2MIrKA8Bwabo9VsYAmzc9P4P6vGOSThfQV2cGuFVTVc9ig/InRDtVk8pocuHyRiDrMhbzhRzsxYoI6NeVkEp7rStbD5Rfkw8pnhnqU/jOUAMEoN1gajApb/v9q03AKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717427559; c=relaxed/simple;
	bh=gQW2jTN1EBHvxW6keKZyJT8JxVSMyAXgZ+FjaAkvm4g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fFbGPLVnAYIpuUMYzu4LO0BeBQQNGP6VPhwRXfhPErbqYHGJyp6BUvgnXVUVC0ODxc9n/0al3wQUjW9tJFC5MJQSTFT2kq33p/Yu73Gmz3Ve+5RdI1VdHCoTfMVtY1245FuwZ7NpQ9P59fKh9PkW8VPghAw+4XTjByyHSqq/vzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VMxeX82F; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VMxeX82F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GN13ZVWmb7fLKdUfIUBRek1uKEDf8h0trMrFO9IkdyeGcKsqodeiIdeK8bi2n1YhCt5IZiqWWm3ry62PO/cj19YMqhW7rd1IxEs8UZOwoLwb7fDpcBNP4YtkPPEEww1/u4VVGLdsVLCjLu5T0pjKbRvTuqkQxzBFvoWILS9/y9Ur3eudhx/2O8EpdRPGIXI8689E0L9u+d+mCPN5o/br6gKKJd3KJUQrJmIsopP8vvTovqgcW7Z9Ex6EFaGgt5cp+OEfmP+WxK6MkFIZgPIAU1NmOHSJuwS9LDS/bwlreCEZ5Mo+1ORg3QNnc0GDXD7OoQ1ZPpJDirCA8EvABbp1hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gu8Jcu4sfrTSP/HqHaM7v8NTvYeBN4DA5lxRVP0S+D4=;
 b=ebMIw1LYSDPM+ZZcq0u43Z3L4GI4LY272c6R/PMWJ+42d5u0hY9AnQw3TRZnDJ0guoMKkK7pJr93z3m/PpWXUFVljkCHRDSepJF47lbZgMRthPlIY5q004cJYfOS3f9A9n2JSazGkAOCKKR8QGixNi64eiicm5EpUXddWojDnDXQaVScZ04MRVFtTSi1upTqf3tC0A70aQlag9WUXBJJSYdoBi03oj+yX5WYW6y+rW+bcd+VbXEg737j80utSXwJSG12EZKYrzQrFsv5XTlwdJooRXeD/LrnnQ0c2oxxokC3RId8iy89FccBBnJbA0DoiUohPf2ZefTzes6LJNEOKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gu8Jcu4sfrTSP/HqHaM7v8NTvYeBN4DA5lxRVP0S+D4=;
 b=VMxeX82FVWtGxS/dQVRBf0ywKXJwt8bb23mM4+AU4hMbg3yHfX2Fk3ngkprQ8Cr/FvFFDl+50br7Z3oax/wvj5uYF9Sd/ESGfFFGyHcWL9qLVgCVo3VX/GmZDcFCtynb8kLro0te9oGFd7D9gmf/k895SrEhpIVzuUsgpz3uO8I=
Received: from SA9P221CA0018.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::23)
 by IA1PR12MB6459.namprd12.prod.outlook.com (2603:10b6:208:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Mon, 3 Jun
 2024 15:12:31 +0000
Received: from SA2PEPF00001509.namprd04.prod.outlook.com
 (2603:10b6:806:25:cafe::51) by SA9P221CA0018.outlook.office365.com
 (2603:10b6:806:25::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30 via Frontend
 Transport; Mon, 3 Jun 2024 15:12:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001509.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Mon, 3 Jun 2024 15:12:30 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 3 Jun
 2024 10:12:29 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>
CC: Mario Limonciello <mario.limonciello@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Kim Phillips <kim.phillips@amd.com>
Subject: [PATCH] crypto: ccp - Fix null pointer dereference in __sev_snp_shutdown_locked
Date: Mon, 3 Jun 2024 10:12:12 -0500
Message-ID: <20240603151212.18342-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00001509:EE_|IA1PR12MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: 580ef1f7-0150-4b24-83aa-08dc83df963b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|36860700004|376005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0elUgZzfkPIPeo707luq0Dvj3OrXMOJ53CX96TvJNUwAbs16aIAMgwivHnwy?=
 =?us-ascii?Q?r4Us+eUTk2JoPV43ObUAds47+BVyZgqAoABaWoKirhDOdmrKmEIb7vnz1kwh?=
 =?us-ascii?Q?r0eNfNWTFTa2dXca081omnDi9wn0w/eDhWoI2Gk7M/ZDfm4RO92QKpDvod5T?=
 =?us-ascii?Q?5O33m0aMEIcGG+D7th2SBqKPwAvk+H7al8EeWP9CTYyfhDzVN1BQlB/6NjUT?=
 =?us-ascii?Q?nbydKkM58AOaWNzIrNm4tRoHMzCZdfRlwYJqfEKSTLkpPKPXchjECrzSpMUA?=
 =?us-ascii?Q?EM8iHUIBEVr6981tzC+ft8rlfgCbwI1pplRlp/D41/C31LQmnmVpMlBvy2JU?=
 =?us-ascii?Q?67z06/g+ast0fhOGAj96LAmLKLzXS1KGFVFMQCQn2b0NQ8A7xX7StB2qbylV?=
 =?us-ascii?Q?0YS5PQQ3VnnQIqyzygArHbk4+clrqk8K9v58C/NeEzMcohRZ4z/94F+ajL2u?=
 =?us-ascii?Q?YSIWLZ8nz2pgaAckvbEpnlOsCDFTfDka4N7rcxT1Ahk8+Avzpd9XrS1/Fl24?=
 =?us-ascii?Q?BdvAZWgyIu1XKm4ozAegPjaiCHfyunufUt466Kw4LXwjsrPTfBZSIsM2zYSr?=
 =?us-ascii?Q?nuNvVurrSG/JWZ7LIi92KrDX0WnuFnN+GyibOBt7R9MvgKrzKN9uNHfflmeQ?=
 =?us-ascii?Q?hNorH1etkqyPMJlvOLsgCaUH/ZMEX3E5ieCMhDDwcjziYuSxyHj+m0WRYeYy?=
 =?us-ascii?Q?Lfjjx8XijWo4aQlvt56EkCctakcw5nzoH4k+rquaueBX3xVoHDA/Qipk4u3l?=
 =?us-ascii?Q?P7C0TTfyOkc6cjzd/7f6XLNZEwUat+dJCH5QWhnv6lc1uY5R9OqupfxlkVNl?=
 =?us-ascii?Q?Tw/UCp4JNDsetBFBBT9KKuGrBquuYGNsSQ9zIT8fsRSvd3SLhWWhVouIg3mz?=
 =?us-ascii?Q?hRBOr8Xg9vWRsKElqvEmURvW4sBBaxVaz5N+L8ZpJu8wIbgIUAiuf9H5eMa4?=
 =?us-ascii?Q?DHxVF2FN5Y6Jysjvt0JNANgxqg7WaX8us/5SqQY3nh1o1YHAy7aqQqScxU6T?=
 =?us-ascii?Q?dtGgn9wm8Y7zXwvnsdsVgMz3V+CZ5VzTCGQFrySNIayqxxiw0ra/BvuiWzbI?=
 =?us-ascii?Q?KHallyo/wbbRvVJQLOQl8270Zt8dXkRDw+u+LB+md1Yl6eQ/KJ5NIs5fhNCg?=
 =?us-ascii?Q?HQk3sKKJn0nCJqGkgLgjuIiJNUxq8lun0GOACao/PGpExSb1RP4wmUkpP2SY?=
 =?us-ascii?Q?tZojosSyrmlDs9zzteKeuDIGA6wx+efmAEnIG5x+p7BE4hm8gNmw9MV3Qu1x?=
 =?us-ascii?Q?OLXX4q1QXvcmBP6QtQjg+o70zG/KApGlhWDsqXE+ELznd2+8br4JHZAv5ymk?=
 =?us-ascii?Q?CUVv6nB1H+Up5NrUaBqP8UIQ+zsYBeZeBY4Y7LHTsHpUhNKdcOV1ITkh9rGc?=
 =?us-ascii?Q?d/yJppbH7zeFQLUTl8K2+x2DrDuW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(376005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 15:12:30.0571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 580ef1f7-0150-4b24-83aa-08dc83df963b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001509.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6459

Another DEBUG_TEST_DRIVER_REMOVE induced splat found, this time
in __sev_snp_shutdown_locked().

[   38.625613] ccp 0000:55:00.5: enabling device (0000 -> 0002)
[   38.633022] ccp 0000:55:00.5: sev enabled
[   38.637498] ccp 0000:55:00.5: psp enabled
[   38.642011] BUG: kernel NULL pointer dereference, address: 00000000000000f0
[   38.645963] #PF: supervisor read access in kernel mode
[   38.645963] #PF: error_code(0x0000) - not-present page
[   38.645963] PGD 0 P4D 0
[   38.645963] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
[   38.645963] CPU: 262 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc1+ #29
[   38.645963] RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
[   38.645963] Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
[   38.645963] RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
[   38.645963] RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
[   38.645963] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
[   38.645963] RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
[   38.645963] R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
[   38.645963] R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
[   38.645963] FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
[   38.645963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.645963] CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
[   38.645963] PKRU: 55555554
[   38.645963] Call Trace:
[   38.645963]  <TASK>
[   38.645963]  ? __die_body+0x6f/0xb0
[   38.645963]  ? __die+0xcc/0xf0
[   38.645963]  ? page_fault_oops+0x330/0x3a0
[   38.645963]  ? save_trace+0x2a5/0x360
[   38.645963]  ? do_user_addr_fault+0x583/0x630
[   38.645963]  ? exc_page_fault+0x81/0x120
[   38.645963]  ? asm_exc_page_fault+0x2b/0x30
[   38.645963]  ? __sev_snp_shutdown_locked+0x2e/0x150
[   38.645963]  __sev_firmware_shutdown+0x349/0x5b0
[   38.645963]  ? pm_runtime_barrier+0x66/0xe0
[   38.645963]  sev_dev_destroy+0x34/0xb0
[   38.645963]  psp_dev_destroy+0x27/0x60
[   38.645963]  sp_destroy+0x39/0x90
[   38.645963]  sp_pci_remove+0x22/0x60
[   38.645963]  pci_device_remove+0x4e/0x110
[   38.645963]  really_probe+0x271/0x4e0
[   38.645963]  __driver_probe_device+0x8f/0x160
[   38.645963]  driver_probe_device+0x24/0x120
[   38.645963]  __driver_attach+0xc7/0x280
[   38.645963]  ? driver_attach+0x30/0x30
[   38.645963]  bus_for_each_dev+0x10d/0x130
[   38.645963]  driver_attach+0x22/0x30
[   38.645963]  bus_add_driver+0x171/0x2b0
[   38.645963]  ? unaccepted_memory_init_kdump+0x20/0x20
[   38.645963]  driver_register+0x67/0x100
[   38.645963]  __pci_register_driver+0x83/0x90
[   38.645963]  sp_pci_init+0x22/0x30
[   38.645963]  sp_mod_init+0x13/0x30
[   38.645963]  do_one_initcall+0xb8/0x290
[   38.645963]  ? sched_clock_noinstr+0xd/0x10
[   38.645963]  ? local_clock_noinstr+0x3e/0x100
[   38.645963]  ? stack_depot_save_flags+0x21e/0x6a0
[   38.645963]  ? local_clock+0x1c/0x60
[   38.645963]  ? stack_depot_save_flags+0x21e/0x6a0
[   38.645963]  ? sched_clock_noinstr+0xd/0x10
[   38.645963]  ? local_clock_noinstr+0x3e/0x100
[   38.645963]  ? __lock_acquire+0xd90/0xe30
[   38.645963]  ? sched_clock_noinstr+0xd/0x10
[   38.645963]  ? local_clock_noinstr+0x3e/0x100
[   38.645963]  ? __create_object+0x66/0x100
[   38.645963]  ? local_clock+0x1c/0x60
[   38.645963]  ? __create_object+0x66/0x100
[   38.645963]  ? parameq+0x1b/0x90
[   38.645963]  ? parse_one+0x6d/0x1d0
[   38.645963]  ? parse_args+0xd7/0x1f0
[   38.645963]  ? do_initcall_level+0x180/0x180
[   38.645963]  do_initcall_level+0xb0/0x180
[   38.645963]  do_initcalls+0x60/0xa0
[   38.645963]  ? kernel_init+0x1f/0x1d0
[   38.645963]  do_basic_setup+0x41/0x50
[   38.645963]  kernel_init_freeable+0x1ac/0x230
[   38.645963]  ? rest_init+0x1f0/0x1f0
[   38.645963]  kernel_init+0x1f/0x1d0
[   38.645963]  ? rest_init+0x1f0/0x1f0
[   38.645963]  ret_from_fork+0x3d/0x50
[   38.645963]  ? rest_init+0x1f0/0x1f0
[   38.645963]  ret_from_fork_asm+0x11/0x20
[   38.645963]  </TASK>
[   38.645963] Modules linked in:
[   38.645963] CR2: 00000000000000f0
[   38.645963] ---[ end trace 0000000000000000 ]---
[   38.645963] RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
[   38.645963] Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
[   38.645963] RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
[   38.645963] RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
[   38.645963] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
[   38.645963] RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
[   38.645963] R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
[   38.645963] R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
[   38.645963] FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
[   38.645963] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.645963] CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
[   38.645963] PKRU: 55555554
[   38.645963] Kernel panic - not syncing: Fatal exception
[   38.645963] Kernel Offset: 0x1fc00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Fixes: ccb88e9549e7 ("crypto: ccp - Fix null pointer dereference in __sev_platform_shutdown_locked")
Cc: stable@vger.kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2102377f727b..1912bee22dd4 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1642,10 +1642,16 @@ static int sev_update_firmware(struct device *dev)
 
 static int __sev_snp_shutdown_locked(int *error, bool panic)
 {
-	struct sev_device *sev = psp_master->sev_data;
+	struct psp_device *psp = psp_master;
+	struct sev_device *sev;
 	struct sev_data_snp_shutdown_ex data;
 	int ret;
 
+	if (!psp || !psp->sev_data)
+		return 0;
+
+	sev = psp->sev_data;
+
 	if (!sev->snp_initialized)
 		return 0;
 
-- 
2.34.1

