Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012011.outbound.protection.outlook.com [52.101.53.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E08D39E6FC;
	Tue, 21 Jul 2026 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784644020; cv=fail; b=gUmsyP46UB0cf9K2ObdVyjUvMCL5PjRWZM2O9qz9bCsWWxaDbAhcjCGltnw6Mqo4+dkpdLOyb14njF+SQQAToNzZCvtQp99nQSk0uHt06gg2j+MbXXUyCf/ojvI+g6TErqxdHzqW9mUIlvSGOg+JRmdAaBiALJ15bDUljBcWRao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784644020; c=relaxed/simple;
	bh=pX72euoHr0hNN1kFL2ghaY7hixQFQPMLPKcwXf6/FQk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fnu/ote6+mxajgEYnvfiCu+xmPcrvx5NI2OgZzDNrRZpbjzcmKOQXtHg5XcpwPxuHpd5fULgXT0vZx/E9z/fcSZAWM/jvIwxyGHkHJ4SgKTzCE1rKikooYehbEoXE6tO6l32jjUVWy71fPNHeFmGoN+dhWQ6Ka77tWyW8zk1d0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VEvS02VP; arc=fail smtp.client-ip=52.101.53.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VEvS02VP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4Ywej/RSFNG7N8DReN9B5ZtguBem1NoH8ibbaGijQl2tIXlN5e0ITolYYponCckJ7szZyD1Qnqhbvpkw3zqHVEAZ3PPygqzZX/YGzYw5nBh7a2p9N2nkaahYoIyGzhB4Yx0DslOk59yhfVNFOlh8HDKeqI2RPmL1Mc1d1MMcENzU3Qp0qnOdhW1v8GuAWmIEKTxVT4xPRd9RUrWLouptfQ5SYrKl6pTmBCO+kJa64rFvUcNW0VOi5TkIg1E7sgmU4MghgTWfJl9TkAToIkX7NMkpAvWGe6Hf4egxURuEAVrkeGx8ZT/m2VV/HaDf+olMZyYn331C0KYjnIQm/VVCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Saj8l4VQlaG1WE7SroDKQ5UMbTkLet0NrMnSHV3h+rc=;
 b=e8k1rjhP+O/DT61GOcCxbaybXdAOj9oKhn3GbFxTHLo40X1Y/d6sN/7QyJFV1H/VNDfP8Rv+EAAS+bp9BV/iCXS7l86RrLzcoHLOdEm/NBfO9lFf99LpDL5vHj60pDj7/UohuXZQDxQhZyIlolS7gdKzFJuKkODEIMyJRIGQ5qSzrjAi9EHlNU3Vom9wwshxpsRZuy5W0M0VUYvy5pXf467uJSJOqeKnf6oFFVtGznBpp7goRcmIX4K4MabQm/XDZijbL6A7QfTrdf7/GFuF/G2cGczrWNlOwMAdmmri9gBYI39WGSL3sArPbwdsgkSlxqmrZrU5B8TvIic+IV4POA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Saj8l4VQlaG1WE7SroDKQ5UMbTkLet0NrMnSHV3h+rc=;
 b=VEvS02VPeQySt5rcf9ZoGIC0btQdBmdPYqnM8iNcHD4Ubz3BFmEYdEYgnwib+nqwHeTa3PyJQNhY7oatjV6X++5xIVcvx5Kwbl4SbTZn2Q1AvcBSgWlQgWmII10hH54SuvBTUdSCtnuiLaQXMpV+fqtXpPad49iYD0GoDloVq2g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS0PR12MB999081.namprd12.prod.outlook.com (2603:10b6:8:2ff::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 14:26:53 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 14:26:53 +0000
Message-ID: <9a183dfc-91fa-4a08-9168-8ea0e53f708c@amd.com>
Date: Tue, 21 Jul 2026 09:26:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
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
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260720221725.GDal6edYI3uHrDruHj@fat_crate.local>
 <5168d3d3-c31c-4f80-be91-c964a5cee674@amd.com>
 <20260721014841.GCal7P-f3ZBHQzR-0_@fat_crate.local>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260721014841.GCal7P-f3ZBHQzR-0_@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS0PR12MB999081:EE_
X-MS-Office365-Filtering-Correlation-Id: 48a984ec-fb70-4ead-696d-08dee7341bf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|11063799006|5023799004|56012099006|10067099003|4143699003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	YrHFYfPOlNU+Ho66SPGsiOIiH/OzveXXdyQeDjzHPaqt2KE7lMAReYhFrBNjNUqQ8ThfBHA/HBVwAY7b2k1X6yPQN0AX9Ul6NyfzKvqW6hsFK3HYRFpYz94ZWFRn8GTPYhN8u1YMOD9e8fZ2WUqkgx6Nn3O2o2KvDzSTJTfhUNyKUJgmkZzFlUSijyXK8CVcOphUCl2cOO0yU7NYJhb0wh2dKBGWyT1TP75Bh6vcrU7Us6eK5AJD7zNW3x/70DApq13hw3KQiLdmiXO2XOGzWtn1HyJVz7TTpKTWBe5jtzQDUhFns+sbzikZcWRhylU5EkqpkiFkDMW4ep+eu+SPmkYp04CLaLBRRBo+wqD6Cs/kSZvH+hQDAks0/xpDrB/BSYoWJVFdfkM/VhFCy3YBCWWVrrMA4ZeUqFgPhmEeIkfGO+KiEXi5gv0VIXa0OiBViY4I+cGpzYKdp5b0mhZzSzM6x3eQdtbUPd+B0h9FYxAcfErmgLQSft7Bib1qBwM4gbQksL2olTlbxExdSfpi+8UHOPq2im/s87vmBniUWl5HTOzH6jnO5wF/N9AlV6RRiRjMgGPNXTGtBk2qct/8jrKNDxMVu5ooSRLrrOEWPLqfWn1Op0XgkZvAlypYFu4sO/R3NtBfQkXsCSVSAc/c3nvVwykLjxsSWhpvESUkcJw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(11063799006)(5023799004)(56012099006)(10067099003)(4143699003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VUtvbnJpMEh5TkE5TERRc2pnMkpucTI4QTdXem4rUGxCeFFHOWxGZmpYQWMr?=
 =?utf-8?B?WE9nRDI0d0tLMGFBOXBTM2VUVWxPOFFKY3l1NzJ0WWFVY0xsUHp0TXN0RjdO?=
 =?utf-8?B?aDFvbStxdnFjeE5vbUQzMk5YYUtzOTliUVB3MzJZc3hISFFvaU5uZktacjN2?=
 =?utf-8?B?TUxBWEpZeWNXZW0wTGM1OTc2akpYNitBcEJPeDg0MDkzcG5qWDR1Sk5iMEw1?=
 =?utf-8?B?SHcwaG9IQU1BZVpOYjQ2dXFHOHVKb0poMzFEd0t1WHU4WGNtUTBqcnEvM3Nl?=
 =?utf-8?B?UHAzOGZQWU1EdUUzOVczWnFhUUVxTXAvL2w4TDFaVmFpcThOcmVBbTVsRzZu?=
 =?utf-8?B?Vkx5UTZZZ3lmTnptV1NaS1ZhU1I1QVRRekUweUg5VmtuOXQ0TVJqbjRkd2I5?=
 =?utf-8?B?L0xmNGdlVjhMSVMwNGdqenNnNVUwRS83dmVJejQ3VG9uVVZ3NHBUSHdkS0dY?=
 =?utf-8?B?ZGk1WUdTSXZDaVBMUS9XTkEydjUyMGtqRkV0MjQzZXpwandtQkRRSXlOYk1M?=
 =?utf-8?B?ZlRtZ29FY3FPUWFQS0JzNlQzbDVQaStBd05UUStGSU5FNUt5VW5xenlTSW54?=
 =?utf-8?B?WWVrOC9DczUxSWpMZWFqZzQ2MXk3UmhZU2w0TWZvMUgzTXBQa2ZkVmJ2amhP?=
 =?utf-8?B?YlFWcUY5Z00yQ1BKaENkand2SEZnU3VmVWdIQzZnOVhvc3g5ZEs0MjM1czk4?=
 =?utf-8?B?cHBwZHpTcG4wSEI3aDVjOUw4bnZGVm1ML2I0Ym5SanR2SE5PQ3g3ZXBrTE1V?=
 =?utf-8?B?YlM0cWgzOUtHSllPY0IxT294d1FydEpDWm8zSWhIZ0pFcUtadk5WOXV6WHhw?=
 =?utf-8?B?cG9NaHVwTUo0Nm12WWYrYXRKaHVHeFByTGhPb2hFejZSeUpzUVZnWjJ0aUFj?=
 =?utf-8?B?ZWJ2THRvdGJMQU93NmlIY20xWkpaanJ4ZjlCU3M1OXh4VWl6ZTJlUFhCSGk1?=
 =?utf-8?B?TnZBYmh5MEJNQXppQ1VFZWFQNGY2a2dyK05CaWd1SGphUEpHVi85Y29rSng4?=
 =?utf-8?B?QjB3dWFId3VPeUdjOTFxa041cVhRNmJLalJreXRyV2VMbzNFZm1xOEdXUWJH?=
 =?utf-8?B?cGZRTE9MN2FxNy9xcFJEb0Z2d0tpbWZSRGl2VFAyWnlBVUh1ZUpLNHVuTTlR?=
 =?utf-8?B?V3EyYUYyVFpCelNLVXpwZklSb2hScTdrOG8rOW1NNnJjVlhCSlQ4eGFMOENh?=
 =?utf-8?B?L2hKRkUxeEI1V21Zb20zT294TVFtN2xraEtQTUhDNSt0SHNIbTV0MXpNMktr?=
 =?utf-8?B?NlkvVFcrYWZpZlQzaVh1OEQzaDgvcGYrTm5LZEpmMFFsZE1hczVBS1k4ZG52?=
 =?utf-8?B?RVNKZXpxNTQ2dmVINWNUdUZqTHNoVGFhRXp0cGlaTlRacnRRSWVIaHFIZDVw?=
 =?utf-8?B?blZqNFlLYU1weUREUjJpSVRRTFRMWU1Jb0JhTkd4SHR5TE9LYk1yeDNMR1A0?=
 =?utf-8?B?LzdhaExRNXFmSURsUUY3U1d5d3UrdWRTZWRMYTAxVkhUK1B3Y0pSWE5qd2Ru?=
 =?utf-8?B?bUlsVE5MMkNTVlp4SHlrdTZOSnVZOHIxdXBaRHlQNWVqcEpTdTN4eFh3cjlS?=
 =?utf-8?B?NWk4RFVyS1E4dVlyMTJEaGRzN1Y2d1JYUmxTeHNDQlVPeUtrQ05LbmR6K0I2?=
 =?utf-8?B?Y1lmdmxzUEtlbVRVRmxQTnZVT3U3YVh4dVZ2RVlKNFlFdVhyM0FFdXJlaHhF?=
 =?utf-8?B?WWxpa21BS25MbVlPQXNZZGtMUGxuMHQ2TTJZQmlpZHhSOTg5VUZHYmZVa242?=
 =?utf-8?B?cTgvbFpTTzRMVGJOZjJUc1Y3SEZFd2F4bWNwQlVNTXJUSFJ1SS9UQVRlUUVY?=
 =?utf-8?B?a1ZlbTRJRWRXcXlRV0hhckJQWFhCV3hjRXV3UHVIbEFEaVZrbW82L2svV2FO?=
 =?utf-8?B?a2lscmFoaldSbnY3VTZ0S29yVmpoSVRGNm40aFVHVXhwUllTWW5MaUZFOHBq?=
 =?utf-8?B?UGFxdWtzdnpUOVgwUXdaVTdJU3pXaGFwWTdPcFcwRVN4YllxbHJ3dXQvYVZO?=
 =?utf-8?B?SWVoRU5tKzV6Y1kzZG1xUy9aVXgzRUVtbEcwdGFyQkxFYUpxUEFrSlp4dnpz?=
 =?utf-8?B?b1IyRlhTRi9TRzFJSk5CajhwV05Vc0FndVRwdkNKb3Nyb1Bhb0xjZUFaYk1R?=
 =?utf-8?B?TDk0b2ExaHNhNEI3VHpDMWxxVWU5U2htUzNxS3I2N0tRbmUzM1EvY25uSGNG?=
 =?utf-8?B?ZGtTQVNpUS9aNlFBakpuUmljZTRrbTB0b0FLOWF3ZUhZb0ZiQ0RPY1Y0NTRQ?=
 =?utf-8?B?VndiUDV6c2RCUy84VTZWbzJ3d0p2UVVUOEZPd0tnSDRJYkdzT2dzZFpiWEZO?=
 =?utf-8?B?b1NvY1hNemVMUTBpT1J2cTdpSVBYTDNtT214S3B1bEVkTDZtYkJLZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a984ec-fb70-4ead-696d-08dee7341bf8
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 14:26:52.8706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jw3RqejYGvreSAyH26vJ92rMHOVZLHnTx8TReF2TV5PeQEiYPH8t44+bS0cCg1pX3t5XcvKlQwRBN3qHk12kCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999081

Hello Boris,

On 7/20/2026 8:48 PM, Borislav Petkov wrote:
> On Mon, Jul 20, 2026 at 05:38:05PM -0500, Kalra, Ashish wrote:
>> Agreed on dropping the bool — I'll derive it in a local helper.
>>
>> One issue though: rmp_segment_table != NULL isn't segmented-only. setup_contiguous_rmptable() also allocates rmp_segment_table
>> (the contiguous RMP is stored as a single segment in the same table), so it's non-NULL for the contiguous case too.
>>
>> To keep it segmented-only, I'll also need to gate on the segmented-RMP mode, something like: 
>>
>>   static bool rmpopt_capable(void)
>>   {
>>         return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
>>                cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
>>                (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) &&
>>                rmp_segment_table;
>>   }
>>
>> The CC_ATTR_HOST_SEV_SNP check also handles SNP being disabled at runtime, so snp_clear_rmpopt_capable() and its caller go away as well.
> 
 Ok, you can simply do:
> 
> 	setup_clear_cpu_cap(X86_FEATURE_RMPOPT)
> 
> and clear our internal representation of RMPOPT support and make it a lot
> simpler.
> 

We did exactly that in v4, but had to drop it in v7 (flagged during Sashiko review) because it's unreliable here — we only
find out whether RMPOPT is usable after alternatives are patched — too late for setup_clear_cpu_cap() to take effect.

Segmented RMP (which RMPOPT requires) is only determined in setup_rmptable(), reached via:

  rootfs_initcall(pci_iommu_init)
    -> amd_iommu_init() 
	-> state_next() 
		-> iommu_snp_enable()
      			-> snp_rmptable_init() 
				-> setup_rmptable()

That's a rootfs_initcall, which runs after alternative_instructions(). By then static_cpu_has(X86_FEATURE_RMPOPT) is already
patched, so a setup_clear_cpu_cap() at that point doesn't take effect and cpu_feature_enabled(X86_FEATURE_RMPOPT) keeps returning true.

That's why v7 moved to a runtime check. In v11 (as i mentioned) this will be a small local helper,  it will also handles two things
the cap-clear can't:
  - a contiguous (non-segmented) RMP, where RMPOPT isn't usable even with X86_FEATURE_RMPOPT set.
  - SNP being disabled at runtime (CC_ATTR_HOST_SEV_SNP).

  static bool rmpopt_capable(void)
  {
        return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
               cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
               (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) &&
               rmp_segment_table;
  }

Thanks,
Ashish
