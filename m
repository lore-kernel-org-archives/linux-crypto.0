Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012059.outbound.protection.outlook.com [52.101.53.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B783DD50D;
	Tue, 15 Sep 2026 21:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789506283; cv=fail; b=Sz7JHk8qzAzELKQRC31lQ8q34muS5i/rbbqgK9nSFccyauAXqSGsyddDQxAxLvPbPVxwsPCN2HrA2cS6AB7rm6GVkhqoGfM6xNvnXQqCdFbBb9DkzIEG7HVa5OVgLGoeK8gkaZl4s6guPhpoQUDyvJaaq7qV9wTjjMFAJzgDkPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789506283; c=relaxed/simple;
	bh=rgt3gdslVYSys+qBTH5jVmLp5vEgI+pMEnh8xEzJvgk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZwOEHRksFawzhveeyGLrQBLqchRKSKyYOsWPiJ2eZBRkiJpsddlYG+QumI1YkRh6SzFZelsEriikUGd9CQw1q2Cq2NPQjpMbm+ca68dV+7vAdDyXRDvJ7NXrsJ6UtDo0Q+6UVRH4b/HC3hwtcxTJCx6QaBThv9MGSJYlwKNqJeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hHquTlD5; arc=fail smtp.client-ip=52.101.53.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hHquTlD5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TpeRS3MkMC7B9ZGHFoPi8kGnDqgoAIgODIFyDKSvXlOQBpH2wYqghi4MaU3q3MyaPhSChzxO4B3Ozf1r0d6TxQlwflWJUxHyjNI89BnhSyy2BfE78B/u8DYvtY45YYQRsW94S4EHOk6SYLREBd339oA5oz4uZhNzJXNWnIcqPloUMML6Ufw/PROci7+xapdj8svVicfybZurGnlRvTAsYWG4dEm3gLIgbrmX9KTNUtiKV72bIv0Z51jziDOqiUa46iw6SOxOG1QLF2yno/xw3jNAf4RfGLOFeRVK/IQWw1u5hTPMmEGVIBFK+c9gYUdZW23RivI4qyUBsz5hZljjrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TiX36A1XQmyZBdx7b7nyDCaARc2QGUUOCd03V01rdVs=;
 b=fj2h8k+YsBngbKwcDOCyLOJUP/QUJEqWJUZg1r+runasTdXa6WLlptxY30FPIU7WRT+1XTPCp+9PMCaJcmsybFEFsvewdbO2lpGO2zvZ+JvYA/0vXTbYz45EUaRWPBn6rLq5RblL0q9X2VQr7q0YFp6Y/vibct8C9ZM2lBfQiLkr2BAdg7O//90m2+PxgHnCvA0aLRBnqjIBu3db+yCGJ9Aa49Spqu0sDfUEjqrKnt4W4CcMMOsD1IE7dDBjIEgGnwnwFSALqHxssK5QBWomRKCDGH7/RueDMwZUgS7LumQu8LgTsS6FLGiMUSqA3gK/wBKiLgXEd0xA/vkaFYdS5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TiX36A1XQmyZBdx7b7nyDCaARc2QGUUOCd03V01rdVs=;
 b=hHquTlD5kx/MoipfASh+mhh/fkul/bPzyFJ00QYYDezFdFKUWvdGZVbVHqUykDAJ6yFqe69uwfZCXk9UYIooOZiOvTdWM1WksXuu0XUxalOpaowbvyAcbB8+uKW0yEzlmX+NSZcJFxTlhua+W69Lz9QbXKFZpybN4esBKew/6TI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SN7PR12MB8770.namprd12.prod.outlook.com (2603:10b6:806:34b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 21:04:36 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%5]) with mapi id 15.21.0428.008; Tue, 15 Sep 2026
 21:04:36 +0000
Message-ID: <1c3d9841-eef8-4c94-9b2c-a7ed92a68260@amd.com>
Date: Tue, 15 Sep 2026 16:04:31 -0500
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
 <279595c8-30bb-4c01-8203-95619bab3d47@amd.com>
 <20260914231546.GAaqiAIsjGUdsK3MAq@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260914231546.GAaqiAIsjGUdsK3MAq@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH0PR07CA0043.namprd07.prod.outlook.com
 (2603:10b6:510:e::18) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SN7PR12MB8770:EE_
