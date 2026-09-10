Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010064.outbound.protection.outlook.com [52.101.85.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77124E13E7;
	Thu, 10 Sep 2026 17:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059747; cv=fail; b=gTNAUvuLPHO2w8Fr5ziuKIhPGRYPFlGukF/2yOkeaF2Ut93zbfYFs6EMlihQkT8bVYX9gEJ8FXlzoUa8ExHtVMFIE7XZiLaxFmLpFPtLZ91p5ryAVG9qhxmSs8zwXgDR13MoAl38LRFPcYcCO/9+Y3qU5AUdjSV2GU9Dc8aHyzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059747; c=relaxed/simple;
	bh=KYoqxubR0AwieSmQQAVsr2aNa6oqbTm0FLZaTlIuyfk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QCWxJpQ9MaDR/VbsUxrAVFCPOLy/8nh9htQmnaFKnqszsnOaaFreXvCOu1Nbt7cLjNp+TAUyeTq8zI8rTN5ST22ImGzhyyYZAQb4jrSuq5ZUz61d1x6aSqwHGzkXjPHtAmzOF91wuWVqVgFQSBeWcvJTQx2znE11s0tQ8yzyy3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3EUr+y5k; arc=fail smtp.client-ip=52.101.85.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3EUr+y5k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ka/e1RWIaByd5i8EMaAhVNRsm483eLkCH6DqZ1yHUfAJMEF94msEw0cdfj1oX1AyTjbQ9KjVsu2tYmwel9tETO9No0mHhX0ndQCPXveo9/gxHTu8ypVinSyR5rwG+FGKZsd2++1KSotSyNi6DLQbCzfXdNCWa9vjwOH/7YmI1MhchxqATG6Wf0b3aFrKlUGHLweFRCBVdmd1bF9ar3tBDUK/GYBTZekMLSegnEjilZhdhev9wh+meV+KDC8ZeY/p/NblKyngLxvYqJBlHrMElFF9ckWx6AeEHwwL11dxF9eo4f0aa5JBUpRk7i++67D/a1RrTr4lUiameLwuJVfk3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OdR/un3hDMCI6bOrJIAYfqjGzc3NMMr4OySb246lIJM=;
 b=UYleeUjw8plV2ZCFSD5BkBIBBEQznLscsmXfa5UJaKWrbPkV5LFVIKoJMOJFfx62cLaUxTT6LVRn7orXNLCPC52LI0wv9CQSMxKKzBxZwWiwxfX5iivlMpd7OtfPY1Lke0GgbWLu6jXNs9WrpBbBCgTN9l9cXTpYruaNn8CzXr11AArZyi/eboN94lGTmbxMzGc7Ls593Op6jTeEZluzLltQBSYJnLalUI4CPI/pjJLlDkOCEyjlx/BYXLex379835lUDGrjDkyo1fx0ji4GcdLgcYnNhXfJME4/sb08cubAnjvt6TT/KfaZo/ivsbkmvFayE7yS8YL/cLf9pSmZzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OdR/un3hDMCI6bOrJIAYfqjGzc3NMMr4OySb246lIJM=;
 b=3EUr+y5kwwKYIDcH0hYgTFOuwrNt9bUmhDyCxtScVaUuutFy94OkJ5qXlhIRP3Q9ypvBBjK8FxwjK2UvCSdlM++UBH+qj5zE/HvlSjdZg9XQKwUo0Yc0p+eNtUwUTtP/1SqEfL4I6KxVHYWcOTBa3bXNM2IZXW8CjXomj6GmTqk=
Received: from CH0PR04CA0039.namprd04.prod.outlook.com (2603:10b6:610:77::14)
 by DM4PR12MB6039.namprd12.prod.outlook.com (2603:10b6:8:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Thu, 10 Sep
 2026 17:02:09 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:77:cafe::a8) by CH0PR04CA0039.outlook.office365.com
 (2603:10b6:610:77::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:02:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:02:09 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 12:02:08 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [PATCH 0/7] Implement SNP live firmware update support
Date: Thu, 10 Sep 2026 17:01:55 +0000
Message-ID: <cover.1789059391.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|DM4PR12MB6039:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bb48823-bc69-4af6-66aa-08df0f5d4036
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|82310400026|7416014|376014|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	NnDopVVE6iqDhLKfDimV4+4U9KNbbRxH9HzlVpcqZRHyO8kxpzhkgHYm31BOTYcoJ4iwq9H0343QwSC5Wcyt3Hn/fj6fxgXKKXW0FeqAyuQWxMXvWz1h/3958NNsWyVm6qOQBqkm2RDdqMwlQARX/5FtLAcaw05ZKrHvqvwo6paMgAAbe55HG/gQENloqyDOZYb1m+doBJYyOlE7ruPxcsyjLcCk0bsQL+K57xsgLGeP+XTMltoD8j9lg4pOuXh52hFFcQPhIhdEoZ1aDKocrC6OH8Bfh6QBt89DTLav7gDyuipcJa1WNQVmDi+W/vFLLt59BA9vXRl4U68cJY0pKl6Lmy6UYvc/1fN+ExMK9bgrnzUkGP4OtQNwOfbJtNzX05Kj9OWFDlbPS2jEB5IT0dhxfpsUnXO7YCdcdg6PWhhQqlOc3JZBcPYHfwr7yqDC1JV3KEVdDth5it1jmScTNCXyC23tLO/LT41WrqW+n+UzWcmXX2zpg930kMH+/YR1mBnJyjoTTOQGC/adaHjohqEOJiPLSXg+D5G87pymGMynOyLEO56QTNPRhiCaR0IekDQGIPVvs24uJLkcoEa8B85S48+qCVhfOY9LAmr99+Ahpo9uogKB2bF5F9UWW3GpY3rYjfXOLqqDZA7/Nl3+zTPKX1hoUi3CFz7NDAyUrWyH+7JsbGRKu1b54pbAgum/veIdEiRJ4ux2x6MEyzP+1A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(82310400026)(7416014)(376014)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zT2mEnKgHYLqdD8+TYTzHpVDpPV/uj0NuE+fkOFBMzV442QikkejWkrOKF/QHvzBFH5ALtfb6RWC8zDAnDiK3NiNRryjn0OF2wrUzU29z5j+TFlr/0MPRBFeamedwgMbhVPnfdKF53OERtkxZw+/lA3coZX2tbR88bKMfRIE/ma2h74YCS7v7hgx2cn2OLvEWK8MuEVFoB6se0qHZ3QvRYEPEZ8fARciBHq5B28xpFmsvBbwE3Y2VAN3W+Zy7uxpblAbMlf/ofEbRI0FhGSZtBtGd2YPEqU0ZiRsbWQuqARCsxqVBEr9QJAcmNxR1+dGWiIjnFiI5oeW07V9/hbMsh5CdFr6vsN3dsd1woDHbIf5a1Z0Bz8jicdfPLU90CDUObmevyPUgbFg7HgKwyoWvQMvcs2flzXPi4U4i4qtHYLACtrUp+wq/DbWQwuc7JiN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:02:09.3047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb48823-bc69-4af6-66aa-08df0f5d4036
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6039

Introducing support for live update on AMD SEV-SNP platforms via
DOWNLOAD_FIRMWARE_EX.

This patchset is an extension of the RFC patchset from Tycho
Andersen[1].

This series also fronts firmware_loader patches from Dan Williams[2]
which majorly cleans up refcount issues so that registering the upload
interface no longer pins the module. Without which having live firmware
update will cause failure to reload the ccp module as well as break
kexec.

Patches based on cryptodev-2.6

RFC..v1:
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

[1]: https://lore.kernel.org/all/20260430160716.1120553-1-tycho@kernel.org/
[2]: https://lore.kernel.org/lkml/20260331214726.903274-2-dan.j.williams@intel.com/

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
 drivers/base/firmware_loader/sysfs_upload.c   |  50 +-
 drivers/base/firmware_loader/sysfs_upload.h   |   1 -
 drivers/crypto/ccp/sev-dev.c                  | 446 ++++++++++++++++--
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
 15 files changed, 474 insertions(+), 88 deletions(-)

-- 
2.43.0

