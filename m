Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.63
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794593529;
	b=4b6mBBIIcYP90CmmfzDwE19z2+KfUMTwA4mbahOVduEvQn6ARE9s7emWBMEKUtxV+rb6
	 ThFN15g+p/lDvz/Cb1J6Pt5BT+kxZj0Cgbdml9yNVOSPcGU4/DNDycerL2r2Yuy6bvEpH
	 2dDsKsNZfz0UDyG6SftbemOOBmznnn9A/6zlDYfbrHH34Px+HEkmwuEjwEsK8GASt0ijU
	 WcPzh9uVuz4561rISCdtZbCrwHpBJK/r04YLGSo5cTSXKDeehIOrhODt0HtCD9CgVV9tj
	 Trclh5GVajrkizUNfekRkiy6bHsSQcJ2z3/EV/gCZXpT1wTSj9txdjADXF84EwO5j3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794593529;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
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
	bh=VYGObqRN7yVf7B2iFsJK3fHn0JDQSfu+2mKy8yTXjQM=;
	b=AO+ULXWtB/y/8C9WbHrxnlIGkLXdgwqu7MEat5giAdCenfJKT8F1DiCUChpsAZOblg4s
	 a4coaEIJ/1C1z+7w0QCleV8T8g79/Q6z0AOGq0joRLxmAeofBL/4fMD05MRmMofK+5q+j
	 RRXK6XEJUzQSBVChsjRZesBZDVYEWqQhnaKPMRNlAGWoRR/CQG/yBN8q7HXQRgNZcRY2Y
	 3cURiAl7Liq+Xnr1Kq2odKvtBqkXW15b+knu4mJ8YqlJ/qMd2AoLki+XwTSJ6mELwKiIT
	 vAC+6RvdANuweZZWgaCpjs9HPyEwdAeXHPstwCoD5SW79jMtaOBWDOCHWK3sH8aEnAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ytjMZIwI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.63
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011063.outbound.protection.outlook.com [40.93.194.63])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A53606A337;
	Fri, 13 Nov 2026 18:12:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2A53606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=ytjMZIwI
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CuF3za1Her2NUFUyWGYEs9XL3L+tRI+gOMCJR9d63rEuunQ6MQbMSs2PkSuQ7yHejeCVtPkwy6j1E3OZTfDe2x0c9m/pqBWKwQEZz9DQoRUSuofi4s5vVdWjoSPpsBn8JlCrlVRIlSkcI8LeA0NoLD3l1duqCbdrg7hrq3s9O526s05rX2hw1i/Rt4PSIEhTKrULnPQDnP+St35Cb6+zo8UUim7nyh/2kRUKQpdEjtVdHMFedZ6iI/80IJ25Wc9To76+BcBZK5lBocvWPUL8DowTqIfQg40GdJYfqSmO5bsudqtGfriZW4xcJBedgdLq+o7VNfkobUAt6wDn1f94OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYGObqRN7yVf7B2iFsJK3fHn0JDQSfu+2mKy8yTXjQM=;
 b=GmA+G239QGYl3JCruUHViUp05jXUZQr6+9EX22a6mga0Eizp3I2P1YeEc0dsnZuho+DT6r+g+7fqJ4gYFKe+GKe8s6q2l1ltxBBbwbDzJBxc+FOvovFl01MouDaNjoLvL3T2HHqcgSQhVQr0UsSHPAB5ZRD70HH8anuFXtgz2yAgVAV8Pzir3arm/so1pbtNlp6iMMrLlMRxFONDdo/xrIjpTNDqcMBzulcXZNl4ucwo2DMjgC2HvauwwAYqO7W6kuuwU4MtkxeBH7MSCDTTTiAmzavfllWl4RQUWivC6GWWaivql8BBP9RNZsgALtihomi1UxvBsUeLpZX/7qVEZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYGObqRN7yVf7B2iFsJK3fHn0JDQSfu+2mKy8yTXjQM=;
 b=ytjMZIwIYnRy94ZQgIma+/buMQO3NKLmOljFmt0kZfkAJa1d4rmDESHZKjZk/uHTWevDcAR3LLdnGDy/UAFQQjzDwAIdYqKD9/gMxQ/lb9esMBj9Z6hNDJGZgMcANKr7okle4JrZT3IG7oLY8TeGiz0x+DnsRPXCrZKwuJVFI/E=
