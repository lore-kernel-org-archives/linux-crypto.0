Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010001.outbound.protection.outlook.com [52.101.85.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D773E480354;
	Mon,  2 Mar 2026 20:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772483244; cv=fail; b=Rg5D4A3XhphFdKUH2prUeTu6pWzjzTxr8PamooQf9dd8wGOrcEFcaRm7LNzUYJFQUGrHcd6pj1occ+hFW6jaUz4f6AhhUzdAENtHqgwLSBPJxAaf6B35nIK/7q2H2n8qD2byaVdnw5D3mu4atq7WMFQib0T+zNY3L4e2KOTSLuo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772483244; c=relaxed/simple;
	bh=7cLk/l1mtQNbOwROEf1qqhmUW6J7xO71mb2by37Wb3M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XrQkQe3VGfKpNxzfFhFaL4zNyHxmhRuAikP5IDPyPdR73Phc9uxsWKaDYGGKeG6d7rzj+nVSWapBBufzBIehCYajIZ73lIJD/kP3wkxo6/acWn42CoTHxviEZzQPsoKEwYIswPjX+uAVzbKIbRhMGbDSOmVNkiDFxVFkDTanZrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RA0s0P2W; arc=fail smtp.client-ip=52.101.85.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RA0s0P2W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IHrS+ktMEj8aibdpR+rgQ2x+UZoi6oYNPEGNeb1xPE2qU/u5P2rk297WjKNlWU02bHiY5kzjL31pFBJ92LRA+vKn4BOqkWpjUQIMAZo7qgYi8eYQ5QRxrrpZQCNrSzvHH0HrN6gDsWoZnOtP5ekmcniTV3PyKPHTLWUzP2YqKMSl7NnxK1ip3LcJvjp2RxX3kY5/ZCc4rslKRTB28ELUHIMNuDPn5KD3Pa3UX3sWO1i95saZ+9fmWDRO+YCys6kYNMKXcE5UmFW43qOOa5hSj8t73jacPTBsurF5uyVia9g40M0uYMOehz2HeYcBxodgCUJzu5/RdFUxB3urzJ5QLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1v5Wi0WLhf3qdj+659KJOWtkfNsmizAc04RPR68Pvc=;
 b=tTEl9mtQqWXUsMZK3AV0tNm+YfAp3eEPLaYhw4t8jiwg+NLUDvtfwBXQn0EtJ59cw52mGAZ1raibD0d8Y5a+nNgfVaQ1uz/Zq5vWbU8Uzfl5MXiLhjOTqLgxFgZh3zl5YRUxpx71w7hYsksOpWTSPT+S66eEd1pQvf0oNN4n2NfIL32I05TetW/EJ12eUjdF+/h4Op7dHsHfsy9uXpMj6m+6xDX1ih6JKb2YpC3gpEq0JYJr1j4Z+uJ7m19cF0q1nMHx9r4JqNa70TPPvmYsiuex0siLXFEc1g4afgIiedLD+OjMkbzjMo92TLvlhUXXVZMRDZUBf4lbzn3XwuK7mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1v5Wi0WLhf3qdj+659KJOWtkfNsmizAc04RPR68Pvc=;
 b=RA0s0P2WF35mTsvhBQmOsQncmay3sK22PMHPUb4JmXlMGDIDWhGoiTKMKsxBOwL/7wZEZHzwU2GomY6jHElD41yF52hHCybyUrnUSDDaXP+2K0EtM4dVsubYmE3Rf4b9Pq6WXXiokedU7dKPlCpR8S4kI3txgcVWMUpUmWU2fJw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 20:27:19 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 20:27:19 +0000
Message-ID: <ba1106c5-e5b7-49fc-b343-aa1bf0b376fd@amd.com>
Date: Mon, 2 Mar 2026 14:27:07 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] x86/snp, crypto: move HSAVE_PA setup to arch/
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
 Alexey Kardashevskiy <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Kim Phillips <kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260302191334.937981-1-tycho@kernel.org>
 <20260302191334.937981-8-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260302191334.937981-8-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::10) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB9194:EE_
