Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010060.outbound.protection.outlook.com [52.101.61.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F8F4399FF;
	Thu, 30 Jul 2026 15:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426633; cv=fail; b=ZoRMXjTvbb2IMXiNQjamQEi95DYXEIdtcA9rZabgu0TO8iUg07Lu26zLIYqZx7X8Ano+TBoGPSSPCLgN3Z6mK7nTjfrn1KrNPiKLK5sM13c7Wy3bnECg9V2v5CN2iHmNNgKG6ONqkB6/5lo8T8fIhdCM7WxAxKmjFnmkGDCAKmg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426633; c=relaxed/simple;
	bh=/4kTJPaZOjj8gAPo1cSbEgnHA2W9raSBC+j7VmrfyxQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BxQzCwt6RcLX3kAZcGqmz5D+srthjS6N8X74+eVJqPmQyQOcI08lijW+h0RyQePgGkKkpz/G7XcE9IQj/30YqNSyD3WYj+7ENS27CKXQ1jZf6ox40AtoCGe9AXQdAEwjmHCX3iIUZpexLtOh91ux/hUOjkC0NF6VrdCuKw/dDGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fa1rQrEZ; arc=fail smtp.client-ip=52.101.61.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fa1rQrEZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WfcMJiqPu8VdGQzamhvM1unpnuS9iCz2au8ZnSUUw+ryZEnxICV8rIBXZ8lEXKwA2DIkeN8DIpZqjWYpYeS+n2RSp3xaxbNpUyjFBBR2cYvDfoKIn8Grw+rgbF3u0Fz2THXohj9xqnatR5B21NyCAS2FC1RKpRNFdLVajh/kEv6AfmrteWQXXvazOQs8f6moOz0xEGQel56/fNJsxrBJmPe8CNBfhbJM0Ssb2sITbu6TyD+0bpOQc4J8YONMsCR8qX4bIwtNDqQlws23q+zarJ9z99p21BFLzx1MKboH2iagXyfN08SBH/Qq8QnusuffB9vdpyx4hXnibL4SgKWiig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDzwvQprgSVWrgrBCfcyhFtVpewi73ImBGWoSuYz77w=;
 b=fVJMww6pOtF9MHWpmrhEwNsn6sI3RKArBTzXcb8CW88XAJTWkeVZ7VMGtW3fTHu4JiQj8LKdMQz4QYalqYPAdpYY3LL7sXAwFUf9Unq025mPEH+gVMle7+sZsjIO4tp272gM9uuutXKONMpZ+SZSVHw9NrRr3jjuVBVvwGyI/BmGlx6P74wJae9GIEs0Pfi7GHF49szhKZ2ZNdNiYph9cXboKEUBNMiyDxoNWMHOJpvEt4jgnwFK5jic2h6IcBxyIhFDpvDGZWhWGtvsLJDmN1AYVvj4ZhK/LDfzQE1MYcIf7Rc2JHMAOIsPlLMAZD53E88pcykop1rBcvGg5Fa+ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDzwvQprgSVWrgrBCfcyhFtVpewi73ImBGWoSuYz77w=;
 b=fa1rQrEZoGgJwGrSHvqzFAaFT/UlMeCvp/3yEY/Ar95h2Sg2IR4C9zXcfDsDQfWN2MW312ussdN2lPc1gnzMxK7WIiDB3APqEeCN2JizxNFFfyv4zTxkcQ66TdCs5scitYwkTDPMoSXTq9cFaDXpalYlhBSzfxX14o5Pug/wW0E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by IA0PR12MB8648.namprd12.prod.outlook.com (2603:10b6:208:486::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 15:50:28 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 15:50:28 +0000
Message-ID: <b93d7af8-7214-4baf-a386-f730bc67fcf5@amd.com>
Date: Thu, 30 Jul 2026 10:50:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - don't abuse kernel-doc comment format
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Ashish Kalra <ashish.kalra@amd.com>, "Borislav Petkov (AMD)"
 <bp@alien8.de>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
References: <20260730051710.1412969-1-rdunlap@infradead.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260730051710.1412969-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:610:e4::15) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|IA0PR12MB8648:EE_
X-MS-Office365-Filtering-Correlation-Id: 143209f3-c170-46b8-b4eb-08deee5246ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	f2LxgOc9IbY4/OSY66IVv/yTrm0HKiyiA7UjmVJOlwnkkf6EhkcOixTCcIKjSvYWek13x3/ET9uYYWRhhDth5hZExtFC/N7lAfIznoDwA0miuOgGf97voeb5jREjuKAxCwmzx+dftvCrmIC2cunT4c9iid9J2njBlaf4GptFrhQalkl5yFnm5h7xyfiCV11b75uF2/415+RKBq2+HqUziU07zdEQvseOkRVk0C5KqQlpLNr+QrCIM5AnWIkssfl4zruUnsOf0I83Xsdu9lML/TbZKLA3YQZwGc2bKMYzky7aLrTj514EL3yIrhjN1g3wMdALR22jdYAyDbfBNbyelr6sj+woDVLeG4+wgl4TdDkCUaEMzOUcd9rBZIH1OYUfbX5ssMkx094djFj+GWfhkapT7vM6oeJdklVOmapvPVIo6X4FEicmoxY/EGB+1ssTlFlCq0ICHmZi995QTPxs2zCyfI5ZQk72lBA4fqUj6HB/w0iPO6fiQTft82FAaiuuszLh2UKa2lXXDdMaBC1aRJmlneDeJibnwh+vIV+1XyxQimsEPd4disD4cBuuQrbohSY+g3ISgX+ZZQffuzG9Kujh/vfBxrB/PzA2DoOdQ18=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VnJCbzBvVGxRZDMybUhoSWpEbzNIdGFPaVdlQi9WTG9LaklqYk0rZkJ5Yjdr?=
 =?utf-8?B?SldpTzJmUUo1UUd6SEV6WEZaTGNSbzBZUHR3Qy84WG04UUtka0o1SEFZNmxa?=
 =?utf-8?B?Vyt2Q25oSW9nV0RPbjh3Sm5VTisySlFiaVJNcFpXZlVBdjQza0krcksvbGxK?=
 =?utf-8?B?dTV4YkVXRUZtSnQ4a1FzRDVQS1h3VVhsWVY3eVVlckxnV010djFpbmh2ZUk1?=
 =?utf-8?B?eEZVODJLUFpUWG5XTk9JUTNkcHFKZjk0T3gvZG1ZdXlqcDZNTithbkxjSTly?=
 =?utf-8?B?cHkwTjJ0RzFMNzBGUkxzM2FUSVBNRmJmNlZwdGZMSTJ4TUY3Mk4vM3JTMHpC?=
 =?utf-8?B?a3ByeHRuS1JjNFpxUk5pNTRQaWxNT1ZuUElxU21hckdpZDFGQjhkeVRlRFor?=
 =?utf-8?B?ZVRXczdoWGRZNGtqZXZWRTlKNTd0YTQyM0NCTXJnbUlQOFJVdndock9uZDVz?=
 =?utf-8?B?bkF5ckR5YnVKd0dTejFJSGpHVTNLekVNRElZQTlnVVhlbWlpZU1aM001VmNt?=
 =?utf-8?B?RWNWQndNQncyTHBvUzZrV3JSTWZiZ09CTnV5cUdab2lSc3Q3WDdDdmMyQWVB?=
 =?utf-8?B?Z0tSQXhWWHlNeGx6Um5EeHhWcFBWNmt4SkVLdkpyKyt1bjZEdmQ3Y2UvZnJU?=
 =?utf-8?B?OW1qUGdMSmhOendocG5URkpPeDdHNnJyRGZXKzk5MHBzbklxL20vMitVRWJN?=
 =?utf-8?B?L1hGblpQOEY0RlM0bzVQZFRJRWVqcDF6VkhrS0xxT240ZlJ1bUUzUFdzN3dy?=
 =?utf-8?B?VElCeGRTSHlQeHYyaWk4NkVrb3BJSGU0c2VoSk93TmczN3RENXh6MWk5bmZt?=
 =?utf-8?B?Vmh2Qnliek1tQUZDWHYzeTZHblF3dEtKdHd0KzdYM3lNTzBNQ1cwdkNtTHVJ?=
 =?utf-8?B?WmFlazZNaXNZK2VYdWViaGtySXQ1ek9XVSt2L1lhWHdTa3N6QlA4ZmRUUERu?=
 =?utf-8?B?TzFUT3k1L0R3VzJQMUdWVGd2MC9ncEt3N2pLWmFiK3hOTVZhL2FUdkhwNkJY?=
 =?utf-8?B?NE1sTVV4Wk1EQXR0aTg2Vk10cE5kbVNxNzVINFNtdEhwbmxUbXI1dlpoanYv?=
 =?utf-8?B?RjZLNTY0NVNaUDYyZURUZkovSmVoZGRpMWhBQ1NST0FaS1hZM1hXSVU1K2Fr?=
 =?utf-8?B?WklaWXpCRXBHc3UrOUk2UmZScERoRmlVWGNLbGo0TVl3cllvYVhtOEtjY0lY?=
 =?utf-8?B?L1RkQ3ovUVB1T1Z3TnRGVWZHSUN0cWtnVnhHa2kyd2xRQ2t6aXZzVTVvNm5G?=
 =?utf-8?B?SGFTOTJlc2k4MVdQb3Raa1l1R0JFQ0ovWG41TXZZS3hCcElXODBrdEE3UXlp?=
 =?utf-8?B?anc1WHBGWkhkajZaOVZrQzRvZjVGQWgwZHd5UVBHL3ZmQmtOc1F0b1Q5UkVK?=
 =?utf-8?B?TTRVanNWSkdqS3JVVW1LSnl1M0xCdjIwai9rRlhUS1BCcERnbWZ5OGRDcnFF?=
 =?utf-8?B?NVJsVm1qNWxDR0paVWlkLzc0SU4vN3Q5ekZRUHZaY01xaDVBZnR2YkJGZ1NB?=
 =?utf-8?B?QVE0TnVUemw1enlCWnhVN2E3Qkl5V0NhVEtzRndvK3R6MVJPb3dEL0hKZ3FB?=
 =?utf-8?B?NTROWmk0cWMzNldycW1ibnhJd3lSYVEwS285Tmx0Zk40M0k1VEtMelo3ZUxF?=
 =?utf-8?B?U2pTSmExcGFrOHNHUmJrL3A1OTBjRjZXWU1oWjZJTGtNNnZIVFhxU25WMUxE?=
 =?utf-8?B?Y1VHci81M2gvY2RYL0lreXd5aGlLd3p4bUp5a3dyMTJCYjhBQS9nUVAzMTdy?=
 =?utf-8?B?L2F1eVhJU0VpcFBhMUw0dm5vL1d3bFBkaTBWMGhlb1VucGU2RzFXS2g0TTdn?=
 =?utf-8?B?OXRtcjJ4WlJkTjFtYVpXSSt2eU81U0FnY2Z2ZFJUYmZhZldxdzg2UjNIdml5?=
 =?utf-8?B?bk9KWnBBMHBWYmFlUnpGQVZkK1FSNU4xdytBN1B2MXRCdDBla292NjVhb2Zr?=
 =?utf-8?B?eDY3a005V1NpQlE5VkhleExVWmZZUGpKckJaQXVibExXTTVoZW82NEIvdlBs?=
 =?utf-8?B?bVJVTExVRXd3ZzdIYktjYTBSdlFjRldpc1hhaUJnOHQ0WWRHNUljeE1YVjNu?=
 =?utf-8?B?QmZqTExBbi9JaHZNR3ZQNTBlZ0FRRzNrZUFQSTBtQWRNK0lxR3ZqR0FnRk9Z?=
 =?utf-8?B?VGdraDI1dEhNb09ZWTBGYUQ3cFNlclk5ckxlNWoxSDRHSFg5MHFFVXRKWDNI?=
 =?utf-8?B?dThGWkNNOVlFYnBtRktDTXFLUnF2ZVlIOHVCdHczdGk0UDdpSFVaSUlvaDBP?=
 =?utf-8?B?d1hqVWt3bkgrR3lmT3p2OWh6Z1l2bXJhMitGL0Q5VmZzVE1PRjZuaTJldzhu?=
 =?utf-8?Q?WpWbL2ELdyEPe3lRRd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143209f3-c170-46b8-b4eb-08deee5246ca
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 15:50:27.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/fqTBwmn5eP9vtN22WWTqYrdJ6R+Ftz57bppFkGBSHrm/F8MWO53fCvfB1V2ZUeJU+hKvZ7P+7GATU2LGp1lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8648

On 7/30/26 00:17, Randy Dunlap wrote:
> Use plain C "/*" notation for comments that are not in kernel-doc format
> to avoid kernel-doc warnings:
> 
> Warning: include/uapi/linux/psp-sfs.h:18 expecting prototype for SFS().
>  Prototype was for PAYLOAD_NAME_SIZE() instead
> Warning: include/uapi/linux/psp-sfs.h:46 This comment starts with '/**',
>  but isn't a kernel-doc comment.
>  * Seamless Firmware Support (SFS) IOC
> 
> Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> Cc: Ashish Kalra <ashish.kalra@amd.com>
> Cc: Borislav Petkov (AMD) <bp@alien8.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> 
>  include/uapi/linux/psp-sfs.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20260729.orig/include/uapi/linux/psp-sfs.h
> +++ linux-next-20260729/include/uapi/linux/psp-sfs.h
> @@ -12,7 +12,7 @@
>  
>  #include <linux/types.h>
>  
> -/**
> +/*
>   * SFS: AMD Seamless Firmware Support (SFS) interface
>   */
>  
> @@ -43,7 +43,7 @@ struct sfs_user_update_package {
>  	__u32	sfs_extended_status;
>  } __packed;
>  
> -/**
> +/*
>   * Seamless Firmware Support (SFS) IOC
>   *
>   * possible return codes for all SFS IOCTLs:

