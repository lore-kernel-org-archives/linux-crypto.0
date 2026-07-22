Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010001.outbound.protection.outlook.com [52.101.193.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C0D411F91;
	Wed, 22 Jul 2026 19:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747834; cv=fail; b=VCnyNOxWZv+VG9Gto6YnlVb1XQ2XrFBLetVgmMawRBvQTRIDRq4su6sVLJf4ojt624HQyHYfcON0/3xTrhyctrGaPXG0qZyZYXWs4oxf0uTfYWkq44Xm8G4efV/WTTLAuwnLKVWizm2+/eAuP/SUp28eI+7xI7MotvaBa/DG27Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747834; c=relaxed/simple;
	bh=iNjXVZGlHTzZHPZURhBM49ZvHbngryWZxgQf5yU7ljo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lECcQkA3lVlqedasflNDEVhJUbvApDL1qXGY+aSheaA4hrWGXgA1+aKHG2NDpgOXZ49v01218rfXuuR79LCm5nRvzyYIjXHmvp7PhMP/k0h4DWrRrJREnXjGO+VH/PVqS645aBfhBVcKu3t7AL2LjVA7nhTgFP9A/cVsMaT5d+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Dh3DVPLN; arc=fail smtp.client-ip=52.101.193.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Dh3DVPLN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhHLbvnoa8OjPAOEXEJloUkhQn6vOQVWSX8ow3Iaavx4r7duxsJU+9MFtd2gddGo2DL/tU5g/6jCW3vQ396ImpAHHozu6xYpcsZz8D/lruUtsr3l6k6/tQLVuVa0Bk//Uh/Y6mx4GRwYK9EleHrOF1M3iD8JxoX+v0OfcBTVPFg8++Qu4F7DqsmEJ9yOxyMCUCwh4D7mkM5R9FSFNr8Rdqn0q2HgmAZh3wuOMfpSBmJZQBDhchVJ5Z/oGDeXU6gAjqVxIwQGkylYgMFXAQZ3EeTs50ez6c9oPEoNbDBYRAGqPhAdJimruElVSMG6/mOserzZECWui9O3zpXr+vUOZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuyZ7OBcROpnxChlwCAV5USQpISsD8nvKjczla9lNLQ=;
 b=feeF5AKHmJEDvkA726nsAqv1MW4onnjmWk+CKU9KH+cwrY7OASj+jTc4UjKIrjC9168VhYimWUcajT0lKzRpzwZ/JJjSW6u3XI4M7ATAk7KVRxjkc9M5jmB3kAtNdT8yDd+5qe+iOG1NZxw4KMmckgfeGjHx5S4vqsMi8PHyin+HMYJjw2AsoAYamw2AtraxgU6OCePMpPThh8SwZVR/FuZC7jD34JAR+4iorH6tdktTbVKM6bGcEztRIQvI6pIS2GcZvR3xqDVAdYhCbCWYwOJ+IUHY7W0stioivM87xhW3yrc14B6CEmM82zU9o8tIIH/77j6+FDur4p8NGxhIJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuyZ7OBcROpnxChlwCAV5USQpISsD8nvKjczla9lNLQ=;
 b=Dh3DVPLNz89m5qVH3AWz/g1+J5Tx2GJxGO7SaCmQ41MpFT5ScL9Cyesn48z6jt9Z9TE7VZTBcgiPaO9BPlnBXqTCF+znF9HaS0r3bxppMtR/usccpLTP5cl4of38M/JBfXPAjk2qCntRMX8g4FFpLK714mn8ubUhmHk43HJguxY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BY1PR12MB8446.namprd12.prod.outlook.com (2603:10b6:a03:52d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 19:17:07 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%7]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 19:17:07 +0000
Message-ID: <1c204da7-1129-4c11-965f-8e623a49170e@amd.com>
Date: Wed, 22 Jul 2026 14:17:03 -0500
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
 <509ac5f1-d05d-4c95-8e61-f0d4b04bbb92@amd.com>
 <f2a4753a-d7fe-448b-973e-025563ae8a74@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <f2a4753a-d7fe-448b-973e-025563ae8a74@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0430.namprd03.prod.outlook.com
 (2603:10b6:610:10e::15) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BY1PR12MB8446:EE_
X-MS-Office365-Filtering-Correlation-Id: 24a46177-dd5c-4520-b9cf-08dee825d1fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|56012099006|11063799006|5023799004|10067099003|4143699003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	VrPecg4aYgwQrzdZ/6k8R73mk3zRChcUCQfzlrLZBf/vkY9ReUg9wm60b1c/KCyzDysZ7BrNP4bTMMOW2SNaa/xAUZkCyJe1l6sRTjqdJoL3xnTQuEIZQ8iY120pTm3KFlHSDRTYmsFt9zRGplawQ0uZklujw+DTZQh6qDLCM8UKV7v9rgfJq4W5gOxG/702yPbhA088/BshvbsN1NiPIBnVD/EcuE3NEgXWE/lYZrizPxJxj1eXOqilJQC0Vs0HNLPqpLr9mEXMPORjr9DMoeAXuWGd/c82Zb1o7D4SYgw14Vym5PHxsGtZgHyTHjkAqEzn1/DBLn8pErnglBZ+7U4Oc0mVzKmWh4tSf/6UCljWrYf8QVu3FwDcW4xUKDg6Skh3+ltBfe3RiviI2Fk5QYn3+lOgJN+V/TUU4eidqGdrfIojuK5TXUY62RbG/c4ltcKg4xG18zLMSYKW5GyS2CS2vyMda3VkLCx/fRO/7DHfGIgc7sUIPx4UkPK9pB/E3FnX9iR2YHsiDFrGH1YPP3sfcNCbpLWHcLJHjD127J8djedhq7WbNUGoz6BDiqOgxXb2+EeBZgA5cZn5hYGleD0Xy11k+v3mCmnMgYO8JCZwChjB6TLGMHv3pHLyoOgubTH6nNO88FCJFyNjJnw67ud7znhMmqPBPQq3DQ6awTg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(56012099006)(11063799006)(5023799004)(10067099003)(4143699003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0lzRjVrdW1BUllMcFlObyszUVFnOW1oeWdWTWxuSldmNGh5NzBveXl1cmk1?=
 =?utf-8?B?QnZQTU11Y0VDTml3ZWlhQXJrYUtIR3EvMks0WmxqWGRNclB5bjVEQ0orMmZG?=
 =?utf-8?B?V2tJU2puUktJd0s3TGFtMFNnTU9YQnpON0lqamVtNGpXNURnbHJ3MllYdVZw?=
 =?utf-8?B?L1o5R0VBUFJQM2VZd2xVM0RCaTRSYjFvZDFlem5IR0swbm1jb2VSK1JMeFVl?=
 =?utf-8?B?UzZRdmREb3B1aVdsd09CSWlydVE5aGNtcXJ2bnNJU1ZJT1RrVUNOQXdOZ3k3?=
 =?utf-8?B?N3FvVldqRWkyczRINzhaUGxsSGJ2bUlvS0d6eTM3dDBpWVdQMHZkYWxWMkVo?=
 =?utf-8?B?cGw5SEZQejZLNERFcUczblZkMERoaUdOYzZJK2tmRmdqOVY1d1Ivck5tUm1u?=
 =?utf-8?B?MURxTDZ5cGw1N2NTY2tkaUljcWcxb0xPUTlnaFFEeGVaSEQ2OTVac2pqcTJZ?=
 =?utf-8?B?TVljYVZNVU5DclZnT0FFK1pZcC9kNXE2dkRVVHNHaWpqQ3hCOGNjdHFubW1M?=
 =?utf-8?B?bVJlMTRoaDB5YzlQQmhOU3VoTFJDNEhvZUhMYmlYL043U3BqZTU3dW00N3dm?=
 =?utf-8?B?MGh6cXBWclhoNmI0UDFrRCt2Y3krcitHT2RHeFV4b21IRFdpeFRNVm9iZ2Nm?=
 =?utf-8?B?cWQvMHA2SWJ0STNVK0FqbmVyQXcvZnBaK3VSOHpuaWYvSW04UXE2Sm93M3Zx?=
 =?utf-8?B?d0cwRVNURy9xNEhqNU1HZTRVeGVyL3VLbWNpd1pnVmN6NTE2RGh3YVY3ZWtt?=
 =?utf-8?B?dTMrQWVMSFZlb3FRckZlZVNCV2ZvN0lpQXc4M3FxK1A1OUlvTVpaci9KR2Z2?=
 =?utf-8?B?cElsK3g1TlRyeUIvdTBmVUlwZWovRGpIUkpkMzd4bW52L3RZM21aUUNqRkZ6?=
 =?utf-8?B?OXhzYkZxRHd1QVF1elVHdkx2d0xIeHNBVCsvUWQ1aDhZSm9jQkJJckI5UDBy?=
 =?utf-8?B?SXRFOVJPbFYzaytMTzIrNGtMV0JLeUhhSXlqbXk5NitFUXhmNVovZWM3bi9j?=
 =?utf-8?B?MjRKNXhWNHZyRGZSTFBaVGVuR3hvcklrZHAyV28zaWcyRXNwdWxwYlBTRHMr?=
 =?utf-8?B?M1RBbGdGNHl0SE84Q2NqVytCbWdSYk5xYXN6K0JpKzBoNnJEOW55R3lRMjZk?=
 =?utf-8?B?eVhGMkF0TGNEWlFydlV4a0dKMjM3ZUkzc0p3c2NoUVpJMnJsSFFwZlg4dDdO?=
 =?utf-8?B?VmJjSk9BcVdTY2twc21EYm5IRStSUnhNM1dVb3k3K3FqS09YdkljeXMxeUFZ?=
 =?utf-8?B?VkhFZlBZdzRaa2VleldObDd1N3gzNE56ejJLVVpjOGo0VExNeDVWNkVZcmZC?=
 =?utf-8?B?dk80a3V6d2o4SXdtMXlTZit4WVVVVEE3bk02ZjhGaG5CVFJDMzFJOWhGdGtW?=
 =?utf-8?B?UmxyMUk2YlNZaFdjMnh5bHRwUStJM2ozR2NDUnA3S1dMbkw5RlJtbGNIUXdr?=
 =?utf-8?B?VGhPUEZTRzVvbnVCRnpyNWNOTmpZazVkVHE5K2tqZUpLKzdZOXNOU2dMcU1T?=
 =?utf-8?B?WUQ4MVU5NlAveGJPMXJqeTAyQ1RYQlkvcHZlYmlUQzdDNmlNR2puR0l6RTRl?=
 =?utf-8?B?cUpMejNOV1lOZ1BuSTRPSkhVTTdIUExJd0NsaFZwUHJIQXo1cU02MjJCenhG?=
 =?utf-8?B?WFprSzRXUStoYjhCMjJkeC9NN0s4bnZsbmxKWDhUOHpzY0Vhd3VSU2E2ZE4y?=
 =?utf-8?B?TzJiK1NiTk8zM1NTM3AvblAyRDFQbW5LSlIxTjd4QzJTc1FmcE5ieEtaOU9P?=
 =?utf-8?B?c2RwenpmSlJFTm94azl2N05QRzBNcThBSzZTdEMySk8yMXNnanFHcjV5NHFU?=
 =?utf-8?B?V3RmOXF5T1BPT2pCK3lDQ3RRajJLWVVNd3o5eU5FbWZnRXVBbjFuanovaXhj?=
 =?utf-8?B?TkhHQVNBekdzcEtSUktxOW5Na2l2VUM1UWFma0VCY0l6Z1RabDZBb0hjbkdh?=
 =?utf-8?B?amFkZnZxSTlOSWYrWkhuQzBuYWZWbERMb0dtTTRMNHZFRnZQYTlGY2xjSG9J?=
 =?utf-8?B?SXF1S0h2SlNpa3krQUJoV1B4bjZ2L3RzdWRVQ2J3S0dPU3pUUUZMd01oUlMv?=
 =?utf-8?B?Q0NzYUdBd01ZcE9LcGZnR0lobVl0VGtGYXp1Q2Y5OUxmendxZEZBTnZDR2c1?=
 =?utf-8?B?MlJzUnZYODhzTUl3RzBpUlNiRzBVRHFDelFwSFo5azlLY1F0M0NCdjZFbnRZ?=
 =?utf-8?B?OHhUREtiOGJnVmJMTXNiYjlQWFNBWEFwNlkyUWtyUlViV0poYVdmTE5Xem1k?=
 =?utf-8?B?VDhScFRwNUNpdEYvTVJPY01OQTVDMWJ1bDBYdUZKT3NZdm5vMEJIRmt1MUdO?=
 =?utf-8?Q?E1J60VExn7wbBwkQw/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a46177-dd5c-4520-b9cf-08dee825d1fd
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 19:17:07.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIPZ/pYCBEFiB6y5C8B00Ir5OGXnPQ3v7Yt86vPNArzaxcmfeKXpOT99zJ/JQTzH8K+1lJmox5tV16d0rVhCJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR12MB8446



On 7/21/2026 9:46 PM, K Prateek Nayak wrote:
> Hello Ashish,
> 
> On 7/22/2026 2:16 AM, Kalra, Ashish wrote:
>> The one I'd keep is (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED). It's a runtime config bit, not the CPUID feature:
>> setup_rmptable() allocates rmp_segment_table and keeps CC_ATTR_HOST_SEV_SNP set for both segmented and contiguous RMP, so
>> the MSR bit is the only thing that distinguishes them — and RMPOPT needs a segmented RMP.
>>
>> Clearing X86_FEATURE_RMPOPT in snp_rmptable_init() won't work on its own as i mentioned in this reply earlier: it runs at
>> rootfs_initcall, after alternative_instructions(), so cpu_feature_enabled() keeps returning true off the already-patched
>> static_cpu_has().
> 
> My bad! I actually meant in snp_probe_rmptable_info() during
> bsp_determine_snp(). Something like:
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 8bcdce98f6dc..3ad53ef16c2f 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -684,10 +684,12 @@ bool snp_probe_rmptable_info(void)
>  	if (cpu_feature_enabled(X86_FEATURE_SEGMENTED_RMP))
>  		rdmsrq(MSR_AMD64_RMP_CFG, rmp_cfg);
>  
> -	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)
> +	if (rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED) {
>  		return probe_segmented_rmptable_info();
> -	else
> +	} else {
> +		setup_clear_cpu_cap(X86_FEATURE_RMPOPT);
>  		return probe_contiguous_rmptable_info();
> +	}
>  }
>  
>  /*
> ---
> 
> Based on a quick look, it gets only called at bsp init and is early
> enough to allow patching alternatives and I don't see anything writing
> to MSR_AMD64_RMP_CFG.
> 
> Thoughts?
> 

Ah, that works — thanks.

With the contiguous case cleared early, X86_FEATURE_RMPOPT set now implies a segmented RMP, so the MSR-bit test drops out and the helper becomes:

  static bool rmpopt_capable(void)
  {
        return cpu_feature_enabled(X86_FEATURE_RMPOPT) &&
               cc_platform_has(CC_ATTR_HOST_SEV_SNP);
  }

I'll keep cc_platform_has(CC_ATTR_HOST_SEV_SNP) for the late failures the early clear can't cover: setup_segmented_rmptable() can still
fail in snp_rmptable_init() (rootfs_initcall, i.e. post-alternatives, where clearing the feature bit wouldn't stick) — and on that path
iommu_snp_enable() clears CC_ATTR_HOST_SEV_SNP, so the helper returns false. Same term also covers SNP being disabled at runtime.

Thanks,
Ashish
