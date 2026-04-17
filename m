Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010071.outbound.protection.outlook.com [52.101.85.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3333B5850;
	Fri, 17 Apr 2026 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776436470; cv=fail; b=nrwWf8Ko7DxJiVJjCnMmgYiuPIeS2drBZRD0KNP6vNX5UjMejC0jguqW/iR24Ej0AOphYmKGui62+uC0+TQpFETcG9b6j0JtZGx8eBkI89qdBqqBwVzvToh8+k+HTqTO1SCiaEl/HWyjc0CNTfza6m8ITzgjnlC2cfWRgapfM0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776436470; c=relaxed/simple;
	bh=DSFcIMZvK+6juq2vvQogzFZNjMfHuYHINjlWg7/1P/I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ne6DzbFrJuXfvdVo1KSIugoqPhkunNAAwptuALdzFST6kB39ozec92f01Wfgi/z2eYH/QU0QKqEPmcApiMmVtCaGmCbTosRiVue5FQQN6eIO94/u1B7XovKYpubTtrmeHcDtO5QQXAplx3avcmfsx9qE39BX06Vnz9nuve1rcZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uRJRFzwp; arc=fail smtp.client-ip=52.101.85.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uRJRFzwp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFAoEnxtxRE2oVrsDNLa5zXxBmszuNutf10dmhHZaYB77zXrLdGP57KlR2u+VnFox9Tsq8JAdtMjn96fL6fVuHi82R/XmbHkw0jHgN2usdvOqhshgykyR1/42gDEmjWOHaN738eoLCoNOzDcujL0qd8dR0wliaNccWcqMJbpZixgzUFk/cfLRfwQkfNEAN4aIaAHQh7ciZdk8Jse9P0z/73ujV64ZJNqZJa9ohDUwp9juxkcHontYjquVaJQhGCS4DehB/I1CNB6EtD2OzhYYYKqD4F5NxFXbWWb0LxfMqdw99Tb8eVSKK2njirOHulBuINax3RM00CLBD1Pf/HP1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MhyhOMwvKI4B2jcji/oTvKaTuNi2eZE0SM2BLu6M2GA=;
 b=KG0+XGiHyqpDMbJ/tYLaxSNd3bNNau5cpRAGlBljLtubT3YTeVqHG2FWREOuGd+axJPgnRRoFrAT8N7qMPbJubIR4UEGzHydthI/jg2vIOGDjE31kI8OB5hkitqmOjoqmoHIcYl30qWkUNKeIKDoMGbF5c/c4XrWgbr5Vrm7JzZGKSGcADytUD8cJyShX7BZ4E2zI3Bs1BTO+LZbOhomWTqLwBX0rBeOEOrqWUi1P2aScGBXkFcDqNvfPraVpDaozFTtbcCQWEobSOgh9Evd7EnvJvzQqG/3jSmVDxmKaj1i/ZKz21DOPJ/srgJ6ug/DDmkYUxgKI0gX/tsCNe5AiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhyhOMwvKI4B2jcji/oTvKaTuNi2eZE0SM2BLu6M2GA=;
 b=uRJRFzwpO6CXmK8gBUOUbXs7TtXdFRyO4CTlEAFcKE2H4y/G2A77t2u8bqPUzsNCRep2otgcSKGu2dorZBKr1uYG2/6uElXJaEvTeMZqs991yiUJwbrAf0Y/OxqneEzfIAPxdtnkHNVrgzV2riFwcWwTkJSSehhQv792zLpNqLw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB7806.namprd12.prod.outlook.com (2603:10b6:806:31d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Fri, 17 Apr
 2026 14:34:26 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 14:34:26 +0000
Message-ID: <dcd7f51e-c3b0-4f8b-b028-ce7e68f8ff4f@amd.com>
Date: Fri, 17 Apr 2026 09:34:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] KVM: SEV: Consolidate logic for printing state of
 SEV{,-ES,-SNP} enabling
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Tycho Andersen <tycho@kernel.org>
References: <20260416232329.3408497-1-seanjc@google.com>
 <20260416232329.3408497-5-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260416232329.3408497-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0403.namprd03.prod.outlook.com
 (2603:10b6:610:11b::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB7806:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cd22a5d-daef-422c-f6b4-08de9c8e6cc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	peK8yeUPSSerZWzhZJZrxURHtUDeM2+f2kCp5YBGIoKxQQbzmdH5CvbX6iIyQxlaLzFj0UJnSTgwsihtKi/aOXwJ3iaSNA/VG0cC9h77ANATFRzkAiM1h7cfIWVtYqa91tjPR6OPZ55gvH5dpXdrwbCVsh24igksix97S2mGKlb30ZDSotLjAc4TRQ0I4Wue46FeNB9dpw8OXdf2eMvWOKET/5WyWS6efmdaJlDgPK9uvOMUNPN3Ac9sX87Wt77WzwIr0gzJ+AEIax9opadiEnekd6WrDa1KOJ70kem7HyBdzJOCwK1Qjxj5DWseHmtvjHsaifMvXavI5XtNd2Wa2Yfwve4YXeiEGVf7obRldL6Pmqg4Yp+C3bc5EzIkRa3sj4XI/axRbKicnar9RGz0UNtfYOX0/a8N86S01u72WzcKHQa9oysD6ZraOKpZJj1etoNbPY9mMG8F1FcjGKTGJHYQwj5Apmj6Y4tke7Wx12fqgf58yIZzsateAJB8jpKRs5DrwSAnMxHIluWrqDC0fMdxpQxnRUVfygkitAlQg9GYzbh9U3WQXwOl6/kl9akFHB8L8yCaV/n+6gJ3spDu2pkWYxkXfPXQSasTTmtLHvnjYdVwYYJZIjnMr7yFfI1QeXcEG7Gsci+WRCw4P+aXH3krQx5fp/v+KgAt43do1BLhmgePH0Zcq8DaSA+jdEjxIeU1L2FtQK1eAHuVjWdaIH3ypdqLYzobeQFZBYTg0NQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1NsL2xmZlVWNW5PRE40L3JteU9hWGNMSmx3dGlTbEpBK3NPQm14QjBocUhy?=
 =?utf-8?B?U0RGVkVaWEhOOTJYVFhMdGsxejJNLy9IRlRPcW4veWk1YnJwUmpGRXJjV1hw?=
 =?utf-8?B?elBQNkJCb3hkdnVpSzBBbmVUMlpsaU1DM3hBU3Awb0pTaXNkWWhCaWFzakN0?=
 =?utf-8?B?QlB2OUkzZEx3Tk13cnNySU9kNU5tTmNlRHlrc3Z6TFJ3T2x4SUhPTWFaMEJj?=
 =?utf-8?B?UERyRWZicCtoSFQxTFBhQXRmV2xVeGdMUCtLNExzQlpVZmlHSXlneHdLS05n?=
 =?utf-8?B?OWNWYTJzQ3dBbm9MQnp3U3BwdXBYdzYxQW1OcXRYM0lVcEZWbnI3WnBteGJw?=
 =?utf-8?B?UHpEVk5XWWI0N1FDVXg4aHplOCtBWFUrYXZUZEU2M3dPYTJidmRjNU8zVm8y?=
 =?utf-8?B?VXZHSlA3WjNreEpYK2I3eURGcEZEZ1AyMytoQ0c0Nm9DWElwVUtvYkpzZ2Yw?=
 =?utf-8?B?RzV0a3BDTUxWVmkzamV3VDRxanpzSWpTaFl0YnZiTlRzaUYwM3RQREloTGpm?=
 =?utf-8?B?UVBQbnU4YVNMNTdoTnBuYzRIRlVFbzJoVWM0Njk2TXl3TzI3cDRMWWcrOEwy?=
 =?utf-8?B?aElkeWhGd2Y4VWQ0STlFUkZhbUdPVUIraUs0dmZzZi81eWorOTQ0NldMTWNi?=
 =?utf-8?B?WjNrSldwOGZMNVQrWUFxUEtUQnRxYTVTREdmUkk4dEhmeUJSVm5KaHVCMHJY?=
 =?utf-8?B?WWJ3T2VtVVRDcFRjUEVkNEJSTmFlN2xPWFRBcytLaDZZRkNZc0xQcVMyNWc0?=
 =?utf-8?B?eTlOVGhxcDNxUnpjMXc0MU1qUXRwdEpEUFkvakVKYjhua0g0aHlMa0FreG9z?=
 =?utf-8?B?cnNXenVmOSthMnR3b3pOdFB6SlJXWXlmcHpwM21VMHVwOEVFVGxOUUQ3R1Nx?=
 =?utf-8?B?c2p5ZGNmN1VPdjd0cTNRWFhwN2ZSK1RycUVFMDQrVEVTazZvOHpZQUk4VXdx?=
 =?utf-8?B?eFZEQldpckViMTlKUUpYdlYzcFBCTENURHBkQ1hvaDVTZytZVVZTVGZ6UVcw?=
 =?utf-8?B?dHg1WDZKU1ZoandzcHcxak8reitvOVd2YWJ5WGx0cmxLdVBlNEk4RDRXRmdP?=
 =?utf-8?B?M2lNTG54UWdhRHZCNktQYUx6ZVUrVVp3TFNlNFZnWGdPYWNVK0ZaWXcrNEhp?=
 =?utf-8?B?VFhwQXErOG42aG14MW1NanB0amErRmRIeWRxVUx3Tk53eUJYbEN6YmZDeE95?=
 =?utf-8?B?K1EzN2tjRW15cmh5cmp3S1BIQ1Q0OU9WOHpzdmFORnpNU3J5emVaTTVpOUlu?=
 =?utf-8?B?R2tqMWhhYnEzek1kb1BiSmxDVm1TelRjazdCc0VWc0wyNXMzZkZmTDJDUjBn?=
 =?utf-8?B?bTlEbXVTekVkczY3Vlo5WFJvZnBQSm8rbU94dFZuZUQ2VER0ejg3RjBXdWla?=
 =?utf-8?B?VDllSzNycFFOZ1ZxVHFaRGFuanVGWlR6RUFGNXpjQi9DYnYzcmMxV0pQNTNX?=
 =?utf-8?B?bVBjN2ZHbUdmdDJhNVpqNHR5SVpCZlU4US95VE9nTDFUUXdtUVVONm12UjFY?=
 =?utf-8?B?YndGcXlJOTdxRkhNbW5hY0psYktNT0srU2NFTGJYMGd4NU5XU2tEVlU3clFO?=
 =?utf-8?B?Ym0wMzQzQm00MDhoc0NyRTZyQnc5djJ3M0FVbUV0bWlJNXYzOFZ2elNVQWtq?=
 =?utf-8?B?L1pkYlRsWXAyN3ovT05zV211a016SVFFWUU2dVNLUEJUdzh0bnNZTDlJS1V4?=
 =?utf-8?B?aHE5TEZoVXhPZ0FPOWJ1UHhVWTAzR25FTUs3YnVOVUV6dTRJMmtQaXdnSXV2?=
 =?utf-8?B?SVF0bnMzTFBWV2NaTVV0RVNsNHJUWU5nSzUzRmxPejhhV1pua2JlaW9wR0dq?=
 =?utf-8?B?WldZQSt2UWdMQ3pXamFVNmlydWw5YXFKMVJhV1hvZmVNQ2lxank0VUJSdjZs?=
 =?utf-8?B?dEJqRWNSTk5aWjQ2cEpzTGlhcEcycTA1SmI5eXhqMHJ5WjcybWV2Tmc5RW85?=
 =?utf-8?B?WktQSDlKSW4vYnRRZERTU3YrMHZpelpkVzBMdXRFdjhFU2JGaUIzdERzKzJ2?=
 =?utf-8?B?RkhsUDJZQkgveHQxb1NvNjE2WWFRZkJlRlVVbklkVU1LdWpIVHJCcURzOTJD?=
 =?utf-8?B?N2xhVXlxeFlSbWtIcXE1a1pEMml3YnhDVXJXRGxHU1k0cHZkTFNNUUZZMUF3?=
 =?utf-8?B?aDV0SWFEZkFReXhXOXY3NVdlQkJPRkVCeEQxTWxxTi9DV20rMVRRNG51OHR3?=
 =?utf-8?B?aUd4K1hEeHBvcDd5UEwrcW9PaElOL3RoNnQvODljS3poamJJWUVOYjNKUk03?=
 =?utf-8?B?bHBJVkpMQmlzY1lENjdvVnFWcUplbkh5TFB1Sm5VY3BRY0NEenFmaFFic051?=
 =?utf-8?Q?ZESNW3FmMAO2a8ApJx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cd22a5d-daef-422c-f6b4-08de9c8e6cc0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 14:34:26.3612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FdLHcanKc7E8muXRgfNe8wQZVZqCYXNZb7wW7RuuzBDKyQdVhTP2DXpd70QyXhuR5EUFLhI5heoa9q9d48u6wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7806

On 4/16/26 18:23, Sean Christopherson wrote:
> Add a helper to print enabled/unusable/disabled for SEV+ VM types in
> anticipation of SNP also being subjecting to "unusable" logic.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index ea4ce371d5f3..dfeb660b8f5d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3050,6 +3050,11 @@ static bool is_sev_snp_initialized(void)
>  	return initialized;
>  }
>  
> +static const char * __init sev_str_feature_state(bool is_supported, bool is_usable)
> +{
> +	return is_supported ? is_usable ? "enabled" : "unusable" : "disabled";
> +}
> +
>  void __init sev_hardware_setup(void)
>  {
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
> @@ -3199,19 +3204,15 @@ void __init sev_hardware_setup(void)
>  
>  	if (boot_cpu_has(X86_FEATURE_SEV))
>  		pr_info("SEV %s (ASIDs %u - %u)\n",
> -			sev_supported ? min_sev_asid <= max_sev_asid ? "enabled" :
> -								       "unusable" :
> -								       "disabled",
> +			sev_str_feature_state(sev_supported, min_sev_asid <= max_sev_asid),
>  			min_sev_asid, max_sev_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> -			sev_es_supported ? min_sev_es_asid <= max_sev_es_asid ? "enabled" :
> -										"unusable" :
> -										"disabled",
> +			sev_str_feature_state(sev_es_supported, min_sev_es_asid <= max_sev_es_asid),
>  			min_sev_es_asid, max_sev_es_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
> -			str_enabled_disabled(sev_snp_supported),
> +			sev_str_feature_state(sev_snp_supported, true),
>  			min_snp_asid, max_snp_asid);
>  
>  	sev_enabled = sev_supported;

