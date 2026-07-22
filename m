Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012034.outbound.protection.outlook.com [40.93.195.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9EA367B7E;
	Wed, 22 Jul 2026 02:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784688395; cv=fail; b=jGvoZI9jpjx98P8bnZQeJvZC1ggfXUiGvHyfIC+wgk2uqpvVWfOzx4AHFOyIq8KmtPs4re3VZ4cHa/5zYR6RW08E+VgcAvMvlUVT/dfas6lXXb2bxMHvCfsELE/aqdT/clp0AzAtcu6tJczIrIcmHxSU7R/7FU8Fe+CpRLFKM1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784688395; c=relaxed/simple;
	bh=cO2WuA+WxHY+1M0+X9HgXCwwSB4n/OCvVPxM3/v8Abg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Sa7VZ7OInZwYaoHtsgvfdwC/n25qR/o2pJBuIC/H4WoLF5BicHe5Z8fSLRVm6N/+XekO8VCPbeku6dbkTxJ18YHfsZcjpJiwIkwYXbQGk8sddt5cDwJ3+o1iIwCXPUtEBFNjb7+mJUkx+d3kOjTkLKhyk9uz92MwMYt//2Q1rj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZqfmGa1K; arc=fail smtp.client-ip=40.93.195.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZqfmGa1K"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gpy5lTO8t67koScTpFCHDvTNNxMEknY4RuywFC4/FWRDOypb0V6HcY41g7qkwLCaC5jbKMB5LCh69KJQVuUCiqPloAdQZY8EAfsTfLfXsNwFShGcEPo0NT/xlCUQ1CduaQK1pj4P9PXxSdU7qVBbGolgp9CmGES/n8Z12d1GvZfFIHRyQ3G5kM0CqboLQZ+kJLLY7/nsbrl4Z2NNhtDOEV+jM3EPFDt0BmVQBTmpqf3eDnPuQyRhyxlNWCwHwKsHT+4z5h5Ut9tXP6XG0np+IpbxKHoEqnnbMdXeDIOdxZ+jpq/pR8gVxqPCotXF+qwrAEEIBK/Hh22pfyyyofzs/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CVBvVkZX1Fq+kKLpRA9vDynv1lJq7EkZ8g9iI8T7bs=;
 b=CAe1vIGM9/Mvw2ss/kMk0vM5kWFmobSPT4iSKXc1mF0oUTxl/3eUCkxjsjw4Hawk6vUr/TC0BnKwH0ZvDQJp3mayxbll7NpBQfCYEXQia5W98fLSDEYZBUpROK348T2DWTPKA69qW93egVp8OmqfcM+ha+o20N4COZYZblytE4EKwib9tYm7cD0fEgKatctLLC+MCshjnCunRj/AA/AnS6ezxDSTyQdKKrvATd6VxMFoPEeJHMAMfQBTnLAv5V6fdbKQ6+lXypqIoc3MLY8J8Sv3Ip2x0otCd8HAWSfYLP14u70uOWa/rEvADUOONGk2VcWi5joZaUAkAGybHElwTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CVBvVkZX1Fq+kKLpRA9vDynv1lJq7EkZ8g9iI8T7bs=;
 b=ZqfmGa1KKFGO7b2Iebn9Tu8JkuZxG9MceRyLkge+Einat9Fh38aeP+yDx79ajfSCvdt/tmShLaLPyQR5iuCIXVc1Xjr4cGbknkFOGlq7uz2Go2opa0Q8iaU1nxeQ8ZOmtu9amdl5yjm5WDZzMxaIM9Ron/Zgx+YecgeOs+D0KFQ=
Received: from DS7PR03CA0143.namprd03.prod.outlook.com (2603:10b6:5:3b4::28)
 by CY8PR12MB7267.namprd12.prod.outlook.com (2603:10b6:930:55::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 02:46:20 +0000
Received: from CH3PEPF00000016.namprd21.prod.outlook.com
 (2603:10b6:5:3b4:cafe::a9) by DS7PR03CA0143.outlook.office365.com
 (2603:10b6:5:3b4::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Wed,
 22 Jul 2026 02:46:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH3PEPF00000016.mail.protection.outlook.com (10.167.244.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.0 via Frontend Transport; Wed, 22 Jul 2026 02:46:20 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 21 Jul
 2026 21:46:20 -0500
Received: from [172.31.184.125] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 21 Jul 2026 21:46:10 -0500
Message-ID: <f2a4753a-d7fe-448b-973e-025563ae8a74@amd.com>
Date: Wed, 22 Jul 2026 08:16:09 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Borislav Petkov <bp@alien8.de>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<Tycho.Andersen@amd.com>, <Nathan.Fontenot@amd.com>,
	<ackerleytng@google.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260720221725.GDal6edYI3uHrDruHj@fat_crate.local>
 <5168d3d3-c31c-4f80-be91-c964a5cee674@amd.com>
 <20260721014841.GCal7P-f3ZBHQzR-0_@fat_crate.local>
 <9a183dfc-91fa-4a08-9168-8ea0e53f708c@amd.com>
 <2696f0a9-d2a3-41e8-91be-6f00a20d5f27@amd.com>
 <509ac5f1-d05d-4c95-8e61-f0d4b04bbb92@amd.com>
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <509ac5f1-d05d-4c95-8e61-f0d4b04bbb92@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000016:EE_|CY8PR12MB7267:EE_
X-MS-Office365-Filtering-Correlation-Id: dbc9d5fe-8ff4-4ad3-2eda-08dee79b694e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|7416014|18002099003|22082099003|4143699003|3023799007|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	LfozwSgxryYKmHxos3z0pQVpHG+z4N3UEY0sywnt8kNLdDYmheXdyhsMBmUq09fXoecFgvikZKpUNL0nH42yx3CpJW9r5LgO9W5GWNknhlNPNWTog60F6K+wPTnRVQm89BoV/1Dvvt+mBwCIbBL1Z33XW3qE4fXwK7snjEbtYhNv1YoUaRXCFqECjbh1Ye3UR7+e3mGwPQIzV0LApLv7ppQybxGaNWa7jZ44LalckchTxaq7MFM4uAqgikhukEvn6WJ95Y1VJv5r92/Zkea+HGR2N9vSSZxyknRG31E9CENyZV9eZwCbUJ38jkdc6Eq5VtDUIWcZGJw0iSjJGsXX7lpAKrU7d4I8iRdbIjNbG0ZEhs3RzZKvbdGwM1ypMXMt/aQlN5s5sGseMgP/AEW4gMVJFCIfVG4/lRNOxEWKKvWE0CbipSa4w2qMMuR8BfNx5A+b4JCgGedQLl8NIjKNc6woZsl68ucaSskm5sJQ72ec4VE2N0539kbMnaTz2ERAWwx8eGKa1xUUSMrgWbf4RvSZIa1CHIJaLPeIX5tdqKQXA45cJAOfBfNk3nK9yINgDBhbLk/fV+U6kLB8EjJNmDI8uDn5IMzL36NACrAwk9OzD5nVGQ4n9BcTqLBoVsyG05L133WjwfbiccnzWfamPm1FshMr7lhM9oiej1uLjlHCfoLI5bNNo84IJ/mX7mK7uUt/qmqzrghd2Cl4BdDR6A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(7416014)(18002099003)(22082099003)(4143699003)(3023799007)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7ZvfoIOnN6bJmkO8qLC4cqB5EI+Xg57Qeh4CgpP36QQVpEO2wPzhB4+A0FvE835N05awfVWg3TyOHyji1Wdx6nlkM/CYbV7QviX8vxCmCxy3OZfpFVgASHqW9lYOeLE9nC/1RZHmBmYNEyRVGWxQopzUFnXHWQWfWUftXxucx05+EvBYaDyw5UqQ64bNsAz5lnWZeQ56vjbit0DN05cER6hHfqf4PAp9gJMWSLBKTJE2Io97EdUSTzRG6cfLxBF3mAqe9wxz4YykQAE8REIfAbEppg4K2+o87EPb6ldRLA9IDxZ8DtwzZt/zibcvOpOD/oCQQ9H3R3qsW+6PU7EZlYuCz+bJO/a3J/tVToBDJ+CceNDLv03A0cGGtyn/v/xs9g5pUtrmPNSWy7hLq84D5ZEi4oPC98FNL41kFK9hu4tqtt4lFbA02E4c9m/I0TkD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 02:46:20.5322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbc9d5fe-8ff4-4ad3-2eda-08dee79b694e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000016.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7267

Hello Ashish,

On 7/22/2026 2:16 AM, Kalra, Ashish wrote:
> The one I'd keep is (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED). It's a runtime config bit, not the CPUID feature:
> setup_rmptable() allocates rmp_segment_table and keeps CC_ATTR_HOST_SEV_SNP set for both segmented and contiguous RMP, so
> the MSR bit is the only thing that distinguishes them — and RMPOPT needs a segmented RMP.
> 
> Clearing X86_FEATURE_RMPOPT in snp_rmptable_init() won't work on its own as i mentioned in this reply earlier: it runs at
> rootfs_initcall, after alternative_instructions(), so cpu_feature_enabled() keeps returning true off the already-patched
> static_cpu_has().

My bad! I actually meant in snp_probe_rmptable_info() during
bsp_determine_snp(). Something like:

diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 8bcdce98f6dc..3ad53ef16c2f 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -684,10 +684,12 @@ bool snp_probe_rmptable_info(void)
 	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
 		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
 
-	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
+	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
 		return probe_segmented_rmptable_info();
-	else
+	} else {
+		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
 		return probe_contiguous_rmptable_info();
+	}
 }
 
 /*
---

Based on a quick look, it gets only called at bsp init and is early
enough to allow patching alternatives and I don't see anything writing
to MSR_AMD64_RMP_CFG.

Thoughts?

-- 
Thanks and Regards,
Prateek

