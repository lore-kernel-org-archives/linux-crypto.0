Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1373BED37;
	Mon, 20 Jul 2026 20:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784578653; cv=fail; b=PJlEmpD/YN9CwUgZdL5KOCVTg0yul30xeoYPPdZavwaNW0Gd2Y3Axb4e9yUxYNlmRwzppAtCx/Ewt0Xzcvvi5J13wPO4jtv09lpN9jmuKuxo0zVhhhaxyhZ/T2nbyJqpiT9APi/l+dxnnEI9S1MVO+Wzk5DBDzKccdlA1b/Y9YE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784578653; c=relaxed/simple;
	bh=ykMaHhH/GME1FGXNnlKafUwQpRMBQJbfLYb6U2EeR9o=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LGVCfbip24MFNjEwSKpZitabY4ntQIM/nbqHmNnpt5Mzk6L+yIZHzLj4Wh8vzXTV6MWtWIC2nEjPnRwBA6XN28Br3COUIVtTx2oaFrcmteIsZMh47+1e9vOO12xV4+klvV6NjhzehvzG3jMH0/HrwLX8dhaj2kgEFg3rcYKbrAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p1JtrhhB; arc=fail smtp.client-ip=52.101.193.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p1JtrhhB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TGTSIUQXuX45xjcHsIIPgxpu5Gm+BsKEfxv85lSU/u+Qo2xV8P0lLnDerqwIt22dcMlUXiKwY01qXDu04oh/zksp90nMDQZJanS3Xj7EIwiS3VfrF4F3PHx165jXPOB0mZhdrLDaoYYwM51Jbiu0dH2T3C2zIaICSYo/ZVays1Bcn5gHraWjm2gILozKW1mqp6bJ8oAdaROfqnbVF+V57z2oIHGeiJj1lyQ5G9OEiW47m+h+1GXx9ddk4ARm4BCGsON69B25FlF6oKmZUp+GzkImJ/uX0N31zIzLCDXk0IuVnj69G2vaEnGr1DL+xgyDjpzvGQS67WVyZ451RqLLeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pu5nYpDGQ3vAt1bJYtjY0oQ3n8T/9VRGzrvAGWlY+3w=;
 b=Z6X584N4w8oueYwmyS0CFviBB4yyLzUCtqX34S5gfdbgvWovG5oHkO5hUKL+JCZwcKGkOgWkEuusJmQNe4FrqP+ndNTQ0+uCtB+OBPUUjJn8QzgLQjLQ97MRRmbL+8xGwfKY8JTGm91B9dwZW1KPME7OTcEIHZGRTK00WPahUhWqBhAX7qZF8GGWcndjDcMtHKRVSC3o1blFOSoTfVx5cWDZ1T9toJIS1A3nV0NL10691N+daUD8uugf71U6qvZ5UrS+/q1bvArsDSNshtKIOgxnorc5F9jBi1tiYW/ZdE+bdpY/AYrEojtSWKelvU3223bJpFRTLrWtBimQ29Q2bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pu5nYpDGQ3vAt1bJYtjY0oQ3n8T/9VRGzrvAGWlY+3w=;
 b=p1JtrhhBwCuA7JbGCJJehH+7VbuPcSYMtyQeHDK6SXj9R3B4K8qziarIs+EDqDydHTdfM7hlE+bj9kILhPhORKKsEGh8V+sD801iktPsP4XdDPzPqc+gQO2iOXGJZopl2YyVIj3VVJ0eZI2bxg9dVAX/OvtX+XtCxyPezGtMPx0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB5887.namprd12.prod.outlook.com (2603:10b6:8:7a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.18; Mon, 20 Jul 2026 20:17:27 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 20:17:27 +0000
Message-ID: <aad54bd5-8a5e-418d-8cb2-2cec6527993b@amd.com>
Date: Mon, 20 Jul 2026 15:17:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/6] Add RMPOPT support.
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782841284.git.ashish.kalra@amd.com>
Content-Language: en-US
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <cover.1782841284.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::8) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: e14a9c52-3934-4dc2-9412-08dee69beacc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|921020|6133799003|56012099006|11063799006|5023799004|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	bhlhI1h0OsfNad6/kz5Buvt0mssr5n4jozqqQYFslAsLu4gLf6nhr88vKP2yld6uPoO4XutD84B7dpki73LqTgxZVk6A6LbJA5flbsd9H+DmT2JK4V1lfnatM6BoefXbmJZhWfD/yorYrkQ65nyJV+1KZtW7EHWI1yMJhDOzjVCOV652GzIXMt61LbkZzIOhKJ/a+QiF2lQMYXxsS2tb+QuVFNJLvr3df9o8aDcTLckNTtGgnmDX+aRTgoZG4JDhHDEDRnXvkILHkRY5tLP9cSsAEtUgzrU5pWNVTjjlW3L89Jft63Gf6O8kMPf/SwnsEYo8tBLyj/reLyxh1/AjtxdMW+j7LtPRwUgU+pLqtHH5xGpV4Zp56r6sF8Fa7O9TcDUmLP/TzrezFn0Yz1pcA/c4hnxjHofg4lXfXbE4Y5u9Y2kl4/zZyd8m8iZZycPodECVW3da09SWmtjGUGuOTci2o8RIjcoEStYsW3aCBqNA5qNpO6Uqz350NnvMkYmk391jx+V7bWxpDZx0vQmiUnDhXw52YXjrQvCm1Pf+dVEmG8ud3uDduwc7INzRlOfz+B17XWfh/Vbia3G3oeMuvMhHvmSM5yT+X7iF3Rxx5APJmveQLiUpsz5+EaS1ImayTNLyJYotiagQ8dBGD/1zwNbf1EZx4fMTqoUSw0Y53aTCymJ+UTTI3vYq7dNRmRAnyeLkBG+dxFMvy96cjiJ5iQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(921020)(6133799003)(56012099006)(11063799006)(5023799004)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b05QRGhneXliTGtUNHl3b0JxdnJ0RncyZFdxZ0NoV2dSY1B5amdud3cwaXVS?=
 =?utf-8?B?dXRNMGpEZlZrL1I2aVF1T3hQZ0RWVXFMeVZOR2NYRlo0V0tEeU1xd2RSUnNF?=
 =?utf-8?B?N2pZYnptamZZUzgrVXZaSWl4OW1YSWk4NklqRHloS2ZWQjR4YS8zeU9zNTVa?=
 =?utf-8?B?dVN5MjRvcDBGRlVjOVluUVVvNXhNeWkwUzVtQzMxK3dmakJkeXlmbVVLbHV0?=
 =?utf-8?B?bHZJUFJGS3RrSHVTamdtMmhzdFV5VHowUTVMY2Y5U1M1RlNPMHF6aVYwQysz?=
 =?utf-8?B?cG1MeDRKZHJSS2xDSDhETkZOSzFWTWQ5LzZVU2xXdEZkWDJ0SG1xWEtOdDcw?=
 =?utf-8?B?S2ZVT29hUnZDU2xMaUR0ZW44My9xQmNmelRoS3VldGZDQmxLK3dLMXBFYTJT?=
 =?utf-8?B?cGdKSENCOGV2TEZyZWFRbU9LN2wwWWRoMTYzSnhxUlVXb2QwMHF0Y2ZCWjNW?=
 =?utf-8?B?dlNRV3lEY2dYZ3prOEEwd0pFYWFYUWFscXBzSXM5ZXNTYXBBVHJRaXBzSkpT?=
 =?utf-8?B?L2ZwVzhHZzNNZG1WOHU0L2YxVXV0eE5MNlBiYmFzSEJEbEZuMDhoTmNYNzc2?=
 =?utf-8?B?S1JEZ05Sd2w1VFl1V3RqeW1pbk1xK3R5VldXVFJPU1hxOSsvcjdzY3BPUG9t?=
 =?utf-8?B?UWUrcHJTeWdUdU52R3JWTjFseWFDdzBESzNvT1pxZEtaNWZmV2UyTDlMTHJU?=
 =?utf-8?B?U015T1AvdUNOUWVKSDh4MG1BL0g3V2hnZnBYZG1VMU9Qa3RnU0dyWDlFc3dF?=
 =?utf-8?B?c1ZLV0lmdllnLzFzdzduVGoxK2Eya0tLb2ZQSko0bGlQR0gvbHVlSEw0ZXAw?=
 =?utf-8?B?R2xmUDlhaHcrVmtlVzI4dEh6L01WQ09ha2JWa3lJemZhNGVBYmE3bjN2d20y?=
 =?utf-8?B?cEExeVhyMmVtRG02YXErQTE5U1dQZUluSGJWOGZtSDFpaitYby91NEorOU4y?=
 =?utf-8?B?ZmZBNFpZajRHWUJTUS9FMWNPQmF6bFZaay9yWDgrRkRWYkZRTnZKdDZvNk8r?=
 =?utf-8?B?d09MYUhwKzlyeDY5SUJ1U0tKdk5ySjZOQzhSWHpHQXNRQU1kUWVjSThiaUV6?=
 =?utf-8?B?VGJUcVJ6dHRjZEFBQ0JCdWpCVWpBQXBOcnBSa3Npd3ZnK0V5R2NiYk0xbm1N?=
 =?utf-8?B?NnF4VUNJby9XQ3VRaE53WkVlWVNtNnVjOXB1SGFjWU1jakk3ekxjTEY1cnhQ?=
 =?utf-8?B?RGgrWlZpZnRNUFhZSHdNb3dyVC9MR3BmcEJyZGJ1WnYyZDkvR2NGRFQ2TUNY?=
 =?utf-8?B?RUJYNmFuU1FDSk5CVzZORWppSnVzZk1wbjNDQWhjaUlOWWhVbUx3QVlzZ0Uw?=
 =?utf-8?B?T0FmVXR4UGxUT1lPUU9wOHVYSE9ybEJaYkNiZDE3b00vNmJ1VWZkR3dBN0Nk?=
 =?utf-8?B?cHFvNWNmanVFS1MrNjhJYzZzT1A0Snh5cDRudWxMUnNvbWdpc1dkN0xNeVNt?=
 =?utf-8?B?N2tSYTF4djQyNUkwMDZnbkFKdXdaRXFFY3JuVk5oWVFGMWUxMzRrSUpaVmNE?=
 =?utf-8?B?R3dFTktLbDRZQ2k0YSs0TzBPMHFuT3VGdUhqaGozMi9jTDFpajdFcVlJR2FF?=
 =?utf-8?B?WlNVOUdPSSsrejR6SFNEdWlxeEpXR0ZENllOUVpKVFp6YmwzL0s0Uk03OWh4?=
 =?utf-8?B?bkV2Und1QncvL1haTmpBa3BxdE02M0Z6L1l5VXdBcTNQNXlkcWo1S2ZNTWZO?=
 =?utf-8?B?Wm1KWHlQR1VXemVLUWcyRmk1TUl5QmxoMlhMdHRKRkJ0cE0xMEpFYzlhc3di?=
 =?utf-8?B?UkZrK3lVYkFJRXVJaTBSRFlGMUxGUmdmZDA5SGRFdHVIY3lmSlFKSUdSa0s3?=
 =?utf-8?B?bXhERmFOWDhzdko5U1FtQXJCbWJKV0hJWjVUeG04WjMwQkJsRm5KUlRLaDVy?=
 =?utf-8?B?NktKUmp2azN0UVFoRUFNelcyb1pENDVrYVI4L3BMRTllQnhQMytBaGo3M2VX?=
 =?utf-8?B?MEZROS9ubU1zNmRaUENzZ1lKbzYyaUptRDZ2RmQ2NG1kaDFkQmZxajJ3S2lw?=
 =?utf-8?B?OTg3Nm1LV2VUbzRER1VuZTRaYlowOTlLNDNieVNSY0NVVC9qSG04aFZJUXhD?=
 =?utf-8?B?eXNtdVBtU0dDa1dPSTNudlVlbVdoTXROYlc2RUtSRVZhYjN2aUVPdFh4VlJM?=
 =?utf-8?B?VWNlZ1ZlTDNncmxxZjFJSFdJaEljb0E5dnRHMm9ISDJmQmVERWFQa212ZkRz?=
 =?utf-8?B?Q25MTC9GNnllaFNzVmZhbVlVRWkwSUxWMFByczdPNGVnemtSdmJPcXVtbi96?=
 =?utf-8?B?MUUzazFDclBuSnRLZCtONncreVJObUg3UjdhRXJDRVQybXBkQ2VmOExoS2tR?=
 =?utf-8?Q?98N1XWyYPcH7yE5+a9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e14a9c52-3934-4dc2-9412-08dee69beacc
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 20:17:26.9893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WMY40T8qDs/Oi4y5wczOCbCkz8igulPWMJcfy5IteTLu6l/o+Sn00RdaXJw4ScTuksMUt6pjLBh/hG2xFRORQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5887