X-MS-Office365-Filtering-Correlation-Id: 06a0dd05-f1cb-49d3-3b74-08de789a1a21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	sLy4aZcRImBNdkXKu7w+pdW3H51bq23KCpihpjLaU+ZSuy7F2Kv+ekGZr/ATSNtBMu6zyhs6+x7OXp3rewRQE9arni2cXagiqtuc5s6j1RSq9smMe3imljALb74kh7BTMd0WYfOBysogoU7RIJLwQVWwDdPcfGVB1Ia0M0OB/cGYw77Bz8IHMUyYmFaWtoYsRRWfsoGU5O3+qfojXNW4WDGvfs/kCbeaM/7msfFJK3ezpB3NBeulv58DM3bpdrbvczhiVdTkPvqIaR9jvyN8aLMf3xQDGdw79MVIqWsw4FP87T2hqlqxaDNe7f92kAFmC8L4pue+DNlscIy4o4aNmd+5Cd7L6BhnR6TJusUAqS7BE96VzdL0M7W9Aq8ffYL7c3eQYbQUe/OU7KopHCMWONe1mneJFJIxOA/zCuCoawlhfiv5MhlBXjoH6m8kh7KQM7jfpFaTAzO8RKYR1nUkX7KN5U0GwfgspXGUCymiyCr4H8bem6tLtczK1CCUKwM5fDDr9+2BodkJHV9bVGmPRbKmGRKO9vgnPIns72+yypsPzMOMLov+DuOsJn8efJE3AylDjcuVbCDoRpKUi3ISUcANlkAxXWzWic+akoyfSyOWOJtJl8dFhgreOy5eCUJfqmkUndEIG6FC2mmlsPQNZt78iODEB5LVe5h75kCyInsTUJrFt2dRAC9Y3KPtYLE+tJ3jdcRDybUWXY1L82QnoeYDZi14hwGEG//danN0tcaUUEPt2++NmS3uhiN6kRxA15xJSplkGw7N0pRDln4MYQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzZ3UjMrL2drK3ZkZHZjc3RXVUs2VGFCK0JJMlgzanRxbmtnT3pXYXhxcldp?=
 =?utf-8?B?dzgzdk1mYnBIU1hRamNsTjdOK3lXaW9ZK1k5UmFCK2dFVlRBUmdjY1ovMGx5?=
 =?utf-8?B?UEFCcTA4SVF2YXJzR0JVOXFkb0s5QnIzL0hjQy9OWFk0Yk43aGRZSVZXOGZN?=
 =?utf-8?B?RCtpOExoREVhZWE4ZjBtWUFzMXlGQnRUOEZ4cVlzdzk0THhGTUlyUmQ3ODNu?=
 =?utf-8?B?NFhiNzJWL08zVEZzZlk0d21zN3V2TTYxb1BsYzZ5TlBseDJ6K0VzL3ZnMFRD?=
 =?utf-8?B?b2pENDNlQmFGQ09iellyY1F0SmwvYVhlTHZnMHJKRXorV29RNGI2R01nNmxH?=
 =?utf-8?B?VVFXNDJMNHM2MHVrMTMxSS9Ybkd1b0Z5dTZJT2JnTGFqNDd1Rk83ZFFVL0F3?=
 =?utf-8?B?V2tsaXpMa0pCR3pLbFRrdG4wTFU0aGsveGNVYmROUTZtWTMwYXlXdnRDMHox?=
 =?utf-8?B?OU5mOFlnOW42ZFdqTW1QYUdxVlRZdENaODNTdFQzUW5sZ3RRNkdiWVJhdDkr?=
 =?utf-8?B?cXdCVjVDckR4cDNDVEFLNlpvYlBES1A0elBYaVBNM3J6Z0xUdC9aaU5nMjl4?=
 =?utf-8?B?eHhmZTlYVHdMZm8wL1poMW5rK2hwRTF3REdjRVNuMlAyL3VyY1RKWVdtRFZ4?=
 =?utf-8?B?cmNtbFZZRlpmc0QzZTlQTFFtbkgyYWljaWRHYmk0N1hlK2MxRE1PRW9GN3ZB?=
 =?utf-8?B?OWNPZVYwaVZWTHk2Um5Zd0d6OGZrYkM3UVZqSXB0cHZQWXZGWUxXbkE4VUxr?=
 =?utf-8?B?Q3hLY3V6R245RUluajRtRGZCZmgvVW5LTXczbmVmdjlGSmRrMTR5bmZZdlRJ?=
 =?utf-8?B?WENPazVXMDF3WlFPbnBackh2aCtjVC9tTldIOGF2ZlQ2QUhNSEN3Y0lhNEl1?=
 =?utf-8?B?TktnV3NQV1FrWTdTbDZXckJtcEpMb2hUYU12SllaZnNpK0hKVXZqenpsc1FO?=
 =?utf-8?B?YUxhQmNtckFic3lCOC9kTFRyMXFsZHhGdXAzTWc5RUVTWWRsdUk4TnBPNFpj?=
 =?utf-8?B?ZGJRT2VDVlNlbDBTN2wxVkJEb0U4UHIxNmNLUFJCQWJIUndJdmgycmh0blNi?=
 =?utf-8?B?OVdKQXpXQlZBUkxRbWFoSXFqMUFFSEJpTkVFUGg3WGRDU2NoMDMvMXAwMHZl?=
 =?utf-8?B?VW9ueGxsV1dWcHZJNzBwWkF1TlRqOHl3Qms0eDBZS3ZrYk5PaVlxc09id3Yr?=
 =?utf-8?B?T1V2b28wdE8wblBOMzZqa2hSVEliZHZYMjEvRkxPbnBFRWEvd01Kc3o4c0J3?=
 =?utf-8?B?VGUwVGZGa3NqUkI3a3N0MDNnaG5OQmNvaFIrYXg4aWZXZ1JhZGUvd2Nqalo1?=
 =?utf-8?B?YmowWXJUMDlhM2xoS3hYRzc0R3k1cE94MzZ0VUViaHpVeFUvNzcxaS9aT1JF?=
 =?utf-8?B?MkdaMjhkK2tQZDB2QjI1cEo1NVdGNUMyZHVMNXkvZDk0TGM3elhZOVpLcTRT?=
 =?utf-8?B?cUJqMlY0Nld0QTlGNk9yemc4M2JWcFZBcHVXbVFUN2JFaUhTU3VEaFlXUVVC?=
 =?utf-8?B?T3pOMUNjT092dFdHZkR5cUlONmJORmFmTGxHaG1NNHh3ZWkrR2FqelZpcm1G?=
 =?utf-8?B?MVlCcS80dDYxRWtGTVR1TExmN3VseTc2WkNRYkJRdER4RE92cDlmNGE3Uzhu?=
 =?utf-8?B?WlM5cHhmV3RESVBSMHlRTEhnS1RJWnNNc3FSQWREdDlVdGRIbENIVWF3Zi9u?=
 =?utf-8?B?MzZxM3FVOU5wbjB6b0czY01SVXdpd2k4MUdWNTB5bWNKWDlTV0RwK09pN3ha?=
 =?utf-8?B?U1cyUXBXZ0V0NDRadms0RGFDWUQrZkVkZkI2T1d5YXBtMWlPczNnd0ZNUzNs?=
 =?utf-8?B?eGFGZitTVy8wZUZaZVpLYmQwWWt6WUhaNHhSN3BXdE9iM0pjOE1uYTloeUR3?=
 =?utf-8?B?cERlNjVocTV4NUprUW4zbjFoenNYYkVCOXVuWVNWL0ExdENUV2Z4RjR4bVY0?=
 =?utf-8?B?elBFVjFYRmNPWm5iQlp2UFdmVlNQdnd0ell3Yjdpa3F6TFNqb2hMTUhSMWRJ?=
 =?utf-8?B?NHRvbmVTS09pdTZyUC9TSk13U09FYzlNMFRicFhQd1FWdkhTLytHTWpyRjVo?=
 =?utf-8?B?NXl2OG9pRHNYL0lucWdLSElsTXdSMWtnQXRpZE51UklUcGN5Z2xqdVVNNG1Z?=
 =?utf-8?B?UUdtM0xyRXF5N1JnS0VEZHg0SkQwVDVVc0dQengvQm1SV3crTzdMU2VZc1Rq?=
 =?utf-8?B?MkQ1SmczQjdyV0pNL1RPNVlCM3hhSU1lSXo5QXVFNkZqSlM2bUVFL2dkU29C?=
 =?utf-8?B?dk43UEY2ejVSN2Zsc01veDRRQk45SnNDWlVKcU5nQ1hvOHlsd2hFYTZaRmVH?=
 =?utf-8?B?TU02Wk9VUVFGZm5QaklrQnNiVmtPVE53QnpRQy9qVzlVcm80MnJEUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06a0dd05-f1cb-49d3-3b74-08de789a1a21
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 20:27:19.3136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0377suY/+Phnzn0/SXajKPOFUIqYUAqlrVqxTZgBnrJ5n4VYeMvuhyY6gcbT7jKr/uPDYamDUsQfRghLWpVBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9194

