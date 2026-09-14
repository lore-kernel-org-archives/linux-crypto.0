Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB9B368968;
	Mon, 14 Sep 2026 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416020; cv=fail; b=mEzFlbe1UKTCRUwLwzxQ4gN5kf4NvmJJVq32w++Pubtr/zWU8stWHfuAJYpwpv06t3alLTTC01XeV2SrhbsYejJJ8kjhHHjI9um8E5QkmNrI2daW2mM8TUA8tvS6S7AeUbv934ax412FDufcPSwXLy5n3blV9Lecbc+uL9k4mmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416020; c=relaxed/simple;
	bh=9kjzKIybsWDuaEzjxT+h4coRhh16Dtrfhrz615TsO+Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bno5NMJuY4sFzvYE+YX2EN5M61uO0oqsEJmHm7HBKsnlnegtotXiC74sD8X2DpBfMbiuSHS/xQ7yslpjqjdJC3ZY01xgoAimjRDvyyDabZLc7upbTgkwdqjeXKN8z11aNM0VXz9GtLqqIU0jL9fgRp+FcpciRGzxjxVnytdOprA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Mc8HDNb0; arc=fail smtp.client-ip=40.107.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Mc8HDNb0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BEYWegXBOmYKCcfA98in6qv++DIgAPO/Hg41NsGh8NtGafPeAEEJzeRLtPWM2H91cnXI/73vcXSWwT0yNYf1AR0TNcYP0ixsRdMrnOgmzL7O3Fs/XqzFZvpng5qxPHljGfSswz4jc5iln3Oq56fPn9KEpH+DuQK4nJ5VVdffeYGEzL4wz1Gr8/tZkCeBpJxBFHnhAb5OBBrIsbKBiazwbtgo6BrWR3MH6ORSQXXL0549/ebyBSKHYeDhXSNf6MyUcCKEDJ5w1PU+TeB1QLK+/UfDVaboHhhai5+bQM+tDk4P7P1eZY0bmlbIa4/nZ4GPK7+5guxTe5C6GMN19+7v3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nN16nTFdYXD8eua/U3VeK5WmC22aR0VLk4NVSVLWlgg=;
 b=XCEXXO+oPj/PFlavCT0YfzS24W0HpPh0C8wWUUV+/noaIR4QsSkggsCulTKqBxws3hvJOj25m9E6FJGn+yZ7QlnjxGAqqqsyW2YpDPuHLR1JMjf1Ut8LaRXz/STCpnUWPmUJ09POxC6UFsbX0TB6SPaBM34ckEWidgSCUVikS/j675MfmjTiz5x3vp4aJEsPQZo3oykqLd0kycHW4UouqtG5PZD6Gy4C/jkgjDd+JchJCu2Ssb1X31Lxo3B37bZP1JQsnl69IwF/SVcYN7CnVr6jwJRBSWzq+T8RjlFGYrV6lX1uPGXJkBFT7iLm6yX9d5KwxbTFSTPL+/NFhJfudw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nN16nTFdYXD8eua/U3VeK5WmC22aR0VLk4NVSVLWlgg=;
 b=Mc8HDNb0zzg0+9DQJ6ccjj3mHdgQbPG0Jf10arBrFUmsjbvw24ov/nFWfUW+/6+uqnOk1txK51oQkShSxE1I7txR+GWfxOUc+hQU8/83sgsF3qkHBvPsutZ8qneIIbTcn2a5Zho/B9DtmZHWrfECL2rXp1ZPsVpE1sgb55ciiJU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Mon, 14 Sep
 2026 20:00:14 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%6]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 20:00:13 +0000
