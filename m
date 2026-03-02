Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010029.outbound.protection.outlook.com [52.101.61.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F28748095B;
	Mon,  2 Mar 2026 20:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772483166; cv=fail; b=NoxAEstUnZFNMvjw2VMZfpztqAyueoH/4BZMcI0AYqIwr835ygCE8YZtWPXTCSDgqZrmzSDObIvYYwqb1ngbK8ev/YjOKIlwRnVM2DKDG2pUXiX3YxiKSK0wRqZc3pamBuIfLeSPgGMfWpkWdGDg4NA5trv65Yvgd7aGvyJEF3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772483166; c=relaxed/simple;
	bh=Izgj+RnuhmwblWcoodtcT2JjLBgh4XYbYEWb75qFHos=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=poxIEflJCsQehOqaoMgZVMPSbFUAj/8fAGkJFKWGmD2EklS7Zde5bYMk9tWMwt24W5F46lxLi8mWr69UVYEG4m+Vt0NqoaIe//I38yOCIUzR0fTi2lJ91I7ZKPqzBu0e8zGlCRwJkPNVLnbXt9ZGcgjyR1e+QbK70ZN4eAqyR30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LPF6q+BK; arc=fail smtp.client-ip=52.101.61.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LPF6q+BK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yabhqLbqttHCrP64Aae8b0kk5lMM5273VsaSsX748MMtZZzg4OXwIa+ZCnkre3Dd9oUxcPSm8C3KqLwQCaPtXWBL2C/X03RSSWc4Kv9CdSIj9utptHhMHugk91usVa5dugC13AMAd2vK7GxCR0UQvu24f6lenYv68fhoxHmnSvYEadMGcbp3cV5rb1k4u7uFYsnUf4XvuTCgGFI665L0aT51qd+5x4oWutph7WIQ0JjUOfZ6r7SF7R2mQmDBwnWb7NWVFOmb336sYcwdzNMqTPA78llf1Cf/Ae0Zcj04CcIk4xhiPiE/J2fJqO3/5kevnoRRnlXl0FHH+11jZDWJQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68s2DmCNPFjA0WWkHXK6fcUX4SexZkhcnb+CKMjQTLw=;
 b=cYJPvKwFeCpZ5jO8fcF4NptmYyzwD/kvdlLWp++S3Iexl7aLwMfbR5R++7nMbbJd1fIDDCwqlK5puYVq2k/+PESMcUOy7LwACLHmBRkOirPGODZmNmTBCjC3pjMpU4naYaSgsffJ2VdxUdmsJfVD97wUloeGYs1Qvn1/6J3Bntil4ILIZSyc4oqgijmcWJk7Z4qMOiu8xtem9gj0CWVoKncD4zVooIKlMUyKJbranPdXxU8Cla7zUYWnqBV//PeOewKo+BNL/ZolLj+YcpExGbWI1NFDA0CyNSgypkFUGSWSVfsfiD0JUcmBYGu1XYkL9X84bYUzuPJUC2nzPTrQXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68s2DmCNPFjA0WWkHXK6fcUX4SexZkhcnb+CKMjQTLw=;
 b=LPF6q+BKLedsVMaO5yDYddbMdsVZiSVfIrLVmKAKbJxV7tLDmUzERxe3bJp+Md/7bkZ3Pz5QuEJThM8IFjBaszYOKRU8bdnOdPMFV2nEj4rPq/9vpGIOqGKK+5pPykmhSuDt6ka0s1dEe1drvLeFKkl3dhoE9iIGYxcYe8uaXtg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Mon, 2 Mar
 2026 20:25:55 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 20:25:54 +0000
Message-ID: <2617cb33-518f-460d-9e87-b9b552727fed@amd.com>
Date: Mon, 2 Mar 2026 14:25:16 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] x86/snp, crypto: move SNP init to ccp driver
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
 <20260302191334.937981-7-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260302191334.937981-7-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB9194:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac0cd9f-2551-460c-4494-08de7899e7ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	GcX/AmaMl2Z5Jsye+dw8uUbaNwFl8x0yNYx9woOiQun7dIhhfHsP9x2cvckQpDlbohoruS1Lld4WOpchowv6YQEUAbjeC5nHtkAl6P3alktMchpuOBA/Txwn4AaFkk1PAhSn+nTVfz6z8/+49Pc9Wo2fJZ/zW0x/ENlh6ng1XIy1VmXdEr0BFRkDqixygDVXfJNmRFTONAnNJWWsI4+XDrbszmgFOLz+gzLH5KvlgOwKZpuQu4geX++2xvDX228qM2hJ9d/2y+aFLIKM3EDZ89vxzVSW+4y3XOE7xpPy/2EWsdW+ff0YMEJFPOaWbNO2KPVrgWtZvh1dwrjcIRt2Py6M7PVTFHSctxoMWYIFHjQta3UdEVaACV+/6qfi/rs0x+rLBuzA8iECZdK4ieu5370HqcMzEAK/9/6gVQ9TRog0imzrNGZgRZ3SRlShK4MmGruL4AgBZFhN09OmiB6ySK1LepGkfAeLinTHvEJWbot58KJ1pr7ClAP+/h5o5UvKykNhxSZd9RwCLEvklsI50NAPXibd7+YthxBM1sjCXbU+b7Olm4CRQYpayZ/voUsJPldR2QNuZBeUIqFKxvpBhR2gUahoiylITi/GRA4Tnq7SzZTx8DDfLsZ+lg7i1n+lvO9DFru8YINI55SVWeUJP77INb9vBIUnrhGGcpYU/GwpEXjXvUm9zHt9TcolY7+pdHmOrwoSOxxjZnw2FWjPliozl8KCKeRM2BI8ae/F1auuNxX9o2GCB4dV1edMcAztAbWA5GujBQtdXXjnOhy6XA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVVKaFFMWUM3a05VQXZpMXp3aVZyNWNRZEJNbmltRlNQOHdlYnZsQzkvTERN?=
 =?utf-8?B?UlJPa2NpUmhUNVpZL2wxOCt2V2NvRU9hSWpWL1BwU25NR1hrT2hGT3hramh1?=
 =?utf-8?B?RWZkTkhncTd6ZnA1U21Fck0yVWg0Q1ZjMXpOUnFzRXZGOU1lc2xZSDJ3Qmk2?=
 =?utf-8?B?VWtrSkdJNVVuOGFQMGt4b0x1bVZxQ2I0Z1F1amU1Tkx1ZHJpMkRmRW1ZQmRt?=
 =?utf-8?B?aGtQU1N5czlWc2xIL3pheEJmT2VnUFkweFZvZHFLcjV0OHRaZnFlQ2NyazR2?=
 =?utf-8?B?UGNUdzZuRWdscE5xTE9uNURndHNmeFhhcDlrcHJENDFRa1loeWttSDhySHB1?=
 =?utf-8?B?TVJzQzkrZFdiSmlhUXVWTGMzekJTMExienc4NHhMZWlGUEtJR1kzTTVZTkVU?=
 =?utf-8?B?RjdnUEVZK0N4eko5bStsZVg2TkhzQnhBL2g1Y3dYamJiNENSNnRLWExCMHlp?=
 =?utf-8?B?OFhOYmtXYnkwZS9uMXNQL2RJbm5YRWpQV1BBRlQvbDVIRXZaLytjdjE0dWpN?=
 =?utf-8?B?SkpOdnJuUER2eVBVMmdnY0JTMkJ3RU9heHhkYUF5U3pxZ2ZvcWZmZXFMbDFB?=
 =?utf-8?B?aEh3VjFPaFhDQUp6R0dVSk9sSlMyL0Frc1F0bGZJTWdkbTJMcjBJckorM0sx?=
 =?utf-8?B?WnU2SUFZMXFIZlIzWkkzc1psZXRvZngvRDNQdU9nbzlUZkRRQU4yeWc3d1Bz?=
 =?utf-8?B?T21FRWlDYkJ0U29OWW4vdEMrQWJ1dXh1WG5FVThnWDZBQjFQUTlmWkxWTnRH?=
 =?utf-8?B?UlJpU2pCMjdXQ0RlS1U2ekRxVTZOaEc0TFB5SG9iTDVoaWQwc2ZRQXVlcEZP?=
 =?utf-8?B?cjFTMXpiYnJUZklJWTJqOU4vdkh6Mm5UNVh5SFVPc1ovdTFnWmlQY1dqYzJi?=
 =?utf-8?B?VGlieEYvQmd5Zy81WjAxOGtmWm9kU0l1WGJnNDJ1UG9aY3lLZEZFYVA2cFVQ?=
 =?utf-8?B?ZFU3alpIZk9mSDdtL3AxanNnV3VkUEViNWkzOEJQdExPRjhyMjluMUxYQnRM?=
 =?utf-8?B?b3ZiSm1KOGxleGp1eXNyNVZBa0tZYXM2bjk3eUpUVHo3aFM0akhnNlhSMXRm?=
 =?utf-8?B?Q0FFc1BqS280MnRLUFVjUkt4ZHVGYnJEaU9CY0JWN0JLa3VJeC9UemV1TlEw?=
 =?utf-8?B?TjlMUlUzRFVNZlNhd3VzMjRPemhnSkhOU1ZZczFGdmdZazhKbDlob1F1R0I5?=
 =?utf-8?B?VG43Qlp0N1JmRE03ZzllRkhBaHUybU5RaHpQSGhkcDhFNVlWZUZrYWJMTkhR?=
 =?utf-8?B?TU53a2JNZmpJR3RCN1ByWkJjeXUxYW9BdU5YbDUwNWxXelZyK0VhK2orWFN6?=
 =?utf-8?B?V01ybWc5NkptMnBsN1pyMktIaXJaVkdZT3hhSzY3SG82SGltb0Q4b1E3ZElD?=
 =?utf-8?B?SVRHZUZGT3QzenpyWXRwOTNzb01WWW0xajNIanJXWGpKcEVBbStBNnVza1ls?=
 =?utf-8?B?RUYrQmRodVgwYTlCQ1FnOGxVNXdveFFRMHlPREgyK1IyMjAvRlViRmRSSDBv?=
 =?utf-8?B?SWVZdStGY0hQUFVub2RpYWpDRHpPUGs2aUQ4UU9sczBLWC9XbzFZeU1Jbjls?=
 =?utf-8?B?eklIZzdHcHprUHFqZkZJYStGUEVyWlBGWk1wdDUyVHhQV2lYV0phdjhwZHo5?=
 =?utf-8?B?dmhudS9NZFlibDh1N28zNnUxN0dydDBzekM0Sko5NGlEUUpHV0ZaZHZrTWgz?=
 =?utf-8?B?bCt3NTJPaEVzSUwxSXVtMVM5RURGNkFvZUkvMjJhUDQzMlZ3OTFzR25mb3Zv?=
 =?utf-8?B?MSs0Nmphc1FLOGx6SnQ0MGJyRFJTR01HbXpucDY0cEtObWg1R1JEUWRSN3lB?=
 =?utf-8?B?YzJSS05IRFVYOTNJbHZEdGhqQjc4eTFjaTdxaXNxdzN3WE5oWXVhaU9IYTNm?=
 =?utf-8?B?SkRhT1JwaCtSNTFtMHhKZklTVnhOaTYyaG53ZmtlRnhUb3VyV0ZXaUtyZmVM?=
 =?utf-8?B?cmFiOGp2K0JJOEM4eVk2R2NnamZlYytkM3diWjFvWVRJdXYxcXFldWJrY1J3?=
 =?utf-8?B?dEt5NS9sSm9sRVpsV2o1Q2xyK0l4T2tleU45bTZraSt1VGcvT1N4RU02NTUx?=
 =?utf-8?B?U3lNcVg0TEtvZHk3WlV6d1NsUy9rOGlUUzRMWVEwZ3Vsb3Vnb0owSlc5UC9M?=
 =?utf-8?B?Tks2eFpobFdGelh0Z0FrcXJnZTcyNXFrajhWWXhya2J5UFhIU1ZPWmdrbHNw?=
 =?utf-8?B?bW9iSTFDTnROY00yYVRnOXZaQWhaYldseXgwOWhlVWZQcnFwQjQ4VXI5eElQ?=
 =?utf-8?B?UWs3QTB3QlRKWm5MZlo5R0pxOVJpV2VnZmFoYTE1SnFORzhjQ2FVSG80cnhl?=
 =?utf-8?B?TnRRdHNmMVlHR21jd2dSbU9rb2VQVndZS2FzNjdGVmRsVWlMTUtjdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac0cd9f-2551-460c-4494-08de7899e7ca
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 20:25:54.9106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bufbMOuGopo1GnF2PmRctRfES7RUcV8guxCWTY7V4yvdy1tvKZlVHQFv9ja/RzAOp3hTRk9ePrFpZpgkWGg0/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9194

On 3/2/26 13:13, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> Use the new snp_prepare_for_snp_init() to initialize SNP from the ccp
> driver instead of at boot time. This means that SNP is not enabled unless
> it is really going to be used (i.e. kvm_amd loads the ccp driver
> automatically).
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/virt/svm/sev.c      | 2 --
>  drivers/crypto/ccp/sev-dev.c | 2 ++
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 8f50538baf7b..aa784542b32d 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -549,8 +549,6 @@ int __init snp_rmptable_init(void)
>  	if (!setup_rmptable())
>  		return -ENOSYS;
>  
> -	snp_prepare_for_snp_init();
> -
>  	/*
>  	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
>  	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 096f993974d1..5b1a24b11e3e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1375,6 +1375,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  		return -EOPNOTSUPP;
>  	}
>  
> +	snp_prepare_for_snp_init();
> +
>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>  	on_each_cpu(snp_set_hsave_pa, NULL, 1);
>  

