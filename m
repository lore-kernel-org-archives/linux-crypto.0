Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013011.outbound.protection.outlook.com [40.93.196.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490623C5DDB;
	Wed, 17 Jun 2026 21:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781733441; cv=fail; b=jfHqXDW3wC2OfutBbC1Du82Pb4kBh/Fq621xG/LCzYwx2ECvjAT1wjSLgciwPLnXPO96GzlIOqnWNKNy7S2+UQl2LmlQkrjpFBMukLi7rM7mmtzieZaNTcnrFNXHn/NZYycYqT+c2p7IgsAB+V682cHP/0S3JhIUDaS7vq2Urzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781733441; c=relaxed/simple;
	bh=XueYb2RKorG9t0Ad9GPOajKviSPV5X8f8p8ohwl5pl8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u9cDqT6qggIcQbelZG/aVZM9ZDF1M1+9GSSGz4j7cb+7pI5tu3FePzEBL0xOqlhzmZahfVMRXzefqC+29LVCBooVCB4P4HFbbSzg1bcTjwWojf6HW1+RYOImfUlmFMUC60Rxrj3fcqgt5mDac+zsZJpOizbkn+8k4FN/eMHneIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Ziv2sc0X; arc=fail smtp.client-ip=40.93.196.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ziv2sc0X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pSvI+Wrf3wzM/2N3vDex78C+A88BfnIOi5W3GpSKLLkLgwyO1dGOCrjQSceOn5wWDShyQvW75Y/h0e7T7zJ6QV+lxu3uG8AtOxlRzzVG9bXzKdWDm+2HcTqd4zZ/PP+pRAjZTvMS352M3waQXpHMncdPuIDdKsR4N3LT9hIM3Yrwfz/SCWgfLYA7u0nL5gpnkj6k/fVQjI53gnxU5pfYZ7O2GCVRoHooJGycFjzrhuprb3YcEDMPNWl3Bf/wUPEqHnDueGBPBImj5LDAkNpwb7I+3A/yj82rrG256d+ZnCymq5KU5E2HNwsdSmsA4nrEm1XMBlDru9H83267DzTg5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ABp4WlOibFfWVp17CVdkU2GuSiuroDZppjl870ff3e0=;
 b=Q5BIX5D7JiakKD6pY46b0XbpNRwpgZfEENOLgmmBywxzpBeiqh7sEKNG/yeJI2qSINxThvKbsr0sJoMCWz88+2UlGFO/u/eO78Ft8CeflBN+AiYENOBlgmCMUy4bEHX6U1W8vgdnX9B468TSuIlabEy/JiHX1NfFOV+0eGsumDv75cKchxivg6Ekq06sxNo7HycOrw4ZshuIv+gCUYp+oZVaBXRu6+dwheYmBmBrg/7hpgNjMuTus5D+Dmx3wgomHoJuONeylNG313i7A1IicOFAODhw+EISWc3w5C6bdk2WqkrshV+JT2Ccv0lFZNeeywADZo6h1oGnYVJbQQVQhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ABp4WlOibFfWVp17CVdkU2GuSiuroDZppjl870ff3e0=;
 b=Ziv2sc0X5VNkziQk0vyjGswydY2LvH8E1GfbPzCw/tgNqUEKlUvRdo+zR2OQsK9/epb/qKwTYJGs13THtQZG559V3aVJp6Co3oh5sj7fPU7RpPnQeNof6MSNpd8WtPo5cHL8fU12Be9v/tvR9hsSzO9OKGaxl7GmuElKmkye708=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB9530.namprd12.prod.outlook.com (2603:10b6:208:593::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Wed, 17 Jun
 2026 21:57:12 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.21.0139.011; Wed, 17 Jun 2026
 21:57:11 +0000
Message-ID: <16dbc1a3-1ad5-4b3e-b22f-68602a006e75@amd.com>
Date: Wed, 17 Jun 2026 16:57:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/7] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: K Prateek Nayak <kprateek.nayak@amd.com>, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <de274c2fb3f794ff1f19f0c96184ee50d04d1282.1781419998.git.ashish.kalra@amd.com>
 <0fa0bc95-ff31-40c5-b083-3c885d09d0ab@amd.com>
 <8c5f4082-e3a5-4f65-b058-33938a7ee324@amd.com>
 <75cf11f1-51fc-4f1a-a9a7-4b9403d2bb8b@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <75cf11f1-51fc-4f1a-a9a7-4b9403d2bb8b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P223CA0029.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::11) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB9530:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e9e33a0-692c-47a5-3ada-08deccbb6250
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|22082099003|10063799003|18002099003|921020|6133799003|56012099006|4143699003|3023799007|11063799006;
X-Microsoft-Antispam-Message-Info:
	zQTpcM3atV4hF3SoCUH/Qmrj65IotvhoBQlNMLXzrg3raTmbILgZZ95v76Qud+dqhw2mFujyZrKAE/aegxQaHTHka9AGU3Y2LLKwb99ETH6xY8rZIBlYWYDfXCzBt/kv8pwzmK6poNE3AEqfoDw/Eu7pd4QgM6MhcnJUykiCDGB3C29W6u/U/1HsAPmwBFinWo5KpomiOtKwPEqNTN0ktrSwzhrRIEJE2PPTnIvKesR+bdm5QKL3XZ9+OyBpnFW523ORg4FaXScKbWx4owKkG1fpMM/62ZhBx4v8q2mZ300pa+0mQuYGUWKFKf+vBvl6m0UtMnHm/jiPCJMC3RaTCoufYZD0qPgLQSuD0SigXpXRJswwO+F7xKE9o/nB4Ej8NBAAuWuShvzwlFDIm9IMqLAD/xa7WKl+XltxDtOLAHGn9yV7krdymb9rLUIooXTT0MIL+qeqZljuiNEXwDbFqKUUezhfT90grqYgEk3um7suZLfxKahWr8vO0VxF0CPJqCUs/4oQmpK6C3iivM8kYj+IJpyuCTEfx0l2vyGfmNNQWGg0FUN1fbsJMOQQ7y1lS/rcwdguHFxBA/xr0Lsx2ILtzfp4dShLw4zm9fq+CUtWcO7DxNOOMPP57SalntpzUTCdMw65DAmhTjwdcfydVR6d4Cv9W32V3OzIKCCmF7msQ2/JztptK6QtKecHQcy1vtpAVRq4AkmYLOfhtBT925Sxsff8Eu+7b3btnYiGnAM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(22082099003)(10063799003)(18002099003)(921020)(6133799003)(56012099006)(4143699003)(3023799007)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cEZRLzQ4enczM3BranJRWGl6Y1BkUDRVUHBiYzlnY1czUnFvS3lXY1NXa2Z2?=
 =?utf-8?B?NnExTHNmOHRGMDZRc2tQUGdwYTRFdGgycmZKQVUyK2lXSkJhRngxZXpRTjNv?=
 =?utf-8?B?Z2NRTDJRdXFicHJBVzRXa2tjcFR3OUdTbWx4OTQ4Q2tVSVgxQ2pPb1B4UUlh?=
 =?utf-8?B?WC96cGVYRHlsaWhXVnFsckJ3WDNWRlBHa1pmSlJXTnZUblA3Tjk4S0tkeFhv?=
 =?utf-8?B?NnZDOGFpTjY4ek8vVW5tVnovQ3M5ZDUraXc1UXdMTFpvQ1pUZ2l4LzVJM2lz?=
 =?utf-8?B?RGVvUUR5a09ST1lRaTVyMk5ML2dDOWxhV2cwWnY0QXNJVXlFWGdsemN3R0h0?=
 =?utf-8?B?RHFRYkNQUHl5M3BFZzFveUpRdjk5NXRycDE0MTg0aHBWa0tLTmx1bnVJakx0?=
 =?utf-8?B?VCtqa0s4QlhhYjR6V25RQmNpZ0hwN0xXcURoR1N6UGlZZytCNEFUNFllb2J3?=
 =?utf-8?B?SElZWmt2VklYZVY1dXVVSkFzcnlVdFBJNFF0djJNSEZVd0cyMkpOYjdLb20r?=
 =?utf-8?B?NlBFUElrSllWbDhqcmNUMzRiUjd5MW81NERCNjZZdXkzelFqYXdwZ0xBRldM?=
 =?utf-8?B?U1F1SXJYUFRtdlVOcEtuVk1FS0Mzd0MxZDVZVW5OZzNwbU5veG42Vy91ZFE5?=
 =?utf-8?B?U3pxb1BTT3lpN3lya0FVQmxQL2gwQ3k2R0QvNzh0Ym5mY0d5SjBaSk5uaVlv?=
 =?utf-8?B?alJCVzZIZWprZSs0MmNBVHVJVnRFL3V5TlBtUGozVTBvRWRHNDZvdUxMT0lF?=
 =?utf-8?B?Y2M3VVVvdzBPSFN0NjVFaHJMVlFsdWExeDVVbTM1dUJkZzRHNUNFSVUxQnZi?=
 =?utf-8?B?NVMrc1BLUXp1OFdqY2dOUmorNmtPYWkxNWZKQnUra3l0Sy9GZWdQaDdlcit4?=
 =?utf-8?B?YUk5cUdDbWwxZnVSc2hieGNpSWpvdkVsTzRzQ0lrUFhkK3VGZlVHVGVZeDhk?=
 =?utf-8?B?WEROMEJYWWx6WDdHVlhyM0RNd2lqb1NWOFpFSlFucmVqYVRQeE1pWlJtZnhm?=
 =?utf-8?B?MWYzMG4wUGcvTE1FYVc2M1hhakg0ZkFxTytrUmowaDR4Q2dSdnBZakhDeFEv?=
 =?utf-8?B?TjdxeEtXOWI4eEZOQVNOdUVIVTE3WXlCSHZjMHFMUTlBY2ZDajFBR2ROeEZ4?=
 =?utf-8?B?QUxmeWJSRkRPK1I2bHRlOWVSeUF4bkVDSWR1eTFkM2d2dnBWRFN1eFVqRitw?=
 =?utf-8?B?Sy9zamhITVlkTHRpRHZhbEtJdXhhRjFFZ0Vucjh1d0Z4UVA0S2kzOEZwWVl0?=
 =?utf-8?B?SUg3UFBITGRUcUdmVlFUUS9MbmNyN2FJcGMydVM3Qm5TeDVkRmNSZXJPWE9o?=
 =?utf-8?B?aE5jc01QNlcrMVpiNHVoRGxmV1UxVzFFc0w5STVTVCtMSmZRUDJaTXRMcHQ0?=
 =?utf-8?B?YWhabG03Y3FHMDhCSTdFdmdJUGRMRjgwWUhOSEJDRm93aVNNcExUVHJxTnRi?=
 =?utf-8?B?Zkg4YzVmWVliTXFBV2hya0sydWt3ejRKdUJKMERuWTllSlBTY0JqbmU4TEpI?=
 =?utf-8?B?UlVVZnZGQk5EYWk4RkExYm9BVWd4MkFJaTRHTjN2SnVVU3lxcDBMbEIrbXUy?=
 =?utf-8?B?a0MwOWE4Q09sM1IvNHZpMVBnV1NpNTZOWTlxTWpUTFlaNGhoZHVkWnRMNmcx?=
 =?utf-8?B?RFpPTVdLNXZpa2R2cDJnM0NCeHVMR0RobjNCUFR4bzE3Zzd5aTErNitSVTh2?=
 =?utf-8?B?bHJlT0dHVGpUcmNuano2UTlTSXRZL0VweEhwTTl1bGswR2MycVRTalltNExW?=
 =?utf-8?B?QThLeTFlTEt3a3lKSkQyS2hhdnhZQWNIUDI4NXhzWXFJeThKR0RsUUlGZ2k5?=
 =?utf-8?B?RHl0SUxlRjd6Tmx2OVZ5aFlkc1R3WExwbUtwRUdZTDU2cDFWR2ZtL01mZ0FT?=
 =?utf-8?B?c0JsT0NjTHlZQkFwL2lwZ3pONVVhSlNXaUxBQjhOb05SVGltNHJ5SWRZWDB6?=
 =?utf-8?B?OVFHbnNsZndVdmswdGxuOTR0cXNTVVBFTDhzTXFCb0VMSFhaM0lEMUlVTVB4?=
 =?utf-8?B?TWxjaVJkeHQ4TTJrVUp2T3FwSHIvSng5T21lUnhHcTJ2Tkw5RDk2bDhzOXo3?=
 =?utf-8?B?dks5VU1mK2VNRFp3Tjc4VE9mV25VSEdIUUZGSVVXUy9HUU1zWFNtSTdsdmwr?=
 =?utf-8?B?c1FkQVpBMzdJY0Q2NnRyS0hxdzEyT3ptN0RxWVMvRVNHaENJWndvWHUxMW01?=
 =?utf-8?B?UWNoVUZDVzk0TWNtaDhEN2ZNRFNwekVFTXlZejQzY29YN2EvbGJ4NkU4L1VG?=
 =?utf-8?B?dmhYeUhQdVJaVUI0aVVzWnl6UnFRbkFleTZaVy9RZ3k5djhsYVhpUVkwL3hM?=
 =?utf-8?Q?itYI0BvLP1E5JBlpHY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e9e33a0-692c-47a5-3ada-08deccbb6250
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 21:57:11.7278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dctCydeI4P3olbBQakIXw48DEZfR1n8y1O23Q7/geaAENx6E7n/eoygMbCaIdpaJBuQrd8PP5uVhS+R0ksO7wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9530

