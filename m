Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAB283CDC;
	Tue,  4 Jun 2024 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717523282; cv=fail; b=NI9k3ixASXzSZSkgk1GY22r/Z5NvCfEuL7jP3zCJxuATfNMLSsiWBhlG063gAiRl+947fLs+IHcJyLI2t4ZGyNBLFd+toC3WUsPa+4r8WTgP2ywyWOhMvJvpYy+y0+qeK2FfaDAWFkgCaOKajrMVf6sc7ffzpqKTYc15rrFvRi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717523282; c=relaxed/simple;
	bh=FFa1Ul0ZxurxZb/cQoZLPpF0m74U9/1Etq18fAEUqZY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p5kUlBNcup7w38a279CUQorZ28ixe0/6b2xxo3fdWzoU0tGs6qdS0bYA2fsgTv3pLXV1tlfZmcMvcQVjb2CM9OdQKsmI9Vqh2I4Q19H4UsGVvdo0JtfadLpiGC4GdauoMU9NyZiNJAFJWzlAw1Q1TsgJEK7TxkOeXXx21D/wZVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=duYggbWZ; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="duYggbWZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALsUkEB3TyvxSUnCQGxTPLpXhr247x/tFG+xSqGYsu3GYKCSWveIY3cjwFZhn/agSCwfcP+TwCSUD971Oh58y92cUXQ1qWQOvXjmUI762wx9R0eTlIS9CzmWMo73hjvvEy6S13fe9KaCF4sbJ1R0VYtaDtP0Q/P/Rwd3a2arQnrz+yuNm1zRskFpWw4qRxZc1UGqmRTXH3nOt0tN/tGlKvK0lH7fviOwdIU/VEF4SH9ptFYFME+M4yiz+1S2eJZBPN+WExGdy0ocXo2VlC1CeJS58zs4jrVivKr52lyTp79VMV9JjROhYbFjJJPc8hXZrrFVnmxM7Hb/eS0O7fK8xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4NHqwnL6PFqzLLrFdGag7/iUkiB9VNlQAbjM2DUIVw=;
 b=jNvv+hC7RKPKzU2q37SpD+WMQdXuNJEm6pfersZa7apdcrSJ2RjKiJjj/hybYE0bxNu3mH6/guOAXyNo6cAQ2kqrRiTNJQ9XEh6zlyOilA5QI4i+96jupi/roBfzYPFtcX/VKo+W7+nHNRr0M2FEelvNe3PZ9Skoqn5OCTYGHpnJFS7FDy1nRRF+kp+UHlq3bpFAQJTiHA71UlBCIWchIMqSJ5O6N8xndBiJWtmtfmLDQfMbJCldac9gd03uioVgSUjTVflhnm/42Ta+UCxJMy/fjpND4rf08wPZTrtShMvRe5CkDgEc6b1Kd1rPByIk+zbH2l+QmBx6htDCBl9HoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4NHqwnL6PFqzLLrFdGag7/iUkiB9VNlQAbjM2DUIVw=;
 b=duYggbWZCVTpNkdkk7QSdyLS5zCbS2YsZ29mew5i13MgF8lxEHCw0OADnUR1CwGL2dE9/nGC3npwmcA8fQww6UvUrCFNvpOTgVwGpso7C/0BHcLPj1zaoYVq0Hgq0TxDpuz1UNQD7kNdJv/t7yGWy0HUZFrS9WKItup+rdjegEQ=
