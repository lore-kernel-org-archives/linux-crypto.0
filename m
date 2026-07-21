Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010001.outbound.protection.outlook.com [52.101.201.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136BD4C9561;
	Tue, 21 Jul 2026 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784645857; cv=fail; b=fEFi4qIcGI2oskA5I0lBtBqAVQK/+j1mVZVmxvnDnAiAbE3AkVCvrZLbamB02YfdJJcA/83RA5H8woUa8wCULVkHO993mHLEFjHJNmq7lvanmjmgSlYF/HCYfdn2qu+/vHJv1YOZUTaP8CCARfq8nIwC2P/nD8jxeUeeMZ/hFwI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784645857; c=relaxed/simple;
	bh=jYSn9aTc0y9QGaao2nrWZqjMZGDfPUqbB71hiDyD4XU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gWvr2936S4B01hskUTYlrf4pTUXh/6Bj4J0ngdbb6PRqcf5BvqNpzbqyk1y5WHLOGdEmzpJ1kkDiojz9Nq12QeAJpT1T+vlzO7RVbEFsnoIQpFOaFwYrOO+V9TZ84KAFfbOFyIqc0bhRwMWGyTY4yc4+x/hFXLmtFrz6cmJ0Kmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p5dIR0TA; arc=fail smtp.client-ip=52.101.201.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p5dIR0TA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZxw6EDtByvwMQOyMgIVLakkM5Rtsyt9ADnpZb3MfrH9Q78T4Ysom/78uwrKOmuFW8MeRN1nI1ewbg/wWojn66X/CTrwY1p/UWrDBhVxspUURIhrNT4ktf7gMtwieFTal8W6uHSXYdkBFJl/mm4WAWLUIa9nrzxvU9jku8XOHHYGVvK0G4nb9ryc6y9aBxb6kYaWcL3sfUB7Xch16ejoNjnNSwgqXiuGGYwvneBSf9g9UlRM59Mve4qJ1WoRu1Uf49mN7bCUxMHZnlqacomoQzE6Pp0zyEucNh3q2hqncb0/69oPgz3dYB/JAVUg1XX3cIGPJ1VP2khvEZMr1IMvmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9J1E+E6dNk1GUsak1Y3guZaw0ZWArxe9vndC7l/N9Os=;
 b=f3LZmVv11FBqheVMkJ0yrUKCzoIs4CD7msrU7Kt7yod0vkAZpOgbSEH0qWfZPAc2qsxhuESet3U59e1NR8AVFvRVJL+3UqrsSZg2qXcyVI9ZjnC+Ip+jWMWYo2IM2PecQa7RzpTwL262XigrUE+NwZt1Y+xoIXT/EFBYLG0pmFhEAeVgIrKBbKg+s0OPlpmYUlW7qGMRiLeGDTRq6lnco2lGwB+2ag5m/gj+h0NRLsm8iXEfLrxejIQdt+u7uzUsngFJvUAibAqu8IEmiavKqDRPXefQM44/c7zpbrQQpdNhhAb/IZ6bCPWyz/buPMXy7v/N62+KHf+FdgISsg9TiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9J1E+E6dNk1GUsak1Y3guZaw0ZWArxe9vndC7l/N9Os=;
 b=p5dIR0TAtKJa3mf0O7CeJsNUzw/CjclIT2yMXu62YwXgRLrXaSZvUkiqMms97kCqpRpk9UpeNHAybuk5HnOmaufcN+DscPcRQ5Ltw+DkHnwGM0A816PRJjcZl6kWznEM7at+/Xfe+a8ABLuBE2E6bpENdtoJS79kTHiC5GJuwPk=
Received: from SJ0PR05CA0072.namprd05.prod.outlook.com (2603:10b6:a03:332::17)
 by PH7PR12MB9127.namprd12.prod.outlook.com (2603:10b6:510:2f6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 14:57:26 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:332:cafe::8d) by SJ0PR05CA0072.outlook.office365.com
 (2603:10b6:a03:332::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.9 via Frontend Transport; Tue, 21
 Jul 2026 14:57:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.245.5 via Frontend Transport; Tue, 21 Jul 2026 14:57:26 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 21 Jul
 2026 09:57:23 -0500
Received: from [172.31.184.125] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 21 Jul 2026 09:57:15 -0500
Message-ID: <2696f0a9-d2a3-41e8-91be-6f00a20d5f27@amd.com>
Date: Tue, 21 Jul 2026 20:27:14 +0530
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
Content-Language: en-US
From: K Prateek Nayak <kprateek.nayak@amd.com>
In-Reply-To: <9a183dfc-91fa-4a08-9168-8ea0e53f708c@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|PH7PR12MB9127:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a24f40e-bf28-4bcb-07eb-08dee73860eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|7416014|23010399003|376014|82310400026|4143699003|56012099006|10067099003|5023799004|11063799006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	CY8Bk7wI2qcQ4Ki2DnXl3lrW4aFW7qlEr6OyGgO2wd1U3pgkG4ZKIJ5NgJwG84RdnEwu5ROa61Dblo4NTZrBsJw6LlWT8x/f+g313+O5RxuXzP3qpVgMFI8p2DHUv9X/RU2CD3RjAC+AwcHyY/3Xgwdn3q22MHA2/1SwJ7fpixPsQ04qIgcddjenVTrXXMsNKSCvif+mUivEh0jQcFpH2mQqI1NYXE8EXeWciQ/P45csPw4mH65TrCmIIcNmuO2xOW4BN1cAD1s9FM6o5o0j+n0mk10Wp1TsXn09lAwqsvov2J9DYRfWI4jzBt36iD5k9PRpsrJ/GlAPGeIMlIO380nnQ8PA+CPQlmDIFTYBaN+yQpzrLbeYvp/3rkK3pYqZKQL/4APcUV+vumzgQOxREWe4+z6bYVVtP/LsinYz7XSEaptFxMgOaTreO19rThbQ8ExOFAD5jm8fQVnptnrktAczIJY24PtJ3dKf7qrXJm4f3aE26JjRVPukN75/QfL1yu1Z3IUxzhquPdyov9duNPLZvx43FD3itM0NKWE7hbT91c4NXNCGa9x2ESjMbk4g59IXDFjPYM3CXr8qKbln+cs4HhpBGNu6nfvOQDsYHlk9ny+SlauTi09qPmRqmQp70ovnQdL0n/B610/8Cz7g8SstL23YJOHMqZQrpfLe1xNOm3gBS74v/kUmEFYyYufvn7UDAT9L20Cop47ccMqjYA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(7416014)(23010399003)(376014)(82310400026)(4143699003)(56012099006)(10067099003)(5023799004)(11063799006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eksYC6/phVZzK4kUmgUIzqTuwuCw3wkSXLNMZT1tLzq/zmuRHt94Ez6f6XcXSRKqRbYcs2vEwt2fKS5jZYC5sgBEVppETO0BSujux/Sxv7V9m3z2/DKu0aaPQ6aFQYqxvzGI+xWxmM6YfmK1zjfkfV4hJ4KGmjyAyuy8dLu4b0GVUY9UMguC/qkXkIjYtOcjzcuy3NHlBQBMl8O4lP37dJ7qei2CfmOObVfDqqYRLXEpKGtu2ycOqGmA96kdkgJk6Zfac4/wK/u5AknsgpqywWPo7KvZfElctVOq0cPMT9k/bevDwZp+ofk7HA4rg8pxfmwsiLNkoFcBTubh4XEltSlLeNiNhzY9oRhcW/pQr4bCGWvjzpIw8G96VOed/gprpfiGjOc2g6YlpUtdnw0YgFfKDVlcenYfDale8Nk3oG8eGk9j5LldjrX+HlBa9OkT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 14:57:26.2676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a24f40e-bf28-4bcb-07eb-08dee73860eb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9127

Hello Ashish,

On 7/21/2026 7:56 PM, Kalra, Ashish wrote:
> That's why v7 moved to a runtime check. In v11 (as i mentioned) this will be a small local helper,  it will also handles two things
> the cap-clear can't:
>   - a contiguous (non-segmented) RMP, where RMPOPT isn't usable even with X86_FEATURE_RMPOPT set.
>   - SNP being disabled at runtime (CC_ATTR_HOST_SEV_SNP).
> 
>   static bool rmpopt_capable(void)
>   {
>         return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
>                cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&

CC_ATTR_HOST_SEV_SNP is set from bsp_determine_snp() ...

>                (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) &&

... and that already checks snp_probe_rmptable_info() ...

>                rmp_segment_table;

.. and if iommu_snp_enable() fails snp_rmptable_init(), we clear
CC_ATTR_HOST_SEV_SNP.

So, the way I see it, CC_ATTR_HOST_SEV_SNP being set means we have
already tried provisioning RMP table.

I'm assuming all platforms that have  X86_FEATURE_RMPOPT will all have
segmented RMP. If not, you can just clear X86_FEATURE_RMPOPT in
snp_rmptable_init() no?

We can never reach functions that need rmpopt_capable() without
first checking CC_ATTR_HOST_SEV_SNP.

-- 
Thanks and Regards,
Prateek