Received: from IA4P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:558::16)
 by SA3PR12MB8437.namprd12.prod.outlook.com (2603:10b6:806:2f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 17:33:39 +0000
Received: from BL4PEPF000003EE.namprd04.prod.outlook.com
 (2603:10b6:208:558:cafe::a3) by IA4P220CA0007.outlook.office365.com
 (2603:10b6:208:558::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Fri, 13
 Nov 2026 17:33:39 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL4PEPF000003EE.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 17:33:38 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 11:33:33 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v6 7/7] crypto: ccp - Implement SNP Download Firmware EX
Date: Fri, 13 Nov 2026 17:32:00 +0000
Message-ID: <46f84ea0e5a20d0e27235badebd509af9a930dab.1794531772.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1794531772.git.prsampat@amd.com>
References: <cover.1794531772.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL4PEPF000003EE:EE_|SA3PR12MB8437:EE_
X-MS-Office365-Filtering-Correlation-Id: bf48a0f6-fd5a-471f-77cf-08df41ac40e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|36860700016|82310400026|1800799024|261021123027099003|10067099003|5023799004|11063799006|261022115727099003|56012099006|261022105027099003|261021133027099003|261026135527099003|261026121527099003|261022113327099003|261021135927099003|261026140227099003|261026130827099003|261021130227099003|261021121427099003|261028144727099003|261022075727099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	5gQtr7INrkXmG68Yrp8P3OegBfooClSElI4gRzlaKpOIHHRZE7MkWjpjhoDZfVhYuWSYaXspVCCVy/MeoSUah+0UX8TG42bSQk5M7YcdOqW/pnYjof/rdBh/Cp97l1wPUrFn96K4jN0FymUdOAuOqsiR9X5TJpKLMcAIPxhPYYC2PWoQwon72JRal6mFb83obsO7LpBrZdrWWKfpddxXDlWCize017Cay+UOWvHrTHuEnJtll1X4qfSN6A92/7gAJWppXyIZ3pslAK37vYftTA19wH74ocnozJPDl5GpuEcl/LFjPw7fbGpIKtMnWh0+ofGOJawMcWrG0O2StBBPp2IgW550jeN+8zm5qaPbn8qiy54dsLsqcvgaDoK7I/z7FSy9ODJuUr3ZtegkYxkPW4DcgTIze59TgIAq0IHC43UfTWQP5uj4GBbannOmsvLdlT16ZqRrhKfrWsxBuiHILhk1o7t81zXTW8MVL8ARZQKoOwKhtTDKvY/SmmpqPfBApbrTe/nu54jzibRE+wBeFRjKkA4ROhW+/poxipjbKTgnYqFDbMilgspW0y8+NskCYbJToTilqBX+AUoe0NW5yt0wO0XZgfvPlpkzL5hoGNcOcMEQnZN5OGUXuyf2S3hiL90D119Ds9d8ZZdAoF3hB6F5D29/f1fKGnAe/6ViZx/aDay+v0VHgKJtMGjMtcdqMQsKS34KYHNaQFCLQHqGsA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(36860700016)(82310400026)(1800799024)(261021123027099003)(10067099003)(5023799004)(11063799006)(261022115727099003)(56012099006)(261022105027099003)(261021133027099003)(261026135527099003)(261026121527099003)(261022113327099003)(261021135927099003)(261026140227099003)(261026130827099003)(261021130227099003)(261021121427099003)(261028144727099003)(261022075727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	L+3p3dqtZDBiWwXhloSKpXnGig1Ezx1ewuOa0gp+bwu8mpPqw+wvfrFvdE9a/h2SykuvjkV35uXMn80F+nmVPdSQ5D8D26PEQyrttT0iHYAtypHuZHkIF5FXCoZ3noyzG6rLPwIgC7i4qCQU7FOmm5EnZJMYl6F5JT7wuB3GWAy1xk1cfdj6A1yMjfFBP8EVfclS/PLuIZS6nagDZGTqCXZTeAJztGBzNVsXm3G1XFqldE9i/mW/sAOluSf5MDRR78NUMIwGK7ggx4ICHVh3D92+It3kMzs8/oVBahk4XWgmGI9ahwsp+40RBA+IpsQqK/dW9xH+8AIhwFoWI5mnKnKi+LvL1XOaG6mhdqSZXQY61Of/A3kEjXiAx3bvckWh2sXh5Q/rU0wlgh7FmNG57oDedUu0+DxDZDFBJC6mWqY0fKMc6Lg0UCPv/aIgUsmJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 17:33:38.8168
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf48a0f6-fd5a-471f-77cf-08df41ac40e1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL4PEPF000003EE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8437

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
Tested-by: Shantanu Sinha <shansinha@google.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v5..v6:
* Move SNP data platform refresh before platform reinit so that it
  can be performed under one lock and cached platform state is not stale
  when re-initting the platform. Also, as a result of that remove the
  function sev_fw_upload_update() and perform this entire operation
  under sev_fw_upload_write()  - Sashiko

v4..v5:
* Report original firmware error on rollback failure - Tycho, Shantanu
---
 drivers/crypto/ccp/sev-dev.c | 289 ++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/sev-dev.h |   2 +
 include/linux/psp-sev.h      |  19 +++
 3 files changed, 309 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c5d9fe7e23d7..0dfaa5da67f6 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -29,6 +29,7 @@
 #include <linux/psp.h>
 #include <linux/amd-iommu.h>
 #include <linux/crash_dump.h>
+#include <linux/sizes.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -250,6 +251,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
 	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
+	case SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX:	return sizeof(struct sev_data_download_firmware_ex);
 	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
 	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
 	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
@@ -2253,17 +2255,302 @@ static int sev_update_firmware(struct device *dev)
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
 static enum fw_upload_err sev_fw_upload_write(struct fw_upload *fw_upload,
 					      const u8 *data, u32 offset,
 					      u32 size, u32 *written)
 {
-	return FW_UPLOAD_ERR_BUSY;
+	struct sev_device *sev = fw_upload->dd_handle;
+	int cmd_ret, psp_ret = SEV_RET_NO_FW_CALL;
+	u8 old_major, old_minor, old_build;
+	enum fw_upload_err fwl_ret;
+
+	guard(mutex)(&sev_cmd_mutex);
+
+	old_major = sev->api_major;
+	old_minor = sev->api_minor;
+	old_build = sev->build;
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
+	if (sev->fwl_rollback_required)
+		psp_dead = true;
+
+	if (fwl_ret == FW_UPLOAD_ERR_NONE) {
+		if (__sev_get_api_version_locked()) {
+			dev_warn_ratelimited(sev->dev,
+					     "Platform data refresh after DLFW_EX failed\n");
+			if (psp_dead)
+				fwl_ret = FW_UPLOAD_ERR_HW_ERROR;
+		} else if (sev->api_major != old_major ||
+			   sev->api_minor != old_minor ||
+			   sev->build != old_build) {
+			dev_info_ratelimited(sev->dev,
+					     "SEV firmware updated from %d.%d.%d to %d.%d.%d\n",
+					     old_major, old_minor, old_build,
+					     sev->api_major, sev->api_minor, sev->build);
+		} else {
+			dev_info_ratelimited(sev->dev,
+					     "SEV firmware version unchanged: %d.%d.%d\n",
+					     sev->api_major, sev->api_minor, sev->build);
+		}
+	}
+
+	if (!sev->fwl_rollback_required && !psp_dead)
+		sev_fw_upload_reinit_platform(sev);
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

