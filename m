Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F7E2E06ED;
	Thu, 18 Jun 2026 21:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781816897; cv=fail; b=dvHjH+LNUqAzBN3kegwpZtbxfZJ5bjtbczxTgzl89Va48hnDAyEX8Xa9yUhjLuG9Fxx80/QMUnfuoIJY08MmKcqpbQytuIR0Qp7DGxV6/rwmMrWVhP9ftYNnnt+8B3/DmCTP1K8TbcXi2Eu133uaBcAxe3Wnwo/4I/ENFHMlE7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781816897; c=relaxed/simple;
	bh=QlN7M/J5OvLE2Js/w8E5ialXWkwvbl7HMwJvRSKvZbw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G/Lc6T7Olr6ynBVHVUZkywS55OeBpt32I3tAzTzqPW562DNUTujWvyHaySuia7fvmYyFO5VgXTsx40H7okyPWTsqif4DabLgkWT4qR84qto6/Swb23LhR7+P/pjNGZ6ygpqzEJ0T9+DUC8K0waKN6p7iIjP8kwqmk1HeO5mQcFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PFzRxbfj; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PFzRxbfj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tt0wZ+B5giR8ZDMZ0b8ZSWlIilOWvN+VhAG0SLV1HLTdsrxDYFk9VhFhLCjptkMJieN7xAS3CoOD0beiq00IcXuiO3EICy2dm1UuI6enVTvjgO8j6usF6VcuMGCiDly8+eLcRNNoIQNFWF6L0qaL6aZghMO2aiyCrYqHBTWBYGf5t/Il8M8Rni4cqL+y4qZnqdB+pW5gIWQEe9TMXytQbJ95qYNv3p0/GUjQLyeqdxJnN8QgFBYHKkBnE+HsqRZDxorMmeXAgNEEpG5MDeUQLcB3QzNqgqflKfnh3R1PXuHQ0kfw4LDLYLArF127QeonWpByT2fD7gY+zkKO445AhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SPPSxLBkjWQkJLG2UKfapKboSL3l1wcy98pFWfqmcDw=;
 b=PJQkftTYydW+wA9fjb4JYAvEfuSojn9kO0Atr2q4botpuTGhxCKQ1c1UE3vKs1lZ4rTtPzV0yPf64ns/8O2IJw9++ffmli6wExA+FPe7zIwY1+Llk4xPQbNRbaJNyleJz7s7LlrQ4wuachB9x4uzf0HKwytzbyx5VcPIiZ4MnNwFYRNMTG1D1QncSZboDgL7O4xcKQvCMJ4Q5kaHbYIB88/RW4RTLkWvx8imkaaC3MP02C5Lx3Xo2DxWwVG0D1CvSDC995U8uTNtCUBWDPL7ql0p9mJqwC/ODgd9Brl0cE16+htZW2ev9sgmB4ML6GLNM/0IfUpUwI40Jpza33DWxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPPSxLBkjWQkJLG2UKfapKboSL3l1wcy98pFWfqmcDw=;
 b=PFzRxbfjPPxhDwg7RfdDNI1u1smFalbKlu/3ZnSgd1ZPJadJlfNKFXm60oFyX3gP+NYHFVVP1s6dnnBGRudfZ6d20yddbdzGUxK+XztJyygj8NxqHe+2ciR2Ho9/R/7UVFZTsI9HQVfxpKYghwy5AqveE48V/Jq5g+cU/JeUDEU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by SJ2PR12MB9137.namprd12.prod.outlook.com (2603:10b6:a03:562::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 21:08:10 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0139.009; Thu, 18 Jun 2026
 21:08:10 +0000
Message-ID: <bc4de90e-094b-4695-baf3-2186ce250873@amd.com>
Date: Thu, 18 Jun 2026 16:08:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/7] x86/sev: Initialize RMPOPT configuration MSRs
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, herbert@gondor.apana.org.au,
 davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 ackerleytng@google.com, jackyli@google.com, pgonda@google.com,
 rientjes@google.com, jacobhxu@google.com, xin@zytor.com,
 pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com, dyoung@redhat.com,
 nikunj@amd.com, john.allen@amd.com, darwi@linutronix.de,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1781419998.git.ashish.kalra@amd.com>
 <6a4d0ec9e037d91c0fdba9c525942ca288e1b1b2.1781419998.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <6a4d0ec9e037d91c0fdba9c525942ca288e1b1b2.1781419998.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::26) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|SJ2PR12MB9137:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e11a76-ac6c-4d36-faa2-08decd7db3e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|56012099006|11063799006|5023799004|6133799003|3023799007|22082099003|18002099003|4143699003|921020;
