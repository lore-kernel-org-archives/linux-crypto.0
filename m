Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012038.outbound.protection.outlook.com [52.101.43.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C09923BD1B;
	Wed, 16 Sep 2026 11:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559619; cv=fail; b=NnSS/5Pfbe/uONpwteUGMjUxlqzZSqCLE49+ECSFUUFoXYKsSmQtG1TzGTKbLj85pQeQArvq6SwCCpn2WJ+BfjVLjWh8yxK6gmLfcitFWMkB53a4b/sah+ZHEGvIJXa4oEfDTBY1uop7cSHVVrZczbfIW8E3EaScPqtrgH9mTdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559619; c=relaxed/simple;
	bh=QFmYmpaqQ/mz3veR2cECFGzP8rzAaLXXJFyquET1DPQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8+D1uIy7p0i1Rp9gdXH+sPBy3xLKW9sRnQgjZ+FPpYPUQqVlfESI7wU+G3g9mwQTHYTc/qOUGurkOWNx7wQegvhwsAewW1RQCMVVJxG2Hl546N+Og6/NNDrwDSfVdq9sATBe0Ket5TrAVWqicRXjtf86upPo6ffQkq0vx3VooM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N0hikTVZ; arc=fail smtp.client-ip=52.101.43.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N0hikTVZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DYBwkp72ulVUxF0lRt6GqSmvMXRJuEgchxPBZV/zlmhjFqryWjHMaYuPxYbaNEDnO4QJks2xk+oc9A9ndQr7YmFhO+NF055lbq0zdSj7NpghIoxft6CM/AwqJ7STor8ECQhDY863hoe56iY7QuqZIM97lBhkNg9SKq29wTy0wiw9s++TkF7B6zFbMvVBVvAj/NHVbEdLlWLM/j+NR67vn8g1Sf8o1NlAPy0TEbNNyCy1Scgj8r+Hx+P3GGavevg7NfeXesR9NPGOyW00QWVftoO1tpwsv1sSCEh+B2fV6elySji0oGLYe95aAyYxHDKAy98SCchlKTkzpkdaqKFjRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SY2PXIfdH4gQPL2ZLaN4rYd0hBg60SV0RgUb/GbX15c=;
 b=ULct9KQj2LIhQ/B/hbSpdfU0x2GV/D2bWqLj/X1urkO5IZ0QSHU71OHI17z+INNJnIJzalFrcBRmNvkI7J2m8/GrbMcJbOGYdS5XqTEaDe7YB+O8bx/yGrGa6r+QfHZ9ZqVLOYQe6uxFVPIJJOGdeJODKbpCiEYmTQuh2qpVenYQ4dwIXHgF2O08hMAMEwzoPi2ZqHkDTq+pqTHCMrdXTz/Rh40AmQzwbMjU2ifmLIFtGmRI9Y/GuJEVSIfzmNeVnAKMaT3wKva1auS9TFNtbhGKSl76LJCT4cwmNI25BkNiMdgtbOSeJX3HJDfl46BTm/Jl0Ko7zFWyWEY4XohYUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SY2PXIfdH4gQPL2ZLaN4rYd0hBg60SV0RgUb/GbX15c=;
 b=N0hikTVZLLlKQRQ9LljQNzVBYbzKHH0cYxZSKI6Hs7pNoviNSEjKHhzWdLDlHjsbn73c0xoZU6VRevsCcGmPydi7mrdoPBzv5blnhya4oMO67gLF4YjYQYkks0qMDyMH3CTQuolNJzfUJ/MBaLhFG8bA5Ui6P5aQl5qA7zDvPmg=
Received: from CH2PR02CA0009.namprd02.prod.outlook.com (2603:10b6:610:4e::19)
 by DS6PR12MB152050.namprd12.prod.outlook.com (2603:10b6:8:410::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 11:53:13 +0000
Received: from CH2PEPF0000013B.namprd02.prod.outlook.com
 (2603:10b6:610:4e:cafe::6f) by CH2PR02CA0009.outlook.office365.com
 (2603:10b6:610:4e::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 11:53:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000013B.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:53:13 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:52:49 -0500
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
Subject: [RFC PATCH kernel 01/17] pci/dma/tsm: Call disable DMA bus hook on cleanup
Date: Wed, 16 Sep 2026 21:51:41 +1000
Message-ID: <20260916115159.1938195-2-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013B:EE_|DS6PR12MB152050:EE_
X-MS-Office365-Filtering-Correlation-Id: c368b172-fea0-475e-27fd-08df13e91646
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|376014|7416014|32650700020|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lTbYfoL+zluMIQcZMX9c7spGZjQpXCynFv3y/cznROcYIxht8DJBw5ZLo8zGEnnTVHWw2qAb7J2BwF5bOjDhq2N7DkQjd+elST2JCWUXpyO/R7ixu/Y59GDjQCR/uX8ZJ+hoCcjGzuqzxqwPZXIA6Hk7NfEDjKLWbuLEDawfl+W/8sniBWPuDo0SLKRlToGBM4tAHn3wgj4XNq50zxnhK9OWU+/Uz7JOxe0eq8qmeAsPXaKRemotGofnQnu8ao7ULnXSqcvYntuzx9WaCWFn78Y/xe3xyWBxlXjnLOeKMRPYU8Awk5LhRYyxlO8X4icA6IA0TovktSJsx89DNS2jZ+rz2QQocNbqmXHIPUjolM7ehwfHWGGircyk9GCfbwD5P/dinhquBfDUpmQOaBvDs/hVTZdaGTRt4GjnIM16Z0Qh9iKRtXw83BfMmVUMpUWdhLJDb4aAgV/tvLtChQNrN/M3QS+2TyYtxV4Mr6aAhHGRBzZZ9WhPAwr2MBDMzjUvo/C9cItn9SfcwirGV8FnAJQ8SrGXwK/w3dUgRGcXKqar2Hycqq4M/oDb1C4fmeZKQ/PM0JxtOO3H6wDkXhq7aF/cV6gI7TNZEN09Ydt6mnEzfpGmAI96cLvtJ8/t5fmTuHmALW6bARpQlwaLinJNEk+/A9eLsr+jqbuksFvGyT8YqV17Z36rwxQPVGoerdCHYcA8GGykuJuX3HK9WyMQSg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(376014)(7416014)(32650700020)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8Car1z4HpXq9pf9mgugQAiDX2M+RvASwLDL9yQIeM+kN/l86aDUJkLlLhXbA7h5FyKBkYdpkEvfnzFtAY1ypdABOLbjCcnRxFBKj2AqHYp3MJJkkxZp84M9m9JgKaBp3rXD4byWsdFprofXiibB3C/Aqe5xf/4+mDSyGncGAsfcoYA69DAfAmCeT0Weetem3fMELGDOK5EChaoFW5WWc17UwY4vkz4nFMdZngDqMXJiDZL4Jz7mkbzgsggHXldh7RY6AEc9zJSlma77wuBATEvSpwK5DjBoSX/o2xKHp1XmL2zF2qZ3AVtfjXHVaJg3js5x2DOxzUGU7365U9zN119sIeHjs9Wk0BELZkps29710E9Z5yecIj4dG6BrhgdrlFzWsRus8rYj7S96/IwFvQzh7ArrzAIHx3s8UCRtb/sMfMykBapwtCYQpoVQ3QXGs
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:53:13.1361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c368b172-fea0-475e-27fd-08df13e91646
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB152050

Since XXXX ("PCI, device core: Add private memory access for DEVICE_TRUST_TCB")
the TSM subsystem relies on the PCI subsystem to ask the TSM to enable
DMA.

That misses teardown path to disable DMA, add it now.

Fixes: XXXX ("PCI, device core: Add private memory access for DEVICE_TRUST_TCB")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

Squash into "PCI, device core: Add private memory access for
DEVICE_TRUST_TCB"?
---
 drivers/pci/pci-driver.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index a036f3d7e6d5..633926b55da6 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1739,6 +1739,9 @@ static void pci_dma_cleanup(struct device *dev)
 
 	if (!driver->driver_managed_dma)
 		iommu_device_unuse_default_domain(dev);
+
+	if (device_tcb_trusted(dev))
+		pci_tsm_disable_dma(to_pci_dev(dev));
 }
 
 /*
-- 
2.55.0

