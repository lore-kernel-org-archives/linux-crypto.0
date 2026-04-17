Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011004.outbound.protection.outlook.com [40.107.208.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8AA34751E;
	Fri, 17 Apr 2026 14:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776435851; cv=fail; b=GkrjtXTbUykDpJCoZ69qwLd0LFVe5CwW7LBfNp7XsHLy3OSglV1ZQMq2NkI0vOH2Y7ugAfKo/dBAaEOwK7RW6dQ3gcC5o2XfPWeP8yK8d7y1e/F+rEgxx8csfBSZOLO2Kvwql8nZGELQyLBsa0K6F2F1oO2PadqNAMk/TZYJL9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776435851; c=relaxed/simple;
	bh=ch03AtJ0IlB0va2eBdA9dUU54zyeRX3B+NykuPe4pBE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CUwcYMvp8GPAne5eolfWsV72Rcw/tVMQjfr7IStFYlYjojjrEwFOu9lw7xhggo/ik2z2BABMZMh35hGSJs7fpl5XOae/FIOkqaZ9fF+GCf20emK9VTh+hQoDlwP8LkDW+fPhuD3E771RR0KBMETUtuSjKXm4VG65ufvyAGgs5f8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2RHCbdoG; arc=fail smtp.client-ip=40.107.208.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2RHCbdoG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nljvgA16Kqo6JomVIImKwM3+fMk57C5EppYQI2+vRFtUjq3I7eKNapWVIhKpHjOpydlei4PIXlvoy7rYvD3eO/8imPpX8lTMH+LJDULwbgQ0tvyghGTMGvUg8pbKkQmHBTGtrglHueamlIShwhweNDvo3TGNtYbPry+3O9VwBAv+pvvuS/3KemOvPMwL7ROmqaa9gfQAV78a4J6MklQPgSpxZfSJh6S9PHp2GeQ0z6j9Rq8oEnb3iKCqi/Zu8G1xqW7A4ztRTczMAy1ulDgugpxhDiADQwWy7uQEgDOubeVcPFpcpl/lKeOIzGXWYzUGF8nsxV+SefY2UyXyIjTzDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i9ff4ud9AlT76pJHl6UJXvGYwEYTpQOcgnNZhByocho=;
 b=SyEgHmw3b8qDppM/aEWOcqrRu0V3pCFWliNrlhGCUEBFl2cpvcwYE4XoTgMNKuAs5FBACoxIg5iBzKAHJGRbeDCnX6C+0S8sWHxIJi3sKuIo9RebD62byjAAZykOefF0C9HiWj+VBbUglZpSnfG0M3g/LhThNjfVqsdV3DbsbPtp5+4cxHqBzm0xVpEYC1Qv3Obln5LT5em5HMbx+bX4qnkuHeGWdWQQhPdxyhkF86aQkde/l/Ii3PlcKC3YisL2hchmxI0W0K4ddqDbrp205PBHKnELr/GDz5+/DSrnx1+f0Pumwl7fsOhJoA0jK8MW6wGG8m6rt+phjjqAX8OzQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9ff4ud9AlT76pJHl6UJXvGYwEYTpQOcgnNZhByocho=;
 b=2RHCbdoGhwqIy/PdWC1fpG0v7DGCmhUbpC/1JMD1zgcYLS7cZWJXkOWF+74GuU+XNEU76i9lNla3I7MfV5OAi92ZAsXU8zuvKKKBQuYvF7ws0PeJHbkWuzotvNhHucvQ0srfdZ0IxEUtIkBfwIiz4jtyK0sPH8shnZTH+VfPvis=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS3PR12MB999216.namprd12.prod.outlook.com (2603:10b6:8:38d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 14:24:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 14:24:08 +0000
Message-ID: <0360e0c0-1680-4281-ae13-434a814ff02b@amd.com>
Date: Fri, 17 Apr 2026 09:24:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] KVM: SEV: Set supported SEV+ VM types during
 sev_hardware_setup()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Tycho Andersen <tycho@kernel.org>
References: <20260416232329.3408497-1-seanjc@google.com>
 <20260416232329.3408497-4-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260416232329.3408497-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR08CA0031.namprd08.prod.outlook.com
 (2603:10b6:4:60::20) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS3PR12MB999216:EE_
X-MS-Office365-Filtering-Correlation-Id: 88d1af34-9d62-4752-7f93-08de9c8cfc9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	JuFt9tMh/j78MtbxUpFXQlwQ4AK+OARY4Ol+HoODeAlxVPrOCi12bYFlvnGwTntshY8e6EQ8ldI4pXyEKAKs4bf1eTHFr2kCELR8aZsr4jjn13WPAFqws2jGVMek5K9AoYXFRh5FGIGYy6UFYfo1CTQrjaPvXdlp9O0I1tMuiYb2P7pGhFSVQHYpTgI6IDDRZ8atAYmsWUdt8PveotlbtAxcrS7Z9aLcJ+Y977XPreER8Yi3ZMSft1mGz/nJ9PAy9zVZptzXUk2EKMf7W+/H3jWoj6Ocy4Vm/sF/GbBwnx216pND2M8923zGSjPv1aCqs8/9qbK9aIUR2k8s36iQakfb4SYaAoZ0EqBu59VN6yJoMubgtgo0Q/LlFS9O8PVPjBGDZCFRH1LfBgAcS3IirWrGrJBZrqKo6G6a27xsFkDzV8wQqgYe5csl3GcZ6AVG5LmYM1CLaFA2k3IxIzg4mf23tVCvOM7XEcMfO9zZfP5qjR+QCcdWUCRGKq6Nl8oAUe8he9Tgngr78l/rlJmahgG7j9ZH/ntPxyrEBzGQAeaXDvX7SV46A43ZeXg1MWkwSSXSQXiciqOPKB+kKUGv23IBFcW9xEmoQ/LmN17nMx+iS+EwhgfzRi9gGXemwlOSA1iIt06ORAzhrqOukZP+1cYvPXYi5l2wIaqGLSN6AKQKREJVjtJ1B/8F1SIfLOr7mdr/pxwHp9Gj/UhfqiyEEZqKsPvom1bhPQiUz20l40E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkMxZ0ZCZFZUVmE3UW93TTEyMHhVdE41VVYwcXN6UEhvN1g0bFRtOSs1bjFW?=
 =?utf-8?B?aGpiQ1BFN2xuVmUrWm9ZRGFOdzdBbGwrZFFMaEgzQzl5RUMvYmhic1RSSVI0?=
 =?utf-8?B?RXNvVWkzUCs0Z0xaSTl1MmVGMWZjUXg4dHM3U1NodHNJUGxyVGNQTE55VndO?=
 =?utf-8?B?d3ppeEwrOUpqN1pVQ2gwWTVhQXBUcW92UnVVY1ZJbGI4dWtxRndSSU1uTU9k?=
 =?utf-8?B?TkFJb3RCWWYxNVJjb25obmNlMTdOdzZSYml6RDVnRGlQVzB2dkVJbndlcUJZ?=
 =?utf-8?B?cmJUV1J5Sld2ZFpqKzZ1NHQrUXJiQXA2clhXMS9EQnBvQkNhazA1a0FpaC9H?=
 =?utf-8?B?bnIzV2tTRWpiV0VQU05VNXhqRGFSN1FPRDFvN3FqYjRLdnVFNHo5RHFORllW?=
 =?utf-8?B?MnpYY0dGblF1cTVoaGNiUlpXeFZuOGEwLzNWaldUWHo0SmVIa3JLRStVdWxI?=
 =?utf-8?B?MEJXME96SGlZOWhma09hTUdocVB2RmNIYXVSK2hlV25iZzdnMTFuQmtaMDBF?=
 =?utf-8?B?WFpYN0kvRThCY0w0UW1GQW9vKzRTTHBKcDM1VjF5L1pRRmRnM1YrdkVRRU5U?=
 =?utf-8?B?eUJjd1VCMFEvaHBoVUNPcjdUeU1sT1lOUlUzSWNOUkxuY3dQUHRRVVdlcVBu?=
 =?utf-8?B?dXBpWkd5Z0xUQnVNdjEyRU4zbDNiSmpnMTdQZkV2NjY1Tk9ZN2gxcTNlVHpl?=
 =?utf-8?B?TkJLTFltRUdrUlB1NEYybjVuZkRSN1M4b2lIQmZqaEgxdTNoK2tsa05OWnlx?=
 =?utf-8?B?Y01JS1JVYUl0STZDNEVPM2tTZUhDR2FvU3dESWJ6aVRrZXVBQjhoeUhXcDNj?=
 =?utf-8?B?REUrMGh3NmJQL3J6WHBMazQzKzJOdUIwZ2xrZ3Job2VlVEJJQnNiY1ZGN2pr?=
 =?utf-8?B?Q2kzYUN2QTF6eVRUZlVGS291M3IvK3l6dFpGdTJlZ2hRN2VuNld3bzJ2SDZk?=
 =?utf-8?B?YldSVW1PSHR5MWZkM1laYnFXdmlrYmxTa0ZCbzR6Rk53bW5nR01rUW55ZHhF?=
 =?utf-8?B?eU5lbjZGblZsZ2Q1K1BCcGJMOTNCcXJMdzA1YzZ0Ky9VSFZJaEdxeW1Ed3M3?=
 =?utf-8?B?WHZuZzhvUDF6a3hBZWJJN1RzNkk4QWYxSXNkS1d4Z2tDSkc2R3VlWm9hWXNv?=
 =?utf-8?B?VHgxeHY4YWl1Q0d0KzMzMmROenpQSW9YTkpsYWVXMURjaEdrOWNXMjErcEZS?=
 =?utf-8?B?L3k3NlVLSkZCbzRQVzBNd1Y5eFdXb3Zyb3Yyby9ZcXJMazBwcCtIN0FkZE9W?=
 =?utf-8?B?YndIWmdhd2EvY3o5TUJkcHdQTGRVNXE1bTFnVnlvb0hSemVnQUNrSzFHaGZV?=
 =?utf-8?B?OGI1SlkvSGJxN3VaaDdVU0wyV0Z2eEFmNEpQM3NzZ01vQnFVekpBc2h2bEdR?=
 =?utf-8?B?blVta2g5TG05SWJhT1hNOUN5UzdlSlk2Ykg2Q3dQRGl6K2dwdW1UTzBERkM3?=
 =?utf-8?B?aHFlaUxjcDdHZ1l0Vk13dXZjNHIyVHdlN0lqYWJrM1VVemVHd2lWSXRtVy9E?=
 =?utf-8?B?c2J2ZXROd2phSlk5UzAxWFhZdlB4c0xxWEpPNGtDUENtTU9qRmx3ejJhVkdY?=
 =?utf-8?B?WGhCNTVMNlZ5THRtaGFPR25Rc0pjZ1pURzZxTjkvUi9xQlFIajJGSE5DenpT?=
 =?utf-8?B?MEtuRnpxRGRvNmprZ0plRjdVVitabmF5MlBJb0RGai9yOGVoczd0bUV6MkVy?=
 =?utf-8?B?VjJvTXNzRFNnZGc5VUZYYzBmbElKc3VHejY0OEJFTGNNMjN5RUlEbjdTS3pi?=
 =?utf-8?B?ZXVJbUhpVmNNKzdxYkJDTWhuN1JQc1ZRd0dZSUZPMlFTN1B4NUo0RXdGWVZl?=
 =?utf-8?B?cW5MN2lTZ2RNY2kyZXhWUUpSb2dSN3dXNUF3aEQvd01Jb1JaamtZNXZIUktn?=
 =?utf-8?B?RlpVZHNudnl6ZGk2QVJDRG5iNzVtUW9JOVg0bStNV3NlbnJGMFdUUGRUTDJR?=
 =?utf-8?B?aU9hQjlIVHRha3BEb1ZBYmdYUDR6WW1wZmlrSWl0SXFoY3VGNXd3b1haRllx?=
 =?utf-8?B?R0gxWkxzNjA0aFRtOC9jWGV1dGJZYkhFb1VIWUNyc2hjYUxPNHVTVHJSOW5j?=
 =?utf-8?B?QnZta21sMkF5YkNRd1IxL2EvUmRIQ2pESXpUMGxNTkFFMFJrd0plV1F3eVEz?=
 =?utf-8?B?SHFwa3hOQ1FROTFTVGJqTzl3VnpXb05yamwxOTJNRWZIYzg1cTF1and6ZGpq?=
 =?utf-8?B?UDVYNGo3emJ5U3NWQWtuaVJ0ZlhyU1JYc1FodVAvWjU3MW5nK0p1dFB5c3JX?=
 =?utf-8?B?K25vUTFTc1VWQmVwbTBIRkQ3eU1jTXhxdTFJa0thN0xNb0ErYVVkN2JCWFdv?=
 =?utf-8?Q?HZmDe7+OsckFkBqYYG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88d1af34-9d62-4752-7f93-08de9c8cfc9a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 14:24:08.2152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uvv3iKc4C8bEFZqetdla8Smg2meBxe2QmMS72/jM/i88Gbir1u6b50td/p50ehb1SvCwLZ+1uRuNIuuc7jvapQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999216

On 4/16/26 18:23, Sean Christopherson wrote:
> Set the supported SEV+ VM types during sev_hardware_setup() instead of
> waiting until sev_set_cpu_caps().  This will using the set of *fully*
> supported VM types to print the enabled/unusable/disabled messaged.
> 
> For all intents and purposes, no functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c2126b3c3072..ea4ce371d5f3 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3013,18 +3013,14 @@ void sev_vm_destroy(struct kvm *kvm)
>  
>  void __init sev_set_cpu_caps(void)
>  {
> -	if (sev_enabled) {
> +	if (sev_enabled)
>  		kvm_cpu_cap_set(X86_FEATURE_SEV);
> -		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);
> -	}
> -	if (sev_es_enabled) {
> +
> +	if (sev_es_enabled)
>  		kvm_cpu_cap_set(X86_FEATURE_SEV_ES);
> -		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
> -	}
> -	if (sev_snp_enabled) {
> +
> +	if (sev_snp_enabled)
>  		kvm_cpu_cap_set(X86_FEATURE_SEV_SNP);
> -		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
> -	}
>  }
>  
>  static bool is_sev_snp_initialized(void)
> @@ -3194,6 +3190,13 @@ void __init sev_hardware_setup(void)
>  		}
>  	}
>  
> +	if (sev_supported)
> +		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_VM);
> +	if (sev_es_supported)
> +		kvm_caps.supported_vm_types |= BIT(KVM_X86_SEV_ES_VM);
> +	if (sev_snp_supported)
> +		kvm_caps.supported_vm_types |= BIT(KVM_X86_SNP_VM);
> +
>  	if (boot_cpu_has(X86_FEATURE_SEV))
>  		pr_info("SEV %s (ASIDs %u - %u)\n",
>  			sev_supported ? min_sev_asid <= max_sev_asid ? "enabled" :

