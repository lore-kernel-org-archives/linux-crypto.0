Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794593443;
	b=y6f6T6x5W6QLpz7/oZL21lkICb0k1XqhXTwGBXpp/FSaEbX5a4H31XirR7KTOSd+QElH
	 wZxkyMC141T6WiMRmmhKgzhImUGMmTQyh5wGGZuJjcGb53llpvMhqmABmZhRFPsgSt+Zf
	 EuOOC0NnFrDaH2Z3LPsm7TjVAkY6eupt2RFO3wys8MfZL7ITUytOjDQJnOBYaiOSUmiNI
	 SjnmZG2cE3P7u3Y/FbFEolDELjnLqYvC81AuvUu+4Fexzz35KJmASIKjsW7NP9qYdofMj
	 XoecCvQvzDKQRlL5F9lEsLbqoK3loS9Jr/DXmWInoTYewgb4TCbANcqT4Oifrxft3Pg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794593443;
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
	bh=cTnocZSpGZ9k2cpp4xTJm5lnxBruoBEIaVe0m2Jl/lI=;
	b=NU4PtKzADP0B2n+7oUi681+W30R+O4EyV1Bn1996F7w38BJ8r2eYw9ofcEtRs+qgL2YI
	 dzH6/s8YijWXscFO4G+1evLdV57ljc3+UX35K8uaXLn/tKoySc0jva+ECNawoUa+1Rtuw
	 iOlhYOz3/7h6FPPSjurTZT1KzHmdQ+y5MzAa7eQADFyYgGgamZKJ9NDr3SRrKu+K5IUpM
	 MY/wirMjfBCu9qOnvijjjw2euvvMQhfgjjuXxxQ5+NRuxY+J68F7g4eMm7UnNGyyAgZtn
	 wrZJMOSs22DNxmKyrQOwzck68lJ6MhX3thj7dkJkF2jWA2JE/9r9Dh0Kj75ItUnTSXA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=CxTxqCid;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.6
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011006.outbound.protection.outlook.com [52.101.57.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C742606A323;
	Fri, 13 Nov 2026 18:10:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C742606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=CxTxqCid
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qB409RQ59X3YII5BXdLzn0HZjE54n6fZjJEr98r7yMTiP2YFgpOs9oe4JpUM5wbDLnJtIL1WLKd9/4JKDVBsBAXnnDgwpfLuk/M49BxBWAmyXRJZbwEYXfNBB/kyXpgSz4L0InvE7dmv/HgiO6GRQ9qxscbNDTbA7SeKKIFG2xD1IjyeTsP9TMo3JFMND48vSFkcK0n/2Fs9+7HJKxwkoc2MijKxcxBDyhd+4CUuoJpvZgZZL6dfTXi3rZaurv+NRg6VG1u4rYYJZp9ivzcdn6EdGa2aJGL5mBiv/T7i/pcZFEm+SBYVJVJH40+ckzmhVrCT1Q19Ch0YqRtWeVXoiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cTnocZSpGZ9k2cpp4xTJm5lnxBruoBEIaVe0m2Jl/lI=;
 b=HAGFZNWQvr98FLKCUD3moRH8KOP+20QF+zr3QslW4qeFW9S4wVgB37FKLEm/yUfxQUGrFsimmRhpfRkfDOwZFSvgj0sIiHRwMfnzJXwAqexgSs7kQU2+P3kcIGYGRG8jRHIkQWynkls/rpXylh+ryvfSxkRkYMsEBqrZ4TKhJia5JRfEdWhR9NktH9c6uLN5JMUOiWJnXyqR4GDpYpgqFIZyaL80jjSW+o+OVTu58vcqOyaND/yA+wznJFIcWlEOSei7LRJQ+gUeK4ZK2Mmalab0Vbw07Zg3LJkbfIK77lHntfQgHl+uSqa1TASBe39aU7aVUCk8jYGRkFBZ8arc/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cTnocZSpGZ9k2cpp4xTJm5lnxBruoBEIaVe0m2Jl/lI=;
 b=CxTxqCidcdEFZSgCytfyxmUJOi7KZSz3O0lG6kFIVrd168CttgLsMsevlWJQKT6qqhR2ETy6gJE/lMFeZSb4bvnLNboHuE4eOrFnYIwQm2+Fhm5aHQA+X4ZRW4D7xmGcgCkCI9lfLmDNLY1CR73lLZ76afQKvBAZtxpi7EnAHtQ=
Received: from CH2PR07CA0059.namprd07.prod.outlook.com (2603:10b6:610:5b::33)
 by CH8PR12MB410303.namprd12.prod.outlook.com (2603:10b6:610:32e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 17:32:07 +0000
Received: from BL2PEPF000352D7.namprd02.prod.outlook.com
 (2603:10b6:610:5b:cafe::ad) by CH2PR07CA0059.outlook.office365.com
 (2603:10b6:610:5b::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Fri, 13
 Nov 2026 17:32:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL2PEPF000352D7.mail.protection.outlook.com (10.167.254.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 17:32:07 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 11:32:06 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v6 0/7] Implement SNP live firmware update support
Date: Fri, 13 Nov 2026 17:31:53 +0000
Message-ID: <cover.1794531772.git.prsampat@amd.com>
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
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D7:EE_|CH8PR12MB410303:EE_
X-MS-Office365-Filtering-Correlation-Id: d942c957-e29d-4931-7f88-08df41ac0a33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|7416014|376014|23010399003|261009221227099003|18002099003|6133799003|261009221727099003|261009223327099003|261009220027099003|261009223027099003|3023799007|13003099007|5023799004|11063799006|56012099006|261021135927099003|261028144727099003|261026121527099003|261102123227099003|261026140227099003|261022075727099003|261022105027099003|261022113327099003|261021123027099003|261021121427099003|260925022911599003|10067099003|260925021311599003|260925021911599003;
X-Microsoft-Antispam-Message-Info:
	xcJ+BWJRffRnE/H6J6ckF2cXJtn4xpp0YDUXTyQ6IuRRCTmJs7eaVau/Uitv9fd9UqMSrL39dcX4u2ylOaEwMwQkoFKQa9VqUFafBoI4KIpVLHPyR35nutxQIlOomJcPBsagoRxqee/Wx79x/xU+4Ac3RdQWk2vnfZ1AZGTRES/wRqVF0lW9NN1jGyq6i84ioU3VMC3ilASS9HI2NcMfApOX7Bis87ZyMBlZ8XRLqP0SU5F64Q6+hSPfvhmOWYK9EFqn9eUX6yKnHAWQXswzs4Vi/nNNlYjtGMbSMIJl/DnIg/nAOXnBiHC/rsIr9n434jPocCAP+mapY3yyIoNkGeehQNw27lPwNgC5ENDx0uCIL9n/MUwwGIPK8j5ZZUxWFku7mdkQVKKiXYtZ+xr1fGm1wTyL7nL9nHrTMRqpNJljHxJyrURIjzL0/1YGy5LfGATUzAE2dWiEQ9zL3nq2e5ihg38WgmngJpRT/CIB3kV6lNoaaS8Tqbufu4LH/k5Qh8t6qjv9f9lAbDHUTV0HuPBaa7Ubwww+gPBY97Q0Tnp5oyVW+FTDrHD334astrfXn9iBj3iE9WFIqXPrIPFI87enrcO54hhD+6iKKVUW2vK0BZdtbVoXqD8cnD7BwL0Nbq/ySZl0z06jV5EvPsN5RA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(7416014)(376014)(23010399003)(261009221227099003)(18002099003)(6133799003)(261009221727099003)(261009223327099003)(261009220027099003)(261009223027099003)(3023799007)(13003099007)(5023799004)(11063799006)(56012099006)(261021135927099003)(261028144727099003)(261026121527099003)(261102123227099003)(261026140227099003)(261022075727099003)(261022105027099003)(261022113327099003)(261021123027099003)(261021121427099003)(260925022911599003)(10067099003)(260925021311599003)(260925021911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cwUXVmZJQpFYq6xuiXVHkhqbaw4bo2fMX3PSZlQSVK81R3AfHhsq8drx5D0DlZglBudTJZp6c+ww2ZvmlE5LXzlftidQBI9Om6Rn21m1dRxdz+GSdWTYHyTJxl95kJbCFKpnCre9O2muu4rFA61YX2NbL4pXVdBQ/jFtBtt6tD6Vo37VcaBkL3c3faCx1eVx2d2ptIwcNwCSO2gHHkKaW7TO68fHK4PK92YZLfiLZn9CoeonUE/99svuRHNTeSGW4LxFESHLAv2bRHD5ABXBZV9N+bqrrOfzte9ZpaI01u9JeDAsmNNkDZ9AikEgXhOsYlKUmWewhxdImEZJChynKhZiCC86Pb0cXNfqs8LIEI+duOsjYSFWv+tw1QuSuw2gUfbKDiuHD3/EBHqPGGg0uyZAg7MaU9lvSMRlylh/+wNjRgJwv752J3oESPjfIs/B
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 17:32:07.0783
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d942c957-e29d-4931-7f88-08df41ac0a33
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB410303

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

v6:
* Since "crypto: ccp - Make usage of sev_cmd_mutex more granular" is
  merged, __sev_do_snp_platform_status() takes sev_cmd_mutex itself, so
  calling it from snp_get_platform_data() with the mutex held would
  deadlock. Instead, stage the SNP_PLATFORM_STATUS output through a page
  from __snp_alloc_firmware_pages() and issue the command directly, the
  same way as SNP_FEATURE_INFO.
* Refresh the cached platform data before re-initializing the legacy
  platform, under the same hold of sev_cmd_mutex as the update
  itself - Sashiko
  This ensures that:
    * __sev_platform_init_locked() logs the new firmware version rather
      than the stale pre-update one.
    * There is no unlocked window in which concurrent callers can see
      stale platform data, or in which a legacy guest launch can move
      the platform to WORKING before the refresh caches that state,
      which would make every later legacy SEV INIT fail.

v5: https://lore.kernel.org/linux-crypto/cover.1792599491.git.prsampat@amd.com/
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
 drivers/crypto/ccp/sev-dev.c                  | 454 ++++++++++++++++--
 drivers/crypto/ccp/sev-dev.h                  |   4 +
 drivers/cxl/core/memdev.c                     |   4 +-
 drivers/firmware/microchip/mpfs-auto-update.c |   2 +-
 drivers/fpga/intel-m10-bmc-sec-update.c       |   4 +-
 drivers/greybus/gb-beagleplay.c               |   2 +-
 drivers/iio/frequency/ad9910.c                |   2 +-
 drivers/media/i2c/thp7312.c                   |   2 +-
 drivers/net/pse-pd/pd692x0.c                  |   4 +-
 drivers/virt/coco/tdx-host/tdx-host.c         |   4 +-
 include/linux/firmware.h                      |  15 +-
 include/linux/psp-sev.h                       |  19 +
 lib/test_firmware.c                           |   3 +-
 17 files changed, 482 insertions(+), 92 deletions(-)

-- 
2.43.0

