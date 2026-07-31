Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010067.outbound.protection.outlook.com [52.101.56.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1798E372B27;
	Fri, 31 Jul 2026 20:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785528873; cv=fail; b=lsGKX0iiIly9LbEz7wndkyRjgy76ZtalwqHztoiNp77vZd3Sjx3m1p3q5tzNJzCKV7xOLk2kRRnjSGWdKAggWdQbwEkXDTN9tESmqnGAo25oYdHoexzA4wgFm6pI/wg3aagiR4VXnh4SLpJ2byEtC4ldRRNQKfUx05wOVeGfIhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785528873; c=relaxed/simple;
	bh=lm2xWS1ArkLdFlzXnqruQFJ7YnKZ9qyVIVJi+dyfmDA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O19CUn/uzG9Sx8VocQPcaWRwuNScv0xlXscBulrOoq6hmTdFVz8sH8Qf8oSVJh2u8vu3LqcjYiq0R6oYk30Ek5CYOAzzJQFrw5UfgJoa9gDWazZEX0UJBoAd4nbJMVb66tQly6UFlGvv1lrekf2sqWteg3jeKHT+Us8DU66eVes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ImgbgX3N; arc=fail smtp.client-ip=52.101.56.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ImgbgX3N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pzjP/8t90B7L3wzGt0BF9qIao8gNwg0u9inC20QEEfdkWsWZJVxPGG5EtxI/YvTBhJbBq0d5ACWxehemjFlo63VZyLXP0iCh2u3ZLe1wm5KGoR+5YfomP8Y7+jhJMELpvJaDlviy+6wblLKnsXGucL9YQK2siPHeIqm6r4QmDZGHSMg9pz+L/2ghWCLhYYMDmAk7K1aCXzIpT+qVyzB9Xo1/XbHlRxNlC9gUPmf+0grKwwvD6ory6wxbqhAD+tSz3YQmvtp2l87ePidUTO4WIEdKns5S/K9jpP+naPEtlVnezTJKpc9zqCLNZ/sy9Dg8LyAsVyOb5G/7ScGEuZikBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCW2Xy7hcDqnBnpW0dZ189yEJs5Zt+40g4akWuQ255M=;
 b=gTfeHNGzOZxvcwSI/Jt7n3PcYi+2pAF6sbmiHKTfUL9hWSb0ZvZGngfwG9vHrTM1EvJ1pBprjmyuKKLD7xFL/bjOF3mejQ1GVb5+Vd32dCm2Bz/g0wb6fkj4h0qp0s4/xGkvVcdcpbFjb6yOskOhtXlXPaALZeRk0G1ro0I12C6PW8qnFAKZvYNY3Gy5Nh6gARNOijJ9b4ftHMwBCANmCsmtxE5ePOG6v9gkBT3ykjS6saHxu3eM12pe5UIQHtp8wyGs9Z46PDblssek6uQmkp7WmJ4agDuOjHt3UBX7B5SVl+nAXSQ/PoZmO0KzUxhNmGoF0N2okczSgKD+xf/yKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCW2Xy7hcDqnBnpW0dZ189yEJs5Zt+40g4akWuQ255M=;
 b=ImgbgX3N4bkmQEiT3uuAgHeeXCQKMXxO8aGpLAjn9GgzB2KWwVMT+gijxGIyMNN57aO32ASRzDt8J1nadgJvYwAtQEyyqCRUTh+x9WxMRbNNkGraCTjxMLB3owZ5ymnNGyWLhtSq6+MnB3nKVte8ICiN8GxV7CmokfsGuDyXmxc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by SN7PR12MB6838.namprd12.prod.outlook.com (2603:10b6:806:266::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 20:14:23 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 20:14:23 +0000
Message-ID: <274d9a06-55f9-47a4-bcb4-7e65900dc9d6@amd.com>
Date: Fri, 31 Jul 2026 15:14:18 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <7f582569acea933c3045be604a81975e29b5ee2b.1784844080.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <7f582569acea933c3045be604a81975e29b5ee2b.1784844080.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:610:1f0::22) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|SN7PR12MB6838:EE_
X-MS-Office365-Filtering-Correlation-Id: d3d18916-4f5e-4a30-2ba7-08deef405011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|921020|56012099006|10067099003|18002099003|22082099003|6133799003|5023799004|11063799006|4143699003|3023799007;
X-Microsoft-Antispam-Message-Info:
	o+pjoYStCsatMJQtKWo0QVaI4TXEALG/aCyfKws2Nywon7Jff+i68padzKBFKdJBg8IlV3elkqrEr6/swmsAIDuKXZ0DlQkE/sKCb2a0ETPAfrIMihXNA7uHKqccVGTFVO18luK4WZnFtKFGgSoxWtoncgXovxkas0fFqQsBjMOIyWOmxZNa21Mp47ga8+z3ZXKJ4X4Q/6ZvCWQm5jOEYO1eO/CZXwgv0jM93lq45ong+4NgfD1e2Y5Xo8Ecb1xhBEWQuxUb7Xqn+2bcCJxtUn05cKsnnOhtKKs+q/HHFzeyjd08tkwO02VrKpwvM78NUTB3A9qS/Wl9kO++lZLywMBAaa3xaUg9ZNZ5mefH/wCPfzlVGu5kLcL0ZIV6oCeGjSCNotBt12BBtVkLF/OEniEsPeirGW2M/MdVTzCT/MpPEMV3iZtOb/IgFuibrnqEY1tdqKJPoJQJ0lQql9gxNDhKvEwoIHE33uEyAlJW69AxswvuJFGW/Tp9XSi/0XBmp7UD/WjsUVGo2v7YwTGebNdAl5u+DweKkJxeLF+L1hn6PW6lmjxVkkerdBW1XYTowrOxrXmZB42FXISNSuK8hgo7kZSV0vw0Fdw65L4qMWARKamkjVm4fO6oLkuo3ryIAF+s+8pS0K22br+SiN9+VboCd202yvbhRpNwN/zJLAGF4iCscYsI5PimK+XrFElo4viEO7nm3pnZqbfPWKR1rA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(921020)(56012099006)(10067099003)(18002099003)(22082099003)(6133799003)(5023799004)(11063799006)(4143699003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlhSK0huUFNWN1JNdEhyTTR4bXhud0FCUFdiZjlwZmdodjg2QWZEenpTQ05v?=
 =?utf-8?B?SUpDd3BzWVIwQVNZbDdUTkU0Slo2TXMrWDFNT3VKdHNQUjZLL1J4M09LYlpu?=
 =?utf-8?B?NnE2T0kvRGpRN1QyT3dqbW5oQXVPTUxqNUM5QXk5S1oxd3J1MXVqVGUyaGpI?=
 =?utf-8?B?em8wR00rVk5ZMEp5MHc1anQ4WHZKU2RRQkpFRjV6bzZwNXZzR0RWZ0dCcFRi?=
 =?utf-8?B?eEJpVnhOR0ZCcTI2L3ZuMmYrcXB6YW9HcjdSZWVwQ29zdVpCVXViR1ozd21u?=
 =?utf-8?B?dU1sNGpTTHNkdTlEWFpLeFA4RTM4K1ViMG51NmlTSjlpZkNqSk4rdnVDL2Uy?=
 =?utf-8?B?SWQxbmpBdmVRZHRULzV5Q0dWaDU5V3lyc0NuUmhFM3RrRTVHa0hvZjMyWU5X?=
 =?utf-8?B?UGE4OC9jRTFwUTgvSjJyTWJ0VDZsV0gwN0gyYWNLc1UrQmFUR05xdUVqRjQ0?=
 =?utf-8?B?eFEvTVdpbjNJUVNnR2l3dlRFTXhXZ0FTaEJaeGFab0tPMDlFQnpYYktDV0hU?=
 =?utf-8?B?VDZheVZIeXRvT0dqd0ZHZWNHdkE1aVpoRFBYbjFSMUlXUDRTa240M25vTWU1?=
 =?utf-8?B?am9LMnJieFhCMGxCU0FSdkRidWJkNzdHSzFCdThDajVzcHE1bjV4OFR1OWhv?=
 =?utf-8?B?THVFSUkrRkhlNWlHUUJXT0lXWkRPb1pHYS9CNlpHTEkrOGRWN3ZURGlnUDFq?=
 =?utf-8?B?bG51c3FYWkg2Sm5PY0pjMDVvLzVtNE11RGVrbzU5NTRMNFJVOVoxWlVBQXV1?=
 =?utf-8?B?cHBUbmdqSWVKR2pGYThVK3lNN0Y0OVdZOUsvMk91S2xHU01yYjVUSi9BRXFl?=
 =?utf-8?B?WHFMVy9QWG1DWUtiNVFiOXdmbk1SbzJxQUF3ai9CVFpyYm4yanNlMHZMbXQ4?=
 =?utf-8?B?Um5SYkVzdElUTTI3bS9mVGg0d2I4TUVzRDhMQjduYTFmQWF3Uk1nUzVpQ1JX?=
 =?utf-8?B?akNpSllQK3F2RHBieHY1Z0JWWVZxdEkxTFNqNnFiZzlnSERTNTdOV1V6OHp3?=
 =?utf-8?B?T0R2czA0N25ZTEthekxHd25NZzZrdFo4TDh4QlNPNEVLRGRXWUJKbTdjUWVt?=
 =?utf-8?B?eVJpOEJNOHhURWpLYUl2dkpLb1B5YjJsOGdYY0ZBN29xZGhFTGF2SmFWck4z?=
 =?utf-8?B?SjJKQVc5dVlNSjFWSVNsS25ZcHFHZlBZaUpuVFlGYTVoYnBBQnpvbTBaaWgw?=
 =?utf-8?B?UWNhK0Rsd25JTnhEVlpHL2NQNSttc2ZZWXFkcDltQ3d1Q2c1ZUIxeVErczlI?=
 =?utf-8?B?dzJYbFZSK2oySDRHWlpjNU1IcmZmK3pQQkI2KzkzR3ZBQTl5S255K2pxOXdC?=
 =?utf-8?B?M0ZCdzNDQ2J0c1NyMXVreXZKUEtFbEpYV3ZJOFVFd01YbTU0S2NIcjFCZjZh?=
 =?utf-8?B?NEhXUTlHdUpoMzVCS2JmQlViS1lFYmt0UlR1NU01U0RnUTg3UzhhTkxCT2N4?=
 =?utf-8?B?NFVzOFZSWlRJTDJNOGdyUENnSWhrOGo0UHR0Y0dPWkYyWGcvYWl5cnNUcFhs?=
 =?utf-8?B?Si9iWERjaEt5RytSaUc0MXQzQmR5YW0wdFBsamJkMjNCM3pIZjRtbk5oR3hk?=
 =?utf-8?B?RVRXbTAybUl5OWpoODR5T3hjbmJNRGlEcUp4SFcyaVFKY2JDRHljSGVQSEpj?=
 =?utf-8?B?Z01PUnAzMG9lRFJxeC9WeHZEV3d3V3JMM3ZnT3NseHpSTzR0cEVHak4zVVJk?=
 =?utf-8?B?NTBtdDVodjc2UjkwRmwxUUZrTnVnVUF1Q0J2YTJIVnMyYUIyNUtFdzlhZHhp?=
 =?utf-8?B?cjNWYXMvUTlqaGRaNkRpbzlHc0hUSnNYN1Fma3h5TW03RWxFN3dKT0VxMU1j?=
 =?utf-8?B?RWZXVVRKT1JOMXliMzArclViR0hVRGdYa0ZWOUowSGI2YkNDM2Y5dkJhTlRT?=
 =?utf-8?B?R1lTYXN4U0szMmxQdmpsNXM2VnNoL0hCWGpEb1VBdXhQdTg0UTRpdWpRdmxP?=
 =?utf-8?B?TlBUNXFwQ0JGdlJXZW51Ui8rcnc2ZkFUUzdsN3JyajhPcVZjdXc4MVdYQkUw?=
 =?utf-8?B?VFR4NnJZb01DY2pZdXNtUktlM2IxSjNaMG9uMEVVamt1Z2Nlb1RkeXFLaitv?=
 =?utf-8?B?U1JuaGF2cmExdTY5bE9NeTRtRTloVWJTbzA2cG1YT1BuOE1OTEllNk1JMDJq?=
 =?utf-8?B?S1NqeFlpRVNCa2dDL25UL0MyUVNSanhDT21UK1Z6bENIVEhlK1lXMnZXeTRp?=
 =?utf-8?B?OUxXL1R4b3RZZENjM2krTGo5VmY5MEg0dlRHcyt0ZktNM3FmaUtMVVB4Ujlu?=
 =?utf-8?B?SCtYRnBJVlNZd0tGM0RicUE0elNvQkJKZDA3Vk1lR3UrcHVmMWx2a2YzMUkx?=
 =?utf-8?Q?Li0rMtUutB0ms0qry4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3d18916-4f5e-4a30-2ba7-08deef405011
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 20:14:23.5033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qydOzZOpApYMCL41LiHZLJxeNRa6mB0bDSy2zdPluRMAxedKfqTisugHoi19wgL0/c1bZrvbtxq9C5Ba88/HQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6838

On 7/27/26 14:05, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SEV-SNP is enabled, all writes to memory are checked to ensure
> integrity of SNP guest memory. This imposes performance overhead on the
> whole system.
> 
> RMPOPT is a new instruction that minimizes the performance overhead of
> RMP checks on the hypervisor and on non-SNP guests by allowing RMP
> checks to be skipped for 1GB regions of memory that are known not to
> contain any SEV-SNP guest memory.
> 
> Add support for performing RMP optimizations asynchronously using a
> dedicated workqueue.
> 
> Enable RMPOPT optimizations for up to 2TB of system RAM starting from
> the lowest physical memory address aligned down to a 1GB boundary at
> RMP initialization time. RMP checks can initially be skipped for 1GB
> memory ranges that do not contain SEV-SNP guest memory (excluding
> preassigned pages such as the RMP table and firmware pages). As SNP
> guests are launched, RMPUPDATE will disable the corresponding RMPOPT
> optimizations.
> 
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/virt/svm/sev.c | 160 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 158 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 8bfd80284836..04b19e64f832 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -19,6 +19,7 @@
>  #include <linux/iommu.h>
>  #include <linux/amd-iommu.h>
>  #include <linux/nospec.h>
> +#include <linux/workqueue.h>
>  
>  #include <asm/sev.h>
>  #include <asm/processor.h>
> @@ -125,7 +126,18 @@ static void *rmp_bookkeeping __ro_after_init;
>  static u64 probed_rmp_base, probed_rmp_size;
>  
>  static cpumask_var_t rmpopt_cpumask;
> -static phys_addr_t rmpopt_pa_start;
> +static phys_addr_t rmpopt_pa_start, rmpopt_pa_end;
> +
> +enum rmpopt_function {
> +	RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS,
> +	RMPOPT_FUNC_REPORT_STATUS
> +};
> +
> +#define RMPOPT_WORK_TIMEOUT	10000

Doing

#define RMPOPT_WORK_TIMEOUT	10 * MSEC_PER_SEC

makes it clear that this is a 10 second timeout or put a comment above it
that this is 10 seconds in milliseconds.

Not a biggee, but if you have to re-spin...

Thanks,
Tom

> +
> +static struct workqueue_struct *rmpopt_wq;
> +static struct delayed_work rmpopt_delayed_work;
> +static DEFINE_MUTEX(rmpopt_wq_mutex);
>  
>  static LIST_HEAD(snp_leaked_pages_list);
>  static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
> @@ -565,11 +577,20 @@ static void snp_cleanup_rmpopt(void)
>  {
>  	int cpu;
>  
> +	guard(mutex)(&rmpopt_wq_mutex);
> +
> +	if (!rmpopt_wq)
> +		return;
> +
> +	cancel_delayed_work_sync(&rmpopt_delayed_work);
> +	destroy_workqueue(rmpopt_wq);
> +
>  	for_each_cpu(cpu, rmpopt_cpumask)
>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0);
>  
>  	free_cpumask_var(rmpopt_cpumask);
> -	rmpopt_pa_start = 0;
> +	rmpopt_pa_start = rmpopt_pa_end = 0;
> +	rmpopt_wq = NULL;
>  }
>  
>  void snp_shutdown(void)
> @@ -599,6 +620,96 @@ static bool rmpopt_capable(void)
>  	       cc_platform_has(CC_ATTR_HOST_SEV_SNP);
>  }
>  
> +/*
> + * RMPOPT: F2 0F 01 FC
> + *   Input:  RAX = system physical address (1GB aligned)
> + *           RCX = operation type
> + *   Output: CF set if the range was optimized
> + */
> +static inline bool __rmpopt(u64 pa_start, u64 op_type)
> +{
> +	bool optimized;
> +
> +	asm volatile(".byte 0xf2, 0x0f, 0x01, 0xfc"
> +		     : "=@ccc" (optimized)
> +		     : "a" (pa_start), "c" (op_type)
> +		     : "memory", "cc");
> +
> +	return optimized;
> +}
> +
> +static void rmpopt(u64 pa)
> +{
> +	u64 pa_start = ALIGN_DOWN(pa, SZ_1G);
> +	u64 op_type = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
> +
> +	__rmpopt(pa_start, op_type);
> +}
> +
> +/*
> + * 'val' is a system physical address.
> + */
> +static void rmpopt_smp(void *val)
> +{
> +	rmpopt((u64)val);
> +}
> +
> +/*
> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this
> + * range of memory does not contain any SNP guest memory.
> + */
> +static void rmpopt_work_handler(struct work_struct *work)
> +{
> +	cpumask_var_t follower_mask;
> +	phys_addr_t pa;
> +	int this_cpu;
> +
> +	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
> +		rmpopt_pa_start, rmpopt_pa_end);
> +
> +	if (!alloc_cpumask_var(&follower_mask, GFP_KERNEL)) {
> +		pr_warn("RMP optimization pass skipped: cpumask allocation failed\n");
> +		return;
> +	}
> +
> +	/*
> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
> +	 * reserved processor memory. The RMP scan is the most expensive
> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
> +	 * if they can see a cached result in the reserved processor memory.
> +	 *
> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
> +	 * on every other primary thread. Followers are "designed to"
> +	 * skip the scan if they see the "cached" scan results.
> +	 *
> +	 * Pin the worker to the current CPU for the leader loop so that
> +	 * this_cpu remains valid and the RMPOPT instruction executes on
> +	 * the correct CPU.  Use migrate_disable() rather than get_cpu() to
> +	 * prevent migration while still allowing preemption.
> +	 */
> +	migrate_disable();
> +	this_cpu = smp_processor_id();
> +
> +	cpumask_andnot(follower_mask, rmpopt_cpumask,
> +		       topology_sibling_cpumask(this_cpu));
> +
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
> +		rmpopt(pa);
> +
> +	migrate_enable();
> +
> +	/*
> +	 * Followers: run RMPOPT on the remaining cores.  cpus_read_lock() is
> +	 * intentionally not held here: CPU hotplug is disabled for the entire
> +	 * time SNP is active (see snp_prepare()), and this work only runs while
> +	 * SNP is active, so the follower set stays valid across the whole scan.
> +	 */
> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
> +		on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, true);
> +
> +	free_cpumask_var(follower_mask);
> +}
> +
>  void snp_setup_rmpopt(void)
>  {
>  	u64 rmpopt_base;
> @@ -607,8 +718,38 @@ void snp_setup_rmpopt(void)
>  	if (!rmpopt_capable())
>  		return;
>  
> +	guard(mutex)(&rmpopt_wq_mutex);
> +
> +	/*
> +	 * On re-initialization after a legacy SNP shutdown (SNP_SHUTDOWN_EX
> +	 * with x86_snp_shutdown=0), snp_shutdown() and thus snp_cleanup_rmpopt()
> +	 * are skipped, so the workqueue, delayed work, cpumask and per-CPU
> +	 * RMPOPT_BASE MSRs are still set up and valid (SnpEn stayed set and
> +	 * CPU hotplug stayed disabled).  Rather than re-doing the setup, which
> +	 * would leak the existing state, just re-queue the optimization pass
> +	 * to re-optimize any memory the previous SNP session de-optimized.
> +	 */
> +	if (rmpopt_wq) {
> +		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
> +		return;
> +	}
> +
> +	/*
> +	 * Create an RMPOPT-specific workqueue to avoid scheduling
> +	 * RMPOPT workitem on the global system workqueue.
> +	 */
> +	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_UNBOUND, 1);
> +	if (!rmpopt_wq) {
> +		pr_err("Failed to allocate RMPOPT workqueue\n");
> +		return;
> +	}
> +
> +	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
> +
>  	if (!zalloc_cpumask_var(&rmpopt_cpumask, GFP_KERNEL)) {
>  		pr_err("Failed to allocate RMPOPT cpumask\n");
> +		destroy_workqueue(rmpopt_wq);
> +		rmpopt_wq = NULL;
>  		return;
>  	}
>  
> @@ -630,6 +771,21 @@ void snp_setup_rmpopt(void)
>  	 */
>  	for_each_cpu(cpu, rmpopt_cpumask)
>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
> +
> +	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
> +
> +	/* Limit memory scanning to 2TB of RAM */
> +	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T) {
> +		pr_info("RMPOPT coverage limited to 2TB; memory above 0x%llx not optimized\n",
> +			rmpopt_pa_start + SZ_2T);
> +		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
> +	}
> +
> +	/*
> +	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
> +	 * optimizations on all physical memory.
> +	 */
> +	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
>  

