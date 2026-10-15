Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D3F2D837C;
	Thu, 15 Oct 2026 02:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030467; cv=fail; b=rOGYLf5qWPJDqw77Oht7kqjepH+2stVVVY20PwjUvT99gb30dMZGAsSyVyrZPtFG2JNw8p5jUonk9YqKIASRanL2hjNGaFhSbixssYRmDsuTAOhUu7zS6KAFdCK3UCdTCkmxpp8jno8nk8pOdT4DJp8/O8oqp3zKwMslEfiy0G0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030467; c=relaxed/simple;
	bh=AmNhEZoe4xrDOqSAfA602lkX5XZ4+dCYr1QpMPy0x/s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cGnoaM5KBzyjnReOgCFJfvzhG+Jz2oHRJCKoRHvnkUJSNVIrtghma5379orydHwZFhWIsqgJt7j7CMZ1DdFJGkunJF+0mJL0bZiyaY1ru98Pm+tmp09S2pjy9fU3JhK1H4HGZNUMR/CdvAUuO0jM8PpLw9//R+sYHjRTt9zKFbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=245u5240; arc=fail smtp.client-ip=52.101.46.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="245u5240"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TsAGW1oWhIONpxPtZXjVexjXinNSpDkpeTKci4glsNpZm0s1vJpVtdcW+kKUDdiLu7dMokBzQZE8gdyDi7subKdV4c2H73NMHlO92A343azm74Z6TBQuxFoyGhnzHvW5izPD3OR4jcwGEYgRsqXxO5WPsuwrcq+T4Mz7V50dolGLfFJ2ebD7unSsvARviznf15VRXaYgLieloEUTw13BbsfKiDm8PcmdYBHfUWOswsyKNz8k2Oro/i37qQsbsiSXdynz1pKpfzOCh3VPDqhq75yO7WUxGcgS/wV1BlRXsLLyaIQHcOQHMhKGwomCyoYpVyBuDIT9lvSKaBh2T/F3mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+h8213cGA9R+xKzJuSuANQfEACtiALWQ10h3+E4YN0Y=;
 b=uafQavPQjHUgHQQwxFg6xyCHIaWppnsSAsoIl1vKqhC0fboAJI8brltPJvtYaFYG+QM2OLQIy3kvBFiPKcaOjeqp87n7PJ1i2wbiu8R5FsvnTNBncsZIZaukRg6BaVXuNkZFYlvT43+viu6GQwyna+YW4uQrSJJMOubAFZPXIPCW/cfClEgjoxOVp4iPk4rU0MYAnVKGJWVxtlSHD26GCkg5UyXNXAbNB4zAOK6iYeRu/M3Y/yFbjBx+azIOLDCCz1Bef+2WJvPr+VduFHp/qrrMcVYdEF/65kpJtIJiyUTKokwSRnjFm0vh7wUEAhZ9EqH/FZX060yimNYFC9l65A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+h8213cGA9R+xKzJuSuANQfEACtiALWQ10h3+E4YN0Y=;
 b=245u5240CD+HZNJCu7J0T0tTKfU+zYamaQaYZBg/2rb05rFZWLIP0URrXitB+sxGx5NHagSmDrI4Xjo1gsIn2cpttO5sVQMG75tfFw+/xDsNiaUM9DYbkREqgtLnrYMZonfade9S/j/mBxUlVqFFkPPnwHm/Eu5Aa4H8zwRC1Go=
