Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012042.outbound.protection.outlook.com [40.107.209.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FFC1F5847;
	Tue,  5 May 2026 20:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778011477; cv=fail; b=QX8bLq81C5wK4kG+RYzbEX94G7C1rEqZEyAATr8Q6SpBkk3FDscqDfcE2cRZA/K13/DRtUNAoEQ5a3InTr63BI2uPY1g7mR7J0b5hD0+F13yY6PXcBBWMU4FzoiUM9XKTnwnh3TwokFjkepV0/4R6joOrlwzY4eXhmqGZ+Mx0m0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778011477; c=relaxed/simple;
	bh=HW7AWwitY69CmIkJ1NXhcSaluIcIL+5kd2XpLfLbSPE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NP7zq4l9SER68kR/+hvG3kCaPxgUd5ak6IMYiYHYMH4XefdBcGJ8LvFZ/4b2QgDS2x7GqOAPqXZrZSx0FN1oEFooNXS8mKOtowbt5WrUI94CysLc6mCa+2W99tB166Lsc5QdW+236vDCDGWue7VJybGtpIYNheIIAAxaWqC2pVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=phLyV8G2; arc=fail smtp.client-ip=40.107.209.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="phLyV8G2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GNAGz6anlDdQPIEi4fPad/drSZEU+Xh8JSKQk5kytgOH5yqiXQ5KfkT4hEcTBxvcBuSFTaNJxTSvxcJv0qASI26ywDF5xHMZW0fdHgCWcHfqpeIN8Uei6bD5vvs+wHqC3TocC8+X/VzCEkx1lqyLEPHihS1ADCCuOUoYhyz7t4xBQ/m717VB8WIXdTSAuKNGSRWP7BL+/54U6pVQnzAFiY02DhujUbKx3Skqcw3/TokJnzcwj/MfdBqazehmKeyr7yzZQA8zcUK3OL2w5MWou8ph3yL+GZpX17FHKjh1/v8yBn4ZGmoCWc0EJWC98BUPZ/y3MrGF4PN1WYST23WMPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jJ4tdDZbmkUoyCUqZcfsjYh6mQNJ+or8vFY4zpVCXs=;
 b=ldro4IJVTuDVpPXZ/D89+5gU+Ip2aDQuLdSDCXJshyC0FCgnin91KX420n3DP8tWVS8zxhucJu/8+nsMHp9oZCY2BUPMNHyo+Lftn7ZvwWvMcmxQvEVXA+fvlKTLk/HKwh8qsxlZqY0mXk6fPmFR9pWIWYO25TMGvEDwLf2O6ZCPpoadCNigGJ9zTIufRAbk/1oMSl92WpfZplN/3ltFqdvR8kxw9xtwSgw92qVi6+Pn1KIBLATBLCmcLA0zAFlz0U3lPbVUgq28bieQYC3+16A34Nl0waRl+2Lyoh9kovOL80BnDV8Wz1bCVsWWVlyNFBSCpBzmOsKGGXEMWoQFOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jJ4tdDZbmkUoyCUqZcfsjYh6mQNJ+or8vFY4zpVCXs=;
 b=phLyV8G2+w+s0uN3e1KBMTRa1ANEcP+OuaZooP7YPIjoAUO80mKrJ1CNKWY4on3kTOV7alBb0xNh8isl/zlyMvJGtyWo7sWkpeJM0XzqnadXvk3c3I16jUvA/i5SL1SX/Fs9PiWynE2DzrefPXrni+uCaJHGMMvK1nDH6CwopGo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by PH0PR12MB8774.namprd12.prod.outlook.com (2603:10b6:510:28e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 20:04:31 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%6]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 20:04:31 +0000
Message-ID: <faed09f4-7fb3-4810-bcb7-0315bf4c0e5f@amd.com>
Date: Tue, 5 May 2026 15:04:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] x86/sev: Initialize RMPOPT configuration MSRs
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
 <846263383f9b6a08fc87ce6edb931c912f68c60d.1775874970.git.ashish.kalra@amd.com>
 <CAEvNRgEC2NSROZWz8uxnOSD6t8s1KmmFrr92=e8s30PJzYhQ1g@mail.gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAEvNRgEC2NSROZWz8uxnOSD6t8s1KmmFrr92=e8s30PJzYhQ1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:610:11a::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|PH0PR12MB8774:EE_
