Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011049.outbound.protection.outlook.com [40.107.130.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B742FD68B
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773155536; cv=fail; b=AX+1uNZB0T2phtzTJHLGq38Lcdnb4bQqYTrVDFBjLnA4IvADYbt0iN9PjK9fbtXdOz4Sub1ULPSy5IcrZCtHnletB8PJLuLtSjQETBzTkiEJYLZD61HkDiLjMoMAcqvln2S1Y+Ad0pNbgQukp00zKW0VJGKd1+Ud0P5dPyrnBiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773155536; c=relaxed/simple;
	bh=AK+76HnN59iP0lCR3XhKpznZ8lQcA6UOL/ol82cm4Js=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U7XLzdYZOeuxitRe/LQbqw/Iy/1YZnwg9E+QZ6jqEmY9IuKOi/sVhlNQXA8RjV1lw8jJodwr/eCbIvvRg7HnsuQMdoNtzDvXoXEEh2AyddZKLEXE1tFfVRsxIcDfxmNHZFzMC91WriMRamGMFGwKmxsIOgt/CeBZjsRVbYP2YPw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b=nL573yRB; arc=fail smtp.client-ip=40.107.130.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nxp.com header.i=@nxp.com header.b="nL573yRB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vId5D8+vmtNKVCcK38OvCzkArw3vp4Yago+TnZRAu+jpihUobXr1xnw0bWJphcemU5UeUjQkR8cs/UYVGsira7X9iIIhrvVuCI+cZjyF1fhCRc5neN7wSiRnPfx3ymgCZWo/vDgZC/OBC1GpKedEyS5sJwMHyyuoJI0958rae5NKwg+cuTECM3nFoyKmHGYViwZ7+vfOmxqFzk2uKzzDrpN9ya+amMkqbSLcL2OzH4gLQ9nYsRmfh2pG78QXd9Ib7z1IEuwu9msUOeaBQv8wDsJePVbYLeC9ypB0azzVTR22YYV3CLih5Jw32dS+/dsFOcE/kTuM7uGJyiHVwPypJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bunbrMPkdwq9G6FgKxpGNoYCDJ+Cix0lA0/p4vumUsI=;
 b=VrqYCtNTqFo1wiAGHdsmGiD0pZ/785tAD7JSwafXCZQV1pQv5VSe8O1rtN7BlOVnw5sJx+iIE09FCngz5+Wbp5JzIkPfEPBECW74lqctCPqmrFKGWC/ppA1SM6nnm79uxLFPThZ73If6IKz4H16pBr4yt/BbUCUUzBpc8+NYtumEo3cOGgqqv/0ZvuJ/yIii03OZ2UCfay60/uUjYqDIMiAhUsQ32NQbjKg5TudvCUxIbc7RvV6vWssoUY/HwE98TKvN9242aAioEuptKlv6IOuWVtSVQCPZLh7Vo551RyfUHT/yoQeE9CVet7hoM1eCgmgJ45XZINhzk5i+REMDog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bunbrMPkdwq9G6FgKxpGNoYCDJ+Cix0lA0/p4vumUsI=;
 b=nL573yRBiVqXPAOvSvSoyHty4Lkkdd4JN+o7pYPf4r+kQW7dlx0uKB/TP2aVTjyT7fx/UNR3guZkLZnPYUB/TClWC8qd81mndnbRazkUwkchZEKsQAztsssyEaGfVO0VBKd1LooLk/y7/Ko98dIEv/5lMbV9/PID+Jt9/5SgtN5o8rOUqP0m9K4Az/QqnoKMbIWzs4jg3IaB6D1e/kUDOyV+uX5vhTabjcnPG0uBbFnxQGX3wqV1KY5wmycO0ikcfDmMofHiok5r6yGOkWFNCL9Re3ZDvX9y5MgS22IxayA4pO/N1F8WN8lQ7BVKt1P1gtdoTfvDeT6D+rJhMiSv3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI0PR04MB11990.eurprd04.prod.outlook.com
 (2603:10a6:800:31e::10) by DB9PR04MB9704.eurprd04.prod.outlook.com
 (2603:10a6:10:303::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.25; Tue, 10 Mar
 2026 15:12:12 +0000
Received: from VI0PR04MB11990.eurprd04.prod.outlook.com
 ([fe80::4e7a:8f03:1bfc:28dd]) by VI0PR04MB11990.eurprd04.prod.outlook.com
 ([fe80::4e7a:8f03:1bfc:28dd%5]) with mapi id 15.20.9678.024; Tue, 10 Mar 2026
 15:12:12 +0000
Message-ID: <d1bd8cf9-db43-4e36-869f-ecb953dd82e6@nxp.com>
Date: Tue, 10 Mar 2026 17:12:10 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: caam - Fix DMA corruption on long hmac keys
To: Herbert Xu <herbert@gondor.apana.org.au>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Pankaj Gupta <pankaj.gupta@nxp.com>, Gaurav Jain <gaurav.jain@nxp.com>
Cc: Paul Bunyan <pbunyan@redhat.com>
References: <aa6PaoYiz_BY1eZI@gondor.apana.org.au>
Content-Language: en-US
From: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
In-Reply-To: <aa6PaoYiz_BY1eZI@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ba::8) To VI0PR04MB11990.eurprd04.prod.outlook.com
 (2603:10a6:800:31e::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI0PR04MB11990:EE_|DB9PR04MB9704:EE_
X-MS-Office365-Filtering-Correlation-Id: 02892eff-0735-4311-5a08-08de7eb767ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|19092799006|366016|1800799024|376014|7053199007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	mRnDos8CmPixa6JZjb4O8erudEmxd0srUBgMNToL5fHlFM1BYAjvgcgm+CROgKxsklP3ro3U3w+hMf9O4w0p9/qXjS9FJ1XjVpCha8es/XGuXiNaRtHKjNeu5lwGMnN3+EAmemv0AjePwJnnlEoRfHLs7aSNZeiTpzbCIgvz0clrM/dS7B08gXhXBRb3Zlx6MFQ+Vyf+rZVL2I50W4hwIMS06hP+Zu84D8V4nfesBqprVzgbO5Fi9Yoqmt53CEB4QQWpxq7Yj76sDCHff88KS5+V7/qSkxCpEqRdoY13JS7sUerYqGgHvg5XKDStiXXBhl518rnDRQYXPhbL/bmBKBHVt7AimqkNsMOlVsORUjmHZEC29edCpVytvGwJkW2I7QC+nWcDYYDZC2sFXuBxtDHLPcFbbB41PX5DuVXrSWBKfffnShcGBWat+J8qduP7KMUhMJp60r3XKDq70idGZmUu3f6aifD26HuJPRM2Mee+ozl2OQCGHVinS1WOezuxMsZVWm1n6U7Loqet2gSGaUyJ9epu+ft3Lunl+YlpoN6mvjXk5Iwh41dzbC+iipME9CfG06z22WKd1HhzVEArwMqEYjrOC3U7NZ9uWxGjbrfA1xGQ8nrFouv7dHY4wUJBSwyEDya/aqbNFXD9SEOkNxfZD+eIf3hh2DPPrDPmhODacM2Pf1w5uGcra6kTfZEoxzds59O90O3qgbUNKq/mqGZSvo9ZMKwC39B1HGIAsto=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI0PR04MB11990.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(366016)(1800799024)(376014)(7053199007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NGdRT0VTRDk0YjlMRW1VNnZUc3lwSURHM0V3ZEQxMXgwRkZ5ekRFZUZCOTRO?=
 =?utf-8?B?d2lKVDk0enNFc3d2dDF5WWdoaHg3dFJTT1ZFSlNSbDAxR0UwK3Y5TGN1UExU?=
 =?utf-8?B?ekd6ZjJudmNJTHlxcHNoSXAvRTRXYjIwYy8ySEJqRzNwaHlrMC93KzhRWGNY?=
 =?utf-8?B?VkVVR21UVXUvSWI5cnFQNHIwK1RQNnZzMGIvSjBxeHl1dnl2V0hDcGxjTkNi?=
 =?utf-8?B?M2k1bUU4Z051Rkd3amtvRklhVE9jNWZGWWdnREg3d2pMTGI2K0lnTjlEVzNQ?=
 =?utf-8?B?VUxkZzBrY0k1YjQxY0dEeGlyTXlWSFRscjhZUk1jUVg1aTF1TEdDRGdLc05z?=
 =?utf-8?B?WXc1dlFUOHE4T1ZNaEk4elU0ckYvY3Z6a3VXZXlHK3pyUjUzRUtsTmJJcHpo?=
 =?utf-8?B?RlRTZzQ1c0F6MTBrKzhhcUxnMFR2SXFXV2FHYks5NVMrODJ1Rm9pVUZXTEtV?=
 =?utf-8?B?Q2xCVWgwUERuTWUrQnJnVDZ5R2FTUWl4eEY2dGdXWlRITXd3TW43dWl5TUZn?=
 =?utf-8?B?aHlKVHIrWC9uZWNCMGp6VUozajNIWThyaGNyWEZjZUhYNDhheXI4QXBwa0Rn?=
 =?utf-8?B?am5aSHorSnZmUWViZFZxSkhOTkxHRFRUYzFXTmRMR1BzektySVhsd1BaNVRG?=
 =?utf-8?B?ZG9RSVVTeDFzUTN6ZURMZkZ1bTF1cWsxMmxjOTlJNFVTdGljWWNVRGcwcUlG?=
 =?utf-8?B?Ulducy8wQVcwY21CK1NIenpBbkVnYkdWSVpxc2dOL3V1U2l6YzUxVDh2UG1j?=
 =?utf-8?B?YVZ5NFIyQkdmWlNvN2UwMDZKL21HazltYmhRYXNCSmhJT1JBb1RLaGRIalJn?=
 =?utf-8?B?aGRFZVlhZXpxd1I2SFRzNUg1OHdoY0tyQnBya08rdE5lU2t5TG1sUm82cmFB?=
 =?utf-8?B?Z2VZMFo2UDZCb0VmUW9jVzBmNnNhZGRIRFBieG13bC81MjdUSGxFd29rL29y?=
 =?utf-8?B?YVhZRU5WUEZZSGdNMHVobEoybFRpSysyYmpTQXRQbnkxUTYxWXE2MHlOZHEy?=
 =?utf-8?B?dVhybThJWVZjeTRuNndYMnQvZVdzdXh2Zkx3SnBhR1hrTm1kZlVjNGpLY0I2?=
 =?utf-8?B?bE00bmNIcnpqRjV3WERYd0NUeStTRnZkcVc1YnFRQkhET05rWUxvMldLeFln?=
 =?utf-8?B?NUkzcnZTQllBK00zZDlOcEdHUTBUMURBSzNOYVh3cUhJWERMWFFWSDBhc01o?=
 =?utf-8?B?YjBSemR3VEZHN2xFdzI3Ni92cTZycnJSMncrSTl0NDZBaFJ5UjJ0TkkxOU52?=
 =?utf-8?B?L0VMOUdseFNhazR2dzdBNU1VMlNSakYyVWRhZXpiZ21xRVFrSjl1bnFlbUc0?=
 =?utf-8?B?dk5IVUE1UHh2OWhxa1pMazUvUTF0dWRwbDljU3F0UXZJVTU3NVNuZC9td05S?=
 =?utf-8?B?eE5ZdDZnYzdiQ3l3dkhMVHhTTFR3K2lEeGM4YzUrVGhqaGE0WExybGNoemVI?=
 =?utf-8?B?RlRvN2JQZTBQanBpVTg5K21zNVpEK2xqaUFud1pBNXBpWFhvUEtnL0ovSGpZ?=
 =?utf-8?B?RWF6TEF6aUlNZGFaNDZibzVERm9zZEl1N2xRZytESHBRR29ldEdHdVRySTVj?=
 =?utf-8?B?NCtvWG5KRkU3ZzBVMU9zYTlnSk8way82anloelRkSkppelVTY3lXRGpIaGNi?=
 =?utf-8?B?b0hEQit3UmFTMGNSaHVDL21ydzJMV05VdEVtTndJVkZFTm12MWhXMzArM0F6?=
 =?utf-8?B?R2p6TW1vUUl3clV4MUs3RXd0VURHYlIxRFZwTDFoczd2VXFwSWcxWm42UUw4?=
 =?utf-8?B?WFM5WGJENllud1RQRDRJcEI3dzBhV0pTTWIvcHd1S3hheWx2V1diOFF4d29V?=
 =?utf-8?B?RUozcW4zOXd6VkpubUptajkrK1FWOThtRmtVMVdKTFE3RHlraU0yODJkNW1j?=
 =?utf-8?B?V3RFUC9KTTVnNS9ISG5vS1FvUmJnbUlyNUtlNzVYNEJGVGk0WGV3YzJFTnZs?=
 =?utf-8?B?UkNhODI0bVAwZGY0RFRYR1BoK3lpU0kweWVDQ1AzUkpvQ3pSZTBDdkZMMC91?=
 =?utf-8?B?MnNDVWg2NU12TjJ3TXNVN2o4MVJQOFl3VFBxUGNGZ2kxNzYvR3czOHdMelh6?=
 =?utf-8?B?am93K1FxWnpnWjREVnl0cVMwbXNyVnc1blhxbDRGeEhEVHRWUzVvSzgzSm44?=
 =?utf-8?B?SStxR3pjdVRjSmRuaDJ3ZldlaGlLWHV1RTNXaUVXVVdVZ0xTbjBkUVRkaU5z?=
 =?utf-8?B?NVdrVWlmSHJqVEpRaEl5K3FyYVNSTnRrb1k3NFBydnlXd2E5cU9YUjdYOSsw?=
 =?utf-8?B?SjJzNEFoM3lLWjlGbWZ0cnhGV0VjR0tOdWl4Q1VQcTFjZUZTbmlHd05sSllx?=
 =?utf-8?B?SlVSOUR1V2Vtcld0akFrc3FSbUZ6VUxxQ0VvU0ZZVUdYRnEvbUVFQT09?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02892eff-0735-4311-5a08-08de7eb767ac
X-MS-Exchange-CrossTenant-AuthSource: VI0PR04MB11990.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 15:12:11.9110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+2W10Ias86lJ+17rntwVN6z5NRk8CfRpUOh0L0pXsISbmOD2E9Xh2MGxvxIlzb1QdgGrGMrVVjvdKkXJjxVAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9704

On 3/9/2026 11:14 AM, Herbert Xu wrote:
> When a key longer than block size is supplied, it is copied and then
> hashed into the real key.  The memory allocated for the copy needs to
> be rounded to DMA cache alignment, as otherwise the hashed key may
> corrupt neighbouring memory.
>
> The rounding was performed, but never actually used for the allocation.
Thanks for catching this.
> Fix this by using the rounded value when calling kmemdup.
Unfortunately, kmemdup can't be used in this case.
>
> Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA alignment padding")
> Reported-by: Paul Bunyan <pbunyan@redhat.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
> index e0a23c55c10e..aded03c8601c 100644
> --- a/drivers/crypto/caam/caamhash.c
> +++ b/drivers/crypto/caam/caamhash.c
> @@ -441,7 +441,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
>   		if (aligned_len < keylen)
>   			return -EOVERFLOW;
>   
> -		hashed_key = kmemdup(key, keylen, GFP_KERNEL);
> +		hashed_key = kmemdup(key, aligned_len, GFP_KERNEL);

When aligned_len is bigger than keylen, kmemdup would go beyond the end 
of "key" buffer.

Looks like kzalloc + memcpy should be used instead of kmemdup.

Double checking the faulty commit, I've found the same pattern in 
ahash_setkey from drivers/crypto/caam/caamalg_qi2.c. Let me know if 
you'd send a fix for this or I should do it.

Thanks,
Horia

