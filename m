Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011048.outbound.protection.outlook.com [52.101.62.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7E4376A15;
	Fri, 31 Jul 2026 20:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785529689; cv=fail; b=q0m0yteydGINLi/1MpCvlTlrYnaGNKeEkIio31P0Q5nXmRDK55QAZERJ2+d5wYn5W7n6Jw1WwBpj7qyPZFFvvmTKmYQk9nkHGuXPzbYrn07U6YUtUyIQGubdtPHExvXl+Y8steEeKrnLgAzEZojFOpkMF3cnh4ZP2/2CfmjvG3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785529689; c=relaxed/simple;
	bh=0J/6xYZMQVr1pIMLrgTNcKnJciK90Q8HPmOg54ynQn4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=clS/sZZax9kVr0co/7ieAVv466dHqq8XXJlHBygbmWBiSr3Rj+cvXEEJ08b+KDfVS6HAe6RgXL3h9kiAAVgJc2tFGOGh9ek8W2zm70LpXAeuYxXUq71u96VjEOx1Z1jr5ZKJhn1jNm7c+GLqNvv/uH5ktS9qR/L9sH3G8aiBTwU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vPkgKAI8; arc=fail smtp.client-ip=52.101.62.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vPkgKAI8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ix0o/Tqdea5WmlJlz6YlWrl8PBoKkt3ROBnGJNiunEqi0agckDOgbQvA/WH4zCIX5SfQ46U7IamdOAMgyqGDklr+S4sjjCVr3NQePDqfdRYh50Ejt4kJL7+dpUKAlAd1rXn8rFqyKmaeH2c9/SzjZ2dGT8g0FBeWAZGisHsOmDn5CvExoFOXQF7ncr2p+2HXjnqKjj/lJTbCUtiJD/nErAbK7YprrLA8FzBPvhnc/aw4Y2SvZMq0RQxSzUu3CVc2PbYV0RujMu22SI8C5GRandC/ZR5jbiMa/B0NE/1IJmlqDHOg8qRukFUH2x8zJuS8S92xG2KQgus0ZiIZnSCsiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f94PhOish6AlUTObITOZllnWAt/nCTGqLC1gwLTGSzU=;
 b=vLqmN9J7Kq2vQCIh1ZzAd5a9eULcnvvwOHiPziM0aVpBJj3E/K1k2k7zh+qVLn5NUf/F4Nol+UwQUYJQr5r304GT/TXIOf1edcGp2cFSHIFSYULvvKNwMPJqQtty74wZG5v+dkOJpzdyXgDN6Xcyl+KozmgJCDpVSMDCJuRbEq5RYTT+XfuQD0JEa8HJFN0P9Z4t7DdI5O/r18LOy/TtTstxdoKIIUcHi2SbKEOwDw7SX1jSxi4o+Js0S4sa5pBeStH5eXrl+cwQIs2ZoitK493aFvxr6Q1qyM5GVJ2Y4LKSgxBF49LeGpiCoe6BPrgqlnqRXQGu/zx9uWoLqMH+UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f94PhOish6AlUTObITOZllnWAt/nCTGqLC1gwLTGSzU=;
 b=vPkgKAI87GqFiX6P8LyNOwEEKhHGY+MT9v7rzHwuGrT0BJZVkvF/LduO02lT06gYV8IdFOvVYzwDwOvPLkHqJ6tBtHYpm77YYpJgRQmjzxELCcC5ghTP0j6vwxtPhmh7D5KJkZXQ6O2J7pHzTEeN5boKoiXBWY5L5D3snlHB064=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by DS7PR12MB6311.namprd12.prod.outlook.com (2603:10b6:8:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Fri, 31 Jul
 2026 20:28:04 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0270.015; Fri, 31 Jul 2026
 20:28:04 +0000
Message-ID: <a108bf08-bbf2-4c1d-b74b-c7446587aaea@amd.com>
Date: Fri, 31 Jul 2026 15:27:58 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/6] x86/sev: Disable CPU hotplug while SNP is active
To: Tom Lendacky <thomas.lendacky@amd.com>, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, peterz@infradead.org,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1784844080.git.ashish.kalra@amd.com>
 <e1631971b3862bcd6043199feba3df51f3ba336c.1784844080.git.ashish.kalra@amd.com>
 <bd67f2e0-312d-4eea-a5ad-009554e3ea93@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <bd67f2e0-312d-4eea-a5ad-009554e3ea93@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0030.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::6) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|DS7PR12MB6311:EE_
