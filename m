Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010042.outbound.protection.outlook.com [52.101.85.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0513B3AF66D;
	Fri,  3 Apr 2026 13:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775223091; cv=fail; b=TdMQuRNZDKfe1wSofen4zZmD3oUpAoHBSIN5s+K48x8tHhJF0iVD2TI0KjZ8/m1GTJWnz+uw27gbe5Py7CSIgm1rnNszucJtVxdPf0shShOBLIxcDx75KkCppgePT3Q35LI13vAbmcYkE4B+/UA5CipXjMbvvIfyeGZyg9G9GtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775223091; c=relaxed/simple;
	bh=g1JCGiGUL6Jy0xzhWT/kXcl7T2AejObjNbqokiwd67I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W1vMZjVe8u0k5QVext01ctrnhAVwWgKAiZ6UZrEJkbBayEz1mvTCBqPvoltzMZ94MiyL/CsEVWPUELWlOzeBin/KxtqjzvtFjBt40U8fUtC4r3x6F6qaw4+MsohnF3oIbGDYD/X2JNaDKhZ0OtDOtsmRQljYL9XP2qrFOn5oWkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AMtNHdRX; arc=fail smtp.client-ip=52.101.85.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AMtNHdRX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HpGrwkyzyj6c507m9qAf/w0O1JHtPujXr7b46k2Zk/Mq0X0BDiRxEr8zzYC3mwjv4kzb+/zNHJv5K6NxIUAGcdIGovi7N2V1leYKuesR166EUQk1zb7JWEF/Ac4TfF50mQ65gqCqVMqBevI/QLNaCzmgiFXKYiMinAaP0eN8YMhSz2yujlkPK95XiZjCBIClRAmQUAzorJkwa5jwGhLJulLADOmwV9wAGeLsKbl6CvsXbNpDtUegvTfpkF9SvyN7iQcBAZoZyiIkfZLxCyAc93OlwpUoerDmW6x+VMi6F5mzKCFmQ+qLsew6iiJyjzJf5jUQ6dpjfQAETlg7WvmVSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nVdyWlEpxaTzokJkAEwiXB6sM8QjUFJzuNeIYn4YWQ=;
 b=NZFqu33wG5u/5/pAZ6x4kl+ocjS9RmYzV77+kbalRxprSmp4rucjMQuFAWUbRfS8sKzLni5ycS5vrdHe4S8FNal4AQpuleYfRsSe/relqEbo7SsmsYKYJ6b7L2eXcq9QRi1bJHvh9Mv3xhWRewei30l+MpFG7atwYCjyw9BjSVGe54NQu9dmQ+5qbOOcynNQ+npVeJ5Q8gC9kc8GxZG78Jm3facihuFTeL5OzRhTLbnUKDfYAgaq6wHrC5lRdrBWNJ38dSQlXsOEdLno8gcKXBibBIWYwyFVXkLhor9ORCDCEkSOHKHU/GyfGoZgyq0AjikAbKuv9QaysNQa449cOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nVdyWlEpxaTzokJkAEwiXB6sM8QjUFJzuNeIYn4YWQ=;
 b=AMtNHdRXZUCkZkRWEoCvxaS9+JRJaegwhqfs3bul67wHcfUE159YEXS5u19NZxzEZvan8+p12snEIsfHDvA+bOkPnXJ4xfiQDkhLUvC+bzuViHs/xCVST56yjpda6sA5zVkrmutOsmBSNgUxjRtdmTjEG95puAXVe2+/jwjIjKY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA1PR12MB7318.namprd12.prod.outlook.com (2603:10b6:806:2b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 13:31:27 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9769.020; Fri, 3 Apr 2026
 13:31:26 +0000
Message-ID: <70635612-76e5-488a-bb82-e66752dc9857@amd.com>
Date: Fri, 3 Apr 2026 08:31:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] x86/sev: Do not initialize SNP if missing CPUs
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy
 <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Kim Phillips <kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260401143552.3038979-1-tycho@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260401143552.3038979-1-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0207.namprd04.prod.outlook.com
 (2603:10b6:806:126::32) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA1PR12MB7318:EE_
X-MS-Office365-Filtering-Correlation-Id: 8834f54b-b7a3-4179-b5c0-08de91854e68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	17qoYngEUysencezlKoktKfbdRjwj5fe2Qnw/+UJFmNCiJPmTOUgt8xfTJaXCjjffQ7V463YzOOdjclPHmWHhVr/wqQxwCGTi5iBDYPBNSC6MMykCIMQtx5VXGWvquSMUMXnwWkPx4ym/QXnfTx0PH+IqhaK/b1R/Cqb7xblLXcGaP9riiFP0LqDwTbtMjBghw4WJ38S7o6XvjUKQJuS+8QP4/LmE4OxOxWZ5+AvGXiAtBpOrrvIabaPvftsc03LVME/HQQobWz2DlgqXVt0xnAPiGRWthC7NBO9KQm8Ixn7OlePZI9YLzZ2SCPxTNQtCjAFId+AYKwUmgPb/CAz6AE23o+3jQfbH+Xzih6920myjCB/9ZIJFX3tngJK6SmamBi1QdrtCZacevIbtfboEAdPGZQw9ZYaQvZsaKnho6fqkyk9oTDpESP/fj/sgicCUwSro8hBMBl8IFLCivPvZiXiEez59nT5ZCV4FlnwoPpGHcZlcnnfhlIr6PzRPsWKErnIK/zT7YSuC/YLeysNQ9AVhfycsTJQtRoizD8COZ/BauvRXXRkDs/X/Ur7o3PXiptGn9qPpg1HGbzvusguB/TwURft3Kuf8nh1BDOgrjf5QGyVO90Iym1Z3KCkzzSj5IkLSlY87Dfz4LcYLuKpSVQ/RXABFKVS6Q17yn3zy5+fRL7/AscjtrwwmrbxEsAUu7kYQEYGZRuQL6a7WtS2b2AlXmL8yZqOE0ITmUeLgvoCC/2Uz38GgvguAg3PJKWaRsGWfDHPFnH2dOw6tnyndw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVdnZXE2ZExjdkVxSXRoclhqT1VtelB5NHFWbEl2UmVFcmhCRTIxT3ZDbU5U?=
 =?utf-8?B?VHZML1RXU0tEV1BCNCs4KzBBZTJycW8rY0o3MkVQc1RUQWNmTitaVWxVY0J6?=
 =?utf-8?B?T1lGUWFHNXo0RURzM09JL0VLNnJvcXdkWDR1VXR2RU5mam55TDdJU2N3aEdR?=
 =?utf-8?B?N1lkSmp5VjVtR3R4UHhsYjYzVW52MjlIOFNnZWoxUFhhU3BwYUZ2NS9KVy9j?=
 =?utf-8?B?Z3hyY3p0Z0R6TXN3d0JHeUlKSDlzZEliKzhTQzltSDNiWWZDci9sT2NKell0?=
 =?utf-8?B?dmM2bjgvVTFPOW4xbnR1YzRJeWErRnEvRHpPUmxReWlmNnR1c2VPdFRCSVlk?=
 =?utf-8?B?QWRUcGxmVGRkWnlPSStUa3QyK1N6UE11UStCN0JUbVlrZGVYYWcxRTJhZmU1?=
 =?utf-8?B?d3pvMmxNSjR3RTJUN216am5uNC8zMXQyNG9jVzYrUUtTa2dzL0RoSW5YcE9u?=
 =?utf-8?B?RzZpaHJ3U1piT2ttYWVjSStUWkdTeUlVcXFYQ3VMa0Q5QzRpQ3VLcVRNbkti?=
 =?utf-8?B?UzI5UDRIYnR4aVdnWHU4MStER1k1c3FtSjFZakdQUldrYWd3WnQ4SUJ1OGRx?=
 =?utf-8?B?c2pwY0xEdENWbXg5UzA0ZmNNSTZLRk1yTUx0SGlkREh0RlkwRXNvdEM5NVFC?=
 =?utf-8?B?alNRWjNXcy9INzlYTXk4cEthTmhzVEVTMjFVeDNGRVBkMkRreWJJSExzWVhi?=
 =?utf-8?B?R1d6MVlJTHIyRGVUS3J2amNnZXBtOFlhVGdCU3RSYUhKekFOUlFJR01nY3Ft?=
 =?utf-8?B?VENmNlZmSW1hSldRZHJHaDBuTzdsT3cxNmNPTW5Jc2lBdXZtZFI0dXFpcCtr?=
 =?utf-8?B?V1hMdGhzYkd6eU1CZmlJUUw2Ky9wbnhlc0Qyb3NBNGkzTXdsazk3OThHb1oz?=
 =?utf-8?B?Zy9xMlNlZ0FTQnFoY2hxelZjSjZkbW9sbG56SkJDQ0wrTTFBb1lxcFE5UVRh?=
 =?utf-8?B?cWt2Ti9tN0diUG15enJNK2dWU1dOcDJVTGFvakd0dEx3b3BxbkJibDlBVC9U?=
 =?utf-8?B?ekZZcitwbXZaci9xaTQ5bk84RmxQZHhPTmVtK3pIcGxOLyttWm9rU0ZQNUw0?=
 =?utf-8?B?Qm54dXpEM0x3amhxYlE2djNMM2VpTVB6MzlOS213eSs2TnZsb3BiejkzYlh5?=
 =?utf-8?B?R2dRNDYyWUgwTHRZcEVWWVlzRnRXN1UwOWYra1MveVBrbitpRnZRNHdyWHFu?=
 =?utf-8?B?NlExV1RiT2xlZ0RvelpNWWJPNS9zOTFTZFVmRSsyUTA3VkhsMkg1UFV0VUdj?=
 =?utf-8?B?cEd5UWpVVU5KSHlSK09OdXdkTUJ2MUUvOGwrV1lBN0RoanQ2c3RwTGh1a3lu?=
 =?utf-8?B?bTcxaFR0ZnFqZ2hsUllHaDA5V1FocU52dkVDZGRXQ2FaeEpQUGtxMlRmMEpW?=
 =?utf-8?B?TTl2MWtGWkVhT3V6Z0Rhc1UvSGZINlBzNTRsUW95QU9IQ2tzMzREc0V0UEI0?=
 =?utf-8?B?dHVxQ3d3RmdBT0tZd3pZQ0JvS3JHM0hCODlzR0FkUFkrUm9Sa29XcElqSi9r?=
 =?utf-8?B?YzRxdXZGQXpTeEU0SWJOOGUwMnFzY0owMXJpb29tazYvNnJibkxVUWkydWFE?=
 =?utf-8?B?SE1xZUJKSUZYTmt0RG9oS01UZno3ZmlnajdiakpOZWZjNDhkTk1NdWoxNjlx?=
 =?utf-8?B?b0cxeGdYbHBFT0lkZlVMRXZ6Vm1iUDRnTkE1NU14bkdvY0l6ZndMNFJkOE5r?=
 =?utf-8?B?Q2dIQ1Y3b1VJcVQ5SkpES3NvcDVsRkJvQnRrbmNoUjNYQjBJV0hUc2xHSzF3?=
 =?utf-8?B?WE5mSVJkMjBVTGlZTjlGR0ZzZndpeTlTZ09SMTVrS2lvMmRnM3BVZFNiRzV3?=
 =?utf-8?B?NlBSbC9oaVc4K1Z3L3pKMjJ5aHZLVzBObDhaWFNZYWF2aGpDZk0yMWlnaUxR?=
 =?utf-8?B?MU0xTWJDSEJJNzl2VWhuVzJFMUU1L21yMlNqRit4bm5yUm5DYVZhRStIQ2F5?=
 =?utf-8?B?bDFscDl0ZGVYYXZGM0dhZEVUUXlndXBtN09TUEJnRzZxRTNROVJ4R25MVkpu?=
 =?utf-8?B?QmJqSVdPdkNPMVdWdkRSWGwzLzBKa01xd3NMWUlXNHI1U3F3UUtsRUJEeWhT?=
 =?utf-8?B?cFJMeVA4K08rMG1zdGY3dlV1QXpZdVFyY2pNQ1BwdHFoYlRZN2t4ODBKYUFn?=
 =?utf-8?B?UG4zNXZsM2hmWXNOOWdaQWJRUnRkR0RFbXVTazN1UE0vQlk1LzlHdlk1RTll?=
 =?utf-8?B?MWVjWHV5NnVTOTY2STYrNytTNVB6Rk1jellnN1o0UkYweEg2TGFzYUJVY1Bn?=
 =?utf-8?B?N0pHdjkrQjdWVVV4U1ZJcFJDUHhkci9mUkdIbElCd0UyQjdXWld5Ulp0bmdK?=
 =?utf-8?Q?ghspVfB7jKFE4yb4Mx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8834f54b-b7a3-4179-b5c0-08de91854e68
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 13:31:26.7513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XM7BJtFNxSyMpF+j1HHCKbGAeWcar4vm13DeHZN9zHcL/RScE/9+WZSpo/qT0yt1kQ/mf4emecZXv835mSm7rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7318

On 4/1/26 09:35, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> The SEV firmware checks that the SNP enable bit is set on each CPU during
> SNP initialization, and will fail if it is not. If there are some CPUs
> offline, they will not run the setup functions, so SNP initialization will
> always fail.
> 
> Skip the IPIs in this case and return an error so that the CCP driver can
> skip the SNP_INIT that will fail.
> 
> Suggested-by: Borislav Petkov (AMD) <bp@alien8.de>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  arch/x86/include/asm/sev.h |  4 ++--
>  arch/x86/virt/svm/sev.c    | 11 +++++++++--
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 09e605c85de4..594cfa19cbd4 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -661,7 +661,7 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>  {
>  	__snp_leak_pages(pfn, pages, true);
>  }
> -void snp_prepare(void);
> +int snp_prepare(void);
>  void snp_shutdown(void);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
> @@ -679,7 +679,7 @@ static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
>  static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  static inline void kdump_sev_callback(void) { }
>  static inline void snp_fixup_e820_tables(void) {}
> -static inline void snp_prepare(void) {}
> +static inline int snp_prepare(void) { return -ENODEV; }
>  static inline void snp_shutdown(void) {}
>  #endif
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 41f76f15caa1..e9ded15dbe60 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -511,8 +511,9 @@ static void clear_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> -void snp_prepare(void)
> +int snp_prepare(void)
>  {
> +	int ret = -EOPNOTSUPP;
>  	u64 val;
>  
>  	/*
> @@ -521,12 +522,15 @@ void snp_prepare(void)
>  	 */
>  	rdmsrq(MSR_AMD64_SYSCFG, val);
>  	if (val & MSR_AMD64_SYSCFG_SNP_EN)
> -		return;
> +		return 0;
>  
>  	clear_rmp();
>  
>  	cpus_read_lock();
>  
> +	if (!cpumask_equal(cpu_online_mask, cpu_possible_mask))

If CONFIG_INIT_ALL_POSSIBLE is set, won't that set cpu_possible_mask to
include all CPUs up to NR_CPUS? That would result in this always failing.

Not sure if this change is worth it.

Thanks,
Tom

> +		goto unlock;
> +
>  	/*
>  	 * MtrrFixDramModEn is not shared between threads on a core,
>  	 * therefore it must be set on all CPUs prior to enabling SNP.
> @@ -537,7 +541,10 @@ void snp_prepare(void)
>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>  	on_each_cpu(clear_hsave_pa, NULL, 1);
>  
> +	ret = 0;
> +unlock:
>  	cpus_read_unlock();
> +	return ret;
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>  
> 
> base-commit: cf112712c193e837225d740ec3e139774f2496f2