Hello Prateek,

On 6/16/2026 11:20 PM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 6/17/2026 1:26 AM, Kalra, Ashish wrote:
>> Hello Prateek,
>>
>> On 6/16/2026 2:27 AM, K Prateek Nayak wrote:
>>> Hello Ashish,
>>>
>>> On 6/16/2026 1:19 AM, Ashish Kalra wrote:
>>>> +	/*
>>>> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
>>>> +	 * reserved processor memory. The RMP scan is the most expensive
>>>> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
>>>> +	 * if they can see a cached result in the reserved processor memory.
>>>> +	 *
>>>> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
>>>> +	 * on every other primary thread. Followers are "designed to"
>>>> +	 * skip the scan if they see the "cached" scan results.
>>>> +	 */
>>>> +	cpumask_copy(follower_mask, &rmpopt_cpumask);
>>>
>>> rmpopt_cpumask is constructed after hotplug is disabled but ...
>>>
>>>> +
>>>> +	/*
>>>> +	 * Pin the worker to the current CPU for the leader loop so that
>>>> +	 * this_cpu remains valid and the RMPOPT instruction executes on
>>>> +	 * the correct CPU.
>>>> +	 *
>>>> +	 * Use migrate_disable() rather than get_cpu() to prevent
>>>> +	 * migration while still allowing preemption.
>>>> +	 */
>>>> +	migrate_disable();
>>>> +	this_cpu = smp_processor_id();
>>>> +
>>>> +	if (cpumask_test_cpu(this_cpu, follower_mask)) {
>>>> +		/*
>>>> +		 * Current CPU is a primary thread in rmpopt_cpumask.
>>>> +		 * Run leader locally and remove from follower mask.
>>>> +		 */
>>>> +		cpumask_clear_cpu(this_cpu, follower_mask);
>>>> +
>>>> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>>>> +			rmpopt(pa);
>>>> +			cond_resched();
>>>> +		}
>>>> +	} else if (cpumask_intersects(topology_sibling_cpumask(this_cpu),
>>>> +				      follower_mask)) {
>>>> +		/*
>>>> +		 * Current CPU is a sibling thread whose primary is in
>>>> +		 * rmpopt_cpumask.  RMPOPT_BASE MSR is per-core, so it
>>>> +		 * is safe to run the leader locally.  Remove the sibling's
>>>> +		 * primary from the follower mask as this core is already
>>>> +		 * covered by the leader.
>>>> +		 */
>>>> +		cpumask_andnot(follower_mask, follower_mask,
>>>> +			       topology_sibling_cpumask(this_cpu));
>>>> +
>>>> +		for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>>>> +			rmpopt(pa);
>>>> +			cond_resched();
>>>> +		}
>>>> +	} else {
>>>> +		/*
>>>> +		 * Current CPU does not have RMPOPT_BASE MSR programmed.
>>>> +		 * Pick an explicit leader from the cpumask to avoid #UD.
>>>> +		 * Use work_on_cpu() to run in process context on the leader,
>>>> +		 * avoiding IPI latency.
>>>> +		 */
>>>
>>> ... this_cpu is neither in the "rmpopt_cpumask", nor is any of its
>>> siblings on "rmpopt_cpumask".
>>>
>>> How does that happen?
>>
>> Actually, this was the implementation before the CPU hotplug disable enforcement code was implemented and added in v8,
>> and i should have fixed this rmpopt_work_handler() accordingly for v8.
>>
>> With the enforced cpu hotplug disable support, case #3 here (above) is now dead code, and removing it lets
>> cases #1 and #2 collapse too.
>>
>> snp_prepare() requires cpu_online_mask == cpu_present_mask before SNP init — so when snp_setup_rmpopt() programs the MSRs, every
>> core's primary is online -> every core is in rmpopt_cpumask.
>>   
>> So now the work handler always runs on a CPU whose core is programmed. topology_sibling_cpumask(this_cpu) therefore always intersects
>> rmpopt_cpumask -> case #1 or #2 always matches.
>>
>> So i should actually drop case #3 here - which is: "this_cpu is neither in the "rmpopt_cpumask", nor is any of its
>> siblings on rmpopt_cpumask"
> 
> Ack.
> 
> Also the fact that cpu_mark_primary_thread() uses LSBs of APICID and if
> you have some insanely weird configuration - like boot with maxcpus=1,
> online all the secondary threads (CPUs 256-511 on a 256C/512T system),
> launch an SNP guest - it can actually leave everything except CORE0 out
> of the "rmpopt_cpumask".
> 
>>
>>
>>>
>>>> +		int leader_cpu = cpumask_first(follower_mask);
>>>> +
>>>> +		if (WARN_ON_ONCE(leader_cpu >= nr_cpu_ids)) {
>>>> +			migrate_enable();
>>>> +			goto out;
>>>> +		}
>>>> +
>>>> +		cpumask_clear_cpu(leader_cpu, follower_mask);
>>>> +
>>>> +		/* Release migration pin before work_on_cpu(). */
>>>> +		migrate_enable();
>>>> +
>>>> +		work_on_cpu(leader_cpu, rmpopt_leader_fn, NULL);
>>>
>>> This creates a delayed work and also waits for it to finish execution
>>> which will add more latency than a simple IPI if the comment about IPI
>>> latency above is accurate.
>>>
>>> I think there is some corner case in construction of the
>>> "rmpopt_cpumask" that requires this not-so-pretty else block. Can you
>>> elaborate why this is required?
>>>
>>> Perhaps the "rmpopt_cpumask" construction needs:
>>>
>>>     for_each_online_cpu(cpu) {
>>>         /* Nominate the first CPU on the sibling mask for RMPOPT */
>>>         if (cpu != cpumask_first(topology_sibling_cpumask(cpu)))
>>>             continue;
>>>         cpumask_set_cpu(cpu, &rmpopt_cpumask);
>>>     }
>>>
>>>
>>> and all you need here is:
>>>
>>>     /* Do RMPOPt for local core */
>>>     for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>>>         rmpopt(pa);
>>>
>>>     /* Skip this core from concurrent RMPOPT */
>>>     cpumask_and_not(follower_mask, &rmpopt_cpumask, topology_sibling_cpumask(cpu));
>>>
>>> No?
>>>
>>
>> Yes, a simpler implementation will be like this: 
>> ...
>>
>>  	if (!alloc_cpumask_var(&follower_mask, GFP_KERNEL))
>>                 return;
>>
> 
> If you move the migrate_disable() here, you can simply do an andnot
> without needing to copy the rmpopt_cpumask beforehand and save on one
> cpumask iteration.

Yes, that's a nice optimization, we can read directly from rmpopt_cpumask and write follower_mask in one pass.

> 
>>  	cpumask_copy(follower_mask, &rmpopt_cpumask);
>>
>>         /*
>>          * The current CPU's core always has RMPOPT_BASE programmed
>>          * (snp_prepare() required all CPUs online at setup and CPU hotplug
>>          * is disabled while SNP is active), so it can always be the leader.
>>          * RMPOPT_BASE is per-core; exclude this core from the followers.
>>          */
>>         migrate_disable();
>>         cpumask_andnot(follower_mask, follower_mask,
>>                        topology_sibling_cpumask(smp_processor_id()));
>>
>>         for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>>                 rmpopt(pa);
>>                 cond_resched();
>>         }
>>         migrate_enable();
>>
>>         cpus_read_lock();
> 
> I think you can even skip the cpus_read_lock() since we know for a
> fact that hotplug is disabled when we are here.
> 
> Perhaps we can have a lockdep_assert_cpu_hotplug_disabled() which
> ensures we'll get a splat if that assumption ever changes when
> running with LOCKDEP?