X-MS-Office365-Filtering-Correlation-Id: 849350d9-515f-4553-3f23-08deef42390f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|921020|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	D/FwQdPqXNEq5AyCDbulzw3Q7Pzm0atcP4yt/1z15ejVWw3gdEuVQavkHyuOk9K2vBRpQZJX9sXCnQwoIpihk5kwsyice4E/+lwTASa0UabG5zK7kpoXcH+UoTWJ/gezY9neNBjZZVoxyMYYQKi5ICHJxqXl/xVHNxg59MMHdhf4jIjWE+sIPjJy9LjiekwunMfTsi1TQujG8P8ysX0D3DQ4/Hgdz9DebgFgqPCNUY6K0pNSWJiAsxJgAEQm0YIyGbhbxJ2eZDDUH81nvP+uj2GvK1rMu0c79WQzTolSoL+xEogJ7DsU+uG8KDcAbe1sEEo0lqAKysH4VtdZ9tr8eADB/iID/6LMvixtLfKdXKQs6OyQNZgeI1UVyCiurtS4et2TPDJAr5cKSqhu0s4+uD5lTEHiQ5XPmmZV2z38f5puMeJnrzR9qq0+vXdKLWuF0BQkPw0g/p/5ZEcX8Y9AbbvLaaM20axPPZm5yq8c6SQuRfadUnYvWWfTWbF1MlnXpH3vmf8ed3Lw8KCrrp+18NXFmaTb1aGoxXopFRbNw5WM8XuyXk7DpqTm06VcFBmY2dS6t/M9bVK21FDfnd69k2vjD9XzZGDSZVL9ZqmHXs9WNd5OpNRQUtXtcfr9VrAePD+SxzYz+P1WtsOGaywE/z3RLyYrchJ8baLSFseElOQgedEMpmhL6yFt9FpCj/nDy1GA18DPdRl1D9lBcZd1Hg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(921020)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0l0Mm9Lcy9sK1FnekVEZlZoQ05DcHJ3M242dVBRcmJIS09GVVpwRW9jK2pn?=
 =?utf-8?B?RFBvK25jTHBCMmk0YVg4WHNldzRQTXN2L2dTYm95UFFBM0lHTTRyTC85YUxK?=
 =?utf-8?B?RVRVY2x3Nm1BMWxCM3JPYU1Jb3A0NVpkMGhJejFHSlJQQ0Y5L1Vjb3E5MWZO?=
 =?utf-8?B?enQ5QWl2S3N1N2VUclkvck83ZHAxVnR4SjVvZ1NaeGxhOXVCUTVocWN0RkdR?=
 =?utf-8?B?UUhPZFlRbmhpd2Vjd3Y4MW4xL1gyd2lyWms3NkpjQWhrak92a2dlUXAwRm5W?=
 =?utf-8?B?akJ4TGRiRDVlU0htcUhIYUUrczJsbFlPdlNmMXNpNUk1RGlpekhQYTc0T3E3?=
 =?utf-8?B?NlNXTm9paTFwcktCQVpCY3ZiVm42NWpGMmRUUTFTYWUyR21XWnZmK3F5VjN3?=
 =?utf-8?B?SGhTdjZPdW5lWU1tZGxKcnd0ZGFwRWdvVzBHYTNGcjIxU0tzeWY4SUFuaVJu?=
 =?utf-8?B?M0ZRMmxiY1FmdGtIOFBsWGNPTFFDc1lOM0twUkZZQ0h3VU4wWlZXWGNBczRW?=
 =?utf-8?B?anJuQ29DQTQ0ZHVWcEcrVWtXZTc2MUxJMy9SOUY4cTcvTXFjUDFiQ3hYWE5h?=
 =?utf-8?B?cTNXUXlBb3JsY3RybFN5djVDWXA3dGNOemJDUmNBdFh0VlVkeTVkS0gyeEZn?=
 =?utf-8?B?cGJBdFRkTFFjcGllNFpJUDZITjdoZExLL2p1YktycW1DU081UTFiV2hEQzYx?=
 =?utf-8?B?Y09DSzV3Qng0SmZEYll6NUQyaDFpc0JBUXJLUDdDOGI2a2pIQi9UVWhPU1k3?=
 =?utf-8?B?bnRvNnN5TFk2U1lxZWdhRTlTUytpbVF6UWFzcmNRMlIxRVkyVkZJY0pIM28v?=
 =?utf-8?B?YVdlR1RyQkdDSXQ1Qkk0aG5VOWdtMW1NV0VPTEp3cGF5OVQ1WE5wa21ERDFQ?=
 =?utf-8?B?V2k1WWpCS0UzM3B0RTNZZmtadXVSa3AzV2hSbFc4RFYzNlZaZVBuelNmd2Ft?=
 =?utf-8?B?TTBJeFVpdDM3R24xcUdiblhiQ0EyeEZSL1k5YkJBb3kvd1JrV3BJdThXNldE?=
 =?utf-8?B?Q0V6OFRSTFdVNzdIYlR1b1BzaE5uMERRYUhIenZMbjByWVVheFg1Sy91Ujlo?=
 =?utf-8?B?L3ZKb0JQS3ZQRnFFRGh0NzJlZU5ITklWZ3JQMmE0YmZna0Z2T2ZhRnVLYXZH?=
 =?utf-8?B?bkQwR2xqTENNR3JUU2JzMERVNU9rdlZrSFlTaFBzemNYQmVhQTVlYkZrQ1N4?=
 =?utf-8?B?Z3hacVBVRWlsa0JBb1NkaCs0cTV3Q09LMTFmNWV4bm5GY0ZZL3V6MTJPdzVn?=
 =?utf-8?B?RXVvdFdxMys3VlU2ZGdTNjI2R0RmU0xNYTJNalRRcDZGYmxkM1MvNEJPTml0?=
 =?utf-8?B?Rm9XTGVvZnZoQ0lBaWRpRnNadXhsam5QZmpra1RpenJQMHJsbmJxWkhxcjRQ?=
 =?utf-8?B?YlNGV0F3YnFnb0NKTVRyQ1YrSWIrWXBHenQ0dkhJcCtrUWZYYWpRZm93enVh?=
 =?utf-8?B?azBTUi91MlM3NTg5YndMWmhYL2t5M2ttb0lYZzR0VTljMHRGbnZwVmcwbVZy?=
 =?utf-8?B?N2dXSzdaKzB1a29QNldPYnIyczFjaldjR1lwdm9rMkhHWElBdTNYWlJrbDN2?=
 =?utf-8?B?MVhidnRGalQwYzllRlkwYUhGSktoOVhuSzBldmd3N1ZHUVpCR1ZIdDFYdFFz?=
 =?utf-8?B?RW1mSHJyWWRiZ1MzT2VncFJHcGh2Qk1KOGVSVFFxQ0xYSDJzYVdlc1I1bnRw?=
 =?utf-8?B?N25IK0tPdWU3c1BnaWFnMzRjcGVaVkthS3liVGxJbk9mSUZuaUF5TDhKWEsw?=
 =?utf-8?B?N3Rkb2IxOCtjZHAvejdjR1lrNUJVbWtLOXZFRUc5Tk9aVUdTRGdUaWQ0TjZR?=
 =?utf-8?B?OUVEdEFKend4cVZIRGt6Z0JQSDZEcjA3VDcrS2RjYWFhRUR4SGR6RnBUREFu?=
 =?utf-8?B?ZHZ4L0o3dmtCSUFlaGpBSGJXMFM4OUVidXAyTHZjODJZMWRBZ3l2MmhRQmJT?=
 =?utf-8?B?VG5wdjRqcGJiMjRLTU9lRW01R0FnTXdyQStzSmdKSEppMnJQeUJXWU9ZcGVG?=
 =?utf-8?B?YnRicGllYzUzMGcrVjF0Z2FodGJiTndxWitja3FRTkRJLzRCT0VqNWQ4V3hl?=
 =?utf-8?B?UXZPbm5VYU85ZVR0Y3NTVTI2Wkt1VjBaRzJhbU9lODB6c3F3dXhJWFRGeGRB?=
 =?utf-8?B?UGdWSEFUQkwzaHd2dlFmRlpWOUF3eWtpdWlKdlhlZFNEWDY2VFN0NjJqbVRa?=
 =?utf-8?B?dWE5em9EUGJ6UlJnY1h4N0owTktzMVlMTVRzdHFwN1JncStDeDZaMzVORkIv?=
 =?utf-8?B?RkNuMWFodnhFWmk3ZXo4RnVBcEUyOVF0TUZscDZqKzNsRkM5TkxyWXg2S0Rt?=
 =?utf-8?Q?xHyypDzsQhxX7R7N3w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 849350d9-515f-4553-3f23-08deef42390f
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 20:28:03.8864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZA8OQB43yBXMoS4dU4Zr9gWSWZHr6BcJP6UGmzPfkz/GKN+WN0HCqSPeaSoBCFp1OAT/v9ShOvOJ5ezNJN4lSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6311