Message-ID: <279595c8-30bb-4c01-8203-95619bab3d47@amd.com>
Date: Mon, 14 Sep 2026 15:00:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 4/5] x86/sev: Perform RMP optimizations asynchronously
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1788984053.git.ashish.kalra@amd.com>
 <1e3d0edb6b275e33fa6f76b0c31db9e999d9a270.1788984053.git.ashish.kalra@amd.com>
 <20260912015336.GJaqSwoBGnp4Zl-jC4@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260912015336.GJaqSwoBGnp4Zl-jC4@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:610:74::24) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a9f5fd8-60b0-4f2c-4ef0-08df129ac9f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|5023799004|56012099006|11063799006|4143699003|3023799007|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	c8hkajW0WYRfeQtRg1TfHzsIGyWHLMj1gsrGNwgSKCIJdC4TbqM06fhvMWkX4jTGcKkR00R5E0izmAGV/aHIOwgi+UpW9WhLIAx7fGM7hF21pPIFUi+lNyj+HV1E2DRm2jCpHkFTnm2UleIb98psv9GbikkuUFzmhzNbie2gpGyNAdCmbTbZREYaYK6ltrPgBwyAUp305S2TDWVHiTVDXZAmmWARD2sVeVl+hfBZOx2GsF70zHU9thGEI+C90U0e6KoPNU9iO70ILa/0DfpXdf6t2vB3qpSLR1EdEoJMb/rkPIYwuS+MX97bN6J3gjvxysDrWvtRoUKeJ2Yv2WpdX906WtbvS2RBnqdY2nq8wOVcuZYI7H549B7re3exGnC0AxJvOdqOWrZGVGjJEqtJFSfT7yy2XvWJ5tF6psqTWQRLHNw4738RUtyGdQfrObKXPn7NccLrOJukZPxlSSPmeJeWOKuBhC/vjTGZFFWITE2CgcbFWpRvM2G5ousKCjA1aMBiAPpHK5mn9Z+YburALnr2aa/vuG8ux/szc83PSCeVy/ERLJRCO21cA3MX9vToNMoor0gez64KRAkx7IaeknV8Az3wszuj9mQ63uo8b1SBaKRl7GD8EV1EjDb2xiR8hh0zEBvp9Zds56JdHGJDJjeDERhqJ0QGY19N2xMNXJM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(5023799004)(56012099006)(11063799006)(4143699003)(3023799007)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUlRelR2dmJtcFFSQ2Q5OVB2Skk1a2JRYU5Ub24xckhxRXZOczJTSktyWCtT?=
 =?utf-8?B?NzhHV21OQTV1WVlMRFJSWXFPNmcvK29KeFhDbmxneTBpVTMrTnBRWjNiZ3hF?=
 =?utf-8?B?NGVRbG5xUVlmSUIwVVBUWWVsVXlURnl2bkgzeUxxRmRnby9EUUptNDNKSUdi?=
 =?utf-8?B?RGRnUWszb1lPMTAvY2NnQ3YxWEdjSG9QNU1BSUJpTVNXVVFzSG5nWm5CazNu?=
 =?utf-8?B?RDNteWlDNDdmL1RlR3hWMlUrVG5tRWdpd1NGZWllNjlXTmtIZUFua0FFSlV6?=
 =?utf-8?B?NitVZUo1U3RObExIOFJSK3I0UThuaXppOENDa0QzMUZMNStLZnk5SHBKVVN6?=
 =?utf-8?B?YVRya0pWcC9YcXA3bXk1S0thTDRsQzF1SzVucmlCOEVscVdvNHhSZThGMFo5?=
 =?utf-8?B?bzBXNEVqOFFDOHZ1N0FteW8zQUpiQ1BJN09Qd1czbldBZ2JLejQ1M3ErekVK?=
 =?utf-8?B?bWJaWGhINzkrcXdjSGZlVUI5Q3pOMTBsZHlsOXNIRjV0aWFkNUc0RnQ0cGo1?=
 =?utf-8?B?TUNZNCsyUzQxSjJhaVBnREdBdDVZai9YWFl6UUl3bU5oVWozeG1xUVg1M21G?=
 =?utf-8?B?bkQvcGNTWXhYUGlZZi8rRGlENWRaaUZiVzM2OS92RmFxQzlsTXNPUll2Smpp?=
 =?utf-8?B?VFl4RmViUjcrR3AvbER2cmxMbloxWmsvcHhjdlIwUDd0NktWbGd5YkNRcGhy?=
 =?utf-8?B?RUdrUTd1anpTT1NzeVM4YlFvcTN0Z1l1MXgvU2xJbXZLcDVZQjY4WXR6d0R2?=
 =?utf-8?B?UVV1NmQ5R2x5Q1gzanZhWXRjclNqeUl1S0JyN0h1ZEYwZ2Mrd3BOeGFYTFlh?=
 =?utf-8?B?b0VrSUFsNkdtRGR1VVhmSzEwR05jWGtGN2c4d3MzbWs4OG9aUWp4cG1vVmEr?=
 =?utf-8?B?SlNDSmpBbVlTcW1DeXFDRVl3Vk4rMmwyaEQ5NW54emVOOTNSS0hOMVRQd2Zr?=
 =?utf-8?B?OEs1UmdSNzhZbFB4YlNhN0pQa1NTNU9oL2N2UlBhZFQvM3lCa1kzRFh5RkhX?=
 =?utf-8?B?cHpXdlVDeGVMTVpUenNRd0FzWmNpaWhLcFJqekswVEdJVHNKbnVYZ3NXSkdM?=
 =?utf-8?B?SVVNTDhkR1VQWFhQdndQUm5vN1hGdG56eVNZSlp2VWZmdHdYZ25uUDcwK0Fp?=
 =?utf-8?B?MHFTN2paVE1xcGlma3lkRUJVRDNEZjRDWWZpa0p0bURieXlTcnlGeHBLM1pB?=
 =?utf-8?B?WTQ2R2Nodjdlc2NreVBHa2wrZENKZ000SlpJbkVXTGMybjZRdnNnb1dpYUFs?=
 =?utf-8?B?RVBHSFUrbEkwUG8zSElWRktWVUNHbGtYN0ZYUTU0YzUzL21RTjVVdmFxWEZU?=
 =?utf-8?B?WEkrNGpEWlJ3V3poMktMQ3k2dmpuaEtVZG5oZHhEQVBZUkVrWFV2MzRPSXNQ?=
 =?utf-8?B?Y2lBSjY3YjBkNlFzMWNCbmtDdXZmMk9yQk5kdzM1eFpscEVyRDRzUXc3WEw0?=
 =?utf-8?B?eGk0dG1wa3g2WlhHKy9PWjBBRVY4andrdDhrSlBIZXpuelNLWFBEY0F4eWZi?=
 =?utf-8?B?S3hWbU5BaXBpNFJ4SUdTZ0JmU2l0YzlhSHdWQk0rTUxNMEdsLzM2bDNPM1N4?=
 =?utf-8?B?K3BzM1ByNElqQ2FSa3NDa2I3RUdpVVdTUVVWNngvUVFobkxVeExsS1pmUXZB?=
 =?utf-8?B?Mll4Mit6M09Jbld6ZERiUllKM3Jwa2pGUWcxbE5odXVuUjFseXozUGxLWUpw?=
 =?utf-8?B?MW5qOXV4QURGbGg5M1paWWhTT0hsVTEvaXdXZFZWa25SRWFrRWFYRUJLRjZr?=
 =?utf-8?B?VkRYTkl0TjVUeDBJRVd3ZWpCWGRHZmduVDEzdjY5UHdxNi9QSkRYZFQrN2NP?=
 =?utf-8?B?NExrNWIzSTl0RGN4WThmaW1hNTFlejRvZnhiVHV1RWVhOFlteExBSjYybGlP?=
 =?utf-8?B?c1dXVHNUY2VUb3AvWHRLNWVCR2JZaU1CTHFFZXpMRW5kckZ3dzQ2UkhKQlp4?=
 =?utf-8?B?TnBEYVU3OE9wYzdjcWxRQ0U1b05UemxaZEdPZ0xncS8zOHRxWUJ1NTFZWEh0?=
 =?utf-8?B?WURKbFRmN2pDaVdFN0xRRXRMZzRTL1R2cU80akQwRHpmQ3VoTVlUTUVGbzVr?=
 =?utf-8?B?SUo0MFc0ZzZvRG1ENU03cVlQRTR5clBTeWZ5c0VobUd5VW1iR3hpRm03bVIr?=
 =?utf-8?B?RU5aZmhqZHVRMnRiQWYyenBNc21DMDhFZjVMcGZjN3puUFgxSmhFQUg0R2dM?=
 =?utf-8?B?RTkvRzZEVVlnKzZ6U28yeXl4U1FYRFJtWFk4OUJrNkM0d1FYeTMxbGo0UmxO?=
 =?utf-8?B?Y200Mi84UUR2bFNBaVgzOVgzTnRYemhKVHFpa2Q3N25yOGZHeUQrdUxlSjFC?=
 =?utf-8?Q?Yl5Xc/epvJsjmFITYD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9f5fd8-60b0-4f2c-4ef0-08df129ac9f6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 20:00:13.6977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RoqYqfu6TdMin5lyHAPirLzDSFhP5c/U5X1iCCnBeqGOrjXmSl3pd4KWUdaNCTDwAKaiGr/xGTFoRrw5RKGBuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624

