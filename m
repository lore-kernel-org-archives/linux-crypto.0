Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2045.outbound.protection.outlook.com [40.107.212.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B201622DFA3;
	Mon, 30 Jun 2025 20:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751315029; cv=fail; b=KET8yIIFZ8fPMVkv1YNBqcW+IC1lYv89FtMX2hxflxb2Wqe4hEuIaNDNVLpZ8ZfkSegxaoS4ZxEdKMnL5CK+6CCEoiATvy3zvQBPr/uo5W9E4MOakJD3aBlVUUoYEQuLM97eFV0andr84b6/kjub6NMrJ8HuxlnKK6SljhfopNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751315029; c=relaxed/simple;
	bh=tZjsrv0CDUfoZKSrdgwDmlRaZ17KiMximC3uHKr4nxE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m7wkmOck+E3bGlCq73f9mgNLNFXeqtYw3Q7X6HhBxJhO6jMTjciRTg0CWAK6IDUPx+ChW2ii/+gnvTp3Co+bZRZMf/oLCCyEaioEf2ieFan1xVGQk61CI/2iYfIOR/6nuoIggahFCfEjJfKCTQ1Gz6RyFy87QRlucoSq0muwh7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uPXYSA/Q; arc=fail smtp.client-ip=40.107.212.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uPXYSA/Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W38AV65olztgEIPA5Zy0zq6PumJKj4XBVusQ/Tu3KN0XF9GdQ0uVE1AgF4VrVCoaffCigJ4jo9ui+BMCJ8eyrzgnj4iJeCcUSezMkKtRLx1tKX2voBlxAx1yJgGOpYroxJoUEhPGUrF4nhwJ7UCKrOnYPb+lZ6HOXyNV+Lrixb0r2hAbp5G0bGTZQmh+s29CRLKg3UclkUPirg0f3hTOdeXjElmT5hiGPDSw7qs4N9Sb8q7Fy6XY9UEkqYYi1LjI7Wh8iAWMgeho/mGL5RiTuyRL6KVCzboYOPAX1ffimEjrg68UsHvOwtFrcNzdhtomx16y0kZCxN6Rwgt5ClWPGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSIFxt2WmIFz6GuX48ivuWEAaoQ+LwvOKDkfBPZTNuI=;
 b=Ojg1I4RpM3vUhypwwAGC6xspeI0QniWv0k0OVCfYulkNL7cwHrnFt3PaxsuccFmevaBbYkVXJhS2KBb/uymvnYm9BSTY8K07wuqyrZK3MOitsXitKUpmNkhxnO9T2gAtbI2SIRsaa72Oe1H5Nk8qmqr11nxYbGn9LVZkGjG9kiAUPIw5w1d87McuIqq3Cm63u5Qd6wvOI79DXqdoGexHulRLpB4U2lY9dMaEs9mAcnr6rI+JyFHPR5oPHm0tOAakimVe+JVxR7sIP36CRvfNK6roEIhoxJSQTtRcCcA49e13X/+WjnT/GdbhMnQQEQcfBMhSE4l0l/NgNnh6/JMBVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSIFxt2WmIFz6GuX48ivuWEAaoQ+LwvOKDkfBPZTNuI=;
 b=uPXYSA/Q6cdRp6z6SoMNk9xP54gu5O+NVLsXr8HJc1ySOM5joOEMkZIGQqNn/jMp3aWQNCCkaoKOZ+Onnv7PbRBhUeaxzwCGaFhMUABL7aX5od4gPplqjyRm1IVO2rQMVk8coNpBxisxU9cXJKAAmSqRi8sN7/bGVwbMHJhdgcU=
Received: from SJ0PR13CA0092.namprd13.prod.outlook.com (2603:10b6:a03:2c5::7)
 by CY8PR12MB9033.namprd12.prod.outlook.com (2603:10b6:930:71::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Mon, 30 Jun
 2025 20:23:38 +0000
Received: from SJ1PEPF0000231F.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::8d) by SJ0PR13CA0092.outlook.office365.com
 (2603:10b6:a03:2c5::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.19 via Frontend Transport; Mon,
 30 Jun 2025 20:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF0000231F.mail.protection.outlook.com (10.167.242.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8901.15 via Frontend Transport; Mon, 30 Jun 2025 20:23:38 +0000
Received: from ellora.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 30 Jun
 2025 15:23:36 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <ashish.kalra@amd.com>,
	<thomas.lendacky@amd.com>, <john.allen@amd.com>,
	<herbert@gondor.apana.org.au>, <bp@alien8.de>, <michael.roth@amd.com>,
	<aik@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>, <prsampat@amd.com>
Subject: [PATCH 1/1] crypto: ccp - Add the SNP_VERIFY_MITIGATION command
Date: Mon, 30 Jun 2025 15:23:19 -0500
Message-ID: <20250630202319.56331-2-prsampat@amd.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250630202319.56331-1-prsampat@amd.com>
References: <20250630202319.56331-1-prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231F:EE_|CY8PR12MB9033:EE_
X-MS-Office365-Filtering-Correlation-Id: b9593ff5-20f4-40d7-8f84-08ddb813ff3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xhk0rcH9CeXxdMwGZ98SRET3c+IRP+ZaPlZHo/0LC2/Ka9ChxZcU4LbAQJ8R?=
 =?us-ascii?Q?kNdPJgbb50eh7VYQRM4cisFJjVTTk3wwKzuP21EOr5jVgjZSIgR0NZHVUDdN?=
 =?us-ascii?Q?7lTE8D0huPevlkPSoxw5D7ELmtJEYH2pOl6EVyrVjzfs5QOKGYjioIz8byCe?=
 =?us-ascii?Q?pNsN9QOJ5TAlynErUebPI5Q+kkah5daXRpu/lMMB3/z2ZOxn1F8z3gao0uFk?=
 =?us-ascii?Q?f22t4Guc5obDjm2N69uF3DsaZYSJ86E5/quYRjSogd2YbR2Z7yRXWeYWd/DA?=
 =?us-ascii?Q?HvHn+PU7NrV6O78mIzmcnU+0S4YRKY6pQBfFFWZASoHIXwht91tyQVhYHzF6?=
 =?us-ascii?Q?kfm5c/a6Z39O6JgkB6Yd7vytEZQOLCU2EAdPmsPAu0oaIgnI5gR++QFpEtCd?=
 =?us-ascii?Q?SyUh/nlsPGvQ7gOQc+LujfPJSvTUjPswYOV1rtk+tgR5ka/mvR/nXF2AbMgf?=
 =?us-ascii?Q?O7NwgBNkBn/ujSLcUOON95yLy1kN8Y5phxLGJOINv8XcTFoOvApBlel7ADo3?=
 =?us-ascii?Q?+LK4ouslTguf5T7WTShuFEEAVwEG7LB4lUngVoI1lWkvKEd+S827XKZWGDYF?=
 =?us-ascii?Q?RMA7CCyDLaC1LX4MQ7ElFcfho/Q7s7uOzXDbxj63oNK2C54FBlqIlGyfwXRj?=
 =?us-ascii?Q?7QpNnYvTAIK+b2svmW9LzzFRrDd/ppqG/gSSrJQ30ltp9lj3ilsGTxl3zalt?=
 =?us-ascii?Q?UY5RJqlmEKiYKVFlVdTG3IyNmdRmR9WDWvLwMrcWA8A2sTwMbILGkY3q1vhO?=
 =?us-ascii?Q?m7UuEGXzdJu59u4MEwOOQRTyPaO+3pj8D8N7YyEWCBHQQcdoNzxA0aS78AWg?=
 =?us-ascii?Q?PCInlW2ympQ7a9Z2w4VBe7jRWLnV2jqJEJqeA/3ojoU+bfAxGYcmBrPNZvlS?=
 =?us-ascii?Q?doJXDqbnCYIXA0Dix4/Pzmz2ja3RBU66czOdfR+QuWphKJlzzBZcLDXQq4es?=
 =?us-ascii?Q?MY6+4lP6onbh2/AmHZX21V/kI3DErFTRqkW8XMD0e2+YMo+6avYHPXh+2hIC?=
 =?us-ascii?Q?UQOtYhbXPHafowOtB5OZVxxTSo6g33IklmB4fZA7vJ00BYSaaRbt8niOMnWf?=
 =?us-ascii?Q?Xu7C1LfE9GPGSrV7/cXW3J0L0c5YL61exbtnXhcu2Rhb2S9SK2SjbyPeUf9b?=
 =?us-ascii?Q?zwyjCDezn11f2cCZvbawMpjsIGAhAg60Q7wfv+Ll3UcwCxhWRwzAFh4AGUYq?=
 =?us-ascii?Q?EVgsjKaIZrnoprHCBjPxfJ9PblCVSSIaHb7bxgJDnAuxwz2t2h1Tv+RLRguU?=
 =?us-ascii?Q?tQ/JKdPGvpLLBWy4uqbpWuDPUPdf3IAUjQIu/8WIWWzQm0MNdSvVExJueWnu?=
 =?us-ascii?Q?auzCypAuGfCfr5aOuDzow42+FdoVynsNFA+NjwgybEsSibGN8K3gkM6tJZN1?=
 =?us-ascii?Q?+7v1onal/DZLMtGpKoLM/HStG8frBp3e3CxDDAZYyKJT/0itFhpYs0jyMIPM?=
 =?us-ascii?Q?/p++Dyqa1M/PUwlEJgxhyAoezPwfed+SHYaNpEtqOdyvbjunBzjnZlPibuwy?=
 =?us-ascii?Q?og2wGUU0lZkCJiDAJzVHRJEZiY1piOTugvm7?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 20:23:38.1315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9593ff5-20f4-40d7-8f84-08ddb813ff3e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB9033

The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
can be used to query the status of currently supported vulnerability
mitigations and to initiate mitigations within the firmware.

See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
more details.

Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
 Documentation/virt/coco/sev-guest.rst | 13 +++++++
 drivers/crypto/ccp/sev-dev.c          | 55 +++++++++++++++++++++++++++
 include/linux/psp-sev.h               | 30 +++++++++++++++
 include/uapi/linux/psp-sev.h          | 34 +++++++++++++++++
 4 files changed, 132 insertions(+)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index 93debceb6eb0..8cc1eb375284 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -195,6 +195,19 @@ them into the system after obtaining them from the KDS, and corresponds
 closely to the SNP_VLEK_LOAD firmware command specified in the SEV-SNP
 spec.
 
+2.8 SNP_VERIFY_MITIGATION
+-------------------------
+:Technology: sev-snp
+:Type: hypervisor ioctl cmd
+:Parameters (in): struct sev_user_data_snp_verify_mitigation
+:Returns (out): 0 on success, -negative on error
+
+SNP_VERIFY_MITIGATION enables the host to issue commands to the SEV firmware to
+manage vulnerability mitigations. This command provides two subcommands: VERIFY
+and STATUS. The VERIFY subcommand instructs the firmware to initiate mitigation
+for a specified vulnerability. The STATUS subcommand queries the firmware for
+the currently supported and verified mitigations.
+
 3. SEV-SNP CPUID Enforcement
 ============================
 
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 16a11d5efe46..9f43151bcdfe 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -228,6 +228,7 @@ static int sev_cmd_buffer_len(int cmd)
 	case SEV_CMD_SNP_LAUNCH_FINISH:		return sizeof(struct sev_data_snp_launch_finish);
 	case SEV_CMD_SNP_DBG_DECRYPT:		return sizeof(struct sev_data_snp_dbg);
 	case SEV_CMD_SNP_DBG_ENCRYPT:		return sizeof(struct sev_data_snp_dbg);
+	case SEV_CMD_SNP_VERIFY_MITIGATION:	return sizeof(struct sev_data_snp_verify_mitigation);
 	case SEV_CMD_SNP_PAGE_UNSMASH:		return sizeof(struct sev_data_snp_page_unsmash);
 	case SEV_CMD_SNP_PLATFORM_STATUS:	return sizeof(struct sev_data_snp_addr);
 	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
@@ -2201,6 +2202,57 @@ static int sev_ioctl_do_snp_vlek_load(struct sev_issue_cmd *argp, bool writable)
 	return ret;
 }
 
+static int sev_ioctl_do_snp_verify_mitigation(struct sev_issue_cmd *argp, bool writable)
+{
+	struct sev_user_data_snp_verify_mitigation input;
+	struct sev_data_snp_verify_mitigation data = {0};
+	struct snp_verify_mitigation_dst *mit_dst = NULL;
+	struct page *page = NULL;
+	void __user *dst_uaddr;
+	int ret;
+
+	if (!argp->data)
+		return -EINVAL;
+
+	if (copy_from_user(&input, u64_to_user_ptr(argp->data), sizeof(input)))
+		return -EFAULT;
+
+	/* VERIFY command may change system state when applying the mitigation */
+	if (!writable && input.subcommand == SNP_MIT_SUBCMD_REQ_VERIFY)
+		return -EPERM;
+
+	data.length = sizeof(data);
+	data.subcommand = input.subcommand;
+	data.vector = input.vector;
+
+	if (!input.dst_uaddr)
+		goto cmd;
+
+	dst_uaddr = (void __user *)input.dst_uaddr;
+
+	page = __snp_alloc_firmware_pages(GFP_KERNEL | __GFP_ZERO, 0, true);
+	if (!page)
+		return -ENOMEM;
+
+	mit_dst = page_address(page);
+	data.dst_paddr = __psp_pa(mit_dst);
+	data.dst_paddr_en = true;
+
+cmd:
+	ret = __sev_do_cmd_locked(SEV_CMD_SNP_VERIFY_MITIGATION, &data, &argp->error);
+	if (ret || !data.dst_paddr_en)
+		goto out;
+
+	if (copy_to_user(dst_uaddr, mit_dst, sizeof(*mit_dst)))
+		ret = -EFAULT;
+
+out:
+	if (page)
+		__snp_free_firmware_pages(page, 0, true);
+
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -2264,6 +2316,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SNP_VLEK_LOAD:
 		ret = sev_ioctl_do_snp_vlek_load(&input, writable);
 		break;
+	case SNP_VERIFY_MITIGATION:
+		ret = sev_ioctl_do_snp_verify_mitigation(&input, writable);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 0b3a36bdaa90..ee5d64b0959a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -96,6 +96,7 @@ enum sev_cmd {
 	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
 	SEV_CMD_SNP_DBG_DECRYPT		= 0x0B0,
 	SEV_CMD_SNP_DBG_ENCRYPT		= 0x0B1,
+	SEV_CMD_SNP_VERIFY_MITIGATION	= 0x0B2,
 	SEV_CMD_SNP_PAGE_SWAP_OUT	= 0x0C0,
 	SEV_CMD_SNP_PAGE_SWAP_IN	= 0x0C1,
 	SEV_CMD_SNP_PAGE_MOVE		= 0x0C2,
@@ -812,6 +813,35 @@ struct sev_data_snp_commit {
 	u32 len;
 } __packed;
 
+/**
+ * struct sev_data_snp_verify_mitigation - SNP_VERIFY_MITIGATION command params
+ *
+ * @length: Length of the command buffer read by the PSP
+ * @subcommand: Mitigation sub-command for the firmware to execute.
+ * @rsvd: Reserved
+ * @vector: Bit specifying the vulnerability mitigation to process
+ * @dst_paddr_en: Destination paddr enabled
+ * @src_paddr_en: Source paddr enabled
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ * @dst_paddr: Destination address to write the result
+ * @src_paddr: Source address for optional input data
+ * @rsvd3: Reserved
+ */
+struct sev_data_snp_verify_mitigation {
+	u32 length;
+	u16 subcommand;
+	u16 rsvd;
+	u64 vector;
+	u32 dst_paddr_en : 1,
+	    src_paddr_en : 1,
+	    rsvd1 : 30;
+	u8 rsvd2[4];
+	u64 src_paddr;
+	u64 dst_paddr;
+	u8 rsvd3[24];
+} __packed;
+
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 
 /**
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index eeb20dfb1fda..ca0f44fef659 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -32,6 +32,7 @@ enum {
 	SNP_COMMIT,
 	SNP_SET_CONFIG,
 	SNP_VLEK_LOAD,
+	SNP_VERIFY_MITIGATION,
 
 	SEV_MAX,
 };
@@ -249,6 +250,39 @@ struct sev_user_data_snp_wrapped_vlek_hashstick {
 	__u8 data[432];				/* In */
 } __packed;
 
+#define SNP_MIT_SUBCMD_REQ_STATUS	0x0
+#define SNP_MIT_SUBCMD_REQ_VERIFY	0x1
+
+/**
+ * struct sev_user_data_snp_verify_mitigation - vulnerability mitigation op
+ *
+ * @subcommand: Mitigation sub-command for the firmware to execute.
+ *              REQ_STATUS: 0x0 - Request status about currently supported and
+ *                                verified mitigations
+ *              REQ_VERIFY: 0x1 - Request to initiate verification mitigation
+ *                                operation on a specific mitigation
+ * @vector: A single bit to specify the mitigation to process
+ * @dst_uaddr: Destination addr to write the result
+ */
+struct sev_user_data_snp_verify_mitigation {
+	u16 subcommand;				/* In */
+	u64 vector;				/* In */
+	u64 dst_uaddr;				/* In */
+} __packed;
+
+/**
+ * struct snp_verify_mitigation_dst - mitigation result vectors
+ *
+ * @mit_verified_vector: Bit vector of vulnerability mitigations verified
+ * @mit_supported_vector: Bit vector of vulnerability mitigations supported
+ * @mit_failure_status: Status of the verification operation
+ */
+struct snp_verify_mitigation_dst {
+	u64 mit_verified_vector;		/* OUT */
+	u64 mit_supported_vector;		/* OUT */
+	u32 mit_failure_status;			/* OUT */
+} __packed;
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.49.0

