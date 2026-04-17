Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010017.outbound.protection.outlook.com [52.101.46.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234B33B582F;
	Fri, 17 Apr 2026 14:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776436675; cv=fail; b=s3zROLAPMPkmpDtCjO7skZS3HmdJ1lDfgqiCWsjr/+iKdlkvNRS392N0bUUcgnfiee+jbZA4TScp2r2LWaDQehM1Zn6qZ0aq+G6dJ0EmYp970V7lGGmIx2LU8y3b8EJgPoiXBaxMK5UM3I93zonbBDcyu5kDpN8QKR+okpcC2j4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776436675; c=relaxed/simple;
	bh=ePJLtchbuD/BMyZFdjebhuysWwCYmXexocDkpRq1b3c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OxAk0f4yE0A8wen+Tp/4TkXXy5GiCHeb8iBqOSHhCTSXMcHbXgP32w1LXtt8jRLFo1lA39NVJosMiVtoDUPT+zXg6ZicAcvSQryqLOEW/pftYEU5zBtQ61J7dSYu183gLdLatm0CeBtif25fxjFLLjFWh3Nx0tULi5F7qFeG/iQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rOj/fjbs; arc=fail smtp.client-ip=52.101.46.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rOj/fjbs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xUC41X5COVjFvsaRLONhAsAHlx5lFJm7d9FbKh4iUTr1mGo405ViNqcwWSMM87zHxPZQ5h9BXt7uoiNXgHGM0aqollBM/eNjBuSs7gyi3GsmyaKN3dr1GfpGz4NVYkmILYyEgaxmgWerAa+uRTUFnVlH1kJOP2doshV5rupWU6yf1BxURV8YOgmUsCjJZsjikyX8ieDX7gfuzqXmvagMMamy6xaOZW/E26C9kmiut21w2HDpBVrX7XvPLjE63NtJPanMcVkv2VAua+HNofs2NoO6RFs3ARBk9OFbZJbQBmk5UK9WTgZ+dal8Ij5ibRw13PejwWbF3k7iVDeTnFCAMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tVNcepLQ321DHoi/jVDIZUP3vP5rPYilhr/4lPETywU=;
 b=hzJL+wNwrnMsYAXV5HzPbjPmn2lNiDHdUTWcQ/SDut6iHTovGwmA0aiewLSZuFVSYwBaUjbLt5WkAhWoZLD6ozP2XSlsu/L8AlJQ0dbhbRs+GbNOYMtoRCtj10qP2UX/pdHktnmDk6qZvLIxUPxhmyrv3Yn9Jg7bqBqDWQqOSzdm9zXVXZ1LvU5ztZspLWt/At5eyTRMlmxm689+/K4omH9wm1NfcLWZN6sZXhIo8u88TtoF/DDNuE/sJhlOop4TAQiQbuif7lP3UB1QU/meSP+c9GvkFTa/WEM8qyAjgM833C+Vwl3+DeV/dsDf10OEgVh2hpwFmPtokiFVxcvv8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tVNcepLQ321DHoi/jVDIZUP3vP5rPYilhr/4lPETywU=;
 b=rOj/fjbskyEUKddXgiYO0DPEuVFdJLA0CKrdvGyNX00B/N2J/xSeGJl507S1Y/wAyrcs7Wuri1Kyi+Tx5AQQvmb+Bl5AoPZ1rgDUV0RS6X7PLWkt9iq6QBta4jkb+TKIpRjuwnN2R89MHX/+eyEr0sDoSRLz0iMdLVq+wEXMzt0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB7066.namprd12.prod.outlook.com (2603:10b6:a03:4ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 14:37:51 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 14:37:50 +0000
Message-ID: <13bc744f-6c1e-41cb-97a1-36177afcfb89@amd.com>
Date: Fri, 17 Apr 2026 09:37:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] KVM: SEV: Don't advertise support for unusable VM
 types
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Tycho Andersen <tycho@kernel.org>
References: <20260416232329.3408497-1-seanjc@google.com>
 <20260416232329.3408497-6-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260416232329.3408497-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0085.namprd04.prod.outlook.com
 (2603:10b6:610:74::30) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB7066:EE_
X-MS-Office365-Filtering-Correlation-Id: 98bc26e4-9a9b-42a6-8bc5-08de9c8ee688
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gKC+hZPor8Yxqu32eWnrg5xYvK5K0SFOWoPh+VVHRMATd8x0uihMdRw/vnXxulP4dIQ/LJTbL+k6LoyE9+TVod7RRyTTFSkJWAaHhP39bfqQN1hPZA3/av7Mm8Dvs9NQzMi57afYF/cOgUE124ks/tRwtTYQh6ibEbwcRBDB/dfo9+R6YWmxyymk5JjBevWOlSJ5fjIiN0P2S0N9AhWNVN3lBBxbFMEUqj0aITxwffw6xI20hBMwOV/qdXDchhfjBlOy/MwyH3vkpLQsxQhhsGphP2Mq2wG8sq28YKWfuL1IAt6gsN5i1tL+G0u2Xdnn+ZoZJ8xgZkjmLiO1EU68vUAG1kJQ1SmQYSzxf26kkbAGPXPV5cVBVV6G6AvIcUZVbMbNigdEoxYyzGwaW1rv5SEjJuXSCU0xXVvYB9GEu/XSFEONWp9cjoX9ZljtbqfNhBy94OCc/AgQFkH4R85zxr2S3CsFD9Pzv8p7FogOE4BsVDN7+8ftppkxny5xWcZkIGzEJC9TzPcJcAnY9soDwwtDvm6UAWHJbPldZjaU4+okiKeQk44WY0b4hgcJLiENLkFfnS8RpD8a017F+WyI0m3tsQStyBbvl/aIZGCUg+JVb8QzmLNFoA9MdH7gEi0JQVghj+4y2v+Jj0fenMn/uRcj2V4f6MwGEAB0Q8pTuEeNA+GmIA/92xYgjT71Tg+C
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2QzTzJHQnJTSEU3WnJPOWVuczhQbXgrMVFtOFgwSW5WaHlmemkwc2pvejAv?=
 =?utf-8?B?c25qQ012ekRoTW9RMHdLakQwb2duc1FYdy8wRHUwbGFkM05qVDNEaHZVM1pj?=
 =?utf-8?B?OUVTMDVxVm12YkZtUlB1K09yenRGQzUydnFYS3BEQ3Zodm1PSC9UemhKeTU0?=
 =?utf-8?B?WGJyTVdFandqaGtCbUx0TnBZeFlCV1p2eTRqZ1hqVEMyVU9uS1Y5dy90dFV2?=
 =?utf-8?B?TzJ5eDR6MHFzSlZ3MWs4MUpFRTluVjlIbFh4aUtoQTZaWElHeVBIRzFKWGdi?=
 =?utf-8?B?V00vMmJqbkhrV09tck5LRWE0QTJiN1dCcUJHRVdTcVd0UVJCbmdoaFpXWlYx?=
 =?utf-8?B?Q0JOUmlRQTBERkFOWTFnTGFMMXIxOENQVjhBOEVxK1VmTTJLNzRTaHg0Wkd1?=
 =?utf-8?B?d001QXlnbUdtV3hQM3dVSE5aYzFLdXJBTEgzVDV4aHFzWnE4Rjh3b0p3dEMw?=
 =?utf-8?B?ZTZ6MWdDaDhEekk0aVRQUmcyTm9tN09rSFVmQlJrZ29COC84U25DNThlRHZy?=
 =?utf-8?B?ZFVxMWg3TGhWQ3VtS2hMaG9RbXYxOHpSV3pERTgvZGlKOVhBL0d0bFJBYzlC?=
 =?utf-8?B?QlBiOFhySlc2RzB2K29uTUpyclRUcGs0b2x6YzZDMG5PSWgzM1RkRGRqUzl0?=
 =?utf-8?B?L2E4RTZ3OHhiaU1RaDJQOXp2eVRnRVFkUFkrNVAvdHc1SGVJYlZ3RTZMUkFp?=
 =?utf-8?B?RVFZeXVtdjJQYyswMkhkaTh4T0VOZi9LUWdSYlY3RmdPLzIySG1VbndJNFRN?=
 =?utf-8?B?dUN6ZWswU1dQeHY3WGcycGtCcE9CVVVRSmsvdmRMa0lTQ0JFQ2I5T1F1UkF6?=
 =?utf-8?B?NjBZcTZuckI0bHQ3SlI2ZUpEVGtla0RUMUFjaHQwTkhKMS9sazNLUndjOTh2?=
 =?utf-8?B?S0ZpMXBLdS9UV20zUHFQankwanRNNEFMSFBKby96dWFjbmtidDk2MVI1R1Yr?=
 =?utf-8?B?UmVTL3ZlTkFlTVl5b2UraG1iUW5tTmRUMnlvUU1wQlNvNy9vUmNNRFlpQ2ZT?=
 =?utf-8?B?ODIwS3ZMOWxKQ2R1RTh5cnBYYjNmN0FIVlplQ2x3UyszUnM3dk1ZOWFWRkRa?=
 =?utf-8?B?YjlGK3FReUw2MkdiOW92SVlBWElhbHUzc1VDVmIvVXhsM1I0YWphMGpEQnJZ?=
 =?utf-8?B?dE0xZzRDdTVxTUl6MzQ2MmNkcEUxWE4rNG9BRHpHaGZkaHgyME1yZmduNmph?=
 =?utf-8?B?SjhHajZyZ2ZkbEtlMnNqWW52bGRFalNWZXNRejRRMmV5UkozNGxKOVgvODhr?=
 =?utf-8?B?ME12SXltYmFMdnFTQTErdFk2Y3ZUQ0tBT3YxNHVBOG56NEF3akNNdWo3RElV?=
 =?utf-8?B?aXdsMkorNU8xWUlKSTFpdVZKUXdDNm1za1RiSE83ZXZKYk50WCtmSVRPOUZL?=
 =?utf-8?B?UmcvRE1RNGxZRHBOZEZlbkt4amQ0Tk56MWxNRldHWWROTlRkbWN6Sm11NjFv?=
 =?utf-8?B?UU03MG93QkJnSG11azkrWmVoQmE3MHVBenluT0RCR1dBcGVwbU5iRE1zRmNW?=
 =?utf-8?B?OGs2NVAxTkV4OG5rWUo0d1hYYWxoNnlQaGltb2dmaEd0cU5kOTJrcitsZEpu?=
 =?utf-8?B?bEdxRFNxK1ltc2ZBK0grVlIyRDJBNjhSUW81Z2YvVklya0R3UjRUbTVjcVZx?=
 =?utf-8?B?T29meDhGUloxM2lJSjkzelpIYVlKMVFwR0REcTJXcmcyaWF2ZEtRdFErWXhq?=
 =?utf-8?B?SkhnTVp3MytwR3E5dGIrNm5rbVYxSlNHK3EvRFQyV05LYVdxZDVFdUxhNk1i?=
 =?utf-8?B?NEoxak96MzB6WGdvUVIzQXlUaUxhSTEwU0RXRGhqRUxXOXE4ejZRREk2ZmE0?=
 =?utf-8?B?NWhpMzdpSXNYR1JkVE9uN0JDM0VnMjk1dG9BblI1S0RiQ0FleTdZd0FrOTBM?=
 =?utf-8?B?MktoOGVRMUFJdGpvdUwxdHNzRllYVGdqTHh2bmVnVjRmTzhpa0J2ekJ0NGtm?=
 =?utf-8?B?Q1JoYkZTaVFzYVJmZzFvMEl6Ui9reWVxaFVha2pwcThvUFg0M01oTDBOeHZM?=
 =?utf-8?B?bXI3RkEyYnAxVllFd3N6Vm8xUG9rUmZySmVOT0w2Z2UxUitkbXhBWGF5enY3?=
 =?utf-8?B?NHhZdEZEQWgwWXBZNUpwNVZTdWF4eWZSVUp4STQ0cVIwUnRFTVU0MXRNTWZs?=
 =?utf-8?B?R1VFMEg0R3FHWVRpais1Z21ZMWFVUld4OG4xR2lKTlhnbXJkRHRnY2Z5dVFi?=
 =?utf-8?B?WG9JSHFWMjc1TjZXb0JSdTl4NDR5c29TUE0vYXJaUDdNV3FlUEJRbXppcE8v?=
 =?utf-8?B?WkYvNE16aVk4TGIxMmNaTm1vRC9sRENkUGpxblVDUW1nYnRwTU5qRnhqdCt4?=
 =?utf-8?Q?HsTfDwgS0vbg0XWDcT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98bc26e4-9a9b-42a6-8bc5-08de9c8ee688
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 14:37:50.9170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7TM7dw7LwHAthFDTExlYx14P4BmrfqNEZjqNfl483EiMaOMp8TfQcQxSt1dRkUX/gJd3CNRjKa/VZbMQEM+fFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7066

On 4/16/26 18:23, Sean Christopherson wrote:
> Commit 0aa6b90ef9d7 ("KVM: SVM: Add support for allowing zero SEV ASIDs")
> made it possible to make it impossible to use SEV VMs by not allocating
> them any ASIDs.
> 
> Commit 6c7c620585c6 ("KVM: SEV: Add SEV-SNP CipherTextHiding support") did
> the same thing for SEV-ES.
> 
> Do not export KVM_X86_SEV(_ES)_VM as supported types if in either of these
> situations, so that userspace can use them to determine what is actually
> supported by the current kernel configuration.
> 
> Also move the buildup to a local variable so it is easier to add additional
> masking in future patches.
> 
> Link: https://lore.kernel.org/all/aZyLIWtffvEnmtYh@google.com/
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> [sean: land code in sev_hardware_setup()]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index dfeb660b8f5d..0971cf652b0b 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3062,6 +3062,7 @@ void __init sev_hardware_setup(void)
>  	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
> +	u32 vm_types = 0;
>  
>  	if (!sev_enabled || !npt_enabled || !nrips)
>  		goto out;
> @@ -3195,24 +3196,26 @@ void __init sev_hardware_setup(void)
>  		}
>  	}
>  
> -	if (sev_supported)
> -		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);
> -	if (sev_es_supported)
> -		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
> +	if (sev_supported && min_sev_asid <= max_sev_asid)
> +		vm_types |= BIT(KVM_X86_SEV_VM);
> +	if (sev_es_supported && min_sev_es_asid <= max_sev_es_asid)
> +		vm_types |= BIT(KVM_X86_SEV_ES_VM);
>  	if (sev_snp_supported)
> -		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
> +		vm_types |= BIT(KVM_X86_SNP_VM);
> +
> +	kvm_caps.supported_vm_types |= vm_types;
>  
>  	if (boot_cpu_has(X86_FEATURE_SEV))
>  		pr_info("SEV %s (ASIDs %u - %u)\n",
> -			sev_str_feature_state(sev_supported, min_sev_asid <= max_sev_asid),
> +			sev_str_feature_state(sev_supported, vm_types & BIT(KVM_X86_SEV_VM)),
>  			min_sev_asid, max_sev_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_ES))
>  		pr_info("SEV-ES %s (ASIDs %u - %u)\n",
> -			sev_str_feature_state(sev_es_supported, min_sev_es_asid <= max_sev_es_asid),
> +			sev_str_feature_state(sev_es_supported, vm_types & BIT(KVM_X86_SEV_ES_VM)),
>  			min_sev_es_asid, max_sev_es_asid);
>  	if (boot_cpu_has(X86_FEATURE_SEV_SNP))
>  		pr_info("SEV-SNP %s (ASIDs %u - %u)\n",
> -			sev_str_feature_state(sev_snp_supported, true),
> +			sev_str_feature_state(sev_snp_supported, vm_types & BIT(KVM_X86_SNP_VM)),
>  			min_snp_asid, max_snp_asid);
>  
>  	sev_enabled = sev_supported;

