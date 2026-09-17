Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011010.outbound.protection.outlook.com [40.107.208.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB484CDDE8;
	Thu, 17 Sep 2026 19:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789674456; cv=fail; b=sQZO/GmnuZjjHD3JU4iO6s6yVDwyk7aUMpvzssRuT1XY9pcnpD3w7Y4sulXE9mI0buiX0mmxR/LKspRc5mEMyBsmhP6P4EioTjPaGEIyJuChl5upBsfy6A2MsdEHZuakJ8t0UoEZ/asTk9OhYXxs7Y+j/5UfwGv18toxFB7FrqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789674456; c=relaxed/simple;
	bh=qMstdUr52sqUym51HsVODPOX4I0xToZhdPgWb8AA6AU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=memMKe1OIzSe4ps+Usud/ZYWG4skQRVMu6C+AqTioyQuIRcFj3A4Bmd1YgxwINrSwAgKxXYvPGCTQFgMrpUdT3vsoFkUtLcGaUMOq+Q/u+Ix12HcojYbZh/Aj6IFBBGa4FZRDeBPht9OVkzd7HDdK74lkD4TplN2/EFxSe36IUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=T4aklV1p; arc=fail smtp.client-ip=40.107.208.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="T4aklV1p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rS4JmrNBWa4Ruz9BtaGLzvQ3BSDr2O3ea6fMhmZ94+7CnSViobrN20ZLQgCvh0V8IjOp5T5vhvE7KckAdi8bjlzhmA1lWLAg+Nrh4k2F6pQOSbfs/8dY2ndntvqnUU62JS60g8fTtLlcbd1VP+UckcAaGYZbG/wdqkYn7QozPHEgW6QsgoptTptWrA/s3EWek1Wd/17zMWYUaCpghxXlnESlaMeTtlvOaDdcwc+ggYXqUI1pxd1fci4kOGx2pFcjWcJGgZqM+7P3FKz32BnTAN4VZfpHyZE1Lrp37CggH0ENxsEiwxC6vOdi2YHo6i2LYp33tGN8YOsAMQW4gqsNRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AyA9SiJ/AigbaP5XHE3VTCpFrVePh+7qFNOufKvzjTE=;
 b=XlVZPexi2QZj9blC3ny04CEyz65EveRXtA/SB7ZPgVQ72w9w9nVB/KKLXYlpUOXEsoQ3SNqRpCJy0JQthxIC5sMQLWO1HItzCVMF5+Pdb+JHMGTUdhG3x4oMQZK36sHUr3xaQ8QBS8S+yGGmzmn30iv58coOjWQtaJOsoJoQzRhBP9OgVD+BWHpIuupytXyE3URCx7wl+/KH1ny715BYBg5y5gKm9B+nWooeuWuBZcE5hjiIcE/St0K5GT8St/7OCxSw7JrK6pj5I+C15q26D0sWTrf9G3rAIaYUOJVm8tW1UGJ7v4FdgKsEdN2BM/k5VPUrJvuqtNnx04CCUJX71g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AyA9SiJ/AigbaP5XHE3VTCpFrVePh+7qFNOufKvzjTE=;
 b=T4aklV1pfFjWtF7BzveEmn7UUSJCuxAQRaw1/LTCxiVJxHiMtk3X8IbXefV3swo921APMcjh4XhCK3pBaYDDI68SO2BdTZpuS5F4Dhis0k867lbOpBbfoqrMPGfs6S5riOgaMLGF8xa0EOLq+gpkrlEXivJAMnrvgLEJSrVkGZM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by SN7PR12MB6744.namprd12.prod.outlook.com (2603:10b6:806:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Thu, 17 Sep
 2026 19:47:23 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0406.007; Thu, 17 Sep 2026
 19:47:23 +0000
Message-ID: <2685585c-b4bc-409b-a5f7-3b8c7a880ede@amd.com>
Date: Thu, 17 Sep 2026 14:47:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 0/5] Add RMPOPT support.
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1789594774.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <cover.1789594774.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0104.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::29) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|SN7PR12MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: 187a7902-578c-4cad-bbad-08df14f47df1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|10067099003|5023799004|11063799006|6133799003|3023799007|22082099003|56012099006|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	BqNzdY9v3ThWOCnmZo8uhaA7rNoUjmoBAsJiH505BlOvtXIyvVrWb0KvKJ6fmhOuSX7xKTw7ZvpTbZha2zCVI1Ew0gzf/9CnJWy6R4u97J5Ddh6I5FrcCehrq6FR+Ft8vCayS989S25rDXmlERBhoAK8WyOU+k4Jyog8KsAyzwTvH7vtvzX2Z0llKm3zN1vEikN8uqzJFBNShV/CpL1bQOS5br0UDDjstvWlrDsexClxKlvGo1gB3ztmX/ABiJ+1l3uiM6tOHczzUb8a2eM+I0pRnsA99r32hsf/BmympxaVgh7uAq81XHanREhWPZv3IRvmrlWT26G5IeFywyYiMNps1lqQhm6HGlGT3DcotNFWYQhQalQVyAzYgtRtJEqXS9VXBFx16vF6MRtU71zyCKXsb2ye21H93tIErRw2S+sxxwQKFnQvnN5OZENphY3FElqCs7MB5I0v1hjeY9flzxJaYHUmL7krD6kfg5QDE6fg+r2YOu9MH1F/+Dd39D+J8fxlV+qNLG4qL/SXHYfU3OPM50ZbZweAu2K/7gCQApcmgWAG1iZT596dD1yIY+CoSjkA0Dw3DXoSV9maIkdpHB3ZlhLNnwJYnb3Y3srJxHQ+vlthqCdDwEMOj+f2OflUHhNzUQCa90GYyBVhbLY54A8fWSQRBK2Nfp9TTKdX9MSDmxBOrJBlSb/odE7ad6xIOqoSv4jQBkJoDSmt//6W5g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(5023799004)(11063799006)(6133799003)(3023799007)(22082099003)(56012099006)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTM2T3lvQXUyWnlSWVBIVGlWMTN3Zkc4dFhOc2krbEpuaFdvRmVyV1JmNkxW?=
 =?utf-8?B?RnBDQ1R6U3plSDZ0ZkdtWTBPaGplUUk0aXJnblRqVmg3NUZaaXMrRDdQbVhS?=
 =?utf-8?B?T3dtVWlaU3pkMEpURFk3RnFqWEh4U2ZKdWtqZ2tCRGFQZWxJVGpFTStiNFky?=
 =?utf-8?B?WHNiUFFpalVSK1F3Qnl2Z1AwQXZhaWkxelc0M1I4bFAzNGN3NXhmV0xmalJP?=
 =?utf-8?B?R0I2R0Y1bkRoV2s0cG93OWRMMktUbTdzTTVZbjI3eU1GSm1FMXlxdWNDditR?=
 =?utf-8?B?SFZwVExJbGgrb0VBaFBOK0RCazFRaVFKZEMxWUN0SDVMeTVrRWszOEczYVNO?=
 =?utf-8?B?ZEZJWFJwYnFMbWY4MCtUWStOQjZFV0YwYTJtdjduZndsdzRsU3dnOFF3R0FX?=
 =?utf-8?B?Unl4M3VyK0dsUVYySDdyM1RmS3IxSjRlSEtYWC85OWhnOHlyamRNVU5BZG5l?=
 =?utf-8?B?bDFZb0J6Z1MxUE5rNUFrZGJXQVJaMzdRZ1dFQmxNWS9YeEx3dzc2ZDFMNkpR?=
 =?utf-8?B?d0lKMG5lTUFLb3EvMEZJUXdQUWZTTkprYUxEdlUzbEdIaFBRdTZoZ1o1TG9Y?=
 =?utf-8?B?YzVyU21IeVNONU5CRXp4M0MwdDlNenoxZHBYTmdzcWRWQTNXSlVXRTl6T3RR?=
 =?utf-8?B?Nm8yUEEyditieWRCSnhKWmhQM0VzSTJmUmlnbzkxV2R0c1dMTDJpT2tiVDdp?=
 =?utf-8?B?dHpBdGNETk1pR21GdzhqN2FuZXh6K3dNVk0wVlQwMllqYlc0ZnF6WHhEMlhW?=
 =?utf-8?B?U0tqTU42d1JQRTJrRHpnYTFLYzFUZTQ3V1duK3ZpcGMrNVFkNW82RXNWQUJX?=
 =?utf-8?B?Rm5jQUJrZ3NhT3RSc0pHSFdNSnZwUEJieUJySWFrKzRpd0NpZjA5a2RGci9k?=
 =?utf-8?B?Ui8xQlNzY0l3NG9jUm5vT1FscG1KSlpSVytMVWVQZEFROGVkMWs5NG1pY3Jh?=
 =?utf-8?B?WkozcENJSnd1OUF1ckxGQlRQUlhjam9WMi8veEN5bmpuQ3FZRG5SdE5ZejBh?=
 =?utf-8?B?Qk9yMWxvWkIvTTIvbXM5NEtQT3EvZmt5UHU3SlM1Vzdrbmt0Y3NaaW8wRFV1?=
 =?utf-8?B?dHduQ0xqR055aUVGbTRHd0pQaXVOK0N2R2J1MHlTWmRxZlptS2dlanFnbllm?=
 =?utf-8?B?a0ZoUy9XMXZDVE1hTzlPSlJQcFVnU0Vza0V5V0wyR3ZnWndncEx2Nk9MSkVN?=
 =?utf-8?B?TW1xQmEyMGZ0ODgvN1ZpeFlaVWlIaytsY29VU0VGU0JmY1Q4WlpJc0cwcVVP?=
 =?utf-8?B?R3ZXaTBEYjArQjBjcmoyVTVvOFMzL0ZyQXJML1RLbXdGWVdwelhTWEtxVjNw?=
 =?utf-8?B?YkNRYkxXalUrYUtwNmxGM2Z5Q3dlQmVQMGJFYUhZVGFSb2xjUzlaQWxSeW90?=
 =?utf-8?B?cEtGUE80MmI4T0tjL25NUklTSzZUaEp3RlFuOEVTNTlrMGZpT0IyMGtpVWMv?=
 =?utf-8?B?bjJVUU9wbERvNUVjaUplZTlXMjczcy9GY013aUJCSG8vQ1lPc0YzQm1GQmpH?=
 =?utf-8?B?QnV2SDBzSGc4TURpQXZvT1pQN3lNS1Q3K2RpelUxYkR4YWFZVDJyektBVm5S?=
 =?utf-8?B?ZXVJZlY1dlN2Y0J6ZVNQSGRZbnBYclJhSFpZN0JtdU5mSXJiSXQxVkd4a1Fu?=
 =?utf-8?B?TklhU3JqOEZVTUE4RWhRNi9yb3JFa0lzZHRaaXBBbkswUHRWLzVjQTI4dVU0?=
 =?utf-8?B?YUF5clZXbkc2OXlzajZSakxpYmhzZU1jem5kOStoWjNyb3B4U3FTemFTSHpW?=
 =?utf-8?B?aFM1OEJpcWY2VUE4blJpblg2WTNrTDB6NE5FTVRrbzEvelBkRXBKeGhXUVlv?=
 =?utf-8?B?SFNqeXIvdUt1QUNzSVh6TENRMEYwMlR6RHg5aHhER1NiRGFpNllub0JDeWVX?=
 =?utf-8?B?Nm5KQklLV2dNaE1FMDRZY3ZhcEtqYkw4dkZUZWlHU21aaUlUQnlHYUZYRE1T?=
 =?utf-8?B?d0VGUE1ETjBPSUpBRUpmeFgrMnBMdzNORHFvSmtlRFVrQURIVGI5TjBaTmUw?=
 =?utf-8?B?UkRaTytocS9mQ2ZWQnpVdU1md0Y5TFBsSC9ieDRjQlpTYTlTcFlzSzNBUzBB?=
 =?utf-8?B?ck5RR2VOSjF5V3k2a0dKM3ZwbkYvNG9HV2U5bHN6L3lnSkNoL3Z0emxodWJS?=
 =?utf-8?B?bDJWRmNKaTRtdEFPQm4vSmlNNWo2eFBQOTZ1MGtNb1VNeTFoTjhJS0svWkpF?=
 =?utf-8?B?WVdJa0tqeUNNeVZnZ3dHSHNjSmlNQUhkWlVkODNUT3pvQ0FHVDhZM1VCQlNB?=
 =?utf-8?B?ZDJJdEwrVllwM3dRUHVCRDhULzl1RllITkNXalhEUXF5ek9HSFdnZnExdEFH?=
 =?utf-8?Q?KVaNjFqqk7udVsracY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 187a7902-578c-4cad-bbad-08df14f47df1
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 19:47:22.9905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDPvixuQ+3NOqEMfxg2fjxEAPAdr5d9EjNVFHKtdCyBdy4plDDJcbcEV37JwgPx5LW4c+ct5qosBM6NXxINN4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6744