X-Microsoft-Antispam-Message-Info:
	D+PuBPrYyjGfcMjr2LU2ORXDiBpW1f7WPg6JHzM/+9JjjjDy5xJfwM5XaWpUkENPWrcwqtoD7bf3P8vNKw1zcOTRCMxFul0tLkAqZD0yohh7COHNqtgTXq4bd03XxQioQuofObWUq/GM0+LGZ3EV9eG4vuui8H7hM/2rU/uDOB4Lr3SJmFmSYht5AQPZx6x4AnlO3VNVCHeM/dlkSZfbyovr8D8ATr2ft15jo1d1BaZMYF65YkGIBSJzk+m9hgHCgCxig5TjECNAnqZGK3xMkOscQZQc9SOPYCCaiunQ5N/aXTcCHRnXDWA4any+wDBbMUk1HI/KaxCGu7tUlt+aFmpDHeXdODnayUyV8jxLqRoAQ++TYrxRJdkN4mv+3/cnWo3thmY0FNn5dZghaYD+uILR+GdpiOQZbKnZF2KE/njAapCm9SoeSkReyk7765rM2iDoXDRwIVlDmHq7yvaAELPykizhdnj347p4kTVKEWx5JjdkkdTUxLKLVUkQhheVNrdFZplk+ODtpftcu/hAMbsejKhgarKbWDbrt64u0OkBmDaoaEtOx42DWKcSTRbWpvBnM6IYdc8mAywYxfh9uJGy8TVtsqU2QHhlL7aePTf6VBaM5ZjzZZhDZ/KlWg+BTV1StsYdeBxZtkJkzuzEMVXpRNjidOdq1zxkDaO345vOveEbzq6mXlwGbC6Ga3s6ddRDHgZ9uWts0ortTNbrAw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(56012099006)(11063799006)(5023799004)(6133799003)(3023799007)(22082099003)(18002099003)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVVWUkYwVk44R0lvYUZwdVY3VVdvZ2RBQWxSNWo4YVR6SkVQZVYrSjJjRUJE?=
 =?utf-8?B?clNiS1ZzRXV2c1BPYVJSbXE0NTZpeDRwbEhQT2d1clBUc2htWHBRS3VBdm5j?=
 =?utf-8?B?K2pDK2wyVitac2psZlF5VW55SEFsaXd1a2FuRVN5V0RCQ1g5YWxaSm9DT2V5?=
 =?utf-8?B?VUNtMndhdXQwM3hSRVRraVZwbHZzMG5Oc2ljWWZkc251Q1lmUlBTYW9GMGEw?=
 =?utf-8?B?WW02OWM3U3ZqM045d1pjZVBENXoweWlPeDFEeXROcE56aDU3aTBISWJpVXln?=
 =?utf-8?B?S3g2QkZod1dFZVoyZFRFYlNOQXdoaGVhL2dlNThXMTlncjZQQ3dMYWU4Q2Q4?=
 =?utf-8?B?Vlh1WHI1Z25xb09wT25iV2FRSHNPZmlpQ1RzeTZPWjJ3SDE2ZEFaM1RUUjVa?=
 =?utf-8?B?Zk8wTXUvbXdhcnNsSXBvcDJkN1BQVFlhblQ3VmtCcm90YktsK2ZFbElBR2Jp?=
 =?utf-8?B?OTZjK1hqR2N1T2tsN250NlFaMEtuaXkxMFBzQzZvVVM4YzdLUVFsUkRVVVJs?=
 =?utf-8?B?Z1dQQUEyODB2Q0lEcG5XaUpsNWN3cGtHd0NyUjdEYmdMNnpPNE81Y21WMWd0?=
 =?utf-8?B?bW5nbmFlUGpmUkVrVzc4VHA2aHppdEx0dzlmU0VaUmVici9hTWM5TlVPRHhz?=
 =?utf-8?B?MGF4dVRyelR3M0JjSVRkbEtmdDZGVGVKeWY2SEY4T0FCeTNQWWxWeVdsTVRT?=
 =?utf-8?B?ekNJa3FuOTRZUVV3aU56aW9lb0NxUFhlUzRLRmFKT0ZwNlkyaDRVLzJMdVZv?=
 =?utf-8?B?SlAxSXVPMDFnQ3VNVEpxWkJ4N09xd0VQaHNTQ1l0Z0pNKzUyRENvbWdlcmVh?=
 =?utf-8?B?emRWNW5td2lZQmNFN2MzakF4THpLaDlKTjZBR2NyMnV2d0RIakdWZ0hQMVU4?=
 =?utf-8?B?MXM1bU9Va1lVaHFiOUlBQmlXSS9SdUk0STRwV3JGK2c5U0x5UGJuRVNoZEJC?=
 =?utf-8?B?cFZ1YURVdVNlVjBlMXFqbDFVamFRcTFiVjlwTEh4Y0NIZk5ucXUwaFRjQzU5?=
 =?utf-8?B?RUlVZjB2TkRzUm9xdnV5cTNRc25wS0hKMVIybHdUNzRyY2QwWmNjUU54U0Jj?=
 =?utf-8?B?UGpld2hyVjV3UU9PS0ZEQVRqaW9VbERlM213ZWZkbExrWnFMUzUzY2l0RkU4?=
 =?utf-8?B?ZWoxRUk3WWZRVDNPbjl6TU82TXNYTXFQZ2lubjVMRnZzZTJHTnNzMytETVBl?=
 =?utf-8?B?T2o5dnRZKzRiNzNqQjdsdDhoWCtiR000Wms4S1RlbWY5Tk9jVE1waVNoNWF3?=
 =?utf-8?B?dlpPUFlLaDRTdjlsbFNVdFg4cEFRTVpXWXpseDYvZ0hMdWk0UkVLU3E2ZEYr?=
 =?utf-8?B?RHA1ZUcwdUxUTVFUU01aenZQdU05MXVEZUpSRlJhb00ydnNNQy8rTUZ0Vitr?=
 =?utf-8?B?MkZmd1BhWk5UeHhoanlnN0NpQ2FqVXlNdnRmOUxxcy9tREpDODdzbDNoU0xz?=
 =?utf-8?B?ZUZXbVJJZmNYUG9WZ0ZyR3hRUEl0OVkxdzRrRVRqcTR6L0h1RHVmWjg1Rnh2?=
 =?utf-8?B?UTlUWFc1cW9PR2U4SUFHeXhWb1ZVNlZVeVpkWHJEaEg2THBrN3BsVkRGRG1P?=
 =?utf-8?B?b3BSczFiaDRabFNQOURyR2ZnL3dCdHh5VlFuY2o0ZkdRSWR5QUcrSTNuc1JO?=
 =?utf-8?B?c1AxclJhd1FXVkZqS0xDK2Q3dEtoTzNVWjZBck0vemw0QzB5Y09OM21xUkIy?=
 =?utf-8?B?VzVCSk1jYmNtUzd3bDZDM3JVSUo1UnhiU2JJTkhCY1BqWGxiYWpkS2twVWhV?=
 =?utf-8?B?ZzkzcnFCYUQ0d1JhVVJnTjF4RkV3eUQzUTZibDQ5VlQ0TUdmUnB0cU9KVjB3?=
 =?utf-8?B?T3ExOEFtb214eE5BQ2FpVGxLbmNqNDd3ME9ua25ZSHBvQy8vcGtGM1FrWnBZ?=
 =?utf-8?B?blRXUkEyVmJMbDc1U3JIVFlmR2svVkMwdTVoM05mL08wQitkR3VHSGhpdkFs?=
 =?utf-8?B?WTBNMHY2UUlwKzR6YWdJSmZ2R0dnbXRxdTZmMFJBQXg4NUFJR3JoWGFGdHlj?=
 =?utf-8?B?TzdWalN3SGlYOE5yRzVsR3J6cjRWbWthc25EZVNjOWVzbzlXZzdrU01oWEtF?=
 =?utf-8?B?MkE5ZkxseGVqdlk2bjVTNlFKVmFqYnhoNG1rYlgwUHBIVE9leTd6enJYWUc1?=
 =?utf-8?B?Q25MNzAxbmhXWGw2U3YwNUZJeWxjQksxTHREWTZkc3RBb0Myb2wrMlY2OXdu?=
 =?utf-8?B?aklpNk1vQVRsMWZya3JWU3YySUw5aGI5N2RISytBQXozS1pORG5WVllRdnRx?=
 =?utf-8?B?YWdEQmc1REpodXA3TE5QSlp6dC9QcHRxRjQzbW53aDV2RDlaVjZoaWc3bUdM?=
 =?utf-8?Q?73qb8Hk1oH+610Dbu3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e11a76-ac6c-4d36-faa2-08decd7db3e6
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 21:08:10.7810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8i30X54HpiKgGRMVIuxO5wHIZoAfbezO5+rG/JCCw2GV6jaKN1XhSuNepfKrwseqh1KGilgOvFOTWYjUalaqrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9137

