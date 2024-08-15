Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A2E2770B;
	Thu, 15 Aug 2024 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723724716; cv=fail; b=ncxNXB6o2dhKIsKKkdwlc+8AwmAoqfBQbgZqSqK3lNtSdgj/ncaX1HEho4dawR6DPFMHitVqvB62o9YMkpYT8p8SYVRGuLqJP+PBCLU6EIfz6sbH2NDP3tYK4QE6omi9ZqY5zWo9dJcVXvhswdSR3qi2z2u3Q5tbJa4wtNdEGn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723724716; c=relaxed/simple;
	bh=PsePS7dpY+2WEGBE0YYNH8SPNwij5yx8y1qkJ6au874=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hQ+EGSFj/e+FQvS5LQgiqV1yQfvv4q4YDN+kmbLCYYLh2zbgoXfUJPp35VU/TGWpsnLS3J1f8wwtmmTyGxpxqNxLOg8XwG9fWO0tAoXLsiJHIt1UEz8hY4lhwCAObQ+1H2xaRIeJu9xh1kU4+KmomaP8t71FSpQhhALWE1EUbbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ekowyMzk; arc=fail smtp.client-ip=40.107.236.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ekowyMzk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SqKACufOo14tWxxHYD47mgwXbeZTD01ntSxflgOhW4pH2dxCZvCs5z7pXXrtSziroum53xGRAiiQTRdcIauZkZFjt07ZrVVsnisMj9FpmXtgJsk7YCjQH2m9ATxoDCm0I/p2bR1Y2CC6drworvnAavKWR2f89SSpsNOsweMYzA6yxf+0Lp1PxAVKVolfVXbAPLMMoYLCKWZkdTOylIZ9unnXCaoE8IMUlJOipI4BrP/mRSQqpsqpaO+AxoGW5tJ/pqIoSp/20twdu3tY9LH3D8T2maSoXtUaGgR31FTWs5T2FN9kpjEKP/EPtLmvyBf2oubEKlqUSpZ35IM5TSl+/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZktDFB3FIrzfEljB4wpfp6PE8alaIPeW71EYv/KPEQo=;
 b=SRFLIz1wbnEh9hviWPT2Ipuor+F0Rx/c0oMwB+N5fPuhGxQIisbQaUJ+ztzk/7Vyy/0y/H7465jHr/6MsHl9PLJXz5iFEbQ4Mctji7dXOLpEq3Zqw7tM7fONtbNAp+VQuhy6dV155HStHsJoByR+aElCYqshmqbVfpUYsGYmFWyUbXGUHkjCb+esx/MTG6yfvBcQ/DnPrwSioBTQFigOIfGGmkylTgCde/q+2xfeJEpbBT5yDdfdDX14zoWiaOeJIpsKwHY/m6FUnKKljfGUe4k4CS+uIklgJogsWcVVLr3ds2j/H54SmiPzG/gymfUlD6jlD27tlxgXtv3aBuMamA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZktDFB3FIrzfEljB4wpfp6PE8alaIPeW71EYv/KPEQo=;
 b=ekowyMzkcWkKL++8CMOr813nvIMTRDAZbKFEnPINglN7uJU/ZncM0mPP0bDzEpUxfqRuyflOrZBdsnNaZeHFgVgDDHDY+Nxc0lSff7FlKQhNDAW4P2+Pm0hh36LbrutxUkTZLObpI+frFS8qFDww+pqP/GOLDj69SoqFpjW9T4w=