On 9/16/26 17:13, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>

For the series:

Review-by: Tom Lendacky <thomas.lendacky@amd.com>

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
> v16:
> - 3/5 (Initialize RMPOPT MSRs): clear X86_FEATURE_RMPOPT when segmented RMP
>   is enabled but its probe fails, so the initcall does not set up RMPOPT for
>   a system that will not bring up SNP.  Program the RMPOPT_BASE MSRs only when
>   RMPOPT_EN is not already set on the local CPU, so guest teardown skips
>   reprogramming rather than reprogramming the MSRs on every teardown.
> 
>   Review feedback from Sashiko AI.
> 
> v15:
> - 3/5 (Initialize RMPOPT MSRs): rename snp_setup_rmpopt() to
>   snp_enable_rmpopt(); program each core's RMPOPT_BASE only when it is not
>   already set.
> - 4/5 (async RMPOPT): split setup from enable -- an initcall allocates the
>   workqueue and computes the (fixed) optimization range once, and
>   snp_enable_rmpopt() programs the RMPOPT_BASE MSRs and queues the
>   optimization pass.  Gate rmpopt_capable() on a static rmpopt_enabled bool
>   instead of an if (rmpopt_wq) check and drop rmpopt_wq_mutex.  Queue both
>   the initial and the teardown pass with mod_delayed_work().
> - 5/5 (Re-enable on guest shutdown): call snp_enable_rmpopt() on guest
>   teardown instead of a separate snp_rmpopt_all_physmem().
> 
>   This is a full resend rather than a 4/5-5/5 reply because patch 3 changed
>   as part of the setup/enable split.
> 
>   Review feedback from Borislav Petkov.
> 
> v14:
> - 3/5 (Initialize RMPOPT MSRs): remove rmpopt_disable() and the RMPOPT_BASE
>   teardown from this patch.  RMPOPT is now set up once and not torn down, so the
>   RMPOPT_BASE MSRs are left in place on shutdown; the (now minimal) disable path
>   moves to 4/5.
> - 4/5 (async RMPOPT): rework the setup/teardown -- initialize once and do not
>   tear it down.  rmpopt_disable() now only cancels the pending re-optimization
>   pass.  Use a dedicated per-CPU workqueue (WQ_PERCPU) and drop the
>   migrate_disable()/migrate_enable() around the local warm-up scan.  Add a
>   binutils-version comment above the RMPOPT .byte encoding and trim redundant
>   comments and the 2 TB pr_info().  Reword the subject to "Perform RMP
>   optimizations asynchronously".
> - 5/5 (Re-enable on guest shutdown): move the call-site comment onto the
>   snp_rmpopt_all_physmem() definition and simplify the RMPOPT_WORK_TIMEOUT
>   comment.
> - Correct the Suggested-by/Reviewed-by tags across the series.
> 
>   Review feedback from Borislav Petkov.
> 
> v13:
> - 3/5 (Initialize RMPOPT MSRs): use cpu_primary_thread_mask directly instead of
>   building a local rmpopt_cpumask -- all primary threads are online while SNP is
>   active, so the two are equivalent.  Rename snp_cleanup_rmpopt() to
>   rmpopt_disable().
> - 4/5 (async RMPOPT): drop the leader/follower bookkeeping.  Warm the RMP scan
>   cache once, then fan the RMPOPT out to cpu_primary_thread_mask; re-running
>   RMPOPT on the warm-up CPU is a cache hit, so the separate follower cpumask and
>   the cpumask_andnot() are no longer needed.  Rename rmpopt_work_handler() to
>   do_rmpopt_work() and drop the now-unused this_cpu.
> - Add Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com> to the series.
> 
>   Review feedback from Borislav Petkov.
> 
> v12:
> - Merged the former "Add interface to re-enable RMP optimizations" and
>   "KVM: SEV: Perform RMP optimizations on SNP guest shutdown" patches into a
>   single patch (now 5/5), since the interface has no user without the KVM
>   caller.  The series is now 5 patches.
> - 2/5 (Disable CPU hotplug): drop a stray reference to later patches from the
>   commit message and trim the snp_prepare() comment.  Move cpu_hotplug_enable()
>   to the end of snp_shutdown(), after clear_rmp() and the mfd_reconfigure() IPI,
>   so no all-CPU operation runs after hotplug is re-enabled.
> - 3/5 (Initialize RMPOPT MSRs): restructure snp_probe_rmptable_info() so the
>   contiguous probe (which clears X86_FEATURE_RMPOPT) is the common fall-through,
>   also covering X86_FEATURE_SEGMENTED_RMP advertised but disabled by firmware.
>   Move snp_setup_rmpopt() to the end of __sev_snp_init_locked().  Give
>   snp_cleanup_rmpopt() its own short comment in snp_shutdown().
> - 4/5 (async RMPOPT): document the optimization trigger points in the commit
>   message.  Rename enum rmpopt_function to rmpopt_op_type.  Merge __rmpopt() into
>   rmpopt() and replace rmpopt_smp() with a new rmpopt_scan_range() that loops as
>   the on_each_cpu() callback, so the follower scan issues one IPI per core rather
>   than one per 1GB.  Use u64 for physical addresses.  Allocate the follower
>   cpumask once at setup.  Document rmpopt_wq as the setup sentinel.  Move the
>   RMPOPT_WORK_TIMEOUT define to the guest-shutdown patch (its only user) as
>   (10 * MSEC_PER_SEC).  Remove a spammy pr_info() and reword comments.
> - 5/5 (Re-enable RMP optimizations on SNP guest shutdown): document why
>   re-optimization is driven by guest teardown (the only event that returns
>   guest memory to hypervisor ownership); reword the commit message
>   (s/clear/disable/ for optimizations, drop "Conversely").
> 
>   Review feedback from Borislav Petkov.
> 
> v11:
> - Reordered so "Disable CPU hotplug while SNP is active" (2/6) precedes
>   "Initialize RMPOPT configuration MSRs" (3/6): the RMPOPT setup/cleanup code is
>   then introduced with CPU hotplug already disabled and never takes
>   cpus_read_lock().
> - 1/6 (cpufeatures): drop the tools/arch/x86/include/asm/cpufeatures.h change and
>   adopt the commit message as applied by Boris.
> - 2/6 (Disable CPU hotplug): reword the commit message.  Drop the redundant
>   cpus_read_lock()/cpus_read_unlock() in snp_prepare() in this same patch -- with
>   hotplug disabled the online CPU mask is stable, so the read lock is not needed
>   and hotplug handling has no hole when bisecting.
> - 3/6 (Initialize RMPOPT MSRs): replace the rmpopt_capable bool with a small
>   helper local to arch/x86/virt/svm/sev.c --
>   cpu_feature_enabled(X86_FEATURE_RMPOPT) && cc_platform_has(CC_ATTR_HOST_SEV_SNP)
>   -- clearing X86_FEATURE_RMPOPT for a contiguous (non-segmented) RMP in
>   snp_probe_rmptable_info() (runs at BSP init, before alternatives).  Rename
>   rmpopt_cleanup() to snp_cleanup_rmpopt() to match snp_setup_rmpopt().  Both are
>   introduced without cpus_read_lock() (hotplug is already disabled by 2/6).
>   Simplify the RMPOPT_BASE comments.  Drop the now-unused <asm/sev.h> include from
>   core.c.
> - 4/6 (async RMPOPT): the follower scan is likewise introduced without
>   cpus_read_lock().  Drop the cond_resched() calls (nops on x86).  On
>   re-initialization after a legacy SNP shutdown, re-queue the optimization pass
>   instead of skipping it.  pr_warn() on cpumask allocation failure.
> 
>   Review feedback from Borislav Petkov and K Prateek Nayak.
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
> Ashish Kalra (5):
>   x86/cpufeatures: Add X86_FEATURE_RMPOPT feature flag
>   x86/sev: Disable CPU hotplug while SNP is active
>   x86/sev: Initialize RMPOPT configuration MSRs
>   x86/sev: Perform RMP optimizations asynchronously
>   x86/sev: Re-enable RMP optimizations on SNP guest shutdown
> 
>  arch/x86/include/asm/cpufeatures.h |   2 +-
>  arch/x86/include/asm/msr-index.h   |   3 +
>  arch/x86/include/asm/sev.h         |   2 +
>  arch/x86/kernel/cpu/scattered.c    |   1 +
>  arch/x86/kvm/svm/sev.c             |   2 +
>  arch/x86/virt/svm/sev.c            | 193 ++++++++++++++++++++++++++---
>  drivers/crypto/ccp/sev-dev.c       |   2 +
>  7 files changed, 189 insertions(+), 16 deletions(-)
> 

