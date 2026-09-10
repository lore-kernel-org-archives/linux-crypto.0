Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011011.outbound.protection.outlook.com [52.101.57.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA89560ADE;
	Thu, 10 Sep 2026 17:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789059832; cv=fail; b=VUViGAYoo44ZU4WSlVEp/k/n6BwQIdXKWo7yYtyPxiDooJwtDSCFBIsm+UkcvIWZvTiZPy4yupY//OGUfi1kxnCjC78rUaLdV8u1OEBxK496rHeneRlBaWqM4lQ3qLYQeeiPZekvghfvB3qamJfUxTghrrtNfX3RV3KqjkHU6+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789059832; c=relaxed/simple;
	bh=nuNX4uyRf0WOPxUFYKSKKuW6NEtLxf/WmNgJJK/yClo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=elQJHtu5PX4ZSK/hRQJgQ62S00T3TwUDT2uM1gm5cjI9y3p8VPqWWLWgT7oIm3DCVDAa4V3/ea0gw5PAtEBqBDPJgHsxy4fDgjOK1x9J8Sy1j0MOb+G6IbNwroS2WIyXIthg5w2CMVD8rcKgqjJ8b2Q285TKY+Sr4AWkaYqsSTE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iSu9E6Vv; arc=fail smtp.client-ip=52.101.57.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iSu9E6Vv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g35UP5R6A+N4J9UBIA76+MY12tZ/ejIPlnReb/oFpDsbLYZrSyEjavPoeRcbaTPj3a2aepfV/jwqKsCA5nbzI6DW+lKhxjI6w2hmdyGsW5D6VCJzbXSkugMN0qfexv7nFTjU6typ4VqTO1OV3kSFjWEam7GXQpxBisFv+0KqoRLLSP66Y53GciJQj3fNS7s64kwtAk6rqLyFYyzNSm+6l33QUfqPleA3Cx3vvu/Z989K1c26Jjn4ElaJGdKNS3FbZVpleqn6udCHj/tRHiWyps/PKAVQX/av9D7SEPY9yMHC6wBHCj2co7bOsuEM4miMCotflwW+ohNQfK/165rUYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+r+dUcjoZTsQ81+IVkdCURWGFkllQ7YllzezRtONcM=;
 b=l26efQ2quxVBQ5+mkHU+edBOoRuLXaE3eptzW+2rgcjolVtZAkDthsPtFrEpmurS+ZaiGFNyuWYzOIJRIzTnkfyG5jIMu1RB7/XJzwoItSuosnDFtM+fmKpWXEAB62IGh1k6bpdVQ5Wc0i7pEZhiXvjwfduE1nryFZIR4kx/QeE1jaj/Mzvgv/CyPz5ErLzCv/mXbbBVVGeY/6ytIfxq8ItQfiHvE5DOP2utkcaZKrjdvVLU31o8avSHUo9vHOV8lU/hjstxoBdSb34DEJ8aywAiYTIEJq+vqV0DGH+PwsdY5ykQWlTRJbZvW3YB3A+BUH7aCNC1eRa9SP/P/33nHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+r+dUcjoZTsQ81+IVkdCURWGFkllQ7YllzezRtONcM=;
 b=iSu9E6VvVOYZwdhB9HFFIz/+OW413ADxP9zfCbM9OEKIjTcwZp50obCbjVKD1VszAB4PchUBK6X6CpDZo22ZtzBan692+glu9/wYiLM8OdR3KVP0hu8PN5r8YB93q94glZ5xwhXA4kXGB0eKVo5b1k/iR9IysnMqtWiwERZS36U=
Received: from PH0P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::13)
 by PH0PR12MB999112.namprd12.prod.outlook.com (2603:10b6:510:38c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 17:03:32 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:510:d3:cafe::6c) by PH0P220CA0009.outlook.office365.com
 (2603:10b6:510:d3::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:03:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:03:31 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 10 Sep
 2026 12:03:31 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [PATCH 7/7] crypto/ccp: Implement SNP Download Firmware EX
Date: Thu, 10 Sep 2026 17:02:02 +0000
Message-ID: <7754d36b3e1123dca15b6abf526b752f28cf1446.1789059392.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789059391.git.prsampat@amd.com>
References: <cover.1789059391.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|PH0PR12MB999112:EE_
X-MS-Office365-Filtering-Correlation-Id: a26dfbb0-cc0e-4b0b-d61f-08df0f5d7164
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|1800799024|23010399003|10067099003|6133799003|3023799007|22082099003|18002099003|56012099006|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	3GmLjGCmuucrZLNJ4+Af+SMPMMgq2Eq5dYxoB6LTKeIktSzwW7tGcQhqzhQ2DwTidu9w8JnRojU1NZxx+8K5+OnA4KY7dp4wx1PIRulzjRKeVCH5tFIrOHqRkSZOfeUGhULU/XMBrBc0s+mi4WbaN3PlwiM2191iavFnuXqHluWvcTC4ViEsCCgwIfiKsmYw4dO5MToxGc0A3Q0CEHrlxyjSomFkdF8UfIKIlUbXEH6FzrXYq+G+uazzU2zTyTA6rV58td7R3f9Dm2X79miLGG4JtcJPLwMD3Xyk+jxBmpbhcWtDgyEjrfY2pur4954pMpHDlyn5BzlhB4uIeM/MaxPfGZIIcpz2GmMkDo5FGU5MHylxcobe9gFCKRrftQ64Z4Ii+HNrWi9hSHh3Pa80iN/Nt0FmD8Pi3UGrS3Wy5t2Diotl7BJ/sFtgdV6w5p4A9TVI7rb2Fx3nbPjGPE6Vpji95TCrCcVXWDyNshlizigXZqtCdIUCmqXhUqw7EXg6NM6D49Rs3sf4WbjqiWlKsqqsvnnUBmuASRHIjdGU4rS12K9XBFWiZw2+GDuChlLMh9x4Z/uCk316XxAuweTqkokuLbwejMHFFUHMdbLgc2Mum0n9tqJfsNspsgJy5GP5NCtXQl+fwru+JENrXvu+Vb0CSOfovK8AZhl3c/gGc6AYIkdI9t8Bo87plvW36sMsE3SYpwGdpKCZF8rztOtg+A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(6133799003)(3023799007)(22082099003)(18002099003)(56012099006)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7LL0r/rjg08dgFT/5mcj0As8/ASRaXiTnX6vZnVQlwGQuxQQOUZ2xCneQy3p0L+2N5Y3EhRUNnCWwlSUAJ2t+agQpoX9AIvYNfklX1YV5mGft5OufgCQUfajhHYHiQp5bmH+9A+FwUxRcVNAmZsFgApqCgYR25pQlYI5zTR+vRwAAEO/4ZBcp+go+NWpWYjXn7uCHk1h2u2w1Hrrt1X6Yp26E+ogMyIWDSu40N9zrUpgDKDrMpjY66e6D5IwZcrJz6v7+LSCjCaH1dpu7BxSZMiGRsp3+l5+04Lv2s1/g5Y8MEk3OnqiAt1vEJ94c4l7st0U7A3Sjy5dep7h4verNtTQBd6DA7OHFdBhLAdXKgHE4ow9lZRx/9amDRroIx2xYZGgGSQyMqARThYwujS2SbEU99/1nt6/9ZoZn1r9eta0bOSJPn4BOFOz4lx8go/F
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:03:31.7803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a26dfbb0-cc0e-4b0b-d61f-08df0f5d7164
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999112

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
 drivers/crypto/ccp/sev-dev.c | 268 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  19 +++
 3 files changed, 288 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 397a797d9312..c95b27275ac2 100644
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
@@ -2240,17 +2242,274 @@ static int sev_update_firmware(struct device *dev)
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
+
+	if (!rc)
+		return FW_UPLOAD_ERR_NONE;
+
+	switch (psp_ret) {
+	case SEV_RET_INVALID_PARAM:
+		dev_err(sev->dev, "DLFW_EX: Provided image is not well formed\n");
+		break;
+	case SEV_RET_INVALID_LEN:
+		ret = FW_UPLOAD_ERR_INVALID_SIZE;
+		dev_err(sev->dev, "DLFW_EX: Provided image has an unusable length\n");
+		break;
+	case SEV_RET_SHUTDOWN_REQUIRED:
+		dev_err(sev->dev, "DLFW_EX: Provided image cannot be live-updated, shutdown required\n");
+		break;
+	case SEV_RET_BAD_VERSION:
+		dev_err(sev->dev, "DLFW_EX: Provided image < committed version\n");
+		break;
+	case SEV_RET_INVALID_PLATFORM_STATE:
+		dev_err(sev->dev, "DLFW_EX: Platform not in UNINIT state\n");
+		break;
+	case SEV_RET_INVALID_ADDRESS:
+		dev_err(sev->dev, "DLFW_EX: Unaligned address provided\n");
+		break;
+	case SEV_RET_UNSUPPORTED:
+		dev_err(sev->dev, "DLFW_EX: feature not supported\n");
+		break;
+	case SEV_RET_INVALID_CONFIG:
+		dev_err(sev->dev, "DLFW_EX: Image rejected, unsupported configuration\n");
+		break;
+	case SEV_RET_BAD_SIGNATURE:
+		dev_err(sev->dev, "DLFW_EX: Bad firmware signature\n");
+		break;
+	case SEV_RET_UPDATE_FAILED:
+		ret = FW_UPLOAD_ERR_HW_ERROR;
+		dev_err(sev->dev, "DLFW_EX: Upgrade failed, automatically reverted\n");
+		break;
+	case SEV_RET_RESTORE_REQUIRED:
+		dev_err(sev->dev, "DLFW_EX: live upgrade failed, please roll back\n");
+		/*
+		 * Firmware requested a roll-back. Declare the PSP dead so
+		 * nothing else tries to use it, and let the next upload through
+		 * so the admin can restore the previous image.
+		 */
+		sev->fwl_rollback_required = true;
+		psp_dead = true;
+		ret = FW_UPLOAD_ERR_HW_ERROR;
+		break;
+	case SEV_RET_HWSEV_RET_UNSAFE:
+		dev_err(sev->dev, "DLFW_EX: SEV firmware no longer safe. Reboot recommended\n");
+		/*
+		 * Following a return of HARDWARE_UNSAFE, operation of the SEV
+		 * firmware is indeterminate and the recommendation is to reboot
+		 * the platform. Declare the PSP dead so the driver stops
+		 * issuing commands to it while the reboot is pending.
+		 */
+		psp_dead = true;
+		ret = FW_UPLOAD_ERR_HW_ERROR;
+		break;
+	case SEV_RET_NO_FW_CALL:
+		/* The command never reached the firmware. */
+		dev_err(sev->dev, "DLFW_EX: driver error %d\n", rc);
+		ret = FW_UPLOAD_ERR_HW_ERROR;
+		break;
+	default:
+		dev_err(sev->dev, "Unknown SEV firmware err 0x%x\n", psp_ret);
+		ret = FW_UPLOAD_ERR_HW_ERROR;
+		break;
+	}
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
+			return rc == -EBUSY ? FW_UPLOAD_ERR_BUSY
+					    : FW_UPLOAD_ERR_HW_ERROR;
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
+	/* A rollback retry failed. PSP now stays dead. */
+	if (sev->fwl_rollback_required)
+		psp_dead = true;
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
@@ -2274,6 +2533,13 @@ static void register_sev_fw_uploader(struct sev_device *sev)
 {
 	struct fw_upload *fwl;
 
+	/*
+	 * The interface only drives DOWNLOAD_FIRMWARE_EX, which is an SNP
+	 * command, so do not advertise it where SNP is unavailable.
+	 */
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+		return;
+
 	/*
 	 * SNP firmware update is a platform-wide operation; only the master
 	 * PSP issues firmware commands. Register a single global interface.
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
index 03a79786df1d..c6adbd46f05a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -856,6 +856,25 @@ struct sev_platform_init_args {
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

