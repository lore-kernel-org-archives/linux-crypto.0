Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012042.outbound.protection.outlook.com [52.101.43.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465B34CE690;
	Mon,  5 Oct 2026 16:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791217051; cv=fail; b=QZv4l9rRQugwrIGfKfvr8IGWXt6+gFdHNxUYSqwra48HPuK/Dvnn1koN4YyvEDvhIZKBr7XVtnUPtaVAClWPqX9BBW6HdWuKbDr3tDQ6XjN1OEOD0F+3q7n8ezLoUk0+fm/R8VcDivxMA1F5WCi+sZ05IreF+ruff2lpGkmSBps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791217051; c=relaxed/simple;
	bh=3DvBn1CFwOlHXvzSAU6dqEm5ThYxwm2fZzxU6XivDSQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rlHa4zpknyFdBFmjAP4/Qa2HF4/3QCOKPXOXxyRuPfE0G20GLQ2AZOibb6eKp+TpcpIlE2CPc9toR1vjVEU2e9fEg3mZGgzNZcskFNS1Sm6MrTGNDopw9lltPEIXWPhVRTkk4ygVAmy2zhmka/iecfL1H+jeTr4uRnMC1oXYv8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pK2CJjYS; arc=fail smtp.client-ip=52.101.43.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pK2CJjYS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sup1iRhFUAD/ZLjLbnTBfQuG7ALX/X0nsHs1HaYM6yfI4pgjuqByFqgYjdnb4asSFbvQv1gGilBcNEXN+pqIVehK55Qk5iUX6qsVIs8ijSizKg7JJSgI5gbYI36+6yw0YOaKFZU9owdzjb3SzYvXKReyoLYLuS1+N5tH6Ea3keDkYt3oEgGhthLhfTQrXvxq1uHPv7XPybueyQ7APwmn5Ee03D3QtUO95m5+WOqVErCBkJBggw6UnWIIxZjBLCRquAhtzabmyA/74zWpSGPnpEo5KVxkvn0+MG/jAcpnt5rg1I84iZpzIeR3Vmjdlq5ps9DjoQav2vWmkvE3b3HN3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NBxgUUPwOEaualOUm2EfEscZdWJOvPpPsRMeqAAGKA=;
 b=hHlZToNWNTR6ALFbWHDPZ/GGRJSXmOlhb1tBO3bXkXXEnxfeWyP+vZrX2zYBjlJhL5+bOhEQV+x12tJeOQspHCw1nvjShrQH46esXcVAyaK9GSZTwc8NfAE+KRLfeov75lN/t/eqSfHCMVcZHIvfeoAXpEp0X8Bp7sl4WERK+QUYPepfrCCH06WLWwXCtYgQgTWC6bOuK8eW/Caw33ye9sbOvXYP3JeMu/QxJ4kyQPErzhuoZoIveMoEn5yi7pjD3jhG05WP3Q0TnZXnd6+L0LGTzeLCMhu9Xzz0GOsyH8bF8iFSnpODvLuzT4+Wirdh1hhfdJ8p1AEcv6R9kkeHeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NBxgUUPwOEaualOUm2EfEscZdWJOvPpPsRMeqAAGKA=;
 b=pK2CJjYSYOa+/qfNW0Ys75c4mLVBf06+EqrMnnuHOBnfxp8ZCl741GYvtJ//z2O9a4evg/IsUbfccL8lG56csGK3HOCZJq8sGE8nHDngVBhWOqCLdeBkDv8Lk/JAqCI0PYdDLfm36YQnkAZeM+wSQESdUTpzU5lkHzDg63XycD0=
Received: from BN9PR03CA0662.namprd03.prod.outlook.com (2603:10b6:408:10e::7)
 by DS4PR12MB9682.namprd12.prod.outlook.com (2603:10b6:8:27f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Mon, 5 Oct
 2026 16:17:20 +0000
Received: from BN2PEPF00004FBB.namprd04.prod.outlook.com
 (2603:10b6:408:10e:cafe::66) by BN9PR03CA0662.outlook.office365.com
 (2603:10b6:408:10e::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 16:17:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBB.mail.protection.outlook.com (10.167.243.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.14 via Frontend Transport; Mon, 5 Oct 2026 16:17:20 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 11:17:18 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v3 7/7] crypto/ccp: Implement SNP Download Firmware EX
Date: Mon, 5 Oct 2026 16:15:41 +0000
Message-ID: <c03c5a47f3972486fdb144bf8c6f50ab3375da2f.1791212077.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791212077.git.prsampat@amd.com>
References: <cover.1791212077.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBB:EE_|DS4PR12MB9682:EE_
X-MS-Office365-Filtering-Correlation-Id: 54cbcbc8-a0b2-4e41-31dc-08df22fc21c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|7416014|82310400026|376014|23010399003|56012099006|11063799006|5023799004|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	BWrJgtpm65DoZCDxpyF3fL2bO/o4ks72nx62YXBl8mWseYuX+IbVxkWABnq0gvZ1WoyqTGdcLYrD9AMeow0QeGGTosDaSRGpvHnenmqL43a3tt4GLi+4f9G2KrcvbPtjG4AaTx+HNhwuQ/A35E4yn+zcPR9zvgMBfcKchTA5/4YtT3Kdg9RLbo2cvgHISoycN2uEwoKyGFl2cNiCjgm+RNC8W7P8u+JyV9gHlYmO/rC41XtKIM7afULb2abn22uRY2uhlm1+vzgi+RXHYZUgz7uYUmOiXqXw4dKB9k0x0wVEabW0LvAevbGvQBhy9vhSX5pLWYhBKVBeU0ES++ZaoMR3RWnHjG3/LinQTbL9kBLacRkA0Q6mfnHgpjPtJrg8VI/gTRfC4WA8AyYdI8Qr44kl+KqrvbPUAYZdG4HUhAaxDemXlL71Pz9jFHPXBO7D/Zp/uuhF+qatQ2MyVg3TGx/X7DaAHYaHWp1AP27Mw9U2w4WIvSDk6bZqRSHLdEvHcl1rIC6Gvg2vPz4TC1iKgZcMCmyw7BWyrIzYvEo50GpEAu7l3hEmCaTsWND8udHyLdciUpI+ztC4uneGW8tVgchEfZDdoN63ElEPh2WX56jf70dWDi7+7n+3e2aEcf5kBNhPHYgGUHvnh9k5btqHYpzeXxvYwObhwrazQia4u1vd5XeZ1ItkFZpZLB/mRcfyOjpVOiKMJ+HtlQaJmYuSAg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(7416014)(82310400026)(376014)(23010399003)(56012099006)(11063799006)(5023799004)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mkgXH2kop8Loc2WePKziwt9hYYt/r/8kaDYYdBm/29QCvOojjMEKDLIZ/TYO9AotPen06kGjPrZbExkDEzpYP9DHSWCn/pvoshTJtkCczJ/uBM40RefHUBN4zcaX0J2jBrjcnLbCQo0pNNtRTIS/5GqPYadvJsDXLJ8BooQO60iOa0IizqqSAoZhpmwh7bpqJlCUBwGS3HvGzS7HkgqBN2EI9omN6HtOCWh9MBTzWE3Jl31zGrlkglHMXCjPtjhMDmokPq8eTTxBPwyHUJXSrOEJa6Qdq/MvjNksDFaQvK2La0Kpj0FeCayzLn7Za3bukrLF6VSIJWZY2poqgbmhQE/QPoLIPaipWE5nIS8CwxEIsBOw4WcTgjS4kS5pYQHqfhccUgZ5auxT50IDJU3Nt2BcXVxuabDLJd/QLdmsJZM0NUxdxEmvOFeVl5qk8NbN
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 16:17:20.3028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cbcbc8-a0b2-4e41-31dc-08df22fc21c3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9682

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
 drivers/crypto/ccp/sev-dev.c | 284 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  19 +++
 3 files changed, 304 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 88cf60a9640e..e54f23ba1b9b 100644
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
@@ -2213,17 +2215,297 @@ static int sev_update_firmware(struct device *dev)
 }
 
 #ifdef CONFIG_FW_UPLOAD
+/* Largest image the firmware accepts, anything above is rejected */
+#define SEV_FW_IMAGE_MAX_SIZE	SZ_512K
+
 static enum fw_upload_err sev_fw_upload_prepare(struct fw_upload *fw_upload,
 						const u8 *data, u32 size)
 {
+	struct sev_device *sev = fw_upload->dd_handle;
+
+	if (size > SEV_FW_IMAGE_MAX_SIZE) {
+		dev_err(sev->dev, "DLFW_EX: image of %u bytes exceeds the %u byte maximum\n",
+			size, SEV_FW_IMAGE_MAX_SIZE);
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
+	 * Don't commit to the new firmware immediately, perform an explicit
+	 * SNP_COMMIT after
+	 */
+	sev_data.commit = 0;
+
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX, &sev_data,
+				  psp_ret);
+
+	__free_pages(p, order);
+
+	return ret;
+}
+
+static enum fw_upload_err sev_fw_upload_handle_err(struct sev_device *sev,
+						   int rc, int psp_ret)
+{
+	enum fw_upload_err ret = FW_UPLOAD_ERR_FW_INVALID;
+	const char *msg;
+
+	if (!rc)
+		return FW_UPLOAD_ERR_NONE;
+
+	/*
+	 * The command timed out: psp_ret was cleared and the PSP was declared
+	 * dead, so there is no firmware status to decode.
+	 */
+	if (psp_dead) {
+		dev_err(sev->dev, "DLFW_EX: PSP not responding (failed %d, error %#x)\n",
+			rc, psp_ret);
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
+		ret = FW_UPLOAD_ERR_INVALID_SIZE;
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
+		ret = FW_UPLOAD_ERR_BUSY;
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
+		ret = FW_UPLOAD_ERR_RW_ERROR;
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
+		ret = FW_UPLOAD_ERR_HW_ERROR;
+		msg = "SEV firmware no longer safe. Reboot recommended";
+		break;
+	case SEV_RET_NO_FW_CALL:
+		/* The command never reached the firmware. */
+		ret = FW_UPLOAD_ERR_BUSY;
+		msg = "Driver error";
+		break;
+	default:
+		ret = FW_UPLOAD_ERR_HW_ERROR;
+		msg = "Unknown SEV firmware error";
+		break;
+	}
+
+	dev_err(sev->dev, "DLFW_EX: %s (failed %d, error %#x)\n", msg, rc, psp_ret);
+
+	return ret;
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
+		dev_err(sev->dev, "SEV get platform state failed %d, error %#x\n",
+			rc, error);
+		return rc;
+	}
+
+	switch (sev_plat_state) {
+	case SEV_STATE_UNINIT:
+		return 0;
+	case SEV_STATE_WORKING:
+		/* Legacy guests are running, the update cannot proceed. */
+		return -EBUSY;
+	case SEV_STATE_INIT:
+		break;
+	default:
+		dev_err(sev->dev, "Unknown SEV firmware state %d\n", sev_plat_state);
+		return -EINVAL;
+	}
+
+	rc = __sev_platform_shutdown_locked(&error);
+	if (rc) {
+		dev_err(sev->dev, "SEV platform shutdown failed %d, error %#x\n",
+			rc, error);
+		return rc;
+	}
+
+	__sev_release_firmware_buffers(false);
+
+	sev->fwl_reinit_required = true;
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
+		dev_err(sev->dev, "SEV platform re-init failed %d, error %#x\n",
+			rc, error);
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
+	int rc, error = SEV_RET_NO_FW_CALL;
+	enum fw_upload_err ret;
+
+	guard(mutex)(&sev_cmd_mutex);
+
+	/*
+	 * A PSP declared dead only executes DOWNLOAD_FIRMWARE_EX if it was the
+	 * firmware update that killed it and asked for a rollback. Declared
+	 * dead for any other reason it will not answer until the platform is
+	 * rebooted.
+	 */
+	if (psp_dead && !sev->fwl_rollback_required) {
+		dev_err(sev->dev, "DLFW_EX: PSP is not responding\n");
+		return FW_UPLOAD_ERR_HW_ERROR;
+	}
+
+	/*
+	 * If the last firmware update returned RESTORE_REQUIRED, retry DLFW_EX.
+	 * We being in this state means that the legacy firmware has previously
+	 * been shut down, so no need to do it again.
+	 */
+	if (sev->fwl_rollback_required) {
+		psp_dead = false;
+	} else {
+		rc = sev_fw_upload_shutdown_platform(sev);
+		if (rc) {
+			return psp_dead ? FW_UPLOAD_ERR_HW_ERROR
+					: FW_UPLOAD_ERR_BUSY;
+		}
+	}
+
+	rc = sev_download_firmware_ex(data, size, &error);
+	ret = sev_fw_upload_handle_err(sev, rc, error);
+	if (ret == FW_UPLOAD_ERR_NONE) {
+		*written = size;
+		sev->fwl_rollback_required = false;
+	}
+
+	/* A rollback retry failed. PSP now stays dead */
+	if (sev->fwl_rollback_required) {
+		psp_dead = true;
+		if (ret != FW_UPLOAD_ERR_HW_ERROR)
+			ret = FW_UPLOAD_ERR_RW_ERROR;
+	}
+
+	if (!sev->fwl_rollback_required && !psp_dead)
+		sev_fw_upload_reinit_platform(sev);
+
+	return ret;
+}
+
 static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
 					      const u8 *data, u32 offset,
 					      u32 size, u32 *written)
 {
-	return FW_UPLOAD_ERR_BUSY;
+	struct sev_device *sev = fw_upload->dd_handle;
+	u8 old_major, old_minor, old_build;
+	enum fw_upload_err ret;
+
+	old_major = sev->api_major;
+	old_minor = sev->api_minor;
+	old_build = sev->build;
+
+	ret = sev_fw_upload_update(sev, data, size, written);
+	if (ret != FW_UPLOAD_ERR_NONE)
+		return ret;
+
+	if (sev_get_api_version()) {
+		dev_err(sev->dev, "SNP platform data refresh after firmware update failed\n");
+		return FW_UPLOAD_ERR_HW_ERROR;
+	}
+
+	if (sev->api_major != old_major || sev->api_minor != old_minor ||
+	    sev->build != old_build) {
+		dev_info(sev->dev, "SEV firmware updated to %d.%d build %d\n",
+			 sev->api_major, sev->api_minor, sev->build);
+	} else {
+		dev_info(sev->dev, "SEV firmware version unchanged: %d.%d build %d\n",
+			 sev->api_major, sev->api_minor, sev->build);
+	}
+
+	return ret;
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

