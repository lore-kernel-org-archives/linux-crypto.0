Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010059.outbound.protection.outlook.com [52.101.193.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A1315D46;
	Fri, 17 Apr 2026 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776433710; cv=fail; b=i0b5onXXYjSi8KKiry6vKb7BmYe/2vLyYOE3biItKMeuWRS977Dv5/zAUNDXRMpEY2q0ExV6aOZedoAkBDNSTaoUIKwZYW9yd16DtBODLv3BQhE8VcGTTWE5l10o4mywUkgH5JdFNcgiOduxZev4WNKVZZUpWC/rmt9Joj/0mpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776433710; c=relaxed/simple;
	bh=zyUBqdCcxfItlvHYO6gGef/O+v9DBxOwVFl1mix/b2k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JPhwKuE9rp8fYR8813400SBSZkz0j+COWgpNjlzSiEMUvbELel9aYB4B3XqPljBWclx/7Ny8fDm1MTh1wbIC5uSoqk+c643C0Bvht/TeeCFmJ+J/OmzaT3AbpU6ArzKhJ6Kog7zhcVyMMBQIV5LQf3rinkB7udfdcI+if2KDS1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CgMC9u5a; arc=fail smtp.client-ip=52.101.193.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CgMC9u5a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IciibI6mVQeHDGIE4+7UAyNkP0vM9xWi+807Elpv+gbCUAJhw90mY9SZeJKauKiRWPxcem7WFWL7zKWfDmXSQgKWYqLgWG4J2yrUc0+VcaMJD1DdbI3VaOOyhp2OKyJ6iaYtBAMx60gTbFlYinXY6HIyOwNZKlO5h6LCk9HFvdPJiKyDNOTKZ9QXnGAhMH4FASQDJji6yZxBrogfq5Rl965GeUUdouq9hMNUv655UAIC2Ibdl9wch291Na5UV418rH3u2By7+QJ+aiutVdGTgaLfd+6+F0ptJcvshKgJ1D1m7r2Ux2pCodf97BkCVWON4pQydY5O1rbfh4N1SCuwyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7IdfqWLe0zIzwtnaky06fvlcLPVzH9d2KPLeNl+g9WY=;
 b=p0CVBm4DieVlU7fIKR7RanrzX4HqJRgpL/epdZCFpYvMpa2yJ9NUL7EOwhL2sZdGvkdN4KEjw9GOwrPSb61CFBEXLqPAxz9Yq47gfXEEio59Ls4ytsf/SOEuOy2YvrgCEZMottDmy9yZcii+mbLXDb/f0sTa6wnNajXesKHqvUfk97QO0wMKCWEhnOcYMGvu/Rz0n20arOJ3lb0i25+CRvGVONdN861VjuZgWVL6EPmkEeSsuiItDgjlFOxIYfvlolo8iSSUztMWsL1SUDqwkYkbEGG/aJAm6KKS68OZd8t2W26bFTKrSUFSqqBB2xSqPNMnybcmNRmFy1yvzYTxlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7IdfqWLe0zIzwtnaky06fvlcLPVzH9d2KPLeNl+g9WY=;
 b=CgMC9u5a3eL7qDHILMi8xTV3JJQWl5HOHiFt3CDJE5yjgmUmwcQqUBbmnkfGihmXWyDaBLmBXVN+80Z8UJEyhlVNglg7C+p9UgqmA1ULPEpw25EfFqdp8MtIm5qhGMYRcgZR/IrKj2VzO8OyHvO/l3ymhMqGGoiIqvnIzkovEqs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB7093.namprd12.prod.outlook.com (2603:10b6:510:21d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 13:48:26 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 13:48:26 +0000
Message-ID: <0eaef1f9-b5d8-4d76-812c-b75d079e4fe7@amd.com>
Date: Fri, 17 Apr 2026 08:48:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] crypto/ccp: hoist kernel part of
 SNP_PLATFORM_STATUS
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Tycho Andersen <tycho@kernel.org>
References: <20260416232329.3408497-1-seanjc@google.com>
 <20260416232329.3408497-2-seanjc@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260416232329.3408497-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::9) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: bba631dc-affb-4ed5-a992-08de9c87ffaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6JZGpihBWB+fcrA8RokAWD0F3j0W/XVzAoYwJ0hUaa3c/1/O6ms4iGsg26r2Py10VpWptmb35/vif8O5YIkd/VSRgbszPEKtIR4wmNIVZWQ7ryHio7cowdQaL8J7tvrrOtWhfNGPxNyT/kHc5BBEZLnT+VREXCepw+O7avhkZkGzHd15+qthQh/fnqtKZu2jcKzxG6Dehui3sTOzkpwAfMtBPgJbP2BxsSkjgU/Nnncovgw6UDVrVWo8whayQ7xjOojp+mdrT1hk69vsacpH6f90PJx+Go9UtCgBohG736axcJr1YQm07uDnb5eOUfADgHLvjB7bkvCEZQCRyuZ0oBagaUCq87IdUH8thvihB5hTYI2qqdN5qHN3sT71KH9Frs9Hw9qf/m1vyULvdGlM+U2NfBQNQEJ0dsfse8I00Y3/NowEINFkAju08Z9XGHk9pS+dOxTaoW3hQD/Irce3IDKEY1WFpyObm+IIfaLtYLWWMovHjurmIu48UZEiupdN33L+U0L+4dKIafYTuNHu8s0Pot0Con/RC76TcNgok775yHC4aRvcuqlUUICRDNn5oAx9rrtF6F60dOxFwComyP0BzxjmwLiPfpCGE89radX09RbE98GukFWn6VcGcoyKVo2BE5+Qu46iqJUW5PKyEVBh4k2fC4NAvOMc3Y6GqutD/qSO1jqbvUcc6nPM8tMFvaRLUNe9sncB3te3aJvebaII+EzlQV3cEbZEbmAO7WY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yll1bjduOWVEOHp0eHNXSmswaFRKOWZJbHo4WnpHQzZLQUN1VUFlZ2JXdjEy?=
 =?utf-8?B?L1lyRGVSUXFvMzhXN0xNOFI3QkNwRXd0ZmpCbWRranhCRkdqZmFpUzhSbHds?=
 =?utf-8?B?MUhrQ0g3Z0NDOFoybHN0WEI4YXJETUdVWjdXM0RTemtkUDg0d0h5Wmp3dkRB?=
 =?utf-8?B?ZHcrMk1hNWdOc0xWVUZOSU1aamwxUUhzZ1A1OFYwMUV3NDFjUmo2bDBoeEo4?=
 =?utf-8?B?dFZxQmcyVnJibCtTay8yb25uM3JrQTZEMk5NSi9PdHdjRUdQNUUrMVFTL1VU?=
 =?utf-8?B?TGhJOWlhRjh6dm1kWUROU0ZyV1FTMmxmdTFHVXF5ak5MbkNlQTVRZ1V3Qmxv?=
 =?utf-8?B?TEhYMlY5TzVlaFUwazdlZnJkU05ZOEE2bFVPMlJURXFIYXlVTGlJK1JPWEJ4?=
 =?utf-8?B?OTd1ZE5oMCtXQ0szakdwbWVWaGl5V1ZYbFNiQkkrd3d6dXVHLzcwanJCamJU?=
 =?utf-8?B?WjJxTEw5aEFjTFU2WjJtUi9Ob3IxQXZHdm92cWtWSktJcUtkZzFwOU5tenU3?=
 =?utf-8?B?LzJVTGZ1aVczYUkyekFKSGlqM3JhbCt1VDFtYk8xZEptZlB3LzNsN0dkZXA4?=
 =?utf-8?B?djBGSi8xcmcvOHRxUEE1dllORTBBeDZ3WW9MQkdmeUh2UGJ6K3pmSHg5NU5a?=
 =?utf-8?B?Mklnd1NiR05GdGc3dmZDVG9SdWIrdk5KM1FmYi9NZlBWTkY2Z2VrODVKZ3V6?=
 =?utf-8?B?VzJBbjFFQ05ueVNSVjYwbHlDUDRjb3k4cjd3dzJqSzlReHQ1ZXJXb2NlUU5s?=
 =?utf-8?B?VjhBZlE1TzkzSnBDbXdHTEdFSXlYbzl2U2FLaWpWNVF4ZUxiR1h6UVBZTndo?=
 =?utf-8?B?UTRhdkl3NE9mbG9Xc0M1U21RVStmSEpjSHk2RWVWNFpBN0M2ZGtqMTlGcVc0?=
 =?utf-8?B?SmozUDRnK3EwMHJhaFhkNUpxRERxRUVGL1NmWFFQZVVJZ2xJUWtIV0w3SU8w?=
 =?utf-8?B?M2M4QzVJeitPUW45dHpXVEZiYkNmZXYySGRtUkUwenVuSUxJbXlsak95WnQ1?=
 =?utf-8?B?TUluOE1qZHZQeit6VlV6UTNNenBiOEs2bkRra0xPaUsvbVQzNFFNcktJcjBN?=
 =?utf-8?B?dFdjdEJvUW56WlMzelFvVkgzNlZ4b05EYVdZRmI5S3Nqb1RsQjY5UEE5SlJK?=
 =?utf-8?B?cTZHME4ySzhDdXBMc1l3eWl6S3g3SmxCS1JjeXRPVHlmczZPU1lvMjRiNFZX?=
 =?utf-8?B?SXVERGV2MHJIZm1TUDVRbXlZRE53WHgzb2hmU3VhMmZ0c2J6SmJiZzhhcmpm?=
 =?utf-8?B?WlN6czNWa01ucXhDcmhsekQxVWMyUGswUnlhNy9zTG5sTVVuL05NdkthQU5v?=
 =?utf-8?B?NjNIT2w0THVLM2lETHpSZEZqNm8vS1ZJQkE3WG9XQW9Qc0dWWjcyemZySUZF?=
 =?utf-8?B?cHZTOHQwK1BVdzh5bzVaemEzandHSmhGenh4b1M5UUp0QnVDaXY2dE9aYWxx?=
 =?utf-8?B?alJsS1dxTC81TGluVCs1V1hLalZZT0hrVHNuKzFrRzhmMjNONCtTd3YzUlRD?=
 =?utf-8?B?Z0Z3OWhUT1hUZXoyTDZBWURqd0M3QXQvcDBtV05tb1NKNUczTXAyajFxTFgr?=
 =?utf-8?B?Q25pZHV3STlOamtwdFZwNmxlQzZ5QlEzUktWVlpod0hUeVd1QWdQNWU0dVNs?=
 =?utf-8?B?Qk1UNUJucHNXVUhwVzlwU3pnTTFjUlgvTmFBYks2YVV5ekNGR01yRmc1U3Jv?=
 =?utf-8?B?Zm9uMEFsVkc5U1lqNXViMTJTSHNEd05kQzNFSFNhNFVZUFlUOXcwYmRSQTR3?=
 =?utf-8?B?VHF3YTkxRnZrMkErRXlsZERKOGhrQlB6WVRBeXAvNnFzbm95dWRSc01obk5I?=
 =?utf-8?B?V0pBTFVXNitCV0FmYzY3Z3doNThDZWRZOHppaEs4cWdtSlhXVEtnd0ZTQ2FS?=
 =?utf-8?B?ZzFWM0M4MHY5TmQyeDdJWmtYM2dPMUhid212Wm14VVlIWFNkcnA3RDZrYVQr?=
 =?utf-8?B?bnJoUm53bUpRRFBJb20wQnJYZjdGK3BRTGZWdWl5aDJ6Y0MxUFRsZlRvRFpQ?=
 =?utf-8?B?VEtrWHNGVmFyMkNmV2tsVFdVK3g3ZWV5bkpVRW9vVU1temFlR2dST2hzVlBI?=
 =?utf-8?B?b3pZaUxXQjlSRTJEdTM2ZjA0N1RkM2Jwb2xNcnpZMVJXdlgyRk9pZ01SQzZ0?=
 =?utf-8?B?VStWaVR0Tlloa0cvaU1TVVgvUkdveEZXcndXWTZSemJJZ2N4emtxT0s0cWoy?=
 =?utf-8?B?UkQ2bEYyalNTeHIvdzlaeGNpZE52MjlubE1wUXJ4aVlsMFpyMUI5QWlNb00w?=
 =?utf-8?B?akN3OG9YZEtvNnhxUEI3ZEsxSUN1RHJtdnhucEVJL3FtTVlCaTJ4QXVaakps?=
 =?utf-8?Q?c0dQraLhb0ey2OCZ6A?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bba631dc-affb-4ed5-a992-08de9c87ffaa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 13:48:25.9424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hgA0p0X5CtkxBhfbwBz/bkqqjYSUbQ9XPpISEh/8n6dFXbB6tiUmu//XD+LRCtEChPpo8zIg1aa0EBdcrm9aIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7093

