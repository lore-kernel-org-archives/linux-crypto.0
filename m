Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C5710F1;
	Wed,  8 Apr 2026 13:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775654272; cv=fail; b=Uu4fK3Fv0BvWFOeKiMTtPKF6VaMrdtOX2yee9qQbMSw/yr4bVWsb1xHmZl7itgR1hT/GGiqVVEId51hv4Fizagyir8srlsgGXilYbmNLWKurh8asJg/qfbU90Uu6KVFA+OlB30emw/GehPJOeF6p40vEiasJ5Ft57ziKS1mTP38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775654272; c=relaxed/simple;
	bh=whURYJ7xH5SJ6wGQN/fvAlg2abKLYgpHcJ1kIE23iE8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vBY6Ku4y/aNZqt4LrqzbZ3VmKOCIMnjOhrb20NU49RhKJRKp3CbeYXEdHjQoRQBgSXkW03dIhFueFeSlS68Z7ZoEzqpgJc4l5btbGQyK09daGHGRY2ghWOmOvsh7yJcvoLLcXig3BUA7oks/x3YCoN+6DvswWd3nMEk6uk4vhIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ayEZZ/hJ; arc=fail smtp.client-ip=52.101.43.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ayEZZ/hJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uw5AebY/5OckzvdqulC2FjRCLpQGo7tNwf5tdb+zrybsogaBNh9DnUxwBitnLNWi5CjG7rC5R+a8kHYhKrGK5zCA+CKwlFaE3bFtLVr83e4kSlQZvif4IkVGgPSZf6mnkQk+irnntN9ypAuoXploSu3lsG881nW8oOcrEq7NK+nkSXhuWPu5A48elFOi4bYYKLFzueSLavCGdkMvZ+ZJpi4yTSclTbo25eP+DGyi7P/+Ti7tJSUq76qCTMmYywFU8RpgDfsNzGsflNm7ICijFAXsd1EcaBmPoOq2tdsPErj+vhEXxBPhptes7xTL/2zO0b7iH9YKuOpcT2h3ltOeIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZv2NZBwcOT5mP+2lGHFcsgea5rgBEdiIqzgyG9t04E=;
 b=kLLh3QN/QHPTDxPOEC6vuAOAKUsoYeEq4vjwrvVpvu6/edYAIlUZtK7nWPDlZ5DfwWIhrwmg4IThZWPgg0zq5qpY+PoZ5QeIaEYzDw4Od1vVEZpSJ1LYbTqOXavqS5vY68MEEuU8IOVbKbpgda/RbpV69wR4mGWhWpkmw5j7jzF0K/ZYwZaXlGCfV6hiKhVfLP00eBIwYqQwAB+2mLGRvu6cPzH7BH3SkuIVrTDfhXftbjYFuQgJ3O4lpnk4Ib7YsqpgDLckUBM2oD7CWK6G5WZzJZSJISZ+0F2zx4yLHXyA0JwKQx80aWHWQnanwqcZzpznmEdLmOhtjaK27LuoeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZv2NZBwcOT5mP+2lGHFcsgea5rgBEdiIqzgyG9t04E=;
 b=ayEZZ/hJB/ifDEWtvOaONuApOi/50bfwSVFYQFjR+o8LPSNgZMEB5XUNTOf48hhJnzwQ/dluSu7ReK/CItnDxI8VwO+kfS3czzLspstfWgQMflRUVn+mb5mCHXcu39EjrPDoUuxSYJEqyOJx9LrKNCv6axYvub+lfmLV1SH494Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM3PR12MB9349.namprd12.prod.outlook.com (2603:10b6:0:49::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Wed, 8 Apr
 2026 13:17:47 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9769.020; Wed, 8 Apr 2026
 13:17:47 +0000
Message-ID: <d4f82d48-6f80-4e19-afd8-6f3df5a6d267@amd.com>
Date: Wed, 8 Apr 2026 08:17:44 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] crypto/ccp: Skip SNP_INIT if preparation fails
To: Tycho Andersen <tycho@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Kishon Vijay Abraham I <kvijayab@amd.com>, Alexey Kardashevskiy
 <aik@amd.com>, Nikunj A Dadhania <nikunj@amd.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Kim Phillips <kim.phillips@amd.com>, Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20260407174713.439474-1-tycho@kernel.org>
 <20260407174713.439474-3-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260407174713.439474-3-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM3PR12MB9349:EE_
