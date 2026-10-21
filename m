Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792602322;
	b=sf22KRPW2UV/N/pS876Ux9IuHnqdqmXT1C+A39fH4n3gAGC3ja3GAXsvsuJhi8dftscV
	 t/fOR0Yx+0CuWP6c0JciCWTWzw3XJz3TLHr9ZzNYwnpfc6aQhXka5do+3jQ1lImgkY5RG
	 i5YJyywnCtDTMvlDy1y3iI6cFxtW1sfIjBAhZQD8m0Wpn8fQnWjN0uy6nMmplmDSh8z4g
	 qI18RY9danjYxD2WFdsARYAc5v8Bu5Kh5X4SoZypMFYMCYaOBaUQNHnLugrYfwRXt/naw
	 eJy4Q049jeSf7iCxDQQ7aRJfTf2w4AcMEZ7kCY06tFCyBSlMb+LKSVHhK2En2hadb4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602322;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=H47gmbpYGZ134hIwdn7ZoGjiCSWKlAI7u343cjXctac=;
	b=Kg9Ed4D+ezRbTAC2AWDgUL/7tGL8rtRuYPkPBTFCufSdaugReA72n6UszcQ6LTZSj+3T
	 pmquQ1NtlPZe94KVVHb0UUpCPVp0qiYhiAwoT/AbomkH2jZLnxgA6gmHPJ3f6G8cj86pa
	 AcAVP22ZppGp8FVgCo3yF4HVXn5Rvg5pxTZY4c+X1/nRmOh/BGVRvpJEUtLsYJ27ZWOul
	 8a0gfGKErsRgylEUmmWidHWJhtpRd2f8E79asxBrJZg2Tqd6SVGkKQskkK2q2mveO9fOa
	 ZmCsaMhe961IjU37ssgyBD/eCj16Eq6ZUxXyE750q0IuUGRO7BmpJzeQEFC7xyvYOQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ugyBSZUF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.32
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013032.outbound.protection.outlook.com [40.93.201.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372D2606A319;
	Wed, 21 Oct 2026 17:05:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 372D2606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ugyBSZUF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=poEwjOBthzcvxEDuL+TUtU3h6+v0sJ81i1FHSSDNfnCitqtK9vViSwXEKNLH9MiGjFCVO+bmDXIYWKy7mqMf5dgRrKoHxNT53ROGsETolBxhRvVqaeTs66qgWiDA9akACU7yJhwROxm4oxGHXSpuGiOe5nQ8MrYmoNKHzmubyn4qV9u6OM0rfzwu50B8BY1tv6WuU9PVlSiEWyoSE3llKKQ+DvyENzP3mgqVnvMOu60q+bYR4jjPocWTNiM51VcZFYzGUkyVXI4gSxnV2XM9qUbV/W3PJTlWTAK3iPp5o3ykcyhO2LINdDxnAy9T/ec1keQJd2Q9yXr2A+yuk0lC/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H47gmbpYGZ134hIwdn7ZoGjiCSWKlAI7u343cjXctac=;
 b=VwfJe4tIlNeGraYZJhYQn5e8/40QD35lssdUm1oCsoNY3PEpfC4Nob4eK9+lCWzFkAP0X87SIi+S98NwJDRI79l+zCnTvSEyelhTpssUIz3rfEm7CDBCeL/pz66hAT3KIiFqhaMS2Ryv7qOVuERk+/3HO2KQcFGNcXiBQHTABJj4t+XhfzDxQpgFh/KGcgtULXNwmevQomAMPEfraIaYwAtsBh9yoMvyT7mnnwjil2wN+QpxAlYqNwlPwyRj48qA2tCSVLLiYQrBp7tPMPwBzWK4600Kt4iX5VfO7WuJIN+h2ptX8xTp8myqsTquoPWexqEQGgeIX3h5jT1WvxHTBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H47gmbpYGZ134hIwdn7ZoGjiCSWKlAI7u343cjXctac=;
 b=ugyBSZUFuWuxvQQVeKRXEiDdZgFkF5R1NqK7WDA9DFAjCXTPPXhAFi6R4URE0E2UNwmQt9l+fTteSE3XYeYunBtkqRMRfpw59iDOn1hscalQd3DW6ypcYRtqXX6915PK89Gt/xHs1qDC7cZBWczewBL+HynxtHOBhfUfD+qNwXE=
Received: from CH0PR04CA0003.namprd04.prod.outlook.com (2603:10b6:610:76::8)
 by PH9PR12MB677494.namprd12.prod.outlook.com (2603:10b6:510:412::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 17:05:17 +0000
Received: from CH01EPF000BE94E.namprd02.prod.outlook.com
 (2603:10b6:610:76:cafe::6a) by CH0PR04CA0003.outlook.office365.com
 (2603:10b6:610:76::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.15 via Frontend Transport; Wed,
 21 Oct 2026 17:05:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94E.mail.protection.outlook.com (10.167.244.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 17:05:16 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 12:05:11 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v5 0/7] Implement SNP live firmware update support
Date: Wed, 21 Oct 2026 17:04:56 +0000
Message-ID: <cover.1792599491.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94E:EE_|PH9PR12MB677494:EE_
X-MS-Office365-Filtering-Correlation-Id: a36b61d1-2ea0-4758-bccc-08df2f957b02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|23010399003|36860700016|261021123027099003|56012099006|260925022911599003|260925021311599003|260925021911599003|261009223327099003|261009220027099003|5023799004|11063799006|261009221227099003|261009221727099003|261009223027099003|10067099003|18002099003|6133799003|13003099007|261021121427099003|261021135927099002;
X-Microsoft-Antispam-Message-Info:
	yNesghITxRLMm+IkRUNiaK/PrCCoe14cULAjj/PgquFoSrm7zJIc9J4Ph6pD2n3weMYEw1jQup3TOp7v8f1oCoJI54x+3aQu2A+rkgeY45Bj5KbnU0HbLsUH1ROy87y/zgR/XWXEEZkP41lSrc5vkxS9JV/uaQW7cw1/J+wLRl6WQzydq9x5YgV0qWtG0CE1jODWpXEOXXHQztl1jWS/SHkSSC3+yBmNW0QZCbpdUyXMQvnDeJ8bAhudHriJNJhoCld9xRk8SZ/OWJf1AUwLnwUwGMiFn4iDt07l5sEZZHP+EvQlknmRe0UViHykuCgsZjFnHx6PKRw7OSer1ja7pg6LbzRraxSx6TGrAAEwaoyCbQyHcS6E+5MsHtRZDwlW0tKu6pGl0uOk4Ufx+Ot8Stjg2yRBAmEjNSoKaQxCASNOiUaSJ3jdP67WGkfm81osdGoPFSY5lirx4fFsHddrpJUDHIz8SlFPjoJoI/neFCNMdRrnoOECZEkxCCCUNjcezSgRI4zXb8e0EbYq3M/gjvmOHyWi74N7Qhu/LrOSvc9v27sMwZ/v7Jp5Z38G6RgwC0FHlgCpPErmqF51x7QteJQ4lmTzVXrrzKC5JWdcp5G21GhvPyf2Ubk6yv4gSk0AUMJ5LcLYKCDKwqdWsoPlqabXJzFX8bwuoj9dAyj5+J4=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(23010399003)(36860700016)(261021123027099003)(56012099006)(260925022911599003)(260925021311599003)(260925021911599003)(261009223327099003)(261009220027099003)(5023799004)(11063799006)(261009221227099003)(261009221727099003)(261009223027099003)(10067099003)(18002099003)(6133799003)(13003099007)(261021121427099003)(261021135927099002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	E7O7Mud2daAm3skJv8wxlYItuH1TOvHBDXuxcYisS9XhiiFkjfY9iKCtzEKZJx5ZNA8xBJypVfmjGlqEXAG49NMO+8SuoD0TUCYVAZCAIWrvw8+UM/We7r3WJLkYOrnhJ8+/udh/Yh260Rpx53EPp1ZGBhpJZ62+iO5qfhZNbpNQJ9nOIZ8nSjjLSs+21JSpq+cxINpKRtf2LpDjB2glR8ZdalolFomcxdVHJ1PhOdbDyOINGtE4fKuGB8xqj3us8ibA+d7wVwWP1mrKASxEHXMESrJ/+GfHVHrDJrOeksbJNpi334je0GCIBZ9NhGDsrhYRMjuVvhhBuX3glFq7aJ+C+DV/yNiubRkpOUk1ECIj+IJ4WRjskt+7NOszH7dE17Sb9D7Qt4vzcj1RmqZ+6WzKUD3hBA4LDkNTinqPJ6Qc9Wjt2qSktZ7fAMruSFpI
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 17:05:16.9720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a36b61d1-2ea0-4758-bccc-08df2f957b02
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR12MB677494

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
* Keep the original firmware error when rollback fails - Tycho, Shantanu

Responding to Sashiko comments:
* Does __snp_alloc_firmware_pages leak the allocated page on error?
   - This isn't a transient firmware error. rmp_mark_pages_firmware()
     issues RMPUPDATE, and a failure there indicates an inconsistent
     RMP. Any pages already converted are reclaimed or placed on the
     SNP leaked pages list, so not freeing is the conservative choice
     and used by all the other callers.

* Can reading *feat_info here trigger a host crash?:
  - No.  Reclaim is only needed before the page is written by the host or
  returned to the allocator, which __snp_free_firmware_pages() takes care
  of after the read. tio_status page reading does the same

v4: https://lore.kernel.org/linux-crypto/cover.1792014060.git.prsampat@amd.com/
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
  - The ccp PCI driver probes synchronously, so psp_master is set
    before sev_pci_init() runs. The uploader follows the same lifecycle
    as the rest of the SEV/SNP initialization, including the TSM and
    verify-mitigation interfaces. The unregister in sev_dev_destroy()
    is needed so the upload device doesn't outlive sev.

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
  crypto: ccp - Register with fw_uploader and always fail
  crypto: ccp - Implement SNP Download Firmware EX

 .../driver-api/firmware/fw_upload.rst         |   2 +-
 drivers/base/firmware_loader/sysfs_upload.c   |  50 +-
 drivers/base/firmware_loader/sysfs_upload.h   |   1 -
 drivers/crypto/ccp/Kconfig                    |   2 +
 drivers/crypto/ccp/sev-dev.c                  | 445 ++++++++++++++++--
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
 16 files changed, 472 insertions(+), 91 deletions(-)

-- 
2.43.0

