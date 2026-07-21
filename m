Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010066.outbound.protection.outlook.com [52.101.46.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACB23B0AC6;
	Tue, 21 Jul 2026 20:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666792; cv=fail; b=K3Q3eAKnPwPCeCjliFng085ZSXfVjTUlxxQ6lkmmvtgeYzQrnbJU4b71HlaHgEfnNoyILApHBqAoG5Niru5z51TTWX6iUYc8ttDCywUUQJlodPrWpN5Q6cTIXgz6BZJcT/GRRmMJexbrBwqbTNT99YRo68wgiOWeFcK5VmKf84k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666792; c=relaxed/simple;
	bh=yn7m2qleQGzcO1PRfv3ozuwdqw4HOgaDP6rrV4J6M2M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pi4ooNUXi05M8l8yYQIzNLAXa1VlRmOExs0Ce8ZueR7es6oXrT2g8CDe8rfkIDMgjj4VjMsG6DMuw2FMNv3epklj2FHqAjQzwSHoquUamMaZs+66RKTN/A6fAvhWD+mWnvV9ISYmqL4uRDIv+qEBuGRPrEbLcsiJb1GgEragZRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tti5xY7M; arc=fail smtp.client-ip=52.101.46.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tti5xY7M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qp2fRz3U/CNohBNVg9DYI7zjSZIywYSf9KRabnxgNsNNVZSj0i+LU7HU9uL4IOwLkFAdu5L41i/HpPdxwvWHJVBdoo/dYl2iYwROJczGFUxFI1YHjI4EXJ/YwVQ+FIbRe5svO+vQtLBWsSIsR28NNN2BT+e1gIvhs1XXTgBSAEUP9KusACVOu3GPhPjeOqanoZp/Gr3RaThdBbPZoE6vIcBwhAng9xxzJ+g1R60KBNEjYtD0lQtGmd1L34fpVQHTCt3WD1KuceckboIxrIP//SRpenSk49FBsvFGU/qnNSfNiwsCb8pU3TaO9I3Il/9EN7hdzeSfa0HHr/YIpOjAKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6swPhjVzi0Ve8Dx8THbrg5VfVwCaZYxC6nsDDe/SyoM=;
 b=CfjvqP1Qvizwcmojw3d5HMRkJ7gMOEKDZWUh6iyeE2E+1uqsaPuNmsUuQuxXftb200u3UDv8Pt4t9m5jVTCNpZJ4AKhpaE0Wi0xlLARgfNZYJ74uMKAGkGXHSpjg47bh/NSCoaK0NmFYFOqDDI8YiKyRD9zg2c0HLMOf4SWFZgxuBZz68+jQ7UCPKZjnQOiXQWm4jMFB8p9KYod10Eyi4WgDV08iJAfktHL8mGwCUPM4n4Lu0DVZImm6dZoH+/Ms+Twb38eMS7th4I5Ik9hVQuDIqLmJik02gVRJ6qG4gADGBu59BZWNWP87I3rnFNvIpXQqiCOJYHrRgRaxnB0qTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6swPhjVzi0Ve8Dx8THbrg5VfVwCaZYxC6nsDDe/SyoM=;
 b=tti5xY7MjKsQygqAu6Il8Xsy41A/DHM8GsjPRqZgVZupbhUwkkCVDrn00GMYW+zglEUADD6NB4fsMMvAtxADr2uR1ZZEWO4HZVpNvGCqwg6ADNEEPZ945JQYVGKnd36DqsAWhG1DcF/wRLlOn00psK+3JuO8l1dwXmTu+VD21mY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BL1PR12MB5996.namprd12.prod.outlook.com (2603:10b6:208:39c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 20:46:26 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 20:46:26 +0000
Message-ID: <509ac5f1-d05d-4c95-8e61-f0d4b04bbb92@amd.com>
Date: Tue, 21 Jul 2026 15:46:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/6] x86/sev: Initialize RMPOPT configuration MSRs
To: K Prateek Nayak <kprateek.nayak@amd.com>, Borislav Petkov <bp@alien8.de>
Cc: tglx@kernel.org, mingo@redhat.com, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 thomas.lendacky@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 ardb@kernel.org, pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com, ackerleytng@google.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1782841284.git.ashish.kalra@amd.com>
 <8518e02c46d6edf1f37a180569c708a3cfa7c413.1782841284.git.ashish.kalra@amd.com>
 <20260720221725.GDal6edYI3uHrDruHj@fat_crate.local>
 <5168d3d3-c31c-4f80-be91-c964a5cee674@amd.com>
 <20260721014841.GCal7P-f3ZBHQzR-0_@fat_crate.local>
 <9a183dfc-91fa-4a08-9168-8ea0e53f708c@amd.com>
 <2696f0a9-d2a3-41e8-91be-6f00a20d5f27@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <2696f0a9-d2a3-41e8-91be-6f00a20d5f27@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:610:59::26) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BL1PR12MB5996:EE_