X-MS-Office365-Filtering-Correlation-Id: 40bb05ff-6c12-4e45-63a0-08de957139da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZF2lny9sfs1igKrGEoTcwhO94hTryL6JMj2r9K0vxIlvJdXGnkaylbb3s/QOiaiRsY07RVvODPPVT8fKnmRLDFBVtm1MYs3VabWVZEWYcYk4eTWfviND6b1Apw7YaGf1q7Jolb02LRUeT5S/9icLBFJNDpAGCyt9bboOwH9HVkY3n0dZdVrdFM6GKuTTMTke7eWslBW7Oqe7mzI5SoPx7l/BhLx90gOQ9LWFeS/nNGkLqcBqH5c6MA+sOV4+frr55jEOiONjGCml0CSzRVGDMgErxXD39pF5RGrNOxdv7nXH0in4d/kqnphLTVHP9L2NiVpiKvVv3rfSkk5vCshWM8lzdJIHcuWxgzdmEdbHdcGDGsyO/Vn7Yk0pgY8L6Q5kj/K4dvuGi4EbGKy+V4ETv14LArY9FrUVzTgVdSB5Nbpz7pDkfI49UWPuztRX9sJlLOYQznYsrUScHqScw/d9Q4JmkkQtceSRtUr8NFwot0mLyzcvLP9hXTwFaW52NYtmOrdRqLo2XB/HgPoh8TPPF90kFQ4aimQHHJDX3P4jfjzj7DonVmxZRRHkiJ/VBL4rfECe2bQOZIGeKA5xwRqQ0t6KfTOPnXkR8Klo1mC2v2ssG5If+AN7MpbNAPT/B3qardGZ1besLYgGZIlFCNVQ5f29CwWuUB0FOGuU/Ipe2ZeM2od6K/FphSyAuCXlUnUe3mtAffqJKtrVJvVCsW54BF2w9Y9KuuhbXCEqq243622xlWryxr62z/vUWZPqUn4+60RYNIXz25yNppna1OUW9g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVI1TXR5MXplRDU3MmJCMDh0cEFpbTlOT0UzekFNWGdrczFlb0M0d21UWE5m?=
 =?utf-8?B?MUZtNTVtQ2s2eEw1SkNYSnUwaG14S0dxNUZ2Z3QzOERHc004NTB3ei9kdTlt?=
 =?utf-8?B?OHljcWFuRCsvMUxHK1ZTb1RhREN5SDVBQ1RMQ2xTUVJPbDRkYW9MU2V1akRh?=
 =?utf-8?B?WHVBeHBaQWVUUjZtZU0rU0M2bFB1dy9IZTZEY29iZWgrZno0RytPSHd2RGE4?=
 =?utf-8?B?aXJKWnJkRnZMYUVJdG8wNVN2YjdQek81M3E0aFVQcEdyQkdjVnk5ZXV5Ujha?=
 =?utf-8?B?RUphL1hWaVE0aGhSNzdDZFMrWG9oaU9OdkF2Y2lFc1VvNWlLcDVEUzc0cUFh?=
 =?utf-8?B?czhwaUt3V2llOXZzcGlsRUlIclRVaWxRSXdRVGJROFB3V2JCb0FwcHNuc0pp?=
 =?utf-8?B?d0JWRE9DV3dndG1ZM3JwbmxySEtZRmlTWWhLNWxESW83WFJ4Sy9xdlJvK1BH?=
 =?utf-8?B?eFkwMFVIZDhyVXVYL0dGV2d3ZE5JalpwdSt5emNBK0VKQkF3bklMd2hHTzZP?=
 =?utf-8?B?c1FDQnRrTURLV3Z2bmYwcGJ0dWpsbTRYQ0UyN0ZkZVRHVGtZUUowQzN0TElj?=
 =?utf-8?B?OHNzU2FpK0ZyN1ZldG8zVVZKNFhNaGlwb1NtRCtOdVNNTTI1M1E3SkJnTWlH?=
 =?utf-8?B?SnBSTWFvbTkwaEIrNTJxVVV5ek5FOE5zVU9jZmVCbXRBcUx2T1pqQVd4aVdH?=
 =?utf-8?B?VmIyUStyL2IwM05PcGNFR1dPNFU5Lzc2d1lPUG1zL29KU1hZdGcraktOY2pv?=
 =?utf-8?B?TitlVXhDR0Y2UDd6a2V2RVlRL05FdDVac3lTRjh5MjYza0RnZlc1NnNuZGRz?=
 =?utf-8?B?bUFJRlFLZmFPMXJ4Rnk3MDd0eWxMTG9maUh2SjZGQUNSM0xFUDBIWEFtby9a?=
 =?utf-8?B?ZndseHBMVG44OS9kUGRIQXRsNGtUMzNKcHZXRkY3YVFQdUR1VTN2Wkt6TFB5?=
 =?utf-8?B?L1B4dnRsUzdIYTc4bk0rZGRERWN6dmFOTWtSMk9vOGVhVDN3ZmE5VGVDMEN4?=
 =?utf-8?B?TVZWUXlxNndoeVdmVmJQVlE4bk1YUDlzd3ZpUjJHNFZabmlsNExBU0hFVEtB?=
 =?utf-8?B?SnpsUDdTQ1VwY3YxeGY2N1AzNTBzZG9ha0t0cFlqQVNib21tRXZnYkV0d2tG?=
 =?utf-8?B?QTlqcml5VXpNT3FydEkyVjNZc2oxMENuNHZySjdIUDViTFBaVDF4VzZFbUwy?=
 =?utf-8?B?dk5Pd2Fxb21FY3gxc2hsNGt3U0Rjckl0N3JOVzhKYVdBd2ZkcU10Y09oQUxr?=
 =?utf-8?B?d011ZGdwTG81WTdDMnlUNnNmRzJTZWwxdnRZZHVqbU5hTWVsdFczR0puZlBr?=
 =?utf-8?B?bFJQZFhKK0l1eUtqTmdmSWdUeHdBUTloblgxbUNNQW5vZHZoM1ZIejQyYito?=
 =?utf-8?B?MTNWdWVvUmRuUzZyWXVxSjZHd3gvNkltVHAzdlprb085MkVyblV1aVFRbkpM?=
 =?utf-8?B?dkFJY0x6Qm44cEhudC9UeCttdDVIbHNwQXhMTjdCdWo4QjBXczd1SThZTENQ?=
 =?utf-8?B?Y0ZTazZnNlBsNUFXL0lPb3FNd3J1eVRnWlo1aTI3cHZwY1RrbWYvUmo0TC81?=
 =?utf-8?B?YjVMcGt3dElma0RVcEhGZFkxSXNsQ2NSaFlqYi9JaElqNmFjNVhZZ3VLTkZ2?=
 =?utf-8?B?SmR4aEVVUHh5dldxdng3Sm1kclc0MzNLQVdzQlRlUy90SVdsZ2RpMSt2eVBT?=
 =?utf-8?B?YzR6K0ZxNEk1UGJYbmVIQ0NtZHFWdGJvYU55eXRDVW9MN1BKYTVtdjRuYjd3?=
 =?utf-8?B?eVNaZjhSSVlKays3UDlCenFXSTlOM3ovVTFWVGU2NFFKcG5jZlJLSkJvSXZG?=
 =?utf-8?B?SmFpdnpEdURwMXE0M3ZqSDAzSVdZMlBVTTVjbXBZdXlYRkNVYThBNmVXeURh?=
 =?utf-8?B?OXZ0bk5PY1BCSFZOTGpKT1haM1NVV0RVY1hqNlhTMHJwUy9VQUNIZTRtZHJk?=
 =?utf-8?B?Y2pOOHc4L2FjMDRIZjdaYWlpSUl6bi9oZkVadFJ0Q0pkNHkxSzF1eWsydjF4?=
 =?utf-8?B?cThYOXh1akpORFFaY1BGSXVkaFhZdGNENW1WdlA2VlJyRFJ0UGxmZFZRYldn?=
 =?utf-8?B?V2VqRFJIM0VpVzcrekgrLzVZaXhPSzRwNVUrYXk5OTNhNnZ2bDhPaDY5aWZJ?=
 =?utf-8?B?ck5xMXhkWlh5NFF2NHFQSVBWR0Z4UWdyeVRGS0wzY2laeDY5RHBzVUN6QnQw?=
 =?utf-8?B?S2JxU0JSRHZZbHhiUGNYVU1XWVI1eUtzUm1qU21LNDBOb0RQS0dzR04zeXFi?=
 =?utf-8?B?S0UrK1p5NmNWcGdzTWNONFhtN1ZvOS9FeDlSVVIrTHNvUmxIZUtxU21YZHJQ?=
 =?utf-8?Q?eRnagffKnokEMdG0Ok?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40bb05ff-6c12-4e45-63a0-08de957139da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 13:17:46.9166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cYhYNUNS5fmwn0mDc3RF3s8F/01eUYWsGHcFspL2gOP3366m1DogRe+FlMA1LepaQLmef4NuvK4h4XSYI+SqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9349

On 4/7/26 12:47, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> During SNP_INIT, the firmware checks to see that the SNP enable bit is set
> on all CPUs. If snp_prepare() failed because not all CPUs were online,
> SNP_INIT will fail, so skip it.

This should probably be more generic and state that if snp_prepare()
fails for any reason then SNP_INIT will fail, so skip it.

> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 939fa8aa155c..854263cbb256 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1374,7 +1374,9 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	snp_prepare();
> +	rc = snp_prepare();
> +	if (rc < 0)

If we are expecting that success only ever returns 0, I would say this
should just be "if (rc)".

Thanks,
Tom

> +		return rc;
>  
>  	/*
>  	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list