Yes, that is true when we have made sure that hotplug is disabled, but i think it is Ok
to keep cpus_read_lock() here as it keeps Sashiko happy.

> 
> I'll let others comment if that is a good idea or not.
> 
>>         for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>>                 on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, true);
>>                 cond_resched();
>>         }
>>         cpus_read_unlock();
>>
>>         free_cpumask_var(follower_mask);
>>
>>
>>  Here, the leader exclusion must use the sibling mask, not clear_cpu(this_cpu). That's why my collapsed version uses:
>>
>>         cpumask_andnot(follower_mask, follower_mask,
>>                        topology_sibling_cpumask(smp_processor_id()));
>>
>>   - If this_cpu is a primary: its sibling mask contains itself (the primary) -> andnot removes this core's primary from the followers.
>>   
>>   - If this_cpu is a secondary: it isn't in follower_mask at all, but its sibling mask contains its primary, which is in
>>   follower_mask -> andnot still removes this core's primary. 
>>
>>   So either way the current core is dropped from the followers. (The old code needed two branches because case #1 used
>>   clear_cpu(this_cpu) — only correct when this_cpu is the primary — while case #2 used the sibling andnot. The single andnot works for
>>   both cases).
> 
> Ack! And I think this looks much cleaner (to my eyes at least ;-)
> 

Thanks,
Ashish
