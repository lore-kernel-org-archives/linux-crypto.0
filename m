Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247534D0A17;
	Wed, 16 Sep 2026 11:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559945; cv=fail; b=NuJgvdzdDOY1eN4WynpdzZlz6pC9v3GdvMLTRiWoY42SUdoWjcLTMU673nOfTr+9teKMWy2TmyI+6kz5FKxbKtJPxDYhChviZZVNaXxOrNfqQRQo3hR1AM10Yr8Nt86i2b8xOSXhKAvouyvq3EEEBDuhzNWpmh2uHoZU36GedHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559945; c=relaxed/simple;
	bh=cZxmKiA5gDpfrJnfuh7RgK6F6OQKyYMp7I2eA4Y1c/Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f+2BfbDpfjdyD4p3AGDlPzZMwFNM7iK9h06TjPqpwBORId/1CIDwHN06BX0uriJjErNMQlds4DeTmWbqpuL4pzP3QD9+KpANiv/ZHW2Qf4BWNF7Xic2oyeV35JkpNNYwMLSXTzi5pRtPytCJtf8cFwisKgUcbS96B9J1M/xtvNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KNHRx1/u; arc=fail smtp.client-ip=52.101.201.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KNHRx1/u"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seol/ZRYlk9PRV/AE/0igGP4M475B8bTrWiYjR7Z5NVQdKgQ8Snt2Iybu43auxQTLklLTDj+/czXGPucm0VRfzcuHZnrtWsnzt9fa564LGCuzyXYB2wboIBU0JiXD2tXbkUw4vznR7ZJdYwkqjhER+nCBLKlLXXLD77GbCUVxF55cBM98geU4KyUAbObpDwGwPlX7OUjvnyQ/ErVPhnYwe35LYF2lgl5JKmTc092duqdYS/xqXIz44O5hNx1ujjZtaQrsdxqobZsO6EZPAGhyMogjMHX3oHd0JDOqY35plSg988uH9TBWL1tdirm3lgBThESwB5WN07dH7u6fQsegQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uN3TtTwM+bwTehqyvzEhtWdo/9tbU5sGc+GO4ttJXns=;
 b=XlTCsuXfh6cbbhbZNEiVEITWSHaHxkZnjq0bBeBSI5S9g72kOw6XGGLeK+K4EWewm32H7VlSEd4nr9nUOHdWNETpfESYKdGCr2rAYiTPH207To88lFcUGwNjCbRT5kfB/PfJJXyvT9Em+8pJ3/kxdg7x61bbkpD3JT9YQtyIVXR5ilk5oujw/aNZ0uubZrZfPpO/N0oLeVTV7PmLE9i4C+BeEl2/6Slm/wxe2mDrFRJf9rojTe83MvrKt2jeWQn8nrZyd2tWkH35wRnCkyEjLproJIrPBR1lP5u2c2UEo9YQu/qPilPg/lGoa9Pjy7GmzZv5ehcBcrlNaEp9KYwiZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN3TtTwM+bwTehqyvzEhtWdo/9tbU5sGc+GO4ttJXns=;
 b=KNHRx1/uIQrLP/p1OqbUtpLgVwCk7UVtvYLpPsa2/jtKdsR4Vjqm3gQm0t1vp4EhK906ZcAgkkSaNp5GN9OT1xi2nBN7sRrVepy7neCrEzBcLk6mtscazitXsKE123nz5ng2gI1C17BYkbYjzOdNlcc5U03fFb1OlKx8D9A4k+g=
