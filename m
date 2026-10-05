Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010061.outbound.protection.outlook.com [52.101.85.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E354C9E1A;
	Mon,  5 Oct 2026 16:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791216975; cv=fail; b=SRJS2sEYLVed/SayU2hq1Ao23ewOCDSknJRa6ydfSPsNyKKK+SP/GRrr3fgPpfFtjnV7EVXhtoj5kzd4208+J/0HSXQLNhfCHZ6NbWNTOwUbxz69hzjyMDGxWytQEfmrgpQgZZhAxHR/uLTzHUra6wMMRuGWph/PvUhL7gyqiPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791216975; c=relaxed/simple;
	bh=DFm2TppdLfJlu1cUdUdxJLjKcJ2HJiFT6DDwxAb3YyU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=J3ILy+c6aOTQEJ/B9DZIk5Y2qz0sjxIe46b/YCFJdGzc9Sl412HTiPl6YhArf8XGlki1jNSWd10ixPOeUpTRJoc2A2ZBElV/YxPa71TH3FGqPyeoQcpOXnfybJ3OkNje/HEm4sjRQXIUZXX53+tMwUIX6eDVJDg/5VmmQodRn2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NsCNipXD; arc=fail smtp.client-ip=52.101.85.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NsCNipXD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hJOcIw/cCEFaBABwSYY/kz8NURj3cRyaMLQY1L1tXGJj81Y5uKYIwpZngm6aGZ5iVtfJmU33MejkkhUS94HHGTbQG/IRZxCcgeDZV+YWgncWSSb0wDV6q/kmbj9a2cDKX8dD4HQR9+3YvjaOg/WFrmR4yu1EIcnv2tmZSsFzrHCS8NEhMu6YP6qJgQNKArz7vxUP+wP7wCyqZkvanYQCQhyOjcBCmfbRzKLTsGgu2zx55iYMH/j/dlOtGOkaG2uh/wUVeAbOsGYudBozvfU24VzDwAQj3ovtv8zaFGKAllzJ9IXv0FmWPDtI5HJgiox87L3JnV+bgTciWVOzjjU/jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pKUfNGul75L2lG1fF0qVELBxjx0XUz8Lu98o7ig/5dE=;
 b=UuLfXBXmulHbTCAtZAg/8PxB5L7xge7EnGiGkqYF2sRaF9PPi6kELLotGl/yylEsYJeDy3nQK6dP+B0ZTJ4FPNkUjD3e+DryczQThht3dDdp142reRoitEFiI0zBunG7tT1pz/hjvgrdTVgReGtnoJPfsI4Xou2PQdcgwdRTT2Xjc52VX3zDcigHCpT1eOPddXiGbPUHkT0fhGNYzlKkmSi8Nt2X2Zhmm+wIOKBqPWT97B5vdbi+O2YRArARX1XBfD9CEOj5tNSGS83iN1rwsvTPRSva4exdy6qP3nNTNFzFKBZ85fYhcWxCsK4mKdOpVNittzggWs32P2D+B4ADsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKUfNGul75L2lG1fF0qVELBxjx0XUz8Lu98o7ig/5dE=;
 b=NsCNipXDuJCDW9jAoqxtTbiK/OIei7/OLMM6akKWfiL1afFjEW302d82xHAib3MDMHd+E6JTlXEDIN/FbWHMoUMpjbE5OjKNvdIxyAIrcCSAcq1WTArYOnTZVkiXqYwQMmezqZ1AavqmkFREy7peCZmQoqIv2xiPj2Fx21UBXBY=
Received: from BN9PR03CA0491.namprd03.prod.outlook.com (2603:10b6:408:130::16)
 by PH8PR12MB7279.namprd12.prod.outlook.com (2603:10b6:510:221::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 16:15:52 +0000
Received: from BN2PEPF00004FBE.namprd04.prod.outlook.com
 (2603:10b6:408:130:cafe::a9) by BN9PR03CA0491.outlook.office365.com
 (2603:10b6:408:130::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 16:15:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBE.mail.protection.outlook.com (10.167.243.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 5 Oct 2026 16:15:47 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 11:15:46 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v3 0/7] Implement SNP live firmware update support
Date: Mon, 5 Oct 2026 16:15:34 +0000
Message-ID: <cover.1791212077.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBE:EE_|PH8PR12MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: c69c8168-1d5b-4e49-f798-08df22fbeab4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|7416014|23010399003|11063799006|5023799004|56012099006|260925022911599003|260925021911599003|260925021311599003|10067099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	A6CYcnTZ+C4Tf4a92VPJGyQRQ5RaVR4A/jY1HWAKI2HNAEK9FQGmp6WAk8uCy9bIMkDLY4ap2Tnfgu/wMcsVEIYH53Z/73Tx1YJ2PcVpamGyVdIFH20vwCAzhZo4fpvBOiAyjOXz0HbFT4Y83OoskWbIqwZeqUKaEdSbvZ/CBbZRsEVvuDCnpi7mx0e3xMajANqUSeT/pkwXE9CxGv1xMHXaqCPPsdeoEXSB0DAhJ56gA55lHHCghAsSlN3D5Yaz+FcuGnm53eVsXfcn1wRCkkJUlXiuye/rRuZ55wtw8yEHFyPqOfVB3iUMNAN1QCgIia5mLCmQz1LR/o0t/ge9+99Fm93w9dINwRwo10duj2YewO2a9SpINdsqWHYtflpHEH38JX6V3iwyX4VyX25SXpkUxfRuk9zszcn8xJMCuhQ3K2vhSFim1XHKQV5hwH+pdJj7ElnZfprO4twizjNjH7CkLZbFpY1KQZeDf28ZfXla+z40mYP6UvMAS/Pygai3yFbKjk2HhQFsIL8SBBHSXhbuTooR0+TD/VFvcB89wT502pCC87zbb/4l89R1YfkFKtwPYnjjIqdWyfNd7YyQWLSm+DGMJdvSatWXrdA2Yilvah08FvZUygT88Qaf9SoUhXkSYNeh72NVXUltFwkQV53pAqmMderK/d7VnoPQrmc=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(7416014)(23010399003)(11063799006)(5023799004)(56012099006)(260925022911599003)(260925021911599003)(260925021311599003)(10067099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KkTzItub5gtBeN08OBcIlQlROVc5Ot6/8s+PBLJ/WDiwC+t11ukNCe7hWwmjtHfW6xEVweuyQy16JqHJp1zSbd+GN5eAx/fDLP2YxBukdwSoZy8fFlI+5QP7FN/Wgr9nYeytO0vp9JM4rvQeaI4oqzc3CPjH7dOJjVz75igWISV/f2FdCDrNKcWCD00U8q7L7JJ4ffQCkivUtQyTt2XyDp6/fIh79nTlRS2BXLFtey4cm+y4UcsYcHZC2U0EZWnsKpK+1ruKtU2qrqZ1yDUkoSMpno3/U4ojjtBPJEqvxpF0gUirE5RCm0c0Nu3v60qiGawY6X+w0q+7B+bxgBQprAhezQjN3D7guadLpzvtdhG6xvkjrMpWv4qFEXs66xGKz1MnzlPCK2uBl01dSY+xRStTfTN/3qwQ0OK5IagcKyj7oe8Y+IZHp90YrPApU9IP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 16:15:47.9329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c69c8168-1d5b-4e49-f798-08df22fbeab4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7279

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

v3:
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

[1]: https://lore.kernel.org/lkml/20260331214726.903274-2-dan.j.williams@intel.comi/

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
 drivers/crypto/ccp/sev-dev.c                  | 444 ++++++++++++++++--
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
 15 files changed, 467 insertions(+), 93 deletions(-)

-- 
2.43.0