On 4/16/26 18:23, Sean Christopherson wrote:
> From: Tycho Andersen <tycho@kernel.org>
> 
> ...to its own function. This way it can be used when the kernel needs
> access to the platform status regardless of the INIT state of the firmware.
> 
> No functional change intended.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

One minor comment below, but not a big deal.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index aebf4dad545e..64fc402f58df 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2367,7 +2367,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	return ret;
>  }
>  
> -static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
> +static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
> +					int *error)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_data_snp_addr buf;
> @@ -2375,9 +2376,6 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  	void *data;
>  	int ret;
>  
> -	if (!argp->data)
> -		return -EINVAL;
> -
>  	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
>  	if (!status_page)
>  		return -ENOMEM;
> @@ -2400,7 +2398,7 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  	}
>  
>  	buf.address = __psp_pa(data);
> -	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &argp->error);
> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
>  
>  	if (sev->snp_initialized) {
>  		/*
> @@ -2415,15 +2413,32 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
>  	if (ret)
>  		goto cleanup;
>  
> -	if (copy_to_user((void __user *)argp->data, data,
> -			 sizeof(struct sev_user_data_snp_status)))
> -		ret = -EFAULT;
> +	memcpy(status, data, sizeof(*status));
>  
>  cleanup:
>  	__free_pages(status_page, 0);
>  	return ret;
>  }
>  
> +static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
> +{
> +	struct sev_user_data_snp_status status;
> +	int ret;
> +
> +	if (!argp->data)
> +		return -EINVAL;
> +
> +	ret = __sev_do_snp_platform_status(&status, &argp->error);
> +	if (ret < 0)

Any non-zero value is an error, so this really should just be "if (ret)"

Thanks,
Tom

> +		return ret;
> +
> +	if (copy_to_user((void __user *)argp->data, &status,
> +			 sizeof(struct sev_user_data_snp_status)))
> +		ret = -EFAULT;
> +
> +	return ret;
> +}
> +
>  static int sev_ioctl_do_snp_commit(struct sev_issue_cmd *argp)
>  {
>  	struct sev_device *sev = psp_master->sev_data;

