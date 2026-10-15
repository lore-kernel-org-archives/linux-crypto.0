Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011011.outbound.protection.outlook.com [52.101.57.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AFB3BD22B;
	Thu, 15 Oct 2026 02:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792030572; cv=fail; b=TFPjUNPKp7rWPGqS2mR8Q+fm2HfBip1lq8d/vJMFIYZxk+vXdvnI+LxJEjGtG4R4fMXGcwJkg/HBqpeBLx6c/rdMhfr43We6LkIK/XAAZSHS3CcNgQsGQtv+bfmbTQXnWbZv0vUKVhTH4RzZSXHiSUv7affvLlKi7Cy7cmkAaa0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792030572; c=relaxed/simple;
	bh=RlMv6Pf/Kl/4MVcDLjTdRbUU0Bn6yk4FvZUtXRQsebE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Omv1Pb0VjrCowP8ZxKvIBCMaDg6pb48ooK9YI+7OdzPDSg+oJOtQBAw6AI3F6WeFKCFdF5Gq/g1k30qgFbc3noElfHbJQDvdmtrILjDyUHOHQ/LiQFhcW2TIYKCl/0qsHWDNQMa18aE5mdvch6g+uCrbhf/PAUEZaDi1Eq+Hnrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=e2fArLrm; arc=fail smtp.client-ip=52.101.57.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="e2fArLrm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M8NL9OyRqzH1o5Y/fmy9MDfG0TQu9QPL0MB+wBomOnTnKRz5FzpuufHYVOuMJ0v759HQ0iKvscSwcqrSl9l+K2kIMltMaqs/+aLwpTn45M7J3EFDEfIIVeLHzZMoQEnQGT/W/MHRBm0aDbZ3/GbhDaK+6CijV84ifJe+LiU/hQZU2scbYXLHRcwJgp/ZE6sVYx29Df+uOuo1WIk5niAqGocndKzVpB05bAM/U/OuDe3ANT70Yq/cTgfvWtrjPYMy+tP61kCn/U1Ll6y1FOFJRt4OnTSSFKnp2E+SCSb7O+elhLQkQDM7FF5M9eOZkN/8NJkqFZ4MMAMYToNUArhKuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PM9HnF1sm0uCaDFVv8NIOevDMIq2A1BiA0aKYLPzJz8=;
 b=KF+TkhxdIyrN/JlPsNAifvnqPSe1Snzx/SwLiu/wQ+nIpZ/XEzUOpsNDQPXzJZMeSiG2RT12O5iQFj5RjR516iwFaUEsWFM9jWUEnQ25fu2FK79NHEgRMJECZhSaI5PYL++JWSsdVwG7aS7pOicZqvEAY5nl1iurCP0uPpnX6dWDLPNawYKUNP8NBl0l4/C01Ys1OwQznk+HWgcpPeMeMwLz0lbLyKW45kjXduuIBJhQd7OOeUh/y269XgqUYOBTa6cOc22HAJqHqjECWuLqwvZYQ/hyDyKpICF/AwU2bRT9f7JYiHWFH63zOiZEpQKShap0XBuUOPDxvwBi9XiBnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PM9HnF1sm0uCaDFVv8NIOevDMIq2A1BiA0aKYLPzJz8=;
 b=e2fArLrmV29fLRGQr6MLDSd+S5z5d7ccEEU9kD806f1GH1dssV4NDUIEGDcIA1R3gKP5TK7b6xhtitoLVeLBPDZ5fsXt6i/DpdZMSne9H2gjROBJXvjCDkjDMjGDuISQtGdqe30VMyzptS723sjbwmxLo/w5POPyF1DEYOfhyCc=
Received: from BN9PR03CA0362.namprd03.prod.outlook.com (2603:10b6:408:f7::7)
 by BN7PPFCE25C719B.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 02:16:05 +0000
Received: from LV8PEPF0000006B.namprd03.prod.outlook.com
 (2603:10b6:408:f7:cafe::6a) by BN9PR03CA0362.outlook.office365.com
 (2603:10b6:408:f7::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Thu, 15
 Oct 2026 02:16:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 LV8PEPF0000006B.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Thu, 15 Oct 2026 02:16:04 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 14 Oct
 2026 21:15:56 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v4 7/7] crypto/ccp: Implement SNP Download Firmware EX
Date: Thu, 15 Oct 2026 02:14:09 +0000
Message-ID: <55c189e9130a7d22c0b756440f10a056415404e5.1792014060.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792014060.git.prsampat@amd.com>
References: <cover.1792014060.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF0000006B:EE_|BN7PPFCE25C719B:EE_
X-MS-Office365-Filtering-Correlation-Id: a164305c-5601-4525-286a-08df2a62442e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|1800799024|82310400026|23010399003|10067099003|261009223027099003|5023799004|11063799006|56012099006|3023799007|18002099003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f8ZKawwRfnOg3VyWPM4L+JePmEav2NaeDSSIrCUHmhAhx9TTLYjpSmy9lsw40BQe7H/DsJH1oowSxUs++ZWWII/hC5pjgHMFSmV1EaG+90zJr6i63bMOmXx+8zhA5I9NGS78WjN1TrSzhy5exvOKJwS1Ug34dkfoANAMLV5KyPeKsRJtaqpARNXc79XWCQS1NA1BJdMWp2i4GwPFuLWDbhzb0NeJaFUJsdgEQcUPZmEqFYZfrGoyJvoNW4GHhfQIWN+JYRbWFPkmOeeZrat+zbv0hPDkMRY7dxZYpNeWw+hvrf1UTbqCL77II4GXEQWpf4+KGEgEdnH++gI+A1K6gErjyCMDiEWGHwNPdv+rWQtUN31FMj8q7HINmApnKI6iPUYsRMlt86/HkRS2WJfdHUFCLWF+EzYX2+/Q0j/PyAt6OrWkRdsTMX5u+CFdNhrA9R4O8EEbs0W626ufukDyLZw0R31WsgF5KP47d4n5hRw+9yx83SHFhwXteHHa+NA12Rh2xZb+rULEHvgGQEvU7RH5V16YDMq8U9XfbnTRDvg6XXDasofcxfe5D5WN0DLXh+nS17BRSTRkH8gPAwJMRmn2lgajGoq/Kcz0e6jUT2g1OjeNbSg0b9V7XlNpunpA8VETAmIZSQMEMqdbmbIHSMf1YkjntveFDdZ5MC5Mkyt+seBfEZa58YaE+5lqbdcLkLjj/o4hMwZxyKgzRLQ/fQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(1800799024)(82310400026)(23010399003)(10067099003)(261009223027099003)(5023799004)(11063799006)(56012099006)(3023799007)(18002099003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YnDRRKZp3a3/D5M58xkD2PfTLjwqvEWaKVePpiVeP+3hHydjvGd1gYqL/pGTdOVgcxEohoF6//JPEGk8Asy7bySuRNcfPMqUYkfLstfHUSqWmTLZXwv6Fpso2VdVC+HQnygAjfZD1t65QzM/Bl9U2AXUXjuyF8zulw/csYCe9pTVjLGnip5tg0YFXjH9zXu+U9Jrx6kCtjJwfVgKbvBWGlcrKGzWhOMU1EVAwRw/0SqIphy3RDEqmhIK/eEFCCwUBz3WBKWSYIVMob0n3j2O+L5MoRA3EoA03on7VxcFQdlVAXPQo6meoLeMtRHkGRMhMQxNaJJd+frsqe8fNdRT0gKirujom35wkJkqjjkD57JXB5bMTdmNHDrR8rgSm7pPO559mebJXoE8+dTwcjIA/vzHWz8BYbqS+KK/Wcq42oKFNWWPyql3rZRqbDramKL5
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 02:16:04.8535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a164305c-5601-4525-286a-08df2a62442e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000006B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFCE25C719B

Implement SNP live firmware update using the DOWNLOAD_FIRMWARE_EX
command.

DOWNLOAD_FIRMWARE_EX requires the legacy SEV platform to be UNINIT. If
it is WORKING then legacy guests are running and the update is refused
as busy. If it is INIT, shut it down, release the buffers the firmware
owns across that shutdown, run the update, and bring the platform back
up afterwards. SNP is never taken down, so SNP guests are unaffected.

To test run the following with your sbin file in FW:

echo 1 > /sys/class/firmware/sev/loading
cat <firmware.sbin> > /sys/class/firmware/sev/data
echo 0 > /sys/class/firmware/sev/loading

The COMMIT bit is left clear, so the image is only loaded provisionally
and the admin decides when to make it permanent with ioctl(/dev/sev,
SNP_COMMIT). To roll back, do not commit and upload the previous image
the same way.

Co-developed-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v3..v4:
* Change dev prints to ratelimited since they occur due to userspace
  interactions - Tom
* Add comment about releasing sev_release_firmware_buffers() - Tom
* Consistent use of DLFW_EX rather than DOWNLOAD_FIRMWARE_EX in all
  comments - Tom
* Name error codes by command, firmware and psp within
  sev_fw_upload_update() - Tom
* Drop #ifdef CONFIG_FW_UPLOAD in lieu of electing FW_UPLOAD - Shantanu
* On failure of sev_get_api_version() return an error only if PSP failed
  in all other cases DLFW_EX succeeded - Shantanu
* Free TMR when platform state already in UNINIT too - local Sashiko
  instance
---
 drivers/crypto/ccp/sev-dev.c | 300 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  19 +++
 3 files changed, 320 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e24c04956535..05e8513dfd36 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -29,6 +29,7 @@
 #include <linux/psp.h>
 #include <linux/amd-iommu.h>
 #include <linux/crash_dump.h>
+#include <linux/sizes.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -252,6 +253,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
+	case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:	return sizeof(struct sev_data_download_firmware_ex);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
@@ -2212,17 +2214,313 @@ static int sev_update_firmware(struct device *dev)
 	return ret;
 }
 
+/* Largest image the firmware accepts, anything above is rejected */
+#define SEV_FW_IMAGE_MAX_SIZE	SZ_512K
+
 static enum fw_upload_err sev_fw_upload_prepare(struct fw_upload *fw_upload,
 						const u8 *data, u32 size)
 {
+	struct sev_device *sev = fw_upload->dd_handle;
+
+	if (size > SEV_FW_IMAGE_MAX_SIZE) {
+		dev_err_ratelimited(sev->dev,
+				    "DLFW_EX: image of %u bytes exceeds the %u byte maximum\n",
+				    size, SEV_FW_IMAGE_MAX_SIZE);
+		return FW_UPLOAD_ERR_INVALID_SIZE;
+	}
+
 	return FW_UPLOAD_ERR_NONE;
 }
 
+static int sev_download_firmware_ex(const u8 *data, u32 size, int *psp_ret)
+{
+	struct sev_data_download_firmware_ex sev_data = {0};
+	int ret, order;
+	struct page *p;
+	void *fw_blob;
+
+	order = get_order(size);
+	p = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	if (!p)
+		return -ENOMEM;
+
+	fw_blob = page_address(p);
+	memcpy(fw_blob, data, size);
+
+	sev_data.len = sizeof(sev_data);
+	sev_data.fw_paddr = __psp_pa(fw_blob);
+	sev_data.fw_len = size;
+	/*
+	 * Don't commit the new firmware, an explicit SNP_COMMIT is required
+	 * after update.
+	 */
+	sev_data.commit = 0;
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, &sev_data, psp_ret);
+
+	__free_pages(p, order);
+
+	return ret;
+}
+
+static enum fw_upload_err sev_fw_upload_handle_err(struct sev_device *sev,
+						   int cmd_ret, int psp_ret)
+{
+	enum fw_upload_err fwl_ret = FW_UPLOAD_ERR_FW_INVALID;
+	const char *msg;
+
+	if (!cmd_ret)
+		return FW_UPLOAD_ERR_NONE;
+
+	if (psp_dead) {
+		/*
+		 * The SEV command timed out and marked the ASP dead, there is
+		 * no status to decode.
+		 */
+		dev_err_ratelimited(sev->dev,
+				    "DLFW_EX: PSP not responding (failed %d, error %#x)\n",
+				    cmd_ret, psp_ret);
+		sev->fwl_rollback_required = false;
+
+		return FW_UPLOAD_ERR_TIMEOUT;
+	}
+
+	switch (psp_ret) {
+	case SEV_RET_INVALID_PARAM:
+		msg = "Provided image is not well formed";
+		break;
+	case SEV_RET_INVALID_LEN:
+		fwl_ret = FW_UPLOAD_ERR_INVALID_SIZE;
+		msg = "Provided image has an unusable length";
+		break;
+	case SEV_RET_SHUTDOWN_REQUIRED:
+		msg = "Provided image cannot be live-updated, shutdown required";
+		break;
+	case SEV_RET_BAD_VERSION:
+		msg = "Provided image < committed version";
+		break;
+	case SEV_RET_INVALID_PLATFORM_STATE:
+		msg = "Platform not in UNINIT state";
+		break;
+	case SEV_RET_INVALID_ADDRESS:
+		msg = "Unaligned address provided";
+		break;
+	case SEV_RET_UNSUPPORTED:
+		msg = "Feature not supported";
+		break;
+	case SEV_RET_INVALID_CONFIG:
+		msg = "Image rejected, unsupported configuration";
+		break;
+	case SEV_RET_BAD_SVN:
+		msg = "Image rejected, SVN < committed SVN";
+		break;
+	case SEV_RET_BAD_SIGNATURE:
+		msg = "Bad firmware signature";
+		break;
+	case SEV_RET_UPDATE_FAILED:
+		/* The previous firmware is still running, a retry is safe. */
+		fwl_ret = FW_UPLOAD_ERR_BUSY;
+		msg = "Upgrade failed, automatically reverted";
+		break;
+	case SEV_RET_RESTORE_REQUIRED:
+		/*
+		 * Firmware requested a roll-back. Declare the PSP dead so
+		 * nothing else tries to use it, and let the next upload through
+		 * so the admin can restore the previous image.
+		 */
+		sev->fwl_rollback_required = true;
+		psp_dead = true;
+		fwl_ret = FW_UPLOAD_ERR_RW_ERROR;
+		msg = "Live upgrade failed, please roll back";
+		break;
+	case SEV_RET_HWSEV_RET_UNSAFE:
+		/*
+		 * Following a return of HARDWARE_UNSAFE, operation of the SEV
+		 * firmware is indeterminate and the recommendation is to reboot
+		 * the platform. Declare the PSP dead so the driver stops
+		 * issuing commands to it while the reboot is pending.
+		 */
+		sev->fwl_rollback_required = false;
+		psp_dead = true;
+		fwl_ret = FW_UPLOAD_ERR_HW_ERROR;
+		msg = "SEV firmware no longer safe. Reboot recommended";
+		break;
+	case SEV_RET_NO_FW_CALL:
+		/* The command never reached the firmware. */
+		fwl_ret = FW_UPLOAD_ERR_BUSY;
+		msg = "Driver error";
+		break;
+	default:
+		fwl_ret = FW_UPLOAD_ERR_HW_ERROR;
+		msg = "Unknown SEV firmware error";
+		break;
+	}
+
+	dev_err_ratelimited(sev->dev, "DLFW_EX: %s (failed %d, error %#x)\n",
+			    msg, cmd_ret, psp_ret);
+
+	return fwl_ret;
+}
+
+static int sev_fw_upload_shutdown_platform(struct sev_device *sev)
+{
+	int rc, error = SEV_RET_NO_FW_CALL, sev_plat_state;
+
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	rc = sev_get_platform_state(&sev_plat_state, &error);
+	if (rc) {
+		dev_err_ratelimited(sev->dev, "SEV get platform state failed %d, error %#x\n",
+				    rc, error);
+		return rc;
+	}
+
+	switch (sev_plat_state) {
+	case SEV_STATE_UNINIT:
+		break;
+	case SEV_STATE_WORKING:
+		/* Legacy guests are running, the update cannot proceed. */
+		return -EBUSY;
+	case SEV_STATE_INIT:
+		rc = __sev_platform_shutdown_locked(&error);
+		if (rc) {
+			dev_err_ratelimited(sev->dev, "SEV platform shutdown failed %d, error %#x\n",
+					    rc, error);
+			return rc;
+		}
+
+		sev->fwl_reinit_required = true;
+		break;
+	default:
+		dev_err_ratelimited(sev->dev, "Unknown SEV firmware state %d\n", sev_plat_state);
+		return -EINVAL;
+	}
+
+	/*
+	 * After DLFW_EX, INIT under the new image can fail with
+	 * SEV_RET_INVALID_PAGE_STATE if it is handed the TMR or INIT_EX NV
+	 * buffer that the previous image left in the firmware state.
+	 *
+	 * Reclaim and free them rather than keeping them for reuse. The
+	 * re-init allocates new buffers and moves them into the firmware
+	 * state itself, and a skipped or failed re-init leaves no stale
+	 * buffers behind for a later INIT or teardown to trip over. If the
+	 * new 2M TMR allocation fails, INIT is issued without SEV-ES and
+	 * only a warning is logged.
+	 */
+	__sev_release_firmware_buffers(false);
+
+	return 0;
+}
+
+static void sev_fw_upload_reinit_platform(struct sev_device *sev)
+{
+	int rc, error = SEV_RET_NO_FW_CALL;
+
+	lockdep_assert_held(&sev_cmd_mutex);
+
+	if (!sev->fwl_reinit_required)
+		return;
+
+	rc = __sev_platform_init_locked(&error);
+	if (rc) {
+		dev_err_ratelimited(sev->dev, "SEV platform re-init failed %d, error %#x\n",
+				    rc, error);
+		return;
+	}
+
+	sev->fwl_reinit_required = false;
+}
+
+static enum fw_upload_err sev_fw_upload_update(struct sev_device *sev,
+					       const u8 *data, u32 size,
+					       u32 *written)
+{
+	int cmd_ret, psp_ret = SEV_RET_NO_FW_CALL;
+	enum fw_upload_err fwl_ret;
+
+	guard(mutex)(&sev_cmd_mutex);
+
+	/*
+	 * SEV firmware will only successfully execute the DLFW_EX command if a
+	 * firmware rollback is required. Other commands may be processed, but
+	 * may not execute properly. Use the psp_dead boolean to restrict
+	 * execution to this path.
+	 */
+	if (psp_dead && !sev->fwl_rollback_required) {
+		dev_err_ratelimited(sev->dev, "DLFW_EX: PSP is not responding\n");
+		return FW_UPLOAD_ERR_HW_ERROR;
+	}
+
+	/*
+	 * If the last firmware update returned RESTORE_REQUIRED, retry DLFW_EX.
+	 * Being in this state means that the legacy firmware has previously
+	 * been shut down, so no need to do it again.
+	 */
+	if (sev->fwl_rollback_required) {
+		psp_dead = false;
+	} else {
+		cmd_ret = sev_fw_upload_shutdown_platform(sev);
+		if (cmd_ret)
+			return psp_dead ? FW_UPLOAD_ERR_HW_ERROR : FW_UPLOAD_ERR_BUSY;
+	}
+
+	cmd_ret = sev_download_firmware_ex(data, size, &psp_ret);
+	fwl_ret = sev_fw_upload_handle_err(sev, cmd_ret, psp_ret);
+	if (fwl_ret == FW_UPLOAD_ERR_NONE) {
+		*written = size;
+		sev->fwl_rollback_required = false;
+	}
+
+	/*
+	 * Firmware either just requested a rollback or a rollback attempt
+	 * failed. Keep the PSP dead for all other commands, only another
+	 * DLFW_EX attempt is allowed through.
+	 */
+	if (sev->fwl_rollback_required) {
+		psp_dead = true;
+		if (fwl_ret != FW_UPLOAD_ERR_HW_ERROR)
+			fwl_ret = FW_UPLOAD_ERR_RW_ERROR;
+	}
+
+	if (!sev->fwl_rollback_required && !psp_dead)
+		sev_fw_upload_reinit_platform(sev);
+
+	return fwl_ret;
+}
+
 static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
 					      const u8 *data, u32 offset,
 					      u32 size, u32 *written)
 {
-	return FW_UPLOAD_ERR_BUSY;
+	struct sev_device *sev = fw_upload->dd_handle;
+	u8 old_major, old_minor, old_build;
+	enum fw_upload_err fwl_ret;
+
+	old_major = sev->api_major;
+	old_minor = sev->api_minor;
+	old_build = sev->build;
+
+	fwl_ret = sev_fw_upload_update(sev, data, size, written);
+	if (fwl_ret != FW_UPLOAD_ERR_NONE)
+		return fwl_ret;
+
+	if (sev_get_api_version()) {
+		dev_warn_ratelimited(sev->dev,
+				     "SNP platform data refresh after firmware update failed\n");
+		return psp_dead ? FW_UPLOAD_ERR_HW_ERROR : FW_UPLOAD_ERR_NONE;
+	}
+
+	if (sev->api_major != old_major || sev->api_minor != old_minor || sev->build != old_build) {
+		dev_info_ratelimited(sev->dev, "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
+				     old_major, old_minor, old_build,
+				     sev->api_major, sev->api_minor, sev->build);
+	} else {
+		dev_info_ratelimited(sev->dev, "SEV firmware version unchanged: %d.%d.%d\n",
+				     sev->api_major, sev->api_minor, sev->build);
+	}
+
+	return fwl_ret;
 }
 
 static enum fw_upload_err sev_fw_upload_poll_complete(struct fw_upload *fw_upload)
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index 7ec692e2147e..1e45a08c41da 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -71,6 +71,8 @@ struct sev_device {
 	struct sev_tio_status *tio_status;
 
 	struct fw_upload *fwl;
+	bool fwl_rollback_required;
+	bool fwl_reinit_required;
 };
 
 int sev_dev_init(struct psp_device *psp);
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index fab62228f981..b71154e9ae4b 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -890,6 +890,25 @@ struct sev_platform_init_args {
 	unsigned int max_snp_asid;
 };
 
+/**
+ * struct sev_data_download_firmware_ex - SNP_DOWNLOAD_FIRMWARE_EX structure
+ *
+ * @len: length of the command buffer read by the PSP
+ * @rsvd0: reserved
+ * @fw_paddr: system physical address of the start of the firmware blob
+ * @fw_len: length of the firmware blob
+ * @commit: whether to immediately commit the firmware update
+ * @rsvd1: reserved
+ */
+struct sev_data_download_firmware_ex {
+	u32 len;			/* In */
+	u32 rsvd0;
+	u64 fw_paddr;			/* In */
+	u32 fw_len;			/* In */
+	u32 commit:1;			/* In */
+	u32 rsvd1:31;
+} __packed;
+
 /**
  * struct sev_data_snp_commit - SNP_COMMIT structure
  *
-- 
2.43.0