On 6/15/26 14:48, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The new RMPOPT instruction helps manage per-CPU RMP optimization
> structures inside the CPU. It takes a 1GB-aligned physical address
> and either returns the status of the optimizations or tries to enable
> the optimizations.
> 
> Per-CPU RMPOPT tables support at most 2 TB of addressable memory for
> RMP optimizations.
> 
> Initialize the per-CPU RMPOPT table base to the starting physical
> address. This enables RMP optimization for up to 2 TB of system RAM on
> all CPUs.
> 
> Additionally, add support to setup and enable RMPOPT once SNP is
> enabled and initialized.
> 
> Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/coco/core.c             |  2 +
>  arch/x86/include/asm/msr-index.h |  3 ++
>  arch/x86/include/asm/sev.h       |  4 ++
>  arch/x86/virt/svm/sev.c          | 70 ++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c     |  3 ++
>  5 files changed, 82 insertions(+)
> 
> diff --git a/arch/x86/coco/core.c b/arch/x86/coco/core.c
> index 989ca9f72ba3..8c1393ddc5df 100644
> --- a/arch/x86/coco/core.c
> +++ b/arch/x86/coco/core.c
> @@ -16,6 +16,7 @@
>  #include <asm/archrandom.h>
>  #include <asm/coco.h>
>  #include <asm/processor.h>
> +#include <asm/sev.h>
>  
>  enum cc_vendor cc_vendor __ro_after_init = CC_VENDOR_NONE;
>  SYM_PIC_ALIAS(cc_vendor);
> @@ -172,6 +173,7 @@ static void amd_cc_platform_clear(enum cc_attr attr)
>  	switch (attr) {
>  	case CC_ATTR_HOST_SEV_SNP:
>  		cc_flags.host_sev_snp = 0;
> +		snp_clear_rmpopt_configured();
>  		break;
>  	default:
>  		break;
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 86554de9a3f5..28540744f1eb 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -761,6 +761,9 @@
>  #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
>  #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
>  #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
> +#define MSR_AMD64_RMPOPT_BASE		0xc0010139
> +#define MSR_AMD64_RMPOPT_ENABLE_BIT	0
> +#define MSR_AMD64_RMPOPT_ENABLE		BIT_ULL(MSR_AMD64_RMPOPT_ENABLE_BIT)
>  
>  #define MSR_SVSM_CAA			0xc001f000
>  
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 594cfa19cbd4..0d662221615a 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -662,6 +662,8 @@ static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>  	__snp_leak_pages(pfn, pages, true);
>  }
>  int snp_prepare(void);
> +void snp_setup_rmpopt(void);
> +void snp_clear_rmpopt_configured(void);
>  void snp_shutdown(void);
>  #else
>  static inline bool snp_probe_rmptable_info(void) { return false; }
> @@ -680,6 +682,8 @@ static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  static inline void kdump_sev_callback(void) { }
>  static inline void snp_fixup_e820_tables(void) {}
>  static inline int snp_prepare(void) { return -ENODEV; }
> +static inline void snp_setup_rmpopt(void) {}
> +static inline void snp_clear_rmpopt_configured(void) {}
>  static inline void snp_shutdown(void) {}
>  #endif
>  
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 8bcdce98f6dc..1b5c18408f0b 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -124,6 +124,10 @@ static void *rmp_bookkeeping __ro_after_init;
>  
>  static u64 probed_rmp_base, probed_rmp_size;
>  
> +static cpumask_t rmpopt_cpumask;
> +static phys_addr_t rmpopt_pa_start;
> +static bool rmpopt_configured;