On 3/2/26 13:13, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Now that there is snp_prepare_for_snp_init() that indicates when the CCP
> driver wants to prepare the architecture for SNP_INIT(_EX), move this
> architecture-specific bit of code to a more sensible place.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/virt/svm/sev.c      | 8 ++++++++
>  drivers/crypto/ccp/sev-dev.c | 8 --------
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index aa784542b32d..53bc0c7f2c50 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -509,6 +509,11 @@ static bool __init setup_rmptable(void)
>  	return true;
>  }
>  
> +static void snp_set_hsave_pa(void *arg)
> +{
> +	wrmsrq(MSR_VM_HSAVE_PA, 0);
> +}
> +
>  void snp_prepare_for_snp_init(void)
>  {
>  	u64 val;
> @@ -530,6 +535,9 @@ void snp_prepare_for_snp_init(void)
>  	on_each_cpu(mfd_enable, NULL, 1);
>  
>  	on_each_cpu(snp_enable, NULL, 1);
> +
> +	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
> +	on_each_cpu(snp_set_hsave_pa, NULL, 1);
>  }
>  EXPORT_SYMBOL_FOR_MODULES(snp_prepare_for_snp_init, "ccp");
>  
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 5b1a24b11e3e..ef45977b09b6 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1076,11 +1076,6 @@ static inline int __sev_do_init_locked(int *psp_ret)
>  		return __sev_init_locked(psp_ret);
>  }
>  
> -static void snp_set_hsave_pa(void *arg)
> -{
> -	wrmsrq(MSR_VM_HSAVE_PA, 0);
> -}
> -
>  /* Hypervisor Fixed pages API interface */
>  static void snp_hv_fixed_pages_state_update(struct sev_device *sev,
>  					    enum snp_hv_fixed_pages_state page_state)
> @@ -1377,9 +1372,6 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  
>  	snp_prepare_for_snp_init();
>  
> -	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
> -	on_each_cpu(snp_set_hsave_pa, NULL, 1);
> -
>  	/*
>  	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list
>  	 * of system physical address ranges to convert into HV-fixed page

