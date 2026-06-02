Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010023.outbound.protection.outlook.com [52.101.85.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A8C2F290A;
	Tue,  2 Jun 2026 20:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780430568; cv=fail; b=IuV23bIEfVuAnxIxIiaDotxRUBH2r64RSbxgWVLoTWvqe7X0Qnkl/xQH6Gzp4VP4wy/WVjqAPwtBH8byhWHRMC17KEzC4XcTcr8b8Oa/khJngCf3Jg1nJxoV4JS8gef6QrfgA7G5xG2+CdyUWmrBUAWtQOKpxRQvNZJH4wif72w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780430568; c=relaxed/simple;
	bh=vuGdLL/e7nbmHBQa3VVs/TpNpujz2G3aM+7E5CDFFTs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+QEvDH6xNNOtxlCukqFd4j9Yk/zalRHZBYOPUQAmCrRxEhr8hMmc6B776RGZYwCYzUu9SA1j21BLtlpUQqbQnXyUXwXf2N1qpfeYxoTURt5ILszHRlnzu7SxIwie3xzjpjnKgwwvytY4YP8PQgpuxj+oU+ISqwuznEzJrV8MPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qaju6R3i; arc=fail smtp.client-ip=52.101.85.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qaju6R3i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CvZcyOz7XY5agCjDFVfCKdgJNZyXIpqooAbHSywJKmpja7bZNH4mPUcA94eVDtmRETV/fOHDyFDGvYVGQ1eTSZa9B9UpHr0kq/IgoZU7XffWDE1aWhSEDvURlvCSxH0ASvgwHmbxldwW+lCPEbOxfwMvzsOxNV6zvsP+zRvs5K/AW5peKEgTBd2pDzl7xF50U+WKqh0r5ZAi5Ayg7Rd6Kqs98h6OTUKBks57XOYTgIuLuNr1/o8Vr9kYZ5rPq0GsztTDDkvotB42Y53ZGzL7OyO1390qEGUpeIKwnie2O3sZEkbdcZkjcraO6vSPWiZOmp7iJiFEXZDEXOktgvJc7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1i1YVQlqnyjYXlJrMfo3dyWzHlnzJV9t5+x5bWLD990=;
 b=iADYdJNiEYEo1GKcDrPMSqVqHjcp2xCtcDA72Il3G7OzQQ1lZJ/Vt/157C7nEPCeiq6RQj/psJC20ln7wzEd5kUgLhWeC/JUbKereyK7FWOCtTMqi+cL+JjHl4Y8aYddCgzG+bzHNp2KJ4cwTPYacUP84epUlsVvpl6K6mBKtojRb2IAUQ3Kg2ICAHVQ/7govHpE9jIgxEIWju5+ET+FEzDUQ7wPf3655s/GZnF44j4Gwc2uARnaMFqhDJEXp1U5ekDLp9DAPtKTupuXoM/lEa36gP9x9gE5oMxosgLTshFrBvzzRobASVbepCeGffNY3Lkor5O0zqe6Wop7OcbhFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1i1YVQlqnyjYXlJrMfo3dyWzHlnzJV9t5+x5bWLD990=;
 b=qaju6R3iF8aSa3UBY5263UCCM3HgNYLZLHGF2yQZc3C9akaj9GyJgLGYldWFAeMIfp/9jKnqZ8KJ/a3HtJzOr4402kdmHN9Ad0Z5l3YGwjDsCpTPrF3rIUR8l8+S0CAVXS/896pVArxWZi3mb8ZY1xPOOdNsIKOlkoWd8cGXVkU=
Received: from CY5PR19CA0098.namprd19.prod.outlook.com (2603:10b6:930:83::15)
 by DS2PR12MB9637.namprd12.prod.outlook.com (2603:10b6:8:27b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 20:02:43 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:930:83:cafe::88) by CY5PR19CA0098.outlook.office365.com
 (2603:10b6:930:83::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.7 via Frontend Transport; Tue, 2
 Jun 2026 20:02:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Tue, 2 Jun 2026 20:02:41 +0000
Received: from nigeria-2635-os.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 2 Jun
 2026 15:02:40 -0500
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
Subject: [PATCH v6 5/6] KVM: SEV: Perform RMP optimizations on SNP guest shutdown
Date: Tue, 2 Jun 2026 20:02:28 +0000
Message-ID: <53da77d689a2281cf875cdf6b3a52a7980b5ef2a.1780427587.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1780427587.git.ashish.kalra@amd.com>
References: <cover.1780427587.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|DS2PR12MB9637:EE_
X-MS-Office365-Filtering-Correlation-Id: 323e3f9c-fbcf-45c4-20e6-08dec0e1e7b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|376014|7416014|921020|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Mo4dIcmrerE4cq/VBDZ585xffs6YIjTCRDG/NyKjZ9joXkZRmK6Ekfb+C0Z71VW75vhc5Re5cm5FOJGnQLupgRcUp4CWN13oH2j7L4H4wP+DWIbZng+8ZGM9zemXG59mnzxMoz2uCDzEC/bdfMOYm8g1ajLU1EqxWUBDmE1ptdEy9faKcTdNcHwtw1E7R1FzpVZslNvZFdbuAiI1izjH9T9dDshSiQ/d0M2j550YlRyzi5shbHN4xy9+UKITVGeLcZuUOfotbIKHqQcyXhz08sN4IwtkiPNQrBieVDJu5X3B+QI+LAkqUJwoHu//78Hjc5XWu5phSahtYj1eLgTDNbkACZvqCwQiBuhcB3myRbb0czyM3nHNQ49Nk+soaRkrC/zoghopZMDKuvdEuV3fW8YMVh6eqkNBOBxRegPbwyNpF4ArHLEE+AHqBXiaKWuIQkwZhuoMxUtywxMP/FYB8n+AxSocADRmLrxk8g0gTbzI3M6+QMypkE+jJ8YoLfMVQke3Xxrt/cn+p0fPbECCAxymUVKVMlQDJs4JT0t+GlfEPdcgeVAvZnB6ruCK2UCZxvT5uYODvI4vY5MyYtcdnejHaCWnejkiJLyiJ08FiaPr46Bv4diA/F2vFMarUE5KS1jzCH0PXgLludHOvOfQnKR3Rc/GTmGNkOQOaOfDWFo1ClDNKQQR+2bl43HaEAHQyos8h+L+VLWsBTpbqs3YkmBtGlGgF0/3P1XvDsDvNtzEUEcVX2l8xh0S1J0mrCaGK8FRNDylYVNDPywJVMkMkA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(376014)(7416014)(921020)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gI+fPd2iNRqPdEWjdYEHU/nbsqSKimYVKyWd9nyc2E+YsQwWfEUwfuYxcTESmUDv9KDOQ93CP4zUQP67n5EUjZ1+ZD8pHdLYe4so9stiRS6BQFYINAN2CvNH7IJ+pHjZFJFBYCQHCdSVfQJwLTvH4gILcNwOUBiMQffsK1ig7DKzb355M1fKX+PGmcLknUprRCzbhylcWgUbWo7HWpJNHlbyLaZeeyHInYNfgE06xM6ltUJfrTXXS3c56Xl6l/WqDFR7ICDI98VwdgFxO5oIHY1hExjAo1rT6zoyrNMmsteDn90UH3DvqZ9KFCPrP0U7NGm7aL/T4G7x07Xp7WIn2CWSyH5nsITRxu28plyVUO16fWMH+rCVM4RqZz5ijVaog+9+7up6B+8AkoMy4H1gH8ZBnzlqf+8oXMagUHF4ISJbTsFocRPJipSH6DtnS9j2
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 20:02:41.9870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 323e3f9c-fbcf-45c4-20e6-08dec0e1e7b5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9637

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