X-MS-Office365-Filtering-Correlation-Id: 35d1b47f-ed34-4078-27a1-08dee76921ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|56012099006|11063799006|5023799004|10067099003|22082099003|18002099003|6133799003|4143699003|3023799007;
X-Microsoft-Antispam-Message-Info:
	RQTyOlboieJ8/6fitO8Odqwdov1lJVGbplY3bzk5H+z/bnEoMPR71813/9gV8iyuvQm4GJZKF+53P7/7Cr5hWBfoOzLMheerQm45a87iOg7RPtvYVu7nGGdfgnLctXFmoG/yv29AaNI8TVpD5QkX2ruNcKy0utBfffIFKBUXsvRDLYGs+h+KVYN45HVDC21FgA0vtazqg0S7JM9j6NVQ+H9J4n85cIR6ohResRnZGL/yKbZSXFYfiTyd73yFmUO48LY+y7mpk/rFX/+VFOFligQZ0Hu4xKeJVdc9ukI/deRBS4GLSv7goGSoclLaooB6Umuy9IWmOQ1CfKuQ9/40y89S6nkc0k79v2EM+PqpbnrKqWYanOXFBrC+efZlHsmdWtD9ECVLz/U8Gij9zz2uR7u+9JUZjFN9j5oTzJdpRXucW1tMErfr9JZfTlw7RvVF9WvfM0wRofVAU9ZMz32rQQdeuyALilBPlGv/qAGs8fo60LYk/+PN0AwiPquqhGbv31ASpUVrOddPzuGo19yUoCnClS9SSDhn7dZnZJy6v0xlWGbg867m9IGJetPbNwO44HAAMi2focYWHPumugNF2N2em5ALY8DobXPv6smQwsxXi7Iq/SNQNGoBQKakWHwfNq2Emt9QyKc9n5Nmn0mURnIgU+498IR8oNW3KbIyUdM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(56012099006)(11063799006)(5023799004)(10067099003)(22082099003)(18002099003)(6133799003)(4143699003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MWw2K1VKbC9mdEEwaUY3dDF6cGlIOHJXMVJnQ0toeDNxa1czWEhQVHNtWXRR?=
 =?utf-8?B?NmlLRzhpS0NUZWt6TDN6M1I5N0RzZC81TExqa0NQSko2R1doSitYYUlEWE9k?=
 =?utf-8?B?QTdjem1FTW1UUmxFYjZ6ZlFwalNibGwrc0g2alhCVkhsSUJVS2lWYzgwaWh2?=
 =?utf-8?B?ME5aRnpIWmpxc005Rit1d1FJZ2JSbkNZSTBYOXVPN2UvbXJXSjh4dFF0QXdU?=
 =?utf-8?B?MThFT1RkZGl2Z2FjYmV3dmVXaXlJaDhzVHJCQU5jQVdQVTR5NTlvR3JHN0xa?=
 =?utf-8?B?cDQ0dXJFWE56ei9sMkFiZGtWenoyd1U1aGNyNzRuNVZGV0RwVnk1SjVwd2kv?=
 =?utf-8?B?T1lUZGd1RmsxRmdMOEZraHQvZDJWM3RkNDBZM2tNNjRqQS9Pb0hwbjVlRXA0?=
 =?utf-8?B?eTdybXZ4bEZTNWdyWGUrcDRmVDU1R2FycGNwR3JlTjBYcW4xWEV3bFlwbXRv?=
 =?utf-8?B?Nkh6TVIvb1JUVnQ3UWJpeHdVTHZjbkx1N2dMd2hXWnd6L0FiS1hHNTJTSlVl?=
 =?utf-8?B?ZzZRMStqZ1QyKy8xZUtLcnJPbG40TjBydzBGNDdyaU5tclJZYjljL0hvc0Vu?=
 =?utf-8?B?N1hHYSs3ckR1SWJLZjk0ckFldVpZTUlZZHpiNHFLbFFESzZzUnVIOTVFdjRj?=
 =?utf-8?B?ZXdlc0xudVk5SXJYS01WMGJmSzJ3d0JKemFsSzNuOVVTcGpiQzZpMTRYQWky?=
 =?utf-8?B?OXZzWUtTNnhnQTl6UVBxTmp5eHRLTzhkb3hQUE1PaUxqY1ZScnlDdHJOdmNm?=
 =?utf-8?B?ZGtrOVVIRGJKYkgwUE9hTTlpWUkvNDN3T1R2RFZzT0dmRXRzU1dveW10aGFi?=
 =?utf-8?B?RGRtTlljNzR2bHA0N1NJeUxtWVhFOG9TZjFiSVVabkRFdGh0T2dXLy9MbkZx?=
 =?utf-8?B?QkE2L2Q4bklnNUNyOWRuc2FlYmYzNVlOQ0JhU0M1Q01BTEp4T2tWY2lHZFIr?=
 =?utf-8?B?WEdtZzJTLy90MjhUUFZWbkllSW5UQXRqdjQ3RXR1RnFRWExxRU1kZWN6RHB3?=
 =?utf-8?B?K3ZyR1EwTnJFRDdDdXhiUU5Qdi80aU5aRmpyRHFKZlN1NktWYWhkRUk3ZGR2?=
 =?utf-8?B?eEo5QjdZdDhiU1hrWkc0d2tvbmIzR1oxVk9vL01JQzg0MU1jdGNXQm1wdUR4?=
 =?utf-8?B?amtrMFBUanlsV2psM2QvdEE3V25Ob2JqbE5rc2JtdVZ6a1pJY2pXQ3FwWFZj?=
 =?utf-8?B?OEZCRkIrbE8zTlpzZVVDUkdaZFE3aHFpQkV6ZEh4Z2VUelA1WkViQUljUEMx?=
 =?utf-8?B?aEZtekJ4cjllZ211RkhaRWNRMmdzS1BpOS9DWlRWY3ErajB1ZDFPdVc1Mjky?=
 =?utf-8?B?MzdRdEF3TWtneWVCVlk5bGp4RURySGJTTkpDK1Njc1pZc2g1bkNVTmplS0po?=
 =?utf-8?B?cEh6Wk52Kzg5RnFpSFBSYkhIOVBiU2FFZzJiL0g3U2RhZ0h0eS9xVmx3b1dl?=
 =?utf-8?B?Y3V1cStIdDNQT0RVNUxscUtHbEgyN1MxTHB4cVQrR2srRmZXMHBZRFR3dVJI?=
 =?utf-8?B?TjNzdFVaMXlTSldtQ2xsb3NVRXhoSllBUWhCeDBtVGtwRERxYUgyT1Y4YlBm?=
 =?utf-8?B?RWVMdXFUYzdYK21KMW1uUVkxQmZROWFkazlXSDVZanh3czV3Q0FLVTJQRG5H?=
 =?utf-8?B?M3FwZ2wvVE9LQ2ZSek5OaUhnNElZLzU3S3RuS0hObEpVR2NWdkhBSVhNb1ps?=
 =?utf-8?B?NTJsM0YyT044dmpTZ1hpYmZCZHgvM1RwWHNPU0Vzd3BFUk8yRmFYMmpjVXFx?=
 =?utf-8?B?SVpaL2cwMFhaamw1NHRQM2JYbUFzdG5FUm94eFhIbnlydkM5TmpHb0dwZGdi?=
 =?utf-8?B?bVhTcGdOODhudzNjVGJ3cGJFdDQ4WU5NbU5SczdJeGF4d1R2bXR2SVMzb09j?=
 =?utf-8?B?NWU4SmhDdUoyQk5yQmttN29PYjhrMzNZL2dVSFVCOHlMTGJYRHdVVENkOHdk?=
 =?utf-8?B?TVpvWFdGRCt1bHUrRDlhazM3c0tBMFRKQThVZU83SmN5OVR0RkQ4WVlGTlNG?=
 =?utf-8?B?c0NjcGJ1VU5YSzhNQ1Fha0FTNVVjWmtDTHlvaldRbEIzaVVobUlmb3RYd29w?=
 =?utf-8?B?TTNjUlIzckVvV0s0dlNqbkt0QmtQUG1KWGI4MWtha3ZUdEVOeHNZQWtxSjVD?=
 =?utf-8?B?bS90U0g1SHg5S0JJbkY3YWN0SW1lUmhaUHNKM0taYkV1V1RQcU1IOERLYmxz?=
 =?utf-8?B?OHRuYmFZRnF1ejZCTFZ6c0lxNzByUHVPRi9uMU8xV1BLa0htaWxHcDkySmQ3?=
 =?utf-8?B?dWlWQWFoTDdYYStpNWllOVl4QTkwYmV1NTdNcldaZkRzM2M2ZjNjbDQ0U2U1?=
 =?utf-8?Q?6NEVKyIAK7dToSOpcx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35d1b47f-ed34-4078-27a1-08dee76921ea
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 20:46:26.2117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hvqCET8mxb6D6+HAJH5NAZ6OqS1bNn2COD3TAVwLAV+BGp9zTZRz5cyllHVQ9ttoAoiec3tUNNbuO/eHX+6zXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5996

Hello Prateek,

On 7/21/2026 9:57 AM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 7/21/2026 7:56 PM, Kalra, Ashish wrote:
>> That's why v7 moved to a runtime check. In v11 (as i mentioned) this will be a small local helper,  it will also handles two things
>> the cap-clear can't:
>>   - a contiguous (non-segmented) RMP, where RMPOPT isn't usable even with X86_FEATURE_RMPOPT set.
>>   - SNP being disabled at runtime (CC_ATTR_HOST_SEV_SNP).
>>
>>   static bool rmpopt_capable(void)
>>   {
>>         return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
>>                cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
> 
> CC_ATTR_HOST_SEV_SNP is set from bsp_determine_snp() ...
> 
>>                (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) &&
> 
> ... and that already checks snp_probe_rmptable_info() ...
> 
>>                rmp_segment_table;
> 
> .. and if iommu_snp_enable() fails snp_rmptable_init(), we clear
> CC_ATTR_HOST_SEV_SNP.
> 
> So, the way I see it, CC_ATTR_HOST_SEV_SNP being set means we have
> already tried provisioning RMP table.

Agreed, and that makes rmp_segment_table redundant — iommu_snp_enable() clears CC_ATTR_HOST_SEV_SNP when
snp_rmptable_init() fails, so the attr being set already implies rmp_segment_table != NULL. I'll drop it.

The one I'd keep is (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED). It's a runtime config bit, not the CPUID feature:
setup_rmptable() allocates rmp_segment_table and keeps CC_ATTR_HOST_SEV_SNP set for both segmented and contiguous RMP, so
the MSR bit is the only thing that distinguishes them — and RMPOPT needs a segmented RMP.

Clearing X86_FEATURE_RMPOPT in snp_rmptable_init() won't work on its own as i mentioned in this reply earlier: it runs at
rootfs_initcall, after alternative_instructions(), so cpu_feature_enabled() keeps returning true off the already-patched
static_cpu_has().

So the helper becomes:

  static bool rmpopt_capable(void)
  {
        return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
               cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
               (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED);
  }

Thanks,
Ashish

> 
> I'm assuming all platforms that have  X86_FEATURE_RMPOPT will all have
> segmented RMP. If not, you can just clear X86_FEATURE_RMPOPT in
> snp_rmptable_init() no?
> 
> We can never reach functions that need rmpopt_capable() without
> first checking CC_ATTR_HOST_SEV_SNP.
> 
