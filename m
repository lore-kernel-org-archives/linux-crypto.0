Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013001.outbound.protection.outlook.com [40.93.196.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EC13750C3;
	Mon,  2 Mar 2026 20:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772484438; cv=fail; b=PNUAE71PCdvggsJRzmAID2PO8XIGhHLmGLaH5kExPTaQffC9nFlJGfBqKBjTzQ3vadybO9oRt9oslg1n+hK5JGuf3DOeqR+SozFjxm73+IqPADqM4o6e/iiK88PkL6/Y67PisfQ+b0U5mCMxA3JBxe3V+YHB47LZfU52/ckPLXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772484438; c=relaxed/simple;
	bh=Lr6NxPZKcu8i48AX8Js5V1dYIkDmKLaX3KuIsyGIiTc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U5HlktKRjc2vEGD2lfI2ny9mVhNl/eLFVA0JnpGF5gDnBxpq8Xd0/Kx5BSqobvrq00oIQ/20VrlIY6Dp2tKaYd3xqKRA/0xeWXDYk6I/VKgFQ7iHg2TlhDXAS7udpmRJDLWDIm1CRMlNgL8IRg0yZPeUyF6SicfA7Cgnb8c1cVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bRt2SVnj; arc=fail smtp.client-ip=40.93.196.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bRt2SVnj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pSJ4Ai3lj37/w0/LBfGQCRqoID9w/IX9V648WtjrOINB/O0wsGpw+BFMXdweKWZzLNEVJHE9uMZasDFErl/kXiYb8NtKoF+caiiOVOd8uvAG4B/u0u74pWGQvAQrL1rXwxMtwi3xZVSvWwXUZHtRIuVM3wQ+X5WipaD0dCapwtpQNEYmhRdni/bBwSJrHupPmNOX7zwdcT3JX64bDx2n+gJjkqAu6wqD/yMv8pjFP1asiTYC9ov+Ha3j6/OOE0GQag9Mj/l6g7Zfi4TBXKz7dISISUhy+X/sHKcfyBSxLtlYSY/0htP4MjzhIQd0oF1Xlxm5s3dgNOryM8xVPCTUBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMgI/aC3S7NviFD7NpQKSWYOExm6NvQHptS+Fyy7u4U=;
 b=itC2kDMwsxRNgVZaaijXUaubZFBa6JvfBdOK46Nle4UmtYCdB/09p09f7prFmtIFKd9TiBv5+M4OyK8hWpZ67nBttTFJjE+AgAfckgfppcWC21SpwDNMet08xJYzdcCKiwQHkdw4sJ6xByADuA95NUfA1u3fhjR8Kq5Bkyv5r+d/1+/uzCTcL2t/9mIhK+63wBBDQz7L85GrQxA4OhkjuFdOOj9l4TjOIjTImx3jHvs2E/QvJsz9L97zkDN5rX6lWe+w6oStl6gjpw7EFed0lT9a4AY6u6agE/FHs1B2ntI8HxMoDuhOQPNlMMbTh+MoiJczqfi5k2JtYzRYpWV0bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FMgI/aC3S7NviFD7NpQKSWYOExm6NvQHptS+Fyy7u4U=;
 b=bRt2SVnjjz6UMdijdFvq57gnkv3m/X7PbY0hK5Huzqc85v5+CJQpjeypfy8ebyx2klVraxvXlVFLCXbp6+bZtJFaU+FjumRbELYJiuEv0QV3h8VRIVYyUZOjZRPOgYYFdvZJu1xb0bEPhXYOPTnyn8nGnfx+2sEjaMvQEzLAEPw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB7488.namprd12.prod.outlook.com (2603:10b6:510:1e9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 20:47:12 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 20:47:10 +0000
Message-ID: <12e7f995-b55e-4090-b733-d25874871593@amd.com>
Date: Mon, 2 Mar 2026 14:47:03 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/11] crypto: ccp - implement SNP x86 shutdown
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
 <20260302191334.937981-11-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260302191334.937981-11-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:8:2a::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB7488:EE_
X-MS-Office365-Filtering-Correlation-Id: 887c10d0-6c60-4d53-0768-08de789ce014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	1M7gRp1nVlPgJZy4uC0KuSLrerG+45IRCYmSxcW+G/yFjrzCkZgz38PAmnZfbKJ49B3iFPTled7VWfM2Ciii76wxBZqgZ/tng+z4iTefnN+q5dBz26hzsHHUpaQb7fBUdBLTOrN4bCRq1Ij743Jkqi/R3Xtx4gLK0CCpSn0Ir+8WerfXbx0bTTtV25aZoHktEgZACfvRdtYIKhGeBVRQi9BjtioWLexoW2AehSr1CGrW+2ygSZqBhRVIkZmZuYRK27tNqD/iR5xgCETRXj1bPA6iRk7ALiSJa70SLOOA5pYG2mkVUyX89ouyEZrKfAIkotgX/A2v8xYhvo90MRltW+U8iRjYWIvRm8jeDdP+wy5ZF/nBBKhrfObxFoZB9JLtGVaPs7jRCZcbGeN+g5BIdkH0b89IJUJlsVd3gExl8V2NittH1e4EYln/xC4aL5JflG201ndNIO3tZKwZC9BdWS96ReknDImTszYWXSE6vHL8scyu4ag2zz8dH9iXgMox6viB3QmSb+C2Ma2gxZMLlbsjAqoWzaAXmy4IPNsnIzbVHS1BQUSEMGNF6fwkPa590r+qIA07ifs3xRiYyCWmYZwCNFPdzY7TDBffW9VWuaF+qj8TutvBP+c9ZIo4T9lg5UBgTVUMj1ysztB07bpICDkzYjEPLrYrEscy5XPDjun2VJ6NNqo34FZDqjUW9iCkm62aVFo0PeDn/iwbK7jw3IJlc1BWY8ckLZcuhBZFWFy4OsgfhBa1DNgbp1Rtw5ruSo2VZsxxBVti4pEbB4Qh6w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGJRR096c2FubWNobGkwNGhZRlRvRDBCTzJ4Ymg5RFREdWwxQVNQTjNVVEJU?=
 =?utf-8?B?U0hycEh0R0ZKVGhSY1R3eHRJbDFWSUwyU2g5YjZPN1hiZ3hXZkV6NUFQU29G?=
 =?utf-8?B?aFhDM1lmWFlDZ3lZNEU1UVFsZGtDdVpkWG0rK0M2SHZISmVUZmtlamwzTWFs?=
 =?utf-8?B?b1ppU3VNSVh0OWI3cU1KbFQ3LytiZmZYc1I0Szd3VDBPUmQycWZFRzU3QlA4?=
 =?utf-8?B?NHc4eWkwUURXeEJFVzFYMmN1WUxuU3RXa3h5NEVZL3NuQjl0dVNJWGxoQVh3?=
 =?utf-8?B?bERXWTlGUGtpUjVSVUJMaHJXWXBBOTJLMmNoVFhWL3VMUGNiMmdIZ1ErU2lj?=
 =?utf-8?B?VmtBVVBRZ0dSR3FjaXZUTVVsTGdFMU05L05SU201Zm9GS3FCeSt0OHAyUnpS?=
 =?utf-8?B?d1RXc3VEZHFSOHIzRXdqdkNuczV0OS9LNWUzRXd4aDY3R2xqTEw4Wlh1OHIv?=
 =?utf-8?B?VHNvRU5ESGpxWXd5QXN2VHl1ZDlhQWJvMFBvL3U1SkFGRkFmM3JONTdXSEVL?=
 =?utf-8?B?ajN5cUJxTDhHS20wMEJsdk9Db0JCb2FwR3UxZ2NqTElxSXdWMElWNDYwQTRF?=
 =?utf-8?B?ZXpoblhIbTZ3dm1BTmhQSGI2TEpDT3NBaGxUY203ZXNJY1VxY1VzaDhFSFZC?=
 =?utf-8?B?ZXpaNnBIRzU2TTFFaXgxVWEyTWVMbXBnOGNXbDUyRGM2eTN5TFU5N2JBN0Rm?=
 =?utf-8?B?bm1SWkUwY0JBNENRaXUzQW1GL3d4QkI0Qm5pT2hsSDF4V3czNnR0YlpQd2tN?=
 =?utf-8?B?SVQvQkRVaEJ1UytkR0dFTlVRUDdZR1JpSitNbW1zWEpoTW5TWVE0ZnFWWGdk?=
 =?utf-8?B?M2NtMGpaWlNUL0xJS3dJTG5sUWhpd3preHAwZ3lEcTdHSktyRkdtS2hlcG5D?=
 =?utf-8?B?MHJBSThua1ppbWF0N0xkcUpsYVB1RVRIUzhaaVNmYWxrQ3VxT0ZVTEtYSnhI?=
 =?utf-8?B?TGI5MnFhV0NHWFpFQTEvdmRHYnVxajlKSFA5b1JTUU4zZU0wOElJTzhsY1JI?=
 =?utf-8?B?Ulp1STFlNFAzQng0NGdONUJrR0RFL2JHRzk2N3ZYeTFBNkh1QTVMa3FHOHZz?=
 =?utf-8?B?dWt1NUluVFhCSGduWlhmWFRSbEw1a3RkUGtBblorc3loOE53UUlBbU9ydVJM?=
 =?utf-8?B?cDN5QU8vK2U1aTlEdWdCSm05ZStlKzlsNUtUYm54bU9Vb2gwRzAwZGU3anpm?=
 =?utf-8?B?Z29Sam95ekVRTXFOU0kyZjRUdFJRak5mY2JPR3ZUdkwxZTZWdUJLMVFVOHlC?=
 =?utf-8?B?cFpjN0ZpZEpyajlmZ0h3L1craXRVck1yTUs4MUFlN2RaN2hUMUhxUmZVbnB1?=
 =?utf-8?B?UWNkclRIbzQ4eGUvM1R0amZlVGl3QlNYSlEzUCs1UW1kenFBS2FIMUpxa2Jo?=
 =?utf-8?B?UkpmVmRTNWNUejAxVDNEQ0RCandPM1NkSTlqUUpGYXg1TmQ2VDhyQjgwZGdm?=
 =?utf-8?B?RWkyUXFIYVJpZ0h5RTh4NlQ3QU5PWDl6ZGp5Ymp1M1NvaUcwNmwxelNnYjFk?=
 =?utf-8?B?K0U1LzBRWVFQckk5cUNUOXNWay9hTDlyLzIyMDdkM1B0OFdESzdRS0lNVVg2?=
 =?utf-8?B?dSsxSFVycjZKSnhVUXA2Z1Jna2ZCeEFiRHNpdDhyUmpmVUxKZThyR2hEbUFT?=
 =?utf-8?B?S1NjYW5VVU11YnR0eHcwT3lUQlJHVGpOOHVpQTZVZldDMElYWHFGK2E5bGpm?=
 =?utf-8?B?RUJ3Q1ZHcXgzYjFCcGZqTE9MeDk0bEJCcVpPMmZUSXZ0c0hTQlhwY2ZwQWt1?=
 =?utf-8?B?c09oSUJDUzhyKy9IM0JpVjV4TkVCWkZ2VVBXVldKeVhBWE1JSGVPT3FoYzM0?=
 =?utf-8?B?YXRJemJ0bGduOWROczI5emVmekkrUG84ZjhXUHlMQTZCV2tDajJZY01KVEZT?=
 =?utf-8?B?eGxSd0hYRUZoRjE5MEl4T3dNMHlmQ1l5bitPakJsNGJNdFJJa1oyemorYXZa?=
 =?utf-8?B?Zjg0Q2hZZ2NJOXJPR1N2NW5tVlc4Z2NvUmlCd0dFeXRKYzdGamdJNGprSGJk?=
 =?utf-8?B?N2wzNkxNeEdTd3FHWVl6RGlIYTZ4cnBLSVZhY3hHYnlXT3RuV0J3MlJoSGtn?=
 =?utf-8?B?RG9KRzh1R1VpekdSRUNXNmF2RlNnUkhCditMN2c0THN1UVgzSmJyODlGUEl5?=
 =?utf-8?B?RUFlbmhueTdkOGNqZW0xakswTlVrc0lWTCtjelRDTFp1NUYzVVRicW1ER1lR?=
 =?utf-8?B?ekdSV21aTUpndnc2NTJnQy9LUkM1VWtkTmdKdkNLVmFIV0pBUEU5cXowVUpT?=
 =?utf-8?B?WVBWbTBCUHkzemZHM3c1Y0R1ekFOUjlEQkhBK08zQUt6NkZTZUY4b3N3ZjBY?=
 =?utf-8?Q?g3lXpsUqZldlMbf4lf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 887c10d0-6c60-4d53-0768-08de789ce014
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 20:47:10.5067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3nFF28OgcHlBdfjRhttNnsLvDvJgOUOCdLhqWHwIQOQzExiol5I1fcK6y07kxMen2LN+a5N2IrIskKIiwxmjEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7488

On 3/2/26 13:13, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> The SEV firmware has support to disable SNP during an SNP_SHUTDOWN_EX
> command. Verify that this support is available and set the flag so that SNP
> is disabled when it is not being used. In cases where SNP is disabled, skip
> the call to amd_iommu_snp_disable(), as all of the IOMMU pages have already
> been made shared.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 44 ++++++++++++++++++++++--------------
>  include/linux/psp-sev.h      |  4 +++-
>  2 files changed, 30 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ef45977b09b6..665fe0615b06 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2028,6 +2028,7 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	struct psp_device *psp = psp_master;
>  	struct sev_device *sev;
>  	struct sev_data_snp_shutdown_ex data;
> +	u64 syscfg;
>  	int ret;
>  
>  	if (!psp || !psp->sev_data)
> @@ -2041,6 +2042,8 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  	memset(&data, 0, sizeof(data));
>  	data.len = sizeof(data);
>  	data.iommu_snp_shutdown = 1;
> +	if (sev->snp_feat_info_0.ecx & SNP_X86_SHUTDOWN_SUPPORTED)
> +		data.x86_snp_shutdown = 1;
>  
>  	/*
>  	 * If invoked during panic handling, local interrupts are disabled
> @@ -2074,23 +2077,30 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>  		return ret;
>  	}
>  
> -	/*
> -	 * SNP_SHUTDOWN_EX with IOMMU_SNP_SHUTDOWN set to 1 disables SNP
> -	 * enforcement by the IOMMU and also transitions all pages
> -	 * associated with the IOMMU to the Reclaim state.
> -	 * Firmware was transitioning the IOMMU pages to Hypervisor state
> -	 * before version 1.53. But, accounting for the number of assigned
> -	 * 4kB pages in a 2M page was done incorrectly by not transitioning
> -	 * to the Reclaim state. This resulted in RMP #PF when later accessing
> -	 * the 2M page containing those pages during kexec boot. Hence, the
> -	 * firmware now transitions these pages to Reclaim state and hypervisor
> -	 * needs to transition these pages to shared state. SNP Firmware
> -	 * version 1.53 and above are needed for kexec boot.
> -	 */
> -	ret = amd_iommu_snp_disable();
> -	if (ret) {
> -		dev_err(sev->dev, "SNP IOMMU shutdown failed\n");
> -		return ret;
> +	rdmsrq(MSR_AMD64_SYSCFG, syscfg);
> +	if (data.x86_snp_shutdown &&
> +	    !WARN_ON_ONCE(syscfg & MSR_AMD64_SYSCFG_SNP_EN)) {
> +		if (!panic)
> +			snp_x86_shutdown();
> +	} else {
> +		/*
> +		 * SNP_SHUTDOWN_EX with IOMMU_SNP_SHUTDOWN set to 1 disables SNP
> +		 * enforcement by the IOMMU and also transitions all pages
> +		 * associated with the IOMMU to the Reclaim state.
> +		 * Firmware was transitioning the IOMMU pages to Hypervisor state
> +		 * before version 1.53. But, accounting for the number of assigned
> +		 * 4kB pages in a 2M page was done incorrectly by not transitioning
> +		 * to the Reclaim state. This resulted in RMP #PF when later accessing
> +		 * the 2M page containing those pages during kexec boot. Hence, the
> +		 * firmware now transitions these pages to Reclaim state and hypervisor
> +		 * needs to transition these pages to shared state. SNP Firmware
> +		 * version 1.53 and above are needed for kexec boot.
> +		 */
> +		ret = amd_iommu_snp_disable();
> +		if (ret) {
> +			dev_err(sev->dev, "SNP IOMMU shutdown failed\n");
> +			return ret;
> +		}
>  	}
>  
>  	snp_leak_hv_fixed_pages();
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 69ffa4b4d1fa..2adb990189c1 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -834,7 +834,8 @@ struct sev_data_range_list {
>  struct sev_data_snp_shutdown_ex {
>  	u32 len;
>  	u32 iommu_snp_shutdown:1;
> -	u32 rsvd1:31;
> +	u32 x86_snp_shutdown:1;
> +	u32 rsvd1:30;
>  } __packed;
>  
>  /**
> @@ -891,6 +892,7 @@ struct snp_feature_info {
>  } __packed;
>  
>  /* Feature bits in ECX */
> +#define SNP_X86_SHUTDOWN_SUPPORTED		BIT(1)
>  #define SNP_RAPL_DISABLE_SUPPORTED		BIT(2)
>  #define SNP_CIPHER_TEXT_HIDING_SUPPORTED	BIT(3)
>  #define SNP_AES_256_XTS_POLICY_SUPPORTED	BIT(4)

