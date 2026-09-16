Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010017.outbound.protection.outlook.com [52.101.201.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726DA4E56FD;
	Wed, 16 Sep 2026 11:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559576; cv=fail; b=I4T08/Cg1/TwNQ0AFJKa953y1hORy6RHZJ3nSnRPB6amD8L1e9kPA3j6L/I+3A5QjFn33Q7NLcExE+skuKsC/wCppkx9JtLumSd9f2aJeTxITF7xvkVNRm9cedKmvc5Cif3ekDTbHQnZbjV4Cq04iEvmq42rw0xA/OO/+r9976c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559576; c=relaxed/simple;
	bh=DHuKzZrVCY/cPgXKUqBlCpppGQ2Ga+e0srYArs8fJdo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FlijSGtrw7qHha6VwlVolgZsBi82NP+DBE0EtLnBjZY382CVd/TX6q8CtlmqI11Z7XLONUPd6osXCq5Dwq2oGilU1b7GpixkM7UCMBcUdmy+1yqzCkCiDX7qaSws6u4YEwg0Y1uLlUU4vTPWs77nwQ+vqWLrScT5ylg894IZaxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TYb0b5xW; arc=fail smtp.client-ip=52.101.201.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TYb0b5xW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aG0oKHb8KcEdre+rK3In8EAAqhdVUmF9VvRw6NPuPrlGrqPlvJPLzycguBO2noWHblZKBztH6x0PTeRAIrNfo/FpZQhkGtE6TprWRpR+ankhY0Sb5NVTSp8OB0TsfwRe1wR34gNExtL8rMQVZtY0WVlYqAev9TLoyn8+fjF+tErqAlqXMQ6QaChgVBOe+FHNUOdFQtBVCZnDV7xdAVyT5RA8NUbNzytuhsjQ2QVS4uT/x4y0xn/YQEwASNyZ3/qCOIOJoXazBFPW4b9h4kcue6fkaKWdAiUhfg0gCYUPi89mn6ssnZCOXYzl2h2M3N6O6c0ARXSiUxHJeyn6Ynu7BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZx62VDeT0ufB+RoQyhNsYub6vn+IMt5N7ocikkQ9sU=;
 b=FUyNkmAgjoL3/Qs+3F8bOdJWZRxxAQSwJW4szhpjx76WlA2EdbNX7jtMV4pbjd6iC91k08D4iBb9j8AgeMohTuau1FzNyZt2pgMNrR3k7wEhCceWhRur0It9nkugCoDQfECZ/QHNEXl5jVGK9zQfspiclLtQPItvb1RkcyDOMSOeazpPRKoZiKffRGMnXBwgNMPwDdqq7GrZVoEa2hiF6nXWgC58+c0tDXJtUVpRjwHqUBSf7xfoY9HeBUajjbck/1j+ocf+2OW94VtyszgXGAhvPMbR2a17/AFehv7xqsqmqP2D78ATc4RhwLcSfrFMBON46FvV0aHG6+MLdveVFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mZx62VDeT0ufB+RoQyhNsYub6vn+IMt5N7ocikkQ9sU=;
 b=TYb0b5xWa3CwbsbXaROqwWacW3UnsWZAsLXCBsuO2VZj3iXs8h7XkGDWJzHS+Rr4NOgL3HVseZVrYfoYjT+MEH/NbZvmfhn1kvBEhxyM6OmIB0EJdTl5EhLqRsxHyVePmgg7X/cEjYvCt0uElsJXsLaUetdh0Zp7OnwDJk7C+7o=
Received: from CH2PR17CA0024.namprd17.prod.outlook.com (2603:10b6:610:53::34)
 by LV3PR12MB9119.namprd12.prod.outlook.com (2603:10b6:408:1a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 11:52:37 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:53:cafe::4e) by CH2PR17CA0024.outlook.office365.com
 (2603:10b6:610:53::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 11:52:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:52:36 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:52:13 -0500
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
Subject: [RFC PATCH kernel 00/17] PCI/TSM: coco/sev-guest: Implement SEV-TIO PCIe TDISP (phase2)
Date: Wed, 16 Sep 2026 21:51:40 +1000
Message-ID: <20260916115159.1938195-1-aik@amd.com>
X-Mailer: git-send-email 2.55.0
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|LV3PR12MB9119:EE_
X-MS-Office365-Filtering-Correlation-Id: 7391569d-ac2a-4616-69f3-08df13e9008e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|23010399003|36860700016|32650700020|18002099003|13003099007|3023799007|5023799004|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	T/gKaq7XFEnBi/yuOuXBHIHCD7TNUzO6/LsGHGpb0VdFnhOacL7FQW1YWREUJE4JArQUEVm1ccK17oYVI1nlQOwVcl/+SkFGawQkgJDJaZ4qH1D/uIlFGDhiW1/d74DByXinxZnIkDQYj9FGXk4OOKJ+kYv/d+CAgG/PTWX0UzZ/Lp0jxAQbHs0Dyh/2BKLQqGx6/d87Tw12FdpCH48IcuKsPZwqk5G9T+klwO3fX8+XnXeVDGfJzW1m5NX1LnPISZhnXsO1uvc3KjxwqC2Ws3B92AV1byfml134mscouKf/eQr8L/BZGaOFkoksnlwWnjD9lH0mPC+uYD4fmIH/V9QWuw+a9tH/N1wA7D6WVBzjww7atU8VJyL+8XzaMFb2qtdJHbhuqCMaB+z8zwC49JfgoEPtAu0mlkYGGFxSu1TzrPnUKfMf62FtDWqwnsNj+u/4ijrmb4SDCnyuz/6Z5BsgMBwCnB0FOHo2HxPuIIO/mnWIVAz+NpBP5CW+k+EC5+76SALy+Sdr9vQ3wwwT8Jfd5sNrI69QlA0aSM0wKMl/u8/LnCLD16kj9JQrN6WPJvPTYouVAb0XPd8oICcFGbiT83qjuJrhursHTFxWhZkq9RUKjqw8PtitrmDBrh8LUAuK8iS9K561fV/OmR7VSuUhBxxDeAcJFprd3/YTi2LlHtvo9PNlxcIYxGV3Ppv25ZrBkRpchcUBXVADUWXLhA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(23010399003)(36860700016)(32650700020)(18002099003)(13003099007)(3023799007)(5023799004)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+PlvSj+WWJdnQa9fqspJ0fGqU+h8yDsfBtjgrmCFlifW3rsbziq4yuNPQQyR/FXWEZSSp00sFYlutVZKzH62lMegd/JbzlYn/hpN78cr2SasoVm5fd/J4xz3ACrrUADNDus1kHqqqKweQl1XkKAuyyjZFggKvacCQoEX2+evG1kj/d82Fq/frgLm/kuBcCvch7vryn1qSGP2AV5fgGB6MD44u054gmUCHYZ5J56mDlJHDsaimg0mgKICWykgf5Qrzl+6gXxuOP4oouH0O8q6rxFwhevrd3K2x79h5jdXml1nC+XkfEUmXRGj3ewK399oB19ERF3hI9KhQsBGCljTGcXTZww+3pXfxyI/qyphgkPNRR1m+v+1Meh6DZkmrq0nPl4K1ltrTht/7eWVnESEApX3Cd54btZQ1VkXv4eebynsR510gjyu4rP54UQmEU7W
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:52:36.6991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7391569d-ac2a-4616-69f3-08df13e9008e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9119


Here are some patches to continue enabling SEV-TIO on AMD.

SEV-TIO allows guests to establish trust in a device that supports TEE
Device Interface Security Protocol (TDISP, defined in PCIe r6.0+) and
then interact with the device via private memory.

In order to streamline upstreaming process, a common TSM infrastructure
is being developed in collaboration with Intel+ARM+RiscV. There is
Documentation/driver-api/pci/tsm.rst with proposed phases:
1. IDE: encrypt PCI, host only
2. TDISP in guest: lock + accept flow, interface report <= WE ARE HERE
3. Enable on host: secure MMIO + DMA, KVM changes
4. Device attestation: certificates, measurements


Acronyms:
TEE - Trusted Execution Environments, a concept of managing trust between the host and devices
TSM - TEE Security Manager (TSM), an entity which ensures security on the host
PSP - AMD platform secure processor (also "ASP", "AMD-SP"), acts as TSM on AMD.
SEV TIO - the TIO protocol implemented by the PSP and used by the host, extension to SEV-SNP
GHCB - guest/host communication block - a protocol for guest-to-host communication via a shared page
TDISP - TEE Device Interface Security Protocol (PCIe).



Flow:
- Boot guest OS, load sev-guest.ko which registers itself as a TSM
- PCI TSM creates sysfs nodes under "tsm" subdirectory in for all
  TDISP-capable devices
- lock the device via:
	echo tsm0 > "/sys/bus/pci/devices/0000:01:00.0/tsm/lock"
- accept the device via:
	echo 1 > "/sys/bus/pci/devices/0000:01:00.0/tsm/accept"
- load the device driver:
	- DMA to encrypted memory should work right away
	- Reported TEE MMIO regions will be mapped as encrypted


Patches 01/17..05/17 are fixes and can go in sooner.
Patches 06/17..17/17 are the minimum required by the VM to get encrypted MMIO and DMA.

Doing "io_tlb_default_mem.for_alloc = true" in swiotlb_init_remap() enabled T=1 DMA
to shared guest memory.


The previous conversation is here:
https://lore.kernel.org/r/20260225053806.3311234-1-aik@amd.com

This is based on the last Dan's patch series rebased on top of
v7.3-rc2 with the DMA SWIOTLB fixes from Aneesh.

The whole tree is here: https://github.com/AMDESE/linux-kvm/commits/tsm-next/
The host support is here: https://github.com/AMDESE/linux-kvm/commits/tsm
Some raw QEMU sketch is here: https://github.com/AMDESE/qemu/commits/tsm-next

Please comment. Thanks.


The SEV TIO spec:
https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58271.pdf



Alexey Kardashevskiy (16):
  pci/dma/tsm: Call disable DMA bus hook on cleanup
  pci/tsm: Fix stale comment about TDI report range start
  tsm/core: Store range_id in pci_tsm_mmio_entry
  crypto/ccp/tsm: Use TSM API for DOE
  tsm-core: Register nevertheless
  x86/io/tsm: Allow mixed ioremap for shared+private BARs
  x86/dma: Revert "x86: Remove unnecessary architecture-specific
    <asm/device.h>"
  x86/dma: Add ARCH_HAS_PHYS_TO_DMA
  dma/swiotlb: Force shared DMA for allocatios from SWIOTLB
  tsm/core: Add TDI status
  coco/sev-guest: Allow multiple source files in the driver
  x86/sev: Pass HV features to sev-guest device via platform data
  x86/sev: Add GHCB calls for SEV-TIO
  x86/sev: Implement guest TSM driver for SEV-TIO (phase2, DMA)
  x86/sev: Enable secure MMIO (phase2)
  x86/sev: Flush IOMMU TLB for trusted devices

Dan Williams (1):
  x86, dma: Allow accepted devices to map private memory

 arch/x86/Kconfig                                    |   1 +
 drivers/virt/coco/sev-guest/Kconfig                 |   1 +
 drivers/virt/coco/sev-guest/Makefile                |   5 +-
 arch/x86/include/asm/device.h                       |  13 +
 arch/x86/include/asm/dma-direct.h                   |  77 +++
 arch/x86/include/asm/sev-common.h                   |   3 +
 arch/x86/include/asm/sev.h                          |  13 +
 arch/x86/include/uapi/asm/svm.h                     |  43 ++
 drivers/virt/coco/sev-guest/sev-guest.h             |  20 +
 include/linux/dma-direct.h                          |   2 +-
 include/linux/io.h                                  |   8 +
 include/linux/ioport.h                              |   3 +
 include/linux/pci-tsm.h                             |  71 ++
 include/uapi/linux/sev-guest.h                      |  12 +
 arch/x86/coco/sev/core.c                            | 148 +++-
 arch/x86/mm/ioremap.c                               |   2 +-
 arch/x86/mm/mem_encrypt.c                           |   5 +-
 drivers/crypto/ccp/sev-dev-tsm.c                    |   5 +-
 drivers/pci/pci-driver.c                            |   3 +
 drivers/pci/tsm/core.c                              |   3 +-
 drivers/virt/coco/sev-guest/{sev-guest.c => core.c} |  25 +-
 drivers/virt/coco/sev-guest/tio.c                   | 725 ++++++++++++++++++++
 drivers/virt/coco/tsm-core.c                        |  16 +-
 drivers/xen/swiotlb-xen.c                           |   2 +-
 kernel/dma/direct.c                                 |   3 +-
 kernel/dma/swiotlb.c                                |   2 +-
 kernel/resource.c                                   |  63 ++
 mm/ioremap.c                                        |   2 +-
 28 files changed, 1249 insertions(+), 27 deletions(-)
 create mode 100644 arch/x86/include/asm/device.h
 create mode 100644 arch/x86/include/asm/dma-direct.h
 create mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
 rename drivers/virt/coco/sev-guest/{sev-guest.c => core.c} (97%)
 create mode 100644 drivers/virt/coco/sev-guest/tio.c

-- 
2.55.0