X-MS-Office365-Filtering-Correlation-Id: d6cb0bb0-8650-44f4-ea3f-08deaae184ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	01WoMcVobJNmO773zuKuvfhcIo7nW9in7KCy3hh5N01HKS6xODRx50VUqS+55zHOL1YEzaNB7jDHX1Wq3dO5E2n+GpxBcov97CdxEyepJATbrUfzeTn3WDQMW2cWxt37AalqibUBaS3HGfUx8tz9/c/g+GeJrYZHFrmD498bafAcC0GWHCKLLwQWql7z13XjY+AOpsS2ahIXMKGl9QAsNU0XwHmKhlLUXsLR5dcurhLpLaxlRDfpLF391urAHP5B7csOdbyV6cjWNAnM/7FnuAbRt/SyBCKZG3EjdycYRDZKv7tjLSeu3jBSwPtVReMt4+2aBnHw0upOXDVBIDupA1FYtTyzkKfINAZmosz65oWciyZKEwmNR0yizvtqVvO+TeteuUiIxaTEx9fNZK3NdYTumV5Z65xG+1ydJ4MVVl1amjwHaJZTPwlyC7VzqPEo+bBVT2Mjq46d5DjP7kLBcClnF0hiuXEGT2xN20RI5t1j5B8soW9AUT9Rsi3CHn4w/kTRTC//uFY9hgsJA4XeZC0aXPQQUZrodfDGDgz0rNONoj0slrnHs57npGqGUNVamPwIahMnmCIL/pklk3e8xYMnPdG/Vr6hkdSrz6mCyEl7ZN/RMrQvVyPHWzBjto2QYtSx80wD2bclnAhpn0n+H2vD1hhKH0bY9f99TIaTR+WFvnaZ7yAMKC/R/fBvWFOF/JsvAxqQbJRpubbsWp0zA9RrYKxJpxzmh3jCVREIzSx5U44yN1aC3fmOYk4KlRty
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFBKRWg3T09tY1FoMGNtbzIwRytSdUR0RlZkTFRtYzFEUnh2cXZ6UXZva3kz?=
 =?utf-8?B?aml4NXJNUDlvYzZ0TXgzWWVvN05JZjc4MlJEVk5CMEVrbDZzVnJjOWFPcEp1?=
 =?utf-8?B?bU44OTlQQlhISHM4MmVaOUR1ZzlvcUcwOCt1TTNpZGEvY2lHODRVckROUVow?=
 =?utf-8?B?UnBvb1dKSVQxaEdnTWNCaWVMaEhtRjNLV1ZCUHpWOUNDeHJLRUFuTjJ6SmFh?=
 =?utf-8?B?RkdURjYwbXpYNGhGUGpjZWhONzhJRkV6MUhocXpPdzQ0djZaUVJacklZbzRV?=
 =?utf-8?B?UDBkRG41R3BBT1NxRUV0a2lOZytBM0R3NzdsdzE0ejVwOThTTVN0VEdOLy9w?=
 =?utf-8?B?VmljZjRSdW5lR3NGZ1IyWGI0Q3MxV21CZ3RTN0FNeWkvZVlxdklYemZlRjQx?=
 =?utf-8?B?U0RPWmQ4emJYMEk2dy9tTGI3bDFPQ29PdW5VcjlCeVR6SHduYVJndzUremNH?=
 =?utf-8?B?U1A5bjRMZDhseThoZ3Q3YWhmRGJlU2d5NG1IcmNoRFE4RXF6NnNNN2hKcjdk?=
 =?utf-8?B?M2VGci9WMmhxMldKNUZwOTZhNlBPMVRuZjJGYzd2RUt4c2hFcjI3akhsbjJx?=
 =?utf-8?B?bGlSeGh0NXdBOW5OaElDQi9TV1ZpSy9sOVhhemtGVnFqSVJlTStUZWdLQ3A1?=
 =?utf-8?B?R1VzUHFnZ0tZN0FDOVFuNlhlaHdEdks2NTlUaWdqSlJKOVR3R1BGM2k4anNL?=
 =?utf-8?B?eDdPWU1JemJTRzB5alN3bG16emxVdUJSamlkUmhldDRHUnkxVUwreFlTVW4v?=
 =?utf-8?B?TEVKUTZDN1dDRkJBSEtpY0NJeTFNaHFFSjRpU2JCREpadHJMWTdmT3VHMnU1?=
 =?utf-8?B?WHJDeHgyNjNwTm9EZnVFbFg3WXlvR3dYaGNQVVkzRURHdXplK3pvbHJNUWFD?=
 =?utf-8?B?ZytaRFFaeXdZbzE5bHdYbytvNmUvOTU4UEFHU2QwUEV1ek1pTWlmcTdnTmVm?=
 =?utf-8?B?ZlZHVW5NaHZOMjhMMmxvaENCaTl1SXFSd0FlQk9jNXBWT1FZR1ZEeVFId3dK?=
 =?utf-8?B?Uk1vR3JuVFFRTGVXMVR5YU5walBQa2YzanEwcDdMTHRnRTVpY0xUOXI0TVEz?=
 =?utf-8?B?cmtOK25obmVlRGN1eG5SamhSMno0OExHR0hrTmk3R3BqZmhtMmRGYWZ3UlBj?=
 =?utf-8?B?Sk9zUE80N2VjdldtaTdYVnJTK2FjSEtUQ0c1c0g2a1VWMFRabTR4ZkQ5cDRP?=
 =?utf-8?B?NzJ4V25IemFzaDBYS0lJV2JTVk9EaXpxbW9iazF2NzZoajNncnRQOVJSM1p0?=
 =?utf-8?B?R1hJMU9WYzdzTERjYWlHd1RiaS8yUG1mbVo2NVIrWTNwL2EwOGN4N2RnVUhu?=
 =?utf-8?B?NFVacWFFbXFEUVJCT2RDK3ZBRHdyRkZ4Qkd1djEyTHVScXpYR0psV2haSzVP?=
 =?utf-8?B?b25za29LQVo4YXNpQXFBMGxQdWtGWFRrbUZiRUVaQ3gzeTdjOVArclVjdFhr?=
 =?utf-8?B?dHBYcWZ5MUhQM250TzUwVXFLaFY2WmYvYUZrYXZBekliZzJ4VUR6TXNNd2dq?=
 =?utf-8?B?dzFKc0Nxcm0xUHRtQWE5NVFCaW5SYXp4cEpRZ2U5OWVSaWRla0VMc01uME10?=
 =?utf-8?B?bkRUeHJBU0R0YStkMkdROW1iMStzaUNWVW9scUxYcEFrYUNXTm1hckNTOU5i?=
 =?utf-8?B?aC9NT002MEduZ21aa1pCWVIvWCszM2pBQ1FLT2xhUnFvK0wyWG9GM2poU3J3?=
 =?utf-8?B?a2hXZkJickorY2x3akJSRW1kTFdRU1FVdVNORzAxVldleHJ1THVEZlRiZ1Mx?=
 =?utf-8?B?d0o3a09MUzhadHB6c0ExUG5iVEt4S3Z2MnA0czV1VlpkUzJjcnExMCtrM1JM?=
 =?utf-8?B?NzNnUmN1VE5yNVdqZTM2NWpHRDNCRk53RnF6aUN0M1NkbWc5SmxQMkl6Q1V4?=
 =?utf-8?B?UHd0Z3V6TDQzV1ZBQm9iSUhHSW15RXhqWWExZzlzS0JGSm9UUldsSHF6eE5Q?=
 =?utf-8?B?U0Q3c0hTTkNveDliZGRWa0RjUHQyU1VMMG1JamNhVFVqR1dUZXZyVGUxTUtq?=
 =?utf-8?B?S3RYSnVGMzdsZlVsNFIzcko0eTkyQkNmcU9rK0wwWThScW5lM0JNVzNhN1cr?=
 =?utf-8?B?dFNpYXRoR2Q4aFhDSWR3N081YStWUjFOTktZNEpWVXdoTFZUcDZlWnp4WU56?=
 =?utf-8?B?em01VW1La2VaWVowMHNoeDRIY0lFSnNydnZJU2tQaEZCMWNsK3hXa1JoR3VX?=
 =?utf-8?B?a29qcG0wSW9CM3hZMWRlOGpuc0tyK3B1VTV2K043MHNMVENoSnhvMXpHcGg0?=
 =?utf-8?B?eFpITmZEd2lZNnY4VDM3bEtPbkVLRWNmRFhFcFNnd2NTT1IwQ2dHRnZiWnVS?=
 =?utf-8?Q?FxjC83SJYqAiF14+kt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6cb0bb0-8650-44f4-ea3f-08deaae184ca
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 20:04:30.9345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+XFZod5VsDzwjbJ21kJ4jo40Xt2gjzXCMXYdv3MQAdZL1GnTj/lzuGRk69oyf0AYEbpT70Kwa7INYgW4mpNIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8774