The usage of this isn't doesn't imply what the name says. How about
changing it to rmpopt_capable ?

> +
>  static LIST_HEAD(snp_leaked_pages_list);
>  static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
>  
> @@ -490,7 +494,12 @@ static bool __init setup_rmptable(void)
>  	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>  		if (!setup_segmented_rmptable())
>  			return false;
> +		rmpopt_configured = true;
>  	} else {
> +		/*
> +		 * RMPOPT requires a segmented RMP table, so leave
> +		 * rmpopt_configured clear on contiguous RMP systems.
> +		 */

I think this comment should be above where rmpopt_configured is set,
slightly changed to

	RMPOPT requires a segmented RMP, so indicate that the system
	is capable of configuring and running RMPOPT.

Thanks,
Tom
>  		if (!setup_contiguous_rmptable())
>  			return false;
>  	}
> @@ -555,6 +564,21 @@ int snp_prepare(void)
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare, "ccp");
>  
> +static void rmpopt_cleanup(void)
> +{
> +	int cpu;
> +
> +	cpus_read_lock();
> +
> +	for_each_cpu(cpu, &rmpopt_cpumask)
> +		WARN_ON_ONCE(wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, 0));
> +
> +	cpus_read_unlock();
> +
> +	cpumask_clear(&rmpopt_cpumask);
> +	rmpopt_pa_start = 0;
> +}
> +
>  void snp_shutdown(void)
>  {
>  	u64 syscfg;
> @@ -563,11 +587,57 @@ void snp_shutdown(void)
>  	if (syscfg & MSR_AMD64_SYSCFG_SNP_EN)
>  		return;
>  
> +	rmpopt_cleanup();
> +
>  	clear_rmp();
>  	on_each_cpu(mfd_reconfigure, NULL, 1);
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_shutdown, "ccp");
>  
> +void snp_clear_rmpopt_configured(void)
> +{
> +	rmpopt_configured = false;
> +}
> +
> +void snp_setup_rmpopt(void)
> +{
> +	u64 rmpopt_base;
> +	int cpu;
> +
> +	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT) || !rmpopt_configured)
> +		return;
> +
> +	cpus_read_lock();
> +
> +	/*
> +	 * The RMPOPT_BASE MSR is per-core, so only one thread per core needs
> +	 * to set up the RMPOPT_BASE MSR.
> +	 *
> +	 * Note: only online primary threads are included.  If a core's
> +	 * primary thread is offline, that core is not covered.  CPU hotplug
> +	 * is not currently supported with SNP enabled.
> +	 */
> +
> +	for_each_online_cpu(cpu)
> +		if (topology_is_primary_thread(cpu))
> +			cpumask_set_cpu(cpu, &rmpopt_cpumask);
> +
> +	rmpopt_pa_start = ALIGN_DOWN(PFN_PHYS(min_low_pfn), SZ_1G);
> +	rmpopt_base = rmpopt_pa_start | MSR_AMD64_RMPOPT_ENABLE;
> +
> +	/*
> +	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory
> +	 * for RMP optimizations. Initialize the per-CPU RMPOPT table base
> +	 * to the starting physical address to enable RMP optimizations for
> +	 * up to 2 TB of system RAM on all CPUs.
> +	 */
> +	for_each_cpu(cpu, &rmpopt_cpumask)
> +		WARN_ON_ONCE(wrmsrq_on_cpu(cpu, MSR_AMD64_RMPOPT_BASE, rmpopt_base));
> +
> +	cpus_read_unlock();
> +}
> +EXPORT_SYMBOL_FOR_MODULES(snp_setup_rmpopt, "ccp");
> +
>  /*
>   * Do the necessary preparations which are verified by the firmware as
>   * described in the SNP_INIT_EX firmware command description in the SNP
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 78f98aee7a66..217b6b19802e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1478,6 +1478,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  	}
>  
>  	snp_hv_fixed_pages_state_update(sev, HV_FIXED);
> +
> +	snp_setup_rmpopt();
> +
>  	sev->snp_initialized = true;
>  	dev_dbg(sev->dev, "SEV-SNP firmware initialized, SEV-TIO is %s\n",
>  		data.tio_en ? "enabled" : "disabled");

