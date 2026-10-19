Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012002.outbound.protection.outlook.com [52.101.48.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9802A60CDBF
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418615; cv=fail; b=GrVFbVPgutYHGOGwh6CYml6+l5NRf6cDTHRlsHkb1OsAcKnucjcu4lJ4MTUzttBVGoAfCfLs6BrSRhh49Gi3DSSSSAUO4vpkSLYq2XlMVT3OGc4gnaKg0epts4LA7gqm1Y1MaWyEarWZ3Nl2E9zuveGlogJMmTh4bzl0hj1MpuM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418615; c=relaxed/simple;
	bh=20w3UCDgW5SpOoUq9kLOiyxP4R7SKAw2PWwjNiAAW4c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WsjllfAN5ajfFlGY+jHmYKJyUHjBh26V6Tg0xFwMdL1iqx6Tsjrh5GAyihItB9NEaMBk82plmhjzDWOnLfLocMECQUqjDfilBTMlJY9T3My7DRceBaSTlx9RowsmDNTs3X9hgZdqIQjb9MZ7+bSJk7OSfo0MHwmZ9syTvelQM+4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AG/V/9+S; arc=fail smtp.client-ip=52.101.48.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AG/V/9+S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zJxeLCL87EF6PZs4KQHacnbq0WG0zVao/4NYwDXNnij5If5lweeFsOpOPhDH/lsvbe3+DRCuT3U6o69z9kLa3Mui6uA2/BLJMS8NVrsNBV+hB69ZvcGKQDugNHJp6Q9coX0NnsbYpQpSniZcmFKH7J5VbkexTot8rx/p7AZClPZo8zPGS3NGHQQfASzINZ78g5atyHdPK8MOMFVvPjBAyB0cQ11+shlHdyCYmiW3kkCBJPWUPs/B1k3Usd2pzMNcirnzXwyoWCwZGWu6lOy7tOusUPmsNuLALhieVgiYIWo81FhCY/yOdMmhWU0rBoumVAA+J9Mx4C+YdIJRzU8nJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+0iO7OULGuFjuWV865nDgUy+kj7KseGMBpepW6RcgI=;
 b=cKLTCcQTRg/26lQhYkRoCrdSLgUrJoP/WROQPFQtEFOU4SUzvO8LGpv4N1IyDG/6yxDP7365EFB5o/g1EDtb0oOE25tTF/fvorx65GS7NHvrcmunj8RG6blLX0B5JvF2DPljlZoUREwVOHd5pt2GwltPXyAmgjgdWF44ZlCq7tKxeD85/v1ZgyoG/oNkgPAuWNpA8dEB1IxBNHZmxt8/V3B+HolmsdpXZX0W9UM02XtzhSlxYW/xdgl/KhWno6rvlVDzriz7ucPglSIivzZWgSmALhPYLWL7TqhBWauFVKa6cibzWEZpujwfxJ31YvADue/2MVt63KaIYAr6G8CIHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+0iO7OULGuFjuWV865nDgUy+kj7KseGMBpepW6RcgI=;
 b=AG/V/9+SfwJsZZv7XJ7YKH4U19J3lX7H7N9ZD+6oeJW5ofhv9wvXFXlsZAhxy07q4hIm/iXilFFOaIJgycttuJX2msafpXaShmy9piSEvl26+kpCl/zXp6S7POLGp3wEw3QAFRHfPYhPx6XxsTR/zHK49tYe6w9tkE6bW/FP/Jw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by PH7PR12MB8594.namprd12.prod.outlook.com (2603:10b6:510:1b3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 14:03:28 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0522.017; Mon, 19 Oct 2026
 14:03:28 +0000
Message-ID: <22ffa7a3-99cb-4443-81df-79d58f6b35a8@amd.com>
Date: Mon, 19 Oct 2026 09:03:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] crypto: ccp - Use __free() handlers for
 __sev_do_snp_platform_status() allocations
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com
References: <20261016041109.1778673-1-michael.roth@amd.com>
 <20261016041109.1778673-9-michael.roth@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261016041109.1778673-9-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0100.namprd03.prod.outlook.com
 (2603:10b6:610:cd::15) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|PH7PR12MB8594:EE_
X-MS-Office365-Filtering-Correlation-Id: d5142dc8-841c-459e-bc7a-08df2de9bff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|261009223027099003|10067099003|56012099006|6133799003|22082099003|18002099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	vENx/yg+WEMYBr5Cwptd7JUdPp1Yzp0S/pxAtcMtil5JwpIYbzHem+IAPCg4hwJParwCYmBM7eJDVR95BdE7sH/2u+LZVpMumwvb3WbF/MSy/39ncUoBXORh4o3XP8n9YucuXl6YhC0THETCOgpZgvQqd1QtAoGkgNAp3QAgWhY+IA6Nq8AbFf1GV0Ylx1L6M0k/9KIp5YP3IAx/YMljVkA0hNKypJuiORs2lDkhl6ABnxi5kWKlp+QvT0IOPI9ZGkm7xPO6aTRJV3ochEJHwY3l+mmrMeoE1u2xg9UXt2/HPb3m/T6tKtRCbVd8cNm+37n9dB3ug8auSV0DvXX62r6c7U+TihIGhJJOI38okDuDP3dtuLCuu8Tr3YVEpsFFoRMixs4oMNr7IIQTzGCVO9PGcXTtoDjOVba/NV8UydxlsbjmR0lvBVq7CnXRMcSrNtp0DptWMwdexS4jPZ9NbuWev9gIb+MrdAFE/JmxjSy1VoqZFg+I/pa5HlZEHLJVDLCqt3KewtJtIqIjKWrgDCzcEJ18bmBBD7SN4HpOW7p6X/8ysl/AqsuZflw5BILchRZJQ1GT8YPFyMb5aUVtwv/Q4KCCVi19h2wTaIGiyFP+guU9UP0/HAlPacfe9EaYEIn/ck4rzwHn7xFxJUg0YDmTn40nIklQBksI/8vsv+8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(261009223027099003)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dys4YWtGRmh6bzBETkp2QklXdWx3d1djSWZhSi84QVVTcUxsakR6Si9LWGNQ?=
 =?utf-8?B?YTNyK004ek1GY1NUU2hINnpWc3lUNFN5RDF3SlViRW9RWWxhMGZBM2QyUFhZ?=
 =?utf-8?B?MUFNYW1FR1pkOTl1RkJrUUhnMFFMTU9keWZIbGU1cVF5ZFlEdFVHdmRlTGYv?=
 =?utf-8?B?blFQZEpZY2IzVmtTZ3RhWGM1Zm1UcER5SE94SUNSTDFiMng4cWxwUWRVbHgy?=
 =?utf-8?B?REIxTGZGK3JqQkJoOWV3Mm53ZkwwV3dkRTltSWV6OWdTcU5QZVJEZlowOFhO?=
 =?utf-8?B?SStzNjUrMlNzempTR3R6dnVhMkhwZWU4K2RXcmpEazh1eEZoYm9VdTNhS0V0?=
 =?utf-8?B?WVArWTFheFRSMnFTNS9iZWtuS1FQRnBUejdISzN6bFd0OHZyRkFKUEt1Zito?=
 =?utf-8?B?dG13VFlrbXgwcFRHS3ZnenFMaXdkYjZ6YnNGTTZMa3orSkxLLzJ0bitSU2tF?=
 =?utf-8?B?MzIzNGIxV0V5RU5kK2p0L3JDa0M5NDZyOFpxMmpDdUJJc2FDTDdwazBRTGpQ?=
 =?utf-8?B?RTc0SlJqWTRQOWYvWUhOT2IwZEUwWWl5SmN2R3l2c3piVklyY2YyNzc5OE9E?=
 =?utf-8?B?eTNKVFc0cHJRNTg4ZnI2Umc4ZTRuL1pGRzZ6Y1g3N1lYR3pSMjBEeFI2L2Nr?=
 =?utf-8?B?YmtYZjZQRFZsN1drVFkxbkpBcWtsYk81U2JoSjB4RUp4Z3d3SlA3b1BobDU3?=
 =?utf-8?B?cHVRaEdDZ2xNSEZmamxaczZLS0lwa0djL2tWK3l4dHp4RS93a1VmY3JDZjVs?=
 =?utf-8?B?Z2ZUa1JjV3RVVFJTazFaai9xSyttb2luMjdkK2NlejZ4bGpHcTgrbkVsSms5?=
 =?utf-8?B?a3g4SGhFbjQ0bFhGSnB2SllWenVQeEVZdlQ2YUw4K2dHZElka0EzUVJCVWx6?=
 =?utf-8?B?aG5uZGJtSlhBY0dUM2V5a3VlZXVHbk1CSFprU1M0Z3gySzQveXNuaE1TT2dE?=
 =?utf-8?B?ZnBSaFpnK1NRMnVKUW93c3lRMnRBZ3c2RWVNNFVWRTkvUnhQMXZLbXZPblI5?=
 =?utf-8?B?bC9adkN4d2ZCaU5jWlF2Nzc3aFJqbngyWW92dkp6NklrOXFKT05ORXpycGty?=
 =?utf-8?B?elJtWGgwNXFnbmtibVdYandqT3BTY0JxejF6aGh5bENyUVFBODdNYk9vL2lS?=
 =?utf-8?B?c3EyZnJRbVBBSlNtRWgxUGROY1A1NmNDeDIxQ0hoK0F0UjNES3d1aGpNNGE3?=
 =?utf-8?B?K1IrZ09xV0FudHd1aGdrTzBieU9VbUxQQTM5dnlMS1d1TXE0UW1nWGNJVXpw?=
 =?utf-8?B?YkRaQ0JXMHpsQnR1NEFaRUtUb1dxNEpmL3IrNXo1SU9qMytHK3o1R05uTHF4?=
 =?utf-8?B?WFl0L21pVVBQWGM2cHl0dk0vSDFPQ05FOU5NbnRXN29FQXJobS84MlN1WExM?=
 =?utf-8?B?SzBRWlc5Vk1wUk52dVA5N0REVHU1eGlKVHNVTnNoVDVmcVl3WjFpSkE4OWRk?=
 =?utf-8?B?c1NiQU1QM1ZUNUxCWnk5UmJoWW5sdmFhTG1OTDMvQW94YmloZTh4NHdDTkxj?=
 =?utf-8?B?YXVpOE1PZ2FzYnlsY2lqZVMyaE1lRTIxdXpXZFVXQ25NdDFtZis2MHRXWlA2?=
 =?utf-8?B?cmMvMWRQWE9ucnRWaXZzRjV0azk5UmZhc2ZnelYzQU9ocmtYQWY1c1hDTGht?=
 =?utf-8?B?OGZkRDBKc3AvMm9aa3dOa0c4cTJjTml0TUJPZ0lCdys2UisrbSt5Q2VqR2py?=
 =?utf-8?B?V05vL2pTalJWQ1lGVEt6RmZ2M1picndZSU43TjNxZ09vUTZ2SGQ2RlhPYURT?=
 =?utf-8?B?L0IwamtGcWRvSDlXaWgyQ1BkWUEyMGMrZzRBbGVpUXpadjZGS0NjWXpveXNI?=
 =?utf-8?B?am1tbUtlWG9ERW1lMDlZYXA5Uzh3bUk2WFEwSlNyWThLSk9kWWRGeGxOVG5D?=
 =?utf-8?B?QUFxMzdBU09oZndtODZEeUJMZEpXRUsyWU9ETGVuV09RYU0wU01PV1BBeDdu?=
 =?utf-8?B?Vk9QS0IvallZcjNBaWMxdXkxMERBOUY3c0RGQzJMMDZiN21GVHRSbXBBQ2Rh?=
 =?utf-8?B?bmhmeHdoNHpGaVlTWEpFQnZuWXRVVDVvNG0weWZNWjJvcms4eG5BV3VtbVA0?=
 =?utf-8?B?dWtOeTUvY2ZjNS9MYXE0WVMyQ1cvV0x2aS9Ydk5KZ3c1K2M4MlhQTUpnalh0?=
 =?utf-8?B?OThDbU9ZNGlybVJnNU5VR05JNHY0anpTcU1wNjQ3MU9meTRjWStheURKOThF?=
 =?utf-8?B?UllwU3JQWndmSkx5UEU5Z08zbTRkODJSSlAxU1A5ejFlc0tsTkxqb1dGYjg4?=
 =?utf-8?B?WU93ZDFQVWtKeFdYVEhXbWZidFZMQ3Fnd21vUllTZmNodkR4UHZyWXg0cUdi?=
 =?utf-8?Q?LIC2osLwSXcLR5arUo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5142dc8-841c-459e-bc7a-08df2de9bff2
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 14:03:28.2684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FDxEY/7l7b4qGYnEhZt2U+imRF/7mTLzpyC4DSgsqLzF2E2/8bVLceW0WRI0a+dZb5xy8k8rvMH5rdeRBftjEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8594

On 10/15/26 23:09, Michael Roth wrote:
> Make use of __free() handlers so that the related goto statements can be
> dropped. This is in preparation for switching over to using mutex
> guard()'s.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 27 ++++++++++-----------------
>  1 file changed, 10 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index aae0b15a10d9..1e017783dd03 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -2536,17 +2536,14 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>  					int *error)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> +	void *data __free(free_page) = NULL;
>  	struct sev_data_snp_addr buf;
> -	struct page *status_page;
> -	void *data;
>  	int ret;
>  
> -	status_page = alloc_page(GFP_KERNEL_ACCOUNT);
> -	if (!status_page)
> +	data = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> +	if (!data)
>  		return -ENOMEM;
>  
> -	data = page_address(status_page);
> -
>  	/*
>  	 * SNP_PLATFORM_STATUS can be executed in any SNP state. But if executed
>  	 * when SNP has been initialized, the status page must be firmware-owned.
> @@ -2556,10 +2553,8 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>  		 * Firmware expects the status page to be in Firmware state,
>  		 * otherwise it will report an error INVALID_PAGE_STATE.
>  		 */
> -		if (rmp_mark_pages_firmware(__pa(data), 1, true)) {
> -			ret = -EFAULT;
> -			goto cleanup;
> -		}
> +		if (rmp_mark_pages_firmware(__pa(data), 1, true))
> +			return -EFAULT;
>  	}
>  
>  	buf.address = __psp_pa(data);
> @@ -2571,17 +2566,15 @@ static int __sev_do_snp_platform_status(struct sev_user_data_snp_status *status,
>  		 * in Firmware state on failure. Use snp_reclaim_pages() to
>  		 * transition either case back to Hypervisor-owned state.
>  		 */
> -		if (snp_reclaim_pages(__pa(data), 1, true))
> +		if (snp_reclaim_pages(__pa(data), 1, true)) {
> +			data = NULL;
>  			return -EFAULT;
> +		}
>  	}
>  
> -	if (ret)
> -		goto cleanup;
> -
> -	memcpy(status, data, sizeof(*status));
> +	if (!ret)
> +		memcpy(status, data, sizeof(*status));
>  
> -cleanup:
> -	__free_pages(status_page, 0);
>  	return ret;
>  }
>  

