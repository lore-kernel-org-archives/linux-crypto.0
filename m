Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010050.outbound.protection.outlook.com [52.101.61.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F175481FDF;
	Wed, 16 Sep 2026 11:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559692; cv=fail; b=CmZOWwnefQaMOqRotzwNYBP6GhWOJ6W8xR7eMi2umk4iLUpxLmOrXCZPPn4Cr9J4wtI2oBwqWXmTOsMDW+LpU/WpRSWwO/tjDLH8GxkQJlEl3c5g//mDgZ7T/8iKWQCAaU9q4FVyf+pCMV4awffj0yWABv+dti5afovanCRP9A4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559692; c=relaxed/simple;
	bh=TLz8I2wQFg+t9Z4CzbXwzBL8FcLjxiJB0k6NXG4SrRQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8jJr68lmFX2G1uJpsPfg/iSrqLZVIYVGkS+QlW0dvTcWtSUvFaEJ7gcnhTfrSGjQVk7ai5FnyiaMjsFXqL/y/mUGlFDpfvG7RNxzT0CE7QtK8y1UnpaL6kH4mFNWXpvoeFDMOrvKSEYkCP/4SrqZJkqRQKnZTLi9oA+UCBDgAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=H4qYp44q; arc=fail smtp.client-ip=52.101.61.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="H4qYp44q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Urn84h68Kv1NiW1kUjFhGSLpejB7pKDouEqo54M/qmMxqqUURd6ehj7mM9xpJoyNrMOyUCwditYWutF0X2+l0E9N6rbyp7n7T93fYm75aTFSiMm3PWzBQ+EzDba/ohbFoxZMLDEtYQ1KMmI8f5qJucPcqUgzNSHQSRCwKOJghCsJdwF34jAnX0AJGV7mjpTDuVJ835sAoA+8mt2dLoBHWmWxVbsPI9P5Pn6LMSuK6og9lrcTYvcgozQynqSEb07n+m9GO1XMQ/tOeOWdpd9q73+IScNGeTdee02ynit+Phwjbohxr+Vsj9onyxl/yw6v5FMtv8Fn2PQ7QgGYuWBOaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKUdPqVU6vcP8IIVfw9k2l6nR9BJplx9o3NZa4hjOck=;
 b=EDrGQU+zjyMIoBNBObg/r6jTe0H5NY8XWxArKdQBcDcekZYrh0UbRIh0tmCOcCfHp+dP6Wztd+oV40oofWIb4PFbFrxaTyiu/fxvMKTsdJyfUDuQBzh63awmNCIlzw2kxvb5izGceKhpYEkaujCzyL/utidKOJh+2vZjiyRqmTUXA9/cQePrUksl8uf6C0grj3ZJTzNp5u8EZzpUEviQPAjjmdTPZeGYvt8v8f/WO3Xzv8VITj5VSvEuFuOEads2rBd6M5Dm/XYx0+tsXPMX9v/5O/KZVSEJUGfxZpb+NPctjB7Uw3AuYXTo9rForv4T9S6RWtJhg4NX8Ej5WJRPrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKUdPqVU6vcP8IIVfw9k2l6nR9BJplx9o3NZa4hjOck=;
 b=H4qYp44qyY8gpvkWf1Ci8lBKgSKe4gGnaL0LZRKfWPHAKK1lwWWi+ubOgacGhxO5O1FzaozHGsrB/86eOm8Ue4BleHqQnDCWrO2eOb1cPtrNH5hsFjJTDNBzzppowIKl9d0/tzYyGSbtYSUiVlSk/3S/fYLmtLs6HF6Luzu27Rw=
Received: from BN9PR03CA0556.namprd03.prod.outlook.com (2603:10b6:408:138::21)
 by CH3PR12MB9124.namprd12.prod.outlook.com (2603:10b6:610:1a7::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 11:54:31 +0000
Received: from BN1PEPF0001854C.namprd05.prod.outlook.com
 (2603:10b6:408:138:cafe::7b) by BN9PR03CA0556.outlook.office365.com
 (2603:10b6:408:138::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Wed, 16
 Sep 2026 11:54:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0001854C.mail.protection.outlook.com (10.167.248.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:54:31 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:54:07 -0500
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
Subject: [RFC PATCH kernel 03/17] tsm/core: Store range_id in pci_tsm_mmio_entry
Date: Wed, 16 Sep 2026 21:51:43 +1000
Message-ID: <20260916115159.1938195-4-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001854C:EE_|CH3PR12MB9124:EE_
X-MS-Office365-Filtering-Correlation-Id: d59d45d3-0f08-439b-d6d0-08df13e944b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|32650700020|7416014|376014|1800799024|82310400026|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rI3FUyxtUsFrikLPRCWOe3jkIJpu8Ayez//FbHvA7EZPaqMJ28NzEM4VhJ4uFsUfHOrPAJb/7UHnkmYOiZsZByETBO7LqwDolMkGk+NuIkrgD4qgEv4RzEDqahiEUr6RmoqLOB4/nnuarOms1DULPJLjrKyDmeOUAEEoyYHWB5A273Gc3ieXPZf/pG8FYsRMtuGwuUM0kd2jypZAIucOFIPlseEW6Tidon+1+G+qvbnitCdEbepShhBJZCMdJvcbi2vS4qERdzgmPEUsJ3ylIy1Ob5JKPPqLHOQxCE0Qe2/CCLBuIYsjqzVwfGEXXNSuZ2BN207i2oGm20r9eqcOgEt3kaOz34+dHkchUmel6U3bjs2AQ+EvxIjcvZ+I/wsFwRJXZHaO71FmXafnt71PBAcdJEK6qVYfgqy2v5S3Uj+vyR+1IKmg6Rfr4z3YMDSg+ptuH+K9bmzONBteIzA0bli1GHUAA4BrfnH2iDkYHuBxYRfVK9Xxfa3cxTwYqdojQDJQ4wX9c/N0NYNBfz8h9ph3umCHa0RhWXWwSESKEBn+FZY+jNWIHHce+uQnoGNf7r5KtJkpLdjT8wtA4XS8UGoRQZRBGqToFDemJKAzlXlGC45dacLPHVyAKBXcIcQK1KSkr1cjUWaUbUoGTGzCb1wvFKZUGANi+ZFG81a1RXGumrPU+cxRi4EFst/iIx9UAMPQNzjE4joretksZWLINw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(32650700020)(7416014)(376014)(1800799024)(82310400026)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3PXzb1uIYISSNMY+R0m2gI1Golc9yZxyHNjo9mqcVW1iX+W8QOAgaw0Jx0+Ta1VKAjQN4QvuQJSWrTEiqdmnJWGdsiX9SXLTV7KsO1jkKL+RbUtl3rM6lse+vVwlHmd+IzaKPKUqMnAJwfSIsMv+aCwgqXOJHqF/H7s5tLLKw2PLKZUtD1ZyNYccxLICbLJnupx7vGu1T6MszIipxPfFngv9Ym+30x0Q2ajKbHjL0uPDpj7E5wgANp2xo3ZVGlO1/icucw65fAYiw3XHyAOEuraigI/3+qS1j8myjEMuJ4CLxEAyULrUad8gSQ6vE9GGBcTDKo8iENf0+SwfAW4PoJeJq0iP70PPpGHtspLqITaJWMzTVVn3E+S6NBglTQqsv+5r2fAzrn5fFPMMl+5p05yA4VJJHiI+sj+qmhIWaBwI9YGSh9HQT9Re3VgfsDTs
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:54:31.0614
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d59d45d3-0f08-439b-d6d0-08df13e944b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001854C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9124

The pci_tsm_mmio struct represent a parsed TDI report which platform
TSM driver will apply at the TDI accept step.

On top of what the existing structure stores already, the AMD TSM driver
is going to need a range ID for the PSP communication.

Instead of calculating it in the platform TSM driver, just pass it along.

While at this, set the flag as resource_contains() checks for the type
when pci_tsm_mmio_setup() inserts the range.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

Not quite sure if IORESOURCE_MEM deserves a separate fix;
also if it is just me who hit this.
---
 include/linux/pci-tsm.h | 2 ++
 drivers/pci/tsm/core.c  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 6d5fadd79360..9b34304d9a1f 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -161,10 +161,12 @@ struct pci_tsm_pf0 {
  * @res: MMIO address range (typically Guest Physical Address, GPA)
  * @tsm_offset: Host Physical Address, HPA obfuscation offset added by the TSM.
  *		Translates report addresses to GPA.
+ * @range_id: PCI BAR index for this range
  */
 struct pci_tsm_mmio_entry {
 	struct resource res;
 	u64 tsm_offset;
+	unsigned char range_id;
 };
 
 struct pci_tsm_mmio {
diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
index 2a18be5be56e..a197d56edbfb 100644
--- a/drivers/pci/tsm/core.c
+++ b/drivers/pci/tsm/core.c
@@ -746,6 +746,8 @@ struct pci_tsm_mmio *pci_tsm_mmio_alloc(struct pci_dev *pdev)
 
 		entry->res.start = range.start;
 		entry->res.end = range.end;
+		entry->res.flags = IORESOURCE_MEM;
+		entry->range_id = bar;
 		entry->tsm_offset = tsm_offset;
 		mmio->nr++;
 	}
-- 
2.55.0