X-MS-Office365-Filtering-Correlation-Id: 411d87ef-9ae1-4821-e7e3-08df136cf2e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|7416014|11063799006|5023799004|56012099006|4143699003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	zIa58k3dsFRCEXAXZcAGLXAZ533+UTLuAwvwKcJ3lxuFsjKEQKU/nwUiKDSgweAuCnuVOc4W6xq8pGV/89yYlNCJ0QuUR0QTZt9/lFcbnVhgrMerQEo6zg+/ZdC88vA2RtWdi+1/DreKN7aQocPN2sEs5Z+cON+P8nLPGxxisXbutQCnuysN4lwcgUbhoDTovdN551ONyzZ+/agSUdeheWZgw37Jh7y39by/XbPi5MqlTI1SxeOn+czPEDxwvR+u1eEKllUxYZ99lb04L/fRq8ePVvnV5Y1+lfXrbzMNWwmY46udBlkX0ulmcJd7uwRCTFyTwtjWTDM+MY+SiBS33ko8PFYQnHc9zFiUUiAMWK6UeKuafWC4DhLkZeDJkxd6QXeJTmPBX0bVBM1X27hSMcYpJ7KIy+bxKB3hoZ2x7YxSBzIfI8dHI1l6/PjnrvWy6HkorIv534uj+IWUUv/NYEsJ2IfpJZ6jx0UVM3aoLb9gNlvm69QLOHuL+fphew/76qLmGz5GkUztLVPG4GsLq1BJUcge/8vubpLtC4ujeH5Sxjy0FC3vFx/eDBIo7XPh288cySAWxrhhtds0hRf6HgxkJUSS0eHiB+3qRWgYYkF9kovGdxW/tBX5nFqOAAeTeTUBlnP/S+X3A+B156t0weBC28VbP7I7ydUKWjuhvhg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(7416014)(11063799006)(5023799004)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qnl3TTRHSVNJY3JEajhRM2FIUjRJbmZsSkgyYzZ6R09PRGpYRU94Y3VjMUx3?=
 =?utf-8?B?YlpFUU5lY2ozaFJDWEpaenRqelRpaW1hdHpVUm94dE5PNnRJT0hjTEQyTUc0?=
 =?utf-8?B?N25QRm1nRTVsOE9BbkhxVGVLUUl2SXdaU2hUaGlMRDJpa2NzOEd6aUkwSm94?=
 =?utf-8?B?eFhJRnphenBhMFBuWTE2a0hQZG11WmVvelJUUmJzSE42UW1qM1g3TzNzRjJI?=
 =?utf-8?B?VHVRRGxmaGlYdHpFT1FsZ1dqbDcyTW5Ca1ZRSEdvaHdXRXVNTFQrM0RYOS9u?=
 =?utf-8?B?b2JNb2xGNE5Tanh2Zm9RZG9VWTBZM0tqNnJLQVhtNkJmb1I2ZW9mVTZBVHJB?=
 =?utf-8?B?Z2MzSW82T0N5K1ZySHhWRUw4WEJNOFdESk1BMEdnM3BaeW9WMHZMVmNENUlh?=
 =?utf-8?B?ckZDeEZLQ3dEK0NBcFhwVlhrUGlNZ0pZTGRsT3hlb1ZzL2x3MldmeFRZYTJY?=
 =?utf-8?B?emFGejY1c0FWTGhKN0hXYW92ZUJnZm05a0kwTUI0RC9ub3AzVzRvb3FoWkF6?=
 =?utf-8?B?WnZtN1pRaW1XV1V3SkVxRU1xRmo4NmFCTzRiUkRtZHBQb1h4L1VmSC8ybUlO?=
 =?utf-8?B?Y2ZFNEdvOVc2Q0tIWGU1cEIrR1hUOGpmTmtzTmFlWXE1VXVWUTF6a1NDV3l6?=
 =?utf-8?B?SVA0Z1VQVXJhaUVtVzNLTVo0UFdmNlJndzZZeXd5OXlMYzNWMlFIWjVDanY3?=
 =?utf-8?B?UEtxeGpKQVpvb1RBQkNKQkZPN0dXczFqSWJyREtDNTV0VmIrY3VuaTB4NVJk?=
 =?utf-8?B?SllEUDUwNHc5QlRVajNlT2czUHdkUjgzZkRWNUJZczlaY1dRTlFHenlmYzdj?=
 =?utf-8?B?WldGL1VVSDNLZllEZTl6NzV0aDFWeHJ5cVVwUDJ3YmZTanlBSTJhb2k0eGY3?=
 =?utf-8?B?V28waWZIMUpZSFhtUUZobWRqR212S0JtOGtxRXdjT29hSUpsb1ZJZkhpblZy?=
 =?utf-8?B?TkN5OWZTUFRxY2RSVHNqWXIyLzBPYTFvK0JUVUpKRll0RWRNQW5FclR4Slgw?=
 =?utf-8?B?eHAxSThUUWxwNUUrMGFuWDBYL2MrMExLd2VTRWlWM0RibW9mcXI2RTJqVlBx?=
 =?utf-8?B?cjI3MlhHcE1xU2FjL3Q3MW9wSzZDc2RiNHBQeDBsbXhxVE1pWXY3cWduMmZE?=
 =?utf-8?B?Si9rbEJDR3p2OUNsakQ4VWlEU1VtbmpTOVVWTGlDRi9Nb0pEYStQbTdrVDFM?=
 =?utf-8?B?YlE1ZVlZWkVWQnV4aHJJZEd4RU1qc2M1a1JXT0dzTG4rcGc3TDRTM3RyTUVy?=
 =?utf-8?B?N0x2ZkxySmkrYXUyT2RJYmxMbHRmZHNnaEplQ0FOT0huT2dZVFkvWllHN2Qz?=
 =?utf-8?B?aFhodFh3bk1sYXR3M08rcURjUW5YdHJVTlRHUkZTeW4wSWFiOUh1OGtlVTFJ?=
 =?utf-8?B?TWlhK1Zqd3VOR3lES1NBT2ZYOVhxUlRNQ2FDT0dCSHU0RTl5Y3J3cEt1TVpQ?=
 =?utf-8?B?QUx0Y05HNDN5TVEwczQzNmlGaHpZZjMyVEp4WVcwV3ZFVkVGZURvOElxem5L?=
 =?utf-8?B?RmdvdStvNUVMd1RSaVdhMG5RV0tEdnlYWitGK3lzMlNmLzJxYndvcmVuRkJH?=
 =?utf-8?B?b3lPTElMeHY0THFVRFEzMGk2aUFIcm1oWFozQnpzYXl1V3Z6bVJOMFV5U21M?=
 =?utf-8?B?Z0ZnOGxpTENnWnI0aDdDOEVhdzZNaDlZOHZVMlhQUFZqZlJsK0Njd2w5R0dE?=
 =?utf-8?B?MGh3NkZ4aWZ5MzROeVpTRzBDZ0wzdkZvVk0rNEdRTGlEN3ZjVFBIQW50cnYy?=
 =?utf-8?B?dStxNUg4bXRRbllPaXFDZHVvVGsxTjI1SS9xUHFtNkFVSktWa2FPMERUQXNk?=
 =?utf-8?B?Z0RSVDI4SzM4M3Nnem8rejVIVEF2RWZQbzlMNk9NVThVTkV0V1dCdXNJOWZJ?=
 =?utf-8?B?NjQyT1Zla3o3UDdvblk1Z1pmN01LMjV1ZGtUNkJSaTM3ZWM3SXpyVW90dENU?=
 =?utf-8?B?V0FqUjJYK1BCeDJnK2p0aTJHeXBGK0N6SVpGb29jUnVyRjlmakIvMXgrZVdI?=
 =?utf-8?B?elIrQWFVQm1mMHZUY1hqcHBwU25WWnluc0FmNktTejdBaWpJQlJLeTI2b2s2?=
 =?utf-8?B?SDYxRTlEa1NpMnNKOTVKaDRhcXd3QW94VkZsZnppbTZOeXVUY3paZkdIRTNX?=
 =?utf-8?B?V2VwbTF4amVTTms4a1BwSkU4UWYrWU1oWU54R2d6S3M3a25ZQlkzTjBkbCto?=
 =?utf-8?B?am9kdzJzRTM4UElLYldocUpPN0E1V0FoQ29YWFg5blNrVGlkblluTHRUYUVu?=
 =?utf-8?B?MWdJR3c4djVCeWUvYlUxcUhwTCtJS0xENEpuWEQ2S2N2N3NMdktianVrYTNO?=
 =?utf-8?B?SkJLOEJ0cDdGcXpwTG0wbVIvNkY3NUE1d20rdkpYeWE4TzVhMjBvUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 411d87ef-9ae1-4821-e7e3-08df136cf2e2
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 21:04:36.4179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7Au+zZhEFMtPFGcEidtrwsAtBCsvg0vLb/5SbuDP9O+5iiHj+KqRZqgk0LuBsVmdxJJLychr5FfxdnIerWgQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8770

