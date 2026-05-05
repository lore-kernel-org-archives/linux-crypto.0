Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011016.outbound.protection.outlook.com [52.101.52.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F1F2BE026;
	Tue,  5 May 2026 20:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778013048; cv=fail; b=eq8mP5AehzrsD4kfoN5S/VUabJZwXaKbaWR0yDTAn2VOJ/PKYFjdc0VKKT7Ib8Ap3i8J2CP8gtNF3bTL76gomm1luSk0spYapLOmxSas3JgJbVgnrY6GeXw48uO6RBpkqw1QP37bFhMXrwtwHbn+HbNVf9KsOf1ixMK1sSt1+04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778013048; c=relaxed/simple;
	bh=ChaRSc8Qv+/1VsIZK6Z7d/sdhNsSVXBZYgxDxgfaeVI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fuVtok+3Irqv24yU2m2IM7LpFyIhpXGA+ZxC1CEaNzGbN1qc16iQuZkuahRUw6UE7yGoJR0xKvGTehNrm5K73kK4jzHpKbGMNVqVw3NUNzlhb3b3ZuFgEMxWKevXxW2l1aZiTW6ccjxImx+Ow2cn+fL8hXOZ1ObI1LjatMRDBHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ith5k6Ne; arc=fail smtp.client-ip=52.101.52.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ith5k6Ne"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UrD58DMHUD9hmQdmYQj0Y3PqJ9z95zZajkk9pade99AFsb104swDjpt/sPw/EeHQt8+IKeB+MUAr+tuhpTlIps+PkdZoSZQX09eqotHPEuUlMiKW/JGu+Srs4hk4k8ByD2d5fF1Fl8wdMQH5sttXpDpRSptFNjf/ZsjeWUkISWmJ8VUqor7QOsfikzotYYlv3wSeb0D/D18Z/wVJXsnLqpiuX6ZXAWyEQEJ3ulh/oHJWA8XbsDzUrqTkmA6itS4bvHgquF6hVBj65LDtt7EBsqHhiZJIgM33YfP4t8AvKNRehf75qEs9UTePA3H5TjwJZi5GU8VtmaqyiMxJD7frOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+2KDY6UTOjG5MC33sX3uVxIkbFoIeRXSNEI3dvDPkI=;
 b=s1KhiFsFWei1ngfsJoxPZGEcpU6lNbGBsJ6dfChh4G7S91iJjGmCZoiqg8kukpX4K2u8s0lYg2xTVuOseokN2n6yS8zunTZT+BBIgbtVDMIJzl+1KqyoZhY89+Ri4mW+0slSKOSaHLzX03gTeIYB/ftRT8ykRgZElI11yubx2YnTZWJIL/0zivkFoVxf5fJX1TL4e+quCzuLBZ6Q3aScJwVIapT6Cyvf+LUEIx9Pt3XTkWFae9F601JZFZK8zLNUsB7qfFgKv7GXONq1tHSl4/GK7M1SzdJuSzDFGjzzhd3+v2WSRHvU3IFduqVqEH3nEldMC8u2ZFGywWpdOuq6rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+2KDY6UTOjG5MC33sX3uVxIkbFoIeRXSNEI3dvDPkI=;
 b=ith5k6NeYUXxbSipspc724KuH73TUKlJtUSUrpTkb6jEQb/W0p1SZL12ylMYUBumXso/5ME0whCakRrNc63A673pu67k9ueToej8yRAHdNKqDZmasrKVAjRcFosVTv9e/5Wcv5pBrc43pCJ8VJrG+HcUOMzqcT8AwUnlJ3XGwgE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by MN2PR12MB4048.namprd12.prod.outlook.com (2603:10b6:208:1d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 20:30:39 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 20:30:39 +0000
Message-ID: <c6235a3a-3ede-4f76-b5d6-67cee78fcca5@amd.com>
Date: Tue, 5 May 2026 15:30:34 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] x86/sev: Add support to perform RMP optimizations
 asynchronously
To: Ackerley Tng <ackerleytng@google.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1775874970.git.ashish.kalra@amd.com>
 <ad924b3fbe4154466195e0668604afe8e0b825ca.1775874970.git.ashish.kalra@amd.com>
 <CAEvNRgFRJNRyUf3T9TTWr9-xt76E=Z28vSKsdZ46QK3UAEd8dA@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAEvNRgFRJNRyUf3T9TTWr9-xt76E=Z28vSKsdZ46QK3UAEd8dA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::26) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|MN2PR12MB4048:EE_
