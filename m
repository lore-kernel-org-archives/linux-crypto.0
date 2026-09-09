Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010032.outbound.protection.outlook.com [52.101.56.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FED5650F4;
	Wed,  9 Sep 2026 15:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788968355; cv=fail; b=Bbf1xQjrQ9fxqOa5Mgp01zPvw2eBXgCuxmAdfYuvzY1Pq9BQAHZDUNLqyKEcuXE5NZbU7MoD2ojE9MWG8isk4gcHBzlHD9+X+3+uZXue/Yvv+zbgegfJ8nT7OlehJfZK3Hn5llCF7FygT1l8gcp69TjhqqnLF5lCpcxQZ2Prr7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788968355; c=relaxed/simple;
	bh=Ww57bbSN/4Btv/oN9QaOfvOt9zJuYgGVkejBJEjGusA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sBQiG7N+uI5ow0PXcZ6Zif6F7o6occ8FmGMP+EZHGw3g0qu3CAcfJDy8x+YyBGI4PZOFYnTjO7fyx9M7ntshOGqImovdAAoPbo4ExjCPwLpmvhZ/68F7OKSXLOouJeHBhs6sD0npZOTpuwd0HI5lrbcOylZaQhIn6G7seogVHYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PxjkV4zr; arc=fail smtp.client-ip=52.101.56.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PxjkV4zr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cP0Ii2xuMy14zUk5VjBxttwQza5YGZAqmZOj2hrVE9w0AE4ePJQnjI/rHYBk5rBoMEmwcZsWiPKAGA4TcmkYMc8BAEo6J+CO9/8xGhS48tVXSBy2Dv7/1t6Xs/pWBRb30LtdXSgmi7R0GkQJNEQZZxBNdSlKTPet/pLHJRer915EqvdQcVcLGvS8hl04w3xnr2Zhf7VfK+3iwYtcvLqsomoF+6PksSR1BhIQD/6j8b85CbJCcNmuL8V6onvEAIuWfQDzMHNUIwYT9UvrriAMFVoYcror08ugZ/A60N0KTqewsXE5YQdnAD6p1PCZR575PvyRta1OOQj/XTqDrwSZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uF0mknmLsOhxzvU/z1W/LvLXZ/ZEH4BDWT9ZILPiAEQ=;
 b=XbaaG0FI78sKugeQsLHJQQvE7iqY/CbS+ooNXDpROGVUKtVVIoMMKPDZZlw0cPTPOfO6WV212pjQhmq07KDxNS3Gq+JniTFB+1ewO0f/9rFBCsA3oWYHzw9lpH2VL0iDjzXa5H11dGqvIvNhsR6yNb2SvPjqHNVYUJ7/779/G8+PWym6hidqq5RW8HcKmjvUaQ3KiYUQhXLzTQnqngyA773kTGZFnl538m4GsLdAQ11eFF5MnTDJYY9FlVR7IcR5pEBFSUSHozBqxa4XzJ9E9iCtCL+EgmnKAKWoVlB2dZYklqGTEdA2foIpYIIFu0vZUHaRwOi2jLLLgoB1xVYvBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uF0mknmLsOhxzvU/z1W/LvLXZ/ZEH4BDWT9ZILPiAEQ=;
 b=PxjkV4zrL5fUy1/N4Iz8E7ldv3p9ElpcMj7L5JF/hwzyf1jyemj3unygMjeKfqDOZcbsv9JaJBUobJSDJeZ+QeByYwZ3fqhGJqCNGvuOjtON9nd5WfDxq5efWb9b4NmrsdC6gefgbn4FmtWd+lQyWizRItuF92vXxbuib9y8w0s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ2PR12MB8136.namprd12.prod.outlook.com (2603:10b6:a03:4f8::6)
 by CY0PR12MB708545.namprd12.prod.outlook.com (2603:10b6:930:130::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 15:39:11 +0000
Received: from SJ2PR12MB8136.namprd12.prod.outlook.com
 ([fe80::e5a6:6049:4f4c:afe2]) by SJ2PR12MB8136.namprd12.prod.outlook.com
 ([fe80::e5a6:6049:4f4c:afe2%6]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 15:39:11 +0000
Message-ID: <e99e34d6-c5d7-439e-965b-b0bef5951fee@amd.com>
Date: Wed, 9 Sep 2026 10:39:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp.h - repair all kernel-doc comments
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: John Allen <john.allen@amd.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 linux-crypto@vger.kernel.org
References: <20260901185438.31038-1-rdunlap@infradead.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260901185438.31038-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0043.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::12) To SJ2PR12MB8136.namprd12.prod.outlook.com
 (2603:10b6:a03:4f8::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8136:EE_|CY0PR12MB708545:EE_
X-MS-Office365-Filtering-Correlation-Id: a62fe8af-eb21-46e0-c5b8-08df0e887e65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|22082099003|18002099003|11063799006|5023799004|56012099006|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	vPpJ4IpeOHsdr2DSzsURbwEJA9sBOehoEA7RAK5vaXZHxG8rh6pnvcRCuesWLusiG4gCXKMDPZ88VOCDOzbtHlKTLVBoinId7A+2zUAhNzRMhFGNi+RUhfZv1yFyZhYMDfiQcgu4hjWekrVLN6Eowwhs9SXh6bOIpstZ/obFPjUCasoKj5IP5Qi0TvBcg49kp1osuV8DlDNu/jVPVpH8rgrGWY4d60lYQCgqyaV3/SUqoLyAQArBDpU77k/k3mjk1oDXaHk3r6dAOag1tAyhKjB6fQQn+N06BmCJj0SdDy53PqOF3rvvgp0nq83e4HjWEDc3fKJIhkRpiHMTG8zfjpIpJ3c0LxUayvW3OplQO/ESju92G1JnBUZ7cRLbpLaDUfkhAIGGsnSAK6fGAtYVN+rVTJ9LbM3P4kBlKZ+/IP6OZoCzKSo+DiJgvql/IwsU2BB6VH+ri9vgEC0ByBQPqRuMiGqTXgQz3U/krrFcxOhfQDFLcOmelbAWEt8cUJeiuMDSTdf4eL0id93SQguHGO4J5ovGyKK/XAsrbMEo4HgqIpLkVWXFiJvJVeR5SgkOHgKVqLScABjtcni6ByZ1FxhR0loLdiwx88MVWNVHf/g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8136.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(22082099003)(18002099003)(11063799006)(5023799004)(56012099006)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlI3eWN0RTVYRVFpaTB2UE5Sd0d6K1B4aFdCeXhHckVEN3lnVnN4UmE5U3ZK?=
 =?utf-8?B?Zm96cmxEZzY3bEdYUStSbzFVdTZPQ3pHQkNuQnYxVzZMZlRaQmhFY2ltNTZw?=
 =?utf-8?B?eGVTelA2QS9Gb3I2MzlJa2pmRDcxVlM4WnFWSWNzN2xydmE5MDIraWVBbzA5?=
 =?utf-8?B?aDhmSWl0YzV6Q3JyMjFRcEZQQ05KbXZWdkx3MVZNTkxMeE5zcXduMDVDdS9M?=
 =?utf-8?B?bTFLMXozeldka2t3cVNBV1hkMFkwNGtSV0ZxTFByMmJsSXplYlYyNVJGWnJx?=
 =?utf-8?B?QVRXTXhGb0ZMRXRJSzJRMnBpSGhieDVBd2EwTHVDNnEzbytnSWN6S3M2N3lk?=
 =?utf-8?B?aVRuNWhYY0dFUUc2cWdqQVdiTkpZWmROT1phWEowZGtIKytkNnZnWG51YUYy?=
 =?utf-8?B?VHlJdWhWTE41NXRIaDVnZ28xQXJvOVNTRnhMcGQzRHZIQlFNcUo2Vy9oeFls?=
 =?utf-8?B?elV1Q3NRV1lIR1BhYUxVVktsS1NoZkNrQm5rSWVvOUZGUUM1a3puVXE1aUR4?=
 =?utf-8?B?bzc1SGtha21HdGNGaVhjLzBJeFlLZ3loeGdGeEEzR0dGZFJGKyt1TzVXSHFB?=
 =?utf-8?B?T0hrLzhNV0c0L3hZTjl4bkp5OUhXcXYrUE9TN1Y5NjdPMXVDNmU1R3J3WlpP?=
 =?utf-8?B?RUcvR2ZpZDQyVE9Zenlhd2lhWVB2UCtSM2VCc2dSK2M4cFJHVmZGdUtmNjdZ?=
 =?utf-8?B?eVpnSjBIL21uR2VIeGVxYnVXQXE3UTVkL0hJZEpGK1hMYzczMjJGTCsvajlG?=
 =?utf-8?B?ZzJodngwQkVwM2ZFaE9PdW00RzBKTFV1SnZrMXJoRnE3NEFCU0Q0bFc4TnlU?=
 =?utf-8?B?S09BOXFYTjJweG5Obit6bTgxQ1RLdHFwY01JU0VMeFBHTy8xbW55cmtvRnhH?=
 =?utf-8?B?WXE2amd1SVRBaTlJOExFVVZWam41VDdoZWIvL2lmYlVFenlzV29JL0Q0SjFK?=
 =?utf-8?B?a0JFaWhCSDFtemgzRlEzNEpxeGtIcVk2dmJSM0dDTVByYTAyZmJIbGhacTZv?=
 =?utf-8?B?dU1FeTN0MFJGTjE2QitCTFBRV3A2OUdqaUpoQXFseFRMMW1YTFhxYUlTSXJw?=
 =?utf-8?B?dmVQYW5Ia0QyZTdQTXBkSjlxdExSdnhFVld0ckVQQlEyOVEyQnlpNkNGdnZp?=
 =?utf-8?B?cWVGR3hvUUJiTEU3S29kdk1leTh0cSt4SFVLUDhHK0w0MVovZStWaEVQVld3?=
 =?utf-8?B?alVjaTBUVGZsTm9peEx3RTJCbmlSVSt5MDNaemNoVnNKRnRxUXpVSTh1TVc4?=
 =?utf-8?B?SlBFYXBSdm80d1ljakNac3IzK1FsSWt0K1c4L0hOVUF5OEJPb3RUSjNPWEdZ?=
 =?utf-8?B?NXNpbnR2NFZid21KZzlJSFpuSGJTZjlZRnQ5VGlZQzRvRWs4Qk9LUUZBSlZP?=
 =?utf-8?B?blRRM2c1enlMeXRuQnMxQUhUR1E1cEExMHkwZUtuN0NWRWVBZFEwTnBLMU5m?=
 =?utf-8?B?V3lJcHJhTkdISFVvbHlHdzdsNk5CZ0VmRmFHQTdzeldDcXdLK1lscnFIdkZY?=
 =?utf-8?B?YnRnbzBWZC92eTYycDlqNk5iRFk3UTFDTUptZExscnNBbmpkTGc4d1BIbmFu?=
 =?utf-8?B?a2RvZGR5RlhiYXNiUjlYMFVaM2YxODJsSXFlNHhudUw3dXlGYlU2bGdPYWEy?=
 =?utf-8?B?RDFnS0xxQjk5SHByaE02cnpGK0F3ZEt4MURSWTlOVy9BWU00d3ltdnZqQTk1?=
 =?utf-8?B?OTEvZ00rQS9ua0RjNjcwalZaZERFQ0Q5Tm1keldJM2lKSlJsUVpUK0JPQmxu?=
 =?utf-8?B?MUFvYW53UWlPVjFPRjJiM0MzQnlhcXpMeHlYTjBWN2o4VEhaOE9VWEc3Yk9K?=
 =?utf-8?B?TTAzWXhib2hjVHFmUTYzSlNVUHFYNWV5OHE3eWNyNWJZODR0ZHJrcStJb3hQ?=
 =?utf-8?B?T0o5Qkt4aGhmOFA4T3VzN2VvcG55ZUMwcE1Yd3lnNVN3WDc3SHp0NXJXQ3hR?=
 =?utf-8?B?YjZDbzU1U2FOaERHYTR4T08vYkN2dzVLMGhKZStqdmJTNmp4L0lRVjVyazcx?=
 =?utf-8?B?UjZpa2t3S0hpQXdtZjJySk9nMnZsZ2U5TGZMZ2FqL3JYRmFXRjBUdDBsMzdm?=
 =?utf-8?B?SWFqeXExUElhb2hUYlM5Y1RFM0dMODhQelJocEZ0SzlYK2Z6dEJmbFk5TENl?=
 =?utf-8?B?UDZKdytDMVdZdmdOVjdyWTV4QUFJeDBCd2hFMU4zckpQSU9VRnJZNHExNll2?=
 =?utf-8?B?UWkvcFhLQ05MMG16bHVWSmNNOEpDYURVTWZvM1pqbXoxRUw4UG9UNy9pbzgv?=
 =?utf-8?B?UlEvUGpBVzh0SmFiVVRxMis2ZDZMUzlzUEZJYkt2clhrNmEvajhGSXRaM0w5?=
 =?utf-8?Q?1KhudHl9oPrUwc5RfN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a62fe8af-eb21-46e0-c5b8-08df0e887e65
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8136.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 15:39:11.1188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjwzGMkvoY9z/XppbFtbL7lboBUTJ6xVpZicYnGTl9QdD+EtXlXeiIZHWOfuNA9bNwvJSZ5ES3dVX8JiPGp5tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY0PR12MB708545

On 9/1/26 13:54, Randy Dunlap wrote:
> Eliminate all kernel-doc warnings in <linux/ccp.h>:
> - add Returns: for function return values
> - use the enum keyword when describing an enum in kernel-doc
> - add missing enum value descriptions
> - add or repair missing struct member descriptions
> - use nested struct notation as needed
> 
> Warning: include/linux/ccp.h:30 No description found for return value
>  of 'ccp_present'
> Warning: include/linux/ccp.h:42 No description found for return value
>  of 'ccp_version'
> Warning: include/linux/ccp.h:67 No description found for return value
>  of 'ccp_enqueue_cmd'
> Warning: include/linux/ccp.h:97 cannot understand function prototype:
>  'enum ccp_aes_type'
> Warning: include/linux/ccp.h:114 cannot understand function prototype:
>  'enum ccp_aes_mode'
> Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GHASH' not
>  described in enum 'ccp_aes_mode'
> Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GCTR' not
>  described in enum 'ccp_aes_mode'
> Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GCM' not
>  described in enum 'ccp_aes_mode'
> Warning: include/linux/ccp.h:128 Enum value 'CCP_AES_MODE_GMAC' not
>  described in enum 'ccp_aes_mode'
> Warning: include/linux/ccp.h:134 cannot understand function prototype:
>  'enum ccp_aes_action'
> Warning: include/linux/ccp.h:190 struct member 'authsize' not described
>  in 'ccp_aes_engine'
> Warning: include/linux/ccp.h:190 struct member 'aad_len' not described
>  in 'ccp_aes_engine'
> Warning: include/linux/ccp.h:202 cannot understand function prototype:
>  'enum ccp_xts_aes_unit_size'
> Warning: include/linux/ccp.h:245 struct member 'type' not described in
>  'ccp_xts_aes_engine'
> Warning: include/linux/ccp.h:255 cannot understand function prototype:
>  'enum ccp_sha_type'
> Warning: include/linux/ccp.h:394 cannot understand function prototype:
>  'enum ccp_passthru_bitwise'
> Warning: include/linux/ccp.h:410 cannot understand function prototype:
>  'enum ccp_passthru_byteswap'
> Warning: include/linux/ccp.h:472 struct member 'src_dma' not described
>  in 'ccp_passthru_nomap_engine'
> Warning: include/linux/ccp.h:472 struct member 'dst_dma' not described
>  in 'ccp_passthru_nomap_engine'
> Warning: include/linux/ccp.h:472 Excess struct member 'src' description in
>  'ccp_passthru_nomap_engine' (did you mean one of: 'src_len', 'src_dma')
> Warning: include/linux/ccp.h:472 Excess struct member 'dst' description in
>  'ccp_passthru_nomap_engine' (did you mean one of: 'dst_dma')
> Warning: include/linux/ccp.h:489 cannot understand function prototype:
>  'enum ccp_ecc_function'
> Warning: include/linux/ccp.h:587 struct member 'u' not described in
>  'ccp_ecc_engine'
> Warning: include/linux/ccp.h:587 Excess struct member 'mm' description in
>  'ccp_ecc_engine' (did you mean one of: 'u.mm')
> Warning: include/linux/ccp.h:587 Excess struct member 'pm' description in
>  'ccp_ecc_engine' (did you mean one of: 'u.pm')
> Warning: include/linux/ccp.h:602 cannot understand function prototype:
>  'enum ccp_engine'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> 
>  include/linux/ccp.h |   58 +++++++++++++++++++++++++++---------------
>  1 file changed, 38 insertions(+), 20 deletions(-)
> 
> --- linux-next-20260831.orig/include/linux/ccp.h
> +++ linux-next-20260831/include/linux/ccp.h
> @@ -26,7 +26,7 @@ struct ccp_cmd;
>  /**
>   * ccp_present - check if a CCP device is present
>   *
> - * Returns zero if a CCP device is present, -ENODEV otherwise.
> + * Returns: zero if a CCP device is present, -ENODEV otherwise.
>   */
>  int ccp_present(void);
>  
> @@ -38,7 +38,7 @@ int ccp_present(void);
>  /**
>   * ccp_version - get the version of the CCP
>   *
> - * Returns a positive version number, or zero if no CCP
> + * Returns: a positive version number, or zero if no CCP
>   */
>  unsigned int ccp_version(void);
>  
> @@ -61,9 +61,9 @@ unsigned int ccp_version(void);
>   * will be -EINPROGRESS. Any other "err" value during callback is
>   * the result of the operation.
>   *
> - * The cmd has been successfully queued if:
> - *   the return code is -EINPROGRESS or
> - *   the return code is -EBUSY and CCP_CMD_MAY_BACKLOG flag is set
> + * Returns: The cmd has been successfully queued if:
> + * * the return code is -EINPROGRESS or
> + * * the return code is -EBUSY and CCP_CMD_MAY_BACKLOG flag is set
>   */
>  int ccp_enqueue_cmd(struct ccp_cmd *cmd);
>  
> @@ -89,7 +89,7 @@ static inline int ccp_enqueue_cmd(struct
>  
>  /***** AES engine *****/
>  /**
> - * ccp_aes_type - AES key size
> + * enum ccp_aes_type - AES key size
>   *
>   * @CCP_AES_TYPE_128: 128-bit key
>   * @CCP_AES_TYPE_192: 192-bit key
> @@ -99,11 +99,12 @@ enum ccp_aes_type {
>  	CCP_AES_TYPE_128 = 0,
>  	CCP_AES_TYPE_192,
>  	CCP_AES_TYPE_256,
> +	/* private: */
>  	CCP_AES_TYPE__LAST,
>  };
>  
>  /**
> - * ccp_aes_mode - AES operation mode
> + * enum ccp_aes_mode - AES operation mode
>   *
>   * @CCP_AES_MODE_ECB: ECB mode
>   * @CCP_AES_MODE_CBC: CBC mode
> @@ -111,6 +112,10 @@ enum ccp_aes_type {
>   * @CCP_AES_MODE_CFB: CFB mode
>   * @CCP_AES_MODE_CTR: CTR mode
>   * @CCP_AES_MODE_CMAC: CMAC mode
> + * @CCP_AES_MODE_GHASH: GHASH mode
> + * @CCP_AES_MODE_GCTR: GCTR mode
> + * @CCP_AES_MODE_GCM: GCM mode
> + * @CCP_AES_MODE_GMAC: GMAC mode
>   */
>  enum ccp_aes_mode {
>  	CCP_AES_MODE_ECB = 0,
> @@ -123,11 +128,12 @@ enum ccp_aes_mode {
>  	CCP_AES_MODE_GCTR,
>  	CCP_AES_MODE_GCM,
>  	CCP_AES_MODE_GMAC,
> +	/* private: */
>  	CCP_AES_MODE__LAST,
>  };
>  
>  /**
> - * ccp_aes_mode - AES operation mode
> + * enum ccp_aes_action - AES operation mode
>   *
>   * @CCP_AES_ACTION_DECRYPT: AES decrypt operation
>   * @CCP_AES_ACTION_ENCRYPT: AES encrypt operation
> @@ -135,6 +141,7 @@ enum ccp_aes_mode {
>  enum ccp_aes_action {
>  	CCP_AES_ACTION_DECRYPT = 0,
>  	CCP_AES_ACTION_ENCRYPT,
> +	/* private: */
>  	CCP_AES_ACTION__LAST,
>  };
>  /* Overloaded field */
> @@ -146,6 +153,7 @@ enum ccp_aes_action {
>   * @type: AES operation key size
>   * @mode: AES operation mode
>   * @action: AES operation (decrypt/encrypt)
> + * @authsize: AES block request size
>   * @key: key to be used for this AES operation
>   * @key_len: length in bytes of key
>   * @iv: IV to be used for this AES operation
> @@ -156,6 +164,7 @@ enum ccp_aes_action {
>   * @cmac_final: indicates final operation when running in CMAC mode
>   * @cmac_key: K1/K2 key used in final CMAC operation
>   * @cmac_key_len: length in bytes of cmac_key
> + * @aad_len: length in bytes of Additional Authenticated Data
>   *
>   * Variables required to be set when calling ccp_enqueue_cmd():
>   *   - type, mode, action, key, key_len, src, dst, src_len
> @@ -192,7 +201,7 @@ struct ccp_aes_engine {
>  
>  /***** XTS-AES engine *****/
>  /**
> - * ccp_xts_aes_unit_size - XTS unit size
> + * enum ccp_xts_aes_unit_size - XTS unit size
>   *
>   * @CCP_XTS_AES_UNIT_SIZE_16: Unit size of 16 bytes
>   * @CCP_XTS_AES_UNIT_SIZE_512: Unit size of 512 bytes
> @@ -206,11 +215,13 @@ enum ccp_xts_aes_unit_size {
>  	CCP_XTS_AES_UNIT_SIZE_1024,
>  	CCP_XTS_AES_UNIT_SIZE_2048,
>  	CCP_XTS_AES_UNIT_SIZE_4096,
> +	/* private: */
>  	CCP_XTS_AES_UNIT_SIZE__LAST,
>  };
>  
>  /**
>   * struct ccp_xts_aes_engine - CCP XTS AES operation
> + * @type: ccp_aes_type - AES key size
>   * @action: AES operation (decrypt/encrypt)
>   * @unit_size: unit size of the XTS operation
>   * @key: key to be used for this XTS AES operation
> @@ -247,11 +258,13 @@ struct ccp_xts_aes_engine {
>  
>  /***** SHA engine *****/
>  /**
> - * ccp_sha_type - type of SHA operation
> + * enum ccp_sha_type - type of SHA operation
>   *
>   * @CCP_SHA_TYPE_1: SHA-1 operation
>   * @CCP_SHA_TYPE_224: SHA-224 operation
>   * @CCP_SHA_TYPE_256: SHA-256 operation
> + * @CCP_SHA_TYPE_384: SHA-384 operation
> + * @CCP_SHA_TYPE_512: SHA-512 operation
>   */
>  enum ccp_sha_type {
>  	CCP_SHA_TYPE_1 = 1,
> @@ -259,6 +272,7 @@ enum ccp_sha_type {
>  	CCP_SHA_TYPE_256,
>  	CCP_SHA_TYPE_384,
>  	CCP_SHA_TYPE_512,
> +	/* private: */
>  	CCP_SHA_TYPE__LAST,
>  };
>  
> @@ -384,7 +398,7 @@ struct ccp_rsa_engine {
>  
>  /***** Passthru engine *****/
>  /**
> - * ccp_passthru_bitwise - type of bitwise passthru operation
> + * enum ccp_passthru_bitwise - type of bitwise passthru operation
>   *
>   * @CCP_PASSTHRU_BITWISE_NOOP: no bitwise operation performed
>   * @CCP_PASSTHRU_BITWISE_AND: perform bitwise AND of src with mask
> @@ -398,11 +412,12 @@ enum ccp_passthru_bitwise {
>  	CCP_PASSTHRU_BITWISE_OR,
>  	CCP_PASSTHRU_BITWISE_XOR,
>  	CCP_PASSTHRU_BITWISE_MASK,
> +	/* private: */
>  	CCP_PASSTHRU_BITWISE__LAST,
>  };
>  
>  /**
> - * ccp_passthru_byteswap - type of byteswap passthru operation
> + * enum ccp_passthru_byteswap - type of byteswap passthru operation
>   *
>   * @CCP_PASSTHRU_BYTESWAP_NOOP: no byte swapping performed
>   * @CCP_PASSTHRU_BYTESWAP_32BIT: swap bytes within 32-bit words
> @@ -412,6 +427,7 @@ enum ccp_passthru_byteswap {
>  	CCP_PASSTHRU_BYTESWAP_NOOP = 0,
>  	CCP_PASSTHRU_BYTESWAP_32BIT,
>  	CCP_PASSTHRU_BYTESWAP_256BIT,
> +	/* private: */
>  	CCP_PASSTHRU_BYTESWAP__LAST,
>  };
>  
> @@ -450,8 +466,8 @@ struct ccp_passthru_engine {
>   * @byte_swap: byteswap operation to perform
>   * @mask: mask to be applied to data
>   * @mask_len: length in bytes of mask
> - * @src: data to be used for this operation
> - * @dst: data produced by this operation
> + * @src_dma: data to be used for this operation
> + * @dst_dma: data produced by this operation
>   * @src_len: length in bytes of data used for this operation
>   * @final: indicate final pass-through operation
>   *
> @@ -478,7 +494,7 @@ struct ccp_passthru_nomap_engine {
>  #define CCP_ECC_MAX_OUTPUTS	3
>  
>  /**
> - * ccp_ecc_function - type of ECC function
> + * enum ccp_ecc_function - type of ECC function
>   *
>   * @CCP_ECC_FUNCTION_MMUL_384BIT: 384-bit modular multiplication
>   * @CCP_ECC_FUNCTION_MADD_384BIT: 384-bit modular addition
> @@ -564,8 +580,9 @@ struct ccp_ecc_point_math {
>   * @function: ECC function to perform
>   * @mod: ECC modulus
>   * @mod_len: length in bytes of modulus
> - * @mm: module math parameters
> - * @pm: point math parameters
> + * @u: union for math parameters
> + * @u.mm: module math parameters
> + * @u.pm: point math parameters
>   * @ecc_result: result of the ECC operation
>   *
>   * Variables required to be set when calling ccp_enqueue_cmd():
> @@ -589,11 +606,11 @@ struct ccp_ecc_engine {
>  
>  
>  /**
> - * ccp_engine - CCP operation identifiers
> + * enum ccp_engine - CCP operation identifiers
>   *
>   * @CCP_ENGINE_AES: AES operation
> - * @CCP_ENGINE_XTS_AES: 128-bit XTS AES operation
> - * @CCP_ENGINE_RSVD1: unused
> + * @CCP_ENGINE_XTS_AES_128: 128-bit XTS AES operation
> + * @CCP_ENGINE_DES3: 3DES operation
>   * @CCP_ENGINE_SHA: SHA operation
>   * @CCP_ENGINE_RSA: RSA operation
>   * @CCP_ENGINE_PASSTHRU: pass-through operation
> @@ -609,6 +626,7 @@ enum ccp_engine {
>  	CCP_ENGINE_PASSTHRU,
>  	CCP_ENGINE_ZLIB_DECOMPRESS,
>  	CCP_ENGINE_ECC,
> +	/* private: */
>  	CCP_ENGINE__LAST,
>  };
>  

