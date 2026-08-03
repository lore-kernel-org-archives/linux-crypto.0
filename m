Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010057.outbound.protection.outlook.com [52.101.193.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7C731E851;
	Mon,  3 Aug 2026 18:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785783393; cv=fail; b=iUzSqWzRj6LzelscP3trbh4wX07qCRRR3oyrE6O+EmPCTZqL/AJ3zqn0CrVeeNn+pdDu7JHPzVLcT8wrtCRn+06NXVLaX6Xk5SVKeqTRoXdr6KPyke7mzmUnEWzL7Qs/iN+8og1lJjRJV77JX27wcXxLQhEQQJCDy2L52qYEnr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785783393; c=relaxed/simple;
	bh=MZ3eyIpGAtPOkF87U3qWXfKMF6cmUGkMmGYO4UCWWlw=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oP9uTW24UOHrTvz3EUQ1DbdBPWuKvqrqt7UU8chS3rH4jXQowFuEkq4chLCJtiiz6BD/Upkbn+gf4hziUzeZosMk0mV7lsWAKMTBdl+2vSF26XaVzxdrWhOZZiyOJZQyGhBfJzNu7h7OtAq4A3ynUND7pvO5Jd72iCeJRyB93tU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HFXCtq6w; arc=fail smtp.client-ip=52.101.193.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HFXCtq6w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aXtsrzd6HVOn3nwFKdC97BHDxyT7xRH3zriwmNe+kyFmSp4oVKkNzTi6nP5O8TwV0W+w+6ZMJ+1y3rfaS9PyfZolQCLoLtwaNpg1qpu5dyuWuRgp+QxenYLgptTi95Psc7/edKDVDjhnN4k646BwvJGPDaN304y9zZAKpWzgqi8J1k1OxYNr88VRIqrZHJMcYo4grwdkg79gyH+zCTbcEs2Dn1hXSSwijGmqvvz30K5taXwbVXqEI0Yn9iab42XUaWNqgcfQjRzByWASqaJjmqHrCkGlHZywaIpyLIvfhVaKTQUs00NJtMbtSy7PPUudRompPSeciu1yrCpBrkoIlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09xZfTxcc7YSQSzpayTErZ1/sVuaPzVsL3EhMfs4Lmk=;
 b=RysWNKFS+B8OsBPwjJMbc4wfDqaElvmQmkuI+UHKOiVs2lP04gELiK57n2y1iYtWHBDAnIhbSXLZjWii2LDfMAVvaNRX7EE/LT2sx7odHLJB4d3AlVnO05LmNsPbtklsKOkYS9Ys6xy+7qR19+9u6yxdhu4YGwex5ODfx68tvpikdMNhPxiz524QK7ofmP9uV/bZOenzN7s4Am3HyphYu3GtLsA5CmVKQB5sGCnyWR5QHGFxL8+7FuyS/Qval5sjFB5xCaCi6Sg/A7/xTjwdTaka4i//6ksIu0yutaHrn75y+dT6gV8FMKAxTQ0umNMs+fA5S/uOQ9QwiTamBXt8Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09xZfTxcc7YSQSzpayTErZ1/sVuaPzVsL3EhMfs4Lmk=;
 b=HFXCtq6w+mRp28UZlsi+f4x5O7pKgqmMZr2OFm9pfkN2dlxgmXmR4ZTpn3c3mxiCvHY40/baZX35WNQfdmiOJ+PM/eLbnySYXxeiqKTwaxPXR4LDUMHrqeFn7EahXvm19E82cg8kvwJrvzecN8m5utA5SII4aaNs5F9YqsWz8YE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA0PR12MB7578.namprd12.prod.outlook.com (2603:10b6:208:43d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Mon, 3 Aug
 2026 18:56:28 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 18:56:28 +0000
Message-ID: <748785f1-f176-4f0a-8b8d-eadf46b20960@amd.com>
Date: Mon, 3 Aug 2026 13:56:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 4/6] x86/sev: Add support to perform RMP optimizations
 asynchronously
From: "Kalra, Ashish" <ashish.kalra@amd.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <7f582569acea933c3045be604a81975e29b5ee2b.1784844080.git.ashish.kalra@amd.com>
 <20260731054425.GNamw2OelKuNhVwnrU@fat_crate.local>
 <ecd09557-ed93-4d05-9850-d02c31900f87@amd.com>
Content-Language: en-US
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <ecd09557-ed93-4d05-9850-d02c31900f87@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:610:1f1::17) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA0PR12MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: 8088271e-7fb6-40f4-adac-08def190ec90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	flgMvnYEWYC7TAmmf5gxIlC9vWyZt7bUF55QaGrxeFRPrkXMEI3ZeoHk5blVkz/47NeEncdhU9nPpUMW1DiFL963rLF2R+0UHldknc8r4jBM+N62xglSDuN5y2x8KsN2kWp+59kdE2Iv96DfohZf/EFgOEQDNuk3If/N4jNkSe/nwsO/CWr8GYeYfSsybNgWqSlRPMAmoIzoLRTBwT3Xh2z3h0r+LzzIEbANuOQkhBoq9TU9F6sDAnfLoSA6jmreSNXYz1npmG6vDLJjSExz3ViN2HKlblPaX/IY7gUbR6h/gjC6UfkDYJgt3cMHIEey3AmAEv4GxA6I5RRaJP/Jdc99SP2qs0HPJS9TmykUimmYiWMRsBhSMARFdttrm7LvuqwjLYFKpngbpRLDhuspFDOjlCQM7nL5pQV2TNAhAP/dY4AfijIUSH7C/Jye7k2Npr2FCg0yHvS8IRcnm2ipFrqflzCHtE1kckBXsfDqedksDXuJedZxgQTiPTl3ZABMM7Tl/G8Va0xb1WejM1Mle/Wn7O7WM3MEQBuXvpe7snIzuPNQGZdzxFx1kSWqLlY7hiNPHQ2DkOjSEEyPirFyEhj09I9WUFuwtlNzvLic7ygIxLHycY5vgXVkIKbgGGl+MLguJbMBAbOZeFCjtmrdAS9wVVcooRg0TrbRpokJeD0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVV2cjB4eFVrbGhNNEhzaldTT3k1REROc0FlcTVycGJoYXFraWp0V2NNeHMw?=
 =?utf-8?B?cXluYUNqSXV4aDlaNitnRmpBQjBtZWVYSmRIUEpJTnZhYkJ6OWt0b1hHZzE3?=
 =?utf-8?B?QVN3MDJ2YzZvMUN6cDlZaVVwbll5VEFPNk8wT3N2ZjM2andFbmJNMHBQVWUv?=
 =?utf-8?B?ajNkbmdTakpBaGlvSVk4ZXoxVkljRWpDY05mU05XR0p5c2hHSlJzMk5McGlR?=
 =?utf-8?B?VmViMnM2UDRXTzFZVk9hNFB0SVlWNVR3V0FZMkNtd0cxam8xNFl0T0NNbzI4?=
 =?utf-8?B?UkRmTVJMcDBwWnlwNWJIWVRsNEZiRTd2bVRBdFJMYXdxLzkyT0QwVytTQ0dv?=
 =?utf-8?B?eTQ5bjBqd3Q3NDN3cktEb3E4TXhiK2JMN2Z1U0d4N1Q1ejhxZ3RLU2E1VXdU?=
 =?utf-8?B?S3c0UGc2Z3IvOC9lRGJMeXdjLzFRQWNGOXE5Y3hXaktabFk1ZzdENlRhUUNE?=
 =?utf-8?B?RGdyZ2IxaTlUU21vaDlYNUt2OXRKL283dFdTL2NMNzhLSjZHdU04SmFnNEJG?=
 =?utf-8?B?Z1lvUCtVa1hnR1pqb25WSlVFTERMajZVS3dJK1JmR2Q2R2F3UytBSjV3M3ha?=
 =?utf-8?B?UWYxVkZHUXFDa0RBVFVGQ0l1ZzlHZk0vdnBGaU0vcGZNVSttOGU1UFRRN0Ra?=
 =?utf-8?B?YWpqdUFLblZNc0VaUDZFR0l5VWh6OGVWSE1ENWUrQ2l3b1J2bmR0dWIzMEIx?=
 =?utf-8?B?Ly9FenBJZHUzRGg3WEtjTk4rcElEUW1RTmhHRXhzeU81dzFJeXM2TTdtMnBT?=
 =?utf-8?B?MUpRa2ZFZjVRNlEycExwa1I3MGZpdXdoWGppdzdSZDdNQVNMbnA1Tlk4Vyta?=
 =?utf-8?B?d2VSVUlOOHE4WXJCSGMzZzhwMkJYeW9qTHZ2Qy96U2RDZFNoMFlXclhuT2R2?=
 =?utf-8?B?V0RHa0N3aHJCSEFiQjNSaEFVMUJlV1J4VTBkOCtrK3RZc2F4ZURiTVZHdWlw?=
 =?utf-8?B?ZzFPVlZUV0hKNkhJeU9TVzBndmhYQW9wU1NLbXFncjVCWisrM21zZTVNT1E2?=
 =?utf-8?B?NXZzbmFSWXlicVZjK1JYWFZmVVhuK2lGOStTT3VRWmMyWFh2dFJvZDBWL3Fs?=
 =?utf-8?B?OWxXNzVlTlBWS1NiclJNVVI2UnBMZzMzb1o5V2VqcmZiNnY5ZldaeEJoWm9C?=
 =?utf-8?B?TDB2d2hzazJ5K0liek8wcDQ2YXN4RDlxRmwwUGlPV1A0cit5eEVHdUJZSGt0?=
 =?utf-8?B?QnlBNDZOY1JzUmo2M0ptVEpXT3VQK2QySU0zS1g0ZHZaZnBDWE1zQ3N1N1ky?=
 =?utf-8?B?djhibGpORStUZ1QxZFRkSnhKVTdHOHlwTHhtSlJMODlnMmxOKzY3MTlhclds?=
 =?utf-8?B?WVJOcndRbkZ6TzB3ell5Yjd0NURDK2s0KzRvMTE2K2kxV1hhUlhWbWI5SWZO?=
 =?utf-8?B?S2g2emxVRUpNaVc0QWtmMGNLdUxsWEgwak9heUNhR1ozdHpsRUxmbHlndHEy?=
 =?utf-8?B?U0l5UFdsYzlyUEVJZlE4Y2pGeXRYa2liS0U3MWcrczdNQ1cvRXJYRzRKY3dx?=
 =?utf-8?B?YXhhRk5FNnMwZEQ3blo0ZFYrV0prM0dIUVdmaFArSkdnRmZMUHFXRzV3OFlO?=
 =?utf-8?B?NmMrTmU2NGk0eUs3NVNwYlJQQ3ZpblRZNTNuVm5FZ1ZmeEdsa1IzTk0zekVE?=
 =?utf-8?B?OEVqUW5yWXFtNVk0SzZSZmg5dW5LSnRqUGIvKzlBZGtrSituYXVSMXN4aEcz?=
 =?utf-8?B?M0tpaENRd21hU3RyRmZQZjFJV0N6SStHOUVBaTlCUUdQMXhKMGhFSSsybEY5?=
 =?utf-8?B?M2xqdjhKd1NRRWlkQWdZOGZmckc0T1NjaUxRZlBhNFhjcmoxeFpteGVVVHBD?=
 =?utf-8?B?V0N4Qm9BeUpGNjVwbWJvakZNcTFxcFhPdG9JUDBJZVYxUjE0Zll3UnVnMmZZ?=
 =?utf-8?B?cG9UZENGZEdxK21WUW9qMjJrbjNhM0tQS2wzMGVYMUZUTTRFVkNoV01pMkVj?=
 =?utf-8?B?SEJRK0tnd3dOODZKc211VkZoc2N0REJhL0lRQi9pZGcvUUNrZ2xkc1hmNURN?=
 =?utf-8?B?REhVSC9tYXBMZ0xpZ0RsOHFkWkphU0s0bXRVSjIzYmdWdnFJVmhiTVA2M2N6?=
 =?utf-8?B?b3E5RjBDRU5EejdkVXhmd1RxT1EzeEFCRGJ2UTI5eXNmZmV0MXJzR2hXbVRO?=
 =?utf-8?B?c3hFTGhOSzBiaFFIWkpBNExpSlVET0dNNmVKM3l4U3lNUWtYQzhCSkdhcEJN?=
 =?utf-8?B?b0NBYXR4MW1kOTFUZUQrOFBxK1RCSXp1dmZuSmEzL0NTaDVOZzhsK2IwT2Zo?=
 =?utf-8?B?aHRMYXRMRVZHZDhteStyTmFMZVJIOWJaUHlDZ3F0UitneGtiY1p5ZEF0dHFS?=
 =?utf-8?Q?7MYzbPOWcYJ+sLIa4H?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8088271e-7fb6-40f4-adac-08def190ec90
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 18:56:28.2902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /rgXApiOlKe2sgjAh71G8CEIPm6MkYRjjF65yCMt+1LVrxUvSfXGXDCctObV647au3553NgZdJ/DiW3wkelnyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7578

