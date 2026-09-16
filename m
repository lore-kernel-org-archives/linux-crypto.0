Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010005.outbound.protection.outlook.com [52.101.46.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F8A4A4857;
	Wed, 16 Sep 2026 11:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559738; cv=fail; b=EMTkcWkJ4fCLsL5a4jymp+r3AgYKu4T0T+gtzhaKt2GSQCuGg76+gtLXF9JD1/th/jQzi2yPn9OP6p5u9LF4ZJBB6IBTyXwleKMdWWhUXpJvtKD6p0XA1LFCg1+BFoelkY/3rJ45YCa/8Ev2X8I31oDMPSldf6k1725WEhyefOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559738; c=relaxed/simple;
	bh=4iQYlcpq78MJm1DYBCcFoi/vcvnnxeFr+DuzszbyJh8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9PjAkx1vBz5ZnRleUMPmrST0K2O4ezbcl3tWAOK7W56SQT/exOTMZUHcUjEF27DYr/vAeNS+o+AQI/5RMz46CrA6vKNwlSiNbeUSmfd/La7jCUuzgDs9PZCD3LxA5O7acrvaLopGxCawHv1cV7J0mHEvlRVXxv1eOg0IPx8mLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hJHVgTgw; arc=fail smtp.client-ip=52.101.46.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hJHVgTgw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TZy2ZJrkMF7OCH9yN7sKyjTdWF7pgDVN6EGs0NLiBABwnnfINtahWOBYqwOz/NWr6N0AN5xk3KZ9gnYsR5DRJMFpXYxh6z5BOA4SqDov1+Py1rv1VdX8JfLWi2Iu9VC//4ZTsve+l1KibkrziEneP494mzlK+fKQ8Y6ZYsA72HeYMG2Hr2hrH/eH1tEk+QrUFUMbjHI1RdRPodHPy4kbR8OzqIx9MnVk7cuU+a0TdPj82AuZaqRcYaxYTHwARqMM06dsFTyWbujX389/moTRtNEA9l6ZTCBwS/3FOhSuXIjxLzfOGe+Ae7jc9Z5xx92b3zLyVpM45P9ZGWWrKZixBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fOSelVshB8tt+z9i3a63f+uWxxjJMxzG7NNd33A9O0=;
 b=jvahsYYrSSADIREzYZklS3cfIwMu0Zmjl3U5BvdwOD0bHjS79vNZLV1090cMPL6Uddm1Hw+ha8DsRIl6P3D7x0Ofg7n5e0eXwx40OjAREYnsDswkBOv39tT7q/bKNNpUmqXWpuNLksT0urT9O7eswM+0t9pB45isrHcK6lFqM8UdcQiBDw4Vb33gF6dsB3eyhqYeP32eJFGEnfmG5DILEG7wekx+bPb9r8qXvsuX1N7LC/toA2ovW1QUEOVq6z514RTOhjhfZBxnBBRn+Dlr186XJ+X6ysknfcEZXH08zx1mABhTDn64ZziAWAzDtRO8T9+PFyMF6nB9sRZuzltbiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fOSelVshB8tt+z9i3a63f+uWxxjJMxzG7NNd33A9O0=;
 b=hJHVgTgw40xSH04nc9KEY2kTfcBikFvdZzQOK6y8fFdlPWQ206tziMwKbuHLq2YsQdsWnXpxBJBN+nC+uIlM7TQItN4B4LBXEVkNpnzIbo0qAVLlJlMgBl/jaNSuWF8TLglwQGLQXYoBSkSvj44AiMmqUoZVh4d3hV9YFqdWZsw=
Received: from BN0PR04CA0192.namprd04.prod.outlook.com (2603:10b6:408:e9::17)
 by CY8PR12MB7267.namprd12.prod.outlook.com (2603:10b6:930:55::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 11:55:12 +0000
Received: from BN1PEPF00018545.namprd05.prod.outlook.com
 (2603:10b6:408:e9:cafe::a) by BN0PR04CA0192.outlook.office365.com
 (2603:10b6:408:e9::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 11:55:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00018545.mail.protection.outlook.com (10.167.248.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:55:12 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:54:44 -0500
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
Subject: [RFC PATCH kernel 04/17] crypto/ccp/tsm: Use TSM API for DOE
Date: Wed, 16 Sep 2026 21:51:44 +1000
Message-ID: <20260916115159.1938195-5-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018545:EE_|CY8PR12MB7267:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b0368a-0e2f-42c3-de47-08df13e95d65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|32650700020|1800799024|23010399003|7416014|376014|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	78xBYQC3+wj95ztS+jhBh7cicxBkBZUOOlFcfH+bxAVFisXGI8GTXus06sBoYkM4BHUkb5zK5O7yhQwpaF6Ip7ekJl/G+pCPCtnHlkIbjjDv8+KUNHhK+PJ5RhP6SlzTgoe81C/Eh+DyMDQXye78SzFJwQW40rgBDQmTb9VchioXMTf4z/5CzwrtVTOPqbyMg+Y8jjHpiDtfFf8zitapJgCESsXZOSM9HNHyJ0Um1NQ7D9s0uHUfcT/dzxDylcymM2S+Ld5yStPeE7mCxLl6qhrLFr3BSHwHwIQKghVjXLTcDnqt3GYaRiw1yz3V3OyeUjtuGPCVf3AbPcfXsEjBmGX3h2tdEuTQRVG2yu5p2hVO7DHZiUoLYTEA8rUsbspBT4rewvZj80kJwOFeoOC9mrD53/WOfp4jUrKfPm1SisbB+kyVpNsgZZv5etsg5Ftvdv2z1q+jSldsTRs0LfdHF3TNYwTFEs1O7ZDtHQkyvUMGi8Wd0Q4cAhiexEAvh9HeKXdpy7ly9noT4dc7jyjth76Lc412wIb3GxzcBx4uGvx9TbHy30dbUYFWfGVgiRyJ4kKr6lWWtTrwgeUS8GP8q2WbaMspMBnT3PljHdlQYUHCU206jA3P1Ax0KDSFRZmCQHobtyHO4o9tJVYCppnHdmpteVaf6qX9JvzuwR/35nR2qu87SdsvzIJ/RRzcLYid
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(32650700020)(1800799024)(23010399003)(7416014)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2+d9WKfuRzwiWgMdluOVo4qJNhnH2FvmuZhqqjP8Ga5RudmSdxm4o30kD3JGM+JEJhea7Mw6INW7XT3nm6ypzdPviJMk9OK4Pvzn2FWUxcA7Vdl/e56ub2ci729tDDVfvh9CVw61K6ffH4bM+JOXA9hNl5odzX2HLX/1echQ9gdSp7MdJwUJI64mKFNnvbf9aUbAqNw4+4SJCg+XD9XffbZf6fjl0LBtuDu0HjfarKrIabaGlv54VhQ3oyYEtE9psLNTPckbXz1N2avdxAcXqsvWJ2kLmfkkwZ5KVqB55EFLafOAfCbw5IMEhQaZWZfVjmI54+4RWFQcol/rYF1TFVzsYPTn+eBGFcEeCuS6BT7+MsDtPowlpnYvJ/R4X0x3YM5wuUYpDWv4dKXLhb6UuiqPb5UM6Mz5WR/m9mvvSwqSgI6A6Nq+5hSnCXyY+hAU
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:55:12.4634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b0368a-0e2f-42c3-de47-08df13e95d65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018545.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7267

Compared to the currently used pci_doe(), the pci_tsm_doe_transfer() helper
performs a few more sanity checks, use that helper now.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 46f2539d2d5a..6e704ad239af 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -40,8 +40,9 @@ static int sev_tio_spdm_cmd(struct tio_dsm *dsm, int ret)
 
 	/* ret > 0 means "SPDM requested" */
 	while (ret == PCI_DOE_FEATURE_CMA || ret == PCI_DOE_FEATURE_SSESSION) {
-		ret = pci_doe(dsm->tsm.doe_mb, PCI_VENDOR_ID_PCI_SIG, ret,
-			      spdm->req, spdm->req_len, spdm->rsp, spdm->rsp_len);
+		ret = pci_tsm_doe_transfer(dsm->tsm.base_tsm.pdev, ret,
+					   spdm->req, spdm->req_len,
+					   spdm->rsp, spdm->rsp_len);
 		if (ret < 0)
 			break;
 
-- 
2.55.0