Received: from BYAPR04CA0005.namprd04.prod.outlook.com (2603:10b6:a03:40::18)
 by DS0PR12MB8042.namprd12.prod.outlook.com (2603:10b6:8:141::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Tue, 4 Jun
 2024 17:47:57 +0000
Received: from SJ5PEPF000001D6.namprd05.prod.outlook.com
 (2603:10b6:a03:40:cafe::29) by BYAPR04CA0005.outlook.office365.com
 (2603:10b6:a03:40::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30 via Frontend
 Transport; Tue, 4 Jun 2024 17:47:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D6.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 17:47:55 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 4 Jun
 2024 12:47:53 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>
CC: Mario Limonciello <mario.limonciello@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<stable@vger.kernel.org>, Kim Phillips <kim.phillips@amd.com>, Liam Merwick
	<liam.merwick@oracle.com>
Subject: [PATCH v2] crypto: ccp - Fix null pointer dereference in __sev_snp_shutdown_locked
Date: Tue, 4 Jun 2024 12:47:39 -0500
Message-ID: <20240604174739.175288-1-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D6:EE_|DS0PR12MB8042:EE_
X-MS-Office365-Filtering-Correlation-Id: f9e10817-6ca7-43a5-709f-08dc84be7717
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|1800799015|82310400017|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aSzimSdJheOv54pqg8Tmrt3DXrc0OH3OZtmbwTHK3FmMCTLxIfNmWm3EFSl+?=
 =?us-ascii?Q?gWSqxFxzPXh4aacOic3vawpWronu8eHY8pDQhX4/uhmzZ6dGyu/l/Fbpd9SJ?=
 =?us-ascii?Q?cJA1AHMtnspEYQ1zVkM1l2nfCbO+hHavVRf9XWAHcQVTmGzWZOdugQ3o3QkJ?=
 =?us-ascii?Q?qmZH5MxIi4z8cQ9zKQD6uAYbCBwb1/pe5KbotnnEsEz5gqi5Mfkp+KbrBiFU?=
 =?us-ascii?Q?FHM2HvSou5CQORgUNLBwkjY/YbUvaf60xK2nxyR/ETxhiJ8VD78PxIorajI1?=
 =?us-ascii?Q?8FDHZGgt1KvsvtfsAxhvUcWGag/4ZDsevSZHB+lwteo6dxIlMRbOEPYA5x7e?=
 =?us-ascii?Q?WRfgJfubMxYjQKRWxSfNuNk5RtWqHGCeka1xMN9sYzItoJUAYQtuHM1fgMbz?=
 =?us-ascii?Q?jLzc9dmA8tmkiPVAN0CtPI5S96ZkWIVGggt0IvQetgM1iASBlcF/PpwUvaVX?=
 =?us-ascii?Q?SN+bSW+b+KEpPITN4Msu0RI9yfKwV3vCaNaG+RMFRRaPPdGpDZj55Yz+cnL4?=
 =?us-ascii?Q?oFhH+a0MgTnRTkbTGUt/AZpvZAJOE3IVFGFp4yoj7tgvYUPs7DuOOoQC924W?=
 =?us-ascii?Q?8Jjy7qZWI/Yn4eBSkOkr365EejIWj+UCgxyCR5Hode4vSX9Q3L1FTNjKGXh/?=
 =?us-ascii?Q?uPq/5X4LZUb8j3WS1R8zhH3nev0XCX0rjuxezcR7TiuvksYS5AVtvAifECvJ?=
 =?us-ascii?Q?ufcCgAaoePqW3BaLkiaucaUp8x1Gvj1lCoyB6WNAi1k9O9ioF31S+GZoGLxu?=
 =?us-ascii?Q?wfo7NkCdZM/UW+A4ivjR8PrJygh800lSMX9GR3EkauRnsWsnITDpUnDnhnKa?=
 =?us-ascii?Q?lu/oFNOW6G7lqCLfDyBH2P2dnOpdD90+Kin6/wk/o4HMXqlP8/FK01GuWczz?=
 =?us-ascii?Q?/bdFMXU/sdo5PcNfdrycmB6LnQSsvYz5t69oRTuMSpCN2ZqnQdAIHuYKcEIq?=
 =?us-ascii?Q?kFpjCyl5iIFxbuyAEVMMwcbsMCTZUA0m93wxvbY0cm8BpvdP7u/WNAY8DCbn?=
 =?us-ascii?Q?HI5BPk562YbE4/apjiTUjKte4c4XTMyZOJQejR6OGaZZ5czB2GMIzBcqmncx?=
 =?us-ascii?Q?UArRR3NKFU9DNoPizZp2QhdYQuvQW3CR95Y3yslkAn1fWdFtU6o6DtQ8rx3n?=
 =?us-ascii?Q?BrlYtIyPFvJhkL26N0/qn+iuFUHI6/H3BVohWI4LWHzlVmfAZnSJKV1QIen9?=
 =?us-ascii?Q?bpoHu3B3KJD86X+WRdRASqgTuE+VSnPNW4FTZ9HkbyG9CC6jz/jRB5h3C7Pp?=
 =?us-ascii?Q?hSKp+QPFg9pOFpRAtqfp4aFLTcVWaUlUzN2rwbqA+01we0i1nm6i58FkQ5qW?=
 =?us-ascii?Q?s7j/303ibc2Ty/naGecBuzmyD5Iek7VSOX+2rf3kSqi+8hrgOTnT0KzkcTGD?=
 =?us-ascii?Q?cY42oq9SwpchCf1OkHW5cYV9cjsrQAhsvDAj1QRZppoeKE9pjw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(82310400017)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 17:47:55.4414
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e10817-6ca7-43a5-709f-08dc84be7717
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8042

Fix a null pointer dereference induced by DEBUG_TEST_DRIVER_REMOVE.
Return from __sev_snp_shutdown_locked() if the psp_device or the
sev_device structs are not initialized. Without the fix, the driver will
produce the following splat:

   ccp 0000:55:00.5: enabling device (0000 -> 0002)
   ccp 0000:55:00.5: sev enabled
   ccp 0000:55:00.5: psp enabled
   BUG: kernel NULL pointer dereference, address: 00000000000000f0
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page
   PGD 0 P4D 0
   Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC NOPTI
   CPU: 262 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc1+ #29
   RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
   Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
   RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
   RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
   RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
   RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
   R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
   R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
   FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
   PKRU: 55555554
   Call Trace:
    <TASK>
    ? __die_body+0x6f/0xb0
    ? __die+0xcc/0xf0
    ? page_fault_oops+0x330/0x3a0
    ? save_trace+0x2a5/0x360
    ? do_user_addr_fault+0x583/0x630
    ? exc_page_fault+0x81/0x120
    ? asm_exc_page_fault+0x2b/0x30
    ? __sev_snp_shutdown_locked+0x2e/0x150
    __sev_firmware_shutdown+0x349/0x5b0
    ? pm_runtime_barrier+0x66/0xe0
    sev_dev_destroy+0x34/0xb0
    psp_dev_destroy+0x27/0x60
    sp_destroy+0x39/0x90
    sp_pci_remove+0x22/0x60
    pci_device_remove+0x4e/0x110
    really_probe+0x271/0x4e0
    __driver_probe_device+0x8f/0x160
    driver_probe_device+0x24/0x120
    __driver_attach+0xc7/0x280
    ? driver_attach+0x30/0x30
    bus_for_each_dev+0x10d/0x130
    driver_attach+0x22/0x30
    bus_add_driver+0x171/0x2b0
    ? unaccepted_memory_init_kdump+0x20/0x20
    driver_register+0x67/0x100
    __pci_register_driver+0x83/0x90
    sp_pci_init+0x22/0x30
    sp_mod_init+0x13/0x30
    do_one_initcall+0xb8/0x290
    ? sched_clock_noinstr+0xd/0x10
    ? local_clock_noinstr+0x3e/0x100
    ? stack_depot_save_flags+0x21e/0x6a0
    ? local_clock+0x1c/0x60
    ? stack_depot_save_flags+0x21e/0x6a0
    ? sched_clock_noinstr+0xd/0x10
    ? local_clock_noinstr+0x3e/0x100
    ? __lock_acquire+0xd90/0xe30
    ? sched_clock_noinstr+0xd/0x10
    ? local_clock_noinstr+0x3e/0x100
    ? __create_object+0x66/0x100
    ? local_clock+0x1c/0x60
    ? __create_object+0x66/0x100
    ? parameq+0x1b/0x90
    ? parse_one+0x6d/0x1d0
    ? parse_args+0xd7/0x1f0
    ? do_initcall_level+0x180/0x180
    do_initcall_level+0xb0/0x180
    do_initcalls+0x60/0xa0
    ? kernel_init+0x1f/0x1d0
    do_basic_setup+0x41/0x50
    kernel_init_freeable+0x1ac/0x230
    ? rest_init+0x1f0/0x1f0
    kernel_init+0x1f/0x1d0
    ? rest_init+0x1f0/0x1f0
    ret_from_fork+0x3d/0x50
    ? rest_init+0x1f0/0x1f0
    ret_from_fork_asm+0x11/0x20
    </TASK>
   Modules linked in:
   CR2: 00000000000000f0
   ---[ end trace 0000000000000000 ]---
   RIP: 0010:__sev_snp_shutdown_locked+0x2e/0x150
   Code: 00 55 48 89 e5 41 57 41 56 41 54 53 48 83 ec 10 41 89 f7 49 89 fe 65 48 8b 04 25 28 00 00 00 48 89 45 d8 48 8b 05 6a 5a 7f 06 <4c> 8b a0 f0 00 00 00 41 0f b6 9c 24 a2 00 00 00 48 83 fb 02 0f 83
   RSP: 0018:ffffb2ea4014b7b8 EFLAGS: 00010286
   RAX: 0000000000000000 RBX: ffff9e4acd2e0a28 RCX: 0000000000000000
   RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffb2ea4014b808
   RBP: ffffb2ea4014b7e8 R08: 0000000000000106 R09: 000000000003d9c0
   R10: 0000000000000001 R11: ffffffffa39ff070 R12: ffff9e49d40590c8
   R13: 0000000000000000 R14: ffffb2ea4014b808 R15: 0000000000000000
   FS:  0000000000000000(0000) GS:ffff9e58b1e00000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: 00000000000000f0 CR3: 0000000418a3e001 CR4: 0000000000770ef0
   PKRU: 55555554
   Kernel panic - not syncing: Fatal exception
   Kernel Offset: 0x1fc00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

Fixes: 1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
Cc: stable@vger.kernel.org
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: John Allen <john.allen@amd.com>
---
v2:
 - Correct the Fixes tag (Tom L.)
 - Remove log timestamps, elaborate commit text (John Allen)
 - Add Reviews-by.

v1:
 - https://lore.kernel.org/linux-crypto/20240603151212.18342-1-kim.phillips@amd.com/

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