Hi Boris, Dave,

Just a gentle ping on this series. I believe v10 addresses the feedback from the earlier rounds. 
Please let me know if it looks good to merge, or if there's anything else you'd like me to change.

Thanks,
Ashish

On 6/30/2026 1:08 PM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> In the SEV-SNP architecture, hypervisor and non-SNP guests are subject
> to RMP checks on writes to provide integrity of SEV-SNP guest memory.
> 
> The RMPOPT architecture enables optimizations whereby the RMP checks
> can be skipped if 1GB regions of memory are known to not contain any
> SNP guest memory.
> 
> RMPOPT is a new instruction designed to minimize the performance
> overhead of RMP checks for the hypervisor and non-SNP guests.
> 
> RMPOPT instruction currently supports two functions. In case of the
> verify and report status function the CPU will read the RMP contents,
> verify the entire 1GB region starting at the provided SPA is HV-owned.
> For the entire 1GB region it checks that all RMP entries in this region
> are HV-owned (i.e, not in assigned state) and then accordingly updates
> the RMPOPT table to indicate if optimization has been enabled and
> provide indication to software if the optimization was successful.
> 
> In case of report status function, the CPU returns the optimization
> status for the 1GB region.
> 
> The RMPOPT table is managed by a combination of software and hardware.
> Software uses the RMPOPT instruction to set bits in the table,
> indicating that regions of memory are entirely HV-owned.  Hardware
> automatically clears bits in the RMPOPT table when RMP contents are
> changed during RMPUPDATE instruction.
> 
> For more information on the RMPOPT instruction, see the AMD64 RMPOPT
> technical documentation.
> 
> As SNP is enabled by default the hypervisor and non-SNP guests are
> subject to RMP write checks to provide integrity of SNP guest memory.
> 
> This patch-series adds support to enable RMP optimizations for up to
> 2TB of system RAM across the system and allow RMPUPDATE to disable
> those optimizations as SNP guests are launched.
> 
> Support for RAM larger than 2 TB will be added in follow-on series.
> 
> This series also adds support to disable CPU hotplug while SNP is
> active, as the SEV firmware enumerates CPUs at SNP initialization and is
> not aware of the OS bringing CPUs online or offline afterwards.  This
> also keeps the set of CPUs stable for the asynchronous RMPOPT scan, so
> the per-core RMPOPT_BASE MSRs programmed during setup remain valid.
> 
> This series also introduces support to re-enable RMP optimizations
> during SNP guest termination, after guest pages have been converted
> back to shared.
> 
> RMP optimizations are performed asynchronously by queuing work on a
> dedicated workqueue after a 10 second delay.
> 
> Delaying work allows batching of multiple SNP guest terminations.
> 
> Once 1GB hugetlb guest_memfd support is merged, support for
> re-enabling RMPOPT optimizations during 1GB page cleanup will be added
> in follow-on series.
> 
> v10:
> - Rework the CPU-hotplug patch (3/6): disable CPU hotplug in
>   snp_prepare(), before SnpEn is set, instead of late in
>   __sev_snp_init_locked(), so no CPU can come online without SnpEn during
>   SNP initialization (per upstream review).  Tie hotplug to SnpEn: it
>   stays disabled while SnpEn is set -- including across a failed SNP_INIT
>   and across the legacy SNP_SHUTDOWN_EX path -- and is re-enabled only
>   once the firmware clears SnpEn on the x86_snp_shutdown path.  Drop the
>   separate idempotent flag: snp_prepare() re-enables hotplug on its own
>   early failure, and a kexec target that boots with SnpEn already set
>   disables hotplug once in snp_rmptable_init().  Reword the commit log and
>   comments accordingly.
> - Emit a pr_warn() in rmpopt_work_handler() (4/6) when the follower
>   cpumask allocation fails, instead of silently skipping the optimization
>   pass.
> 
>   Sashiko AI upstream review identified several of the above issues.
> 
> v9:
> - Rename rmpopt_configured to rmpopt_capable.
> - Make rmpopt_cpumask a cpumask_var_t (allocated/freed at setup/cleanup)
>   instead of a static cpumask_t.
> - Drop the v8 WARN_ON_ONCE() on the RMPOPT_BASE writes; use a plain
>   wrmsrq_on_cpu(), matching the SNP MSR-write convention in this file.
> - Disable CPU hotplug with cpu_hotplug_disable()/cpu_hotplug_enable()
>   (per tglx); re-enable only on the full x86_snp_shutdown path.
> - Simplify rmpopt_work_handler() to a single leader-then-followers path:
>   with CPU hotplug disabled while SNP is active and snp_prepare()
>   requiring all CPUs online when RMPOPT_BASE is programmed, every core is
>   always programmed, so the explicit-leader fallback is now unreachable.
>   Drop it along with the v8 work_on_cpu()/rmpopt_leader_fn() helper.
> - Drop the debugfs interface (was patch 7/7) and its report-only
>   plumbing; observability will be revisited after this series is merged.
> - Restrict snp_rmpopt_all_physmem()'s export to the kvm-amd module.
> - Use scoped_guard(cpus_read_lock) for the per-CPU MSR and follower
>   loops.
> 
>   Sashiko AI upstream review identified several of the above issues.
> 
> v8:
> - Add a new patch to disable CPU hotplug while SNP is active, keeping
>   the CPU set stable for the RMPOPT work handler.
> - Drop the setup_clear_cpu_cap(X86_FEATURE_RMPOPT) calls; the
>   rmpopt_configured bool is the runtime guard.
> - WARN_ON_ONCE() on the RMPOPT_BASE MSR writes that previously ignored
>   their return value.
> - Simplify rmpopt_work_handler() by removing the explicit-leader
>   fallback: with CPU hotplug disabled while SNP is active and
>   snp_prepare() requiring all CPUs online when RMPOPT_BASE is programmed,
>   every core is always programmed, so the running CPU can always be the
>   leader.  This drops the smp_call_function_single() fallback (and with
>   it the AB-BA deadlock and IRQ-latency concerns) and collapses the
>   leader selection into a single leader-then-followers path.
> - Use mod_delayed_work() in snp_rmpopt_all_physmem() so the batching
>   delay tracks the last SNP guest termination.
> 
>   Sashiko AI code review identified several of the above issues.
> 
> v7:
> - Sync tools/arch/x86/include/asm/cpufeatures.h to mirror the kernel
>   header for X86_FEATURE_RMPOPT.
> - Fix commit title to use X86_FEATURE_RMPOPT to match the code
>   (was X86_FEATURE_AMD_RMPOPT).
> - Add static bool rmpopt_configured, set only when segmented RMP setup
>   succeeds in setup_rmptable().  Check rmpopt_configured alongside
>   cpu_feature_enabled(X86_FEATURE_RMPOPT) in snp_setup_rmpopt() and
>   snp_rmpopt_all_physmem(), because setup_clear_cpu_cap() is unreliable
>   after alternatives are patched.  Add snp_clear_rmpopt_configured()
>   called from amd_cc_platform_clear() when CC_ATTR_HOST_SEV_SNP is
>   cleared.  Do not use __ro_after_init on rmpopt_configured since the
>   writer snp_clear_rmpopt_configured() is not __init.
> - Add cond_resched() to all three leader loops in rmpopt_work_handler()
>   to prevent soft lockups on systems with up to 2TB of RAM.
> - Add comment above __rmpopt() documenting the RMPOPT instruction
>   encoding (F2 0F 01 FC) and register interface (RAX = system physical
>   address input, RCX = operation type input, RFLAGS.CF = output).
>   Note: RMPOPT does not modify RAX unlike PVALIDATE/RMPUPDATE, so
>   the existing "a" (input-only) constraint is correct.
> 
>   Sashiko AI code review identified several of the above issues.
> 
> v6:
> - Drop wrmsrq_on_cpus() helper; use for_each_cpu() with wrmsrq_on_cpu()
>   instead, as RMPOPT_BASE MSR programming is not performance-critical.
> - Rewrite rmpopt_work_handler() leader selection to use a local
>   follower_mask copy instead of modifying the global rmpopt_cpumask.
>   This eliminates the current_cpu_cleared tracking and the restore at
>   the end, and removes the need for synchronization comments about
>   transient cpumask inconsistency.
> - Add three-way leader selection in rmpopt_work_handler():
>   1. Current CPU is a primary thread in cpumask: run leader locally.
>   2. Current CPU is a sibling thread whose primary is in cpumask:
>      run leader locally (RMPOPT_BASE MSR is per-core), remove the
>      primary from followers via cpumask_andnot(topology_sibling_cpumask).
>   3. Current CPU's core has no RMPOPT_BASE MSR programmed: pick an
>      explicit leader via cpumask_first() + smp_call_function_single()
>      to avoid #UD, with cpus_read_lock() around the IPI loop.
> - Add WARN_ON_ONCE guard for empty cpumask in the explicit leader
>   fallback path, with migrate_enable() before goto out.
> - Add .llseek = seq_lseek to rmpopt_table_fops for consistency with
>   other seq_file-based debugfs files and to support tools like "less".
> - Change debugfs file permissions from 0444 to 0400 to restrict access
>   to root only.
> - Add comment in rmpopt_table_seq_show() explaining why cpu_online_mask
>   is safe: RMPOPT_BASE MSR is per-core and snp_prepare() ensures all
>   CPUs are online when the MSR is programmed.
> 
>   Sashiko AI code review identified several of the above issues.
> 
> v5:
> - Introduce rmpopt_cleanup() to tear down workqueue, debugfs, cpumask,
>   and MSR state, called from snp_shutdown().
> - Introduce rmpopt_wq_mutex to serialize snp_setup_rmpopt(),
>   snp_rmpopt_all_physmem(), and rmpopt_cleanup().
> - Introduce rmpopt_show_mutex to serialize debugfs reporting of
>   rmpopt_report_cpumask.
> - Move snp_rmpopt_all_physmem() call after SNP DECOMMISSION during
>   guest shutdown.
> - Use migrate_disable()/migrate_enable() for CPU pinning in the
>   rmpopt_work_handler() leader loop to maintain CPU affinity without
>   disabling preemption for the entire RMPOPT scan.
> - Add cpus_read_lock()/cpus_read_unlock() around the follower
>   on_each_cpu_mask() loop in rmpopt_work_handler().
> - Guard snp_setup_rmpopt() against re-initialization when
>   SNP_SHUTDOWN_EX with x86_snp_shutdown=0 skips rmpopt_cleanup()
>   but clears snp_initialized, preventing workqueue and resource
>   leaks on repeated init/shutdown cycles.
> - Replace setup_clear_cpu_cap() with pr_err() on alloc_workqueue()
>   failure in snp_setup_rmpopt(), as setup_clear_cpu_cap() cannot be
>   used after alternatives are patched; callers check rmpopt_wq != NULL
>   as the runtime guard instead.
> - Add pr_info() when RMPOPT coverage is capped at 2TB.
> - Add comments noting CPU hotplug is not supported with SNP enabled
>   and only online primary threads are covered by rmpopt_cpumask.
> - Add comment in setup_rmptable() noting Segmented RMP must be
>   enabled to enable RMPOPT.
> - Simplify cpumask setup loop to set if primary thread rather than
>   skip if not primary.
> - Improve grammar and clarity in snp_setup_rmpopt() comments.
> - Added Reviewed-by's.
> 
>   Sashiko AI code review identified several of the above issues.
> 
> v4:
> - Add new wrmsrq_on_cpus() helper to write same u64 value to a
>   per-CPU MSR across a cpumask without per-cpu struct allocation
>   overhead.
> - Rename configure_and_enable_rmpopt() to snp_setup_rmpopt().
> - Use wrmsrq_on_cpus() instead of wrmsrq_on_cpu() loop for
>   programming RMPOPT_BASE MSRs.
> - Add setup_clear_cpu_cap(X86_FEATURE_RMPOPT) if segmented RMP
>   setup fails or workqueue allocation fails.
> - Add X86_FEATURE_RMPOPT feature clear logic in amd_cc_platform_clear()
>   for CC_ATTR_HOST_SEV_SNP.
> - All of the above allow checking for only X86_FEATURE_RMPOPT for both
>   RMPOPT setup/enable and RMP re-optimizations.
> - Rename snp_perform_rmp_optimization() to snp_rmpopt_all_physmem().
> - Split rmpopt() into rmpopt() and rmpopt_smp() for SMP callback use.
> - Introduce separate rmpopt_report_cpumask for debugfs reporting,
>   distinct from rmpopt_cpumask used for primary thread tracking.
> - Remove snp_perform_rmp_optimization() call from __sev_snp_init_locked()
>   and instead setup and enable RMPOPT after SNP is enabled and
>   initialized.
> 
> v3:
> - Drop all RMPOPT kthread support and introduce adding custom and
>   dedicated workqueue to schedule delayed and asynchronous RMPOPT work.
> - Drop the guest_memfd inode cleanup interface and add support to
>   re-enable RMP optimizations during guest shutdown using the
>   asynchronous and delayed workqueue interface.
> - Introduce new __rmpopt() helper and rmpopt() and
>   rmpopt_report_status() wrappers on top which use rax and rcx
>   parameters to closely match RMPOPT specs.
> - Use new optimized RMPOPT loop to issue RMPOPT instructions on all
>   system RAM upto 2TB and all CPUs, by optimizing each range on one CPU
>   first, then let other CPUs execute RMPOPT in parallel so they can skip
>   most work as the range has already been optimized.
> - Also add support for running the optimized RMPOPT loop only on
>   one thread per core.
> - Replace all PUD_SIZE references with SZ_1G to conform to 1GB regions
>   as specified by RMPOPT specifications and not be dependent on PUD_SIZE
>   which makes the RMPOPT patch-set independent of x86 page table sizes.
> - Use wrmsrq_on_cpu() to program the RMPOPT_BASE MSR registers on
>   all CPUs that removes all ugly casting to use on_each_cpu_mask().
> - Fix inline commits and patch commit messages
> 
> 
> v2:
> - Drop all NUMA and Socket configuration and enablement support and
>   enable RMPOPT support for up to 2TB of system RAM.
> - Drop get_cpumask_of_primary_threads() and enable per-core RMPOPT
>   base MSRs and issue RMPOPT instruction on all CPUs.
> - Drop the configfs interface to manually re-enable RMP optimizations.
> - Add new guest_memfd cleanup interface to automatically re-enable
>   RMP optimizations during guest shutdown.
> - Include references to the public RMPOPT documentation.
> - Move debugfs directory for RMPOPT under architecuture specific
>   parent directory.
> 
> Ashish Kalra (6):
>   x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
>   x86/sev: Initialize RMPOPT configuration MSRs
>   x86/sev: Disable CPU hotplug while SNP is active
>   x86/sev: Add support to perform RMP optimizations asynchronously
>   x86/sev: Add interface to re-enable RMP optimizations.
>   KVM: SEV: Perform RMP optimizations on SNP guest shutdown
> 
>  arch/x86/coco/core.c                     |   2 +
>  arch/x86/include/asm/cpufeatures.h       |   2 +-
>  arch/x86/include/asm/msr-index.h         |   3 +
>  arch/x86/include/asm/sev.h               |   6 +
>  arch/x86/kernel/cpu/scattered.c          |   1 +
>  arch/x86/kvm/svm/sev.c                   |  10 +
>  arch/x86/virt/svm/sev.c                  | 277 +++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c             |   3 +
>  tools/arch/x86/include/asm/cpufeatures.h |   2 +-
>  9 files changed, 304 insertions(+), 2 deletions(-)
> 