Hello Boris,

On 7/31/2026 7:37 AM, Kalra, Ashish wrote:
> 
> On 7/31/2026 12:44 AM, Borislav Petkov wrote:

>>> +	migrate_disable();
>>> +	this_cpu = smp_processor_id();
>>> +
>>> +	cpumask_andnot(follower_mask, rmpopt_cpumask,
>>> +		       topology_sibling_cpumask(this_cpu));
>>> +
>>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>>> +		rmpopt(pa);
>>> +
>>> +	migrate_enable();
>>> +
>>> +	/*
>>> +	 * Followers: run RMPOPT on the remaining cores.  cpus_read_lock() is
>>> +	 * intentionally not held here: CPU hotplug is disabled for the entire
>>> +	 * time SNP is active (see snp_prepare()), and this work only runs while
>>> +	 * SNP is active, so the follower set stays valid across the whole scan.
>>> +	 */
>>> +	for (pa = rmpopt_pa_start; pa < rmpopt_pa_end; pa += SZ_1G)
>>> +		on_each_cpu_mask(follower_mask, rmpopt_smp, (void *)pa, true);
>>
>> An IPI per 1G pa?!?!? On each CPU?!
>>
>> Instead of IPIing each CPU and inside the handler, doing the loop?
>>
>> Nope.
>>
> 
> You're right — an IPI per 1 GB is far too many. Will restructure to a single IPI per follower core: a new on_each_cpu()
> callback can loop over the whole range on the CPU it runs on. The leader will call it directly (migrate-disabled) to populate
> the RMP scan cache, then one on_each_cpu_mask() will run it on the remaining cores.
> 
> This will also fold nicely with the earlier cleanup:  __rmpopt() getting merged into rmpopt().
> 
> One important tradeoff to be aware of: each follower IPI handler will now run a 2048-iteration loop with IRQs disabled — 
> but followers are RMP-scan cache hits (the leader populated the cache), so each rmpopt() there is cheap, and this only runs
> at setup and guest-teardown re-optimization time.
> 

Following up again on the tradeoff above.

Referencing your point about not IPIing per 1 GB, two ways to run the follower scan (followers = primary threads only, one
per core, so ~half the logical CPUs — not every CPU):
  
 A) Loop on the worker, IPI per 1 GB: loop is preemptible / IRQs on, only a single op per IPI runs IRQs-off — but 2048
 IPIs per follower.
 
 B) One IPI per core, loop in the handler: a single IPI per follower, but the whole ~2048-iteration loop runs
 non-preemptible with IRQs disabled.
 
Followers are RMP-scan cache hits (cheap) and this only runs at setup/teardown, so I'm leaning toward (B) — but it does
mean a bounded non-preemptible/IRQ-off window per core. If you'd rather keep it preemptible, I can run the per-core loop
as per-CPU work instead. Which do you prefer?

Thanks,
Ashish