X-MS-Office365-Filtering-Correlation-Id: 0218656f-e4df-4ce3-c025-08deaae52bb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|22082099003|56012099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	3lfOXp1Sx8WrGJqfrutBTIxsIRkYhUPL8B806D6DT0TaP4xX2yJ247mwKf4Xabs3JCAQu4mpOn0WaqJG/g99qRabHW2QLQRnISXsiVEPSPKrARyqB5iFjsNpevL1/0zEC8IKlj1jKpbtN/pG1tTzh16IJ2svPyhSGQ180xUDHDQ5DqnnMfIfHhCOSe43IDWh6/a95g156VCMGGaUvrmO0BufDbmIEO4Dvgp47WpSDz+MY3xhBQRjvjheNEXTXO1qc9F2oUZqyXeosJqKIm21JGfd16+RIbGweZW9S2R+i5CDuDkqoRpTVkwhSdZX6MAPG0Zr0u9/BVVwB5xSi83nr9x0OICgY4GMJ74ZX+WODGNAW+A8lD1KzE9aB7XB26/e+xn1aSHKnFx6PMmZIE01+5kd4GoPjKsNU6/bnz/nk7KFirIhEdYERhuoLHS4KoxBN6AajM3MV9Z2FV2Qf5fGUSQmr1mXtRaPJZ9CLCLH4Q2VdalLyLF/SKxYUtQ3+o8LCC/C+jtIP3JH8cdlRduHf3EOmciXu5pSNDr8GlruyowCI4DM588x1VBrlyQpIObwLIdxUxguPnzKl7aclvzrvNgQyj/ySmmZQUscFHbEw9MhlThL1IkbTqnMmijMEFJ45dKX9RC3ev7wf5FzqF6fmRepRpdpLytSLCC+UnAZ3c2kwHYUJ5M3bYOKntzN8o+0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(22082099003)(56012099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEZaajE3cXNQN0cyR3hIcHFLOERDcTZWa0QvdDdOc0lKTnZIa2JJUWRhV2VI?=
 =?utf-8?B?Z3VDSDZGcitKNjlUbFBIT0VqMGg3YUMvazJSdXdYdXlLNnVNRFNoMEJGMER4?=
 =?utf-8?B?aUNzdmx0aHRkanpNb3FUdml6TlVxUmUxTzRkRWpXYmdZcm4xU3VuNkxPdmNV?=
 =?utf-8?B?bkF5b3NNcHEyM2Y4bXFvbVMwbmZlYzR2S0xjMytac0lnUzFrdTlvZjRHNWU4?=
 =?utf-8?B?MzkxVVJ4NFpvUVNJMjdsYzkxOVRYeXhlcDlheC9uZEVtT29neTVvaFJOUjBE?=
 =?utf-8?B?QVlzSklQQkVrZVB6L0NwM29SMldMS0tiZFhkSmtxZHoycCs4eENSSXVwbFNQ?=
 =?utf-8?B?OXYyb092c3FNYW9ONjhidUI3dnVQV2FoU2ZVaFlmV0F2WmNjaW1IeHJOUmpP?=
 =?utf-8?B?bU9XbEdsMWRFYys3a0VkTitNczluVGJBZ2NlMEJTdGFQaGQyY3dOZUwvUC9H?=
 =?utf-8?B?TmxYbkVSM05tMkVLV3BheFozV2ZWN0JyZUJzNW5zc0RSQm1ORkdtNjRLN3Nz?=
 =?utf-8?B?U1ZRRkVWc3FRN3lIYkxiMGZ6NmRBTFc4TDN5S25HSUhOaktxTnoyb0FXdnFj?=
 =?utf-8?B?bEl1eXZlQzJJV1AxYU1QcHIrU0tjbXZ1OHFEUWV5aUNzSkdTNnVRQVdzNlBX?=
 =?utf-8?B?NGIwMEZwYldlRG1wZ0NGUTVDbW5jS2MrczlrOXZNaEFTY2hkeGNxeVgxcHRE?=
 =?utf-8?B?Y1JvRDdPZkhETGhkN2dSeXVOa3BNZmpQVUREQnhrSWNaZnVReHJIcExvZEtX?=
 =?utf-8?B?Z1NYSndYV1Vhd1cvKzd5QWpZdWFTVWVHbUVxTG01ME5sOE9CdW9LYTI2RkEx?=
 =?utf-8?B?OFcrOS93d0VlTENiSHNRRW4wcFBVaVRFc1Z6OGtERytGVlB5V0E0dGJuTWgz?=
 =?utf-8?B?YUFWWm0vTnZsaDFrZnZWR3JwaEJPdVkwbi9rTjlENGpjRTl5V2hLRW54bDJk?=
 =?utf-8?B?aGVwUTRCaW44VnFuUHdQakxDMnVTbGVlUGVQc3NkeDIzRmhGekxFMW9VL05R?=
 =?utf-8?B?YWNTZ3hRTTJWTDJDKzV4eG9WaTZBNXFCYU9Zb0ZLWlhBdjZEaXRmZFpGYVJv?=
 =?utf-8?B?ZE4rYS91UDl0OXpBZGUyYlZpd0dub0NKS2t1aUFLYjZ4YlNoeTBBRm9LMlBB?=
 =?utf-8?B?VVZKVENqaEtBZGQraFhBblVHcVMvSzZUR010QlRjZ2YrRklwaE1FQUJGTTU2?=
 =?utf-8?B?VDdPRnp1WDNucmVrS0FhWmZ2ZU9Ecm5NbmZ0dWVHWjl4NVZWaU4xQVhFeEFP?=
 =?utf-8?B?cEZvWklwUGpLQ0Z0QjdYZGx1RDBmVmExNG9hSFNIS09Bb21reStuMHdHY01t?=
 =?utf-8?B?dmNYRkwrSnlNOXUwRTV3NTdQb2RKNjZURVhNbzlOMWpZZFluVVlXMTYwMjBp?=
 =?utf-8?B?RStaNHdaQ0w5cnROZEh0ZGxSSk9jbHQxa3ZwSEhaVXpmR3RUdFI4cmtNVkNi?=
 =?utf-8?B?VmxrdlBRYVlmbXVMbmp2Y2FaWXEyb0U3RkQ0d0s0aUJ2UHdPMXh1bGt1SXR6?=
 =?utf-8?B?UVJFZlo3OTVrK2Q1ZTArNUszdUxIdFRobzcvVTRPNmtmVTY1TGFjb3M1ak81?=
 =?utf-8?B?dENBOUYrY0xhbXIzUnMxaWZUTEloN3dBUEYvY2RBa2lRMkQ4VkxNcW5CeTB2?=
 =?utf-8?B?T3cwSmR3amZhc2hqV3VtTGIxdVp4aktvcVJ0SFd3Z1lZQlRLTyt4czdZcWRS?=
 =?utf-8?B?M1BTT3NVb0xiYy9nQjljWGIxOWI4YWsvMFF4WDQ5Sk8ya2Nsbld2VUpueHBz?=
 =?utf-8?B?NEpRc0krb3JwNWQrMlNwQjM4YWlCZUhkb1d6MG8xNHAxRmgrTlpuSjBtcUxH?=
 =?utf-8?B?U2lGTUNKY2hreDVTNzEycTRoY2pNMlpUcHBlUzl6TUZLMllaQVFBT09aelMw?=
 =?utf-8?B?TVUvMGhzZU9WZGh1SkRPclNiR1ZKdUV3c2xzMHMzcTQya1lLeSttWFBBTnQy?=
 =?utf-8?B?YytiYlEwamE3WjIzYkUzZ1FLN0VoQ2gvZG1iK0JraU1ybGk3THNLd3lBNkhX?=
 =?utf-8?B?MURIUG02WVV6UkExQ3UxZFRhY1ZiY2V5c01kb3ZmdWc4MmlWV1RBekwzOWFa?=
 =?utf-8?B?WmduL0QxWGRiQ2RPK2N4R2pZeGNRREFCZDJSMG40MmdzUDdtb01CM21ZdVlD?=
 =?utf-8?B?b2dEcHU5SjczUzNYeWNxQnAwZHNiWWtFejMwdm0rSlB3TTNGUFBCaWkzaW1s?=
 =?utf-8?B?SHhKZzQ2YzdmZEtsQnFzVitRaGRWdEl3c2lORmg5K1VJSlZ6OEh6Wi9oVkhV?=
 =?utf-8?B?MHAxTkN0NnlYMGM0b2NtL2MwTnlwVnJRQ0xJOUI5SnNCNkw1OHVYeTNkaUIx?=
 =?utf-8?Q?mN68kcHxael+MAoXRY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0218656f-e4df-4ce3-c025-08deaae52bb4
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 20:30:39.2572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqvJO3XDKG1Q4pozATblFcKnwgmpako2DcWlRswBmS3jeoQVmrlhQ1MMcoZbidvXgq43f1l+jaC22vQGWCrcKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4048

Hello Ackerley,

On 5/1/2026 1:57 PM, Ackerley Tng wrote:
> Ashish Kalra <Ashish.Kalra@amd.com> writes:
> 
>>
>> [...snip...]
>>
>> +/*
>> + * 'val' is a system physical address.
>> + */
>> +static void rmpopt_smp(void *val)
>> +{
>> +	u64 rax = ALIGN_DOWN((u64)val, SZ_1G);
>> +	u64 rcx = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
>> +
>> +	__rmpopt(rax, rcx);
>> +}
>> +
>> +static void rmpopt(u64 pa)
>> +{
>> +	u64 rax = ALIGN_DOWN(pa, SZ_1G);
>> +	u64 rcx = RMPOPT_FUNC_VERIFY_AND_REPORT_STATUS;
>> +
>> +	__rmpopt(rax, rcx);
>> +}
>> +
> 
> Could rmpopt_smp() call rmpopt() to remove duplicate code?

Yes. 

> 
>> +/*
>> + * RMPOPT optimizations skip RMP checks at 1GB granularity if this
>> + * range of memory does not contain any SNP guest memory.
>> + */
>> +static void rmpopt_work_handler(struct work_struct *work)
>> +{
>> +	bool current_cpu_cleared = false;
>> +	phys_addr_t pa;
>> +
>> +	pr_info("Attempt RMP optimizations on physical address range @1GB alignment [0x%016llx - 0x%016llx]\n",
>> +		rmpopt_pa_start, rmpopt_pa_end);
>> +
>> +	/*
>> +	 * RMPOPT scans the RMP table, stores the result of the scan in the
>> +	 * reserved processor memory. The RMP scan is the most expensive
>> +	 * part. If a second RMPOPT occurs, it can skip the expensive scan
>> +	 * if they can see a cached result in the reserved processor memory.
>> +	 *
>> +	 * Do RMPOPT on one CPU alone. Then, follow that up with RMPOPT
>> +	 * on every other primary thread. This potentially allows the
>> +	 * followers to use the "cached" scan results to avoid repeating
>> +	 * full scans.
> 
> Out of curiosity, how does this caching work? Is it possible to do it
> once and then synchronize the cache to the other CPUs?

The first CPU does the full RMP scan and stores the result of the scan in reserved processor memory.
And other CPUs can skip the scan if they can see a cached result in the reserved processor memory.
So i believe the other CPUs would *still* have to issue the RMPOPT instruction, but then they will 
avoid the full RMP scan and use the cached results.

> 
>> +	 */
>> +
>> +	if (cpumask_test_cpu(smp_processor_id(), &rmpopt_cpumask)) {
>> +		cpumask_clear_cpu(smp_processor_id(), &rmpopt_cpumask);
>> +		current_cpu_cleared = true;
>> +	}
>> +
>> +	/* current CPU */
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>> +		rmpopt(pa);
>> +
>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G) {
>> +		on_each_cpu_mask(&rmpopt_cpumask, rmpopt_smp,
>> +				 (void *)pa, true);
>> +
>> +		 /* Give a chance for other threads to run */
>> +		cond_resched();
>> +
>> +	}
>> +
>> +	if (current_cpu_cleared)
>> +		cpumask_set_cpu(smp_processor_id(), &rmpopt_cpumask);
> 
> Sashiko [1] pointed this out: after cond_resched(), this code might be
> on a different cpu so smp_processor_id() would return a different cpu,
> that would mess up the global cpumask.
> 
> Perhaps it's better to store the id on a stack? Or actually, what if we
> give on_each_cpu_mask a copy of rmpopt_cpumask with the current cpu
> unset?
> 
> [1] https://sashiko.dev/#/patchset/cover.1775874970.git.ashish.kalra%40amd.com
>

Yes, i think it makes sense to store the id on the stack.

Additionally, i will be moving the computing of the cpumask within this workitem,
so cpumask won't be global.
 
>> +}
>> +
>>  void snp_setup_rmpopt(void)
>>  {
>>  	u64 rmpopt_base;
>> @@ -568,9 +656,20 @@ void snp_setup_rmpopt(void)
>>  	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>>  		return;
>>
>> +	/*
>> +	 * Create an RMPOPT-specific workqueue to avoid scheduling
>> +	 * RMPOPT workitem on the global system workqueue.
>> +	 */
>> +	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_UNBOUND, 1);
>> +	if (!rmpopt_wq) {
>> +		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>> +		return;
>> +	}
>> +
>>  	/*
>>  	 * RMPOPT_BASE MSR is per-core, so only one thread per core needs to
>> -	 * setup RMPOPT_BASE MSR.
>> +	 * setup RMPOPT_BASE MSR. Additionally only one thread per core needs
>> +	 * to issue the RMPOPT instruction.
>>  	 */
>>
>>  	for_each_online_cpu(cpu) {
>> @@ -590,6 +689,20 @@ void snp_setup_rmpopt(void)
>>  	 * up to 2 TB of system RAM on all CPUs.
>>  	 */
>>  	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>> +
>> +	INIT_DELAYED_WORK(&rmpopt_delayed_work, rmpopt_work_handler);
>> +
>> +	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
>> +
>> +	/* Limit memory scanning to the first 2 TB of RAM */
> 
> I think this is better phrased as "limit memory scanning to 2TB",
> 

Ok.

>> +	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
>> +		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
> 
> and then this could be
> 
>     rmpopt_pa_end = min(rmpopt_pa_end, rmpopt_pa_start + SZ_2T);
>

Yes.

Thanks,
Ashish

>> +
>> +	/*
>> +	 * Once all per-CPU RMPOPT tables have been configured, enable RMPOPT
>> +	 * optimizations on all physical memory.
>> +	 */
>> +	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
>>  }
>>  EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
>>
> 
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
