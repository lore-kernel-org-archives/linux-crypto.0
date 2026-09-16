Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012014.outbound.protection.outlook.com [52.101.48.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC60338736E;
	Wed, 16 Sep 2026 12:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560231; cv=fail; b=jjZ6exUTPzAeNITtIbCBLY+X/RE6PSHB3yCWdeJANkJe/atPlODBX3WMo+P3RDJD7IDnMZZYuAdYDC0r24KKcclZ/rL9IqoDtfxv1bl3HHv6YQ0C02bN1GD8i9iGnQypGSv6xmvNUwZF2Bw8hkkSANl7t5hSKBb7yC/3J/0GSfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560231; c=relaxed/simple;
	bh=wSb8CRmnG6Q/1UzYGP8aZ70xLkoLJr1eGfoeWFRwexs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/JoaJiAHRwVLmL9UIVbYkjqTMBksQF0wQF29RQU6Gr0W08HPz/KfRAu6J5JMbm4YiLtp9O9F/VbyY3ywiE9smO/BbZDoG3pVDpWOvyKBRkGZnaZCIjPx0FxSyv7Ha+ACCMEgoPE3g/hOV1jv7MwDb7H0lJ2OuF1l5tpme0C+5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pEkxIe6W; arc=fail smtp.client-ip=52.101.48.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pEkxIe6W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sdWZGPM/zgWMCChuh52X0kMji/qLxyRnue0l4weppikfIskSxwetWJztFG0+vdh/yuym1d0rd0z3AfQTJLfwN5/s3ttZPOvbaFGTaPbhJkkXfTU7wIDgO0fbrwAc5JCaaTsidDHnutfF/OQFVv1XYn98HJ1W3xvnmWScIDfCUT3K14TyKd7PASinbA8Sk8PoFypDZP5fTlvlv72O+U9SMCcK8jxp/mNUydtEyYrHwfGavd0ucS7VnvEy4x6T/JOxc0I/y7m7k1tEp9FGYw6ZAGvqpO1pnvZy8VTszGO7n/Vrl6+0g9/VY2DU6OMEWRU0tw/CWyETpjwPpA/MYywJ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WNgXfa5En712+eAspMOEbd4EbM4QDl/vkmtEAEeJtpw=;
 b=LSYNh5pVts8gPMPMedX0JXjgMQiXo3cpgEMoWw+mHa2iEZwEuZAKy3JVH8sIV7pIGmPmhp1Pdii9dBGHYWUfDaV0yH1y3hpCRTFtVJhCc0K+PedFf69YdzoqYzT2HqGmzRSs9uVXsmJ0xPZOKeqPmEvBxX77/wEC+/CFR0QNoj1/Bv6PYR5S5yWrBIsn+h+41pGYwwPOoqAGPvhk62KHw7QAI0K0wqRibfEVgjss5cLb4NuliWck4voL2FcQcwdG7v/OtNPkoKmw0VmNAxi9FfEkUd6wHZVObbXkDVnCjSrM89ghLFpoHG8o9WNsZ6W0mO4hvtvv3dAyLMTEF37LHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WNgXfa5En712+eAspMOEbd4EbM4QDl/vkmtEAEeJtpw=;
 b=pEkxIe6WPh1OzcaBTJT4DVHOZUiIH9fM8UC0vHozp9wjEJKN7cTc8RQ2oJN5lIT/WKvmxpwTk90fQw7tTftPmDuF5diikQVG431OJLdqT9rnfRqfjeWMxJu4oTNAbxUZyI+8bsbwvSOuw7uEzI8tt4Fqr8NUiKxBtub7JpwIGes=
Received: from SJ0PR05CA0148.namprd05.prod.outlook.com (2603:10b6:a03:33d::33)
 by PH7PR12MB5758.namprd12.prod.outlook.com (2603:10b6:510:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Wed, 16 Sep
 2026 12:03:24 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::6c) by SJ0PR05CA0148.outlook.office365.com
 (2603:10b6:a03:33d::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.8 via Frontend Transport; Wed, 16
 Sep 2026 12:03:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 12:03:24 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 07:03:01 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-pci@vger.kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Jini Susan George
	<jinisusan.george@amd.com>, Kees Cook <kees@kernel.org>, Michael Ellerman
	<mpe@ellerman.id.au>, Nikunj A Dadhania <nikunj@amd.com>, Ard Biesheuvel
	<ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, Kim Phillips
	<kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>, Ethan Nelson-Moore
	<enelsonmoore@gmail.com>, "Tycho Andersen (AMD)" <tycho@kernel.org>, "Liam
 Merwick" <liam.merwick@oracle.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>, Xiaotian Feng <dfeng@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, Andi Kleen
	<ak@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, Tony Luck
	<tony.luck@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu
	<baolu.lu@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>, Jonathan Cameron
	<jic23@kernel.org>, Jori Koolstra <jkoolstra@xs4all.nl>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Ian Campbell
	<ian.campbell@citrix.com>, Jeremy Fitzhardinge
	<jeremy.fitzhardinge@citrix.com>, Petr Tesarik <ptesarik@suse.com>, "David
 Howells" <dhowells@redhat.com>, Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, "Christian
 Marangi" <ansuelsmth@gmail.com>, Dave Jiang <dave.jiang@intel.com>, "Michael
 Kelley" <mhklinux@outlook.com>, Ilias Stamatis <ilstam@amazon.com>, "Sumanth
 Korikkar" <sumanthk@linux.ibm.com>, Simona Vetter <simona.vetter@ffwll.ch>,
	Toshi Kani <toshi.kani@hp.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Vinod Koul <vkoul@kernel.org>, Jiang Liu
	<jiang.liu@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Palmer Dabbelt" <palmerdabbelt@google.com>, <linux-coco@lists.linux.dev>,
	<xen-devel@lists.xenproject.org>, <iommu@lists.linux.dev>,
	<linux-mm@kvack.org>, Alexey Kardashevskiy <aik@amd.com>, <aik@ozlabs.ru>,
	Santosh Shukla <santosh.shukla@amd.com>, "Pratik R . Sampat"
	<prsampat@amd.com>, Scott Soule Cheloha <scott.cheloha@amd.com>, Ackerley Tng
	<ackerleytng@google.com>, Fuad Tabba <tabba@google.com>
Subject: [RFC PATCH kernel 17/17] x86/sev: Flush IOMMU TLB for trusted devices
Date: Wed, 16 Sep 2026 21:51:57 +1000
Message-ID: <20260916115159.1938195-18-aik@amd.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916115159.1938195-1-aik@amd.com>
References: <20260916115159.1938195-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|PH7PR12MB5758:EE_
X-MS-Office365-Filtering-Correlation-Id: 21ea1d17-cfda-4c2c-c170-08df13ea82d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|82310400026|23010399003|376014|1800799024|32650700020|11063799006|56012099006|6133799003|18002099003|22082099003|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	yu/3328I801SY6FsYLc9CmvUZeEctUSSIDcyqxwUJ2hyVwt1WwcikhhyEMaqjVoj9tup6Xs7JzO2JsFAwueqDHDuLJ4UJeD/Cqr0S/gwkM/VbD2cofhYFX+DGMcg8giesVcXkUaTcZfLys+XRE2GX0TEknqjsrq8h+KJMRLuv9azyIRAHjLcNOetKEeY/l3SK+Zl6nQaWCi2uBgCZm871matcHCgw8YPx771yvaq3lo372oXL6vbba3D+LqRDMjyGQXtjXjQ2kEqFmGqfdaiaI24BeoAKNt4T4lsp8YxyrpYck0xZC8v2YQWbWtd2ZjGgUZdlW8WfxK7kNLFYHLfq1OsmitoWZ5nLJKkI5SlgjZ5Y1b6ytdTP9v1b5oOHAKJ/TeeWP3hRt4xn56FdReJnGnJ6Mfx1xjAhoFl16ZwQ25h/RSTrPwtNSOwF0tNev+u2W1ADCXmLBjsw6yfT18W86V2LNNt4b+fRE23l5h0xhIYXcOsWPSB+Y3F5SDGmWere2xqvjMP/gQfj8rpcZxpYarVEjV+OFEKpCid77UcNu/fAGh7619VZIwl2bovx9wB
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(82310400026)(23010399003)(376014)(1800799024)(32650700020)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cb7bK2cEQmHcr0JP49cyQs52un826U+ce5HZh0WUKLP+NxrD8AcCzH5bePkXMGpnA3ymANrzpOSs6nrnYlJPrhKvhMt+HtLVqqmS/E6++vt5OAdCWcjsBtHKJ+QIvM/bunvTX7sQKQ/2dns2Gc45uni/M6nHqDzJVC8R0Po21vRlnjJa+CcTk0dJZ3HbQ5zUPHsM1WIk9XQj39DDho1cKopgzakVdo/TZNycLzBfRVOk8LuI1piyvQ5BRbAzLqWH76tpNQKNERneQPauhw+yjtUPl1rqfN8chlrueV970xK4gUAPXQ2sMffAzL/zncSCVYK1Hwdgvut4Qb3FsjbJ3ufmR1Vfxlf8u1T+0W2JcqtSsasf0M/f6hxoC+oUKHN+NZI6VVyVLetXy4sdmL6/faQmDdYbLkXxVyvkuVeH1fivn8YnzvYNkPGf8gVbJJcV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 12:03:24.6817
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ea1d17-cfda-4c2c-c170-08df13ea82d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5758

IOMMU performs RMP checks when SNP is enabled, the results are
cached along with the IOMMU translations. When a VM lowers permission
of a mapped page (moves to a lower VMPL level or from read+write to
read-only or private to shared), the cached RMP check results require
invalidation.

At the moment the only way to invalidate IOMMU cache is the RMPUPDATE
instruction which flushes all IOMMU TLBs. It is a host privileged
instruction so a VM needs a way to ensure the host has done it.
Note that the guest's RMPADJUST/PVALIDATE do not flush IOMMU TLBs.

The host implements a new "IOMMU TLB Flush" VMGEXIT code which is
advertised via bit#11 in the GHCB Hypervisor capabilities.

Use RMPUPDATE in the following way:
- allocate a page per VCPU (to allow lockless flushing);
- When invalidation is needed, copy two patterns (A and B) to the page;
- invalidate the page so the host can make it shared;
- use new GHCB call to request RMPUPDATE on the host;
- the host makes the page shared;
- the host clears pattern A;
- the host makes the page private again;
- the host returns to the guest;
- check if pattern A has changed and pattern B has not;
- if the above failed, panic().

The patterns are located far enough to not hit the same cache line to
work with the cipher text hiding feature.

The host can choose to not execute the request, WARN_ON if this
is the case. Further patches will attempt to handle this in other way.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 +
 arch/x86/include/uapi/asm/svm.h   |  3 +
 arch/x86/coco/sev/core.c          | 92 ++++++++++++++++++++
 3 files changed, 97 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index ff763c3c5d63..51abf8d061fa 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -138,6 +138,7 @@ enum psc_op {
 #define GHCB_HV_FT_SNP_AP_CREATION	BIT_ULL(1)
 #define GHCB_HV_FT_SNP_MULTI_VMPL	BIT_ULL(5)
 #define GHCB_HV_FT_SNP_SEV_TIO		BIT_ULL(7)
+#define GHCB_HV_FT_SNP_IOMMU_TLB_FLUSH	BIT_ULL(11)
 
 /*
  * SNP Page State Change NAE event
@@ -210,6 +211,7 @@ struct snp_psc_desc {
 #define GHCB_TERM_SECURE_TSC		10	/* Secure TSC initialization failed */
 #define GHCB_TERM_SVSM_CA_REMAP_FAIL	11	/* SVSM is present but CA could not be remapped */
 #define GHCB_TERM_SAVIC_FAIL		12	/* Secure AVIC-specific failure */
+#define GHCB_TERM_IOMMUTLB_FLUSH	13	/* IOMMUTLB flush failed for SEV-TIO device */
 
 #define GHCB_RESP_CODE(v)		((v) & GHCB_MSR_INFO_MASK)
 
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 93597ad492bf..269050942c8e 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -160,6 +160,8 @@
 #define SVM_VMGEXIT_SEV_TIO_OP_UNBIND	1
 #define SVM_VMGEXIT_SEV_TIO_OP_RUN	2
 #define SVM_VMGEXIT_SEV_TIO_OP_STOP	3
+#define SVM_VMGEXIT_IOMMU_TLB_FLUSH		0x80000022ull
+#define SVM_VMGEXIT_IOMMU_TLB_FLUSH_NO_ACTION	1
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffdull
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffeull
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
@@ -285,6 +287,7 @@
 	{ SVM_VMGEXIT_AP_CREATION,	"vmgexit_ap_creation" }, \
 	{ SVM_VMGEXIT_SEV_TIO_GR,	"vmgexit_sev_tio_guest_request" }, \
 	{ SVM_VMGEXIT_SEV_TIO_OP,	"vmgexit_sev_tio_op" }, \
+	{ SVM_VMGEXIT_IOMMU_TLB_FLUSH, "vmgexit_sev_tio_iommu_tlb_flush" }, \
 	{ SVM_VMGEXIT_HV_FEATURES,	"vmgexit_hypervisor_feature" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index ed0e4546d5e5..aa5a3abb4796 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -44,6 +44,7 @@
 #include <asm/cpuid/api.h>
 #include <asm/cmdline.h>
 #include <asm/msr.h>
+#include <asm/archrandom.h>
 
 #include "internal.h"
 
@@ -103,6 +104,36 @@ static unsigned long snp_tsc_freq_khz __ro_after_init;
 
 DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
 DEFINE_PER_CPU(struct sev_es_save_area *, sev_vmsa);
+DEFINE_PER_CPU(u8 *, iommu_tlb_flush_ghcb_page);
+static atomic_t sev_tio_devices_num;
+
+static int alloc_iommu_tlb_flush_ghcb_pages(void)
+{
+	unsigned int cpu;
+	struct page *pg;
+	void *p;
+
+	/*
+	 * Allocate per CPU pages while encrypted DMA is not happening yet
+	 * and smashing is cheap.
+	 */
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(iommu_tlb_flush_ghcb_page, cpu))
+			continue;
+
+		pg = alloc_pages_node(cpu_to_node(cpu), GFP_KERNEL, 0);
+		if (!pg)
+			return -ENOMEM;
+
+		p = page_to_virt(pg);
+		/* Trigger psmash in the host os now to avoid psmash race later */
+		snp_set_memory_shared((unsigned long)p, 1);
+		snp_set_memory_private((unsigned long)p, 1);
+		per_cpu(iommu_tlb_flush_ghcb_page, cpu) = p;
+	}
+
+	return 0;
+}
 
 int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
 {
@@ -111,6 +142,24 @@ int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
 	struct ghcb *ghcb;
 	int ret;
 
+	if (!(sev_hv_features & GHCB_HV_FT_SNP_SEV_TIO))
+		return -EPERM;
+
+	if (op == SVM_VMGEXIT_SEV_TIO_OP_RUN || op == SVM_VMGEXIT_SEV_TIO_OP_STOP) {
+		if (!(sev_hv_features & GHCB_HV_FT_SNP_IOMMU_TLB_FLUSH))
+			return -EPERM;
+
+		if (op == SVM_VMGEXIT_SEV_TIO_OP_RUN) {
+			if (atomic_inc_return(&sev_tio_devices_num) == 1) {
+				ret = alloc_iommu_tlb_flush_ghcb_pages();
+				if (ret)
+					return ret;
+			}
+		} else if (atomic_dec_return(&sev_tio_devices_num) == 0) {
+			/* Do cleanup or leave it like this? */
+		}
+	}
+
 	/* __sev_get_ghcb() needs IRQs disabled because it uses per-CPU GHCB. */
 	guard(irqsave)();
 
@@ -347,6 +396,42 @@ static int vmgexit_psc(struct ghcb *ghcb, struct snp_psc_desc *desc)
 	return ret;
 }
 
+static int ghcb_flush_iommu_tlb(struct ghcb *ghcb)
+{
+	/* AES encrypts with 16 byte blocks */
+	unsigned long s1[BITS_TO_LONGS(128)], s2[BITS_TO_LONGS(128)];
+	void *p = this_cpu_read(iommu_tlb_flush_ghcb_page), *p2;
+	struct es_em_ctxt ctxt;
+	int ret;
+
+	if (!p)
+		return -ENOMEM;
+
+	/* Keep patterns apart far enough to not share the same cache line */
+	p2 = (u8 *) p + 2048;
+
+	vc_ghcb_invalidate(ghcb);
+
+	BUILD_BUG_ON(ARRAY_SIZE(s1) != 2);
+	if (!rdrand_long(s1) || !rdrand_long(s1 + 1) ||
+	    !rdrand_long(s2) || !rdrand_long(s2 + 1))
+		return -EFAULT;
+
+	memcpy(p, s1, sizeof(s1));
+	memcpy(p2, s2, sizeof(s2));
+
+	pvalidate((unsigned long) p, RMP_PG_SIZE_4K, false);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_IOMMU_TLB_FLUSH, __pa(p), 0);
+	pvalidate((unsigned long) p, RMP_PG_SIZE_4K, true);
+
+	/* Ensure that the host change is visible */
+	smp_mb();
+
+	if (!memcmp(p, s1, sizeof(s1)) || memcmp(p2, s2, sizeof(s2)))
+		return -EFAULT;
+
+	return 0;
+}
 static unsigned long __set_pages_state(struct snp_psc_desc *data, unsigned long vaddr,
 				       unsigned long vaddr_end, int op)
 {
@@ -404,6 +489,13 @@ static unsigned long __set_pages_state(struct snp_psc_desc *data, unsigned long
 	if (!ghcb || vmgexit_psc(ghcb, data))
 		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PSC);
 
+	if (atomic_read(&sev_tio_devices_num)) {
+		int ret = ghcb_flush_iommu_tlb(ghcb);
+
+		if (ret)
+			sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_IOMMUTLB_FLUSH);
+	}
+
 	__sev_put_ghcb(&state);
 
 	local_irq_restore(flags);
-- 
2.55.0

