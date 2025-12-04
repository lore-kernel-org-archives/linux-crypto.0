Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011010.outbound.protection.outlook.com [40.93.194.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F4F19D89E;
	Thu,  4 Dec 2025 00:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764808071; cv=fail; b=saNReZYWBP+WvZ0ooNEk8toZjhIzsIit7V2gM3hFoBVtiesPnjezKc5CoJAurLgRo6kxU+soNdTIY5rzim5fqOK8kAQIx+pgnaejmogm18r6IVzhjWyGoLrfcCAeP6xxX93fxKp531QYPof7oBxfKVsaJQdhHIjC577EpbZSFoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764808071; c=relaxed/simple;
	bh=WJyVVJlBfsDliZUCeGi3XmSWEfKLbGICicOQYyRN/3U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DzVqrsohV2LTZ4muEeaF7giEmjk6nblYllgZAwnOPsjSBE67xr9DqvlitlXaZIvczPpf+329iL3NUsqAbXcWLhvKcRKvCHnXwjNbB3A9EQlecpwy4fDIZBehFzjmuatY7cvmGzZBOUPKorNT41p6XGUARrkcdxI/Ta/fKEBNhDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qPFQlwaY; arc=fail smtp.client-ip=40.93.194.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qPFQlwaY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=URcvDpoFJrHeEA6GBvbe2oe8uhvKQKdoqx5KC8ywKfntWSs29v/GteBnnU+W8eAnvRsiTQJ8a7DJRjhCicFJTnLW9BVas/n3XySxsQc8aPOpkcWL1lDjrFH11GGvKXCRMuX79djEo6LierRu5oEcvn9Ijw75zQUxxbh++BVLdGSUjPlt4z+Uz757G1VuOD1t8/qUlBy6w4cjvUGAf7n1dNwnrO6KK5RtAv3wxd50aJIsRZ2dqL7BrfzLknqtknbkdUZs7q7vtk4xiDv0iziF7OsgzF4PmZCsyYjQY/dQkQs5Ewp4PKBwSWYBsYF1pf8qd/x6DjpEPb9VcGU+zXu7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxCBF49vmYCHXuQx+On4F25ws5qHz19EPC/tXm2DnBs=;
 b=HRCNGAuznZO/k1wHCobb3OvsKRBqKKV6sPcHr8bL6Kj8MkGBCKxTWEVMfaIKWovDPLzg//tKa9zGbr1a19Spu+DfvH8Sb00uG48mOCe8WE/dHZATF9Z+adF7xkLYomcREYi2mvYzDH/8kEIPk/05zPGTfCvqipAIMndZEOewQY4pM7OuQbJXt+EHTHoPGPGSOZ6psICYBvawFtELMaf1Vs8azQZP6ceDyndEz5Aao/i8jPmNUU8bjlPMvH5CCORRCTjOGAzw7Q79P0QWWUZSL9nU11C6pyR6sgsF/+xNSEENk/V7KiCkP6EUhRdHm106Kq0CZHys58QOnzfVeyvCFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxCBF49vmYCHXuQx+On4F25ws5qHz19EPC/tXm2DnBs=;
 b=qPFQlwaYa4twuepmR8VDyL2lOEIoYa/kmqvgtxaPrN39DV/MA2Vl2redFoS1dQv1m85oH8v8roMlDSzHAxCObXCHQjBILpVQ0AtSrMsM2cswSupq8YyW5MUaMzvyN3hJu8Jg0jfohvSiO0poag1K8gzGcpJxT0EA8/eGqO9MnW0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ0PR12MB7067.namprd12.prod.outlook.com (2603:10b6:a03:4ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Thu, 4 Dec
 2025 00:27:45 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9366.012; Thu, 4 Dec 2025
 00:27:45 +0000
Message-ID: <ec2106ad-deab-45a5-a0cf-66e7b15439c0@amd.com>
Date: Thu, 4 Dec 2025 11:27:31 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] crypto/ccp: Fix CONFIG_PCI=n build
To: Dan Williams <dan.j.williams@intel.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kernel test robot <lkp@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 John Allen <john.allen@amd.com>
References: <20251203031948.2471431-1-dan.j.williams@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20251203031948.2471431-1-dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0137.ausprd01.prod.outlook.com
 (2603:10c6:10:5::29) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ0PR12MB7067:EE_
X-MS-Office365-Filtering-Correlation-Id: 502dbfd1-cf03-40a5-4183-08de32cbf195
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZVpRYStIOEY5cEl0UnpLdjhqQjlCcWdnQ1dSczNLbHJYRlhFVC9NSWFoOXdv?=
 =?utf-8?B?emxTZlFkaTVTb1JzcEFTc0NTVU9SSmRwaHVQSFJJdnd3MCtoTXVnUGZnMHlJ?=
 =?utf-8?B?QU5PaE95NS9MZ2x2MXgyNDg5N3ZXM1ZLZ2NBbjVTbUcrZU85VFBaTkw3TWg3?=
 =?utf-8?B?UFYyalFsZFNCMk9yL3NjVmZQL0ovQWZYd1M2SHBEVEZERUMvanAvSm9OSm04?=
 =?utf-8?B?c3FvM0JrTllPUm5nRzF5V1lTVkpBeFIvN1drVFZrcHliZEsvelBjdXM4Zktv?=
 =?utf-8?B?R29zVDV4ZVVpR3lRRjA0UkZkSHB1MG1sOUNQVkYrU1daWlZaYnhVRzAxQ0h0?=
 =?utf-8?B?Nk9WRVlCYVZPTmZpd2pYZnhLTVNzUUpzN05zT252MkRadkF5bUlmbitwSjFm?=
 =?utf-8?B?Q1FNaGJsckJydDFBMVg2TUJUakRmR0M5U3pPTUpNSW1DdFNodndyUUdHT1pX?=
 =?utf-8?B?SE16VElGcWl5azd2bUFUeHhyQ3dsUXdQZlROMlJmUW9xZzJ1cEZyOGFJSDNq?=
 =?utf-8?B?V2FXcndmTnpxS2FhVlcvVHNBbXVFazFVeUdUb0hBUktQM093cFEvanlvOE5a?=
 =?utf-8?B?ZkFpTzBtVXgwckpsM1J4ZzdkZkVTVlJYTFovT1ArTTBXZ0NZWWhPeU1OczA2?=
 =?utf-8?B?Ykd2VE9GeXVCcVAyaUNDYWUxVEpQQlZmd1ZiK2pWQnN2QlhRVDRxRUsvTFht?=
 =?utf-8?B?WWdlUkhzaVgrb3p1WmQ0czYyaFBkeDQyRzhVSUJsUncxNzZaeUZ3SHBRM0th?=
 =?utf-8?B?aC8wZ2duNENiVVVnRXBIdnUvWngraWp3cldRYmtkamNOS0RTcHdLMTNEd3Jx?=
 =?utf-8?B?T2dYTXd1eDdQNHhWR0QzMWZKbVFEUU10UTNTeFNrS2JZVUdTMHk3ZTYyVlla?=
 =?utf-8?B?YnFIY1hKZVpWQUxkVWJ0clhsK3I1a1BqRmdFS0Vjb1lUUGhoZkUyVmVOYnJ6?=
 =?utf-8?B?dFpDblFqdVFJRW5KSnI0SHRtR0ZNWUtuL0FFcXdOdDUzb0RxdHZJVVJxWjB2?=
 =?utf-8?B?UU5qYVhtcklTRkFFWm4vSnVEaGt0OGZuNGh1RVErWG9TZ2FHZDlOWmo2ZHg4?=
 =?utf-8?B?SkcvZno3N21rUHQydFBBZEhrbFBlWjdseWN4Q1FhOXNjNVNlQjc1cldZUnZ5?=
 =?utf-8?B?clNiNlBSa1h0RHRkVHk2YWozR1FBZ2FsbTQxNlJYUnFYQWo1d2tzTjk4bmtm?=
 =?utf-8?B?cUwySS9TamEzSnVNT2RWMkZSZjdKNVJqd1JCYXhBZzkzemVkakM4S0R6N0k4?=
 =?utf-8?B?MnBmNnNJMXYvbjhvVHNCeCt2UUVJSFVJYlVuVXBwU3JzMVRLQ29Sc2ZxMUpk?=
 =?utf-8?B?M3BQVVZLU3UwR1AvZ1Q2Ym11Vk8zNkpndkZ4cGthcDlTM3o1VUVEMUYwajJy?=
 =?utf-8?B?SmpGMTRXcnV0aHp4QXJUTlZyczNoNHorSytMeXFsWWpGK0t3TzNDZ0NRcDVC?=
 =?utf-8?B?QnY0UDNKRzhEQVgrT3I4RHU5Z3lMbkFuTERmMDg1UHJRT0wxQ05zaWRZSElC?=
 =?utf-8?B?ZXlWanRLdEZRQjMvZ2d6cnJ5QXRnOXlUY0t5UE5hNFQ5NE9KMUs3cjZQdEF0?=
 =?utf-8?B?T1JNZnEzUGRjQWg4MTk1bm4xaU5yK0NsVEt2L3JTcmpPVFE0Njd4dWVYejJj?=
 =?utf-8?B?N2pML0ZJUE50Q1dIYkJYdVpLNGhXTjYwcEUvR096QUlTNWd3Q2tLZkt2QVM4?=
 =?utf-8?B?TFJQU091TEZnY0NiSWI3b2tCV295eEdQcDN3RHZ5N3pxZ29waUF2aVZUOC9H?=
 =?utf-8?B?Zk1jenBObkRIQnZlMnptaWVBVkZieWViUlBSUHByS2FvNmZTN3VrRkRBaHdm?=
 =?utf-8?B?S1hnb2gzT29BbnVPYWVUTmljc3lrQUdDNVlEYU9jU3NkQ2hjMUVRclRERlFo?=
 =?utf-8?B?NkladmxrY0tqNVhQRUEwUk1oclRVbmhxOFl6WWNxeWkvbzd6RnRPUEF3dXFV?=
 =?utf-8?B?Q01LWkdIc0ZuZFU2aXBGMGhFYXJjbGdHbkw2QWNXU0dGb1E2UGUxWXpPcEhz?=
 =?utf-8?B?eTlydVNuTWRBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzBzZlVTQ3Jzdm1MY3lZZHkwZnN0U1M0V2VpSlhJSVVqSnRkanJtOVRJVTVD?=
 =?utf-8?B?b2J4STZwQUlVQllUdEFEY3lQSjF0dng1akk1d25qQ0MwOTlsOXh1eVVDMWxD?=
 =?utf-8?B?UUQzbEhJYnllZHVtUnRaWDZ3L1RESER2MDJETmZwaWRqRWp6cEZwM0RncG9t?=
 =?utf-8?B?a2JXNVNDcVVvYXhjODlXM1k0RnZpVlZhRDlES1JQeTF5bzZoUHhBTHkxVlBS?=
 =?utf-8?B?bW50anV2ODg0S2ppRzFKU1ZDa3hSdTEzZlk3QjdsZkVKMXk1UndhdGoyNlY5?=
 =?utf-8?B?VkpZaWJzcEVOcVB6ZTkyTGJoMFN5M3MvK0RtNjAxbEQ3aU5VQkhOaUtnN2V0?=
 =?utf-8?B?TkZlKzV3Sk5zQTl1NnlvYTc5ZENaTTQydTRzVXN5bHVqdGYzZFIwZEhnMGts?=
 =?utf-8?B?UWxzSWtkaE9va3V3RXd4RXZ3MFJLNkZGU1YxZWNST0JVczlvVFRWWnh0eVh1?=
 =?utf-8?B?WS9GUmxKMHpWM1lraHVIM0RaZnVKYUFUR0pNT2ozUm5PWVRTL1Q5Mk1LREh1?=
 =?utf-8?B?K1BhSmhNV0gydldiNGVUa0Fqd21CYncrd2xBQVF5ejF2U1haakZuSkh1aWhT?=
 =?utf-8?B?cEh0U3ZRU1g2Vy8zN09IemlqZU9BQUtqVU9uYWZLSlFWOU1Xbk5RSllGWndM?=
 =?utf-8?B?RkhMb3pCQm85N01HUjc3YzVqZGZRejhJOEk3M3ZhVFYva2s5OHVRczJ4cmZO?=
 =?utf-8?B?azlSQzlzbXlHR2lDcHVFODR2eWJ0VHpqaVk2UDF3WVdRVlNwZXRhUWY3c2J0?=
 =?utf-8?B?TDE1Mzd4LzBDU043ajBFMW1OR1NFOWh4TUhJYVFDcXJuemYvVEduTzdPWmdM?=
 =?utf-8?B?QjlMUlpqR0tiT3NhWkt4a3l0N2c5TElWY0lqOTI5NFlaaDZaWk1IU1J6S0JP?=
 =?utf-8?B?aCtUL05TWG5hWE1ocTJwdUd5bUFIdGVxUXNldlF2dGFZTllUVWZRUDJWUkhy?=
 =?utf-8?B?RWRzYVRpMjROb3R6MHZYRDNlZ2VRdGhadEc0SXVZS0JKd0pGeElocXREVnF2?=
 =?utf-8?B?ZExxcVVXWTBPY3FFcnVGTk5OM2gzVlFBcWNHVjNsTFRrVStZZFJiSGEvY2h1?=
 =?utf-8?B?ZTlZelFZeDZJZFRiSHVLazRWbmVjalFhdThFOXBvKzk3clU5NG16MXpEUTRv?=
 =?utf-8?B?K0RJRnZUSEV6MDE4Z3V6MDJRMEJ3V255SENLRkNqdWhxUi9aVExIdk0zLzdj?=
 =?utf-8?B?K29zcy9rYjNMUDVYWktra29KREY4djNENzFuc0hmM1d5dGxUb0NlVkcxV0c4?=
 =?utf-8?B?UEdLN0R2ZXpvaUlhWXJiZmZaYUxXKzNUak5YZUJlSEtQL3NvbFQwNnBEbXYw?=
 =?utf-8?B?dWVrTzhpc1ZjMi80SmZHMEUrUlVRbjI2a1RpVm5BKytVNVdlcGtWNFVqRzg0?=
 =?utf-8?B?Qm5ScnpOVzU4clU4dTVmRXk5OVk3WFB0aDNoT25hVXd1UXVsVjdzTXJGN0I5?=
 =?utf-8?B?UXJSUkFSeUdBNERKNmFEZ0J0WERUYWtXOHRzdnZUMXFSZVJiYnJoVVhPSVNW?=
 =?utf-8?B?YXlYQ1BNUmg0OGpuUUhEZzNsc2pQbkRoNVJuQmtXZVowRE9iaTNoYzJqZ3FY?=
 =?utf-8?B?WGp3VWVUSS93TDFKalZZdVQ5RFZKYkg4dlpkeU4rNnRWdjc1VURNNU9xSzNv?=
 =?utf-8?B?MXdPS2pESG14azFEcm9CQWo5aXdnNzhtRHM3RVdYWTZzYkdMeFIralJlQ1Nw?=
 =?utf-8?B?ZXRqSGI0N0ZBdzl3bS9wYkJTdjdZbTArTWg4UjhuVk0xZGFNWlNaNHI2ZEdH?=
 =?utf-8?B?UG5XRU53bUF2ekt4Q2dwRXRSUzVESmZTaEJLWXVib2VnUHRFWUM2RDFvNVpu?=
 =?utf-8?B?VEtPUE9rdTQ2ejV0WVBYV1UyMUNwcmFCcDRYL3ZJbHd1NTJGaGFIMVV0SnhK?=
 =?utf-8?B?QmJVSlBQQWl0TjNYaFBDbytpaVVhZE8velYrTllRYXlrdENzV3czWTdhS1I3?=
 =?utf-8?B?TUNkdTBXdDFGdmJuUVZucm9rVFBXTm5VRlNZcGRCaHRFSlRFL2wyYXR4NUhu?=
 =?utf-8?B?cExqZiszV2RIbXNOTUkwN1hmWW5EVTlIcTI0dy8rSy83SkVTYVJ1WFZxTGhT?=
 =?utf-8?B?RVZKaGVTVGxYOWtjUjVUU2FHcGp2N01QYnprOEFvckg4MzVQSUdmdEU5ODlk?=
 =?utf-8?Q?5zpvPsn0n99az/YxqkCvX5b9o?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 502dbfd1-cf03-40a5-4183-08de32cbf195
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 00:27:45.0338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s9xUNs326GxoKFfk77kEfGoRIZKzoeBLGOloxjTnT9Ywzsf6568+F8SwDlHYS50VwjjMdY44fT7L1KOfH2/kig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7067



On 3/12/25 14:19, Dan Williams wrote:
> It turns out that the PCI driver for ccp is unconditionally built into the
> kernel in the CONFIG_PCI=y case. This means that the new SEV-TIO support
> needs an explicit dependency on PCI to avoid build errors when
> CONFIG_CRYPTO_DEV_SP_PSP=y and CONFIG_PCI=n.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: http://lore.kernel.org/202512030743.6pVPA4sx-lkp@intel.com
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: John Allen <john.allen@amd.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>   drivers/crypto/ccp/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index e2b127f0986b..f16a0f611317 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -39,7 +39,7 @@ config CRYPTO_DEV_SP_PSP
>   	bool "Platform Security Processor (PSP) device"
>   	default y
>   	depends on CRYPTO_DEV_CCP_DD && X86_64 && AMD_IOMMU
> -	select PCI_TSM
> +	select PCI_TSM if PCI

Acked-by: Alexey Kardashevskiy <aik@amd.com>

>   	help
>   	 Provide support for the AMD Platform Security Processor (PSP).
>   	 The PSP is a dedicated processor that provides support for key
> 
> base-commit: f7ae6d4ec6520a901787cbab273983e96d8516da
> prerequisite-patch-id: 085ed7fc143cfcfd0418527cfad03db88d4b64ec
> prerequisite-patch-id: c1d1a6d802b3b4bfffb9f45fc5ac6a9a1b5e361d
> prerequisite-patch-id: 44c6ea6fb683418ae67ff3efdb0c07fda013e6b2
> prerequisite-patch-id: 407daf59d54ecebcb7fefd22a5b5833e03c038e4

oh it can do this too now, cool :) Thanks,


-- 
Alexey