Received: from MN2PR16CA0048.namprd16.prod.outlook.com (2603:10b6:208:234::17)
 by SA1PR12MB8965.namprd12.prod.outlook.com (2603:10b6:806:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Thu, 15 Aug
 2024 12:25:09 +0000
Received: from BL6PEPF00020E64.namprd04.prod.outlook.com
 (2603:10b6:208:234:cafe::9f) by MN2PR16CA0048.outlook.office365.com
 (2603:10b6:208:234::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23 via Frontend
 Transport; Thu, 15 Aug 2024 12:25:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF00020E64.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Thu, 15 Aug 2024 12:25:08 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 15 Aug
 2024 07:25:08 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>, "David S . Miller"
	<davem@davemloft.net>, Pavan Kumar Paluri <papaluri@amd.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] crypto: ccp: Properly unregister /dev/sev on sev PLATFORM_STATUS failure
Date: Thu, 15 Aug 2024 07:25:00 -0500
Message-ID: <20240815122500.71946-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E64:EE_|SA1PR12MB8965:EE_
X-MS-Office365-Filtering-Correlation-Id: 7785835f-1690-48a7-f487-08dcbd254d64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2/axsrFmw80QiMmOkDtjLagohfzQCZqN/ln09NnLd5OOAjttrlnaA9+3IvIT?=
 =?us-ascii?Q?uqhO1PvHthZfCmJWT8hS3XeKxdEyTjKfL8FE1r/ZvJrP6LtbyVGBdBj/a/On?=
 =?us-ascii?Q?/0IERx7Q5UinB3zPmMIhIDkhh+ETL1YVEbrvRPGIGPhdhEYBFW7qYArr3va8?=
 =?us-ascii?Q?3JEzbKUqPXzxY1mNd1rQzONiuoN5c1wnpfQqe7e9OEYQH+z4LMvHVkgGYpyp?=
 =?us-ascii?Q?1PNjmYw/5D7g0CvpmNrdbTO0uskPatuB7l9APkAwNbdr5F4Ua6LIlt8cYXSI?=
 =?us-ascii?Q?EEmqh1pyh5Gj8u4EYqKLDvyhBG2Ad+tEdhFgFalLDin7t0OGRqq4jn4FEn58?=
 =?us-ascii?Q?ypMbQAJsgi9iP5jY/KKT8BZxyVMsQw+R2/KutoZKqx9/VBStz3UxacR9tu6a?=
 =?us-ascii?Q?kfbQaKob1DNau/k6HybiU6F2dQ42uVzaPH38gpLwJ5cvbp3afUOxQDmRwifq?=
 =?us-ascii?Q?Gbut6Txlaq8nKxmI13qwC946YjRvoTXr/ERMO7jg+A8HOaWUDcLFTH2FAEkH?=
 =?us-ascii?Q?JPpdDp6XLHeibitM6Q0NQzu5RJJ5EaXBURbI8Irccp5wwWNxG9ug0maqamSX?=
 =?us-ascii?Q?4CvTtmwnZ+MWqgr+5k7fes9Ck/278RHQoH7TY22ts5s1Vs9XlQn7u1zFli2u?=
 =?us-ascii?Q?ZPQabV+YsbuCeTPa6XG2TgOZOSK6SC04bzWfpd0eGCc1X/dJpgFoo+Bwzh1C?=
 =?us-ascii?Q?5koeeHY6fTx2VxjcMKSESXvEgL1Vmj4rF4KkPv+YDH1XdA9uTdM3QnJbKlSE?=
 =?us-ascii?Q?X/5uSLA7AOq7BxjFdMdFyJMd7HyXJvwOo5YpVf1z9dUgxb860LouNAcsIdd1?=
 =?us-ascii?Q?HVHx4q5dLhZ7v9Cbou6zP2k11l2iijQNGN4kuhkgXJP6r7LeInAZRZhtLe0V?=
 =?us-ascii?Q?uIsTmEXVP4soMupWWZltjWIvegzwyI7hPef9gVrl9o1xdNx4H43q+90RI6pf?=
 =?us-ascii?Q?9POawV8nqOa+sb7JxJLr/wWNNWcgPlf2A7wn65BMHL025aO4lSrsGEnEGodt?=
 =?us-ascii?Q?0wWB6ConNZvLwvkuFzJosSMEfdh+2Jsd7AF1a/7jHwJX+jrhQjmZGSGaVjTP?=
 =?us-ascii?Q?5dagURnlL850Zkb9FxCO9aBl2qetzzhc+qQR+Gn5ZzXfzcNYaOdK93Ax1/WY?=
 =?us-ascii?Q?fdZ/YuEAmO6X1R//t+5ax8ELHHPFiEFyAhvhDFCyfdiKGDDYd4MzwYYBgeIE?=
 =?us-ascii?Q?qiEhUdhSQRFaxdPcY2a+vOV2JZygqyToWwn5fd8LnLGFX+Aeczlb0AA4pT5L?=
 =?us-ascii?Q?W3OXHPkw1VYs56Vp+3AMTS05SnWyublfDmZa86VnGFPLArx0+E7XjkSWlcYe?=
 =?us-ascii?Q?I5oyjtTBo16uc+uz8nQ6uX/QUGM/rN2+tcdpU5drPVtalDI2RWyXRLNFqwCu?=
 =?us-ascii?Q?cQAt+DJsWXU3CbFmK3eztEbzjZn3P7nEDZxGh08RW9Oj/W7kKF6HKe3ffQ9C?=
 =?us-ascii?Q?UyVuWtfoK76bugsktLPnNSFD6lmZ79Cq?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 12:25:08.8888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7785835f-1690-48a7-f487-08dcbd254d64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8965

In case of sev PLATFORM_STATUS failure, sev_get_api_version() fails
resulting in sev_data field of psp_master nulled out. This later becomes
a problem when unloading the ccp module because the device has not been
unregistered (via misc_deregister()) before clearing the sev_data field
of psp_master. As a result, on reloading the ccp module, a duplicate
device issue is encountered as can be seen from the dmesg log below.

on reloading ccp module via modprobe ccp

Call Trace:
  <TASK>
  dump_stack_lvl+0xd7/0xf0
  dump_stack+0x10/0x20
  sysfs_warn_dup+0x5c/0x70
  sysfs_create_dir_ns+0xbc/0xd
  kobject_add_internal+0xb1/0x2f0
  kobject_add+0x7a/0xe0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? get_device_parent+0xd4/0x1e0
  ? __pfx_klist_children_get+0x10/0x10
  device_add+0x121/0x870
  ? srso_alias_return_thunk+0x5/0xfbef5
  device_create_groups_vargs+0xdc/0x100
  device_create_with_groups+0x3f/0x60
  misc_register+0x13b/0x1c0
  sev_dev_init+0x1d4/0x290 [ccp]
  psp_dev_init+0x136/0x300 [ccp]
  sp_init+0x6f/0x80 [ccp]
  sp_pci_probe+0x2a6/0x310 [ccp]
  ? srso_alias_return_thunk+0x5/0xfbef5
  local_pci_probe+0x4b/0xb0
  work_for_cpu_fn+0x1a/0x30
  process_one_work+0x203/0x600
  worker_thread+0x19e/0x350
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xeb/0x120
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x3c/0x60
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>
  kobject: kobject_add_internal failed for sev with -EEXIST, don't try to register things with the same name in the same directory.
  ccp 0000:22:00.1: sev initialization failed
  ccp 0000:22:00.1: psp initialization failed
  ccp 0000:a2:00.1: no command queues available
  ccp 0000:a2:00.1: psp enabled

Address this issue by unregistering the /dev/sev before clearing out
sev_data in case of PLATFORM_STATUS failure.

Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
Cc: stable@vger.kernel.org
Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9810edbb272d..5f63d2018649 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2410,6 +2410,8 @@ void sev_pci_init(void)
 	return;
 
 err:
+	sev_dev_destroy(psp_master);
+
 	psp_master->sev_data = NULL;
 }
 

base-commit: b8c7cbc324dc17b9e42379b42603613580bec2d8
-- 
2.34.1