Hello Boris,

On 9/11/2026 8:53 PM, Borislav Petkov wrote:
> On Thu, Sep 10, 2026 at 10:00:08PM +0000, Ashish Kalra wrote:
>>  void snp_setup_rmpopt(void)
>>  {
>>  	u64 rmpopt_base;
>> @@ -591,6 +648,30 @@ void snp_setup_rmpopt(void)
>>  	if (!rmpopt_capable())
>>  		return;
>>  
>> +	guard(mutex)(&rmpopt_wq_mutex);
>> +
>> +	/*
>> +	 * Set up once: the workqueue and RMPOPT_BASE MSRs are left in place on
>> +	 * shutdown, so a later re-initialization just re-queues the optimization
>> +	 * pass rather than redoing the setup.
>> +	 */
>> +	if (rmpopt_wq) {
>> +		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
>> +		return;
>> +	}
> 
> No, this is not how this is done. This is a *setup* function but you also use
> it to start the workqueue if it has been allocated already. So it should
> either setup or start but not both.
> 
> So what you do is, you try to allocate the workqueue. If it fails, you clear
> X86_FEATURE_RMPOPT so that rmpopt_capable() is false and that can be your
> start_workqueue function.
> 
> This way you get rid of all that
> 
> 	if (rmpopt_wq) 
> 
> sprinkles everywhere.
> 
>> +
>> +	/*
>> +	 * Use a dedicated per-CPU workqueue so the potentially lengthy warm-up
>> +	 * scan does not tie up a shared workqueue worker.
>> +	 */
>> +	rmpopt_wq = alloc_workqueue("rmpopt_wq", WQ_PERCPU, 1);
>> +	if (!rmpopt_wq) {
>> +		pr_err("Failed to allocate RMPOPT workqueue\n");
>> +		return;
>> +	}
>> +
>> +	INIT_DELAYED_WORK(&rmpopt_delayed_work, do_rmpopt_work);
>> +
>>  	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
>>  	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
>>  
>> @@ -600,6 +681,15 @@ void snp_setup_rmpopt(void)
>>  	 */
>>  	for_each_cpu(cpu, cpu_primary_thread_mask)
>>  		wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base);
>> +
>> +	rmpopt_pa_end = ALIGN(PFN_PHYS(max_pfn), SZ_1G);
>> +
>> +	if ((rmpopt_pa_end - rmpopt_pa_start) > SZ_2T)
>> +		rmpopt_pa_end = rmpopt_pa_start + SZ_2T;
>> +
>> +	queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
>> +
>> +	pr_info("RMPOPT optimizations enabled\n");
>>  }
>>  EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
> 
> There is no ccp driver patch calling this so this export needs to happen when
> you're actually adding the ccp code.
> 
> Same thing for the snp_rmpopt_all_physmem() export to kvm-amd.
> 
> Looking at this more, I would like to get rid of the snp_setup_rmpopt() export
> and have this function do the necessary setup stuff from an initcall in this
> file. This way you set up the stuff at kernel init time and have everything
> ready to go.
> 
> Then the ccp will *only* call a function which is called snp_enable_rmpopt()
> after it has enabled SNP. That function simply enables the workqueue.
> 
> And then kvm-amd can call that function too so we end up with one export.
> 