Hello Ackerley,

On 5/1/2026 1:12 PM, Ackerley Tng wrote:
> Ashish Kalra <Ashish.Kalra@amd.com> writes:
> 
>>
>> [...snip...]
>>
>> +void snp_setup_rmpopt(void)
>> +{
>> +	u64 rmpopt_base;
>> +	int cpu;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT))
>> +		return;
>> +
>> +	/*
>> +	 * RMPOPT_BASE MSR is per-core, so only one thread per core needs to
>> +	 * setup RMPOPT_BASE MSR.
>> +	 */
>> +
>> +	for_each_online_cpu(cpu) {
> 
> Dave mentioned hotplug in v3 [1], which led me to check. From this
> series, it looks like RMPOPT won't ever be performed for newly-plugged
> cpus, is that okay?

Yes, with this current series, RMPOPT won't be performed on newly-plugged
CPUs, i was computing and storing the cpumask for threads to fire RMPOPT on,
statically during the setup code to save computing it again on the
worker thread, but i believe the simple fix for handling hotplugged CPUs
would be to compute the cpumask every time the worker thread executes.

> 
>> +		if (!topology_is_primary_thread(cpu))
>> +			continue;
>> +
>> +		cpumask_set_cpu(cpu, &rmpopt_cpumask);
> 
> nit: perhaps flipping the condition is easier to read:

Yes.

> 
>     if (topology_is_primary_thread(cpu))
>     	cpumask_set_cpu()
> 
>> +	}
>> +
>> +	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
>> +	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
>> +
>> +	/*
>> +	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory
>> +	 * for RMP optimizations. Initialize the per-CPU RMPOPT table base
>> +	 * to the starting physical address to enable RMP optimizations for
>> +	 * up to 2 TB of system RAM on all CPUs.
>> +	 */
>> +	wrmsrq_on_cpus(&rmpopt_cpumask, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>> +}
> 
> [1] https://lore.kernel.org/all/ab41b1d8-e464-4ad6-ac07-7318686db10e@intel.com/
> 
>>
>> [...snip...]
>>
