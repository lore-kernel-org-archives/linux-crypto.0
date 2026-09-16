Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012065.outbound.protection.outlook.com [40.107.200.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B963EB802;
	Wed, 16 Sep 2026 11:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559834; cv=fail; b=evv8v3dPh4rsCcOH2j07qkZMRnO2LqQNVvaQZoHIGp3WYtGzqGlwfjjePAWPd9dipY+s7czzsqztso1gwprCQUIsBrEuTEUVXr9G8PM7nw6kIYT0N3qxABGqG3NZ8E+iNqLMer5D2LeACa7soUwzRz+e+E1ZZ+3tWFaP8nd0TzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559834; c=relaxed/simple;
	bh=BJModVS+cADdJhqRKK0S1aFEdmuVD3rZQFvp2IOMaIk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INCkDgOorBJbrmsdKlv17qZ864N4HHyHdNZm16FMEyVDBCFa2lT3J31bmZPOT/Bi2zHlfqx//+1VEXCCMFcdF9l8LOdOrv3HDF1DvhuQv83iRjzK33G2cN9CLYtXbgVHvXoPdzKQxeKiz5Ve9BylE0tnakd09QKtWEswfIelc/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Gi07ps9C; arc=fail smtp.client-ip=40.107.200.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Gi07ps9C"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l+SiFZ7/hHfUrDLNpVjc22zytUw7mMLTkNxt2r69S/qdu0carYYohxObD3yjvEu5SQ+wuQB5XlBQtUYxqK23iFPpi97i/zOUOutR5bio1rYvBG7vh8eTJRa7JEw0ia8z1aSHpTYQV9X8xqC/ahDTR54v0kFasHb36sea796g42VVvgBkDCOetPJ0Ti3nNfTJvVd1PUzjB9O8r0JSoC7HMnvIQrSLvUt1YBqy1cqr9RBxrMuTan+xoxsIXP1WwomplLJ0+xvcYvBPi4OmcNiAP7EiSaA78S74jQsWh5GOi4LlWJkdJ1/y2eF7yfwSjql3kUPkYNY39HNyHj65MPauDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U59zJdwFWF8Dtpjn0ZNqO7P2OXSyW40uUqet0Z5N1JU=;
 b=wH4q8IqwEmW9neFuBRcBWVeDfcDVooZbJzAoYEaB03BZq8MFLpsUT9SNJK4/LA1+cPPHIA8UtaSQYE8Vz1RTVNIa9rfTP/fHer1KhXxX1lTaK/UzA3lhHh3nQQn5R1aZ3R5w+suwK+v0PI+7JZC8V7KgAVILBkgZlDEfJ65S9rsEP4Fmv4pmpyJnPQ5r6jnRi1XUFYABorMStBPjUTLDXpYOsTKX33v/3rA93XuBvBQYsiPSgx0umdgkfSLyefokQkbvyDsV4Vs6YLjNVywjESue4wzmYUycoYcNYsDgcLwNQjWO72vQAAcdOuev1MzoOtkJqAjgxrLcRHyEUqS6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U59zJdwFWF8Dtpjn0ZNqO7P2OXSyW40uUqet0Z5N1JU=;
 b=Gi07ps9CzGoJ81/8k6Wbcbo2i1+zlay2fkTSjAjFrf0a4xOQv7YRLHjN77rhDs7p8+Wl/5mvaQkQXXwzqAMUUyJYXlSoLYvgj6Azcig8qLvThcWeRs9bl2er29aN1DAyj9u4cBH66SYMUYPx3TzdI7HG720ZqjXhASc9Wc77DsI=
Received: from BN9PR03CA0695.namprd03.prod.outlook.com (2603:10b6:408:ef::10)
 by IA5PR12MB999278.namprd12.prod.outlook.com (2603:10b6:208:603::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 11:56:58 +0000
Received: from BN1PEPF0001854B.namprd05.prod.outlook.com
 (2603:10b6:408:ef:cafe::5a) by BN9PR03CA0695.outlook.office365.com
 (2603:10b6:408:ef::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 11:56:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0001854B.mail.protection.outlook.com (10.167.248.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:56:58 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:56:33 -0500
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
Subject: [RFC PATCH kernel 07/17] x86/dma: Revert "x86: Remove unnecessary architecture-specific <asm/device.h>"
Date: Wed, 16 Sep 2026 21:51:47 +1000
Message-ID: <20260916115159.1938195-8-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001854B:EE_|IA5PR12MB999278:EE_
X-MS-Office365-Filtering-Correlation-Id: 448520c7-a25f-43ce-e785-08df13e99c7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|32650700020|36860700016|82310400026|56012099006|11063799006|22082099003|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oWYjiIiilI1/ltPRVsCgLypCaO9vdfmAiW9o7bG/tLr2NRbsTlSQv8K3/d8rX5M3nVeN6TkYSM0w/F84RRGrLZsu2Ldkmc4ao/v8bnqwZasx5h5XVYDVuAsWhTTT9NFe6UpG4yaEsyyKCfdO9tOujEJEkc6RxwvGJD8pvPIwjcZe/hiQPRg9ahlPVTlPguqvcxaE0HlKapm8SZdVvh1v7e/GExGtg9hmAmQqi+88Ew0CeUueYnm2cOkNy4Hqh293Bp33eoouGRPfo2SJmIk6Kny0EZqIWDioPOOsC4H81BGc40CEsUhgdf1cThyOgmdWNPOgo2Qbl/SsdmoWPqNymLBymYwfIrB8blbG7dDXHC6wcqhv1eGLMJzbry36D/Aejm39ycmLZKQGzAPzJrIAXN/CzMR8MBpzyYhV/KYmnHaC5Xj8lCgybKAqQuavFgIdTHzm9LVsderQaU79gQoXCU+oWJDzAr295ed6KTXKdZZJg8gGA6Tbpd38JNDlPxoddI0RR14x2MijKrCrsoEGapRMVFegBZigvRmxXJqy2QrB+tPg81V4TV196umnkVC7nTxZQQOx0u03/i1SaUcNKHvonyCjMqj6V9gxIZbqRiXNrmla5PQFBCxnLFKFMm689C1qxvRd9yao6HBZMwM6/KCKXwGbz6i/RoOC18iiTPVntLke1mU7l6ZDhxJBnqvRbhtPwZCwBHfSwRyn0o0mDg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(32650700020)(36860700016)(82310400026)(56012099006)(11063799006)(22082099003)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	06G2FJL0nKGF5TZJWtb7HCRGG+2PKlr27MT4WesUbZV0+gY80l88PL3BrmSeQ5beh70gGokCsKSRysqzfX3ciubcsIdAgmE4y0F4Ova3YxLQ5ozXQV8jIvB/ODOKm0hzPGI1pSwI1ByYd5u5QCjB0hPfjquA08XIbaOue6zkn1tV3Kn/gUAylPpox6/hZRAaJBMEj7DLM5b2wwi5kO0ZHkLwfHDI6r/j1crQDqupTVDXVqOuwF68hi1zCDtYsqvl3N1ntLgU3p8HTTB75Muqf9IMzhthlWMGQpWme4gTOH1dPPBGebMzKO/lwp4X8IixDkk8V5F7M20c7y6q0Em4t50tzsSw6gpQSlPcV8ahXZOZq4skJKBSdaGvLnoLoUvMa46yGRJkzCkyOSNOvQFGaxtyRraDo/hGmA4sggJrE4UwcXwFsqenewvBgglqYzrr
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:56:58.3314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 448520c7-a25f-43ce-e785-08df13e99c7f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001854B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999278

The trusted guest device DMA setup is going to distinguish
encrypted and decrypted memory and dev_archdata is a logical place for
it.

This reverts commit c256d2a8adf2f5670ca262979c451ec4c1108e38.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/include/asm/device.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/device.h b/arch/x86/include/asm/device.h
new file mode 100644
index 000000000000..7c0a52ca2f4d
--- /dev/null
+++ b/arch/x86/include/asm/device.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_DEVICE_H
+#define _ASM_X86_DEVICE_H
+
+struct dev_archdata {
+};
+
+struct pdev_archdata {
+};
+
+#endif /* _ASM_X86_DEVICE_H */
-- 
2.55.0