Hello Tom,

On 7/31/2026 2:35 PM, Tom Lendacky wrote:
>>  int __init snp_rmptable_init(void)
>>  {
>> +	u64 val;
>> +
>>  	if (WARN_ON_ONCE(!cc_platform_has(CC_ATTR_HOST_SEV_SNP)))
>>  		return -ENOSYS;
>>  
>> @@ -586,6 +596,15 @@ int __init snp_rmptable_init(void)
>>  	if (!setup_rmptable())
>>  		return -ENOSYS;
>>  
>> +	/*
>> +	 * On a kexec boot SNP may already be enabled (legacy firmware leaves
>> +	 * SnpEn set across shutdown), in which case snp_prepare() bails without
>> +	 * disabling CPU hotplug, so disable it here.
>> +	 */
>> +	rdmsrq(MSR_AMD64_SYSCFG, val);
>> +	if (val & MSR_AMD64_SYSCFG_SNP_EN)
>> +		cpu_hotplug_disable();
>> +
> Why not just put the cpu_hotplug_disable() at the start of snp_prepare()
> then? Wouldn't that take care of both situations and only end up with a
> single disable point?

The difference is SnpEn: on normal boot it isn't set until snp_prepare(), so hotplug during that IOMMU init -> ccp load window 
is harmless and the online == present check refuses to enable SNP if the CPU set is incomplete — detect-and-refuse at the enable moment.

On kexec SnpEn could already be set from the previous kernel, so that same window is now dangerous (there'd be a window from 
IOMMU-init -> ccp-load where CPU could be offlined/onlined while SnpEn is set) and additionally there's no enable moment to gate — 
snp_prepare() bails before the check because SNP is already on. So we can't detect-and-refuse and so we have to prevent the window
by disabling hotplug early, at the IOMMU-init point (snp_rmptable_init()).

Thanks,
Ashish
