Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011041.outbound.protection.outlook.com [52.101.57.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA204E3EF7;
	Wed, 16 Sep 2026 11:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559870; cv=fail; b=SWMRYl2IkdVGR3ch1QT4vG5gqdKhZWiXmSMLvD5S2KOY177OU5kXaLVeEm/wuXc5BEiEbQt/Q2yTj1X5weGPDQMEkN8+qwue7CI23gwssh9yu+W7akn6gdYZGTnUukoQPlnQ+PPYL2IPyML76M6TZ5VwMW5ZseJfBFC9TUJPFtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559870; c=relaxed/simple;
	bh=woqbs4X1y1xY7vnSm59CXkT9eRCp7XBnc7O+RtawlVs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JY0Y1/N6sbQIlPiySq1owryFYgCnp+oMsV9xus7rThEO3vzZyrLDAlKEHHNanpfdYe/WqeNZb+zcpP1te9GuiqPkUnDTa0mcLRID1c3vKzuPVRenYgXb/UTR3JA9He3YP+8KcFAp7uDh+68SlYOs8LN9F0A3WVaYA65c188EAM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QV15anIu; arc=fail smtp.client-ip=52.101.57.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QV15anIu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e0hZQz2ly2aua2Z6ZGSh2w8G4Zwdd2zHDTyQNsPDeFJzZlb2avbBchHKRIOXzb49t7PxXqjLsMnzaMkk7mtwLM/MSNG/eUN2YuY2ZjLWnUIN6CNpo7+P9bHMduW9QiimGvNdsENfL4rP7XU8SjESAlIS89+aNYuw3/pWQ6YPX4O/Le0v01N/nKbEqP5EvHAXEXNM9Bl+TIqlTdwyCvWqusFJc8zKV9cFp0cUeeDx4gcQG4kMUHZCmrAH4HFysNBh7NJxP6vQnz15BJLDXqb5dasTR6R7xkNDD2KaeaPd0tU3D84yPwr+wql95dkgOJ8jwja4q4z8aClhEF0etnpgzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0HUBrkcanKP7HSIPLpfduG1GgH85AS/UaJthCpuaLQk=;
 b=PrcPtrvkgZBxuroIXC3TwasdGTxB/zfCXaknrPstK9/nn4DlIj4O3R46UmNjnE867EfRv87KVb+2+Ek6ExiZpz7H8KRK4Hp/rd6houOy+BH3W6EGiNGWI0Htqi3pTKjCvEv+ORDwONTxWGFFruqHaPMmV/LYCrjxKk+9zuDq81ZZ1Yg8DUkF5yuN4WTtg/Q007QLbOotsJvTU/OrPBQ4CF4HhO8SrRPlwIVcO+LU6NomEqyucPb9dSQTcbXuFyJPgpOb2k/vCCyUfPFO/6nV7egXG099zN1XXTFcnsgDQHgRbdDQdp8IKy3F1aG7F0mGze8isCWRW55dZbgpRO1N2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HUBrkcanKP7HSIPLpfduG1GgH85AS/UaJthCpuaLQk=;
 b=QV15anIuuHWTYLolbBMi91et8XL9OGeDIsQrAoRT8BFl+I1U6jsdYMCz49LJNt/7euLhofzeBxsUagwjxE1osQAWRXh/yDwOPP8f0+3eJxyytEMzYqrift3pJO6sgoiae6d2gbRDI9fDDd2DheM97h8Gm6RT6vrDPpzLS43byX0=
Received: from BN9PR03CA0273.namprd03.prod.outlook.com (2603:10b6:408:f5::8)
 by DS0PR12MB999311.namprd12.prod.outlook.com (2603:10b6:8:42c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 11:57:34 +0000
Received: from BN1PEPF0001854A.namprd05.prod.outlook.com
 (2603:10b6:408:f5:cafe::a5) by BN9PR03CA0273.outlook.office365.com
 (2603:10b6:408:f5::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 11:57:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0001854A.mail.protection.outlook.com (10.167.248.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:57:33 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:57:10 -0500
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
Subject: [RFC PATCH kernel 08/17] x86/dma: Add ARCH_HAS_PHYS_TO_DMA
Date: Wed, 16 Sep 2026 21:51:48 +1000
Message-ID: <20260916115159.1938195-9-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001854A:EE_|DS0PR12MB999311:EE_
X-MS-Office365-Filtering-Correlation-Id: 812fd5a2-86d9-4479-97f7-08df13e9b1af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|32650700020|82310400026|23010399003|7416014|10067099003|18002099003|22082099003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	er94ITmWcnhrxhyFDFF8CA+wo3OcaYsqyrxyg8FsjvHuU9hbYcOn8yKJ8P9I9a6kAmssaycN1S60pGL/85Hz40P2Y07GKdnLBbE5aVSU7yKOJVYRTTzYDXONwHdAkp4KT9WaO9miG8qHfYuT8tRDj9n/p3qkJ75f0No+LFoexZJT0FCSK4OkfEYmH+fAvHNKjTnPnRHf0yQkY9i/YusrSpYYzODNqRZr9mSzV0nji0rDuy+fePlMkEe84ddhFFrHerpO/T9UwzZzahF42KDd8jGb89oWkRgq4U3qITSWdUMaHAvuY0MiukKz5gIr7Fa6tE2IXZjjtFFppFObdpCvVX5cZaK8u7l0CTjr9W1wQSxnnW0QeATbOVHQ5x4Jh3cGweFoRUKk95W2kDUXQUYF+EAiXIKtRxuquILQfmN6CiR0qsZFtwaGlJbR0uxNpf2jwx/v1J4eBfVBXKJ0r/QgOdEeimbiCSdIN8ORGcl6HEHuuiZGCLNsR8f73a7pkW6ZLDDfMRpc7B+ErLCTbDprdxhqK0aojQFf0Rc77jk3pAO4gZEHm89HDWrJGQHGfnFhwpcs96sYMG7HdFlD8COwEtJahgr9ul2CHc3td1kr4/4ek+EHfVg2qGB6XMCprqcVrjFXZw0tpKqFIjfEFFDaI7erOOMW8RRzdbL4T0DsJE18W7TTmtoOq2zYwB7ISP025qzd68WvKg7mhqXECJaxIw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(32650700020)(82310400026)(23010399003)(7416014)(10067099003)(18002099003)(22082099003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Xt8sxNe21lwjTxCXMGse61wsz1HS5p7ZKAo4SfcdIkscuki7ds9IMSFXyuuHN+Rg+VAhJUDrULObfgnn2VVL75R3iStKXUY9kz1rH7C1OsEqT8PoH4W1aZrtox1ncrsG0LrgtMBr26FsKZgIni2keOEhhePVCe6WdFNrvJiLvQc9+VjtariGQ7y3M4iWyhQ29Zv5Vb8wUVIxiTEbZG7DVUzklH6KkbaFTdKBN4vSElKdJpOCIRl5LXgc03N5ZU58szdchfEgu1UsZJHbepmej50F+lrCm9Qb6F/HCmbkeSnaZWyEi6py/kqp8aRxZG8HdFi9quOamRi9EJ/lnCCmYXeEUwVx1FPKJrvDcXbArM+19SO/QbwysihNi7dbyYmLtw6MhD9o3UVYuFrCeP14A+jA1e6swbl/L5+yd+QuSCtmJRdIIsSwR3q/GNxmLRgq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:57:33.8747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 812fd5a2-86d9-4479-97f7-08df13e9b1af
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001854A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999311

Confidential VMs work with both trusted and legacy (untrusted devices).
The trusted devices allow DMA to/from encrypted guest memory while legacy
devices have to use SWIOTLB or share pages for DMA.

In case of P2P between trusted and legacy devices, the trusted device has
to perform DMA with T=1 (a PCIe IDE TLP bit saying "encrypt") but the target
may be shared.

One way of allowing the above on AMD SEV is using IOMMU sDTE vTOM feature
which is a bus address:
- below that address all accesses target private guest memory;
- above - shared memory.

Effectively this adds some high bit in a DMA handle to mark "shared" (on
AMD).

Copy the generic phys_to_dma / dma_to_phys helpers from
include/linux/dma-direct.h into arch/x86/include/asm/dma-direct.h and
select ARCH_HAS_PHYS_TO_DMA for x86.

The x86 implementation is the same as the generic code for
__phys_to_dma, dma_range_map handling, and SME encryption, with two
additions for confidential devices:
 - cc_shared_dma_offset and cc_private_dma_offset in dev_archdata
 - when TDI is accepted is true, phys_to_dma() adds the shared or
   private offset (selected by DMA_ATTR_CC_SHARED), and dma_to_phys()
   subtracts it on the way back

phys_to_dma() also gains an attrs argument so dma_capable() and swiotlb can
pass mapping attributes through. Update the call sites accordingly.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

DMA_ATTR_CC_SHARED or __DMA_ATTR_ALLOC_CC_SHARED?
---
 arch/x86/Kconfig                  |  1 +
 arch/x86/include/asm/device.h     |  2 +
 arch/x86/include/asm/dma-direct.h | 77 ++++++++++++++++++++
 include/linux/dma-direct.h        |  2 +-
 drivers/xen/swiotlb-xen.c         |  2 +-
 kernel/dma/swiotlb.c              |  2 +-
 6 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15fd9ec5ecac..c4df431e74b2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -112,6 +112,7 @@ config X86
 	select ARCH_HAS_UBSAN
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
+	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_HAVE_EXTRA_ELF_NOTES
 	select ARCH_MEMORY_ORDER_TSO
diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
index 7c0a52ca2f4d..0dbc2c125522 100644
--- a/arch/x86/include/asm/device.h
+++ b/arch/x86/include/asm/device.h
@@ -3,6 +3,8 @@
 #define _ASM_X86_DEVICE_H
 
 struct dev_archdata {
+	dma_addr_t cc_shared_dma_offset;
+	dma_addr_t cc_private_dma_offset;
 };
 
 struct pdev_archdata {
diff --git a/arch/x86/include/asm/dma-direct.h b/arch/x86/include/asm/dma-direct.h
new file mode 100644
index 000000000000..37074c87bbec
--- /dev/null
+++ b/arch/x86/include/asm/dma-direct.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef ASM_X86_DMA_DIRECT_H
+#define ASM_X86_DMA_DIRECT_H 1
+
+#include <linux/pci-tsm.h>
+
+static inline dma_addr_t __phys_to_dma(struct device *dev, phys_addr_t paddr)
+{
+	if (dev->dma_range_map)
+		return translate_phys_to_dma(dev, paddr);
+
+	return paddr;
+}
+
+static inline bool __device_cc_accepted(struct device *dev)
+{
+	if (!dev || !dev_is_pci(dev) || !to_pci_dev(dev)->tsm)
+		return false;
+
+	return test_bit(PCI_TSM_F_ACCEPT, &to_pci_dev(dev)->tsm->flags);
+}
+
+static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr, unsigned long attrs)
+{
+	if (__device_cc_accepted(dev)) {
+		if (attrs & DMA_ATTR_CC_SHARED)
+			return __phys_to_dma(dev, paddr) + dev->archdata.cc_shared_dma_offset;
+
+		return __phys_to_dma(dev, paddr) + dev->archdata.cc_private_dma_offset;
+	}
+
+	return dma_addr_encrypted(__phys_to_dma(dev, paddr));
+}
+
+static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr)
+{
+	phys_addr_t paddr;
+
+	if (__device_cc_accepted(dev)) {
+		if (dev->archdata.cc_shared_dma_offset &&
+		    daddr >= dev->archdata.cc_shared_dma_offset)
+			return daddr - dev->archdata.cc_shared_dma_offset;
+
+		if (dev->archdata.cc_private_dma_offset &&
+		    daddr >= dev->archdata.cc_private_dma_offset)
+			return daddr - dev->archdata.cc_private_dma_offset;
+	}
+
+	daddr = dma_addr_canonical(daddr);
+	if (dev->dma_range_map)
+		paddr = translate_dma_to_phys(dev, daddr);
+	else
+		paddr = daddr;
+
+	return paddr;
+}
+
+static inline dma_addr_t phys_to_dma_unencrypted(struct device *dev, phys_addr_t paddr)
+{
+	if (__device_cc_accepted(dev))
+		return __phys_to_dma(dev, paddr) + dev->archdata.cc_shared_dma_offset;
+
+	return dma_addr_unencrypted(__phys_to_dma(dev, paddr));
+}
+
+static inline dma_addr_t phys_to_dma_encrypted(struct device *dev, phys_addr_t paddr)
+{
+	if (__device_cc_accepted(dev))
+		return __phys_to_dma(dev, paddr) + dev->archdata.cc_private_dma_offset;
+
+	return dma_addr_encrypted(__phys_to_dma(dev, paddr));
+}
+
+#define phys_to_dma_unencrypted phys_to_dma_unencrypted
+#define phys_to_dma_encrypted phys_to_dma_encrypted
+
+#endif /* ASM_X86_DMA_DIRECT_H */
diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index daa31a1adf7b..616b66ccf322 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -150,7 +150,7 @@ static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size,
 		return false;
 
 	if (is_ram && !IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT) &&
-	    min(addr, end) < phys_to_dma(dev, PFN_PHYS(min_low_pfn)))
+	    min(addr, end) < phys_to_dma(dev, PFN_PHYS(min_low_pfn), attrs))
 		return false;
 
 	return end <= min_not_zero(*dev->dma_mask, dev->bus_dma_limit);
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index e2538824ef52..915c174f8b56 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -55,7 +55,7 @@ static inline phys_addr_t xen_phys_to_bus(struct device *dev, phys_addr_t paddr)
 
 static inline dma_addr_t xen_phys_to_dma(struct device *dev, phys_addr_t paddr)
 {
-	return phys_to_dma(dev, xen_phys_to_bus(dev, paddr));
+	return phys_to_dma(dev, xen_phys_to_bus(dev, paddr), 0);
 }
 
 static inline phys_addr_t xen_bus_to_phys(struct device *dev,
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index ded7016a46a7..d7c7d15740ae 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1764,7 +1764,7 @@ dma_addr_t swiotlb_map(struct device *dev, phys_addr_t paddr, size_t size,
 	phys_addr_t swiotlb_addr;
 	dma_addr_t dma_addr;
 
-	trace_swiotlb_bounced(dev, phys_to_dma(dev, paddr), size);
+	trace_swiotlb_bounced(dev, phys_to_dma(dev, paddr, attrs), size);
 
 	swiotlb_addr = swiotlb_tbl_map_single(dev, paddr, size, 0, dir, &attrs);
 	if (swiotlb_addr == (phys_addr_t)DMA_MAPPING_ERROR)
-- 
2.55.0

