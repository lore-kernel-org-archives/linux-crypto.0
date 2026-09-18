Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010070.outbound.protection.outlook.com [52.101.193.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A5251AFDF;
	Fri, 18 Sep 2026 16:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789749780; cv=fail; b=qBKqVRm8+4W467OoHqFCBYdVUaO5sN8VJi05491kRlhaXFrl+19c+sxUPFoogQ6w7esbR1mWq2uMi3pSyl0m75Rh4UuTvF/p5noCZvOCW1ZsJvWQu6057Bq/H3JFbhPC9dxs6Zk48u5WXK5K1In4D1O5cDvaFDFNfAP7i36yk3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789749780; c=relaxed/simple;
	bh=b979a89YSlxWiaPAM4xbD7lN0HBPD66Cy1iX6OqKKcU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q3jXTWZ3kyeaGG6Kjz5F2Tfm4Slc4sg3oT4FQhr/kVeI+is8+OxBbFnfBIzBC9SCktKhvEVRb7g6NI+9AMJmuEZRaE8/02uKQqKb9MwbVU25z3guj09H+mKmlAcT8/giPHKtmf41mBjyVrTecOQqsbtRbiyljU4ILMCAEmkhFsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qjiblG4y; arc=fail smtp.client-ip=52.101.193.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qjiblG4y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xOUx01i7/AU6lgg7AIf75WKmsoLpQu6VY5ILZl0EWvoOcPlyS6dYDZykD5IRk0Gtbvuq8Cw+aFxaadvf4qrjdaOmOs/eBOwxM8MUVDLdRFTGLw/kRUnEgLunMMCTdGlGyKs5UwF95ehpDewBRCagyI6vMs/Bu38PjRyvE8PXgezRwsMtBP1PEF1xftK02pq1Cfi6k0gla/aIRyKjo/s9smOU6KEvKycyn7a81QidFk3JEfi4yepKShIWVTTn+yfQqLLnOiyqAjxo6qGi50EPTLvqD0s2RHSCM3mDkvaRnMOSwoptbwarhJkbwL0RlFU5Lsu8f8s/bWCKY26Sl+gjjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ohUejXLfOeaI32tOXg/M+rrQmOFxbyBMoxvkIvUaDvQ=;
 b=ikCZVduWFhgjYilSSt2I/PwzYomKEHVsF70fw29Gkf+VbO9UfxTzb6APxP7B5FtoGVE8/fFme4lBrhQl5uJudH0U8W8fh1FRbrO4jD4uNHp2m2iFm+szvXuNCrufFuHSO/TD4T9Ksq0BVHbrQPD3VsaNyHd8yb5ULa9ie7suo9SoPRvRGLoUOWZkQdeuArdjCqy/PwFbUYgJC8WyND/nqGdKi/op7j+azb0RoppRYCHnLT6KaXvbqLV93yInIVQGxXHG8U/YFlhQ4q9+WiKfzm4vrYiLsus8Z9PqQHLKkCWPnHU5p10QQLjHU+oPjUrgq82DzMSnx0GLW0kSvEKdIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohUejXLfOeaI32tOXg/M+rrQmOFxbyBMoxvkIvUaDvQ=;
 b=qjiblG4ygNcSGB6HRFCoy9vbFEWazBna6Qa2v5fpt5g00+g4+P3DznDOis4iRsPII/eEXvIZKT66AZUG/kMVCHA+fmg2H4ep7RJnhYjOqjSMNWILYzuVHecDv0gWnY5P2d+YDjfko5rO5puPQZ3AgacrUxl3MYtQ/iLEokk8c8g=
Received: from CPYP284CA0044.BRAP284.PROD.OUTLOOK.COM (2603:10d6:103:81::13)
 by DS5PPF1ADAD2878.namprd12.prod.outlook.com (2603:10b6:f:fc00::646) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Fri, 18 Sep
 2026 16:42:40 +0000
Received: from SJ1PEPF00001CE1.namprd05.prod.outlook.com
 (2603:10d6:103:81:cafe::8a) by CPYP284CA0044.outlook.office365.com
 (2603:10d6:103:81::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 16:42:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE1.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 16:42:36 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Fri, 18 Sep
 2026 11:42:34 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v2 7/7] crypto/ccp: Implement SNP Download Firmware EX
Date: Fri, 18 Sep 2026 16:41:01 +0000
Message-ID: <3463e8ce7b925d8cade35cf9d98b96bc3fc619b4.1789749016.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789749016.git.prsampat@amd.com>
References: <cover.1789749016.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE1:EE_|DS5PPF1ADAD2878:EE_
X-MS-Office365-Filtering-Correlation-Id: 31084fdb-2b1e-45c1-5c5f-08df15a3d83c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|82310400026|1800799024|10067099003|3023799007|56012099006|5023799004|6133799003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mz2IuHw9ncYTjqQpeBOTUrTS39Mavp4nYTCwOdcWJdrzyd8uqtS/vcT0UAbPCPyWCnJrWLy37HZ17XB9oqFii0RssfcTml1TyM2uD6tkP3G+02VRzXHSFR8SJREjjpVpeWKr2GbsIBvFyFYj1PXPHjDIGzVOGmFl9V40dSZBPhuf+DZ74siOob55u9Q6HQBdgTT8m2ps+Z9lqiPdV0fcTSJHGXZGZuWRvJiHIo/PLMQidGCw8PBUPCbDckBhkQcqCtvo1r7uD0Ve6B+IFGCybb4oC9Bj4H4Mm8cF2vsyhtqnfAlpsGhnJMIX9KSk/+ytEOETykiU1RVAW7qA2hVrI8HKTIMCtdL0sLX4qduSzUs9AwSO2gmZ/XfWaG6wtnhfAtguVOlpDUBEMAsujxaAuxuZYkKuosRtM6KyBIIp8KcEy8f2r5uOuRWkZAJX/JIcEtOPLwFs3J0ICv9MUwYbAUIcUzoEuXNLTw1nf/6qvXsIzisNzClDwggtAE5o/U2k/3TgX6oB4S76RREIs6PqRPOl9Q6julgzT8JXeS0K+VSN9um6yi9Pkmry+Ao1AcMm80yWsm43lcxkc8DvHpvhh2Fsv5iyfxwnVNsYqAukgCbf8J+ReS46XiPQU8BzSlRZGls2bjlHcOx5OHC0BUHhqLqt4xtXC202/JOjRxUfuubIeTWWjPjvzsBhn0IkQu30VIrb1rfIEsdFzyBPjy56wA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(82310400026)(1800799024)(10067099003)(3023799007)(56012099006)(5023799004)(6133799003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Z91Axbhm9yB/5kxNLQNLSlgcInHTv9IVLfLHykT+NOoCeaZvHdUOQSobhMdR7lfsZUhXg4xEFzvfHkMKEprg6lsU1Qtkv3IwMEfR3IU+RXs5al/e6UVIisgxBgR3LuaamogJ+EYuJ3Bi8utEZYZB59R2utMtEhVPdQ92DVaKIoL/E9fHIqFeFkR2MjKWOeheJRlwscaAIOS86n1C8GabdZ1T/csm/vmt+PWY2DQU28sXt7Dfy9lz14aHFEFVep3YMt/MCWzS3sunwt4sLfSN9u0mBrTaL95RktVst5lYXplTjbGBSWCDVhp7xzOkKfUMJaVRKbEhFnpepSFVm8xyjP3WwTOb2ENmHNAj+7ie3XvsbOeKCg96GJ8ms7DnhTcyCM/p3tocRlSLyRecifNkSmAoGcKGZsSX4UCXBkcX1gCXJd5CJMYfpLpTWFA5c3EF
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 16:42:36.0308
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31084fdb-2b1e-45c1-5c5f-08df15a3d83c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF1ADAD2878

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
index f3714e8f5ab1..aee708be7cab 100644
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
@@ -2209,17 +2211,274 @@ static int sev_update_firmware(struct device *dev)
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
@@ -2243,6 +2502,13 @@ static void register_sev_fw_uploader(struct sev_device *sev)
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