Received: from BN9PR03CA0782.namprd03.prod.outlook.com (2603:10b6:408:13f::7)
 by SJ2PR12MB8111.namprd12.prod.outlook.com (2603:10b6:a03:4fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Wed, 16 Sep
 2026 11:58:47 +0000
Received: from BN1PEPF0001854A.namprd05.prod.outlook.com
 (2603:10b6:408:13f:cafe::37) by BN9PR03CA0782.outlook.office365.com
 (2603:10b6:408:13f::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 11:58:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0001854A.mail.protection.outlook.com (10.167.248.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:58:46 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:58:23 -0500
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
	<ackerleytng@google.com>, Fuad Tabba <tabba@google.com>, Dan Williams
	<dan.j.williams@intel.com>
Subject: [RFC PATCH kernel 10/17] x86, dma: Allow accepted devices to map private memory
Date: Wed, 16 Sep 2026 21:51:50 +1000
Message-ID: <20260916115159.1938195-11-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001854A:EE_|SJ2PR12MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: c49f70c9-81ce-478f-dac0-08df13e9dd27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|7416014|82310400026|32650700020|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1bJ49a9trfumDwoyn9MewgHhdhH/vcO7H1vXItEBAR2GcC7Oz87Mn2l/avJzWfkRSChnShOjFI7hXwvbMP4FfIal/XfkCyAQO06jw07jp3OKH8Fv14GY6YOHfTvUSlnHRxfsxtpJfmrCwkr9GnKg5GXYolHH8kdXZuVQtH+PnHROr5jB+rRKZUZkw+jMKi6EB5sMFZve0dHPB2LyTXPZfcqQSwRzRnMa9JPAmrYk6BmjpPlY/zGIZMRL4ogIwgoaoBWgr2X3fJECn8xofhkS/dPlWE1gm4LGMM32AysHf5mzmXFzDVjFx/CzkJpupwN0nH8TVL9pWKTlpIbIQXDjaLx+FkjqAMfx3fzEL7R4946H7Hyse1Woyyf1+rbrQX6IFOCMqIQA75eNFofO3sWviWdOBrpPfr3KmGpt74PsgqnSShJAKfS1rBPn1YyDMZkLp8IRElEVCiFMgecxLvI7J7mj2+8+4z5F1jrSmVH0Pm+vouATGQfb5p4qKwJd5g31NtCxqwjL3sFapbwogiTa2xbrqJegMhJ+hMbhT1MYg0hV+Xn4w7KKLhnAON+dlxkAOXrgjAYJhDrg6VqYsK3x1ZmsmutuwzCbubbgs27aDBSaTnor7fzVXyE4z3gIdRZrtCPFmFIGs1Lxt9GqNBFoPs+7N5a4otqlL9gf7mHsWsJ4fS9vrcN8OM8srKTIfIU3IRe3qhs521WNeSWpaqmQQg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(7416014)(82310400026)(32650700020)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qK/f3bcE1ASam6x2JuApZeSzxgwli4lwEhb+EPtO5GlbcvqWi2n0k+nCmOHidWa9c57wxnSKyVw6rpTH9uNaDmg3oJNXlIBXvGR1R/KFN/gP+3nnPsanWwrd57y/UdARYtTQx0oclZLQ0BGPI91gFjNkAlX5ujD1fxxig+qClAg8/i1f9m8YX9y28sjNZGmBEwP33TPzxrpHnN+hFi9AJNhz+zn1fgjuz4xCrtBlZIiJKBNAa55ix5MqPrc/Hp0hNMUb1/YlmECGfzThwtN1CwLiUVLLQlBKO1fcb1JIi5Qgv+5uPUz+SYTP5gl8NeH5pRlAUwiBM8wDq7PFX6NC37IA+rMpo1xfWlWcVjunL8MiE56oFApW110XZtgRGjDSOijBETZIzUKDFueWDJ8SMcnlpUO0wFZzFrYSoIR3W1JjxXGiUODmzMgF+4duPdAm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:58:46.8022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c49f70c9-81ce-478f-dac0-08df13e9dd27
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001854A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8111

From: Dan Williams <dan.j.williams@intel.com>

With the arrival of "accepted" devices, devices that have been enabled to
DMA to private encrypted memory, coherent DMA allocation no longer requires
page conversion. Update force_dma_unencrypted() to skip accepted devices.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[aik: re-added device_cc_accepted()]
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/mm/mem_encrypt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 95bae74fdab2..805800ddbd79 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -20,10 +20,11 @@
 bool force_dma_unencrypted(struct device *dev)
 {
 	/*
-	 * For SEV, all DMA must be to unencrypted addresses.
+	 * Require unencrypted DMA unless the device has been "accepted",
+	 * enabled by a TSM driver to DMA to private encrypted memory.
 	 */
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
-		return true;
+		return !__device_cc_accepted(dev);
 
 	/*
 	 * For SME, all DMA must be to unencrypted addresses if the
-- 
2.55.0

