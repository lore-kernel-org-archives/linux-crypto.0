Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012009.outbound.protection.outlook.com [52.101.43.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787B6519916;
	Fri, 18 Sep 2026 16:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789749685; cv=fail; b=C3zvakJqwFj6oh4CJoVW5tcX8e6HH3+X5v5zmarry6Ki0sXjeQKtRSnV+SeZji28qsCa9YML9gR15FnSnC7LiA32lsj6fmTsMOb3PpifFxr2H0tzHI7sWJhbb79Yy0LA8xiX4rSeSA+UlqxCs5LBX8YsB16XQbWiJyjXnFVNJ+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789749685; c=relaxed/simple;
	bh=O31n/qiaNoQHcC1XCVqFrc49CLyS3netnEQMhdGTFME=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Up67iK5yUP9Yu9RfsZabCoQ67RhZJP4yDDKisE3nn2gC/7KqvAaWSxIuqFepACoszO4j+ZRiAutpZ2mF7beT6LPn56AJhnvYgr10TAZqOvAoc9uvHBK6EaRnA47gHCVq5WLQi03P+/ByHhD1iUqBXNOwk56egsEHT3voeQRD2W8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=csWSq3RA; arc=fail smtp.client-ip=52.101.43.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="csWSq3RA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nLHLmkOlvPgy3Xck9kKBmHrfAy7CxuRRaqmGX6pJRQOsNm6hdj+AcGoxCFoJD9WdvZSk0cogy392xuxKzHh3j0VFUaFFdQjTypOazTDsvchEX8VgnwfG1eP2tsimVodPRpXlELQxc7Iwj28rNqGptzreL90+bLXKLxJu7U6EpM1o8oUXFyi9g9m6rI4OYKgXvnVQocdhyRhRVxl1ZkzTqzeGroBWf1IVhqFk8C2OChc1Cm98uqIUwJGx0AMPVHNl+sUCxd2PeAMX4rJ5iSLS8mo4zduwsZFJtZI791Wd+suNTWNQD4ZwE/2fOc2qfrt+oHk11KTYXWB7YyjfkilSLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HzfZqKUnHZv3gm1RTnUryF2Jlbsc354l+r3W+JxIgU=;
 b=QQukXqFbHRKeYyqzFonR6k+PSRYEau0b6sJ7FRVckdU2NmFzrkKTFjYToRgj/IBGKlMyNiyyN02tfc+pfzaopm8n0NOeJA7lZwjp5SRhIOPU6CH+/Y2SmVMLD7OproycWhyy48K77WvDfBAGX725fzvL4OYEc82WZ+90nBvlgUZnO0uQFljdqVBE9AmPltAMMMQ0QrtevzC+MqyH05kLGUe8kkqk1b0kGno4U1FbwV9fyrrkncxS2jraWjBeUa9NHCzllRp0pjnkTkqiUf1vwsExDgjRk/ZQKezvCHm1vSLARPQWSGA/mUDX5ckamLU3p/Ym83XavJ2+2VA49vlNnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HzfZqKUnHZv3gm1RTnUryF2Jlbsc354l+r3W+JxIgU=;
 b=csWSq3RAXCMBz/TGQF7tdoPch2Pv7xqeg2lwUGvhaensgRvNpxC4haEFyQ5uirqxwSSepbtECnemla2msRcr69Cv7Xr/T0hQMMxvKuA9Kp4jneoPov/IZCurpu4+1oBoiiKrFBYQOCqp2T3LAVXpTbVSB0i0jlcM5bEYVDFG3hI=
Received: from CH2PR02CA0018.namprd02.prod.outlook.com (2603:10b6:610:4e::28)
 by DS0PR12MB9726.namprd12.prod.outlook.com (2603:10b6:8:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 16:41:13 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:610:4e:cafe::9e) by CH2PR02CA0018.outlook.office365.com
 (2603:10b6:610:4e::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Fri,
 18 Sep 2026 16:41:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 16:41:12 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 18 Sep
 2026 11:41:11 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v2 0/7] Implement SNP live firmware update support
Date: Fri, 18 Sep 2026 16:40:54 +0000
Message-ID: <cover.1789749016.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DS0PR12MB9726:EE_
X-MS-Office365-Filtering-Correlation-Id: efc10007-e561-4723-9036-08df15a3a68a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|82310400026|36860700016|23010399003|13003099007|18002099003|5023799004|11063799006|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	m29U0ArJCCwHVg0lHdHHM8Ssbut9W3cFhPUOZKigB/zzzj8snsOn1wYUn6+A9jUACG4g/bMMcYkDiZguI0SD+//6izY9eQEKpxAk+yNBpGMxOwoPWtbhR4wxtk+WTNYqm/7x2HVl0/fbIiXtZ0KwUCsiDXBzyExh0LiSruxMCYT918PwpFa5IlO57tbk4p7xwXzbdGSkWq8m/NgZ3eu9IZc7jsrhdsMgmInpIS3Fp9ujHvGHcwk7gpBOeZnYpx7DP8ucevJytjR8OgzEtj0pXOoF8zrABBbSMaO/JtjPkYiJVWALNYgqr3gbqzJi1fhj30iHbKzOzcdoL3wyIgzvnGQ4YYFDv47fn6kReLFt/RzGWF2hAbyu2VL9MC9/VXSOEo9RwD7B42oKzDKm8TlDTEy6GCE+iZsyEpIujkyk0lRSqvPTja5AIBY6nbrsGuo5GfITNIKZNtS2/uPyipxyhuCv473Ygs6nZrccwAvr61GU4Hso9cC0Mp//mY8tkjImvfn5zZkH5hwXnfQga2nA2l+bI7EZxgKAerb2JJnvrtCACKdOdE/XiTo6EawOAjBG49EeE0VjenyjCYTE6VVTCrwgBud7isLyTg4f+qDEsSnt2s8Cyaf6Ds3nFXHaigVCcF1dM7o0cOGf6yWkrE5PNDI9J+Ix3dm8XPdKdmpyvZAk8Q20GZGxFlHkWQ+RUYal1WqEkAaB9uTYKqvQOy9+/Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(82310400026)(36860700016)(23010399003)(13003099007)(18002099003)(5023799004)(11063799006)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	W8JxcV6GNSXI5rnl6+Vq9EnFS9YXj16bh7b16nyJ3DHPOXdz6Dai4VrvzQnniqg2qGfYMQ9p/P6Bljnth/LuiMivYaAiBLe3Z6yHDQevBAujfpCJgh8qiJEFSx1FgQyqbGN1aX3i3C80WVaF2HRFE8fLqFiVAtKIT+VK7vgBzKzYxnYiivKUYi0p4oUSicN0kuyyy/m4bM8Y+SJS6LC2adx+rrAZIHnbT+jtzFDsgGqDeI7Pnu6pgxpg+rA0m8aV5iC376qQxjZ6yo+RQnVnnflWPk0Ia3dktfi0Me8GKp0310Mtcmd9qQ2V6is4kwk1fEqXnKZV0yBrCnF+ZoOCH9LssSYNmkMLgykazSkOS2a+Uvyi36mTq1A1Dg24nj0twp91lue09Bx7eyprqqujMJOFW3zJAm7/OFYiqL4p1OaGEQ3xXCXkz5UQQys6NY5W
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 16:41:12.7166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efc10007-e561-4723-9036-08df15a3a68a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9726

Introducing support for live update on AMD SEV-SNP platforms via
DOWNLOAD_FIRMWARE_EX.

This patchset is an extension of the RFC patchset from Tycho
Andersen.

This series also fronts firmware_loader patches from Dan Williams[1]
which majorly cleans up refcount issues so that registering the upload
interface no longer pins the module. Without which having live firmware
update will cause failure to reload the ccp module as well as break
kexec.

Patches based on cryptodev-2.6

v2:
* In snp_get_platform_data() use snp_[alloc|free]_firmware_page() to
  transition pages to and from firmware-owned state, instead of
  open-coding rmp_mark_pages_firmware()/snp_reclaim_pages() around the
  SNP_FEATURE_INFO command - Tom, Sashiko
* Claim sev->fwl atomically with xchg() in unregister_sev_fw_uploader()
  so a concurrent module removal and sysfs unbind cannot both reach
  firmware_upload_unregister() - Sashiko

Responding to other Sashiko comments:
* __sev_release_firmware_buffers() called with panic=true can cause
  deadlock as another stopped CPU might currently hold zone->lock or
  other page allocator locks.
        - I think having a panic param within __snp_free_firmware_pages
          which checks and returns before __free_pages() should resolve
          this issue. Since this is a pre-existing issue not relevant
          to this patchset, plan to send this as a seperate patch
* The sev_download_firmware_ex() function is called with the lock held
  and performs a GFP_KERNEL allocation.  Since GFP_KERNEL can trigger
  direct memory reclaim, could this invoke SEV page reclaim operations
  that attempt to acquire the already-held sev_cmd_mutex, resulting in
  a deadlocked state?
        - GFP_KERNEL may perform direct MM reclaim, but SNP page
          reclamation is not registered as an MM shrinker or normal
          page-reclaim callback. snp_reclaim_pages() acquires
          sev_cmd_mutex only when explicitly called with locked=false
* "If snp_reclaim_cmd_buf() fails and returns early, the code skips
  resetting sev->cmd_buf_active and sev->cmd_buf_backup_active.
  Will this permanently leak the bounce buffer slots and result in
  future -EBUSY failures?"
        - Since the command buffer may still be firmware owned, I think
          declaring psp_dead = true is the way to ensure we do not make
          it available for reuse after a failed reclaim. Pre-existing
          issue, plan to send this as a seperate patch

v1: https://lore.kernel.org/linux-crypto/cover.1789059391.git.prsampat@amd.com/
 * firmware-loader patches are rebased as-is and only incorporates
   fixes for minor build issues
 * Dropped crypto/ccp: Hoist kernel part of SNP_PLATFORM_STATUS as that
   patch has been merged since
 * Dropped crypto/ccp: Reclaim command buffer when the PSP dies and
   subsequent handling since firmware quirk is now resolved and need not be
   handled in the OS
 * Use guard(mutex) for the locked region, which the split makes
   possible since sev_get_api_version() acquires sev_cmd_mutex - Maxwell
 * Added a patch factoring out the TMR and INIT_EX teardown, so the update
   path and __sev_firmware_shutdown() share it - Shantanu
 * Skip the re-init when the PSP is dead, not just when a rollback is
   outstanding - Shantanu
 * Re-initialize the platform before refreshing the cached status -
   Shantanu
 * Split the monolithic .write into a locked update helper, an error
   translation helper, and a thin .write that refreshes the cached status
   once the lock is dropped and clean up various allocations
 * Convert rollback required and reinit required globals to reside in
   sev_dev struct to avoid carrying over states if manually reloaded

RFC: https://lore.kernel.org/all/20260430160716.1120553-1-tycho@kernel.org/

[1]: https://lore.kernel.org/lkml/20260331214726.903274-2-dan.j.williams@intel.com/

Dan Williams (3):
  firmware_loader: Stop pinning modules on registration
  firmware_loader: Stop pinning parent device per workqueue invocation
  treewide: firmware_loader: Drop the unused @module argument

Pratik R. Sampat (4):
  crypto: ccp - Factor out the release of the SEV firmware buffers
  crypto: ccp - Allow SNP platform data to be queried after SNP INIT
  crypto/ccp: Register with fw_uploader and always fail
  crypto/ccp: Implement SNP Download Firmware EX

 .../driver-api/firmware/fw_upload.rst         |   2 +-
 drivers/base/firmware_loader/sysfs_upload.c   |  50 +--
 drivers/base/firmware_loader/sysfs_upload.h   |   1 -
 drivers/crypto/ccp/sev-dev.c                  | 423 ++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h                  |   4 +
 drivers/cxl/core/memdev.c                     |   4 +-
 drivers/firmware/microchip/mpfs-auto-update.c |   2 +-
 drivers/fpga/intel-m10-bmc-sec-update.c       |   4 +-
 drivers/greybus/gb-beagleplay.c               |   2 +-
 drivers/media/i2c/thp7312.c                   |   2 +-
 drivers/net/pse-pd/pd692x0.c                  |   4 +-
 drivers/virt/coco/tdx-host/tdx-host.c         |   4 +-
 include/linux/firmware.h                      |  15 +-
 include/linux/psp-sev.h                       |  19 +
 lib/test_firmware.c                           |   3 +-
 15 files changed, 446 insertions(+), 93 deletions(-)

-- 
2.43.0