Thanks, Boris. Splitting setup from start and collapsing to a single export makes sense — a couple of constraints from the RMPOPT
spec shape how it has to be done.

RMPOPT_BASE can only be written (RMPOPT_EN set) when SYSCFG[SnpEn] and RMP_CFG[SegmentedRmpEn] are both 1; otherwise the access
#GP(0)s. So the MSR programming can't run from an init‑time initcall — SnpEn is 0 then and it would #GP. The software setup can,
though, so the split becomes:

  - an initcall in this file does the software setup — allocate the workqueue and INIT_DELAYED_WORK(), no export;
  - snp_enable_rmpopt() (the single export) programs RMPOPT_BASE on the primary threads and queues the pass. ccp calls it after it
  has enabled SNP, and kvm‑amd calls it on teardown.

The same spec text makes that single entry point safe to call repeatedly: RMPOPT_BASE_ADDR is read‑only once RMPOPT_EN is 1 (and
RMPOPT_EN can't be cleared while SnpEn is 1), so a later call's write is a probably a no‑op rather than a reprogram. If we want
to avoid even the redundant IPIs, snp_enable_rmpopt() can read RMPOPT_BASE and skip programming when RMPOPT_EN is already set — a
hardware‑state check instead of an if (rmpopt_wq).

On clearing X86_FEATURE_RMPOPT when the allocation fails: that hits the problem we ran into in earlier revisions — the workqueue
allocation is at initcall time, after alternatives are patched, where setup_clear_cpu_cap() isn't reliable (static_cpu_has() is
already baked in), so clearing the cap won't flip rmpopt_capable(). The setup/enable split removes most of the if (rmpopt_wq)
checks anyway; the only one left is a single guard in snp_enable_rmpopt() for the (rare) allocation‑failure case, which I will
probably like to keep rather than rely on clearing the feature.

