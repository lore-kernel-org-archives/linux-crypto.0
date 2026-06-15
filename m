Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701863B531A;
	Mon, 15 Jun 2026 19:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781553049; cv=fail; b=PYYLcfgZgaXOW7dOyDiFgpFL2gChv42gZZUIZJds7xaO5RT4jLwwLbK6f3KxqqlukkRt+n/0EyTRUhkKlc4DSNdTjYa3ixwLmycHFPgsU/Xbilqr6m9OyC/YOxgr300NhOWjb5RFZzvUjkFkiczi57Cd5IqHMQSEiBpUrjJXdQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781553049; c=relaxed/simple;
	bh=vuGdLL/e7nbmHBQa3VVs/TpNpujz2G3aM+7E5CDFFTs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XqIuPF8uVLuZtipuJKrXhONEF37ky6KdaBEIMJf5rTssedax4RJMvlyQvuJv4ypwdrbmn4zUsfEln/jRGb4LTu2p8GWoWynfZfYAKusFF/GhCxA06TyHTSiOTF56h2G2PMeP7uKf3QskaGCbZZjzPYb5VRajScOOmMk9jO4BPwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ysJ99u0X; arc=fail smtp.client-ip=40.93.201.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ysJ99u0X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dkEgexrmgLmv264Ywk/yE+tGFM7XGw1AlEVWA54BNuutxqD9uxFhjqOcme843xjHXp9iO1GeKUZ2HvtTdQeh0nrvZbb+WxI9HSQdTGR0hiiw9FcJGQs3HvJJ7u0OI7NKjzd0j+hmIKesRvZmf2Oy2eeOQWngaPn0TnJzUvCaLqp1m228HmHyjMvvvNDmFQ/PUzA2vjzeYM0rJe0Oz8OrRDs0+s+U1ZQMH1DFTfKYOqxoz530qqDIfZQHm6jr0OFfClXEvSV/nhVIH8yEmW910RiKxM2meRQaljreYmddTVJYSkcLIpFxlQ374hJiKgxaO54bHQNS4L0yQ5JxRC6otw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i1YVQlqnyjYXlJrMfo3dyWzHlnzJV9t5+x5bWLD990=;
 b=SYnlVdTMIHaJHGKmIsLeoBk83hCHQDqXO+o5vJew/pfiaIxKUnvCxvW2nd3Tak4GDo9BDsk/76g1UgwRzAt3l1lHmUMTLzxdL2UXGXDF7ba2WiRht6+8kiJTgti0UNkNfHnHicXezaL9laxwSaQQJqftzknwUDjPo+50mD9w6UAsnsoM7F4BFnzjcluXrcs1dlmZ/oM4eUozTx1597LWjdxRmdjYrOj7tZ8XOR6abVDKo7J1RnmOow4c243QPxpYE1oeRXe/SmzbUK5aZipOZLLP1/+5WK6XTYUysrYNSMNynd/EJo61zi9B4urpSiOdPEVn9VizfSSbJXfUgRhLtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i1YVQlqnyjYXlJrMfo3dyWzHlnzJV9t5+x5bWLD990=;
 b=ysJ99u0X7oj57O5M+xFs8TLwBpbwiEXMgFvx/gg4U/HzYfzYaMPb6edz+/Rg9IPTTz12imucMZ7V/x91nfp3CXjqioxavndVOBeD6cQErKeIB9fswELVWZ2lVj7J59Oyx6uPbseivMRX5Jv2co8bx2mmztcaeYHEPzud+9M0Pa0=
Received: from MN0P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::12)
 by MN2PR12MB4077.namprd12.prod.outlook.com (2603:10b6:208:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.16; Mon, 15 Jun
 2026 19:50:44 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:52e:cafe::67) by MN0P220CA0022.outlook.office365.com
 (2603:10b6:208:52e::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.18 via Frontend Transport; Mon,
 15 Jun 2026 19:50:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.139.8 via Frontend Transport; Mon, 15 Jun 2026 19:50:44 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Mon, 15 Jun
 2026 14:50:42 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <ackerleytng@google.com>, <jackyli@google.com>,
	<pgonda@google.com>, <rientjes@google.com>, <jacobhxu@google.com>,
	<xin@zytor.com>, <pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v8 6/7] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