Received: from BN9PR03CA0674.namprd03.prod.outlook.com (2603:10b6:408:10e::19)
 by SJ2PR12MB9088.namprd12.prod.outlook.com (2603:10b6:a03:565::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Thu, 15 Oct
 2026 02:14:21 +0000
Received: from LV8PEPF00000067.namprd03.prod.outlook.com
 (2603:10b6:408:10e:cafe::18) by BN9PR03CA0674.outlook.office365.com
 (2603:10b6:408:10e::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Thu, 15
 Oct 2026 02:14:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 LV8PEPF00000067.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 02:14:20 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 21:14:13 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v4 0/7] Implement SNP live firmware update support
Date: Thu, 15 Oct 2026 02:14:02 +0000
Message-ID: <cover.1792014060.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF00000067:EE_|SJ2PR12MB9088:EE_
X-MS-Office365-Filtering-Correlation-Id: 1671ef64-8fd4-49f0-4663-08df2a620615
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|1800799024|7416014|376014|6133799003|260925021911599003|10067099003|18002099003|260925022911599003|13003099007|260925021311599003|5023799004|11063799006|261009223327099003|261009223027099003|261009221727099003|261009220027099003|261009221227099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	K+qjUlSNoyHdjBiJS3iOxYIH3vWJtlgKsRVUwrP93cd3rSy/BzEd6k0UmcrgOOWbq6vDFP2Wg6WY9zaJw5RB+i06zIItbNT9oQrU36uxklEB3ApOyTq8RcoAHJaSTCctV14U0cLncq1CBXX+XwrAZoSAW3KiXciOs0CWoKDjmGKB7pgGgMvk4odX3sRjxSaYbWHviCwqVrp3NLQvYtWLezc88f9RtzzEjqIMy8+BiznMTUBWDbuDRWfx+4IrGS7EPF0pd9Z2s5OJqS393Dm1sZXuT79kHVhcax2rUCMUaIGzilczTt/0UGgbuGs74gS2LNvwvrQ0fuZ4xyNmfqmfRRtSTffK1M3l5/bTXP5r727Clwwglyv9DZA3+MiPGgCjv8Yy0Il+14Fv8fP5ei6A4m03sHdR0uZjWPGDnaxlgdX0OyMX+kghgfYRlMO0pNnuLPmqlkQFqw9dekWuTMe42zCH0idowzj2z6wZ/yXUTnhHl0oUbylJ8zoVJbSxbFWuj82kxonzLc2Bmioaj4X9NBr3lmQv2I9q/r1fonhX9iv24vyE4GcsZzSviqOwzIAiiLQc09WRzH3ESX37DeDxlSOO4P4r+x0KRDMYysb4a+iJ4jJmQbEo5c2hXc+RxJ0AbfUfhHxnyZT9Axz5QLF1DC9yYdAENy87vCLrcrxBcnM=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(1800799024)(7416014)(376014)(6133799003)(260925021911599003)(10067099003)(18002099003)(260925022911599003)(13003099007)(260925021311599003)(5023799004)(11063799006)(261009223327099003)(261009223027099003)(261009221727099003)(261009220027099003)(261009221227099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GflcxG1pOqwcBBNtXPDgr6uOCsyX9w05++RG83LWxt05f1b2uLGSqiHI2pM/R0dMcmkNgnBvb9Oc9aRFKVPX7x1wYo4QwqlDa+xZeQHPopvGAbSxFF1lGmOKQ+9HtrAh5pXYvWCnIOwDYthjIFdzG20fPA/BNS79EmyRvkTv2ylPwf4SBG8E6X6xaIjZ4Rcx2BEGlNg37FlPDwY+hydd8cfgQEDifoFEyZpE0m/mM7D2FFuMDGcqvIQRx4sph6Gyi7lVjKBPpcP+AudpHJAQg424bACMchOn93BBDo4vzgR5KkLqioc7CPSPvokj4JnA//5AJyd9pMO5CedLBFF2Tf0dYFIDjEU0Q2xZIddP1W0aJ17uwT/Ic7/gcVwXuKJmKRoZZBD87D5JNzfw1H2QPJVgHT6N/WzdeATcjrkmHcV3i3CEHWQWaPCNm4bM0gUx
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:14:20.6690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1671ef64-8fd4-49f0-4663-08df2a620615
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000067.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9088

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

v4:
* Collected reviewed-by tags
* Cleanup snp_alloc_firmware_pages() error handing - Tom
* Cleanups to comments and code formatting - Tom
* Change dev prints to ratelimited - Tom
* Add comment about releasing sev_release_firmware_buffers() - Tom
* Add FW_UPLOAD and FW_LOADER to CRYPTO_DEV_SP_PSP config and clean
  up #ifdef-erry - Shantanu
* On failure of sev_get_api_version() return an error only if PSP
  failed in all other cases DLFW_EX succeeded - Shantanu
* Free TMR if we were already in UNINIT too - Local Sashiko instance

Responding to Sashiko review:
* Possible RMP violation when live fireware update races with
  snp_get_platform_data()
  - Both the dlfw_ex and snp_get_platform_data() are called within a
    mutex guard so feat_info can only be accessed once it is no longer
    in the firmware owned state and the mutex is dropped.
* Register-unregister failure
  - The ccp PCI driver probes synchronously, so psp_master is set
    before sev_pci_init() runs. The uploader follows the same lifecycle
    as the rest of the SEV/SNP initialization, including the TSM and
    verify-mitigation interfaces. The unregister in sev_dev_destroy()
    is needed so the upload device doesn't outlive sev.

v3: https://lore.kernel.org/linux-crypto/cover.1791212077.git.prsampat@amd.com/
* Print psp return codes along with driver returns for easier
  parsing - Shantanu
* Clean up error codes to map the right firmware/driver error condition
  to the firmware error codes. - Shantanu
* Report -ETIMEOUT case by checking for psp_dead after DLFW_EX command
  is called instead of reporting unknown error - Shantanu
* __sev_do_snp_platform_status() call can race and incorrect cached platform
  states may be supplied. Guard the call under a mutex - Sashiko
* firmware unregister can race when called from sev_dev_destroy() or
  sev_pci_exit(). Guard the call under a mutex - Sashiko

v2: https://lore.kernel.org/lkml/cover.1789749016.git.prsampat@amd.com/
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
 drivers/base/firmware_loader/sysfs_upload.c   |  50 +-
 drivers/base/firmware_loader/sysfs_upload.h   |   1 -
 drivers/crypto/ccp/Kconfig                    |   2 +
 drivers/crypto/ccp/sev-dev.c                  | 448 ++++++++++++++++--
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
 16 files changed, 475 insertions(+), 91 deletions(-)

-- 
2.43.0