I'll respin as v15 with the setup/enable split once we settle the feature‑clear question and the RMPOPT_BASE MSR programming
question (i.e., skipping it if RMPOPT_EN is already set).

> Oh, and you can zap those comments while at it:

Yes, i will fix the comments as below.

Thanks,
Ashish

> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index ca99617142be..c8ba71431a5e 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -619,7 +619,6 @@ static void rmpopt(u64 pa)
>  		     : "memory", "cc");
>  }
>  
> -/* on_each_cpu() callback: optimize the whole RMPOPT range on this CPU. */
>  static void rmpopt_scan_range(void *arg)
>  {
>  	u64 pa;
> @@ -632,7 +631,7 @@ static void do_rmpopt_work(struct work_struct *work)
>  {
>  	/*
>  	 * Warm up the RMPOPT cache on this pinned per-CPU worker with interrupts
> -	 * on, so the IRQ-disabled fan-out below only issues cache-hit RMPOPTs.
> +	 * enabled, so the IRQ-disabled fan-out below only issues cache-hit RMPOPTs.
>  	 */
>  	rmpopt_scan_range(NULL);
>  
> @@ -649,11 +648,6 @@ void snp_setup_rmpopt(void)
>  
>  	guard(mutex)(&rmpopt_wq_mutex);
>  
> -	/*
> -	 * Set up once: the workqueue and RMPOPT_BASE MSRs are left in place on
> -	 * shutdown, so a later re-initialization just re-queues the optimization
> -	 * pass rather than redoing the setup.
> -	 */
>  	if (rmpopt_wq) {
>  		queue_delayed_work(rmpopt_wq, &rmpopt_delayed_work, 0);
>  		return;
> 