Date: Mon, 15 Jun 2026 19:50:26 +0000
Message-ID: <25c3693a59c8f00796e84f1ffa668df6e3b734b5.1781419998.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1781419998.git.ashish.kalra@amd.com>
References: <cover.1781419998.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|MN2PR12MB4077:EE_
X-MS-Office365-Filtering-Correlation-Id: c2d8b53b-8a9c-4ab8-37eb-08decb176342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700016|1800799024|23010399003|921020|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pL6lOt0DXWVf9ATBLpaxbSVGy5cHVom5fswrnwmSXG0NwxBoQYqT1B/ypHZbxaQeWoeBh4EDXJerY+F5XBooGmmeUgp5j1Phj1OSuFrR9cSQnQUqrP74v2YUojhk0BZQ9zHrj0UuZkdxH6QYHnohE3Zx75s4vivgsiuNkJ4GiVeTEyrZxhnt+M44RdPXuS6AxB8UnoGzTet+VSvXokuNVBQc79WsqxacPocmxxiA/ST/uyanq6GhTnJNhFoc5khcd09+zihOv9I0KQC2qCw1A7Clc6mgG2RfqdYySj3jSMRQFQtt1pLuUgvWh/A4I85G89YC9KBj/K8fzw7qDiXhYw9YFLQtvl5sg/Q1Trv2Kh5+KS36ABTc5x0jniXaOiZycik+28hDQcMvIxBrswMR9xgB6kJXPD+XtNIQziJ/EUL4QaxZbXITIxwj7elMtgvFQNfDciJe5zhgrH/n8aP7KrCb2Yqw+GzVqBclb/2dJR06dCBBbyjzT+cVFBf7tZ9xPSoCOL7oAAWtsZt0rz9OvCoU9mRhCnFp4DuyPOr56VkaVuSyNGwRQUHzzR/NkL9B+diDJak7GcdjAECEwT1s0Q2K5oQjyiKenlgR7X77XbXnPgCxdaTLyke3L2CX40Hwjl0XnGF6KHATXLBg22lpJY7YN20K2UCMA+SL1WSeneYzzwl4fdQQaE3mO5XqBX1ljUiLpiTrn3FVUDS/suL6crYwF/AvhzJo5o+2d5k7a2MvQ1Tm5Hbp+ckim6W7rnGGzLz4Ab/lzdbZoTn+ZlzhrA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700016)(1800799024)(23010399003)(921020)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mpX3xeHeEV6sayEMxYYRHpR42uaevnJEZl/PnEClLqq+UzKEsfRV4f39iq5OkOmyd1v6st4ciHrpPIKBxHr93ZyzbmM4Wtqsvky9GhAj8geqrFxGBxY2LtWHCV8c+tJd686IRAQ88+Sh/sJUgMCNtnbGm8E5xgos/OyKRv4nyz24gSHMe6dagqTLQ35sR/shb3iPXVA9Hw6UrbDyRH54M0p4Btrb7PDq3daYfcA83Y9dUJTX8CeiWQVOWtDD7rDr0UNYOH9kNgm6Eh11bLid2YFCOaHP6+5RIvOk5xoibQYL5fJIk9LRN87XliZwzhSScv5F2vWcGGJBY5ZZLwAEB4H8oC4G362qUY285ujq92fjLjNxSvxYliWRQoKUKHNckRNsvTgoIexEzP+HXiMkbMWxT7wPk3OnihWJkUwXgpWDN6ubUZB177XxEWjtFtM4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 19:50:44.2733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d8b53b-8a9c-4ab8-37eb-08decb176342
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4077

From: Ashish Kalra <ashish.kalra@amd.com>

Pages are converted from shared to private as SNP guests are launched.
This destroys exisiting RMPOPT optimizations in the regions where
pages are converted.

Conversely, guest pages are converted back to shared during SNP guest
termination and their region may become eligible for RMPOPT
optimization.

To take advantage of this, perform RMPOPT after guest termination.
Do it after a delay so that a single RMPOPT pass can be done if
multiple guests terminate in a short period of time.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e107f368ed2d..29af6f6e603c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3005,6 +3005,8 @@ void sev_vm_destroy(struct kvm *kvm)
 		 */
 		if (snp_decommission_context(kvm))
 			return;
+
+		snp_rmpopt_all_physmem();
 	} else {
 		sev_unbind_asid(kvm, sev->handle);
 	}
-- 
2.43.0