Hello Boris,

On 9/14/2026 6:15 PM, Borislav Petkov wrote:
> On Mon, Sep 14, 2026 at 03:00:04PM -0500, Kalra, Ashish wrote:
>> Thanks, Boris. Splitting setup from start and collapsing to a single export makes sense — a couple of constraints from the RMPOPT
>> spec shape how it has to be done.
>>
>> RMPOPT_BASE can only be written (RMPOPT_EN set) when SYSCFG[SnpEn] and RMP_CFG[SegmentedRmpEn] are both 1; otherwise the access
>> #GP(0)s. So the MSR programming can't run from an init‑time initcall — SnpEn is 0 then and it would #GP. The software setup can,
>> though, so the split becomes:
>>
>>   - an initcall in this file does the software setup — allocate the workqueue and INIT_DELAYED_WORK(), no export;
>>   - snp_enable_rmpopt() (the single export) programs RMPOPT_BASE on the primary threads and queues the pass. ccp calls it after it
>>   has enabled SNP, and kvm‑amd calls it on teardown.
> 
> This programming sure sounds like something we don't need to repeat each time
> we enable RMPOPT...
> 
> rmpopt_pa_start is practically static so I'd love it if those MSRs are written
> once and that's it. The question is, do they keep their value when we disable
> SNP?
> 
> And I can basically imagine the answer from hw folks: "yeah, yeah, maybe, but
> to be on the safe side, you should always write them after having enabled
> SNP."
> 
> Because if not, I'd be perfectly fine with us setting them on the *first* SNP
> init and not touching them again.
> 
> IOW, this pseudo:
> 
> 	if (!rdmsr(RMPOPT_BASE))
> 		wrmsr(RMPOPT_BASE, ...):
> 
> This should probably be in the snp_enable_rmpopt() function anyway as it
> should do what we want.
> 
>> The same spec text makes that single entry point safe to call repeatedly: RMPOPT_BASE_ADDR is read‑only once RMPOPT_EN is 1 (and
>> RMPOPT_EN can't be cleared while SnpEn is 1), so a later call's write is a probably a no‑op rather than a reprogram. If we want
>> to avoid even the redundant IPIs, snp_enable_rmpopt() can read RMPOPT_BASE and skip programming when RMPOPT_EN is already set — a
>> hardware‑state check instead of an if (rmpopt_wq).
> 
> Yap, or that. Sounds ok to me if it works.
> 
>> On clearing X86_FEATURE_RMPOPT when the allocation fails: that hits the problem we ran into in earlier revisions — the workqueue
>> allocation is at initcall time, after alternatives are patched, where setup_clear_cpu_cap() isn't reliable (static_cpu_has() is
>> already baked in), so clearing the cap won't flip rmpopt_capable(). The setup/enable split removes most of the if (rmpopt_wq)
>> checks anyway; the only one left is a single guard in snp_enable_rmpopt() for the (rare) allocation‑failure case, which I will
>> probably like to keep rather than rely on clearing the feature.
> 
> Or, you can introduce that bool rmpopt_enabled and clear it and test it in
> rmpopt_capable(). As long as it stays a static var, only visible in this
> compilation unit and not exported, that's good enough.
> 
>> I'll respin as v15 with the setup/enable split once we settle the feature‑clear question and the RMPOPT_BASE MSR programming
>> question (i.e., skipping it if RMPOPT_EN is already set).
> 
> Thx.
> 
> Btw, you can respin the last two patches only and send them as a reply to that
> thread - I have applied the first 3 already so no need to resend them again.
> 

One thing to sort out first, since you've already applied p1‑p3: the setup/enable rework reshapes a few things that landed
in p3 — snp_setup_rmpopt() becomes the single snp_enable_rmpopt() export, rmpopt_capable() now uses the rmpopt_enabled
guard, and the ccp caller in sev-dev.c changes with the rename. I can carry all of that as deltas in the respun p4 (i.e.
p3 adds snp_setup_rmpopt() and p4 renames/reworks it right after), but if you'd rather it land cleanly I can refresh p3
too so it introduces the final shape. Which would you prefer — p4 deltas over what's applied, or a refreshed p3 as well?

Thanks,
Ashish
